# sdd-bootstrap

A reusable skill that sets up a spec-driven structure for coding agents in an empty repository, from one prompt. It is stack-agnostic: it creates documents and folders, not code or tooling.

## Use

1. Put this repository where your agent can read it, for example `~/.agents/skills/sdd-bootstrap`.
2. In the new project's repository, give the agent one prompt:

```
Read ~/.agents/skills/sdd-bootstrap/SKILL.md and bootstrap this repository.
Project: <name>
Purpose: <one or two sentences>
Stack: <languages, frameworks, storage>
Build: <command>
Lint: <command>
Type-check: <command>
Test: <command>
Modules: <name - responsibility - may depend on>, ...
```

Agents with skill discovery can be asked simply to "bootstrap this repository with sdd-bootstrap" plus the same inputs. Anything you leave out is written as `[TODO-CLARIFY: ...]`, never guessed.

## What it creates

| Path | Role |
|---|---|
| `AGENTS.md` | Entry file every agent loads: commands, map, read order, the few universal rules |
| `CLAUDE.md` | Redirect to `AGENTS.md` for Claude Code |
| `docs/architecture.md` | Modules and allowed dependency directions |
| `docs/constitution.md` | Non-negotiable rules, each with what enforces it |
| `docs/decisions/` | Decision records and an index with a binding "Do not" list |
| `specs/` | One spec per capability, describing current behavior |
| `changes/` | One folder per change in progress; finished ones move to `changes/archive/` |
| `.agents/skills/sdd-change/` | The change cycle and its templates, read only when behavior changes |

## How the structure works

- **State and history are separate.** `specs/<capability>/spec.md` says what is true now. `changes/<slug>/` holds a proposal, design, tasks and delta specs (ADDED / MODIFIED / REMOVED). Archiving merges the deltas into the spec and moves the folder to `changes/archive/`.
- **Rework does not multiply specs.** Debugging and refactoring amend the open change, or go through the bug-fix and refactor paths, which create no spec.
- **Rejected approaches are remembered.** A reversed approach gets a decision record and a "Do not" line that agents must read before planning.
- **The always-loaded file stays thin.** Process detail lives in the `sdd-change` skill and is loaded only when needed.

## After bootstrap

Add the stack-specific enforcement yourself: formatter, linter, type-checker, tests, a dependency-boundary check, CI and branch protection. Until then the constitution's rules are marked `discipline-only`.

## Layout of this repository

```
SKILL.md              the bootstrap procedure
scripts/bootstrap.sh  copies assets/project/ into a target, never overwriting
scripts/check.sh      reports unfilled placeholders and open TODO-CLARIFY items
assets/project/       the tree copied into the new project
```
