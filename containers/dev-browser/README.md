# dev-browser container

Containerized dev-browser (browser automation for AI agents). 

## One-time setup (per machine)

```
distrobox assemble create -f containers/dev-browser/distrobox.ini
distrobox enter dev-browser -- bash -lc 'npm config set prefix ~/.npm-global && echo "export PATH=~/.npm-global/bin:\$PATH" >> ~/.bashrc'
distrobox enter dev-browser -- bash -lc 'export PATH=~/.npm-global/bin:$PATH && npm install -g --allow-scripts=dev-browser dev-browser@0.2.9 && dev-browser install'
```

The `npm config set prefix` line is required because the container's
default npm prefix (`/usr/local`) is root-owned and global installs would
be rejected by modern npm.

## Update

Bump the pinned version in the `npm install` line above, re-run the three
`distrobox enter` commands on each machine. 

## Notes

- The distrobox.ini `additional_packages` list is the complete set of
  Chromium shared-library dependencies; do not trim it casually or launch
  fails with a missing `.so` error.
