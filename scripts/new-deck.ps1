<#
.SYNOPSIS
  Start a new talk from decks/_template.

.EXAMPLE
  .\scripts\new-deck.ps1 -Name jcsse-2026
  .\scripts\new-deck.ps1 -Name thesis-defence -Thai
  .\scripts\new-deck.ps1 -Name talk -Title "My Title" -Author "My Name"

.NOTES
  macOS / Linux users: use scripts/new-deck.sh instead.
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$Name,
    [string]$Title,
    [string]$Author,
    [switch]$Thai
)

$ErrorActionPreference = 'Stop'

$RepoRoot = Split-Path -Parent $PSScriptRoot
$Src  = Join-Path $RepoRoot 'decks\_template'
$Dest = Join-Path $RepoRoot "decks\$Name"

if (Test-Path $Dest) {
    Write-Error "decks\$Name already exists - pick another name or delete it first."
}

Copy-Item -Recurse $Src $Dest
# Strip any build leftovers that came along with the copy.
$Out = Join-Path $Dest 'out'
if (Test-Path $Out) { Remove-Item -Recurse -Force $Out }

# --- Fill in metadata -------------------------------------------------------
$Meta     = Join-Path $Dest 'metadata.tex'
$MetaText = Get-Content $Meta -Raw

if ($Title) {
    $MetaText = $MetaText -replace '\\title\[Short title\]\{Full Presentation Title\}',
                                   "\title[$Title]{$Title}"
}
if ($Author) {
    $MetaText = $MetaText -replace '\\author\[A\. Author\]\{Author Name\}',
                                   "\author[$Author]{$Author}"
}
Set-Content -Path $Meta -Value $MetaText -Encoding utf8 -NoNewline

# --- Thai: enable the module and switch the deck to xelatex ----------------
if ($Thai) {
    $MainPath = Join-Path $Dest 'main.tex'
    $Main     = Get-Content $MainPath -Raw
    $Main     = $Main -replace '(?m)^% \\input\{lang-thai\}', '\input{lang-thai}'
    Set-Content -Path $MainPath -Value $Main -Encoding utf8 -NoNewline

    $RcPath = Join-Path $Dest '.latexmkrc'
    $Rc     = Get-Content $RcPath -Raw
    $Rc     = $Rc -replace '(?m)^# \$pdf_mode = 5;', '$pdf_mode = 5;'
    Set-Content -Path $RcPath -Value $Rc -Encoding utf8 -NoNewline

    Write-Host "Thai enabled: lang-thai loaded, engine set to xelatex (needed for Sarabun)." -ForegroundColor Cyan
}

Write-Host "Created decks\$Name" -ForegroundColor Green
Write-Host ""
Write-Host "Next:"
Write-Host "  1. edit decks\$Name\metadata.tex"
Write-Host "  2. write slides in decks\$Name\sections\"
Write-Host "  3. .\scripts\build.ps1 -Deck $Name"
