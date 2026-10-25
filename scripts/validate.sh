#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

failed=0
checked=0

# —— 参数：--privacy 开启已跟踪文件的内容级隐私扫描（见 scripts/privacy-scan.rb）
privacy=0
for arg in "$@"; do
  case "$arg" in
    --privacy) privacy=1 ;;
    *) ;;
  esac
done

# —— 外部命令缺失必须显式 FAIL（计入退出码），绝不允许静默跳过某项检查。
for cmd in git ruby find grep; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    printf 'FAIL  missing external command: %s\n' "$cmd" >&2
    failed=1
  fi
done

# —— 扫描根必须存在，且 find 的退出码不能被吞掉。
# 反例：`done < <(find skills projects integrations ...)` 里进程替换丢弃 find 的退出码，
# 目录缺失时 find 已经报错，但循环照常结束、脚本仍 exit 0 —— 扫描范围缩水却仍然 PASS。
scan_roots=(skills projects integrations)
for root in "${scan_roots[@]}"; do
  if [[ ! -d "$root" ]]; then
    printf 'FAIL  missing scan root: %s\n' "$root" >&2
    failed=1
  fi
done

scan_list="$(mktemp)"
if ! find "${scan_roots[@]}" -name SKILL.md -print0 2>/dev/null | sort -z >"$scan_list"; then
  printf 'FAIL  skill discovery failed: find exited non-zero\n' >&2
  failed=1
fi

while IFS= read -r -d '' skill_file; do
  checked=$((checked + 1))
  if ! ruby - "$skill_file" <<'RUBY'
path = ARGV.fetch(0)
lines = File.readlines(path, encoding: 'UTF-8')
abort "missing opening frontmatter" unless lines.first&.strip == '---'
ending = lines[1..]&.find_index { |line| line.strip == '---' }
abort "missing closing frontmatter" unless ending
frontmatter = lines[1, ending]
abort "missing name" unless frontmatter.any? { |line| line.match?(/^name:\s*\S/) }
abort "missing description" unless frontmatter.any? { |line| line.match?(/^description:\s*\S/) }
RUBY
  then
    printf 'FAIL  %s\n' "$skill_file" >&2
    failed=1
  fi
done <"$scan_list"
rm -f "$scan_list"

for platform_root in \
  skills/codex \
  skills/deepseek-harness/skills \
  skills/claude-code/skills; do
  if [[ ! -d "$platform_root" ]]; then
    printf 'FAIL  missing platform root: %s\n' "$platform_root" >&2
    failed=1
  fi
done

core_skills=(
  himice-advance-fund-application-process
  himice-budget-process
  himice-officecli
  himice-operating-expense-reimbursement-process
  himice-vibevoice
)

for platform_root in \
  skills/codex \
  skills/deepseek-harness/skills \
  skills/claude-code/skills; do
  for skill_id in "${core_skills[@]}"; do
    if [[ ! -f "${platform_root}/${skill_id}/SKILL.md" ]]; then
      printf 'FAIL  missing %s in %s\n' "$skill_id" "$platform_root" >&2
      failed=1
    fi
  done
done

for skill_dir in skills/codex/*; do
  [[ -d "$skill_dir" ]] || continue
  ui_file="${skill_dir}/agents/openai.yaml"
  if [[ ! -f "$ui_file" ]]; then
    printf 'FAIL  missing Codex UI metadata: %s\n' "$ui_file" >&2
    failed=1
    continue
  fi
  if ! ruby -ryaml -e 'value = YAML.load_file(ARGV.fetch(0)); abort "not a YAML mapping" unless value.is_a?(Hash)' "$ui_file"; then
    printf 'FAIL  invalid Codex UI metadata: %s\n' "$ui_file" >&2
    failed=1
  fi
done

# rg 缺失时回退 grep（同事机器不必装 ripgrep）；两者都缺则显式 FAIL，不静默跳过。
search_tool=""
for t in rg grep; do
  if command -v "$t" >/dev/null 2>&1; then
    search_tool="$t"
    break
  fi
done
if [[ -z "$search_tool" ]]; then
  printf 'FAIL  no regex search tool (rg or grep) available for config-leak check.\n' >&2
  failed=1
else
  if git ls-files | "$search_tool" -q -E '(^|/)(\.env|.*\.local\.(md|json|ya?ml))$'; then
    printf 'FAIL  local secret/config file is tracked.\n' >&2
    failed=1
  fi
fi

# —— 内容级隐私扫描（--privacy）：只扫已跟踪文件，命中高置信模式且非白名单即 FAIL。
if [[ "$privacy" -eq 1 ]]; then
  tmp="$(mktemp)"
  if ! git ls-files -z | ruby "$repo_root/scripts/privacy-scan.rb" "$repo_root" >"$tmp" 2>&1; then
    printf 'FAIL  privacy scan found non-allowlisted matches:\n' >&2
    sed 's/^/       /' "$tmp" >&2
    failed=1
  else
    grep -q 'PRIVACY-OK' "$tmp" && : || { printf 'FAIL  privacy-scan.rb output unreadable\n' >&2; failed=1; }
    # 豁免也要摆明面（可审计）：哪些文件按「已批准基线 + 校验和」被放行
    if grep -q '^EXEMPT' "$tmp"; then
      grep '^EXEMPT' "$tmp" | sed 's/^/       /' >&2
    fi
  fi
  rm -f "$tmp"
fi

if [[ "$failed" -ne 0 ]]; then
  exit 1
fi

printf 'PASS  %d SKILL.md file(s) have required frontmatter.\n' "$checked"
