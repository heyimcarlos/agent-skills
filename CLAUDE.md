# CLAUDE.md — agent-skills repo

This repo is the single source of truth for Claude Code skills, subagents, and slash commands across multiple agent CLIs. It also packages those as Claude Code plugins.

## Layout
- `core/` and `qrspi/` are independently-installable Claude plugins. Each has `.claude-plugin/plugin.json`.
- `.claude-plugin/marketplace.json` makes the repo a Claude marketplace.
- `.gemini/` and `.codex/` are adapter directories that `bin/install` targets when wiring this repo into `~/.gemini/` or `~/.codex/`.
- `.claude/settings.json` is a reference snapshot of the maintainer's Claude Code settings; the plugin marketplace handles all actual content (skills/agents/commands).
- Editing happens in `core/` and `qrspi/`. The Gemini adapter regenerates from those.

## Conventions
- Skill SKILL.md uses the standard `name`/`description` frontmatter; no `model:` line unless deliberate.
- Slash command files use `description:` frontmatter so the Gemini TOML generator can lift it.
- Commands prefixed with `_` (e.g., `qrspi/commands/_create_research.md`) are meant to be invoked indirectly by other commands, not by the user.
- After editing any `core/commands/*.md` or `qrspi/commands/*.md`, regenerate Gemini TOML: `python3 bin/build-gemini-commands`.

## Don't
- Don't edit anything inside `.gemini/` or `.codex/` directly — they are derived/adapter content.
- `.claude/settings.json` is a personal reference; only update when you've changed your real `~/.claude/settings.json` and want the repo snapshot to match.
- Don't commit `.claude/settings.local.json` or any per-machine state (see `.gitignore`).
