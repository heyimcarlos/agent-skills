# Claude Code setup

Install via the Claude Code plugin marketplace.

## Add the marketplace

From inside Claude Code:

```
/plugin marketplace add heyimcarlos/agent-skills
```

This registers `agent-skills` as a known marketplace pointing at `https://github.com/heyimcarlos/agent-skills`.

## Install plugins

```
/plugin install core@agent-skills
/plugin install qrspi@agent-skills    # optional
```

## What you get

| Plugin | Surfaces | Contents |
|--------|----------|----------|
| `core` | `/core:*` slash commands · auto-triggered skills | 2 skills (ralph, improve-claude-md) · 14 utility commands (commit, describe_pr, debug, linear, worktree, handoff, founder_mode, validate_plan, implement_plan, plus CI variants) |
| `qrspi` | `qrspi:*` skills (explicitly invoked) · subagents via Agent tool | 11 skills implementing the Question → Research → Spec → Plan → Implement workflow · 6 research subagents (codebase + thoughts + web) |

`core` skills auto-trigger by description match. QRSPI skills set `disable-model-invocation: true` and are invoked explicitly per phase. Subagents are available via the Agent tool. Slash commands appear in `/` menu autocomplete.

## Settings reference

The repo's `.claude/settings.json` is a reference snapshot of the maintainer's settings (env vars, statusline, marketplaces, enabled plugins). It is **not** installed by the marketplace — copy what you want into your own `~/.claude/settings.json`. The statusline script lives at `statusline/statusline.sh` if you want to use it.

## Updating

```
/plugin update core@agent-skills
/plugin update qrspi@agent-skills
```

## Uninstalling

```
/plugin uninstall core@agent-skills
/plugin uninstall qrspi@agent-skills
/plugin marketplace remove agent-skills
```
