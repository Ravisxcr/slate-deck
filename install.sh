#!/usr/bin/env bash
# Installs SlateDeck into Typst's local package directory and installs the bundled fonts
# so you can compile or watch decks directly without passing --font-path.

set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
toml_path="$root/typst.toml"

name="$(grep -m1 '^name' "$toml_path" | sed -E 's/.*"([^"]+)".*/\1/')"
version="$(grep -m1 '^version' "$toml_path" | sed -E 's/.*"([^"]+)".*/\1/')"

if [[ -z "$name" ]]; then
  echo "Could not find package name in $toml_path" >&2
  exit 1
fi
if [[ -z "$version" ]]; then
  echo "Could not find package version in $toml_path" >&2
  exit 1
fi

if [[ "$(uname -s)" == "Darwin" ]]; then
  data_home="$HOME/Library/Application Support"
  user_fonts_dir="$HOME/Library/Fonts"
else
  data_home="${XDG_DATA_HOME:-$HOME/.local/share}"
  user_fonts_dir="${XDG_DATA_HOME:-$HOME/.local/share}/fonts"
fi

target="$data_home/typst/packages/local/$name/$version"

# 1. Install Typst local package
rm -rf "$target"
mkdir -p "$target"

for item in typst.toml src assets README.md; do
  if [[ -e "$root/$item" ]]; then
    cp -R "$root/$item" "$target/"
  fi
done

# 2. Install bundled fonts to user font directory
mkdir -p "$user_fonts_dir"
find "$root/assets/fonts" -type f -name "*.ttf" -exec cp {} "$user_fonts_dir/" \;

if command -v fc-cache >/dev/null 2>&1; then
  fc-cache -f "$user_fonts_dir" >/dev/null 2>&1 || true
fi

echo "============================================================"
echo " SlateDeck ($name:$version) installed successfully!"
echo "============================================================"
echo ""
echo "• Package Path: $target"
echo "• Fonts: Installed into $user_fonts_dir"
echo ""
echo "Usage in any .typ document:"
echo "  #import \"@local/$name:$version\": *"
echo ""
echo "You can now compile or live-watch presentations with zero extra flags:"
echo "  typst watch my-deck.typ my-deck.pdf"
echo "  typst compile my-deck.typ my-deck.pdf"
echo ""
