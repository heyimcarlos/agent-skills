# QRSPI HTML Output Reference

This document is the source of truth for the `--output=html` mode shared by every doc-producing QRSPI skill (`create-*` and `iterate-*` for research-questions, research, design-discussion, structure-outline, plan). `qrspi-create-worktree` produces no document and is excluded.

When a QRSPI skill runs with `--output=html`, it emits **both** a markdown file (canonical) and a sibling HTML file at the same path with the `.html` extension. Iterate skills detect the sibling and refresh both together.

## Philosophy

The HTML output is **not** a literal slide-by-slide rendering of the markdown. It is a richer, parallel artifact designed to be readable and shareable — color, SVG diagrams, annotated code, comparison tables, and mobile-responsive layout. Borrow Tariq's "Unreasonable Effectiveness of HTML" principles:

- Use HTML's expressiveness — tables for comparisons, SVG for flows and file maps, annotated `<pre><code>` blocks for code, color-coded badges for status, anchored sections for navigation.
- Optimize for someone reading it once. Headings, summaries up top, details below.
- Don't ASCII-diagram what SVG can render. Don't emoji-color what CSS can.
- The HTML is the artifact a human or teammate actually reads. The markdown is the durable, diff-friendly record.

## Flag contract

The skill scans its free-form input for the literal token `--output=html` (anywhere in the args). If present, it emits both files. Otherwise, markdown only — current behavior is unchanged.

For iterate skills, the rule is:

1. If a sibling `.html` already exists next to the target `.md`, refresh both regardless of flags.
2. If no sibling exists and `--output=html` is passed, generate one alongside the refreshed `.md`.
3. Otherwise markdown only.

## File naming

For every doc path `thoughts/shared/<area>/<filename>.md`, the HTML sibling is `thoughts/shared/<area>/<filename>.html`. No separate directory, no suffix — same basename, different extension.

## Reveal.js skeleton

Use reveal.js loaded from a CDN. The deck is structured as `<section>` elements; each top-level `<section>` becomes one slide. Vertical slides (nested `<section>`) are fine for sub-points. Keep a consistent header, theme, and link back to the markdown source.

```html
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>[Skill output title]</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/reveal.js@5/dist/reveal.css" />
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/reveal.js@5/dist/theme/white.css" id="theme" />
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/reveal.js@5/plugin/highlight/monokai.css" />
  <style>
    :root {
      --c-accent: #2b6cb0;
      --c-ok: #2f855a;
      --c-warn: #c05621;
      --c-bad: #c53030;
      --c-muted: #4a5568;
    }
    .reveal section { text-align: left; font-size: 0.85em; }
    .reveal h1, .reveal h2, .reveal h3 { text-transform: none; }
    .reveal table { font-size: 0.7em; border-collapse: collapse; width: 100%; }
    .reveal th, .reveal td { border: 1px solid #cbd5e0; padding: 0.35em 0.6em; }
    .reveal th { background: #edf2f7; }
    .reveal .badge { display: inline-block; padding: 0.1em 0.5em; border-radius: 0.4em; font-size: 0.7em; color: white; }
    .reveal .badge.ok { background: var(--c-ok); }
    .reveal .badge.warn { background: var(--c-warn); }
    .reveal .badge.bad { background: var(--c-bad); }
    .reveal .badge.info { background: var(--c-accent); }
    .reveal pre { box-shadow: none; }
    .reveal .meta { color: var(--c-muted); font-size: 0.75em; }
    .reveal .grid-2 { display: grid; grid-template-columns: 1fr 1fr; gap: 1em; }
    .reveal .grid-3 { display: grid; grid-template-columns: repeat(3, 1fr); gap: 1em; }
    .reveal .card { border: 1px solid #e2e8f0; border-radius: 0.5em; padding: 0.75em; background: #f7fafc; }
  </style>
</head>
<body>
  <div class="reveal">
    <div class="slides">
      <!-- Title slide -->
      <section>
        <h1>[Title]</h1>
        <p class="meta">[Source ticket/file] · [Date] · <a href="[basename].md">markdown source</a></p>
      </section>

      <!-- Per-phase slides go here. See "Per-phase slide structure" below. -->
    </div>
  </div>
  <script src="https://cdn.jsdelivr.net/npm/reveal.js@5/dist/reveal.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/reveal.js@5/plugin/highlight/highlight.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/reveal.js@5/plugin/notes/notes.js"></script>
  <script>
    Reveal.initialize({
      hash: true,
      slideNumber: 'c/t',
      plugins: [RevealHighlight, RevealNotes],
    });
  </script>
</body>
</html>
```

The skeleton is the same across phases. What changes is the slide content per phase.

## Per-phase slide structure

Each phase has a different shape of content. The sections below are guidance, not a rigid template — adapt to the actual document.

### Research questions (`qrspi-create-research-questions` / `qrspi-iterate-research-questions`)

1. **Title** — ticket title, source link, status.
2. **Context summary** — the objective context paragraph.
3. **Question map** — SVG or grid showing question categories (data flow, boundaries, components, constraints) with counts.
4. **Questions** — one slide per question or one slide per category, numbered with badges (`info` for active questions). Use vertical sub-slides if a question has clarifications.
5. **Coverage check** — table of "areas mentioned in ticket" vs. "questions covering them" so the reader can spot gaps.

