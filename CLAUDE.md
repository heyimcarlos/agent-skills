# AGENTS.md — agent-skills repo

This file provides guidance to AI coding agents (Claude Code, Gemini CLI, Codex CLI, Cursor, Copilot, etc.) when working with code in this repository. `CLAUDE.md` is a symlink to this file — Claude Code reads it under that name.

## Repository overview

This repo is the single source of truth for skills and subagents across multiple agent CLIs. It packages them as one Claude Code plugin (`agent-skills`) and is also installable into any agent supported by [`vercel-labs/skills`](https://github.com/vercel-labs/skills) via:

```bash
npx skills@latest add heyimcarlos/agent-skills
```

## Layout

- `skills/` — every skill lives here, bucketed by purpose:
  - `engineering/` — code-work skills (commit, debug, linear, worktree, …)
  - `productivity/` — general workflow skills (ralph, improve-claude-md)
  - `qrspi/` — the QRSPI workflow as prefixed `qrspi-*` setup, create, and iterate skills
  - `misc/` — reserved bucket for rarely-used skills (currently empty)
- `agents/` — Claude Code subagents shipped alongside the plugin (codebase + thoughts + web research roles).
- `.claude-plugin/plugin.json` — single-plugin manifest. Listed by `vercel-labs/skills` for discovery and used by Claude Code's plugin system. The repo is registered as a single-plugin Claude marketplace via this file.
- `.claude/settings.json` — reference snapshot of the maintainer's Claude Code settings. The plugin handles all installable content; this is just a personal snapshot.
- `statusline/statusline.sh` — personal status-line script, not part of the plugin.

## Orchestration: skills and subagents

Two composable layers, two different jobs. Don't mix them up.

- **Skills** (`skills/<bucket>/<name>/SKILL.md`) — workflows with steps and exit criteria. The _how_. Most skills auto-trigger from the description; QRSPI skills are prefixed with `qrspi-`, set `disable-model-invocation: true`, and are invoked explicitly by the user.
- **Subagents** (`agents/<name>.md`) — research/specialist roles with a perspective and an output format. The _who_. Invoked via the `Agent` tool.

Composition rule: **the user (or a skill) is the orchestrator.** Subagents do not invoke other subagents. A skill or subagent may invoke other skills.

The QRSPI workflow is the canonical multi-step orchestration in this repo: each phase is its own skill (`qrspi-create-research-questions`, `qrspi-create-research`, `qrspi-create-design-discussion`, `qrspi-create-structure-outline`, `qrspi-create-plan`, `qrspi-create-worktree`) with `qrspi-iterate-*` siblings for refinement. The user drives stage-to-stage transitions; don't build a "router" persona that picks which stage to run next.

**Claude Code interop:** the agents in `agents/` are auto-discovered as Claude Code subagents when the plugin is installed. Plugin agents silently ignore the `hooks`, `mcpServers`, and `permissionMode` frontmatter fields. Subagents cannot spawn other subagents.

**Other CLIs:** when installed via `npx skills add`, the `vercel-labs/skills` CLI auto-detects which agent CLIs are present (Claude Code, Codex, Gemini, Cursor, …) and installs `SKILL.md` files into each one's native skill path. Agents in `agents/` are only picked up by the Claude Code plugin install path; other CLIs don't have a subagent concept.

## Conventions

- **Skill `SKILL.md`** uses the standard `name` / `description` frontmatter. Add `model:` only when deliberate; QRSPI skills use `model: opus` and `disable-model-invocation: true` so the human triggers each phase.
- **Subagent `<name>.md`** uses the standard subagent frontmatter (`name`, `description`, `tools`).
- After adding or removing a skill, update `.claude-plugin/plugin.json` so its path is in the `skills` array. The vercel-labs CLI also recursively finds skills, but the manifest is the source of truth for the Claude Code plugin install.
- After adding or removing a skill, update the README's reference section so every shipped skill is linked from there.

## Skill anatomy

```
skills/<bucket>/<skill-name>/  # kebab-case directory
  SKILL.md                     # required, exactly this filename
  scripts/                     # optional executable scripts
    <script-name>.sh
  references/                  # optional supporting docs (loaded on demand)
```

`SKILL.md` frontmatter:

```yaml
---
name: <skill-name>
description: <One sentence describing when to use this skill. Include trigger phrases agents will recognize.>
---
```

### Best practices for context efficiency

Skills load on-demand — only the name and description load at startup; the full `SKILL.md` only loads when the agent decides the skill applies. To minimize context:

- **Keep `SKILL.md` under 500 lines** — put detailed reference material in separate files under `references/`.
- **Write specific descriptions** — the description is what triggers activation. Vague descriptions mean the skill never fires or fires for the wrong tasks.
- **Use progressive disclosure** — reference supporting files that get read only when needed.
- **Prefer scripts over inline code** — script execution doesn't consume context (only the output does).
- **File references work one level deep** — link directly from `SKILL.md` to supporting files.

### Script requirements

If a skill ships scripts:

- Use `#!/bin/bash` shebang.
- `set -e` for fail-fast behavior.
- Status messages → stderr (`echo "Message" >&2`).
- Machine-readable output (JSON when possible) → stdout.
- Include a cleanup trap for temp files.

## Don't

- Don't update `.claude/settings.json` casually — it's a personal reference snapshot. Only update when the maintainer's real `~/.claude/settings.json` has changed and the repo snapshot should match.
- Don't commit `.claude/settings.local.json` or any per-machine state (see `.gitignore`).
- Don't add a `model:` line to skill or subagent frontmatter unless deliberate — let the host tool pick.
- Don't have a subagent spawn another subagent. Orchestrate from a skill instead.
- Don't add a skill without listing it in `.claude-plugin/plugin.json` and the README reference section.
