# BMAD Skills for OpenAI Codex

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![OpenAI Codex](https://img.shields.io/badge/OpenAI%20Codex-Native-orange.svg)](https://openai.com/codex/)

Codex-first adaptation of the BMAD workflow model.

## Quick Start Example

Need a fast start with our skills? See [`docs/getting-started.md`](docs/getting-started.md).

## Attribution & Credit

The BMAD Method (Breakthrough Method for Agile AI-Driven Development) is created and
maintained by the BMAD Code Organization.

All credit for the BMAD methodology belongs to:

- BMAD Code Organization: https://github.com/bmad-code-org
- Original BMAD Method: https://github.com/bmad-code-org/BMAD-METHOD
- Website: https://bmadcodes.com/bmad-method/
- YouTube: https://www.youtube.com/@BMadCode
- Discord: https://discord.gg/gk8jAdXWmj

This repository is an implementation and adaptation of BMAD for OpenAI Codex.
The methodology, core workflow patterns, and BMAD concepts remain the intellectual
property of the BMAD Code Organization.

This OpenAI Codex adaptation was initially based on the
[BMAD Method v6 for Claude Code](https://github.com/aj-geddes/claude-code-bmad-skills)

Codex-specific adaptations in this repository include:

- OpenAI Codex runtime contract (`.agents/skills` global and project roots)
- intent-based workflow routing (`bmad:*`) instead of slash commands
- explicit YAML workflow state in `bmad/*.yaml`
- migration-safe preference for project-local skills over global collisions

## The BMAD Workflow

BMAD for OpenAI Codex uses intent IDs (not slash commands) and tracks workflow state in
`bmad/workflow-status.yaml`.

Recommended orchestration flow:

1. `bmad:init`
2. `bmad:status`
3. `bmad:next`
4. Run the recommended phase intent
5. Update workflow state in YAML

### Phase 1: Analysis

Primary skill: `bmad-analyst`

Intents:

- `bmad:product-brief`
- `bmad:research`
- `bmad:brainstorm`

Primary outputs:

- `docs/bmad/product-brief.md`
- `docs/bmad/research-report.md`
- `docs/bmad/brainstorm.md`

When: start of a new project or major feature discovery.

### Phase 2: Planning

Primary skills: `bmad-product-manager`, `bmad-ux-designer`

Intents:

- `bmad:prd`
- `bmad:tech-spec`
- `bmad:prioritize`
- `bmad:ux-design`

Primary outputs:

- `docs/bmad/prd.md`
- `docs/bmad/tech-spec.md`
- `docs/bmad/prioritization.md`
- `docs/bmad/ux-design.md`

When: after Analysis, before architecture design.

Level rules:

- Level 0-1 projects require `tech-spec`
- Level 2-4 projects require `prd` and `architecture`

### Phase 3: Solutioning

Primary skill: `bmad-architect`

Intents:

- `bmad:architecture`
- `bmad:gate-check`

Primary outputs:

- `docs/bmad/architecture.md`
- `docs/bmad/gate-check.md`

When: after Planning, before implementation.

### Phase 4: Implementation

Primary skills: `bmad-scrum-master`, `bmad-developer`

Intents:

- `bmad:sprint-plan`
- `bmad:create-story`
- `bmad:dev-story`
- `bmad:code-review`

Primary outputs:

- `docs/bmad/sprint-plan.md`
- `docs/stories/STORY-*.md`
- implemented code and tests in the repository
- optional `docs/bmad/code-review.md`

When: iterative delivery after architecture/gate readiness.

### Extension and Innovation (Any Phase)

These intents are optional and can be used when needed:

- `bmad:create-skill`
- `bmad:create-workflow`
- `bmad:ideate`
- `bmad:research-deep`
- `bmad:user-flow`

## Status

Migration is in progress on this branch, but the core Codex path is already usable:

- skill namespace: `skills/bmad-*`
- installers: `installers/install-codex.sh`, `installers/install-codex.ps1`
- project artifacts: `bmad/*.yaml`
- orchestration scripts: `skills/bmad-orchestrator/scripts/*`

## Runtime Requirements

- `yq` v4+
- `python3` (or `python`)

Installer validates both dependencies before install.

## Install

### Install to default global path

```bash
./installers/install-codex.sh
```

### Install to custom path (example: project-local)

```bash
codex-bmad-skills/installers/install-codex.sh --dest "<project>/.agents/skills"
```

PowerShell:

```powershell
codex-bmad-skills/installers/install-codex.ps1
codex-bmad-skills/installers/install-codex.ps1 -Dest "<project>\.agents\skills"
```

Notes:

- `--dest` / `-Dest` is optional
- default destination is `$HOME/.agents/skills`
- restart Codex after installation so it reloads and sees newly installed skills

## Initialize BMAD in Project

After skills installation, initialize project artifacts:

```bash
bash skills/bmad-orchestrator/scripts/init-project.sh \
  --name "My Project" \
  --type web-app \
  --level 2
```

This creates:

- `bmad/project.yaml`
- `bmad/workflow-status.yaml`
- `bmad/sprint-status.yaml`
- `docs/bmad/`
- `docs/stories/`

## Check Status and Next Action

```bash
bash skills/bmad-orchestrator/scripts/show-status.sh bmad/workflow-status.yaml
bash skills/bmad-orchestrator/scripts/recommend-next.sh bmad/workflow-status.yaml
```

## BMAD Intent IDs

- Orchestration: `bmad:init`, `bmad:status`, `bmad:next`
- Discovery: `bmad:product-brief`, `bmad:research`, `bmad:brainstorm`
- Planning: `bmad:prd`, `bmad:tech-spec`, `bmad:prioritize`
- Architecture: `bmad:architecture`, `bmad:gate-check`
- Delivery: `bmad:sprint-plan`, `bmad:create-story`, `bmad:dev-story`, `bmad:code-review`
- UX: `bmad:ux-design`, `bmad:user-flow`
- Creative: `bmad:ideate`, `bmad:research-deep`
- Extensibility: `bmad:create-skill`, `bmad:create-workflow`

## Layout

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
├── templates/
└── docs/
```

## License

MIT License

Copyright (c) 2025 BMAD Method v6 Contributors

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

---

**IMPORTANT:** The **BMAD Method™** name, methodology, workflow patterns, and concepts are the intellectual property of the **BMAD Code Organization**. This license covers only the OpenAI Codex implementation code in this repository, not the BMAD Method itself.

**Original BMAD Method**: https://github.com/bmad-code-org/BMAD-METHOD  
**Original BMAD Method v6 for Claude Code**: https://github.com/aj-geddes/claude-code-bmad-skills

---
