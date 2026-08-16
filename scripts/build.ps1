<#
.SYNOPSIS
  Build this presentation.

.DESCRIPTION
  main.tex in the repo root IS the presentation. One copy of this repo is one
  talk, so with no arguments this builds that. The PDF is named after the
  folder, so a copy called opdc-5stars\ produces build\opdc-5stars.pdf.

.EXAMPLE
  .\scripts\build.ps1                       # build this presentation
  .\scripts\build.ps1 -Engine xe            # force xelatex
  .\scripts\build.ps1 -Watch                # rebuild on every save
  .\scripts\build.ps1 -Clean                # remove intermediates first
  .\scripts\build.ps1 -Deck showcase        # build a deck in a subfolder
  .\scripts\build.ps1 -All                  # this one plus every subfolder

.NOTES
  macOS / Linux users: use scripts/build.sh instead. Same options.
#>
[CmdletBinding()]
param(
    [string]$Deck,
    [ValidateSet('default', 'pdf', 'xe', 'lua')]
    [string]$Engine = 'default',
    [switch]$Watch,
    [switch]$Clean,
    [switch]$All
)

# NOTE: deliberately NOT 'Stop'.
# latexmk writes progress and warnings to stderr even on a completely
# successful run. With $ErrorActionPreference = 'Stop', PowerShell turns each
# of those lines into a terminating NativeCommandError and aborts the build
# that actually worked. Success is judged by $LASTEXITCODE instead, which is
# the only reliable signal from a native executable.
$ErrorActionPreference = 'Continue'

$RepoRoot = Split-Path -Parent $PSScriptRoot
$BuildDir = Join-Path $RepoRoot 'build'

if (-not (Test-Path $BuildDir)) {
    New-Item -ItemType Directory -Path $BuildDir | Out-Null
}

# Map the friendly engine name onto the latexmk flag. 'default' passes nothing,
# so the deck's own .latexmkrc decides -- which is how Thai selects xelatex.
$EngineFlag = switch ($Engine) {
    'pdf'  { '-pdf' }
    'xe'   { '-xelatex' }
    'lua'  { '-lualatex' }
    default { $null }
}

# --- Which folders? ---------------------------------------------------------
#  The root folder is the presentation. Subfolders holding their own main.tex
#  are extra decks kept alongside it (showcase is one).
$Skip = @('build', 'out', 'scripts', 'theme', 'preamble', 'figures', 'sections')
$Targets = @()

if ($Deck) {
    $Parts = @($Deck -split '[\\/]+' | Where-Object { $_ -and $_ -ne '.' })
    if ($Parts.Count -gt 0) { $Deck = $Parts[0] }
    $Path = Join-Path $RepoRoot $Deck
    if (-not (Test-Path (Join-Path $Path 'main.tex'))) {
        Write-Host "No deck named '$Deck' (looked for $Path\main.tex)" -ForegroundColor Red
        exit 1
    }
    $Targets = @(Get-Item $Path)
} elseif ($All) {
    $Targets = @(Get-Item $RepoRoot)
    $Targets += Get-ChildItem -Path $RepoRoot -Directory |
                Where-Object { $Skip -notcontains $_.Name -and
                               (Test-Path (Join-Path $_.FullName 'main.tex')) }
} else {
    if (-not (Test-Path (Join-Path $RepoRoot 'main.tex'))) {
        Write-Host "No main.tex in $RepoRoot -- is this the right folder?" -ForegroundColor Red
        exit 1
    }
    $Targets = @(Get-Item $RepoRoot)
}

$Failed = @()

foreach ($Target in $Targets) {
    # The root deck is named after the folder the repo was copied to.
    $Name = $Target.Name
    Write-Host ""
    Write-Host "==> $Name" -ForegroundColor Cyan

    Push-Location $Target.FullName
    try {
        if ($Clean) {
            latexmk -C | Out-Null
        }

        # --- Engine-change guard --------------------------------------------
        #  Remember which engine produced the current out/ folder and wipe it
        #  when the engine changes: intermediates written by one engine are
        #  not readable by another.
        $EngineLabel = $Engine
        if ($EngineLabel -eq 'default') {
            $EngineLabel = 'pdf'
            if (Test-Path '.latexmkrc') {
                $Rc = Get-Content '.latexmkrc' -Raw
                if ($Rc -match '(?m)^\s*\$pdf_mode\s*=\s*5')      { $EngineLabel = 'xe'  }
                elseif ($Rc -match '(?m)^\s*\$pdf_mode\s*=\s*4')   { $EngineLabel = 'lua' }
            }
        }
        $Stamp = 'out\.engine'
        if (Test-Path $Stamp) {
            if ((Get-Content $Stamp -Raw).Trim() -ne $EngineLabel) {
                Write-Host "    engine changed -> cleaning first" -ForegroundColor DarkGray
                Remove-Item -Recurse -Force 'out'
            }
        }

        # --- In-editor leftovers ---------------------------------------------
        #  TeXstudio (and TeXworks, TeXShop, ...) build in place, leaving
        #  main.aux next to main.tex. latexmk keeps its own copy in out/, so a
        #  top-level main.aux is never ours -- but TeX still finds it on the
        #  search path, and one written by a different engine breaks the
        #  build. main.pdf, main.log and main.synctex.gz are left alone:
        #  harmless, and the PDF is the one the editor is showing.
        $Stray = @('aux', 'bbl', 'bcf', 'run.xml', 'toc', 'nav', 'snm', 'out', 'vrb') |
                 ForEach-Object { "main.$_" } |
                 Where-Object { Test-Path $_ }
        if ($Stray) {
            Write-Host "    clearing in-editor leftovers: $($Stray -join ' ')" -ForegroundColor DarkGray
            Remove-Item -Force $Stray
        }

        $LatexmkArgs = @('-interaction=nonstopmode', '-halt-on-error')
        if ($EngineFlag)  { $LatexmkArgs += $EngineFlag }
        if ($Watch)       { $LatexmkArgs += '-pvc' }
        $LatexmkArgs += 'main.tex'

        latexmk @LatexmkArgs
        $Code = $LASTEXITCODE

        if ($Code -ne 0) {
            Write-Host "    FAILED (exit $Code) - see $Name\out\main.log" -ForegroundColor Red
            $Failed += $Name
        } else {
            Set-Content -Path $Stamp -Value $EngineLabel -Encoding ascii
            $Pdf = Join-Path $Target.FullName 'out\main.pdf'
            if (Test-Path $Pdf) {
                Copy-Item $Pdf (Join-Path $BuildDir "$Name.pdf") -Force
                Write-Host "    OK -> build\$Name.pdf" -ForegroundColor Green
            }
        }
    }
    finally {
        Pop-Location
    }
}

Write-Host ""
if ($Failed.Count -gt 0) {
    Write-Host "Failed: $($Failed -join ', ')" -ForegroundColor Red
    exit 1
}
Write-Host "Done." -ForegroundColor Green
