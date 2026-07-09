<#
.SYNOPSIS
  Installs (or reinstalls) this package into Typst's local package directory so any document on
  this machine can `#import "@local/typeset:<version>": *` without a relative path.

.DESCRIPTION
  Reads name/version from typst.toml, copies typst.toml, src/, assets/, and README.md into
  %LOCALAPPDATA%\typst\packages\local\<name>\<version>\, replacing whatever was there before.
  Re-run this after every change to the package source -- the local package dir is a build
  output, not a place to edit directly.
#>

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$tomlPath = Join-Path $root "typst.toml"
$toml = Get-Content $tomlPath -Raw

if ($toml -notmatch 'name\s*=\s*"([^"]+)"') { throw "Could not find package name in $tomlPath" }
$name = $Matches[1]
if ($toml -notmatch 'version\s*=\s*"([^"]+)"') { throw "Could not find package version in $tomlPath" }
$version = $Matches[1]

$target = Join-Path $env:LOCALAPPDATA "typst\packages\local\$name\$version"

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
Write-Host "  typst compile --font-path `"$target\assets\fonts`" deck.typ"
