#!/usr/bin/env bash
# ============================================================================
#  build.sh  --  build one deck, or every deck, and collect PDFs into build/
# ----------------------------------------------------------------------------
#  macOS / Linux. Windows users: use scripts\build.ps1 instead (same options).
#
#  Usage:
#     ./scripts/build.sh                      build every deck
#     ./scripts/build.sh -d showcase          build one deck
#     ./scripts/build.sh -d showcase -e xe    force xelatex
#     ./scripts/build.sh -d showcase -w       rebuild on every save
#     ./scripts/build.sh -c                   clean intermediates first
# ============================================================================
set -euo pipefail

DECK="all"
ENGINE="default"
WATCH=0
CLEAN=0

usage() { sed -n '2,15p' "$0" | sed 's/^# \{0,1\}//'; exit 0; }

while getopts ":d:e:wch" opt; do
  case "$opt" in
    d) DECK="$OPTARG" ;;
    e) ENGINE="$OPTARG" ;;
    w) WATCH=1 ;;
    c) CLEAN=1 ;;
    h) usage ;;
    \?) echo "Unknown option -$OPTARG" >&2; exit 2 ;;
    :)  echo "Option -$OPTARG needs a value" >&2; exit 2 ;;
  esac
done

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DECKS_DIR="$REPO_ROOT/decks"
BUILD_DIR="$REPO_ROOT/build"
mkdir -p "$BUILD_DIR"

# 'default' passes no flag, so the deck's own .latexmkrc decides the engine --
# which is how Thai decks select xelatex.
case "$ENGINE" in
  pdf)     ENGINE_FLAG="-pdf" ;;
  xe)      ENGINE_FLAG="-xelatex" ;;
  lua)     ENGINE_FLAG="-lualatex" ;;
  default) ENGINE_FLAG="" ;;
  *) echo "Unknown engine '$ENGINE' (use pdf, xe or lua)" >&2; exit 2 ;;
esac

# Which decks? Anything with a main.tex, skipping the _template scaffold.
TARGETS=()
if [ "$DECK" = "all" ]; then
  for d in "$DECKS_DIR"/*/; do
    name="$(basename "$d")"
    [ "$name" = "_template" ] && continue
    [ -f "$d/main.tex" ] && TARGETS+=("$d")
  done
else
  if [ ! -f "$DECKS_DIR/$DECK/main.tex" ]; then
    echo "No deck named '$DECK' (looked for $DECKS_DIR/$DECK/main.tex)" >&2
    exit 1
  fi
  TARGETS+=("$DECKS_DIR/$DECK/")
fi

if [ ${#TARGETS[@]} -eq 0 ]; then
  echo "No decks found in $DECKS_DIR" >&2
  exit 0
fi

FAILED=()

for target in "${TARGETS[@]}"; do
  name="$(basename "$target")"
  echo
  echo "==> $name"

  pushd "$target" >/dev/null

  [ "$CLEAN" -eq 1 ] && latexmk -C >/dev/null 2>&1 || true

  # --- Engine-change guard --------------------------------------------------
  #  XeLaTeX and LuaLaTeX write polyglossia macros such as \xpg@aux into the
  #  .aux file. pdfLaTeX does not load polyglossia, so reading a stale .aux
  #  left by another engine kills the build with
  #  "Undefined control sequence \xpg@aux".
  #
  #  So: remember which engine produced the current out/ folder, and wipe it
  #  whenever the engine changes.
  engine_label="$ENGINE"
  if [ "$engine_label" = "default" ]; then
    engine_label="pdf"
    if [ -f .latexmkrc ]; then
      if   grep -qE '^[[:space:]]*\$pdf_mode[[:space:]]*=[[:space:]]*5' .latexmkrc; then engine_label="xe"
      elif grep -qE '^[[:space:]]*\$pdf_mode[[:space:]]*=[[:space:]]*4' .latexmkrc; then engine_label="lua"
      fi
    fi
  fi
  if [ -f out/.engine ] && [ "$(cat out/.engine)" != "$engine_label" ]; then
    echo "    engine changed -> cleaning first"
    rm -rf out
  fi

  args=(-interaction=nonstopmode -halt-on-error)
  [ -n "$ENGINE_FLAG" ] && args+=("$ENGINE_FLAG")
  [ "$WATCH" -eq 1 ] && args+=(-pvc)
  args+=(main.tex)

  if latexmk "${args[@]}"; then
    printf '%s' "$engine_label" > out/.engine
    if [ -f out/main.pdf ]; then
      cp -f out/main.pdf "$BUILD_DIR/$name.pdf"
      echo "    OK -> build/$name.pdf"
    fi
  else
    echo "    FAILED - see decks/$name/out/main.log" >&2
    FAILED+=("$name")
  fi

  popd >/dev/null
done

echo
if [ ${#FAILED[@]} -gt 0 ]; then
  echo "Failed: ${FAILED[*]}" >&2
  exit 1
fi
echo "All decks built."
