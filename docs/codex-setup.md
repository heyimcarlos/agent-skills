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
~/.codex/prompts/qrspi_create_research.md
…
```

Codex prompts live in a flat directory and are invoked as `/core_commit`, `/qrspi_create_research`, etc. The plugin name is folded into the filename prefix.

## AGENTS.md

Codex CLI reads `AGENTS.md` from the working directory. Add this repo's `AGENTS.md` (or your own per-project one) to the root of any project where you want Codex to know the conventions.

## Project install

```bash
bin/install codex --project /path/to/project
```

Populates `<project>/.codex/prompts/` with the same content.
