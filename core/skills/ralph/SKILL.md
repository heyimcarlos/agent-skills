---
description: Generate a ralph loop for any project - creates a bash loop, prompt, and task tracker so claude can autonomously iterate on research, specs, or implementation. Use when someone wants to set up an autonomous agent loop, explore an idea deeply, reverse-engineer something, write specs, build iteratively, or run any multi-step project hands-free. Even if the user doesn't say "ralph" - if they want an autonomous iterative loop, this is it.
model: sonnet
---

# Ralph Loop Generator

A ralph loop is a bash script that repeatedly spawns fresh claude instances,
each reading the same prompt file and picking up where the last left off
through files on disk. Fresh context each iteration means no degradation.
State persists through a task tracker, a progress log, and output artifacts.

The skill's job: take any objective and scaffold the files needed to run it
as a ralph loop. The user launches it and walks away.

## Step 1 — Understand the objective

Read the user's prompt. Extract:

1. **Objective** — what are we trying to accomplish?
2. **Approach** — research, reverse-engineer, spec, build, or a custom sequence?
3. **Done condition** — what does "finished" look like?
4. **Output location** — where should artifacts live? Default: `./ralph/<objective-slug>/`

If any of these are unclear, ask before generating files. Get the objective
right — everything else flows from it.

think deeply about how to decompose this into right-sized tasks

## Step 2 — Decompose into tasks

Break the objective into discrete tasks. Each task must:

- Fit within a single context window (~180k tokens of reading + output)
- Produce a concrete artifact (a file, a document, code, etc.)
- Be independently verifiable — you can tell if it's done by reading the output
- Build on prior tasks in a logical sequence

**Sizing guidance:**
- Research tasks: one per research target (e.g., "reverse-engineer LinkedIn's feed algorithm")
- Spec tasks: one per feature or component being specified
- Build tasks: one per incremental, testable implementation step
- If a task feels too big, split it. Err on the side of smaller.

## Step 3 — Generate the loop files

Create the directory structure:

```
ralph/<objective-slug>/
  ralph.sh          # The bash loop
  prompt.md         # Instructions for each iteration
  tasks.json        # Task tracker
  progress.md       # Cross-iteration memory (starts near-empty)
  output/           # Where artifacts go
```

### ralph.sh

```bash
#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROMPT_FILE="$SCRIPT_DIR/prompt.md"
PROGRESS_FILE="$SCRIPT_DIR/progress.md"
MAX_ITERATIONS="${1:-10}"

if [ ! -f "$PROGRESS_FILE" ]; then
  printf "# Progress Log\nStarted: %s\n---\n" "$(date)" > "$PROGRESS_FILE"
fi

echo "Starting Ralph Loop — Max iterations: $MAX_ITERATIONS"

for i in $(seq 1 "$MAX_ITERATIONS"); do
  echo ""
  echo "========================================"
  echo "  Iteration $i of $MAX_ITERATIONS"
  echo "========================================"

  OUTPUT=$(claude --dangerously-skip-permissions \
    --print < "$PROMPT_FILE" 2>&1 | tee /dev/stderr) || true

  if echo "$OUTPUT" | grep -q "<promise>COMPLETE</promise>"; then
    echo ""
    echo "Ralph completed all tasks at iteration $i!"
    exit 0
  fi

  echo "Iteration $i complete. Continuing..."
  sleep 2
done

echo "Reached max iterations ($MAX_ITERATIONS) without completing."
echo "Check progress.md for status."
exit 1
```

This is the standard ralph.sh — don't modify the loop structure unless the
user has a specific reason. The magic is in prompt.md, not the bash script.

### prompt.md

This is the heart of the loop. Tailor it entirely to the user's objective.
Follow this structure but adapt the content:

