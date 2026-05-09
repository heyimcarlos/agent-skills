# AGENTS.md — agent-skills repo

This file provides guidance to AI coding agents (Claude Code, Gemini CLI, Codex CLI, Cursor, Copilot, etc.) when working with code in this repository. `CLAUDE.md` is a symlink to this file — Claude Code reads it under that name.

## Repository overview

This repo is the single source of truth for skills, subagents, and slash commands across multiple agent CLIs. It packages them as two independently-installable Claude Code plugins (`core`, `qrspi`) and ships adapter directories that `bin/install` translates into Gemini CLI and OpenAI Codex CLI native config layouts.

## Layout

- `core/` and `qrspi/` — independently-installable Claude plugins. Each has `.claude-plugin/plugin.json`.
- `.claude-plugin/marketplace.json` — makes the repo a Claude marketplace.
- `.gemini/` and `.codex/` — adapter directories that `bin/install` targets when wiring this repo into `~/.gemini/` or `~/.codex/`.
- `.claude/settings.json` — reference snapshot of the maintainer's Claude Code settings; the plugin marketplace handles all actual content.
- `bin/install` — the mini-agent installer.
- `bin/build-gemini-commands` — regenerates `.gemini/commands/*.toml` from the canonical command markdown.

Canonical (editable) content lives in:

- `core/skills/<name>/SKILL.md` — utility skills (ralph, improve-claude-md)
- `core/commands/<name>.md` — utility slash commands (commit, describe_pr, debug, linear, …)
- `qrspi/skills/<name>/SKILL.md` — QRSPI workflow skills (one per stage, plus iterate variants)
- `qrspi/agents/<name>.md` — research subagents (codebase + thoughts + web)

## Orchestration: skills, subagents, and commands

Three composable layers, three different jobs. Don't mix them up.

- **Skills** (`*/skills/<name>/SKILL.md`) — workflows with steps and exit criteria. The _how_. `core` skills auto-trigger when a task matches the description; QRSPI skills set `disable-model-invocation: true` and are invoked explicitly.
- **Subagents** (`qrspi/agents/<name>.md`) — research/specialist roles with a perspective and an output format. The _who_. Invoked via the `Agent` tool.
- **Slash commands** (`core/commands/<name>.md`) — user-facing entry points for git/PR/Linear/handoff utilities. The _when_.

Composition rule: **the user (or a skill / slash command) is the orchestrator.** Subagents do not invoke other subagents. A skill or subagent may invoke other skills.

The QRSPI workflow is the canonical multi-step orchestration in this repo: each phase is its own skill (`qrspi:create-research-questions`, `qrspi:create-research`, `qrspi:create-design-discussion`, `qrspi:create-structure-outline`, `qrspi:create-plan`, `qrspi:create-worktree`) with `iterate-*` siblings for refinement. The user drives stage-to-stage transitions; don't build a "router" persona that picks which stage to run next.

**Claude Code interop:** the agents in `qrspi/agents/` work as Claude Code subagents (auto-discovered from the plugin's `agents/` directory). Plugin agents silently ignore the `hooks`, `mcpServers`, and `permissionMode` frontmatter fields. Subagents cannot spawn other subagents.

## Conventions

- **Skill `SKILL.md`** uses the standard `name` / `description` frontmatter. Add `model:` only when deliberate; QRSPI skills use `model: opus` and `disable-model-invocation: true` so the human triggers each phase.
- **Subagent `<name>.md`** uses the standard subagent frontmatter (`name`, `description`, `tools`).
- **Slash command files** use a `description:` frontmatter field so the Gemini TOML generator can lift it.
- After editing any `core/commands/*.md`, regenerate the Gemini TOML:

  ```bash
  python3 bin/build-gemini-commands
  ```

## Skill anatomy

```
{plugin}/skills/{skill-name}/  # kebab-case directory
  SKILL.md                     # required, exactly this filename
  scripts/                     # optional executable scripts
    {script-name}.sh
  references/                  # optional supporting docs (loaded on demand)
```

`SKILL.md` frontmatter:

```yaml
---
name: {skill-name}
description: {One sentence describing when to use this skill. Include trigger phrases agents will recognize.}
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

- Don't edit anything inside `.gemini/` or `.codex/` directly — they are derived/adapter content. Edit the canonical command markdown and run `python3 bin/build-gemini-commands`.
- Don't update `.claude/settings.json` casually — it's a personal reference snapshot. Only update when you've changed your real `~/.claude/settings.json` and want the repo snapshot to match.
- Don't commit `.claude/settings.local.json` or any per-machine state (see `.gitignore`).
- Don't add a `model:` line to skill or subagent frontmatter unless deliberate — let the host tool pick.
- Don't have a subagent spawn another subagent. Orchestrate from a skill or slash command instead.
