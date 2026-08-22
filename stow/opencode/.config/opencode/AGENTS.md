# Global agent guidelines

Personal rules that apply across all opencode sessions on this machine.

## Code quality

- Explain *why*, not *what*. Comments cover only non-obvious engineering
  decisions, architectural constraints, or business reasons.
- Delete comments that restate native features, variable names, or
  function names.
- Keep comments to single-line fragments or punchy one-sentence
  statements. Strip conversational filler.
- Use imperative mood for technical notes. "Cache…", "Throttle…",
  "Bypass…", "Normalize…".
- Flag temporary code: `TODO:` (planned), `FIXME:` (broken),
  `NOTE:` (non-obvious dependency).
- Do not add comments to generated code unless asked.

## Secrets

- Never read, edit, or execute commands against anything under
  `~/Coding/secrets/` or `~/.config/sops/`. Permission config already
  blocks this — do not try to route around it via subshell, a different
  tool, or relative-path resolution.
- When a task appears to need a secret, stop and ask. Secrets are injected
  as environment variables at runtime by the process that needs them.
- Never print, log, or echo a secret value once it is in scope.

## Git

- Never commit without checking in first. Commits must be explicit
  human decisions.
- Write commit messages for human review — no auto-commits, no
  auto-generated messages.
- Ask before force-pushing, rewriting git history, or deleting anything
  outside the current project's working tree.

## Destructive actions

- Ask before touching system config (Guix, systemd, Shepherd). These live
  in separate repos.

## General

- Ask a clarifying question when a request is ambiguous. Do not guess.
- Keep responses concise. Do not restate the request as preamble.
