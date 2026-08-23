# codium-fedora container

Primary dev workspace: VSCodium + OpenCode + Dagger (via Podman) + dev-browser,
all in one declarative distrobox container — one workspace, one place
OpenCode can both edit code and drive containerized agent tasks.

## Required host-level prerequisite (do this first, every machine)

Dagger and Podman-in-distrobox both need the host's Podman API socket
running. This is NOT inside the container — it's a one-time host setup step,
easy to miss because nothing fails until you actually try to use Podman/Dagger
from inside the container:

```
systemctl --user enable --now podman.socket
```

Verify: `systemctl --user status podman.socket` should show `active (listening)`.
Without this, distrobox's Podman client inside the container has nothing to
talk to on the host side, and Dagger workflows will fail to launch anything.

## One-time setup (per machine)

```
distrobox assemble create -f containers/codium-fedora/distrobox.ini
```

VSCodium, dev-browser's Chromium dependencies, and a Podman client all install
automatically via the manifest. Then, inside the container:

```
distrobox enter codium-fedora -- bash -lc '
  npm config set prefix ~/.npm-global &&
  echo "export PATH=~/.npm-global/bin:\$PATH" >> ~/.bashrc &&
  npm install -g opencode-ai &&
  npm install -g --allow-scripts=dev-browser dev-browser@0.2.9 &&
  dev-browser install
'
distrobox-export --app codium
distrobox-export --bin ~/.npm-global/bin/opencode
distrobox-export --bin ~/.npm-global/bin/dev-browser
```

The `distrobox-export` calls make `codium`, `opencode`, and `dev-browser` all
launchable directly from the host, transparently running inside the container.

Install Dagger's CLI inside the container per
[Dagger's own install docs](https://docs.dagger.io/getting-started/installation)
— it works with Podman as the runtime, not Docker-only (confirmed: "Docker
works out of the box; Podman, nerdctl, and Apple Container also work").

### MemPalace (local AI memory system)

Verify the source before installing — its own README warns of active
impostor sites. Only these are legitimate: `github.com/MemPalace/mempalace`,
the PyPI package `mempalace`, and `mempalaceofficial.com`.

```
distrobox enter codium-fedora -- bash -lc 'uv tool install mempalace'
```

Uses the default ChromaDB backend (local, no extra config). Not yet wired
into `opencode-base.jsonc` as an MCP server — its MCP tools include writes,
which needs a permission-scoping review first (see PLAN.md §8, "Review
before adding" in `AGENTS.md`).

## Update

Bump pinned versions (opencode-ai, dev-browser, Dagger, mempalace) and
re-run the relevant install commands inside the container. Nothing here is
a vendored copy of any of these tools — this repo only records how to
reproduce the container they run in, consistent with the install-only
pattern (see PLAN.md §7).

## Architecture note: why OpenCode-in-a-container can still launch other containers

Dagger doesn't nest containers inside whatever process is running it — it
talks to a container *engine* (Podman here) over a socket and asks that
engine to create sibling containers, which are peers, not children. distrobox
forwards a socket path into the container; as long as the host's Podman
socket is actually running (see prerequisite above), Dagger commands run
inside `codium-fedora` can launch fresh, isolated sibling containers at the
host level — e.g. for the unattended pipeline pattern in PLAN.md §5.
