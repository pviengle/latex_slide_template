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

# Accept the deck as a bare name or as a path, and reduce it to the name:
#   showcase  decks/showcase  decks/showcase/sections  ->  showcase
# VS Code's ${relativeFileDirname} hands us the last of those, and tab
# completion in a shell produces the middle one.
if [ "$DECK" != "all" ]; then
  DECK="${DECK//\\//}"      # accept backslashes too
  DECK="${DECK#./}"
  DECK="${DECK#decks/}"
  DECK="${DECK%%/*}"
fi

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

  # --- In-editor leftovers --------------------------------------------------
  #  TeXstudio (and TeXworks, TeXShop, ...) build in place, leaving main.aux
  #  next to main.tex. latexmk keeps its own copy in out/, so a top-level
  #  main.aux is never ours -- but TeX still finds it on the search path, and
  #  a pdflatex run chokes on one that xelatex wrote (it holds \xpg@aux).
  #  The engine stamp above cannot see these, so clear them separately.
  #  main.pdf, main.log and main.synctex.gz are left alone: harmless, and the
  #  PDF is the one the editor is showing.
  stray=""
  for ext in aux bbl bcf run.xml toc nav snm out vrb; do
    [ -f "main.$ext" ] && stray="$stray main.$ext"
  done
  if [ -n "$stray" ]; then
    echo "    clearing in-editor leftovers:$stray"
    rm -f $stray
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
