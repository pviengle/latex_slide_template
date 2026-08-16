# ============================================================================
#  .latexmkrc  --  build settings for THIS deck
# ----------------------------------------------------------------------------
#  Loads the shared settings, then lets you override them per deck.
# ============================================================================

do "../../scripts/latexmk-common.pl";

# --- Engine -----------------------------------------------------------------
#  1 = pdflatex (fast, default)
#  5 = xelatex  (REQUIRED for Thai / Sarabun)
#  4 = lualatex
#
#  Uncomment the line below if this deck contains Thai.
# $pdf_mode = 5;
