# AGENTS.md

Instructions for AI agents working on this repo. These rules apply to every session here.

## General

- After structural changes (renames, moves, reorgs), check `README.md` and the docs folder and update any references that now point to stale paths or outdated names.
- Every change must be rigorous and justifiable. If the direction is vague or ambiguous, or if you spot slop code — stop and ask for human input.
- Significant changes always get human review before being committed.

## Software installation

- Never install packages, tools, or dependencies without asking the user how they want it done. The user owns the security review of what runs on their machine — do not bypass that by installing things silently.
- If extra software is required for something in this repo, document it so the setup is reproducible on another machine.

## External repos and tools

- When adding something that tracks an external repo or tool, don't keep a second copy unless there's no other option. Prefer a pinned reference plus a documented way to update from upstream (e.g. a version pin + reinstall command, a pinned plugin/package reference) over vendoring or diffing a local copy.

## Review before adding

- Review a new skill's, plugin's, or MCP server's source and requested permissions before adding it to `opencode-base.jsonc` or committing it here. Don't add third-party agent-facing capabilities on trust alone.

## Unattended/containerized agents

- Unattended or containerized pipeline agents follow the hardening checklist in `PLAN.md` §5 (ephemeral containers, network:none by default, read-only root, cap-drop, bind-mount blocklist for credential paths).
