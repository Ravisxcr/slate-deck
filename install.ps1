<#
.SYNOPSIS
  Installs (or reinstalls) this package into Typst's local package directory so any document on
  this machine can `#import "@local/typeset:<version>": *` without a relative path.

.DESCRIPTION
  Reads name/version from typst.toml, copies typst.toml, src/, assets/, and README.md into the
  Typst local package dir (%LOCALAPPDATA%\typst\packages\local\<name>\<version>\ on Windows,
  ~/Library/Application Support/typst/packages/local/<name>/<version>/ on macOS,
  $XDG_DATA_HOME/typst/packages/local/<name>/<version>/ (or ~/.local/share/...) on Linux),
  replacing whatever was there before. Re-run this after every change to the package source --
  the local package dir is a build output, not a place to edit directly.
#>

$ErrorActionPreference = "Stop"

$root = $PSScriptRoot
$tomlPath = Join-Path $root "typst.toml"
$toml = Get-Content $tomlPath -Raw

if ($toml -notmatch 'name\s*=\s*"([^"]+)"') { throw "Could not find package name in $tomlPath" }
$name = $Matches[1]
if ($toml -notmatch 'version\s*=\s*"([^"]+)"') { throw "Could not find package version in $tomlPath" }
$version = $Matches[1]

if ($env:LOCALAPPDATA) {
  $dataHome = $env:LOCALAPPDATA
} elseif ($IsMacOS) {
  $dataHome = Join-Path $HOME "Library/Application Support"
} else {
  $dataHome = if ($env:XDG_DATA_HOME) { $env:XDG_DATA_HOME } else { Join-Path $HOME ".local/share" }
}

$target = Join-Path $dataHome "typst/packages/local/$name/$version"

if (Test-Path $target) {
  Remove-Item $target -Recurse -Force -Confirm:$false
}
New-Item -ItemType Directory -Path $target -Force | Out-Null

foreach ($item in @("typst.toml", "src", "assets", "README.md")) {
  $itemPath = Join-Path $root $item
  if (Test-Path $itemPath) {
    Copy-Item $itemPath -Destination $target -Recurse -Force
  }
}

Write-Host "Installed $name`:$version -> $target"
Write-Host ""
Write-Host "In any .typ file:"
Write-Host "  #import `"@local/$name`:$version`": *"
Write-Host ""
Write-Host "Compile decks with the bundled fonts on the font path, e.g.:"
Write-Host "  typst compile --font-path `"$(Join-Path $target 'assets/fonts')`" deck.typ"
