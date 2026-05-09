---
name: create-research
description: Document codebase as-is with thoughts directory for historical context
disable-model-invocation: true
model: opus
---

# Codebase Research

You are conducting comprehensive, objective research across the codebase to document how things work today. Your output is a research report with file:line references that serves as the factual foundation for design and planning phases.

This report feeds into design and planning phases where decisions get made. If the research layer mixes in opinions, those phases inherit biased assumptions instead of clean facts. Keep the research pure so downstream decisions are grounded in reality.

## CRITICAL: Your only job is to document and explain the codebase as it exists today
- DO NOT suggest improvements, changes, or future enhancements
- DO NOT perform root cause analysis or critique the implementation
- DO NOT recommend refactoring, optimization, or architectural changes
- ONLY describe what exists, where it exists, how it works, and how components interact
- You are creating a technical map of the existing system

The questions document carries intent from the original ticket. Your job is to document what the codebase does today — not what it doesn't do relative to something planned. If a component has a limitation, state what it currently does. "Processes one day_offset at a time" is a fact about the code. "Would need to be called per-day or extended for multi-day ranges" is a design opinion — that belongs in the Design phase, not here.

## Getting started

When this skill is triggered:

1. **If a file path was provided** (e.g., `thoughts/shared/questions/YYYY-MM-DD-ENG-XXXX-questions.md`):
   - Read it fully using the Read tool (no limit/offset).
   - Begin the research process immediately.

2. **If no input was provided**, respond with:
   ```
   I'll execute the Research phase to map out the codebase objectively.

   Please provide the path to the answered questions document from the Question phase
   (e.g., `thoughts/shared/questions/YYYY-MM-DD-ENG-XXXX-questions.md`).
   ```
   Then wait for input.

## Process

### Step 1: Analyze the Questions Document

- Read the questions document fully using the Read tool (no limit/offset)
- Extract research targets: specific components, concepts, data flows, and constraints mentioned
- Formulate a search plan: list codebase areas that require investigation

### Step 2: Spawn Sub-agent Research

- Spawn parallel agents to research facts efficiently
- The expensive investigation stays isolated, only compressed results come back
- Use these specialized agents based on what the questions document actually needs:

**For codebase research:**
- Use the **codebase-locator** agent find WHERE files and components live
- Use the **codebase-analyzer** agent to understand HOW specific code works (without critiquing it)
- Use the **codebase-pattern-finder** agent to find examples of existing patterns (without evaluating them)

**For thoughts directory:**
- Use the **thoughts-locator** agent to discover what documents exists about the topic. **Exclude `thoughts/tickets/`** because ticket content must not leak into research agents to prevent contamination of objective findings.
- Use the **thoughts-analyzer** agent to extract key insights from specific documnets (only the most revelant ones)

**For web research (only if questions documents explicity asks):**
- Use the **web-search-researcher** agent for external documentation and resources
- IF you use web-research agents, instruct them to return LINKS with their findings, and INCLUDE those links in your final report.

The key is to use these agents intelligently:
- Start with locator agents to find what exists
- Then use analyzer agents on the most promising findings to document how they work
- Run multiple agents in parallel when they're searching for different things
- Each agent knows its job — just tell it what you're looking for
- All agents are documentarians, not critics — remind them to describe what exists without suggesting improvements
- **Never include ticket content** in any agent prompt — the research phase must discover facts from the codebase itself

### Step 3: Verify and Deepen

- Wait for ALL agents to complete before proceeding
- Read all critical files identified by agents directly into your main context — never rely solely on an agent's summary for files central to the investigation
- Trace loose ends: if a function calls an interface, find the concrete implementations; if a config value is referenced, find where it's set

### Step 4: Write Research Report

Gather metadata (date, git commit, branch, repo name, researcher) via `~/scripts/spec_metadata.sh` or git commands, then write the report.

- **Filename**: `thoughts/shared/research/YYYY-MM-DD-ENG-XXXX-description.md`
  - YYYY-MM-DD is today's date, ENG-XXXX is the ticket number (omit if no ticket), description is a brief kebab-case topic
  - Examples: `2025-01-08-ENG-1478-parent-child-tracking.md`, `2025-01-08-authentication-flow.md`

- **Structure**:
     ```markdown
     ---
     date: [Current date and time with timezone in ISO format]
     git_commit: [Current commit hash]
     branch: [Current branch name]
     repository: [Repository name]
     topic: "[User's Question/Topic]"
     tags: [research, codebase, relevant-component-names]
     status: complete
     last_updated: [Current date in YYYY-MM-DD format]
     ---

     # [Feature/Task Name] — Codebase Research

     - **Date**: [Current date and time with timezone]
     - **Git Commit**: [Current commit hash]
     - **Branch**: [Current branch name]
     - **Repository**: [Repository name]
     - **Questions Document**: [Path to questions document]

     ## Research Question
     [Brief explanation of the research questions and what they cover]

     ## Research Methodology (verbatim)
     The document will remain objective and factual. It does not contain any recommendations or implementation suggestions. Open questions will not ask Why things haven't been built or what should be built in the future.

     There is no "implementation" section - this is intentional.

     ## Summary
     [Brief summary of the research objective based on the questions document]

     ## Detailed Findings

     ### [Component/Area 1]
     - Description of what exists ([file.ext:line](link))
     - How it connects to other components
     - Current implementation details (without evaluation)

     ### [Component/Area 2]
     ...

     ## Code References
     - `path/to/file.py:123` - Description of what's there
     - `another/file.ts:45-67` - Description of the code block

     ## Architecture Documentation
     [Cross-cutting patterns and conventions that emerge from reading across multiple findings]

     ## Data Flow
     [Trace the path of data or execution through the system]
     - Step 1: `file.ext:function()` at line N does X
     - Step 2: `file2.ext:handler()` at line N does Y
     - Step 3: ...

     ## Related Research
     [Links to other research documents in thoughts/shared/research/]
     ```

### Step 5: Add GitHub permalinks
- Get repo info: `gh repo view --json owner,name`
- Replace local file references with permalinks: `https://github.com/{owner}/{repo}/blob/{commit}/{file}#L{line}`

### Step 6: Present and Iterate

```
Research report written to:
`thoughts/shared/research/YYYY-MM-DD-[ticket-id]-research.md`

Please review. Does this provide a complete and accurate picture of the current system?

Next step: `/qrspi:create_design_discussion thoughts/shared/research/YYYY-MM-DD-[ticket-id]-research.md`
```

## Guidelines

- **Be objective**: Document what exists, not what should be. Solutions belong in Design.
- **Be thorough**: Every claim needs a file:line reference. Track down loose ends.
- **Be efficient with context**: Sub-agents do the expensive searching; you receive compressed results. Read critical files yourself but don't read everything an agent found.
- **Verify agent results**: Agents compress information. For files central to the task, read them yourself to catch what agents may have summarized away.
