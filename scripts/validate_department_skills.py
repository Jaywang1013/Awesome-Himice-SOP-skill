#!/usr/bin/env python3
"""Validate the self-contained contracts for Himice SOP skill packages."""

from __future__ import annotations

import re
import sys
from pathlib import Path


REPO_ROOT = Path(__file__).resolve().parents[1]
NAME_RE = re.compile(r"^[a-z0-9]+(?:-[a-z0-9]+)*$")
LINK_RE = re.compile(r"(?<!!)\[[^]]+\]\(([^)]+)\)")
DEPARTMENT_DIRS = {"project-business", "creative", "general-affairs", "investment"}


def fail(errors: list[str], message: str) -> None:
    errors.append(message)


def frontmatter(path: Path, errors: list[str]) -> dict[str, str]:
    content = path.read_text(encoding="utf-8")
    match = re.match(r"^---\n(.*?)\n---\n", content, re.DOTALL)
    if not match:
        fail(errors, f"{path.relative_to(REPO_ROOT)}: missing or invalid YAML frontmatter")
        return {}

    fields: dict[str, str] = {}
    for line in match.group(1).splitlines():
        key, separator, value = line.partition(":")
        if separator:
            fields[key.strip()] = value.strip().strip('"').strip("'")

    unexpected = set(fields) - {"name", "description"}
    if unexpected:
        fail(errors, f"{path.relative_to(REPO_ROOT)}: unsupported frontmatter field(s): {', '.join(sorted(unexpected))}")
    for required in ("name", "description"):
        if not fields.get(required):
            fail(errors, f"{path.relative_to(REPO_ROOT)}: missing {required} frontmatter field")
    return fields


def validate_local_links(path: Path, errors: list[str]) -> None:
    content = path.read_text(encoding="utf-8")
    for target in LINK_RE.findall(content):
        target = target.split("#", 1)[0]
        if not target or "://" in target or target.startswith("mailto:"):
            continue
        if not (path.parent / target).resolve().exists():
            fail(errors, f"{path.relative_to(REPO_ROOT)}: linked file does not exist: {target}")


def validate_category(skill_dir: Path, errors: list[str]) -> None:
    parts = skill_dir.relative_to(REPO_ROOT).parts
    valid_shared = len(parts) == 3 and parts[:2] in {
        ("skills", "all-department"),
        ("skills", "company-common"),
    }
    valid_department = (
        len(parts) == 4
        and parts[:2] == ("skills", "departments")
        and parts[2] in DEPARTMENT_DIRS
    )
    if not (valid_shared or valid_department):
        fail(
            errors,
            f"{skill_dir.relative_to(REPO_ROOT)}: skill must live under "
            "skills/all-department, skills/company-common, or an approved skills/departments directory",
        )


def validate_skill(path: Path, errors: list[str]) -> str:
    skill_dir = path.parent
    fields = frontmatter(path, errors)
    name = fields.get("name", "")
    if name and not NAME_RE.fullmatch(name):
        fail(errors, f"{path.relative_to(REPO_ROOT)}: name must use lowercase letters, digits, and hyphens")
    if name and name != skill_dir.name:
        fail(errors, f"{path.relative_to(REPO_ROOT)}: name must match its directory ({skill_dir.name})")
    if not (skill_dir / "agents" / "openai.yaml").is_file():
        fail(errors, f"{skill_dir.relative_to(REPO_ROOT)}: missing agents/openai.yaml")
    validate_category(skill_dir, errors)
    validate_local_links(path, errors)

    fixture = REPO_ROOT / "tests" / "fixtures" / f"{skill_dir.name}.md"
    checklist = REPO_ROOT / "tests" / "checklists" / f"{skill_dir.name}.md"
    if not fixture.is_file():
        fail(errors, f"{skill_dir.relative_to(REPO_ROOT)}: missing anonymized fixture {fixture.relative_to(REPO_ROOT)}")
    if not checklist.is_file():
        fail(errors, f"{skill_dir.relative_to(REPO_ROOT)}: missing acceptance checklist {checklist.relative_to(REPO_ROOT)}")
    return name


def main() -> int:
    skill_files = sorted(REPO_ROOT.glob("**/himice-*-sop/SKILL.md"))
    errors: list[str] = []
    if not skill_files:
        fail(errors, "No skill packages found at **/himice-*-sop/SKILL.md")
    seen_names: dict[str, Path] = {}
    for skill_file in skill_files:
        name = validate_skill(skill_file, errors)
        if name and name in seen_names:
            fail(
                errors,
                f"{skill_file.relative_to(REPO_ROOT)}: duplicate skill name also used by "
                f"{seen_names[name].relative_to(REPO_ROOT)}",
            )
        elif name:
            seen_names[name] = skill_file

    index_files = [
        REPO_ROOT / "README.md",
        REPO_ROOT / "skills" / "README.md",
        REPO_ROOT / "skills" / "all-department" / "README.md",
        REPO_ROOT / "skills" / "company-common" / "README.md",
        REPO_ROOT / "skills" / "departments" / "README.md",
        *sorted((REPO_ROOT / "skills" / "departments").glob("*/README.md")),
    ]
    for index_file in index_files:
        if not index_file.is_file():
            fail(errors, f"{index_file.relative_to(REPO_ROOT)}: missing classification index")
            continue
        validate_local_links(index_file, errors)

    if errors:
        print("Skill validation failed:", file=sys.stderr)
        print(*[f"- {error}" for error in errors], sep="\n", file=sys.stderr)
        return 1
    print(
        f"Validated {len(skill_files)} uniquely categorized skill package(s), "
        "fixtures, checklists, references, and navigation indexes."
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
