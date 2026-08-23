---
name: planner
description: Conventions and structure of the planner.org file specifically — habits, calendar, goals, journal. Load before editing planner.org or scheduling/reviewing anything in it.
---

# Planner

`~/Documents/Notetaking/planner.org` is the single file this system's daily
skills read and write. First load the `notetaking` skill for general
standards (format, philosophy, editing rules) — this skill covers what's
specific to this one file.

## Top-level sections in planner.org, and how to use each

- **Cheat sheet** — quick org-agenda keybind reference. Reference material,
  not data; don't add TODOs or entries here.
- **Daily** — habit-style TODOs meant to recur every day. Section heading
  carries `:PROPERTIES: :agenda-group: daily :collapsed: true :END:`; new
  daily habits go here, following the habit conventions below.
- **Weekly** — subdivided by day-of-week headings (`** Monday`, `** Tuesday`,
  ... `** Any Day`), each holding that day's recurring TODOs. Assign a new
  weekly-recurring habit to the day(s) of the week it actually recurs on;
  use `** Any Day` for one that recurs weekly but isn't day-specific.
- **Monthly** — monthly-recurring TODOs (bills, recurring maintenance, etc.).
- **Backlog** — TODOs with no fixed schedule yet. Use this for something
  that needs doing but isn't tied to a specific day/week/month cadence.
- **Calendar** — fixed annual dates (birthdays, anniversaries), tagged
  `:birthday:` or a similarly descriptive tag, using `+1y` repeaters. Use
  for any date that should recur once a year.
- **Alarm Clock** — for time-specific reminders/alarms distinct from the
  day-level scheduling above; use this section when a prompt at a specific
  clock time (not just a date) is what's needed.
- **Long-term goals** — plain bullet lists (NOT TODO items), nested by
  horizon: Quarterly Goals, Yearly Goals, 3-year Goals, 10-year Goals, plus
  a "Hobby Project Stack" for someday-maybe ideas. Add a new long-term goal
  under whichever horizon actually fits it; don't force everything into one
  horizon for convenience.
- **Self-affirmations** — free-text grounding statements meant to be read
  or said aloud. Append new ones; don't restructure existing ones.
- **People in my life** — one heading per person, freeform notes on
  reconnecting/relationship intentions. Add a new heading for a new person;
  add notes under an existing person's heading as intentions arise.
- **Finances** — subscriptions list, yearly tax checklist (uses `[x]`/
  `[fail]`/`[na]` inline checkbox markers within a checklist, distinct from
  TODO items). Use the checklist markers for this kind of item-by-item
  tracking rather than converting entries to full TODOs.
- **Groceries** — grocery list items. Add/remove items here as needed.
- **Journal** — dated entries (`** M/D/YY` headings), each holding that
  day's `DEADLINE`-tagged TODOs and any notes. Append-only: new entries go
  at the top of this section, most recent first, in the same format as
  existing entries. The "Daily check-in" template (see the `daily-planning`
  skill) lives as a set of sub-headings under a Journal entry.

## Habit/TODO conventions

- `SCHEDULED: <date [+Nd|+Nw|+Nm]>` — a repeater. `+1d` daily, `+1w` weekly,
  `+1m` monthly. `+2d/3d` form means "repeat every 2 days, but if more than
  3 days late, reschedule from today" (flexible repeater) — preserve this
  distinction, don't collapse it to a plain `+2d`.
- `:PROPERTIES: :STYLE: habit :LAST_REPEAT: [timestamp] :END:` marks a
  recurring habit and its last completion.
- `:LOGBOOK:` drawers record `State "DONE" from "TODO" [timestamp]` history
  — never delete existing logbook entries; new completions append a new line.
- Tags: `:habit:`, `:important:` are the two in active use. Preserve tags
  exactly when editing an entry; don't add new tags unless asked.
- `DEADLINE: <date>` (not `SCHEDULED`) is used specifically for Journal-
  section dated action items, not for Daily/Weekly/Monthly habits.

## Reading/writing rules for the daily skills

- `daily-planning`, `checkin`, `review`, and `schedule-item` all operate on
  this file. None of them duplicate its content elsewhere — they read the
  live file, make edits directly to it, in place, matching the conventions
  above.
- Never invent a new top-level section without being asked. If new content
  doesn't fit an existing section, ask where it should go rather than
  guessing.
