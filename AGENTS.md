# Repository guide

## Purpose

This repository distributes Himice activity-operation Skills for Codex, DeepSeek Harness (DSH), and Claude Code. It is public, but it must never contain real client data, invoices, recordings, tax IDs, employee contact information, API keys, or OAuth credentials. The only data exception is a project-owner-approved public enterprise industry baseline, which must preserve sources, verification status, a checksum and a clear non-marketing usage boundary.

## Layout

```text
skills/           Deployable core SOP Skills, grouped by runtime
  all-department/ Cross-department business taxonomy: all departments
  company-common/ Cross-department business taxonomy: two or more departments
  departments/    Department-specific Skills and navigation indexes
integrations/     Upstream integration guides; no third-party source or binaries
projects/         Optional capability stacks and platform blueprints
scripts/          Safe installer and repository validation
docs/             Maintenance and public-repository guidance
```

## Change rules

- Keep each business Skill's `name` stable across Codex, DSH, and Claude Code.
- A taxonomy Skill has one canonical directory under `skills/all-department/`, `skills/company-common/`, or `skills/departments/<department>/`. Department indexes link to shared Skills and must not copy them.
- Keep the four department indexes synchronized: `project-business`, `creative`, `general-affairs`, and `investment`.
- A business-rule or template change must be applied to all three runtime copies before release.
- Keep `SKILL.md` focused on routing and must-not-miss decisions. Put detailed rules in `references/` and reusable templates in `assets/`.
- Do not invent tool availability. External integrations must point to their official upstream project and require a real availability check at runtime.
- Keep platform-specific instructions inside the matching runtime folder; do not leak Codex-only or DSH-only commands into shared business rules.
- Do not add a public licence or copy upstream source code without explicit owner approval and licence review.

## Validation

Run before committing:

```bash
bash scripts/validate.sh
python3 scripts/validate_department_skills.py
git diff --check
```

For installer behaviour, use a disposable test home directory or run:

```bash
bash scripts/install.sh --platform codex --bundle core --dry-run
```