### Research (`qrspi-create-research` / `qrspi-iterate-research`)

1. **Title** — ticket, research scope, date.
2. **TL;DR** — 3–5 bullets answering the questions in plain language.
3. **File map** — SVG diagram or table grouping files by purpose (implementation/tests/config/types) with `path:line` references.
4. **Per-question findings** — one slide per question with bullet findings and `path:line` cites; annotate code blocks with margin notes via `<aside class="notes">` or inline `<mark>` tags.
5. **Data flow** — SVG of how data moves through the relevant components.
6. **Existing patterns** — a comparison grid (`grid-2`/`grid-3`) of patterns with file:line, brief description, and which files use each.
7. **Discrepancies** — table of "ticket assumes / codebase actually does" with a `warn` or `bad` badge.

### Design discussion (`qrspi-create-design-discussion` / `qrspi-iterate-design-discussion`)

1. **Title** — feature, ticket, date.
2. **Current vs. desired** — `grid-2` cards or a side-by-side table.
3. **Patterns in play** — same comparison grid as research's patterns, plus the chosen one highlighted.
4. **Options** — one slide per option with `pros / cons / risk` columns and a recommendation badge (`ok` for recommended, `warn` for viable, `bad` for ruled out). Iterate skill moves rejected options to a "Resolved" slide rather than deleting them.
5. **Open questions** — list with `warn` badges; iterate moves resolved ones to a "Decisions" slide.
6. **Approved approach** — last slide once iteration converges. Bold visual marker (`badge ok`) to make it obvious.

### Structure outline (`qrspi-create-structure-outline` / `qrspi-iterate-structure-outline`)

1. **Title** — feature, design link, date.
2. **What we're NOT doing** — a high-contrast slide with explicit exclusions and rationale.
3. **Phase overview** — the same table as the markdown, plus a small SVG timeline showing phase order, line estimates, and verification checkpoints.
4. **Per-phase slides** — one slide each, with `card` blocks for goal / files / verification (automated and manual side-by-side via `grid-2`) / boundary. Use `info` badges for "tracer bullet" phases and `ok` badges for verification status.
5. **Testing strategy** — final slide with unit/integration/manual blocks.

### Plan (`qrspi-create-plan` / `qrspi-iterate-plan`)

1. **Title** — feature, structure link, date, last-updated banner if iterated.
2. **Phase navigation** — small SVG with anchored links to each phase slide.
3. **Per-step slides** — one slide per step (or one phase per slide if steps are tiny):
   - File path with a copy-friendly `<code>` block.
   - The "Do" instructions.
   - Code snippets in syntax-highlighted `<pre><code>` with `class="language-...".`
   - **Automated** and **Manual** verification cards via `grid-2`.
   - Status checkbox: `<input type="checkbox" disabled>` matched to the markdown's `- [ ]`/`- [x]` state.
4. **Phase checkpoints** — one slide each, with both verification commands rendered as runnable `<code>` blocks.
5. **Final verification** — last slide with the comprehensive command and manual scenarios.

## SVG conventions

Keep SVGs inline (no external assets). Use the CSS variables for colors so the deck stays consistent. Examples worth reusing:

- **File map**: rectangles grouped by directory, labeled with relative paths, with arrows for imports/calls.
- **Data flow**: numbered nodes, directional arrows, fail/error edges in `--c-bad`.
- **Phase timeline**: horizontal lanes, each phase a labeled segment with line-count, ending with a checkpoint diamond.

If a diagram would be more than ~30 lines of SVG, it's probably better as a table.

## Code annotation

For non-trivial snippets, add inline annotations rather than dropping a wall of code:

```html
<pre><code class="language-ts">
async function handler(req) {
  const user = await getUser(req); // <span class="badge info">step 1</span>
  return reply(user);              // <span class="badge ok">verified</span>
}
</code></pre>
```

Or render diff-style with `+`/`-` line classes when showing what a step changes.

## Iterate behavior

Iterate skills follow these rules when refreshing:

1. **Always refresh the markdown surgically** with `Edit` (existing behavior).
2. **For HTML**: regenerate the relevant slides only when feasible (Edit-style), but a full rewrite of `.html` via `Write` is acceptable since HTML diffs are noisy and the markdown is the canonical record. Prefer rewriting only the slides that changed when content is large.
3. **Preserve checked state**: for plan iteration, copy each step's `[x]`/`[ ]` from the markdown into the HTML's `<input type="checkbox" checked|disabled>`.
4. **Add an "Updated" banner**: append `<aside class="meta">Updated YYYY-MM-DD: [reason]</aside>` to the title slide.

## When NOT to use HTML output

- For a one-off scratch ticket where nobody else will read the doc.
- When the user is iterating rapidly and only wants markdown diffs.
- When the codebase has no browser-capable reviewer (rare).

The default remains markdown. `--output=html` is opt-in per phase. A user can mix modes — markdown for research, HTML for the design and plan — and the iterate skills will respect the per-document state.
