# agent-skills

**Skills, subagents, and slash commands for AI coding agents — one source of truth, installed natively in Claude Code, Gemini CLI, and OpenAI Codex CLI.**

Skills, agents, and commands encode the workflows a senior engineer follows: research before coding, spec before plan, plan before implement, verify before ship. Packaged so the same workflows trigger across every tool you drive.

## Two plugins

| Plugin | What it ships |
|--------|---------------|
| `core`  | 5 skills · 9 research subagents · 14 workflow commands (commit, describe_pr, debug, linear, worktree, handoff, founder_mode, validate_plan, implement_plan, plus CI variants) |
| `qrspi` | 11 commands implementing the QRSPI workflow: **Q**uestion → **R**esearch → **S**pec → **P**lan → **I**mplement, plus iterate variants |

## QRSPI workflow

The framework `qrspi` enforces maps to five stages:

| Stage | Command | Purpose |
|-------|---------|---------|
| Question  | `_create_research_questions` | Turn a ticket into targeted questions before any code is read |
| Research  | `_create_research` | Document the codebase as-is, grounded in real files |
| Spec      | `create_design_discussion` → `create_structure_outline` | Synthesize research into architectural decisions and a phased outline |
| Plan      | `create_plan` | Convert outline into a rigid step-by-step plan with dual verification |
| Implement | `create_worktree` | Launch an isolated implementation session from an approved plan |

Each phase has an `iterate_*` sibling for surgical adjustments without restarting the workflow.

## Installation

### Claude Code (recommended)

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

## Skills (5, in `core`)

Skills auto-trigger when a task matches their description.

- **ralph** — generate an autonomous bash loop for any task (research, specs, implementation)
- **improve-claude-md** — rewrite a CLAUDE.md using `<important if>` blocks for instruction adherence
- **create-research** — document codebase as-is, with a thoughts/questions directory for historical context
- **create-research-questions** — analyze a ticket to generate targeted research questions before investigation
- **iterate-research-questions** — refine research questions and surface follow-up ambiguities

## Subagents (9, in `core`)

Specialist research personas. Used by skills, slash commands, and directly via the `Agent` tool.

- **codebase-locator** — super grep/glob; locates files, directories, components by description
- **codebase-analyzer** — deep dive on implementation details for specific components
- **codebase-pattern-finder** — finds similar implementations and concrete code examples
- **thoughts-locator** — discovers relevant documents in `thoughts/` metadata directory
- **thoughts-analyzer** — research equivalent of codebase-analyzer for `thoughts/`
- **deep-research** — adaptive external knowledge gathering
- **deep-research-agent** — comprehensive research with adaptive strategies
- **repo-index** — repository indexing and codebase briefing
- **web-search-researcher** — modern, web-only information

## Slash commands

### Core workflow (14)

| Command | Purpose |
|---------|---------|
| `commit`, `ci_commit` | Create git commits with user approval |
| `describe_pr`, `describe_pr_nt`, `ci_describe_pr` | Generate PR descriptions following repo templates |
| `linear` | Manage Linear tickets — create, update, comment |
| `debug` | Debug by investigating logs, DB state, git history |
| `local_review` | Set up worktree for reviewing a colleague's branch |
| `create_worktree` | Create an isolated worktree |
| `create_handoff`, `resume_handoff` | Snapshot and resume work across sessions |
| `founder_mode` | Create Linear ticket and PR for experimental features |
| `validate_plan` | Verify implementation against plan and success criteria |
| `implement_plan` | Implement a technical plan from `thoughts/shared/plans` |

### QRSPI (11)

| Phase | Commands |
|-------|----------|
| Question  | `_create_research_questions`, `_iterate_research_questions` |
| Research  | `_create_research`, `_iterate_research` |
| Spec      | `create_design_discussion`, `iterate_design_discussion`, `create_structure_outline`, `iterate_structure_outline` |
| Plan      | `create_plan`, `iterate_plan` |
| Worktree  | `create_worktree` |

Underscore-prefixed commands are invoked indirectly by their non-prefixed siblings — not directly by the user.

## Repo layout

```
.claude-plugin/marketplace.json   # marketplace metadata listing both plugins
core/                             # plugin: skills + agents + utility commands
  .claude-plugin/plugin.json
  skills/  agents/  commands/
qrspi/                            # plugin: QRSPI workflow commands
  .claude-plugin/plugin.json
  commands/
.claude/                          # reference snapshot of the maintainer's settings
.gemini/                          # adapter dir (TOML translations + skills symlink)
.codex/                           # adapter placeholder (installer flattens prompts)
statusline/statusline.sh          # context/cost/rate-limit statusbar
hooks/                            # placeholder for future hooks
docs/                             # per-tool setup guides
bin/
  install                         # mini-agent installer
  build-gemini-commands           # regenerates .gemini/commands/*.toml from sources
```

## Editing

Canonical content lives in `core/skills/`, `core/agents/`, `core/commands/`, `qrspi/commands/`. The `.claude/`, `.gemini/`, and `.codex/` dirs are adapters that point back at those — don't hand-edit them.

After editing slash command markdown, regenerate the Gemini TOML files:

```bash
python3 bin/build-gemini-commands
```

See [`AGENTS.md`](./AGENTS.md) for repo conventions, skill anatomy, and orchestration rules.

## License

MIT.
