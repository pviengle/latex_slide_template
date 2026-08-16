# ============================================================================
#  .latexmkrc  --  build settings for THIS deck
# ----------------------------------------------------------------------------
#  Works whether the deck is still inside the repo or has been copied out on
#  its own. Nothing in here needs editing when you copy the deck; the only
#  line you may want to change is $pdf_mode at the bottom.
# ============================================================================

use Cwd qw(abs_path);

# --- Shared settings, if they are reachable ---------------------------------
#  Searches this folder and up to three levels above for scripts/, the same
#  way main.tex searches for theme/. abs_path is used because Perl's `do`
#  searches @INC for relative paths, and '.' is not in @INC on Perl 5.26+.
#  (The result must go in a scalar first: `do abs_path(...)` parses as
#  `do BLOCK`, which is a syntax error here.)
my $shared = 0;
foreach my $p ('scripts/latexmk-common.pl',    '../scripts/latexmk-common.pl',
               '../../scripts/latexmk-common.pl',
               '../../../scripts/latexmk-common.pl') {
  if (-r $p) { my $abs = abs_path($p); do $abs; $shared = 1; last; }
}

# --- Fallback: the deck was copied out without scripts/ ---------------------
#  These are the same values latexmk-common.pl sets. Repeated here so a
#  copied deck builds identically instead of silently reverting to latexmk's
#  own defaults (no SyncTeX, bibtex instead of biber, output strewn about).
unless ($shared) {
  $pdflatex   = 'pdflatex -synctex=1 %O %S';
  $xelatex    = 'xelatex  -synctex=1 %O %S';
  $lualatex   = 'lualatex -synctex=1 %O %S';
  @default_files = ('main.tex');   # else bare `latexmk` also builds metadata.tex
  $bibtex_use = 2;
  $aux_dir    = 'out';    # must NOT be "aux": reserved device name on Windows
  $out_dir    = 'out';
  $clean_ext  = 'nav snm vrb bbl bcf run.xml synctex.gz fdb_latexmk fls xdv';
  $max_repeat = 5;
}

# --- Engine -----------------------------------------------------------------
#  1 = pdflatex (fast)
#  5 = xelatex  (REQUIRED for Thai -- real Sarabun and automatic fallback)
#  4 = lualatex
#
#  XeLaTeX, because main.tex loads lang-thai. If your talk has no Thai, set
#  this to 1 and change line 1 of main.tex to  % !TeX program = pdflatex
$pdf_mode = 5;

1;
