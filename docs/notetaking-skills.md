# Notetaking skills — structure

How the org-mode/notetaking skills relate to each other.

## Layers, bottom to top

- **`notetaking`** — what it's for: general standards for the whole
  notetaking system. Format (org-mode), personal-wiki philosophy, per-file
  editing conventions, when to look for better org-mode features,
  personal-info handling. Loaded by everything below.
- **`planner`** — what it's for: everything specific to `planner.org` (its
  sections, habit/TODO conventions). Loads `notetaking` first, since it
  needs those general standards too.
- **`daily-planning` / `checkin` / `review` / `schedule`** — what each is
  for:
  - `daily-planning` — guided, procedural, full daily walkthrough.
  - `checkin` — unguided, lightweight update to something already tracked.
  - `review` — retrospective on work already done.
  - `schedule` — create/edit a habit, TODO, or calendar entry.

  Each of these loads `planner` first (which loads `notetaking`), since
  all four need `planner.org`'s conventions to actually do their job.

## Commands

Thin wrappers, one per task skill, giving typed `/slash-command` access:
`/daily-planning`, `/checkin`, `/review`, `/schedule`. Each just says
"follow the matching skill" — no logic of its own.

## Why layered this way

- **DRY.** Org-mode syntax and conventions are defined exactly once, in
  `planner` (and `notetaking` for the general standards). The four task
  skills reference them instead of restating them.
- `notetaking` stays stable even as folders/files elsewhere in the
  notetaking system change; `planner` is the one skill tied to a specific,
  permanent file; the four task skills are the only ones a user directly
  invokes.
