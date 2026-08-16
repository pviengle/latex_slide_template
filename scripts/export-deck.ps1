<#
.SYNOPSIS
  Bundle one deck into a standalone folder that carries its own copy of
  theme/ and preamble/, so it can be moved, emailed or uploaded anywhere.

.DESCRIPTION
  A deck inside this repo depends on ../../theme and ../../preamble. Copy the
  deck folder on its own and it stops building. This script copies the deck
  AND its dependencies into one folder, and rewrites the single line that
  points at them, so the result builds by itself:

      <target>/
        main.tex          <- \deckroot changed from ../../ to nothing
        metadata.tex  sections/  figures/  refs.bib
        theme/            <- copied, fonts included
        preamble/         <- copied
        .latexmkrc        <- self-contained, no reference back to this repo
        HOW-TO-BUILD.txt

  The result opens in TeXstudio and builds with no setup, and uploads to
  Overleaf as-is.

.EXAMPLE
  .\scripts\export-deck.ps1 -Deck showcase
  .\scripts\export-deck.ps1 -Deck my-talk -To D:\talks\my-talk
  .\scripts\export-deck.ps1 -Deck my-talk -Zip

.NOTES
  macOS / Linux users: use scripts/export-deck.sh instead. Same options.
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$Deck,
    [string]$To,
    [switch]$Zip,
    [switch]$Force
)

$ErrorActionPreference = 'Stop'

$RepoRoot = Split-Path -Parent $PSScriptRoot

# Accept the deck as a bare name or as a path (see build.ps1 for why):
#   showcase  decks/showcase  decks\showcase\sections  ->  showcase
$Parts = @($Deck -split '[\\/]+' | Where-Object { $_ -and $_ -ne '.' })
if ($Parts.Count -gt 0 -and $Parts[0] -eq 'decks') {
    $Parts = @($Parts | Select-Object -Skip 1)
}
if ($Parts.Count -gt 0) { $Deck = $Parts[0] }

$Src = Join-Path $RepoRoot "decks\$Deck"

if (-not (Test-Path (Join-Path $Src 'main.tex'))) {
    Write-Error "No deck named '$Deck' (looked for $Src\main.tex)"
}

if (-not $To) { $To = Join-Path $RepoRoot "export\$Deck" }

if (Test-Path $To) {
    if ($Force) {
        Remove-Item -Recurse -Force $To
    } else {
        Write-Error "$To already exists. Use -Force to overwrite, or pass a different -To."
    }
}

New-Item -ItemType Directory -Path $To -Force | Out-Null
$To = (Resolve-Path $To).Path

# --- 1. The deck itself, minus build leftovers ------------------------------
Copy-Item -Recurse -Path (Join-Path $Src '*') -Destination $To -Exclude 'out'
$StaleOut = Join-Path $To 'out'
if (Test-Path $StaleOut) { Remove-Item -Recurse -Force $StaleOut }

#  Drop intermediates left by an in-editor build. Matched narrowly -- only
#  top-level files called main.* -- so a real figures/diagram.pdf is safe.
$JunkExt = '.aux', '.log', '.nav', '.out', '.snm', '.toc', '.vrb', '.fls',
           '.fdb_latexmk', '.gz', '.xdv', '.dvi', '.bbl', '.blg', '.bcf',
           '.xml', '.pdf'
Get-ChildItem -Path $To -File |
    Where-Object { $_.Name -like 'main.*' -and $JunkExt -contains $_.Extension } |
    Remove-Item -Force

# Which engine does this deck use? Read it from the deck's own .latexmkrc.
# (A fresh, self-contained .latexmkrc is written over the copy in step 4.)
$SrcRc = Join-Path $Src '.latexmkrc'
$Engine = 1
if (Test-Path $SrcRc) {
    $RcText = Get-Content $SrcRc -Raw
    if ($RcText -match '(?m)^\s*\$pdf_mode\s*=\s*5')     { $Engine = 5 }
    elseif ($RcText -match '(?m)^\s*\$pdf_mode\s*=\s*4') { $Engine = 4 }
}

