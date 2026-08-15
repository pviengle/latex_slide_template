<#
.SYNOPSIS
  Remove build intermediates. Use -All to remove the finished PDFs too.

.EXAMPLE
  .\scripts\clean.ps1          # intermediates only, PDFs kept
  .\scripts\clean.ps1 -All     # everything, including build\*.pdf

.NOTES
  macOS / Linux users: use scripts/clean.sh instead.
#>
[CmdletBinding()]
param([switch]$All)

# See the note in build.ps1: latexmk writes to stderr on success, and 'Stop'
# would turn that into a spurious terminating error.
$ErrorActionPreference = 'Continue'

$RepoRoot = Split-Path -Parent $PSScriptRoot
$DecksDir = Join-Path $RepoRoot 'decks'

Get-ChildItem -Path $DecksDir -Directory | ForEach-Object {
    if (Test-Path (Join-Path $_.FullName 'main.tex')) {
        Push-Location $_.FullName
        try {
            if ($All) { latexmk -C | Out-Null } else { latexmk -c | Out-Null }
            $Out = Join-Path $_.FullName 'out'
            if ($All -and (Test-Path $Out)) { Remove-Item -Recurse -Force $Out }
            Write-Host "cleaned $($_.Name)"
        }
        finally { Pop-Location }
    }
}

if ($All) {
    $BuildDir = Join-Path $RepoRoot 'build'
    if (Test-Path $BuildDir) {
        Remove-Item -Recurse -Force $BuildDir
        Write-Host "removed build\"
    }
}

Write-Host "Done." -ForegroundColor Green
