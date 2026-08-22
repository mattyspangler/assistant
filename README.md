# Assistant

A repo that makes my AI workflows reproducible and manageable: skills,
commands, MCP servers, prompts, and containerized agent pipelines.

## Layout

```
stow/opencode/.config/opencode/
              skills/       SKILL.md folders — agent auto-discovers & self-selects these
              commands/     opencode slash-commands — user-invoked, deterministic
              opencode.jsonc  canonical opencode config (plugins, agents, mcp, etc.)
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
