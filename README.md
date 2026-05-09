# agent-skills

**Skills, subagents, and slash commands for AI coding agents — one source of truth, installed natively in Claude Code, Gemini CLI, and OpenAI Codex CLI.**

Skills, agents, and commands encode the workflows a senior engineer follows: research before coding, spec before plan, plan before implement, verify before ship. Packaged so the same workflows trigger across every tool you drive.

## Two plugins

| Plugin | What it ships |
|--------|---------------|
| `core`  | 2 skills (ralph, improve-claude-md) · 14 workflow commands (commit, describe_pr, debug, linear, worktree, handoff, founder_mode, validate_plan, implement_plan, plus CI variants) |
| `qrspi` | 11 skills implementing the **Q**uestion → **R**esearch → **S**pec → **P**lan → **I**mplement workflow · 6 research subagents (codebase + thoughts + web) |

## QRSPI workflow

Each stage is an explicit skill (with an `iterate-*` sibling for surgical adjustments without restarting the workflow):

| Stage | Skill | Purpose |
|-------|-------|---------|
| Question  | `qrspi:create-research-questions` | Turn a ticket into targeted questions before any code is read |
| Research  | `qrspi:create-research` | Document the codebase as-is, grounded in real files |
| Spec      | `qrspi:create-design-discussion` → `qrspi:create-structure-outline` | Synthesize research into architectural decisions and a phased outline |
| Plan      | `qrspi:create-plan` | Convert outline into a rigid step-by-step plan with dual verification |
| Implement | `qrspi:create-worktree` | Launch an isolated implementation session from an approved plan |

QRSPI skills set `disable-model-invocation: true` — the human invokes each phase deliberately rather than letting the model auto-trigger them.

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

## Skills

### `core` (2) — auto-trigger by task description

- **ralph** — generate an autonomous bash loop for any task (research, specs, implementation)
- **improve-claude-md** — rewrite a CLAUDE.md using `<important if>` blocks for instruction adherence

### `qrspi` (11) — explicitly invoked QRSPI workflow

| Phase | Skills |
|-------|--------|
| Question  | `create-research-questions`, `iterate-research-questions` |
| Research  | `create-research`, `iterate-research` |
| Spec      | `create-design-discussion`, `iterate-design-discussion`, `create-structure-outline`, `iterate-structure-outline` |
| Plan      | `create-plan`, `iterate-plan` |
| Implement | `create-worktree` |

## Subagents (6, in `qrspi`)

Specialist research personas. Used by skills and directly via the `Agent` tool.

- **codebase-locator** — super grep/glob; locates files, directories, components by description
- **codebase-analyzer** — deep dive on implementation details for specific components
- **codebase-pattern-finder** — finds similar implementations and concrete code examples
- **thoughts-locator** — discovers relevant documents in `thoughts/` metadata directory
- **thoughts-analyzer** — research equivalent of codebase-analyzer for `thoughts/`
- **web-search-researcher** — modern, web-only information

## Slash commands (`core`, 14)

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

The QRSPI workflow used to ship as slash commands; it now ships as skills under `qrspi/skills/` instead.

## Repo layout

```
.claude-plugin/marketplace.json   # marketplace metadata listing both plugins
core/                             # plugin: utility skills + slash commands
  .claude-plugin/plugin.json
  skills/  commands/
qrspi/                            # plugin: QRSPI workflow skills + research subagents
  .claude-plugin/plugin.json
  skills/  agents/
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

Canonical content lives in `core/skills/`, `core/commands/`, `qrspi/skills/`, `qrspi/agents/`. The `.claude/`, `.gemini/`, and `.codex/` dirs are adapters that point back at those — don't hand-edit them.

After editing any slash command markdown under `core/commands/`, regenerate the Gemini TOML files:

```bash
python3 bin/build-gemini-commands
```

See [`AGENTS.md`](./AGENTS.md) for repo conventions, skill anatomy, and orchestration rules.

## License

MIT.
