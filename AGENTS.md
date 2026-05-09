# AGENTS.md — agent-skills repo

Source-of-truth repo for skills, subagents, and slash commands. Two Claude Code plugins (`core`, `qrspi`) plus adapters for Gemini CLI and OpenAI Codex CLI.

Editable content lives in:
- `core/skills/` — SKILL.md per skill
- `core/agents/` — subagent .md files
- `core/commands/` — utility slash commands
- `qrspi/commands/` — QRSPI workflow slash commands

Adapter dirs (`.claude/`, `.gemini/`, `.codex/`) and `bin/install` translate the canonical content into each tool's native config layout. Don't hand-edit adapters.

After editing command markdown, run `python3 bin/build-gemini-commands` to refresh `.gemini/commands/*.toml`.
