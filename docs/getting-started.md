---
layout: default
title: "Getting Started (OpenAI Codex)"
description: "Install BMAD skills into OpenAI Codex and initialize project YAML artifacts."
keywords: "OpenAI Codex, BMAD install, .agents/skills, yq"
---

# Getting Started (OpenAI Codex)

## Prerequisites

- OpenAI Codex installed
- `yq` v4+
- `python3` (or `python`)

The installer checks these dependencies during installation.

## 1. Clone

```bash
git clone https://github.com/xmmm/codex-bmad-skills.git
```

## 2. Install Skills

### Install to default global path

```bash
codex-bmad-skills/installers/install-codex.sh
```

### Install to custom path (example: project-local)

```bash
codex-bmad-skills/installers/install-codex.sh --dest "<project>/.agents/skills"
```

PowerShell equivalents:

```powershell
codex-bmad-skills/installers/install-codex.ps1
codex-bmad-skills/installers/install-codex.ps1 -Dest "<project>\.agents\skills"
```

## 3. Initialize BMAD Artifacts

### Run Codex
```bash
codex --cd <project>/
```

### Initialize a project

```codex
› bmad:init
```
<details>
<summary>Codex output (click to expand).</summary>

```bash
• I’m running the BMAD orchestrator init workflow now: first I’ll check the init script arguments, then initialize 
  artifacts in this repo with sensible defaults and report the created state files.

• Explored
  └ List example
    Read REFERENCE.md, init-project.sh

────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

• I confirmed the repo is empty, so I’m initializing with defaults: project name example, type other, level 2, and root 
  set to this workspace so BMAD state files are created locally.

• Ran bash /Users/xmm/.agents/skills/bmad-orchestrator/scripts/init-project.sh --name "example" --type other --level 2 \
 --project-root /Users/xmm/workspace/xmmdev/example
  └ initialized=true
    … +5 lines
    document_output_language=English
    next_intent=bmad:status

────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

• Initialization succeeded. I’m validating by running the status/recommend scripts and then I’ll report the current 
  phase and next routed intent.

• Explored
  └ List example
    List bmad

────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

• BMAD initialization is complete for this workspace.

  Created artifacts:

  - bmad/project.yaml
  - bmad/workflow-status.yaml
  - bmad/sprint-status.yaml
  - AGENTS.md
  - docs/bmad/
  - docs/stories/

  Initialization parameters used:

  - name=example
  - type=other
  - level=2
  - communication_language=English
  - document_output_language=English

  Current routed next step:

  - next_intent=bmad:product-brief
  - Reason: Phase 1 foundation is incomplete.

  1. Continue with bmad:product-brief.
  2. If you want different init settings (name/type/level/language), I can re-run bmad:init with --force.
```

</details>


### Initialize a project with parameters

```codex
› bmad:init --force with name "My Project" and both communication and document output languages set to German
```

#### Codex CLI output:

<div style="max-height: 300px; overflow-y: auto;
  background-color: #808080;
  padding: 12px;
  border-radius: 12px;
  font-family: monospace;
  font-size: 14px;
">

```bash
• I’m using the bmad-orchestrator skill again for bmad:init. I’ll read the required reference, pull the current
  type/level from bmad/project.yaml, then re-run init with --force, name My Project, and both languages set to German.

• Explored
  └ Read REFERENCE.md, init-project.sh, project.yaml

────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

• I have the needed inputs from current config (type=other, level=2). I’m now forcing re-initialization with your
  requested name and German for both communication and document output languages.

• Ran bash /Users/xmm/.agents/skills/bmad-orchestrator/scripts/init-project.sh --name "My Project" --type other \
 --level 2 --project-root /Users/xmm/workspace/xmmdev/example --communication-language
  │ "German" --document-output-language "German" --force
  └ initialized=true
    … +5 lines
    document_output_language=German
    next_intent=bmad:status

────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

• Re-init completed successfully. I’m validating the generated config values and current routed next intent before I 
  hand back the result.

• Explored
  └ Read project.yaml

────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

• bmad:init --force wurde erfolgreich ausgeführt.

  Aktualisiert:

  - bmad/project.yaml: Name auf "My Project"
  - bmad/project.yaml: communication_language auf German
  - bmad/project.yaml: document_output_language auf German
  - bmad/workflow-status.yaml und bmad/sprint-status.yaml neu gerendert

  Aktueller nächster Schritt:

  - next_intent=bmad:product-brief
  - Grund: Phase 1 ist noch nicht abgeschlossen.
```
</div>

#### Generated files:

- `AGENTS.md`
- `bmad/project.yaml`
- `bmad/workflow-status.yaml`
- `bmad/sprint-status.yaml`

## 4. Check Status


```codex
› bmad:status
```

#### Codex CLI output:

It uses the language selected in the previous step.

<div style="max-height: 300px; overflow-y: auto;
  background-color: #808080;
  padding: 12px;
  border-radius: 12px;
  font-family: monospace;
  font-size: 14px;
">

```bash

• Ich führe erneut den Orchestrator-Statuslauf aus und lese den aktuellen Stand aus bmad/workflow-status.yaml, damit die
  Antwort den exakten Ist-Zustand wiedergibt.

• Explored
  └ Read workflow-status.yaml

────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

• BMAD-Status (aktuell)

  - Projekt: My Project (Level 2)
  - Aktuelle Phase: 1 (Analysis)
  - Fortschritt: 0% (0/0)
  - Workflow-Datei: bmad/workflow-status.yaml steht weiterhin auf not_started in allen Phasen.

  Offen:

  - Phase 1: product-brief (required), research (optional), brainstorm (optional)
  - Phase 2: prd (required), tech_spec (optional), ux_design (recommended)
  - Phase 3: architecture (required), gate_check (recommended)
  - Phase 4: sprint_planning (required), stories (0/0)

  Nächster empfohlener Intent:

  - bmad:product-brief
  - Grund: Phase-1-Basis ist noch unvollständig.
```
</div>

## 5. Run Phase Intents

Start with recommended intent from status, then continue by phase:

- discovery: `bmad:product-brief` / `bmad:research`
- planning: `bmad:prd` or `bmad:tech-spec`
- solutioning: `bmad:architecture`
- implementation: `bmad:sprint-plan` -> `bmad:create-story` -> `bmad:dev-story`

For example:
```codex
› bmad:product-brief I want to create a mobile app for conversational practice in a foreign language.
```

Then keep moving with `bmad:next` and verify progress with `bmad:status` after each completed phase artifact.
