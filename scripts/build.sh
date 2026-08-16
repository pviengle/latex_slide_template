#!/usr/bin/env bash
# ============================================================================
#  build.sh  --  build this presentation
# ----------------------------------------------------------------------------
#  macOS / Linux. Windows users: use scripts\build.ps1 instead (same options).
#
#  main.tex in the repo root IS the presentation. One copy of this repo is one
#  talk, so with no arguments this builds that.
#
#  Usage:
#     ./scripts/build.sh                      build this presentation
#     ./scripts/build.sh -e xe                force xelatex
#     ./scripts/build.sh -w                   rebuild on every save
#     ./scripts/build.sh -c                   clean intermediates first
#     ./scripts/build.sh -d showcase          build a deck in a subfolder
#     ./scripts/build.sh -a                   build this one and every subfolder
# ============================================================================
set -euo pipefail

DECK=""
ENGINE="default"
WATCH=0
CLEAN=0
ALL=0

usage() { sed -n '2,18p' "$0" | sed 's/^# \{0,1\}//'; exit 0; }

while getopts ":d:e:wcah" opt; do
  case "$opt" in
    d) DECK="$OPTARG" ;;
    e) ENGINE="$OPTARG" ;;
    w) WATCH=1 ;;
    c) CLEAN=1 ;;
    a) ALL=1 ;;
    h) usage ;;
    \?) echo "Unknown option -$OPTARG" >&2; exit 2 ;;
    :)  echo "Option -$OPTARG needs a value" >&2; exit 2 ;;
  esac
done

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_DIR="$REPO_ROOT/build"
mkdir -p "$BUILD_DIR"

# 'default' passes no flag, so the deck's own .latexmkrc decides the engine --
# which is how the Thai setup selects xelatex.
case "$ENGINE" in
  pdf)     ENGINE_FLAG="-pdf" ;;
  xe)      ENGINE_FLAG="-xelatex" ;;
  lua)     ENGINE_FLAG="-lualatex" ;;
  default) ENGINE_FLAG="" ;;
  *) echo "Unknown engine '$ENGINE' (use pdf, xe or lua)" >&2; exit 2 ;;
esac

# --- Which folders? ---------------------------------------------------------
#  The root folder is the presentation. Subfolders holding their own main.tex
#  are extra decks kept alongside it (showcase is one).
TARGETS=()
if [ -n "$DECK" ]; then
  DECK="${DECK//\\//}"; DECK="${DECK#./}"; DECK="${DECK%%/*}"
  if [ ! -f "$REPO_ROOT/$DECK/main.tex" ]; then
    echo "No deck named '$DECK' (looked for $REPO_ROOT/$DECK/main.tex)" >&2
    exit 1
  fi
  TARGETS+=("$REPO_ROOT/$DECK")
elif [ "$ALL" -eq 1 ]; then
  TARGETS+=("$REPO_ROOT")
  for d in "$REPO_ROOT"/*/; do
    name="$(basename "$d")"
    case "$name" in build|out|scripts|theme|preamble|figures|sections) continue ;; esac
    [ -f "$d/main.tex" ] && TARGETS+=("${d%/}")
  done
else
  if [ ! -f "$REPO_ROOT/main.tex" ]; then
    echo "No main.tex in $REPO_ROOT -- is this the right folder?" >&2
    exit 1
  fi
  TARGETS+=("$REPO_ROOT")
fi

FAILED=()

for target in "${TARGETS[@]}"; do
  # The root deck is named after the folder the repo was copied to, so a copy
  # called opdc-5stars/ produces build/opdc-5stars.pdf.
  name="$(basename "$target")"
  echo
  echo "==> $name"

  pushd "$target" >/dev/null

  [ "$CLEAN" -eq 1 ] && latexmk -C >/dev/null 2>&1 || true

  # --- Engine-change guard --------------------------------------------------
  #  Remember which engine produced the current out/ folder and wipe it when
  #  the engine changes: intermediates written by one engine are not readable
  #  by another.
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
  #  one written by a different engine breaks the build. main.pdf, main.log
  #  and main.synctex.gz are left alone: harmless, and the PDF is the one the
  #  editor is showing.
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
    echo "    FAILED - see $name/out/main.log" >&2
    FAILED+=("$name")
  fi

  popd >/dev/null
done

echo
if [ ${#FAILED[@]} -gt 0 ]; then
  echo "Failed: ${FAILED[*]}" >&2
  exit 1
fi
echo "Done."
