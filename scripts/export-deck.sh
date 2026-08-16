#!/usr/bin/env bash
# ============================================================================
#  export-deck.sh  --  bundle one deck into a standalone, movable folder
# ----------------------------------------------------------------------------
#  macOS / Linux. Windows users: use scripts\export-deck.ps1 (same options).
#
#  A deck inside this repo depends on ../../theme and ../../preamble. Copy the
#  deck folder on its own and it stops building. This copies the deck AND its
#  dependencies into one folder and rewrites the single line that points at
#  them, so the result builds by itself -- in TeXstudio, from a terminal, or
#  uploaded straight to Overleaf.
#
#  Usage:
#     ./scripts/export-deck.sh -d showcase
#     ./scripts/export-deck.sh -d my-talk -t ~/talks/my-talk
#     ./scripts/export-deck.sh -d my-talk -z        # also make a .zip
#     ./scripts/export-deck.sh -d my-talk -f        # overwrite existing
# ============================================================================
set -euo pipefail

DECK=""
TO=""
ZIP=0
FORCE=0

usage() { sed -n '2,20p' "$0" | sed 's/^# \{0,1\}//'; exit 0; }

while getopts ":d:t:zfh" opt; do
  case "$opt" in
    d) DECK="$OPTARG" ;;
    t) TO="$OPTARG" ;;
    z) ZIP=1 ;;
    f) FORCE=1 ;;
    h) usage ;;
    \?) echo "Unknown option -$OPTARG" >&2; exit 2 ;;
    :)  echo "Option -$OPTARG needs a value" >&2; exit 2 ;;
  esac
done

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [ -z "$DECK" ]; then
  echo "Which deck? Use -d <name>. Available:" >&2
  ls "$REPO_ROOT/decks" >&2
  exit 2
fi

# Accept the deck as a bare name or as a path (see build.sh for why):
#   showcase  decks/showcase  decks/showcase/sections  ->  showcase
DECK="${DECK//\\//}"
DECK="${DECK#./}"
DECK="${DECK#decks/}"
DECK="${DECK%%/*}"

SRC="$REPO_ROOT/decks/$DECK"
if [ ! -f "$SRC/main.tex" ]; then
  echo "No deck named '$DECK' (looked for $SRC/main.tex)" >&2
  exit 1
fi

[ -z "$TO" ] && TO="$REPO_ROOT/export/$DECK"

if [ -e "$TO" ]; then
  if [ "$FORCE" -eq 1 ]; then
    rm -rf "$TO"
  else
    echo "$TO already exists. Use -f to overwrite, or pass a different -t." >&2
    exit 1
  fi
fi

mkdir -p "$TO"
TO="$(cd "$TO" && pwd)"

# --- 1. The deck itself, minus build leftovers ------------------------------
#  The trailing /. copies the contents including dotfiles such as .latexmkrc.
cp -R "$SRC/." "$TO/"
rm -rf "$TO/out"

#  Drop intermediates left by an in-editor build. Matched narrowly -- only
#  top-level files called main.* -- so a real figures/diagram.pdf is safe.
for ext in aux log nav out snm toc vrb fls fdb_latexmk xdv dvi bbl blg bcf \
           pdf synctex.gz run.xml; do
  rm -f "$TO/main.$ext"
done

# Which engine does this deck use?
ENGINE=1
if [ -f "$SRC/.latexmkrc" ]; then
  if   grep -qE '^[[:space:]]*\$pdf_mode[[:space:]]*=[[:space:]]*5' "$SRC/.latexmkrc"; then ENGINE=5
  elif grep -qE '^[[:space:]]*\$pdf_mode[[:space:]]*=[[:space:]]*4' "$SRC/.latexmkrc"; then ENGINE=4
  fi
fi
case "$ENGINE" in
  5) ENGINE_NAME="xelatex";  ENGINE_NOTE="xelatex  (this deck needs it -- Thai/Sarabun)" ;;
  4) ENGINE_NAME="lualatex"; ENGINE_NOTE="lualatex" ;;
  *) ENGINE_NAME="pdflatex"; ENGINE_NOTE="pdflatex" ;;
esac

# --- 2. Its dependencies ----------------------------------------------------
cp -R "$REPO_ROOT/theme"    "$TO/theme"
cp -R "$REPO_ROOT/preamble" "$TO/preamble"

# --- 3. Repoint \deckroot ---------------------------------------------------
#  In the repo a deck is two levels down, so \deckroot is ../../ . Here
#  theme/ and preamble/ sit beside main.tex, so \deckroot becomes empty.
if grep -q '\\providecommand{\\deckroot}' "$TO/main.tex"; then
  # A literal-text edit via perl -pe, so no regex metacharacter can leak in.
  perl -i -pe 's/\\providecommand\{\\deckroot\}\{[^}]*\}/\\providecommand{\\deckroot}{}/' "$TO/main.tex"
else
  echo "WARNING: main.tex has no \\deckroot line - the export may not build." >&2
  echo "         See decks/_template/main.tex." >&2
fi

# --- 4. A .latexmkrc with nothing pointing back at this repo ----------------
cat > "$TO/.latexmkrc" <<EOF
# ============================================================================
#  .latexmkrc  --  standalone deck, exported from the slide template
# ----------------------------------------------------------------------------
#  Everything this deck needs is in this folder. theme/ and preamble/ are
#  found by main.tex itself, so there is nothing to install or configure.
# ============================================================================

# Engine: 1 = pdflatex, 4 = lualatex, 5 = xelatex
# Currently: $ENGINE_NOTE
\$pdf_mode = $ENGINE;

# Jump between source and PDF in the editor.
\$pdflatex = 'pdflatex -synctex=1 %O %S';
\$xelatex  = 'xelatex  -synctex=1 %O %S';
\$lualatex = 'lualatex -synctex=1 %O %S';

\$bibtex_use = 2;          # run biber, and clean up after it

# Intermediates go in out/ so this folder stays readable.
# (Must not be called "aux" -- that is a reserved name on Windows.)
\$aux_dir = 'out';
\$out_dir = 'out';

\$clean_ext  = 'nav snm vrb bbl bcf run.xml synctex.gz fdb_latexmk fls xdv';
\$max_repeat = 5;

1;
EOF

# --- 5. A note for whoever receives this folder -----------------------------
cat > "$TO/HOW-TO-BUILD.txt" <<EOF
HOW TO BUILD THIS PRESENTATION
==============================

You need a LaTeX installation: TeX Live (Windows/Linux) or MacTeX (Mac).
Nothing else. No fonts to install -- they are inside theme/assets/fonts/.

Easiest: open main.tex in TeXstudio and press the green build arrow.

From a terminal, in this folder:

    latexmk

or, without latexmk:

    $ENGINE_NAME main.tex
    $ENGINE_NAME main.tex        (twice -- the second pass fixes the slide numbers)

The finished slides are main.pdf (in out/ if you used latexmk).

This deck must be built with $ENGINE_NAME.
EOF

# --- 6. Optional zip --------------------------------------------------------
if [ "$ZIP" -eq 1 ]; then
  if command -v zip >/dev/null 2>&1; then
    rm -f "$TO.zip"
    ( cd "$TO" && zip -qr "$TO.zip" . )
    echo "Zipped -> $TO.zip"
  else
    echo "WARNING: 'zip' is not installed, skipping the archive." >&2
  fi
fi

SIZE="$(du -sh "$TO" | cut -f1)"
echo "Exported '$DECK' -> $TO  ($SIZE, engine: $ENGINE_NAME)"
echo
echo "That folder is self-contained. Move it, zip it, or upload it to Overleaf."
