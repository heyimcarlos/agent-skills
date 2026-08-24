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
  misc/           # cross-cutting productivity and writing skills
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

### Install

```bash
npx skills@latest add heyimcarlos/agent-skills
```

All shared global skills with external lineage differed from their current upstream packages and now ship here as Codex-maintained forks. The [upstream audit](./UPSTREAMS.md) records the comparison commits, per-skill results, and required license notices.

### Skills maintained here

These skills ship from this repository. "Global" means the skill was also present in `~/.agents/skills` when this inventory was taken.

| Skill | Group | Global |
|---|---|---|
| [`architect`](./skills/engineering/architect/SKILL.md) | Engineering | Yes |
| [`arena`](./skills/engineering/arena/SKILL.md) | Engineering | Yes |
| [`blast-radius`](./skills/engineering/blast-radius/SKILL.md) | Engineering | Yes |
| [`code-review`](./skills/engineering/code-review/SKILL.md) | Engineering | Yes |
| [`codebase-design`](./skills/engineering/codebase-design/SKILL.md) | Engineering | Yes |
| [`commit`](./skills/engineering/commit/SKILL.md) | Engineering | No |
| [`debug`](./skills/engineering/debug/SKILL.md) | Engineering | No |
| [`defragance`](./skills/engineering/defragance/SKILL.md) | Engineering | No |
| [`deslop`](./skills/engineering/deslop/SKILL.md) | Engineering | Yes |
| [`diagnosing-bugs`](./skills/engineering/diagnosing-bugs/SKILL.md) | Engineering | Yes |
| [`domain-modeling`](./skills/engineering/domain-modeling/SKILL.md) | Engineering | Yes |
| [`effect`](./skills/engineering/effect/SKILL.md) | Engineering | Yes |
| [`find-comparables`](./skills/engineering/find-comparables/SKILL.md) | Engineering | No |
| [`get-pr-comments`](./skills/engineering/get-pr-comments/SKILL.md) | Engineering | No |
| [`grill-with-docs`](./skills/engineering/grill-with-docs/SKILL.md) | Engineering | Yes |
| [`how`](./skills/engineering/how/SKILL.md) | Engineering | Yes |
| [`implement`](./skills/engineering/implement/SKILL.md) | Engineering | Yes |
| [`improve-codebase-architecture`](./skills/engineering/improve-codebase-architecture/SKILL.md) | Engineering | Yes |
| [`interrogate`](./skills/engineering/interrogate/SKILL.md) | Engineering | Yes |
| [`principle-boundary-discipline`](./skills/engineering/principle-boundary-discipline/SKILL.md) | Engineering | Yes |
| [`principle-encode-lessons-in-structure`](./skills/engineering/principle-encode-lessons-in-structure/SKILL.md) | Engineering | Yes |
| [`principle-exhaust-the-design-space`](./skills/engineering/principle-exhaust-the-design-space/SKILL.md) | Engineering | Yes |
| [`principle-fix-root-causes`](./skills/engineering/principle-fix-root-causes/SKILL.md) | Engineering | Yes |
| [`principle-foundational-thinking`](./skills/engineering/principle-foundational-thinking/SKILL.md) | Engineering | Yes |
| [`principle-guard-the-context-window`](./skills/engineering/principle-guard-the-context-window/SKILL.md) | Engineering | Yes |
| [`principle-laziness-protocol`](./skills/engineering/principle-laziness-protocol/SKILL.md) | Engineering | Yes |
| [`principle-make-operations-idempotent`](./skills/engineering/principle-make-operations-idempotent/SKILL.md) | Engineering | Yes |
| [`principle-minimize-reader-load`](./skills/engineering/principle-minimize-reader-load/SKILL.md) | Engineering | Yes |
| [`principle-outcome-oriented-execution`](./skills/engineering/principle-outcome-oriented-execution/SKILL.md) | Engineering | Yes |
| [`principle-prove-it-works`](./skills/engineering/principle-prove-it-works/SKILL.md) | Engineering | Yes |
| [`principle-redesign-from-first-principles`](./skills/engineering/principle-redesign-from-first-principles/SKILL.md) | Engineering | Yes |
| [`principle-separate-before-serializing-shared-state`](./skills/engineering/principle-separate-before-serializing-shared-state/SKILL.md) | Engineering | Yes |
| [`principle-sequence-verifiable-units`](./skills/engineering/principle-sequence-verifiable-units/SKILL.md) | Engineering | Yes |
| [`principle-subtract-before-you-add`](./skills/engineering/principle-subtract-before-you-add/SKILL.md) | Engineering | Yes |
| [`prototype`](./skills/engineering/prototype/SKILL.md) | Engineering | Yes |
| [`research`](./skills/engineering/research/SKILL.md) | Engineering | Yes |
| [`resolving-merge-conflicts`](./skills/engineering/resolving-merge-conflicts/SKILL.md) | Engineering | Yes |
| [`review-and-ship`](./skills/engineering/review-and-ship/SKILL.md) | Engineering | No |
| [`setup-matt-pocock-skills`](./skills/engineering/setup-matt-pocock-skills/SKILL.md) | Engineering | Yes |
| [`swarm`](./skills/engineering/swarm/SKILL.md) | Engineering | Yes |
| [`systems-lab-ui`](./skills/engineering/systems-lab-ui/SKILL.md) | Engineering | Yes |
| [`tdd`](./skills/engineering/tdd/SKILL.md) | Engineering | Yes |
| [`thermo-nuclear-code-quality-review`](./skills/engineering/thermo-nuclear-code-quality-review/SKILL.md) | Engineering | Yes |
| [`to-spec`](./skills/engineering/to-spec/SKILL.md) | Engineering | Yes |
| [`to-tickets`](./skills/engineering/to-tickets/SKILL.md) | Engineering | Yes |
| [`triage`](./skills/engineering/triage/SKILL.md) | Engineering | Yes |
| [`typescript-best-practices`](./skills/engineering/typescript-best-practices/SKILL.md) | Engineering | Yes |
| [`wayfinder`](./skills/engineering/wayfinder/SKILL.md) | Engineering | Yes |
| [`why`](./skills/engineering/why/SKILL.md) | Engineering | Yes |
| [`wizard`](./skills/engineering/wizard/SKILL.md) | Engineering | Yes |
| [`bro`](./skills/misc/bro/SKILL.md) | Misc | Yes |
| [`grill-me`](./skills/misc/grill-me/SKILL.md) | Misc | Yes |
| [`grilling`](./skills/misc/grilling/SKILL.md) | Misc | Yes |
| [`handoff`](./skills/misc/handoff/SKILL.md) | Misc | Yes |
| [`recall`](./skills/misc/recall/SKILL.md) | Misc | Yes |
| [`show-me`](./skills/misc/show-me/SKILL.md) | Misc | Yes |
| [`show-me-your-work`](./skills/misc/show-me-your-work/SKILL.md) | Misc | Yes |
| [`teach`](./skills/misc/teach/SKILL.md) | Misc | Yes |
| [`technical-writing`](./skills/misc/technical-writing/SKILL.md) | Misc | Yes |
| [`to-questionnaire`](./skills/misc/to-questionnaire/SKILL.md) | Misc | Yes |
| [`unslop`](./skills/misc/unslop/SKILL.md) | Misc | Yes |
| [`writing-for-agents`](./skills/misc/writing-for-agents/SKILL.md) | Misc | Yes |
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
