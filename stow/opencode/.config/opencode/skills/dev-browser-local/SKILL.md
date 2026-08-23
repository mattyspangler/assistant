---
name: dev-browser-local
description: Connect the dev-browser tool to a local browser via CDP instead of its own broken Playwright Chromium. Use when a task needs browser automation and dev-browser must run against this machine's browser.
---

# dev-browser local setup

Pairs with the `dev-browser` skill (upstream) — do not duplicate its API
reference; this covers only how to connect on this machine.

## Rule

Always invoke `dev-browser` with `--connect`. Never let it launch its own
managed Chromium — that download does not work on this immutable (OSTree)
host.

## How it runs

dev-browser lives in the `dev-browser` distrobox container. To run from the
host, launch the browser with remote debugging, then connect:

    dev-browser --connect http://localhost:9222 --headless <<'EOF'
    const page = await browser.getPage("main");
    await page.goto("https://example.com", { waitUntil: "domcontentloaded" });
    console.log(await page.title());
    EOF

Do not run `dev-browser install` on the host; do not pipe scripts to a
daemon-managed browser. Connection mode only.
