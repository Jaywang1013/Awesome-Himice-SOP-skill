# Repository guide

## Purpose

This repository distributes Himice activity-operation Skills for Codex, DeepSeek Harness (DSH), and Claude Code. It is public, but it must never contain real client data, invoices, recordings, tax IDs, employee contact information, API keys, or OAuth credentials.

## Layout

```text
skills/           Deployable core SOP Skills, grouped by runtime
integrations/     Upstream integration guides; no third-party source or binaries
projects/         Optional capability stacks and platform blueprints
scripts/          Safe installer and repository validation
docs/             Maintenance and public-repository guidance
```

## Change rules

- Keep each business Skill's `name` stable across Codex, DSH, and Claude Code.
- A business-rule or template change must be applied to all three runtime copies before release.
- Keep `SKILL.md` focused on routing and must-not-miss decisions. Put detailed rules in `references/` and reusable templates in `assets/`.
- Do not invent tool availability. External integrations must point to their official upstream project and require a real availability check at runtime.
- Keep platform-specific instructions inside the matching runtime folder; do not leak Codex-only or DSH-only commands into shared business rules.
- Do not add a public licence or copy upstream source code without explicit owner approval and licence review.

## Validation

Run before committing:

```bash
bash scripts/validate.sh
git diff --check
```

For installer behaviour, use a disposable test home directory or run:

```bash
bash scripts/install.sh --platform codex --bundle core --dry-run
```
