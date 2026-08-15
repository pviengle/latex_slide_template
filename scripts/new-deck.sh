#!/usr/bin/env bash
# ============================================================================
#  new-deck.sh  --  start a new talk from decks/_template
# ----------------------------------------------------------------------------
#  macOS / Linux. Windows users: use scripts\new-deck.ps1 instead.
#
#  Usage:
#     ./scripts/new-deck.sh -n jcsse-2026
#     ./scripts/new-deck.sh -n thesis-defence -t          # -t = Thai (xelatex)
#     ./scripts/new-deck.sh -n talk -T "My Title" -a "My Name"
# ============================================================================
set -euo pipefail

NAME=""
THAI=0
TITLE=""
AUTHOR=""

while getopts ":n:T:a:th" opt; do
  case "$opt" in
    n) NAME="$OPTARG" ;;
    T) TITLE="$OPTARG" ;;
    a) AUTHOR="$OPTARG" ;;
    t) THAI=1 ;;
    h) sed -n '2,13p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    \?) echo "Unknown option -$OPTARG" >&2; exit 2 ;;
    :)  echo "Option -$OPTARG needs a value" >&2; exit 2 ;;
  esac
done

if [ -z "$NAME" ]; then
  echo "A deck name is required:  ./scripts/new-deck.sh -n my-talk" >&2
  exit 2
fi

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$REPO_ROOT/decks/_template"
DEST="$REPO_ROOT/decks/$NAME"

if [ -e "$DEST" ]; then
  echo "decks/$NAME already exists -- pick another name or delete it first." >&2
  exit 1
fi

cp -R "$SRC" "$DEST"
# The template's .latexmkrc is copied too; strip any build leftovers.
rm -rf "$DEST/out"

# --- Fill in metadata -------------------------------------------------------
META="$DEST/metadata.tex"
if [ -n "$TITLE" ]; then
  perl -pi -e "s/\\\\title\\[Short title\\]\\{Full Presentation Title\\}/\\\\title[$TITLE]{$TITLE}/" "$META"
fi
if [ -n "$AUTHOR" ]; then
  perl -pi -e "s/\\\\author\\[A\\. Author\\]\\{Author Name\\}/\\\\author[$AUTHOR]{$AUTHOR}/" "$META"
fi

# --- Thai: enable the module and switch the deck to xelatex ----------------
if [ "$THAI" -eq 1 ]; then
  perl -pi -e 's/^% \\input\{lang-thai\}/\\input{lang-thai}/' "$DEST/main.tex"
  perl -pi -e 's/^# \$pdf_mode = 5;/\$pdf_mode = 5;/'          "$DEST/.latexmkrc"
  echo "Thai enabled: lang-thai loaded, engine set to xelatex (needed for Sarabun)."
fi

echo "Created decks/$NAME"
echo
echo "Next:"
echo "  1. edit decks/$NAME/metadata.tex"
echo "  2. write slides in decks/$NAME/sections/"
echo "  3. ./scripts/build.sh -d $NAME"
