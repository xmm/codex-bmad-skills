---
name: bmad-developer
description: Implementation skill for BMAD. Use for bmad:dev-story and bmad:code-review to deliver tested code from story specs.
---

# BMAD Developer

## Trigger Intents

- `bmad:dev-story`
- `bmad:code-review`

## Workflow Variants

1. `dev-story`
- Implement one story to completion with tests.

2. `code-review`
- Review implementation quality against story acceptance criteria.

## Inputs

- target story file `docs/stories/STORY-*.md`
- architecture constraints from `docs/bmad/architecture.md` when present
- repository coding and testing standards

## Language Guard (Mandatory)

Enforce language selection separately for chat responses and generated artifacts.

Chat language (`communication_language`) fallback order:

1. `language.communication_language` from `bmad/project.yaml`
2. `English`

Rules for chat responses:

- Use the resolved chat language for all assistant responses (questions, status updates, summaries, and handoff notes).
- Do not switch chat language unless the user explicitly requests a different language in the current thread.

Artifact language (`document_output_language`) fallback order:

1. `language.document_output_language` from `bmad/project.yaml`
2. `English`

Rules for generated artifacts:

- Use the resolved artifact language for all generated BMAD documents and structured artifacts.
- write prose and field values in the resolved document language
- avoid mixed-language requirement clauses with English modal verbs (for example, `System shall` followed by non-English text)
- allow English acronyms/abbreviations in non-English sentences (for example, `API`, `SLA`, `KPI`, `OAuth`, `WCAG`)
- Keep code snippets, CLI commands, file paths, and identifiers in their original technical form.

## Mandatory Reference Load

Before executing `dev-story` or `code-review`, read `REFERENCE.md` first and treat it as required context. Then load focused details from:
- `resources/clean-code-checklist.md`
- `resources/testing-standards.md`

Architecture Guardrails = `Architecture Compliance Guardrails` section
(source of truth for architecture constraints).

When `docs/bmad/architecture.md` exists, apply Architecture Guardrails.

## Output Contract

- code and test changes in repository
- optional review artifact `docs/bmad/code-review.md`
- clear pass/fail status against acceptance criteria
- for architecture-constrained stories: concise note on how key constraints were handled

## Core Workflow

1. Read story scope and acceptance criteria.
2. Implement minimal complete solution.
3. Add or update tests.
4. Run quality checks and summarize outcomes.
5. Report residual risks and follow-up items.
6. If architecture constraints are clearly violated, return `Needs changes`; otherwise report residual risks and follow-up items.

## Implementation Approach

### 1. Understand Story and Constraints

- Parse acceptance criteria into explicit checks.
- Identify touched modules, dependencies, and data contracts.
- Load architecture constraints from `docs/bmad/architecture.md` when present.
- Apply Architecture Guardrails.
- Flag ambiguities and assumptions before implementation.

### 2. Plan Before Coding

- Break work into small slices:
  - data and schema changes
  - business logic
  - interfaces and adapters
  - test updates
- Define edge cases, failure modes, and rollback-safe behavior.

### 3. Implement Incrementally

- Prefer small, reviewable changes over large rewrites.
- Preserve existing project conventions and architecture boundaries.
- Handle errors explicitly and keep behavior deterministic.
- Avoid hidden scope expansion; if scope grows, record it in the summary.

### 4. Test to Match Risk

- Add unit tests for new logic and edge cases.
- Add integration tests where component boundaries are crossed.
- Add end-to-end tests for critical user-facing flows when applicable.
- Verify acceptance criteria with test evidence, not assumptions.

### 5. Run Hard Quality Gates

- Run lint and static checks:
  ```bash
  bash scripts/lint-check.sh
  ```
- Run pre-commit checks:
  ```bash
  bash scripts/pre-commit-check.sh
  ```
- Run coverage validation (default 80% minimum unless project requires higher):
  ```bash
  bash scripts/check-coverage.sh
  ```
- Do not mark complete with unresolved failing checks unless explicitly approved.

### 6. Close with Traceable Outcome

- Map each acceptance criterion to code and test evidence.
- Summarize relevant architecture constraints and where they are addressed in code/tests.
- Summarize changed files, key decisions, and residual risks.
- For `code-review`, record findings using `templates/code-review.template.md`.

## Script Selection

- Lint checks:
  ```bash
  bash scripts/lint-check.sh
  ```
- Pre-commit quality checks:
  ```bash
  bash scripts/pre-commit-check.sh
  ```
- Coverage checks:
  ```bash
  bash scripts/check-coverage.sh
  ```

## Template Map

- `templates/code-review.template.md`
- Why: structured review output for quality and risk communication.

## Reference Map

- `REFERENCE.md`
- Must read first for developer workflow and implementation discipline.

- `resources/clean-code-checklist.md`
- Use when reviewing maintainability and readability.

- `resources/testing-standards.md`
- Use when validating test completeness and quality.

## Quality Gates

- acceptance criteria are explicitly verified
- architecture constraints are explicitly verified (storage, auth, idempotency when applicable)
- tests and lint pass, or failures are reported clearly
- no hidden scope expansion without note
- implementation remains maintainable and reviewable
