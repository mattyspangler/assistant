# Global agent guidelines

Personal rules that apply across all opencode sessions on this machine.

## Secrets

- Never read, edit, or execute commands against anything under
  `~/Coding/secrets/` or `~/.config/sops/`. This is enforced by permission
  config (see `opencode.jsonc`), not just this instruction — but don't try
  to route around it (e.g. via a subshell, a different tool, or a relative
  path that resolves there).
- If a task seems to require a secret, stop and ask rather than trying to
  read it directly. Secrets get injected as environment variables at
  runtime by whatever process needs them (pipeline, shell session) — you
  should never need to open the encrypted files or the key yourself.
- Never print, log, or echo a secret value once it's in scope, even if
  you're allowed to use it.

## Destructive actions

- Ask before force-pushing, rewriting git history, or deleting anything
  outside the current project's working tree.
- Ask before running commands that touch system config (Guix, systemd,
  Shepherd services) — these are typically managed in a separate repo,
  not this one.

## General

- Prefer asking a clarifying question over guessing when a request is
  ambiguous.
- Keep explanations concise. Don't restate what was just asked back as
  preamble before doing it.