```markdown
# Objective

[Crystal-clear statement of what we're building/researching/exploring]

## Context

[Any background the user provided — what inspired this, constraints, etc.]

## Your instructions

You are one iteration in a ralph loop. Many instances of you will run in
sequence, each with a fresh context window. You communicate with past and
future iterations ONLY through files on disk.

1. Read `progress.md` to understand what previous iterations accomplished
2. Read `tasks.json` to find the highest-priority incomplete task
3. Work on that ONE task:
   [PHASE-SPECIFIC INSTRUCTIONS GO HERE]
4. Save your output to `output/[descriptive-filename]`
5. Mark the task done in `tasks.json` (set `"done": true`)
6. Append a concise summary to `progress.md` — what you did, what you found,
   what the next iteration should know
7. If ALL tasks in tasks.json are done, output: <promise>COMPLETE</promise>

## Rules

- Do ONE task per iteration. Do it thoroughly. Don't rush to do multiple.
- Never repeat work captured in progress.md — read it carefully first.
- If you discover something that changes the plan (new tasks needed, a task
  is irrelevant, scope changed), update tasks.json accordingly. Add new
  tasks, remove obsolete ones, reorder if needed. Note the change in
  progress.md so the next iteration understands why.
- Be thorough — you have a full context window. Use it.
- If a task requires web research, use WebSearch and WebFetch extensively.
- If a task requires codebase research, use Grep, Glob, Read.
- Save ALL findings to files. Your memory dies when you exit.

## Output format for artifacts

[Specify the format the user wants — markdown docs, JSON specs, code files,
etc. Be specific about structure and naming conventions.]
```

**Adapt the phase-specific instructions based on the objective type:**

For **research** objectives:
```
3. Work on that ONE task:
   - Research the target thoroughly using WebSearch, WebFetch, and any
     available tools
   - Document findings with sources and specific examples
   - Be unbiased — document what you find, not what you think should be true
   - Include direct quotes, URLs, and data points where possible
```

For **spec/design** objectives:
```
3. Work on that ONE task:
   - Read any relevant research from output/ that informs this spec
   - Write a detailed spec covering: what it does, how it works, key
     design decisions, tradeoffs, open questions, dependencies
   - Each spec should stand alone — a reader shouldn't need other docs
```

For **build/implementation** objectives:
```
3. Work on that ONE task:
   - Read the relevant spec from output/ before writing code
   - Implement incrementally — write code, then verify it works
   - Run tests if they exist, write them if they should exist
   - Commit working code (don't commit broken state)
```

For **reverse-engineering** objectives:
```
3. Work on that ONE task:
   - Study the target systematically — architecture, features, patterns
   - Use WebSearch and WebFetch to gather information
   - Document: how it works, why it works that way, what makes it
     successful, what could be done differently
   - Include concrete examples, not just abstractions
```

### tasks.json

```json
{
  "objective": "[the objective in one line]",
  "tasks": [
    {
      "id": 1,
      "name": "short-task-name",
      "description": "Detailed description of what this task should produce",
      "phase": "research|spec|build",
      "done": false
    }
  ]
}
```

Order tasks so later ones can build on earlier artifacts. The prompt
tells each iteration to pick the first incomplete task, so ordering matters.

### progress.md

Initialize with:

```markdown
# Progress Log

Started: [date]
Objective: [the objective]

---
```

Each iteration will append its own entries. Don't pre-fill this — the
whole point is that iterations build it up as they go.

## Step 4 — Review with the user

Present the generated files to the user. Specifically:

1. **tasks.json** — "Here are the tasks I broke this into. Right order? Anything missing?"
2. **prompt.md** — "Here's what each iteration will be told to do. Does this capture your intent?"
3. **How to run it:**

```
cd ralph/<slug>
chmod +x ralph.sh
bash ralph.sh 20    # adjust iteration count to task count + buffer
```

4. **How to monitor:** `tail -f ralph/<slug>/progress.md` in another terminal
5. **How to stop:** Ctrl+C the script

Ask for feedback. Adjust files based on their response. Don't launch until
the user is satisfied with the decomposition and prompt.

## Step 5 — Adjustments

If the user wants changes:
- Edit the specific files — don't regenerate from scratch
- If they want to add/remove/reorder tasks, update tasks.json
- If they want to change the approach, update the instructions section in prompt.md
- If they want a different output format, update the output format section

## Tips for writing good prompts

Things that make ralph loops succeed:

- **Right-sized tasks**: each fits in one context window with room to spare
- **Concrete deliverables**: "write a spec for X" beats "think about X"
- **Clear done criteria**: the iteration needs to know when the task is finished
- **Good progress.md discipline**: the prompt should emphasize appending useful
  context, not just "done with task 3"
- **Adaptability**: telling the iteration it can modify tasks.json if the plan
  needs to change prevents it from getting stuck on an obsolete task

Things that break ralph loops:

- Tasks that are too big (context fills up, output degrades)
- Vague instructions (iterations flail without clear direction)
- No progress.md (iterations repeat each other's work)
- Too many iterations with no completion signal (waste of compute)
