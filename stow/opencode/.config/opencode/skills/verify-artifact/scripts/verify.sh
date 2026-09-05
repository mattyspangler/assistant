#!/usr/bin/env bash
set -euo pipefail
export LC_ALL=C LANG=C

usage() {
  cat <<'EOF'
Usage: verify.sh --file <path> [--sig <path>] [--key <path> ...]
                  [--digest-file <path>] [--expected-size <bytes>]
                  [--require-chain "<child-fpr> signed_by <parent-fpr>"]
                  [--device <path>]

At least one of --sig or --digest-file is required.

--device is only relevant for artifacts meant to be burned/written to
physical media (e.g. a bootable ISO). It prints (does not run) the dd
command to write the artifact to the device, and the command to
re-verify the signature directly against the device afterward. Requires
--sig. Re-verifying after writing guards against tampering introduced
during the write step itself, which a signature check on the original
file alone would not catch.
EOF
}

FILE=""
SIG=""
DIGEST_FILE=""
EXPECTED_SIZE=""
REQUIRE_CHAIN=""
DEVICE=""
KEYS=()

# Guard against bash's unbound-variable crash on a trailing flag with no value.
require_value() {
  if [[ $# -lt 2 ]]; then
    echo "ERROR: $1 requires a value" >&2
    usage >&2
    exit 2
  fi
}
warn_if_set() {
  if [[ -n "$2" ]]; then
    echo "WARNING: $1 given more than once; using the last value" >&2
  fi
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --file) require_value "$@"; warn_if_set --file "$FILE"; FILE="$2"; shift 2 ;;
    --sig) require_value "$@"; warn_if_set --sig "$SIG"; SIG="$2"; shift 2 ;;
    --key)
      require_value "$@"
      if [[ -z "$2" ]]; then
        echo "ERROR: --key requires a non-empty path" >&2
        exit 2
      fi
      KEYS+=("$2"); shift 2 ;;
    --digest-file) require_value "$@"; warn_if_set --digest-file "$DIGEST_FILE"; DIGEST_FILE="$2"; shift 2 ;;
    --expected-size) require_value "$@"; warn_if_set --expected-size "$EXPECTED_SIZE"; EXPECTED_SIZE="$2"; shift 2 ;;
    --require-chain) require_value "$@"; warn_if_set --require-chain "$REQUIRE_CHAIN"; REQUIRE_CHAIN="$2"; shift 2 ;;
    --device) require_value "$@"; warn_if_set --device "$DEVICE"; DEVICE="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown argument: $1" >&2; usage >&2; exit 2 ;;
  esac
done

if [[ -z "$FILE" ]]; then
  echo "ERROR: --file is required" >&2
  usage >&2
  exit 2
fi
if [[ ! -f "$FILE" ]]; then
  echo "ERROR: --file '$FILE' does not exist" >&2
  exit 2
fi
if [[ -n "$DEVICE" && -z "$SIG" ]]; then
  echo "ERROR: --device requires --sig" >&2
  exit 2
fi
if [[ -z "$DEVICE" && -z "$SIG" && -z "$DIGEST_FILE" ]]; then
  echo "ERROR: at least one of --sig or --digest-file is required" >&2
  exit 2
fi

# --- Dependency preflight ---
missing=()
command -v gpg >/dev/null 2>&1 || missing+=("gpg")
command -v stat >/dev/null 2>&1 || missing+=("stat")
if ! command -v sha256sum >/dev/null 2>&1 && ! command -v shasum >/dev/null 2>&1; then
  missing+=("sha256sum or shasum")
