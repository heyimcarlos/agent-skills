---
name: create-plan
description: Convert an approved structure outline into a rigid step-by-step implementation plan with dual verification criteria.
disable-model-invocation: true
model: opus
---

# Implementation Plan

You are creating the final, tactical implementation plan from an approved structure outline. Your job is to convert the high-level phases into granular, executable steps that an implementation agent can follow mechanically. This is Step 5 (Plan) in the QRSPI framework.

**This plan is the contract between human review and agent execution.** Every step must be unambiguous, every verification must be runnable, and every file must be named explicitly.

## Getting Started

When this skill is triggered:

1. **If a structure file path was provided**: Read it fully, then read the design and research documents referenced in it. Begin planning.
2. **If no input was provided**, respond with:
   ```
   I'll create an implementation plan from the approved structure outline.

   Please provide the path to the structure document (e.g., `thoughts/shared/structure/YYYY-MM-DD-[ticket-id]-structure.md`).
   ```
   Then wait for input.

## Process

### Step 1: Read All Context

1. Read the **structure outline** fully.
2. Read the **design document** referenced in the structure.
3. Read the **research document** referenced in the design — especially the file map and existing patterns sections.
4. Spawn a **codebase-analyzer** agent to verify that the target files from the structure still exist and haven't changed since research was conducted. This catches stale references.

### Step 2: Convert Phases to Steps

For each phase in the structure outline, expand it into granular steps. Each step must include:

- **What to do**: Specific action (create file, modify function, add test)
- **Target files**: Exact `path/to/file.ext` with line references where applicable
- **Code guidance**: Concrete snippets, function signatures, or patterns to follow (from the research's Existing Patterns section). Plans with concrete code are more reliable than abstract ones.
- **Automated verification**: A runnable command that proves the step succeeded (e.g., `make test`, `npm run build`, `go vet ./...`)
- **Manual verification**: What the human should check that automation can't (UI behavior, data correctness, integration with external systems)

### Step 3: Write Plan Document

Write to `thoughts/shared/plans/YYYY-MM-DD-[ticket-id]-plan.md`:

````markdown
# [Feature/Task Name] Implementation Plan

## Overview

[One-paragraph summary of what this plan implements]

## References
- Structure: `thoughts/shared/structure/[filename]`
- Design: `thoughts/shared/design/[filename]`
- Research: `thoughts/shared/research/[filename]`
- Ticket: `thoughts/shared/tickets/[filename]`

## What We're NOT Doing
[Carried forward from structure outline]

---

## Phase 1: [Phase Name from Structure]

### Step 1.1: [Action]
- **Files**: `path/to/file.ext`
- **Do**: [Specific action with code guidance]
  ```language
  // Pattern to follow (from research):
  [concrete code snippet or function signature]
  ```
- **Automated**: `make test` or specific test command
- **Manual**: [What to check]
- [ ] Done

### Step 1.2: [Action]
- **Files**: `path/to/file.ext`
- **Do**: [Specific action]
- **Automated**: [Command]
- **Manual**: [What to check]
- [ ] Done

### Phase 1 Checkpoint
- **Automated**: [Command that validates the entire phase]
- **Manual**: [End-to-end check for this phase]
- [ ] Phase 1 complete — pause for human confirmation

---

## Phase 2: [Phase Name]

### Step 2.1: [Action]
...

### Phase 2 Checkpoint
- **Automated**: [Command]
- **Manual**: [Check]
- [ ] Phase 2 complete — pause for human confirmation

---

## Final Verification

- [ ] All automated checks pass: `[comprehensive command]`
- [ ] Manual testing complete: [scenarios to test]
- [ ] No regressions in existing functionality
````

### Step 4: Validate the Plan

Before presenting, check:
- Every file referenced in the plan exists in the codebase (confirmed by codebase-analyzer)
- Every automated verification command is a real, runnable command
- No step is ambiguous — an implementation agent could execute it without asking questions
- Phase checkpoints match what the structure outline defined
- The plan follows the approved design's chosen pattern

If any check fails, fix the plan or flag the issue.

### Step 5: Present for Approval

```
Implementation plan written to:
`thoughts/shared/plans/YYYY-MM-DD-[ticket-id]-plan.md`

Summary:
- [N] phases, [M] total steps
- Phase 1 ([name]): [steps] steps — [description]
- Phase 2 ([name]): [steps] steps — [description]
...

Each phase ends with a checkpoint that pauses for your confirmation before proceeding.

Please review. Once approved, this plan is ready for implementation.
```

## Guidelines

- Plans should be mechanical to execute. If a step requires judgment calls, the design phase didn't resolve enough.
- Include concrete code snippets — not pseudocode — for non-trivial changes. Pull these from the research's Existing Patterns section.
- Every phase checkpoint must pause for human confirmation of manual verification before proceeding to the next phase.
- If you discover the structure outline missed something during planning, don't silently add it. Flag it and suggest running the iterate-structure-outline skill.
- Keep steps small enough that each one is independently verifiable. A step that says "implement the entire handler" is too big.
