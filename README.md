# agent-skills

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
  productivity/   # general workflow — autonomous loops, CLAUDE.md tuning
  qrspi/          # the QRSPI workflow as 11 skills (create-* + iterate-*)
  misc/           # reserved for rarely-used skills
agents/           # Claude Code subagents (codebase + thoughts + web research)
.claude-plugin/
  plugin.json     # single-plugin manifest read by `npx skills` and Claude Code
```

## QRSPI workflow

Each stage is its own skill, with an `iterate-*` sibling for surgical adjustments without restarting the workflow.

| Stage | Skill | Purpose |
|-------|-------|---------|
| Question  | [`create-research-questions`](./skills/qrspi/create-research-questions/SKILL.md) | Turn a ticket into targeted questions before any code is read |
| Research  | [`create-research`](./skills/qrspi/create-research/SKILL.md) | Document the codebase as-is, grounded in real files |
| Spec      | [`create-design-discussion`](./skills/qrspi/create-design-discussion/SKILL.md) → [`create-structure-outline`](./skills/qrspi/create-structure-outline/SKILL.md) | Synthesize research into architectural decisions and a phased outline |
| Plan      | [`create-plan`](./skills/qrspi/create-plan/SKILL.md) | Convert outline into a rigid step-by-step plan with dual verification |
| Implement | [`create-worktree`](./skills/qrspi/create-worktree/SKILL.md) | Launch an isolated implementation session from an approved plan |
| Setup     | [`setup-qrspi`](./skills/qrspi/setup-qrspi/SKILL.md) | Initialize the local `thoughts/` workspace used by the QRSPI skills |

QRSPI skills set `disable-model-invocation: true` — the human invokes each phase deliberately rather than letting the model auto-trigger them.

Every doc-producing QRSPI skill (all of the above except `create-worktree`) accepts an optional `--output=html` flag. When present, the skill emits a reveal.js slide deck alongside the canonical markdown — color, SVG diagrams, annotated code, comparison tables. Iterate skills detect the sibling `.html` and refresh both. See [`skills/qrspi/HTML-OUTPUT.md`](./skills/qrspi/HTML-OUTPUT.md) for the conventions and per-phase slide structures.

## Reference

### Engineering

Code-work skills — git, PRs, planning, implementation, debug.

- [**commit**](./skills/engineering/commit/SKILL.md) — Create git commits with user approval and no Claude attribution.
- [**ci-commit**](./skills/engineering/ci-commit/SKILL.md) — Create git commits for session changes with clear, atomic messages.
- [**describe-pr**](./skills/engineering/describe-pr/SKILL.md) — Generate comprehensive PR descriptions following repository templates.
- [**describe-pr-nt**](./skills/engineering/describe-pr-nt/SKILL.md) — `describe-pr` variant tuned for repos without templates.
- [**ci-describe-pr**](./skills/engineering/ci-describe-pr/SKILL.md) — `describe-pr` variant for CI / non-interactive contexts.
- [**linear**](./skills/engineering/linear/SKILL.md) — Manage Linear tickets — create, update, comment, and follow workflow patterns.
- [**debug**](./skills/engineering/debug/SKILL.md) — Debug issues by investigating logs, database state, and git history.
- [**worktree**](./skills/engineering/worktree/SKILL.md) — Create a worktree and launch an implementation session for a plan.
- [**local-review**](./skills/engineering/local-review/SKILL.md) — Set up a worktree for reviewing a colleague's branch.
- [**create-handoff**](./skills/engineering/create-handoff/SKILL.md) — Create a handoff document for transferring work to another session.
- [**resume-handoff**](./skills/engineering/resume-handoff/SKILL.md) — Resume work from a handoff document with context analysis and validation.
- [**founder-mode**](./skills/engineering/founder-mode/SKILL.md) — Create a Linear ticket and PR for experimental features after implementation.
- [**implement-plan**](./skills/engineering/implement-plan/SKILL.md) — Implement technical plans from `thoughts/shared/plans` with verification.
- [**validate-plan**](./skills/engineering/validate-plan/SKILL.md) — Validate implementation against the plan, verify success criteria, identify issues.

### Productivity

General workflow tools, not code-specific.

- [**ralph**](./skills/productivity/ralph/SKILL.md) — Generate a ralph loop for any project — bash loop, prompt, and task tracker so an agent can autonomously iterate on research, specs, or implementation.
- [**improve-claude-md**](./skills/productivity/improve-claude-md/SKILL.md) — Improve a CLAUDE.md file using `<important if>` blocks for instruction adherence.

### QRSPI

The Question → Research → Spec → Plan → Implement workflow as explicit skills.

- [**create-research-questions**](./skills/qrspi/create-research-questions/SKILL.md) — Analyze a ticket to generate targeted research questions before any codebase investigation begins.
- [**iterate-research-questions**](./skills/qrspi/iterate-research-questions/SKILL.md) — Refine research questions by adding, removing, or reframing them based on user feedback.
- [**create-research**](./skills/qrspi/create-research/SKILL.md) — Document codebase as-is using parallel sub-agents, guided only by the research questions document.
- [**iterate-research**](./skills/qrspi/iterate-research/SKILL.md) — Deepen or correct codebase research based on user feedback using targeted sub-agents.
- [**create-design-discussion**](./skills/qrspi/create-design-discussion/SKILL.md) — Synthesize research and ticket into architectural decisions, surfacing options and patterns for human review.
- [**iterate-design-discussion**](./skills/qrspi/iterate-design-discussion/SKILL.md) — Refine design options and converge on an architectural decision through collaborative discussion.
- [**create-structure-outline**](./skills/qrspi/create-structure-outline/SKILL.md) — Translate an approved design into a phased structural outline with vertical slices and verification checkpoints.
- [**iterate-structure-outline**](./skills/qrspi/iterate-structure-outline/SKILL.md) — Adjust phase ordering, boundaries, or verification checkpoints in the structure outline.
- [**create-plan**](./skills/qrspi/create-plan/SKILL.md) — Convert an approved structure outline into a rigid step-by-step implementation plan with dual verification criteria.
- [**iterate-plan**](./skills/qrspi/iterate-plan/SKILL.md) — Surgically adjust the implementation plan when scope changes or implementation hits a mismatch.
- [**create-worktree**](./skills/qrspi/create-worktree/SKILL.md) — Create an isolated git worktree and launch an implementation session from an approved plan.
- [**setup-qrspi**](./skills/qrspi/setup-qrspi/SKILL.md) — Set up the local `thoughts/` workspace and ignore it from git.

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
