---
name: schedule
description: Create or edit a habit, TODO, or calendar entry in planner.org — scheduling, repeaters, and habit-tracking setup specifically.
---

# Schedule

First load the `planner` skill (which itself loads `notetaking`).

Focused specifically on **creating or editing** an item that gets scheduled
or tracked as a habit — as opposed to `checkin` (updating status on
something that already exists) or `daily-planning`/`review` (the guided
daily procedures). Use this when the task is specifically "add a new
recurring habit," "change how often X repeats," or "schedule a one-off
calendar item."

## What this covers

- Creating a new recurring habit (Daily, Weekly, or Monthly section).
- Editing an existing habit's schedule (frequency, day-of-week, time).
- Adding a one-off dated item (Calendar section, or a `DEADLINE` under a
  Journal entry).
- Converting a Backlog item into a scheduled one, or vice versa.

## Behavior

- Determine which section the item belongs in (Daily/Weekly/Monthly/
  Calendar/Backlog) based on its actual cadence — ask if it's ambiguous
  rather than guessing.
- Use the repeater and habit-drawer conventions from the `planner` skill —
  don't restate them here, just apply them.
- When editing an existing item's schedule, preserve its `:LOGBOOK:`
  history — don't clear or reset completion history when just changing
  the cadence going forward.
- Tag appropriately: use `:habit:` for recurring items, `:important:` if
  the user indicates it's a priority item, or a new descriptive tag if one
  is warranted (see `notetaking`'s note on using tags for topic/priority
  filtering) — ask before inventing a new tag if it's not obviously needed.
