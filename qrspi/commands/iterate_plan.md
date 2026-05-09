---
description: Surgically adjust the implementation plan when scope changes or implementation hits a mismatch
---

# Iterate Plan

You are adjusting an in-flight implementation plan. Your job is to surgically edit the plan when scope changes, roadblocks are hit, or implementation reality diverges from what was planned.

## Initial Response

When this command is invoked:

1. **If a file path and feedback were provided**: Read the plan FULLY and process the feedback.
2. **If only a file path was provided**: Read it and ask what needs to change.
3. **If neither**: Find the most recent `thoughts/shared/plans/` document, read it, and ask what happened.

## Process

### Step 1: Diagnose the Issue

Read the plan and the user's feedback. Categorize:

- **Mismatch**: Implementation reality differs from what the plan assumed
- **Scope change**: Requirements changed since the plan was written
- **Blocked step**: A step can't be executed as written
- **Missing step**: Something was needed that the plan didn't account for
- **Phase reorder**: A phase needs to happen in a different order

### Step 2: Research if Needed

If the issue requires new codebase understanding (e.g., a file doesn't exist where the plan says it should, or an API has a different signature), spawn a **codebase-analyzer** agent to get the current truth before modifying the plan.

For mismatches, document them clearly before fixing:
```
**Mismatch Report**:
- **Expected** (from plan): [What the plan assumed]
- **Found** (in codebase): [What's actually there]
- **Impact**: [Which steps are affected]
- **Fix**: [How the plan should change]
```

### Step 3: Surgical Update

Use the Edit tool to update the plan. Rules:

- **Maintain dual verification**: Every new or modified step must still have both Automated and Manual verification.
- **Preserve checkboxes**: Don't uncheck steps that were already completed (`- [x]`). Add new steps below if the completed work needs extension.
- **Update phase checkpoints**: If the phase scope changed, update the checkpoint to match.
- **Mark plan version**: Add a note at the top: `> Updated YYYY-MM-DD: [brief reason for change]`

### Step 4: Present Changes

```
Updated the plan:
- [What changed and why]
- [Steps affected: X.Y, X.Z]
- [Any new steps added]

The plan is ready to continue from Step [next incomplete step].
```

## Guidelines

- Don't rewrite the entire plan for a single step's issue. Surgical edits only.
- If the mismatch is fundamental (wrong architecture, missing component), suggest going back to `/qrspi:iterate_design_discussion` or `/qrspi:iterate_structure_outline` rather than patching the plan.
- If more than 3 steps need to change, that's a signal the structure outline needs updating first.
- Completed steps are immutable history — never uncheck them.
