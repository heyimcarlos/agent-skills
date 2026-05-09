# Getting started

This repo is a marketplace + adapter bundle. Pick your tool, run one command.

| Tool | Command |
|------|---------|
| Claude Code | `/plugin marketplace add heyimcarlos/agent-skills` then `/plugin install core@agent-skills` |
| Gemini CLI | `git clone https://github.com/heyimcarlos/agent-skills && agent-skills/bin/install gemini --user` |
| OpenAI Codex CLI | `git clone https://github.com/heyimcarlos/agent-skills && agent-skills/bin/install codex --user` |

Per-tool details: [claude-setup](./claude-setup.md) · [gemini-setup](./gemini-setup.md) · [codex-setup](./codex-setup.md)

## What you get

**Skills (5)** — auto-trigger by task match
- `ralph` — generate an autonomous bash loop for any task
- `improve-claude-md` — rewrite CLAUDE.md with `<important if>` blocks
- `create-research`, `create-research-questions`, `iterate-research-questions` — research helpers used by QRSPI

**Subagents (9)**
- `codebase-analyzer`, `codebase-locator`, `codebase-pattern-finder`
- `deep-research`, `deep-research-agent`, `repo-index`
- `thoughts-analyzer`, `thoughts-locator`, `web-search-researcher`

**Workflow commands (`core` plugin, 14)**
- `commit`, `ci_commit`
- `describe_pr`, `describe_pr_nt`, `ci_describe_pr`
- `linear`, `debug`, `local_review`
- `create_worktree`, `create_handoff`, `resume_handoff`
- `founder_mode`, `validate_plan`, `implement_plan`

**QRSPI commands (`qrspi` plugin, 11)**
- Question: `_create_research_questions`, `_iterate_research_questions`
- Research: `_create_research`, `_iterate_research`
- Spec: `create_design_discussion`, `iterate_design_discussion`, `create_structure_outline`, `iterate_structure_outline`
- Plan: `create_plan`, `iterate_plan`
- Worktree: `create_worktree`

Underscore-prefixed commands are invoked indirectly by their non-prefixed siblings, not directly by the user.
