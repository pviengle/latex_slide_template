# ============================================================================
#  showcase/.latexmkrc
# ----------------------------------------------------------------------------
#  Works whether this deck is still inside the repo or has been copied out on
#  its own. See decks/_template/.latexmkrc for the full explanation.
# ============================================================================

use Cwd qw(abs_path);

my $shared = 0;
foreach my $p ('scripts/latexmk-common.pl',    '../scripts/latexmk-common.pl',
               '../../scripts/latexmk-common.pl',
               '../../../scripts/latexmk-common.pl') {
  if (-r $p) { my $abs = abs_path($p); do $abs; $shared = 1; last; }
}

unless ($shared) {
  $pdflatex   = 'pdflatex -synctex=1 %O %S';
  $xelatex    = 'xelatex  -synctex=1 %O %S';
  $lualatex   = 'lualatex -synctex=1 %O %S';
  @default_files = ('main.tex');   # else bare `latexmk` also builds metadata.tex
  $bibtex_use = 2;
  $aux_dir    = 'out';
  $out_dir    = 'out';
  $clean_ext  = 'nav snm vrb bbl bcf run.xml synctex.gz fdb_latexmk fls xdv';
  $max_repeat = 5;
}

# --- Engine -----------------------------------------------------------------
#  This deck contains Thai, so it builds with XeLaTeX: the only engine that
#  reads Sarabun (.ttf) and the only one with automatic Thai font fallback.
#  To see the pdfLaTeX/Garuda fallback path instead:  latexmk -pdf
$pdf_mode = 5;

1;
