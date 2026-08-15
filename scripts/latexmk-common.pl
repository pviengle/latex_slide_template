# ============================================================================
#  latexmk-common.pl  --  shared build configuration for every deck
# ----------------------------------------------------------------------------
#  This is the SINGLE SOURCE OF TRUTH for build settings. Each deck's
#  .latexmkrc is a 3-line stub that loads this file and then (optionally)
#  overrides the engine.
#
#  It is loaded with latexmk's current directory set to the DECK directory,
#  so the repo root is two levels up.
# ============================================================================

use Cwd qw(abs_path);

# --- Locate the repo root from the deck directory ---------------------------
my $repo = abs_path('../..');

# --- Make theme/ and preamble/ visible to \usepackage and \usetheme ---------
#  LaTeX only searches the current directory by default, so `\usetheme{deck}`
#  would not find theme/beamerthemedeck.sty. Prepending these to TEXINPUTS
#  fixes that. The trailing "//" means "search this tree recursively"; the
#  trailing separator means "then search the normal TeX tree as usual".
#  Windows kpathsea uses ';' as the path separator, POSIX uses ':'.
my $sep = ($^O =~ /MSWin|cygwin/i) ? ';' : ':';
$ENV{TEXINPUTS} = join($sep, "$repo/theme//", "$repo/preamble//",
                             ($ENV{TEXINPUTS} // ''));

# --- Bibliography -----------------------------------------------------------
$bibtex_use = 2;          # run biber/bibtex, and clean .bbl on `latexmk -C`

# --- Default engine ---------------------------------------------------------
#  1 = pdflatex (default)   5 = xelatex   4 = lualatex
#  Decks that use Thai/Sarabun override this to 5 in their own .latexmkrc.
$pdf_mode = 1;

# --- Keep the deck folder clean --------------------------------------------
#  Intermediates and the PDF go into a subfolder so the deck stays readable.
#
#  NOTE: this folder must NOT be called "aux". On Windows, AUX is a reserved
#  device name (like CON, PRN and NUL) and creating a directory with that
#  name fails outright.
$aux_dir = 'out';
$out_dir = 'out';

# --- Extra files latexmk should remove on `-c` / `-C` ----------------------
$clean_ext = 'nav snm vrb bbl bcf run.xml synctex.gz fdb_latexmk fls xdv';

# --- Rerun heuristics -------------------------------------------------------
$max_repeat = 5;          # beamer + biblatex + tikz externalisation can need 4

1;   # a `do`-loaded Perl file must end truthy
