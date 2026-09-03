#!/usr/bin/env bash
# Transition an ADR's status and, optionally, link a superseding ADR.
# Usage:
#   set_adr_status.sh 7 accepted
#   set_adr_status.sh 7 deprecated
#   set_adr_status.sh 7 superseded 12     # ADR-0007 superseded by ADR-0012

set -euo pipefail

if [[ $# -lt 2 ]]; then
  echo "usage: $0 <adr-number> <proposed|accepted|deprecated|superseded> [superseded-by-n]" >&2
  exit 2
fi

num="$1"
status="$2"
by="${3:-}"

case "$status" in
  proposed|accepted|deprecated|superseded) ;;
  *) echo "invalid status: $status" >&2; exit 2 ;;
esac

if [[ "$status" == "superseded" && -z "$by" ]]; then
  echo "superseded requires a superseding ADR number" >&2
  exit 2
fi

ADR_DIR="${ADR_DIR:-docs/adr}"
nnnn="$(printf '%04d' "$((10#$num))")"

# Find the file by prefix
file=""
shopt -s nullglob
for f in "$ADR_DIR"/${nnnn}-*.md; do
  file="$f"
done
shopt -u nullglob

if [[ -z "$file" ]]; then
  echo "no ADR found with number $nnnn in $ADR_DIR" >&2
  exit 1
fi

# Update status line in YAML frontmatter (portable sed).
tmp="$(mktemp)"
awk -v s="$status" '
  BEGIN { in_fm=0; done=0 }
  /^---$/ { in_fm = !in_fm; print; next }
  in_fm && !done && $1=="status:" { print "status: \"" s "\""; done=1; next }
  { print }
' "$file" > "$tmp" && mv "$tmp" "$file"

# If superseded, append a Links note.
if [[ "$status" == "superseded" ]]; then
  by_nnnn="$(printf '%04d' "$((10#$by))")"
  printf '\n> Superseded by ADR-%s on %s.\n' "$by_nnnn" "$(date -u +%Y-%m-%d)" >> "$file"
fi

echo "$file → $status${by:+ (by ADR-$(printf '%04d' "$((10#$by))"))}"
