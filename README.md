# agent skills

Skills and subagents for AI coding agents — one source of truth, installed natively in Claude Code, Gemini CLI, OpenAI Codex CLI, and 50+ other agent CLIs through [`vercel-labs/skills`](https://github.com/vercel-labs/skills).

Skills encode the workflows a senior engineer follows: research before coding, spec before plan, plan before implement, verify before ship. Packaged so the same workflows trigger across every tool you drive.

## Quickstart

```bash
npx skills@latest add heyimcarlos/agent-skills
```

Pick which skills to install and which agents to install them into. The CLI auto-detects supported agent CLIs on your machine and writes `SKILL.md` files into each one's native skill path.

### Claude Code (full plugin)

`npx skills add` installs skills only. To also pick up the research subagents in `agents/`, install via Claude Code's plugin marketplace:

```
/plugin marketplace add heyimcarlos/agent-skills
/plugin install agent-skills@agent-skills
```

## Layout

```
skills/
  engineering/    # daily code work — git, PRs, planning, implementation, debug
  qrspi/          # the QRSPI workflow as prefixed qrspi-* setup, create, and iterate skills
  misc/           # reserved for rarely-used skills
agents/           # Claude Code subagents (codebase + thoughts + web research)
.claude-plugin/
  plugin.json     # single-plugin manifest read by `npx skills` and Claude Code
```

## QRSPI workflow

Each stage is its own skill, with an `iterate-*` sibling for surgical adjustments without restarting the workflow.

| Stage | Skill | Purpose |
|-------|-------|---------|
| Question  | [`qrspi-create-research-questions`](./skills/qrspi/qrspi-create-research-questions/SKILL.md) | Turn a ticket into targeted questions before any code is read |
| Research  | [`qrspi-create-research`](./skills/qrspi/qrspi-create-research/SKILL.md) | Document the codebase as-is, grounded in real files |
| Spec      | [`qrspi-create-design-discussion`](./skills/qrspi/qrspi-create-design-discussion/SKILL.md) → [`qrspi-create-structure-outline`](./skills/qrspi/qrspi-create-structure-outline/SKILL.md) | Synthesize research into architectural decisions and a phased outline |
| Plan      | [`qrspi-create-plan`](./skills/qrspi/qrspi-create-plan/SKILL.md) | Convert outline into a rigid step-by-step plan with dual verification |
| Implement | [`qrspi-create-worktree`](./skills/qrspi/qrspi-create-worktree/SKILL.md) | Launch an isolated implementation session from an approved plan |
| Setup     | [`qrspi-setup`](./skills/qrspi/qrspi-setup/SKILL.md) | Initialize the local `thoughts/` workspace used by the QRSPI skills |

QRSPI skills use a `qrspi-` name prefix so they are easy to find and select during installation. They set `disable-model-invocation: true` — the human invokes each phase deliberately rather than letting the model auto-trigger them.

Every doc-producing QRSPI skill (all of the above except `qrspi-create-worktree`) accepts an optional `--output=html` flag. When present, the skill emits a reveal.js slide deck alongside the canonical markdown — color, SVG diagrams, annotated code, comparison tables. Iterate skills detect the sibling `.html` and refresh both. See [`skills/qrspi/HTML-OUTPUT.md`](./skills/qrspi/HTML-OUTPUT.md) for the conventions and per-phase slide structures.

## Complete skill inventory

This inventory compares the repository with the shared global skill directory at `~/.agents/skills`, Codex's built-in system skills, and the plugin-managed skills available in Codex. It was last checked on 2026-08-24.

### Install sources

```bash
# Skills maintained in this repository
npx skills@latest add heyimcarlos/agent-skills

# Matt Pocock's engineering and productivity skills
npx skills@latest add mattpocock/skills

# Effect v4 skill
npx skills@latest add kitlangton/skills --skill effect

# HumanLayer's visual explanation skill
npx skills@latest add humanlayer/skills --skill show-me
```

The pstack skills come from Cursor's [`pstack`](https://github.com/cursor/plugins/tree/main/pstack) plugin. Install the plugin in Cursor with `/add-plugin pstack`. Codex-managed skills come from the named plugin and should be installed or updated through Codex's Plugins screen, not copied from `~/.codex/plugins/cache`.

### Skills maintained here

These skills ship from this repository. "Global" means the skill was also present in `~/.agents/skills` when this inventory was taken.

| Skill | Group | Global |
|---|---|---|
| [`commit`](./skills/engineering/commit/SKILL.md) | Engineering | No |
| [`debug`](./skills/engineering/debug/SKILL.md) | Engineering | No |
| [`defragance`](./skills/engineering/defragance/SKILL.md) | Engineering | No |
| [`deslop`](./skills/engineering/deslop/SKILL.md) | Engineering | Yes |
| [`find-comparables`](./skills/engineering/find-comparables/SKILL.md) | Engineering | No |
| [`get-pr-comments`](./skills/engineering/get-pr-comments/SKILL.md) | Engineering | No |
| [`review-and-ship`](./skills/engineering/review-and-ship/SKILL.md) | Engineering | No |
| [`systems-lab-ui`](./skills/engineering/systems-lab-ui/SKILL.md) | Engineering | Yes |
| [`thermo-nuclear-code-quality-review`](./skills/engineering/thermo-nuclear-code-quality-review/SKILL.md) | Engineering | Yes |
| [`qrspi-create-design-discussion`](./skills/qrspi/qrspi-create-design-discussion/SKILL.md) | QRSPI | No |
| [`qrspi-create-plan`](./skills/qrspi/qrspi-create-plan/SKILL.md) | QRSPI | No |
| [`qrspi-create-research`](./skills/qrspi/qrspi-create-research/SKILL.md) | QRSPI | No |
| [`qrspi-create-research-questions`](./skills/qrspi/qrspi-create-research-questions/SKILL.md) | QRSPI | No |
| [`qrspi-create-structure-outline`](./skills/qrspi/qrspi-create-structure-outline/SKILL.md) | QRSPI | No |
| [`qrspi-create-worktree`](./skills/qrspi/qrspi-create-worktree/SKILL.md) | QRSPI | No |
| [`qrspi-iterate-design-discussion`](./skills/qrspi/qrspi-iterate-design-discussion/SKILL.md) | QRSPI | No |
| [`qrspi-iterate-plan`](./skills/qrspi/qrspi-iterate-plan/SKILL.md) | QRSPI | No |
| [`qrspi-iterate-research`](./skills/qrspi/qrspi-iterate-research/SKILL.md) | QRSPI | No |
| [`qrspi-iterate-research-questions`](./skills/qrspi/qrspi-iterate-research-questions/SKILL.md) | QRSPI | No |
| [`qrspi-iterate-structure-outline`](./skills/qrspi/qrspi-iterate-structure-outline/SKILL.md) | QRSPI | No |
| [`qrspi-setup`](./skills/qrspi/qrspi-setup/SKILL.md) | QRSPI | No |

### Global skills maintained elsewhere

These 53 skills are installed in `~/.agents/skills` but owned by another repository. Keeping their source here would create stale forks, so this repository records where they come from instead.

| Skill | Install source |
|---|---|
| `architect` | [`pstack`](https://github.com/cursor/plugins/tree/main/pstack/skills/architect) |
| `arena` | [`pstack`](https://github.com/cursor/plugins/tree/main/pstack/skills/arena) |
| `blast-radius` | [`pstack`](https://github.com/cursor/plugins/tree/main/pstack/skills/blast-radius) |
| `bro` | [`pstack`](https://github.com/cursor/plugins/tree/main/pstack/skills/bro) |
| `code-review` | [`mattpocock/skills`](https://github.com/mattpocock/skills/tree/main/skills/engineering/code-review) |
| `codebase-design` | [`mattpocock/skills`](https://github.com/mattpocock/skills/tree/main/skills/engineering/codebase-design) |
| `diagnosing-bugs` | [`mattpocock/skills`](https://github.com/mattpocock/skills/tree/main/skills/engineering/diagnosing-bugs) |
| `domain-modeling` | [`mattpocock/skills`](https://github.com/mattpocock/skills/tree/main/skills/engineering/domain-modeling) |
| `effect` | [`kitlangton/skills`](https://github.com/kitlangton/skills/tree/main/skills/effect) |
| `grill-me` | [`mattpocock/skills`](https://github.com/mattpocock/skills/tree/main/skills/productivity/grill-me) |
| `grill-with-docs` | [`mattpocock/skills`](https://github.com/mattpocock/skills/tree/main/skills/engineering/grill-with-docs) |
| `grilling` | [`mattpocock/skills`](https://github.com/mattpocock/skills/tree/main/skills/productivity/grilling) |
| `handoff` | [`mattpocock/skills`](https://github.com/mattpocock/skills/tree/main/skills/productivity/handoff) |
| `how` | [`pstack`](https://github.com/cursor/plugins/tree/main/pstack/skills/how) |
| `implement` | [`mattpocock/skills`](https://github.com/mattpocock/skills/tree/main/skills/engineering/implement) |
| `improve-codebase-architecture` | [`mattpocock/skills`](https://github.com/mattpocock/skills/tree/main/skills/engineering/improve-codebase-architecture) |
| `interrogate` | [`pstack`](https://github.com/cursor/plugins/tree/main/pstack/skills/interrogate) |
| `principle-boundary-discipline` | [`pstack`](https://github.com/cursor/plugins/tree/main/pstack/skills/principle-boundary-discipline) |
| `principle-encode-lessons-in-structure` | [`pstack`](https://github.com/cursor/plugins/tree/main/pstack/skills/principle-encode-lessons-in-structure) |
| `principle-exhaust-the-design-space` | [`pstack`](https://github.com/cursor/plugins/tree/main/pstack/skills/principle-exhaust-the-design-space) |
| `principle-fix-root-causes` | [`pstack`](https://github.com/cursor/plugins/tree/main/pstack/skills/principle-fix-root-causes) |
| `principle-foundational-thinking` | [`pstack`](https://github.com/cursor/plugins/tree/main/pstack/skills/principle-foundational-thinking) |
| `principle-guard-the-context-window` | [`pstack`](https://github.com/cursor/plugins/tree/main/pstack/skills/principle-guard-the-context-window) |
| `principle-laziness-protocol` | [`pstack`](https://github.com/cursor/plugins/tree/main/pstack/skills/principle-laziness-protocol) |
| `principle-make-operations-idempotent` | [`pstack`](https://github.com/cursor/plugins/tree/main/pstack/skills/principle-make-operations-idempotent) |
| `principle-minimize-reader-load` | [`pstack`](https://github.com/cursor/plugins/tree/main/pstack/skills/principle-minimize-reader-load) |
| `principle-outcome-oriented-execution` | [`pstack`](https://github.com/cursor/plugins/tree/main/pstack/skills/principle-outcome-oriented-execution) |
| `principle-prove-it-works` | [`pstack`](https://github.com/cursor/plugins/tree/main/pstack/skills/principle-prove-it-works) |
| `principle-redesign-from-first-principles` | [`pstack`](https://github.com/cursor/plugins/tree/main/pstack/skills/principle-redesign-from-first-principles) |
| `principle-separate-before-serializing-shared-state` | [`pstack`](https://github.com/cursor/plugins/tree/main/pstack/skills/principle-separate-before-serializing-shared-state) |
| `principle-sequence-verifiable-units` | [`pstack`](https://github.com/cursor/plugins/tree/main/pstack/skills/principle-sequence-verifiable-units) |
| `principle-subtract-before-you-add` | [`pstack`](https://github.com/cursor/plugins/tree/main/pstack/skills/principle-subtract-before-you-add) |
| `prototype` | [`mattpocock/skills`](https://github.com/mattpocock/skills/tree/main/skills/engineering/prototype) |
| `recall` | [`pstack`](https://github.com/cursor/plugins/tree/main/pstack/skills/recall) |
| `research` | [`mattpocock/skills`](https://github.com/mattpocock/skills/tree/main/skills/engineering/research) |
| `resolving-merge-conflicts` | [`mattpocock/skills`](https://github.com/mattpocock/skills/tree/main/skills/engineering/resolving-merge-conflicts) |
| `setup-matt-pocock-skills` | [`mattpocock/skills`](https://github.com/mattpocock/skills/tree/main/skills/engineering/setup-matt-pocock-skills) |
| `show-me` | [`humanlayer/skills`](https://github.com/humanlayer/skills/tree/main/skills/show-me) |
| `show-me-your-work` | [`pstack`](https://github.com/cursor/plugins/tree/main/pstack/skills/show-me-your-work) |
| `swarm` | [`pstack`](https://github.com/cursor/plugins/tree/main/pstack/skills/swarm) |
| `tdd` | [`mattpocock/skills`](https://github.com/mattpocock/skills/tree/main/skills/engineering/tdd) |
| `teach` | [`mattpocock/skills`](https://github.com/mattpocock/skills/tree/main/skills/productivity/teach) |
| `technical-writing` | [`pstack`](https://github.com/cursor/plugins/tree/main/pstack/skills/technical-writing) |
| `to-questionnaire` | [`mattpocock/skills`](https://github.com/mattpocock/skills/tree/main/skills/productivity/to-questionnaire) |
| `to-spec` | [`mattpocock/skills`](https://github.com/mattpocock/skills/tree/main/skills/engineering/to-spec) |
| `to-tickets` | [`mattpocock/skills`](https://github.com/mattpocock/skills/tree/main/skills/engineering/to-tickets) |
| `triage` | [`mattpocock/skills`](https://github.com/mattpocock/skills/tree/main/skills/engineering/triage) |
| `typescript-best-practices` | [`pstack`](https://github.com/cursor/plugins/tree/main/pstack/skills/typescript-best-practices) |
| `unslop` | [`pstack`](https://github.com/cursor/plugins/tree/main/pstack/skills/unslop) |
| `wayfinder` | [`mattpocock/skills`](https://github.com/mattpocock/skills/tree/main/skills/engineering/wayfinder) |
| `why` | [`pstack`](https://github.com/cursor/plugins/tree/main/pstack/skills/why) |
| `wizard` | [`mattpocock/skills`](https://github.com/mattpocock/skills/tree/main/skills/engineering/wizard) |
| `writing-for-agents` | [`mattpocock/skills`](https://github.com/mattpocock/skills/tree/main/skills/productivity/writing-for-agents) |

### Codex-managed skills

These skills were available through Codex's built-in skill set or globally managed plugins when this inventory was taken. Codex or the named plugin owns the files and updates them as a unit.

| Skill | Install from |
|---|---|
| `browser:control-in-app-browser` | Browser plugin |
| `chrome:control-chrome` | Chrome plugin |
| `cloudflare:agents-sdk` | Cloudflare plugin |
| `cloudflare:building-ai-agent-on-cloudflare` | Cloudflare plugin |
| `cloudflare:building-mcp-server-on-cloudflare` | Cloudflare plugin |
| `cloudflare:cloudflare` | Cloudflare plugin |
| `cloudflare:durable-objects` | Cloudflare plugin |
| `cloudflare:sandbox-sdk` | Cloudflare plugin |
| `cloudflare:web-perf` | Cloudflare plugin |
| `cloudflare:workers-best-practices` | Cloudflare plugin |
| `cloudflare:wrangler` | Cloudflare plugin |
| `deep-research-work:deep-research` | Deep research plugin |
| `documents:documents` | Documents plugin |
| `imagegen` | Codex built-in |
| `openai-docs` | Codex built-in |
| `pdf:pdf` | PDF plugin |
| `plugin-creator` | Codex built-in |
| `plugin-management:plugin-management` | Plugin management plugin |
| `presentations:Presentations` | Presentations plugin |
| `review-agent` | Codex built-in |
| `sites:sites-building` | Sites plugin |
| `sites:sites-hosting` | Sites plugin |
| `skill-creator` | Codex built-in |
| `skill-installer` | Codex built-in |
| `spreadsheets:excel-live-control` | Spreadsheets plugin |
| `spreadsheets:Spreadsheets` | Spreadsheets plugin |
| `template-creator:template-creator` | Template creator plugin |
| `visualize:visualize` | Visualize plugin |

### Subagents (Claude Code only)

Specialist research personas in [`agents/`](./agents/), invoked from skills via the `Agent` tool. Only installed by the Claude Code plugin path; `npx skills` doesn't install subagents into other CLIs (they don't have the concept).

- [**codebase-locator**](./agents/codebase-locator.md) — super grep/glob; locates files, directories, and components by description.
- [**codebase-analyzer**](./agents/codebase-analyzer.md) — deep dive on implementation details for specific components.
- [**codebase-pattern-finder**](./agents/codebase-pattern-finder.md) — finds similar implementations and concrete code examples.
- [**thoughts-locator**](./agents/thoughts-locator.md) — discovers relevant documents in the `thoughts/` metadata directory.
- [**thoughts-analyzer**](./agents/thoughts-analyzer.md) — research equivalent of codebase-analyzer for `thoughts/`.
- [**web-search-researcher**](./agents/web-search-researcher.md) — modern, web-only information.

## Editing

Canonical content lives in `skills/<bucket>/<name>/SKILL.md` and `agents/<name>.md`. After adding or removing a skill, update [`.claude-plugin/plugin.json`](./.claude-plugin/plugin.json) and the reference section above.

See [`AGENTS.md`](./AGENTS.md) (alias `CLAUDE.md`) for repo conventions, skill anatomy, and orchestration rules.

## License

MIT.
