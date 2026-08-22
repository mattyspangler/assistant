# Assistant

A repo that makes my AI workflows reproducible and manageable: skills,
commands, MCP servers, prompts, and containerized agent pipelines.

## Layout

```
stow/opencode/.config/opencode/
              skills/              SKILL.md folders — agent auto-discovers these
              commands/            opencode slash-commands — user-invoked, deterministic
              opencode-base.jsonc   repo-managed config (plugins, permissions)
              AGENTS.md             global agent guidelines
mcp/          MCP server configs/notes
prompts/      reusable prompt text for use OUTSIDE opencode commands
pipelines/    containerized/scheduled agent task execution
  dagger/       Dagger modules/functions
  images/       Dockerfiles for agent containers
  scheduling/   docs on what's scheduled + why
notes/        personal notes, reference docs
```

## Setup

```
stow -d stow -t ~ opencode
```

Symlinks `stow/opencode/.config/opencode` into `~/.config/opencode`.

Then, on every machine that uses this repo, set an environment variable so
OpenCode loads the repo-managed config as a layer *without* overwriting the
machine's own local `~/.config/opencode/opencode.jsonc`:

```
export OPENCODE_CONFIG=~/.config/opencode/opencode-base.jsonc
```

Add this to your shell rc or Guix Home config.
