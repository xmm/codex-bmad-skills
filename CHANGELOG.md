# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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

[1.0.0]: https://github.com/xmm/codex-bmad-skills/releases/tag/v1.0.0
