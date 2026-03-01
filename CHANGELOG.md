# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.3.2] - 2026-03-01

### Added
- Added a direct GitHub link to the original `xmm/codex-bmad-skills` repository in the root `README.md`.

### Changed
- Updated `installers/install-codex.sh` and `installers/install-codex.ps1` to copy the root `README.md` into the install destination as `bmad-README.md` so project-local installs retain a visible reference to the source project.
- Updated both installers so `bmad-README.md` respects `--force`/`-Force`: existing files are skipped by default and only overwritten when force is requested, including accurate `--dry-run` logging.

---

## [1.3.1] - 2026-02-18

### Fixed
- Fixed `skills/bmad-scrum-master/scripts/generate-story-id.sh` to extract project names from both flat (`project: my-project`) and nested (`project.name`) `bmad/sprint-status.yaml` schemas, preventing false failures on orchestrator-generated files.

---

## [1.3.0] - 2026-02-17

### Added
- Added release and commit conventions to `AGENTS.md`, including SemVer tag/title formats and Conventional Commit requirements.

### Changed
- Updated cross-platform installers (`installers/install-codex.sh`, `installers/install-codex.ps1`) to resolve installable `codex-bmad-skills` version from Git tags, with fallback to `CHANGELOG.md` when Git metadata is unavailable.
- Updated installers to print the resolved installable version and persist it to `skills/bmad-orchestrator/version.yaml` during installation.
- Updated orchestrator scripts (`skills/bmad-orchestrator/scripts/init-project.sh`, `skills/bmad-orchestrator/scripts/show-status.sh`) to display `codex_bmad_skills_version` from orchestrator-local `version.yaml`.

---

## [1.2.0] - 2026-02-17

### Changed
- Moved project initialization templates (`project.template.yaml`, `workflow-status.template.yaml`, `sprint-status.template.yaml`) under `skills/bmad-orchestrator/templates/` and updated `init-project.sh` to consume orchestrator-local templates.
- Replaced the legacy compatibility workflow-status template with the structured phase/workflow schema used by current orchestrator initialization.
- Updated docs to clarify that `bmad-shared` now focuses on shared YAML state helpers and registry data, not initialization templates.
- Updated onboarding docs (`README.md`, `docs/getting-started.md`) to use the Codex intent workflow (`bmad:init`, `bmad:status`, `bmad:next`) instead of direct script invocation examples.
- Updated `docs/getting-started.md` examples to include explicit init parameters (`type`, `level`) and switched long sample outputs to collapsible `<details>` blocks for readability.
- Added AGENTS policy guardrails that enforce `skills/*` path isolation and forbid cross-tree references from skill assets/scripts.

### Fixed
- Hardened `skills/bmad-analyst/scripts/validate-brief.sh` for non-interactive runs by making `clear` non-fatal and replacing arithmetic post-increment that could trigger early exit under `set -e`.
- Hardened `skills/bmad-architect/scripts/validate-architecture.sh` under `set -euo pipefail`; counters now increment safely and checks aggregate complete output before the final verdict.

### Removed
- Removed obsolete compatibility template `skills/bmad-orchestrator/templates/config.template.yaml`.
- Removed `skills/bmad-shared/workflow-status.template.yaml` after template ownership was consolidated under `bmad-orchestrator`.

---

## [1.1.0] - 2026-02-16

### Changed
- Updated `bmad-analyst` to enforce a chat-native discovery interview gate before drafting/finalizing `product-brief`.
- Set the default discovery path to chat Q&A for both Codex Desktop and Codex CLI.
- Updated incomplete brief guidance in `skills/bmad-analyst/scripts/validate-brief.sh` to point to `resources/interview-frameworks.md`.
- Normalized metadata block style across BMAD templates for consistent front matter formatting.

### Removed
- Removed `skills/bmad-analyst/scripts/discovery-checklist.sh` and all references to it.

---

## [1.0.0] - 2026-02-13

### Added
- Initial BMAD skill set for OpenAI Codex under `skills/bmad-*`.
- BMAD orchestration scripts and YAML workflow state management under `bmad/`.
- Cross-platform installers:
  - `installers/install-codex.sh`
  - `installers/install-codex.ps1`
- Project templates and BMAD documentation under `templates/` and `docs/`.

### Changed
- Enforced BMAD language guard behavior across skills.
- Refined developer skill architecture guidance.
- Migrated project state paths from `.bmad` to `bmad`.
- Simplified installer flow and updated install documentation/flags.
- Clarified BMAD intent naming in docs and prompts.

### Fixed
- Fixed `--dest` tilde expansion in `installers/install-codex.sh`.

### Removed
- Removed `pyproject.toml`; project versioning is now managed via Git tags.

---

## 0.1.0 - 2026-02-08

### Added
- Initial adaptation baseline for OpenAI Codex.
- Project foundation based on [aj-geddes/claude-code-bmad-skills](https://github.com/aj-geddes/claude-code-bmad-skills).

[1.3.2]: https://github.com/xmm/codex-bmad-skills/releases/tag/v1.3.2
[1.3.1]: https://github.com/xmm/codex-bmad-skills/releases/tag/v1.3.1
[1.3.0]: https://github.com/xmm/codex-bmad-skills/releases/tag/v1.3.0
[1.2.0]: https://github.com/xmm/codex-bmad-skills/releases/tag/v1.2.0
[1.1.0]: https://github.com/xmm/codex-bmad-skills/releases/tag/v1.1.0
[1.0.0]: https://github.com/xmm/codex-bmad-skills/releases/tag/v1.0.0
