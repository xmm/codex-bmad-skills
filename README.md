# BMAD Skills for OpenAI Codex

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![OpenAI Codex](https://img.shields.io/badge/OpenAI%20Codex-Native-orange.svg)](https://openai.com/codex/)

BMAD Skills for OpenAI Codex adds a structured, intent-driven workflow to Codex for **product discovery, planning, architecture, and implementation.**

It installs reusable BMAD skills, introduces `bmad:*` intents, and keeps project workflow state in explicit YAML files inside your repository.

Original GitHub project: [xmm/codex-bmad-skills](https://github.com/xmm/codex-bmad-skills)

## What This Project Does

This repository provides:

- BMAD skills that can be installed into Codex
- intent-based workflow routing via `bmad:*`
- project-local workflow state in `bmad/*.yaml`
- a repeatable path from idea to implementation

Use it when you want Codex to guide work through defined phases instead of relying on ad-hoc prompts.

## Who This Is For

This project is for:

- developers using OpenAI Codex as a primary coding assistant
- teams that want a consistent AI-assisted delivery workflow
- projects that need explicit planning and traceable workflow state

## Quick Start

### Requirements

- `yq` v4+
- `python3` (or `python`)

The installers validate both dependencies before install.

### Install

#### Install to the default global path

```bash
./installers/install-codex.sh
```

#### Install to a custom path (example: project-local)

```bash
./installers/install-codex.sh --dest "<project>/.agents/skills"
```

#### Windows PowerShell

```powershell
./installers/install-codex.ps1
./installers/install-codex.ps1 -Dest "<project>\.agents\skills"
```

Notes:

- `--dest` and `-Dest` are optional
- the default destination is `$HOME/.agents/skills`
- restart Codex after installation so it reloads newly installed skills

### Start Codex

```bash
codex
```

### Initialize BMAD in a Project

```text
bmad:init name "My Project" communication language is English documentation language is English
```

### Check Current Status

```text
bmad:status
bmad:next
```

For a guided walkthrough, see [Getting Started](docs/getting-started.md).

## What Gets Created

After initialization, the project contains:

- `bmad/project.yaml` - project settings and language preferences
- `bmad/workflow-status.yaml` - current workflow phase and progress
- `bmad/sprint-status.yaml` - sprint and delivery tracking
- `docs/bmad/` - generated BMAD documents
- `docs/stories/` - implementation stories

## How The Workflow Works

BMAD in Codex is organized into four main phases.

### 1. Analysis

Use this phase to explore the problem space and define direction.

Typical intents:

- `bmad:product-brief`
- `bmad:research`
- `bmad:brainstorm`

Typical outputs:

- `docs/bmad/product-brief.md`
- `docs/bmad/research-report.md`
- `docs/bmad/brainstorm.md`

### 2. Planning

Use this phase to turn discovery into scoped plans and product documentation.

Typical intents:

- `bmad:prd`
- `bmad:tech-spec`
- `bmad:prioritize`
- `bmad:ux-design`

Typical outputs:

- `docs/bmad/prd.md`
- `docs/bmad/tech-spec.md`
- `docs/bmad/prioritization.md`
- `docs/bmad/ux-design.md`

Planning rules:

- level 0-1 projects require `tech-spec`
- level 2-4 projects require `prd` and `architecture`

### 3. Solutioning

Use this phase to define architecture and validate readiness before implementation.

Typical intents:

- `bmad:architecture`
- `bmad:gate-check`

Typical outputs:

- `docs/bmad/architecture.md`
- `docs/bmad/gate-check.md`

### 4. Implementation

Use this phase to plan delivery, create stories, build, and review.

Typical intents:

- `bmad:sprint-plan`
- `bmad:create-story`
- `bmad:dev-story`
- `bmad:code-review`

Typical outputs:

- `docs/bmad/sprint-plan.md`
- `docs/stories/STORY-*.md`
- implemented code and tests in the repository
- optional `docs/bmad/code-review.md`

### Extension and Innovation

These intents are optional and can be used in any phase:

- `bmad:create-skill`
- `bmad:create-workflow`
- `bmad:ideate`
- `bmad:research-deep`
- `bmad:user-flow`

## Core Intents

### Orchestration

- `bmad:init`
- `bmad:status`
- `bmad:next`

### Discovery

- `bmad:product-brief`
- `bmad:research`
- `bmad:brainstorm`

### Planning

- `bmad:prd`
- `bmad:tech-spec`
- `bmad:prioritize`

### Architecture

- `bmad:architecture`
- `bmad:gate-check`

### Delivery

- `bmad:sprint-plan`
- `bmad:create-story`
- `bmad:dev-story`
- `bmad:code-review`

### UX and Extensions

- `bmad:ux-design`
- `bmad:user-flow`
- `bmad:ideate`
- `bmad:research-deep`
- `bmad:create-skill`
- `bmad:create-workflow`

## Repository Layout

```text
.
├── AGENTS.md
├── installers/
├── skills/
│   ├── bmad-orchestrator/
│   ├── bmad-analyst/
│   ├── bmad-product-manager/
│   ├── bmad-architect/
│   ├── bmad-scrum-master/
│   ├── bmad-developer/
│   ├── bmad-ux-designer/
│   ├── bmad-creative-intelligence/
│   ├── bmad-builder/
│   └── bmad-shared/
└── docs/
```

Key directories:

- `skills/` - the BMAD skills used by Codex
- `installers/` - install scripts for supported environments
- `docs/` - documentation and examples

## Current Status

The core Codex workflow is already usable today.

Current implementation focus:

- Codex-native skill installation
- intent-based orchestration
- YAML-backed project workflow state
- migration-safe preference for project-local skills over global collisions

## Learn More

- [Getting Started](docs/getting-started.md)
- [Contributing](CONTRIBUTING.md)
- [Changelog](CHANGELOG.md)

## Attribution

The BMAD Method (Breakthrough Method for Agile AI-Driven Development) is created and maintained by the BMAD Code Organization.

This repository is an implementation and adaptation of BMAD for OpenAI Codex. The methodology, core workflow patterns, and BMAD concepts remain the intellectual property of the BMAD Code Organization.

This OpenAI Codex adaptation was initially based on [BMAD Method v6 for Claude Code](https://github.com/aj-geddes/claude-code-bmad-skills).

Original sources:

- BMAD Code Organization: https://github.com/bmad-code-org
- Original BMAD Method: https://github.com/bmad-code-org/BMAD-METHOD
- Website: https://bmadcodes.com/bmad-method/
- YouTube: https://www.youtube.com/@BMadCode
- Discord: https://discord.gg/gk8jAdXWmj

## License

MIT License. See [LICENSE](LICENSE).
