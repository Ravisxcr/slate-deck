<#
.SYNOPSIS
  Installs SlateDeck into Typst's local package directory and installs the bundled fonts
  so you can compile or watch decks directly without passing --font-path.

.DESCRIPTION
  1. Reads name/version from typst.toml.
  2. Copies typst.toml, src/, assets/, and README.md into Typst's local package directory:
     %LOCALAPPDATA%\typst\packages\local\<name>\<version>\
  3. Installs and registers the bundled fonts (Archivo, IBM Plex Sans, IBM Plex Mono) into
     the user fonts directory (%LOCALAPPDATA%\Microsoft\Windows\Fonts) and sets TYPST_FONT_PATHS.
#>

$ErrorActionPreference = "Stop"

$root = $PSScriptRoot
$tomlPath = Join-Path $root "typst.toml"
$toml = Get-Content $tomlPath -Raw

if ($toml -notmatch 'name\s*=\s*"([^"]+)"') { throw "Could not find package name in $tomlPath" }
$name = $Matches[1]
if ($toml -notmatch 'version\s*=\s*"([^"]+)"') { throw "Could not find package version in $tomlPath" }
$version = $Matches[1]

$dataHome = if ($env:LOCALAPPDATA) { $env:LOCALAPPDATA } else { Join-Path $HOME "AppData\Local" }
$target = Join-Path $dataHome "typst/packages/local/$name/$version"

# 1. Install Typst local package
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

# 2. Automatically install and register bundled fonts in user profile
$userFontsDir = Join-Path $dataHome "Microsoft\Windows\Fonts"
if (!(Test-Path $userFontsDir)) {
  New-Item -ItemType Directory -Path $userFontsDir -Force | Out-Null
}

$fontsSource = Join-Path $root "assets\fonts"
$fontFiles = Get-ChildItem -Path $fontsSource -Recurse -Filter "*.ttf"
$installedFontsCount = 0

foreach ($font in $fontFiles) {
  $destPath = Join-Path $userFontsDir $font.Name
  try {
    if (!(Test-Path $destPath) -or ((Get-Item $destPath).Length -ne $font.Length)) {
      Copy-Item -Path $font.FullName -Destination $destPath -Force -ErrorAction Stop
    }
  } catch {
    # Font is currently loaded and locked by Windows/Typst, which means it's already installed.
  }
  try {
    New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Fonts" -Name $font.Name -Value $destPath -PropertyType String -Force -ErrorAction SilentlyContinue | Out-Null
  } catch {}
  $installedFontsCount++
}

# 3. Configure TYPST_FONT_PATHS environment variable
$pkgFontsDir = Join-Path $target "assets\fonts"
try {
  [Environment]::SetEnvironmentVariable("TYPST_FONT_PATHS", $pkgFontsDir, "User")
  $env:TYPST_FONT_PATHS = $pkgFontsDir
} catch {}

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host " SlateDeck ($name`:$version) installed successfully!" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "• Package Path: $target"
Write-Host "• Fonts: $installedFontsCount font weights registered in $userFontsDir"
Write-Host ""
Write-Host "Usage in any .typ document:" -ForegroundColor Yellow
Write-Host "  #import `\"@local/$name`:$version`\": *"
Write-Host ""
Write-Host "You can now compile or live-watch presentations with zero extra flags:" -ForegroundColor Yellow
Write-Host "  typst watch my-deck.typ my-deck.pdf" -ForegroundColor White
Write-Host "  typst compile my-deck.typ my-deck.pdf" -ForegroundColor White
Write-Host ""
