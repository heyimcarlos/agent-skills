# Getting started

This repo is a marketplace + adapter bundle. Pick your tool, run one command.

| Tool | Command |
|------|---------|
| Claude Code | `/plugin marketplace add heyimcarlos/agent-skills` then `/plugin install core@agent-skills` |
| Gemini CLI | `git clone https://github.com/heyimcarlos/agent-skills && agent-skills/bin/install gemini --user` |
| OpenAI Codex CLI | `git clone https://github.com/heyimcarlos/agent-skills && agent-skills/bin/install codex --user` |

Per-tool details: [claude-setup](./claude-setup.md) · [gemini-setup](./gemini-setup.md) · [codex-setup](./codex-setup.md)

## What you get

**Skills (13)**

`core` (2) — auto-trigger by task description match
- `ralph` — generate an autonomous bash loop for any task
- `improve-claude-md` — rewrite CLAUDE.md with `<important if>` blocks

`qrspi` (11) — QRSPI workflow, explicitly invoked (`disable-model-invocation: true`)
- Question: `create-research-questions`, `iterate-research-questions`
- Research: `create-research`, `iterate-research`
- Spec: `create-design-discussion`, `iterate-design-discussion`, `create-structure-outline`, `iterate-structure-outline`
- Plan: `create-plan`, `iterate-plan`
- Implement: `create-worktree`

**Subagents (6, in `qrspi`)**
- `codebase-analyzer`, `codebase-locator`, `codebase-pattern-finder`
- `thoughts-analyzer`, `thoughts-locator`
- `web-search-researcher`

**Workflow commands (`core` plugin, 14)**
- `commit`, `ci_commit`
- `describe_pr`, `describe_pr_nt`, `ci_describe_pr`
- `linear`, `debug`, `local_review`
- `create_worktree`, `create_handoff`, `resume_handoff`
- `founder_mode`, `validate_plan`, `implement_plan`
