#!/usr/bin/env bash
# Seed a new ADR with the next zero-padded number and a kebab-cased slug.
# Usage: new_adr.sh "Use Temporal Update over Signal+Query polling"
#   -> writes docs/adr/0007-use-temporal-update-over-signal-query-polling.md

set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "usage: $0 \"<title>\"" >&2
  exit 2
fi

TITLE="$*"
ADR_DIR="${ADR_DIR:-docs/adr}"
mkdir -p "$ADR_DIR"

# Find the template relative to this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE="${TEMPLATE:-$SCRIPT_DIR/../assets/templates/adr-madr.md}"

if [[ ! -f "$TEMPLATE" ]]; then
  echo "template not found: $TEMPLATE" >&2
  exit 1
fi

# Compute next number: 0001 if none, else max+1, zero-padded to 4.
last_num=0
shopt -s nullglob
for f in "$ADR_DIR"/[0-9][0-9][0-9][0-9]-*.md; do
  base="$(basename "$f")"
  n="${base%%-*}"
  # strip leading zeros safely
  n="$((10#$n))"
  (( n > last_num )) && last_num=$n
done
shopt -u nullglob
next_num=$((last_num + 1))
nnnn="$(printf '%04d' "$next_num")"

# Kebab-case slug: lowercase, non-alnum → '-', squeeze, trim.
slug="$(echo "$TITLE" \
  | tr '[:upper:]' '[:lower:]' \
  | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//')"

out="$ADR_DIR/${nnnn}-${slug}.md"
date_iso="$(date -u +%Y-%m-%d)"

sed \
  -e "s/{{NNNN}}/${nnnn}/g" \
  -e "s/{{TITLE}}/${TITLE//\//\\/}/g" \
  -e "s/{{DATE}}/${date_iso}/g" \
  "$TEMPLATE" > "$out"

echo "$out"
