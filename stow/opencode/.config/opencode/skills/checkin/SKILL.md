---
name: checkin
description: Lightweight update to planner.org — add/remove/update a goal, or record any progress note. No fixed procedure.
---

# Check-in

First load the `planner` skill (which itself loads `notetaking`).

Unlike `daily-planning`, this is **not** guided or procedural. There's no
fixed sequence of steps. Its job is to be a fast, low-friction way to
record whatever the user brings to it.

## What this covers

- Adding a new goal or TODO.
- Removing or marking done a goal or TODO.
- Updating status/progress on something already tracked (a habit, a
  backlog item, a long-term goal).
- Recording a progress note of any size — not bounded to "small". If the
  user has something substantial to record, capture it fully; don't
  compress it just because this is the lightweight-entry skill.

## Behavior

- Ask what they want to do only if it's not already clear from what they
  said when invoking this.
- Make the edit directly, following the existing conventions for whatever
  section of `planner.org` it belongs in (per the `planner` skill).
- Don't turn this into a guided conversation the way `daily-planning`
  does — capture and confirm, rather than walking through unrelated steps.
- If what the user describes doesn't obviously belong in `planner.org`
  (e.g. it's a reference note or idea for a topic file elsewhere in the
  notetaking system), ask where it should go rather than defaulting it
  into the planner file.
