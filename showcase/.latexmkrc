# ============================================================================
#  showcase/.latexmkrc
# ----------------------------------------------------------------------------
#  Left on pdflatex deliberately: this deck contains Thai, so the default
#  build exercises the Garuda fallback path. Build with `latexmk -xelatex`
#  to see the same deck render in real Sarabun.
# ============================================================================

do "../../scripts/latexmk-common.pl";

# $pdf_mode = 5;   # uncomment for xelatex by default
