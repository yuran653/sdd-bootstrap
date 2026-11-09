---
name: sdd-bootstrap
description: Bootstraps a spec-driven repository structure for coding agents in a new or empty project - AGENTS.md entry file, constitution, architecture doc, capability specs, change folders, decision log and the change-cycle skill. Use when asked to bootstrap, initialise or set up SDD or an agent-ready structure in a repository. Stack-agnostic - creates documents and folders only, no source code or toolchain.
metadata:
  version: "0.1.0"
---

# sdd-bootstrap

Creates the structure below in a target repository, then fills in the project-specific values. Templates are copied, not rewritten: do not rephrase them.

```
AGENTS.md                      entry file, always loaded - keep it thin
CLAUDE.md                      one-line redirect to AGENTS.md
docs/architecture.md           modules and allowed dependencies
docs/constitution.md           non-negotiable rules and what enforces each
docs/decisions/INDEX.md        decision log and the binding "Do not" list
specs/INDEX.md                 registry of capability specs (current behavior)
changes/archive/               finished changes
.agents/skills/sdd-change/     the change cycle and its templates, loaded on demand
```

## Inputs

Take these from the user's prompt:

| Input | Placeholder |
|---|---|
| Project name | `{{PROJECT_NAME}}` |
| Purpose, one or two sentences | `{{PROJECT_PURPOSE}}` |
| Stack | `{{STACK}}` |
| Build command | `{{CMD_BUILD}}` |
| Lint command | `{{CMD_LINT}}` |
| Type-check command | `{{CMD_TYPECHECK}}` |
| Test command | `{{CMD_TEST}}` |
| Initial modules and their allowed dependencies (optional) | rows in `docs/architecture.md` |

If an input is missing, ask for all missing inputs in one message. If nobody can answer, write `[TODO-CLARIFY: <question>]` in its place. Never invent a value, and never derive a command from what is usual for the stack.

## Steps

1. **Check the target.** The target is the repository root. If `AGENTS.md`, `specs/` or `changes/` already exist there, stop and ask: this skill is for new projects and never overwrites.
2. **Copy the templates.** Run `sh <this-skill-dir>/scripts/bootstrap.sh <target>`. It copies `assets/project/` into the target, preserving paths and skipping any file that already exists. Without a shell, copy the tree by hand under the same rules.
3. **Fill the placeholders** in `AGENTS.md`, `docs/architecture.md` and `docs/constitution.md`.
   - A command that does not exist for this project (for example, no type-check step): delete its line. Do not fake one.
   - No modules given: leave the `[TODO-CLARIFY]` row in `docs/architecture.md`.
4. **Record the stack decision** if a stack was given: create `docs/decisions/ADR-0001-stack.md` from `.agents/skills/sdd-change/assets/adr.md` and add its row to `docs/decisions/INDEX.md`. Write rejected alternatives only if the user named them; otherwise put `[TODO-CLARIFY: alternatives considered]`.
5. **Verify.** Run `sh <this-skill-dir>/scripts/check.sh <target>`. It must report zero unfilled `{{...}}` placeholders. It also lists every `[TODO-CLARIFY]`.
6. **Report:** files created, files skipped, every open `[TODO-CLARIFY]`, and the remaining step below.

## Boundaries

- Do not create source code, linter, test or CI configuration. Those depend on the stack and are a separate step.
- Do not add content to `AGENTS.md` beyond the template and the inputs. It is loaded on every task.
- Do not commit or push unless the user asked.

## What remains after bootstrap

The structure exists but nothing enforces it. Every rule in `docs/constitution.md` starts as `discipline-only`. The next step, outside this skill, is stack-specific: formatter, linter, type-checker, test runner, a dependency-boundary check, CI running the commands from `AGENTS.md`, and branch protection. As each lands, update the rule's "Enforced by" and "Status" in the constitution.
