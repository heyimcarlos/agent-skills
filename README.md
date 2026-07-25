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

## Reference

### Engineering

Code-work skills — git, PRs, planning, implementation, debug.

- [**commit**](./skills/engineering/commit/SKILL.md) — Create focused git commits with user approval
- [**debug**](./skills/engineering/debug/SKILL.md) — Debug issues by investigating logs, database state, and git history.
- [**defragance**](./skills/engineering/defragance/SKILL.md) — Distill the taste, idioms, and operating habits of strong comparables into project guidance.
- [**deslop**](./skills/engineering/deslop/SKILL.md) — Remove AI-generated code slop and clean up code style.
- [**find-comparables**](./skills/engineering/find-comparables/SKILL.md) — Research mature comparable repositories, language standards, and books to extract best practices for a project or rewrite.
- [**get-pr-comments**](./skills/engineering/get-pr-comments/SKILL.md) — Fetch and summarize review comments from the active pull request.
- [**review-and-ship**](./skills/engineering/review-and-ship/SKILL.md) — Review the current branch for bugs, intent fit, and test coverage; run or write tests; commit focused work; open or update a PR.
- [**systems-lab-ui**](./skills/engineering/systems-lab-ui/SKILL.md) — Build interactive operational canvases for architecture, workflows, queues, agents, delivery, and load.
- [**thermo-nuclear-code-quality-review**](./skills/engineering/thermo-nuclear-code-quality-review/SKILL.md) — Run an extremely strict maintainability review for abstraction quality, giant files, and spaghetti-condition growth.

### Misc

Rarely-used skills for external tools and specialized workflows.

- [**hermes-tweet**](./skills/misc/hermes-tweet/SKILL.md) - Use Hermes Tweet with Hermes Agent for X/Twitter research, social listening, and approval-gated publishing.

### QRSPI

The Question → Research → Spec → Plan → Implement workflow as explicit skills.

- [**qrspi-create-research-questions**](./skills/qrspi/qrspi-create-research-questions/SKILL.md) — Analyze a ticket to generate targeted research questions before any codebase investigation begins.
- [**qrspi-iterate-research-questions**](./skills/qrspi/qrspi-iterate-research-questions/SKILL.md) — Refine research questions by adding, removing, or reframing them based on user feedback.
- [**qrspi-create-research**](./skills/qrspi/qrspi-create-research/SKILL.md) — Document codebase as-is using parallel sub-agents, guided only by the research questions document.
- [**qrspi-iterate-research**](./skills/qrspi/qrspi-iterate-research/SKILL.md) — Deepen or correct codebase research based on user feedback using targeted sub-agents.
- [**qrspi-create-design-discussion**](./skills/qrspi/qrspi-create-design-discussion/SKILL.md) — Synthesize research and ticket into architectural decisions, surfacing options and patterns for human review.
- [**qrspi-iterate-design-discussion**](./skills/qrspi/qrspi-iterate-design-discussion/SKILL.md) — Refine design options and converge on an architectural decision through collaborative discussion.
- [**qrspi-create-structure-outline**](./skills/qrspi/qrspi-create-structure-outline/SKILL.md) — Translate an approved design into a phased structural outline with vertical slices and verification checkpoints.
- [**qrspi-iterate-structure-outline**](./skills/qrspi/qrspi-iterate-structure-outline/SKILL.md) — Adjust phase ordering, boundaries, or verification checkpoints in the structure outline.
- [**qrspi-create-plan**](./skills/qrspi/qrspi-create-plan/SKILL.md) — Convert an approved structure outline into a rigid step-by-step implementation plan with dual verification criteria.
- [**qrspi-iterate-plan**](./skills/qrspi/qrspi-iterate-plan/SKILL.md) — Surgically adjust the implementation plan when scope changes or implementation hits a mismatch.
- [**qrspi-create-worktree**](./skills/qrspi/qrspi-create-worktree/SKILL.md) — Create an isolated git worktree and launch an implementation session from an approved plan.
- [**qrspi-setup**](./skills/qrspi/qrspi-setup/SKILL.md) — Set up the local `thoughts/` workspace and ignore it from git.

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
