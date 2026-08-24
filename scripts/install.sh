#!/usr/bin/env bash
set -euo pipefail

# Install a selected Himice bundle without overwriting any existing local skill.

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
platform=""
bundle="core"
dry_run=false

usage() {
  cat <<'EOF'
Usage:
  bash scripts/install.sh --platform <codex|dsh|claude-code> [--bundle <core|productivity|all>] [--dry-run]

Bundles:
  core          Budget, advance-fund, reimbursement, OfficeCLI and meeting transcription
  productivity  Cross-agent office, file intake, online office, notification, design and knowledge skills
  all           Both bundles

The installer never overwrites an existing local skill. Update or remove an installed
skill manually before installing a replacement.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --platform)
      platform="${2:-}"
      shift 2
      ;;
    --bundle)
      bundle="${2:-}"
      shift 2
      ;;
    --dry-run)
      dry_run=true
      shift
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      printf 'Unknown option: %s\n\n' "$1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

case "$platform" in
  codex)
    target_root="${HOME}/.codex/skills"
    core_source="${repo_root}/skills/codex"
    productivity_source="${repo_root}/projects/enterprise-productivity-stack/codex/skills"
    ;;
  dsh|deepseek-harness)
    target_root="${HOME}/.dsh/skills"
    core_source="${repo_root}/skills/deepseek-harness/skills"
    productivity_source="${repo_root}/projects/enterprise-productivity-stack/deepseek-harness/skills"
    ;;
  claude-code)
    target_root="${HOME}/.claude/skills"
    core_source="${repo_root}/skills/claude-code/skills"
    productivity_source="${repo_root}/projects/enterprise-productivity-stack/claude-code/skills"
    ;;
  *)
    printf 'Choose --platform codex, dsh, or claude-code.\n\n' >&2
    usage >&2
    exit 2
    ;;
esac

case "$bundle" in
  core)
    sources=("$core_source")
    ;;
  productivity)
    sources=("$productivity_source")
    ;;
  all)
    sources=("$core_source" "$productivity_source")
    ;;
  *)
    printf 'Choose --bundle core, productivity, or all.\n' >&2
    exit 2
    ;;
esac

if [[ "$dry_run" == false ]]; then
  mkdir -p "$target_root"
fi

installed=0
skipped=0
for source_root in "${sources[@]}"; do
  for skill_dir in "$source_root"/*; do
    [[ -d "$skill_dir" ]] || continue
    [[ -f "$skill_dir/SKILL.md" ]] || continue
    skill_name="$(basename "$skill_dir")"
    destination="${target_root}/${skill_name}"

    if [[ -e "$destination" ]]; then
      printf 'SKIP  %s already exists\n' "$destination" >&2
      skipped=$((skipped + 1))
      continue
    fi

    if [[ "$dry_run" == true ]]; then
      printf 'PLAN  %s -> %s\n' "$skill_dir" "$destination"
    else
      cp -R "$skill_dir" "$destination"
      printf 'ADD   %s\n' "$destination"
    fi
    installed=$((installed + 1))
  done
done

if [[ "$dry_run" == true ]]; then
  printf '\nDry run complete: %d skill(s) would be added; %d skipped.\n' "$installed" "$skipped"
else
  printf '\nInstall complete: %d skill(s) added; %d skipped. Restart the selected agent before use.\n' "$installed" "$skipped"
fi
