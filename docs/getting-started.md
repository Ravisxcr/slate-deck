# Getting started

## Install

From the repo root:

```powershell
./install.ps1
```

```sh
./install.sh   # macOS/Linux
```

This copies the package into Typst's local package directory
(`%LOCALAPPDATA%\typst\packages\local\typeset\0.1.0\` on Windows; the XDG/Application Support
equivalent elsewhere). Re-run it after any change to `src/`, `assets/`, or `typst.toml` — the
installed copy is not symlinked, it's a snapshot. Side-by-side versions are supported: bumping
`version` in `typst.toml` and reinstalling adds a new version directory without touching decks
pinned to an older one.

Any `.typ` file on the machine can then do:

```typst
#import "@local/typeset:0.1.0": *
```

### Fonts require `--font-path`

Typst does not auto-discover a package's bundled assets as fonts. Every compile needs
`--font-path` pointing at the package's `assets/fonts` directory:

```sh
typst compile --font-path "%LOCALAPPDATA%\typst\packages\local\typeset\0.1.0\assets\fonts" deck.typ
```

If you forget this flag, Typst falls back to substitute fonts and the deck will compile but look
wrong (weights/metrics won't match the design tokens in [design-tokens.md](design-tokens.md)).

### Iterating on the package itself

`examples/demo.typ` imports `../src/lib.typ` directly and compiles against the in-repo
`assets/fonts`, so you can edit `src/` and re-render without reinstalling:

```sh
typst compile --font-path assets/fonts --root . examples/demo.typ examples/demo.pdf
```

## Your first deck

```typst
#import "@local/typeset:0.1.0": *

#show: deck.with(title: "Deck Title", accent-hue: 250deg)

#slide(
  kind: "title",
  eyebrow: [My Package],
  eyebrow-icon: "terminal",
  title: [Slides that read like a spec.],
  subtitle: [One line of positioning.],
  byline: ([Your Name], [Team], [Jul 2026]),
)

#slide(kicker: [Why this matters], title: [Three problems])[
  #numbered-grid((
    ([Problem one], [One line of detail.]),
    ([Problem two], [One line of detail.]),
  ))
]
```

- `#show: deck.with(..)` must come first — it sets the page size, base text, and theme state that
  every slide/component reads.
- `#slide(kind: "...", ..)[body]` — one call per slide. Omit `kind` for `"content"` (kicker +
  headline + free-form body). See [slides.md](slides.md) for the full parameter table per kind.
- Rebrand by changing one argument: `deck.with(accent-hue: 145deg)`. Every color token derives
  from `accent-hue`/`accent-chroma` — see [design-tokens.md](design-tokens.md).

## Project layout reference

See the tree in [index.md](index.md#how-the-package-fits-together). The two files you'll touch
most as a *deck author* (not package developer) are your own `.typ` file and, occasionally,
`examples/demo.typ` if you're checking how a slide kind behaves.

## Gotchas

These are non-obvious failure modes worth knowing before you hit them, drawn from building the
package against `examples/demo.typ`:

- **Silent overflow onto a phantom extra page.** `deck()` zeros Typst's implicit
  paragraph/block spacing so every component's `v()` calls control rhythm precisely. If you write
  new slide content with raw markup that relies on default paragraph spacing, it stacks
  *on top of* the explicit `v()`s already in the component and the slide silently overflows onto
  an unwanted second page — no compiler error. If a deck renders one page too many, this is the
  first thing to check.
- **`align(horizon)` no-ops inside a shrink-to-fit `pad()`.** If you're placing content inside a
  `pad()` box, vertical centering only works if the containing block has an explicit height —
  otherwise the box shrinks to its content and there's no extra space to center within.
- **`block(height: 100%, ...)` can overflow onto a phantom next page** if content is even
  slightly taller than the box, because blocks are breakable by default. Use a fixed pt height
  instead for anything meant to be exactly one card/box (see `compare-card` in
  `src/components/card.typ`, which uses `height: 320pt` for this reason).
- **Compile-check visually, not just for compiler errors.** Both bugs above compile cleanly —
  they only show up when you actually look at the rendered PDF/PNG. Re-render to PNG when
  changing a component:
  ```sh
  typst compile --font-path assets/fonts --root . examples/demo.typ "examples/slide-{p}.png"
  ```
