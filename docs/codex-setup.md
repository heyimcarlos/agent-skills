# OpenAI Codex CLI setup

```bash
git clone https://github.com/heyimcarlos/agent-skills ~/repos/agent-skills
cd ~/repos/agent-skills
bin/install codex --user
```

Result:
```
~/.codex/prompts/core_commit.md
~/.codex/prompts/core_describe_pr.md
~/.codex/prompts/core_linear.md
…
```

Codex prompts live in a flat directory and are invoked as `/core_commit`, `/core_describe_pr`, etc. The plugin name is folded into the filename prefix.

> The `qrspi` plugin no longer ships slash commands — its workflow lives in `qrspi/skills/` and `qrspi/agents/`. Only `core/commands/` are translated into Codex prompts; QRSPI skill/agent integration for Codex is not yet implemented.

## AGENTS.md

Codex CLI reads `AGENTS.md` from the working directory. Add this repo's `AGENTS.md` (or your own per-project one) to the root of any project where you want Codex to know the conventions.

## Project install

```bash
bin/install codex --project /path/to/project
```

Populates `<project>/.codex/prompts/` with the same content.
