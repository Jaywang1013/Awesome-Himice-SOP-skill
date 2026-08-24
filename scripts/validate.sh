#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

failed=0
checked=0

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
done < <(find skills projects integrations -name SKILL.md -print0 | sort -z)

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

if git ls-files | rg -q '(^|/)(\.env|.*\.local\.(json|ya?ml))$'; then
  printf 'FAIL  local secret/config file is tracked.\n' >&2
  failed=1
fi

if [[ "$failed" -ne 0 ]]; then
  exit 1
fi

printf 'PASS  %d SKILL.md file(s) have required frontmatter.\n' "$checked"
