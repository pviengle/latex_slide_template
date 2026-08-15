<#
.SYNOPSIS
  Build one deck, or every deck, and collect the PDFs into build/.

.EXAMPLE
  .\scripts\build.ps1                       # build every deck, default engine
  .\scripts\build.ps1 -Deck showcase        # build one deck
  .\scripts\build.ps1 -Deck showcase -Engine xe
  .\scripts\build.ps1 -Deck showcase -Watch # rebuild on every save
  .\scripts\build.ps1 -Clean                # remove intermediates first

.NOTES
  macOS / Linux users: use scripts/build.sh instead. Same options.
#>
[CmdletBinding()]
param(
    [string]$Deck = 'all',
    [ValidateSet('default', 'pdf', 'xe', 'lua')]
    [string]$Engine = 'default',
    [switch]$Watch,
    [switch]$Clean
)

# NOTE: deliberately NOT 'Stop'.
# latexmk writes progress and warnings to stderr even on a completely
# successful run. With $ErrorActionPreference = 'Stop', PowerShell turns each
# of those lines into a terminating NativeCommandError and aborts the build
# that actually worked. Success is judged by $LASTEXITCODE instead, which is
# the only reliable signal from a native executable.
$ErrorActionPreference = 'Continue'

$RepoRoot = Split-Path -Parent $PSScriptRoot
$DecksDir = Join-Path $RepoRoot 'decks'
$BuildDir = Join-Path $RepoRoot 'build'

if (-not (Test-Path $BuildDir)) {
    New-Item -ItemType Directory -Path $BuildDir | Out-Null
}

# Map the friendly engine name onto the latexmk flag. 'default' passes nothing,
# so the deck's own .latexmkrc decides -- which is how Thai decks select xelatex.
$EngineFlag = switch ($Engine) {
    'pdf'  { '-pdf' }
    'xe'   { '-xelatex' }
    'lua'  { '-lualatex' }
    default { $null }
}

# Which decks? Anything with a main.tex, skipping the _template scaffold.
if ($Deck -eq 'all') {
    $Targets = Get-ChildItem -Path $DecksDir -Directory |
               Where-Object { $_.Name -ne '_template' -and (Test-Path (Join-Path $_.FullName 'main.tex')) }
} else {
    $Path = Join-Path $DecksDir $Deck
    if (-not (Test-Path (Join-Path $Path 'main.tex'))) {
        Write-Host "No deck named '$Deck' (looked for $Path\main.tex)" -ForegroundColor Red
        exit 1
    }
    $Targets = @(Get-Item $Path)
}

if ($Targets.Count -eq 0) {
    Write-Warning "No decks found in $DecksDir"
    return
}

$Failed = @()

foreach ($Target in $Targets) {
    Write-Host ""
    Write-Host "==> $($Target.Name)" -ForegroundColor Cyan

    Push-Location $Target.FullName
    try {
        if ($Clean) {
            latexmk -C | Out-Null
        }

        # --- Engine-change guard --------------------------------------------
        #  XeLaTeX and LuaLaTeX write polyglossia macros such as \xpg@aux into
        #  the .aux file. pdfLaTeX does not load polyglossia, so reading a
        #  stale .aux left by another engine kills the build with
        #  "Undefined control sequence \xpg@aux".
        #
        #  So: remember which engine produced the current out/ folder, and
        #  wipe it whenever the engine changes.
        $EngineLabel = $Engine
        if ($EngineLabel -eq 'default') {
            # Work out what the deck's own .latexmkrc selects.
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

        $LatexmkArgs = @('-interaction=nonstopmode', '-halt-on-error')
        if ($EngineFlag)  { $LatexmkArgs += $EngineFlag }
        if ($Watch)       { $LatexmkArgs += '-pvc' }
        $LatexmkArgs += 'main.tex'

        latexmk @LatexmkArgs
        $Code = $LASTEXITCODE

        if ($Code -ne 0) {
            Write-Host "    FAILED (exit $Code) - see $($Target.Name)\out\main.log" -ForegroundColor Red
            $Failed += $Target.Name
        } else {
            Set-Content -Path $Stamp -Value $EngineLabel -Encoding ascii
            $Pdf = Join-Path $Target.FullName 'out\main.pdf'
            if (Test-Path $Pdf) {
                $Dest = Join-Path $BuildDir "$($Target.Name).pdf"
                Copy-Item $Pdf $Dest -Force
                Write-Host "    OK -> build\$($Target.Name).pdf" -ForegroundColor Green
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
Write-Host "All decks built." -ForegroundColor Green
