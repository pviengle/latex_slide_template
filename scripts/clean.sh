#!/usr/bin/env bash
# ============================================================================
#  clean.sh  --  remove build intermediates
# ----------------------------------------------------------------------------
#  macOS / Linux. Windows users: use scripts\clean.ps1 instead.
#
#  Usage:
#     ./scripts/clean.sh        intermediates only, PDFs kept
#     ./scripts/clean.sh -a     everything, including build/*.pdf
# ============================================================================
set -euo pipefail

ALL=0
while getopts ":ah" opt; do
  case "$opt" in
    a) ALL=1 ;;
    h) sed -n '2,11p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    \?) echo "Unknown option -$OPTARG" >&2; exit 2 ;;
  esac
done

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# The root folder is the presentation; subfolders with their own main.tex are
# extra decks kept beside it.
DIRS=("$REPO_ROOT")
for d in "$REPO_ROOT"/*/; do
  case "$(basename "$d")" in build|out|scripts|theme|preamble|figures|sections) continue ;; esac
  [ -f "$d/main.tex" ] && DIRS+=("${d%/}")
done

for d in "${DIRS[@]}"; do
  [ -f "$d/main.tex" ] || continue
  name="$(basename "$d")"
  pushd "$d" >/dev/null
  if [ "$ALL" -eq 1 ]; then
    latexmk -C >/dev/null 2>&1 || true
    rm -rf out
  else
    latexmk -c >/dev/null 2>&1 || true
  fi
  echo "cleaned $name"
  popd >/dev/null
done

if [ "$ALL" -eq 1 ]; then
  rm -rf "$REPO_ROOT/build"
  echo "removed build/"
fi

echo "Done."