fi
if [[ ${#missing[@]} -gt 0 ]]; then
  echo "ERROR: missing required tool(s): ${missing[*]}" >&2
  exit 2
fi

sha256() {
  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum -- "$1" | awk '{print $1}'
  else
    shasum -a 256 -- "$1" | awk '{print $1}'
  fi
}
sha512() {
  if command -v sha512sum >/dev/null 2>&1; then
    sha512sum -- "$1" | awk '{print $1}'
  else
    shasum -a 512 -- "$1" | awk '{print $1}'
  fi
}

GNUPGHOME_DIR="$(mktemp -d)"
cleanup() { rm -rf "$GNUPGHOME_DIR"; }
trap cleanup EXIT
chmod 700 "$GNUPGHOME_DIR"
export GNUPGHOME="$GNUPGHOME_DIR"

declare -A RESULTS
declare -a RESULT_ORDER

pass() {
  RESULTS["$1"]="PASS"
  RESULT_ORDER+=("$1")
  echo "CHECK $1: PASS"
}
fail() {
  RESULTS["$1"]="FAIL"
  RESULT_ORDER+=("$1")
  echo "CHECK $1: FAIL - $2"
}

# --- Size check ---
if [[ -n "$EXPECTED_SIZE" ]]; then
  echo "=== Size check ==="
  actual_size="$(stat -c %s -- "$FILE")"
  echo "expected: $EXPECTED_SIZE"
  echo "actual:   $actual_size"
  if [[ "$actual_size" == "$EXPECTED_SIZE" ]]; then
    pass "size"
  else
    fail "size" "expected $EXPECTED_SIZE, got $actual_size"
  fi
fi

# --- Digest-file check ---
if [[ -n "$DIGEST_FILE" ]]; then
  echo "=== Digest-file check ==="
  echo "NOTE: a match proves integrity (no corruption in transit)."
  echo "NOTE: it does not prove authenticity unless the digest file is itself signed."
  if [[ ! -f "$DIGEST_FILE" ]]; then
    fail "digest_file" "digest file '$DIGEST_FILE' does not exist"
  else
    base_name="$(basename -- "$FILE")"
    computed_sha256="$(sha256 "$FILE")"
    computed_sha512="$(sha512 "$FILE")"
    echo "computed sha256: $computed_sha256"
    echo "computed sha512: $computed_sha512"

    match_found=0
    mismatch_found=0
    while IFS= read -r line; do
      line="${line%$'\r'}"
      [[ -z "$line" ]] && continue
      [[ "$line" == \#* ]] && continue
      hash="$(awk '{print $1}' <<<"$line")"
      if [[ ! "$hash" =~ ^[0-9a-fA-F]+$ ]]; then
        continue
      fi
      hash="${hash,,}"
      case "${#hash}" in
        64) algo=sha256; want="$computed_sha256" ;;
        128) algo=sha512; want="$computed_sha512" ;;
        *) echo "skipping unrecognized hash length ${#hash}: '$hash'"; continue ;;
      esac

      # A bare hash with no filename field applies to --file directly —
      # many project pages publish digests with no filename at all.
      rest="$(awk '{ $1=""; sub(/^ /,""); print }' <<<"$line")"
      if [[ -n "$rest" ]]; then
        fname="${rest#\*}"
        fname="$(basename -- "$fname")"
        [[ "$fname" == "$base_name" ]] || continue
      fi

      if [[ "$hash" == "$want" ]]; then
        echo "MATCH    $algo digest-file entry for ${rest:-$base_name}"
        match_found=1
      else
        echo "MISMATCH $algo digest-file entry for ${rest:-$base_name}: file has $hash, computed $want"
        mismatch_found=1
      fi
    done < "$DIGEST_FILE"

    if [[ "$mismatch_found" -eq 1 ]]; then
      fail "digest_file" "one or more digest-file entries did not match the computed hash"
    elif [[ "$match_found" -eq 1 ]]; then
      pass "digest_file"
    else
      fail "digest_file" "no entry in digest file matched filename '$base_name'"
    fi
  fi
fi

# --- Key import ---
if [[ ${#KEYS[@]} -gt 0 ]]; then
  echo "=== Key import ==="
  import_failed=0
  for k in "${KEYS[@]}"; do
    echo "--- importing $k ---"
    if [[ ! -f "$k" ]]; then
      echo "ERROR: key file '$k' does not exist"
      import_failed=1
      continue
    fi
    if ! gpg --batch --import "$k"; then
      import_failed=1
    fi
  done
  if [[ "$import_failed" -eq 1 ]]; then
    fail "key_import" "one or more keys failed to import"
  else
    pass "key_import"
  fi
fi

# --- Chain-of-trust check ---
if [[ -n "$REQUIRE_CHAIN" ]]; then
  echo "=== Chain-of-trust check ==="
  # Split on the literal " signed_by " separator, not on whitespace generally —
  # fingerprints are often written with internal spaces (4-char groups).
  if [[ "$REQUIRE_CHAIN" == *" signed_by "* ]]; then
    chain_child="${REQUIRE_CHAIN%% signed_by *}"
    chain_parent="${REQUIRE_CHAIN##* signed_by }"
  else
    chain_child=""
    chain_parent=""
  fi
  chain_child="${chain_child// /}"
  chain_child="${chain_child^^}"
  chain_parent="${chain_parent// /}"
  chain_parent="${chain_parent^^}"
  if [[ -z "$chain_child" || -z "$chain_parent" ]]; then
    fail "chain_of_trust" "could not parse --require-chain value: '$REQUIRE_CHAIN'"
  else
    echo "asserting: $chain_child signed_by $chain_parent"
    sig_output="$(gpg --with-colons --check-signatures "$chain_child" 2>&1)" || true
    echo "$sig_output"
    if awk -F: -v want="$chain_parent" '$1=="sig" && $2=="!" && $13==want {found=1} END{exit !found}' <<<"$sig_output"; then
      pass "chain_of_trust"
    else
      fail "chain_of_trust" "no valid (sig!) signature by $chain_parent found on $chain_child"
    fi
  fi
fi

# --- Signature verification ---
# GOODSIG is the right bar, not gpg's TRUST_FULLY/TRUST_ULTIMATE — this
# keyring is ephemeral and never webbed, so gpg will always report
# TRUST_UNDEFINED regardless of key correctness. The human already
# corroborated the fingerprint out-of-band before it reached --key.
if [[ -n "$SIG" ]]; then
  echo "=== Signature verification ==="
  set +e
  verify_output="$(gpg --status-fd 1 --verify -- "$SIG" "$FILE" 2>&1)"
  verify_exit=$?
  set -e
  echo "$verify_output"
  if grep -q '^\[GNUPG:\] GOODSIG' <<<"$verify_output"; then
    pass "signature"
  else
    fail "signature" "no GOODSIG status line (gpg exit $verify_exit)"
  fi
fi

# --- Device write + re-verification (advisory only, for burnable media) ---
# Reading/writing a raw block device needs root, and a script should not
# decide on its own to escalate privileges. This prints self-contained
# commands — it does not touch the device — for the human to run.
if [[ -n "$DEVICE" ]]; then
  echo "=== Device write + re-verification ==="
  artifact_size="$(stat -c %s -- "$FILE")"
  key_args=""
  for k in "${KEYS[@]}"; do
    key_args+=" --import $(printf '%q' "$k") &&"
  done
  cat <<EOF
Not run automatically — review the target device carefully (wrong device =
data loss), then run yourself with sudo.

1) Write the artifact to the device:

sudo dd if=$(printf '%q' "$FILE") of=$(printf '%q' "$DEVICE") bs=4M status=progress conv=fsync

2) Re-verify what actually landed on the device, independent of what was
   written above:

sudo sh -c '
  d=\$(mktemp -d); chmod 700 "\$d";
  GNUPGHOME="\$d" gpg --batch${key_args% &&} ;
  dd if=$(printf '%q' "$DEVICE") bs=1M count=$artifact_size iflag=count_bytes status=progress |
    GNUPGHOME="\$d" gpg --status-fd 1 --verify $(printf '%q' "$SIG") - ;
  rm -rf "\$d"
'

Step 2 reads exactly the first $artifact_size bytes off the device — the
size of $FILE — and verifies them against $SIG using a throwaway keyring
built from the same --key file(s) given to this script. A GOODSIG here
means the data actually on the device matches what was verified above; it
does not re-run the other checks (size/digest/chain).
EOF
fi

echo "=== Summary ==="
overall=0
for name in "${RESULT_ORDER[@]}"; do
  echo "CHECK $name: ${RESULTS[$name]}"
  [[ "${RESULTS[$name]}" == "PASS" ]] || overall=1
done
exit "$overall"
