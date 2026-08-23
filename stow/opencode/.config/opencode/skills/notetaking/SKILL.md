---
name: notetaking
description: General standards for interacting with the personal notetaking system (org-mode, personal wiki). Load before any task that reads or edits files in the notetaking folder.
---

# Notetaking

Standards for the personal notetaking system at `~/Documents/Notetaking`, a
separate git repo from this one.

## Format

Everything is **org-mode**. Never introduce a different format (no
Markdown, no plain text notes) into this system, even for quick additions.

## Philosophy

Treat this as a **personal wiki**, not a flat dump. Content is meant to be
categorized and cross-referenced (org-mode links between files/headings),
not just appended in one place. When adding new material, think about where
it fits conceptually before just writing it wherever is fastest.

## Editing standards

- **Preserve existing conventions exactly, per file.** Conventions vary
  across this system depending on a file's purpose — don't assume one
  file's idioms apply everywhere. Match whatever the specific file you're
  editing already does:
  - Task/habit-tracking files (e.g. `planner.org`) use `:PROPERTIES:`
    drawers, `:LOGBOOK:` state-change history, `SCHEDULED`/`DEADLINE`
    timestamps with repeaters, `:STYLE: habit`.
  - Reference/idea/topic files are often much looser — plain nested
    headings (`*`, `**`, `***`) with prose or bullet lists underneath, no
    task-tracking machinery at all. Don't add `:PROPERTIES:`/`SCHEDULED`
    machinery to a file that doesn't already use it.
  - Some files open with a `:PROPERTIES: :ID: <uuid> :END:` block plus an
    Emacs local-variables line (e.g. `-*- mode: org -*-`) right under the
    title. Preserve this if present; don't strip it or invent a new ID for
    an existing file.
  - Cross-references use org-mode file links —
    `[[file:other-file.org][Display Text]]` or
    `[[file:./sub/dir/file.org][Display Text]]` for relative paths into
    subdirectories. Use this form (not a bare filename or a Markdown-style
    link) when linking between files, consistent with the personal-wiki
    philosophy above.
  - Code/data samples use `#+name: <label>` followed by
    `#+begin_example` / `#+end_example` blocks.
  - Journal-style files (dated narrative entries, e.g. `** 2020`,
    `*** June 7th-8th`) are typically the most personal content in this
    system — treat with particular care per the Personal information
    section below, and never summarize their content unprompted.
- Never restructure or "clean up" existing entries as a side effect of an
  unrelated edit. Touch only what the current task requires.
- When adding an entry to any file, follow the syntax already used by
  neighboring entries in that same file/section — if unsure which
  convention applies, look at the nearest existing entries before adding
  a new one, rather than defaulting to `planner.org`'s task-tracking style.

## Look for better org-mode features, not just existing ones

Preserving existing conventions (above) applies to content that's already
there — don't rewrite old entries just because a better feature exists.
But for **new** content, actively consider whether an org-mode feature
would represent it better than plain prose, and suggest it rather than
defaulting to unstructured text. Don't silently impose this on a file's
existing material — propose it, let the user decide.

Some features worth watching for opportunities to use, beyond whatever a
file already happens to use:

- **`#+STARTUP:`** options (e.g. `overview`, `indent`) — worth suggesting
  for large, deeply-nested files that would benefit from a default
  collapsed view.
- **Tags beyond `:habit:`/`:important:`** — topic tags (e.g. `:gamedesign:`,
  `:worldbuilding:`) make `org-tags-view` cross-file search actually useful
  once content is scattered across many topic files.
- **`org-id` links** (`[[id:uuid]]`) instead of file-path links, for files
  that already carry a `:PROPERTIES: :ID:` block — survives file renames/
  moves, unlike a `[[file:...]]` link.
- **Checkbox lists** (`- [ ]` / `- [X]`) for informal sub-task tracking
  inside reference/idea files that don't warrant full TODO/habit machinery.
- **`#+begin_src <language>`** instead of `#+begin_example` for actual code
  samples, to get syntax highlighting.

This isn't an exhaustive list — the point is to stay alert for a
better-fitting org-mode feature in general, not just match these examples.

## Two workflows, both must keep working

This system is used two ways, and neither should break the other:

1. **Manual** — the user opens the file directly in Emacs and works with
   `org-agenda` themselves.
2. **Conversational** — the user talks through the same tasks with an
   agent, which reads and edits the same underlying file.

Never create a parallel, agent-only format or a separate file to avoid
touching the "real" one. Both workflows operate on the same file, using the
same conventions, always.

## Personal information

Per the global `AGENTS.md` "Personal & private information" rule: content
in this system is frequently personal (goals, stressors, journal entries).
Reading it sends it to the underlying model provider — don't read more of
it than a task actually requires, and don't summarize or repeat back
personal content unnecessarily even when legitimately reading it to do the
task. Always prefer to check with the user if you should be reading a file before doing so.
