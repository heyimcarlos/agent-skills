# agent-skills

Skills, subagents, and slash commands for Claude Code, Gemini CLI, and OpenAI Codex CLI — one source of truth, installed natively in each tool.

## Plugins

| Plugin | What it ships |
|--------|---------------|
| `core` | 5 skills (ralph, improve-claude-md, create/iterate research questions, create-research) · 9 research subagents (codebase-*, deep-research-*, thoughts-*, web-search-researcher, repo-index) · 14 workflow commands (commit, describe_pr, debug, linear, worktree, handoff, founder_mode, validate_plan, implement_plan, plus CI variants) |
| `qrspi` | 11 commands implementing the QRSPI workflow: **Q**uestion → **R**esearch → **S**pec (design discussion + structure outline) → **P**lan → **I**mplement, plus iterate variants |

## Install

### Claude Code

From inside Claude Code:

```
/plugin marketplace add heyimcarlos/agent-skills
/plugin install core@agent-skills
/plugin install qrspi@agent-skills    # optional
```

### Gemini CLI

```bash
git clone https://github.com/heyimcarlos/agent-skills ~/repos/agent-skills
~/repos/agent-skills/bin/install gemini --user
```

### OpenAI Codex CLI

```bash
git clone https://github.com/heyimcarlos/agent-skills ~/repos/agent-skills
~/repos/agent-skills/bin/install codex --user
```

Append `--project /path/to/repo` to install into a specific project instead of the user-level dir. Append `--copy` to snapshot files instead of symlinking.

## Repo layout

```
.claude-plugin/marketplace.json   # marketplace metadata listing both plugins
core/                              # plugin: skills + agents + utility commands
  .claude-plugin/plugin.json
  skills/  agents/  commands/
qrspi/                             # plugin: QRSPI workflow commands
  .claude-plugin/plugin.json
  commands/
.claude/                           # reference snapshot of the maintainer's settings
.gemini/                           # adapter dir (TOML translations + skills symlink)
.codex/                            # adapter placeholder (installer flattens prompts)
statusline/statusline.sh           # context/cost/rate-limit statusbar
hooks/                             # placeholder for future hooks
docs/                              # per-tool setup guides + skill anatomy
bin/
  install                          # mini-agent installer
  build-gemini-commands            # regenerates .gemini/commands/*.toml from sources
```

## Editing

Make changes in the canonical locations: `core/skills/`, `core/agents/`, `core/commands/`, `qrspi/commands/`. The `.claude/`, `.gemini/`, and `.codex/` dirs are adapters that point back at those.

After editing slash command markdown, regenerate the Gemini TOML files:

```bash
python3 bin/build-gemini-commands
```