# --- 2. Its dependencies ----------------------------------------------------
Copy-Item -Recurse (Join-Path $RepoRoot 'theme')    (Join-Path $To 'theme')
Copy-Item -Recurse (Join-Path $RepoRoot 'preamble') (Join-Path $To 'preamble')

# --- 3. Repoint \deckroot ---------------------------------------------------
#  In the repo a deck is two levels down, so \deckroot is ../../ . Here
#  theme/ and preamble/ sit beside main.tex, so \deckroot becomes empty.
$MainPath = Join-Path $To 'main.tex'
$Main     = Get-Content $MainPath -Raw
if ($Main -notmatch '\\providecommand\{\\deckroot\}') {
    Write-Warning "main.tex has no \deckroot line - the export may not build. See decks\_template\main.tex."
} else {
    $Main = $Main -replace '\\providecommand\{\\deckroot\}\{[^}]*\}',
                           '\providecommand{\deckroot}{}'
    Set-Content -Path $MainPath -Value $Main -Encoding utf8 -NoNewline
}

# --- 4. A .latexmkrc with nothing pointing back at this repo ----------------
$EngineNote = switch ($Engine) {
    5 { 'xelatex  (this deck needs it -- Thai/Sarabun)' }
    4 { 'lualatex' }
    default { 'pdflatex' }
}
@"
# ============================================================================
#  .latexmkrc  --  standalone deck, exported from the slide template
# ----------------------------------------------------------------------------
#  Everything this deck needs is in this folder. theme/ and preamble/ are
#  found by main.tex itself, so there is nothing to install or configure.
# ============================================================================

# Engine: 1 = pdflatex, 4 = lualatex, 5 = xelatex
# Currently: $EngineNote
`$pdf_mode = $Engine;

# Jump between source and PDF in the editor.
`$pdflatex = 'pdflatex -synctex=1 %O %S';
`$xelatex  = 'xelatex  -synctex=1 %O %S';
`$lualatex = 'lualatex -synctex=1 %O %S';

`$bibtex_use = 2;          # run biber, and clean up after it

# Intermediates go in out/ so this folder stays readable.
# (Must not be called "aux" -- that is a reserved name on Windows.)
`$aux_dir = 'out';
`$out_dir = 'out';

`$clean_ext  = 'nav snm vrb bbl bcf run.xml synctex.gz fdb_latexmk fls xdv';
`$max_repeat = 5;

1;
"@ | Set-Content -Path (Join-Path $To '.latexmkrc') -Encoding ascii

# --- 5. A note for whoever receives this folder -----------------------------
$EngineName = switch ($Engine) { 5 { 'xelatex' } 4 { 'lualatex' } default { 'pdflatex' } }
@"
HOW TO BUILD THIS PRESENTATION
==============================

You need a LaTeX installation: TeX Live (Windows/Linux) or MacTeX (Mac).
Nothing else. No fonts to install -- they are inside theme/assets/fonts/.

Easiest: open main.tex in TeXstudio and press the green build arrow.

From a terminal, in this folder:

    latexmk

or, without latexmk:

    $EngineName main.tex
    $EngineName main.tex        (twice -- the second pass fixes the slide numbers)

The finished slides are main.pdf (in out/ if you used latexmk).

This deck must be built with $EngineName.
"@ | Set-Content -Path (Join-Path $To 'HOW-TO-BUILD.txt') -Encoding utf8

# --- 6. Optional zip --------------------------------------------------------
if ($Zip) {
    $ZipPath = "$To.zip"
    if (Test-Path $ZipPath) { Remove-Item -Force $ZipPath }
    Compress-Archive -Path (Join-Path $To '*') -DestinationPath $ZipPath
    Write-Host "Zipped -> $ZipPath" -ForegroundColor Green
}

$Size = '{0:N0} KB' -f ((Get-ChildItem -Recurse $To | Measure-Object -Property Length -Sum).Sum / 1KB)
Write-Host "Exported '$Deck' -> $To  ($Size, engine: $EngineName)" -ForegroundColor Green
Write-Host ""
Write-Host "That folder is self-contained. Move it, zip it, or upload it to Overleaf."
