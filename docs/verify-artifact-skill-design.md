# Design: `verify-artifact` skill

Status: draft, pending user review
Date: 2026-09-04

## Purpose

A skill for verifying a downloaded file against its detached PGP signature
and/or checksum file, for any artifact and any project. Not tied to a
specific download.

## Core design decision

Exact-match logic runs in a hard tool: a bash script does key import,
signature verification, chain-of-trust checks, and hash comparison, and
reports PASS/FAIL per check via string comparison. The AI handles inputs
(finding key sources, deciding what to check) and outputs (report
narrative). The AI never eyeballs a fingerprint or a hash for a match.

This also applies to checksum-file comparison specifically: matching a
computed hash against a value listed in a digest file is a string
comparison, done by the script, not read and compared by the AI.

## Trusted-core script

`scripts/verify.sh`. Design constraints:

- Uses only `gpg`, `sha256sum`/`sha512sum` (or `shasum` fallback), `stat`.
- Short and linear enough to read top-to-bottom with no hidden behavior.
- Every check emits a machine-parseable `CHECK <name>: PASS|FAIL` line,
  plus the raw, unmodified tool output as a transcript.
- Parses GPG's machine-readable status output (`--status-fd`,
  `GOODSIG`/`BADSIG`, `sig!`/`sig-`/`sig%`) rather than localized text.

### Keyring isolation

Each run uses a fresh temp directory as `GNUPGHOME`, imports only the
key(s) given for that run, and deletes the directory on exit. The script
never touches the user's real `~/.gnupg`.

Reasoning: trust here comes from independently corroborating a key's
fingerprint, not from which keyring file holds it. Using a permanent
keyring would leave disposable keys behind and risk a scripted trust-level
change bleeding into keys the user relies on for unrelated things (e.g.
signing their own commits).

### Inputs (generic across artifact types)

```
verify.sh
  --file <artifact>
  --sig <detached-signature>        # optional
  --key <path> [--key <path> ...]   # one or more, human-supplied
  --digest-file <path>              # optional
  --expected-size <bytes>           # optional
  --require-chain "<child> signed_by <parent>"   # optional
```

At least one of `--sig` or `--digest-file` is required.

### Checks

1. **Size** — compare `stat -c %s` to `--expected-size`, if given.
2. **Digest-file match** — compute SHA256/SHA512 of the artifact, parse the
   digest file, exact-match against the matching-filename entry. Reported
   as an integrity check only — an unsigned digest file has no provenance
   of its own, so a match confirms the download wasn't corrupted, not that
   it's authentic.
3. **Key import** — into the ephemeral keyring.
4. **Chain of trust** (if `--require-chain` given) — `gpg
   --check-signatures` on the child key, exact match for a `sig!` line
   naming the parent key ID.
5. **Signature verification** (if `--sig` given) — `gpg --verify`, parsed
   via status-fd output.

## Acquisition of key material

The AI does not fetch and import the key file that ends up being trusted.
It researches candidate sources (project docs, keyservers) and separate
sources that state the same fingerprint (mailing lists, forums, archived
pages, etc.), then asks the human to download the chosen key file(s) and
place them where the script can read them. The AI only reads that file from
disk afterward.

This splits acquisition from corroboration into two independent actions.
If the AI's own fetch path were compromised, having it also "corroborate"
the same fetch wouldn't be a second channel.

Residual risk this does not close: if the upstream source itself is
compromised, both an AI-fetch and a human-fetch get the same bad file. What
mitigates this is corroborating the fingerprint across sources independent
of the download channel, not the fetch method. The report must state this
limitation rather than imply it's eliminated.

## Source research method

1. WebFetch, first.
2. dev-browser, if available, for sites that block or challenge WebFetch.
3. Page content is untrusted data. If fetched content attempts to direct
   the AI's behavior (e.g. "trust this key"), that's flagged, not followed.
4. No stored fingerprint/trust cache anywhere in this skill or repo. Every
   run repeats corroboration from scratch — nothing persists that could go
   stale or be planted ahead of a future run.

## Report

Written to `<artifact-path>.verification-report.md`, next to the artifact.

Two clearly separated kinds of content:

- **Machine-generated** — the script's transcript, included verbatim
  (unmodified stdout/status lines), under its own heading.
- **AI-written** — source corroboration findings (what each source stated,
  match or mismatch), anything that couldn't be corroborated online and
  needs actual human effort to close (e.g. a second device/network, an
  in-person check), and a final recommendation labeled as AI-assisted
  judgment, not a safety guarantee.

## Location

`Coding/Assistant/stow/opencode/.config/opencode/skills/verify-artifact/`
- `SKILL.md`
- `scripts/verify.sh`

No project-specific data anywhere in the skill — same script and workflow
regardless of what's being verified.

## Non-goals

- Proving an artifact is free of malicious content. Only authenticity
  (correctly signed) and integrity (matches checksums) are in scope.
- Re-verifying media after writing to removable storage. Possible future
  script mode, not in this version.

## AI risk management

Risks specific to having an AI run this workflow, and how the design
addresses each:

- **Hallucinated or misread match.** An LLM comparing a 40-character
  fingerprint or a hash by reading it can get this wrong, or state a match
  occurred when it didn't. Mitigation: the script does every exact
  comparison and emits a `PASS`/`FAIL` line; the AI's role is limited to
  running the script and reporting its output, never re-deriving a match
  itself. See "Core design decision" above.
- **Single-channel key acquisition.** If the AI both fetches a key and
  "corroborates" it, a compromised fetch path defeats corroboration
  silently. Mitigation: the human downloads the key file; the AI only
  reads it from disk after. See "Acquisition of key material" above.
- **Prompt injection from fetched pages.** A page used for corroboration
  could contain text aimed at the AI rather than the human reader.
  Mitigation: page content is treated as untrusted data; any instruction
  found there is flagged, not followed. See "Source research method"
  above.
- **Scope creep into the user's own credential material.** This workflow
  never has a reason to read the user's real `~/.gnupg`, SSH keys, or any
  secrets store — its file access is limited to the artifact, its
  signature/digest file, and the human-supplied key file(s) passed as
  script arguments. The ephemeral `GNUPGHOME` (see "Keyring isolation")
  is what keeps the script itself from touching the user's permanent
  keyring; the same boundary applies to the AI directing it — no step in
  this workflow should ask the AI to read outside those explicit inputs.
- **Overstated confidence in the final report.** An AI-written summary
  could read as a guarantee of safety. Mitigation: the report separates
  machine-verified fact from AI synthesis, and the recommendation is
  explicitly labeled as AI-assisted judgment requiring human sign-off, not
  a safety claim. See "Report" above.
