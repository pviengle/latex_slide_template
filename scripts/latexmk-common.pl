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

# --- Locate the folder holding theme/ and preamble/ -------------------------
#  Searched the same way main.tex searches, and for the same reason: the deck
#  may sit in decks/<name>/, or have been copied somewhere else entirely. Do
#  not assume '../..'.
my $repo;
foreach my $p ('.', '..', '../..', '../../..') {
  if (-d "$p/theme" && -d "$p/preamble") { $repo = abs_path($p); last; }
}

# --- Make theme/ and preamble/ visible to \usepackage and \usetheme ---------
#  BELT AND BRACES. Each deck's main.tex already finds these folders itself
#  (the \deck@probe / \input@path block at the top of the file), which is what
#  lets TeXstudio and a bare `xelatex main.tex` work with no setup at all.
#  This TEXINPUTS entry is only a backstop for a deck missing that block.
#
#  The trailing "//" means "search this tree recursively"; the trailing
#  separator means "then search the normal TeX tree as usual".
#  Windows kpathsea uses ';' as the path separator, POSIX uses ':'.
if (defined $repo) {
  my $sep = ($^O =~ /MSWin|cygwin/i) ? ';' : ':';
  $ENV{TEXINPUTS} = join($sep, "$repo/theme//", "$repo/preamble//",
                               ($ENV{TEXINPUTS} // ''));
}

# --- SyncTeX ----------------------------------------------------------------
#  Writes main.synctex.gz, which lets an editor jump between a line of source
#  and the matching spot in the PDF ("forward/inverse search"). TeXstudio,
#  VS Code and SumatraPDF all use it. latexmk does not pass this by default,
#  so each engine command is respecified here with the flag added.
$pdflatex = 'pdflatex -synctex=1 %O %S';
$xelatex  = 'xelatex  -synctex=1 %O %S';
$lualatex = 'lualatex -synctex=1 %O %S';

# --- What a bare `latexmk` builds -------------------------------------------
#  Without this, latexmk compiles EVERY .tex file in the deck folder -- which
#  means metadata.tex and each file in sections/, none of which have a
#  \begin{document}. The build then "fails" with "Missing \begin{document}"
#  even though main.pdf came out perfectly.
@default_files = ('main.tex');

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
