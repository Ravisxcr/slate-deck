#!/usr/bin/env bash
# Installs (or reinstalls) this package into Typst's local package directory so any document on
# this machine can `#import "@local/typeset:<version>": *` without a relative path.
#
# Reads name/version from typst.toml, copies typst.toml, src/, assets/, and README.md into the
# Typst local package dir ($XDG_DATA_HOME/typst/packages/local/<name>/<version>/, or
# ~/.local/share/... on Linux, ~/Library/Application Support/... on macOS), replacing whatever
# was there before. Re-run this after every change to the package source -- the local package
# dir is a build output, not a place to edit directly.

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
else
  data_home="${XDG_DATA_HOME:-$HOME/.local/share}"
fi

target="$data_home/typst/packages/local/$name/$version"

rm -rf "$target"
mkdir -p "$target"

for item in typst.toml src assets README.md; do
  if [[ -e "$root/$item" ]]; then
    cp -R "$root/$item" "$target/"
  fi
done

echo "Installed $name:$version -> $target"
echo ""
echo "In any .typ file:"
echo "  #import \"@local/$name:$version\": *"
echo ""
echo "Compile decks with the bundled fonts on the font path, e.g.:"
echo "  typst compile --font-path \"$target/assets/fonts\" deck.typ"
