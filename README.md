# typeset

An opinionated Typst presentation package: strict grid, one accent color, and a small set of
slide kinds and components that cover most corporate-update / dev-talk decks. See
[CLAUDE.md](CLAUDE.md) for the design tokens and architecture behind it.

`examples/demo.typ` is the spec — one example of every slide kind, in mockup order.
`examples/showcase.typ` goes further: components reused outside their default slide kind, `icon()`
at arbitrary sizes, native Typst markup inside a content body, and a live mid-deck rebrand via
theme state.

## Install

```powershell
./scripts/install.ps1
```

Copies this package into `%LOCALAPPDATA%\typst\packages\local\typeset\0.1.0\`. Re-run it after
any change to the package source. Any `.typ` file on the machine can then do:

```typst
#import "@local/typeset:0.1.0": *
```

Fonts (Archivo, IBM Plex Sans, IBM Plex Mono) are bundled but Typst does not auto-discover a
package's own assets as fonts — compile with `--font-path` pointing at the installed package's
`assets/fonts` folder:

```sh
typst compile --font-path "%LOCALAPPDATA%\typst\packages\local\typeset\0.1.0\assets\fonts" deck.typ
```

(`examples/demo.typ` in this repo instead imports `../src/lib.typ` directly and compiles against
`assets/fonts` in-place, so you can iterate on the package without reinstalling for every change.)

## Usage

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

Rebrand by changing one argument: `deck.with(accent-hue: 145deg)` — every color token derives
from `accent-hue`/`accent-chroma`.

## Slide kinds

`slide(kind: "...", ..)` — omit `kind` for `"content"`.

| kind | required/typical params | notes |
|---|---|---|
| `title` | `eyebrow`, `eyebrow-icon`, `title`, `subtitle`, `byline` | cover slide, accent bar down the left |
| `section` | `label`, `title`, `blurb`, `progress` | full accent-color divider |
| `content` (default) | `kicker`, `title`, body | kicker + headline + free-form body content |
| `compare` | `kicker`, `title`, `left`, `right` | each of `left`/`right` is `(label:, title:, items:, recommended:)` |
| `stat` | `kicker`, `value`, `caption`, `note` | navy background, oversized number |
| `image` | `image`, `caption-title`, `caption-body` | full-bleed, `image` is any content (an `image()` call or placeholder box) |
| `code` | `kicker`, `kicker-icon`, `title`, `code`, `lang` | navy background, line-numbered, syntax-colored via Typst's built-in `raw` highlighting |
| `diagram` | `kicker`, `kicker-icon`, `title`, `nodes`, `edges`, `cols`, `rows`, `theme` | manual-placement node/edge diagram — architecture, flowcharts, ER diagrams |
| `quote` | `quote`, `name`, `role` | vertically centered pull-quote |
| `team` | `kicker`, `title`, `members`, `columns` | `members` is an array of `(name:, role:)` |
| `closing` | `title`, `subtitle`, `footer` | mirrors `title`, accent background |

Every kind accepts `progress` (except `title`/`closing`) for a bottom-right "N / total" marker.

## Components

Usable directly inside a `content`-kind slide body:

- `icon(name, size: 1em, color: none, brand: false)` — line icon from `assets/icons/line/`, or
  `brand: true` for a full-color mark from `assets/icons/brand/`. Sizes/baseline-aligns to
  surrounding text.
- `kicker(body)` — uppercase, letter-spaced mono label in the accent color.
- `cols(items, columns: 2)` — generic N-up grid.
- `numbered-grid(items, columns: 2)` — the "01 / 02 / 03 / 04" numbered-bullet layout.
- `compare-card(label, title, items, recommended: false)`, `team-card(name, role)`,
  `stat-hero(value, caption)`, `pull-quote(body, name, role)`, `code-block(body, lang: "typ")` —
  the pieces each slide kind is built from, usable standalone if you need a custom layout.
- `diagram(nodes, edges: (), cols:, rows:, cell:, gutter:, theme: "light")` — manual-placement
  node/edge diagram. Nodes sit on an explicit `(col:, row:)` grid (0-indexed) and render as either
  an icon+label box (`kind: "box"`, default) or a schema table (`kind: "table"`, via `er-table()`).
  Edges reference node ids (or `(id:, row:)` for a row-level anchor into a table node) and draw as
  straight or right-angle elbow connectors, with optional arrowheads, dashing, and labels. No
  auto-layout — you place every node explicitly, same philosophy as the rest of the package.
- `er-table(name, columns, width:, height: auto, accent: false)` — standalone DB/ER schema table
  (header bar + one row per column, with a key icon for `key: "pk"`/`"fk"` columns). Used by
  `diagram()` for table nodes, but usable directly in any content slide too.

## Icons

- Line icons: `assets/icons/line/*.svg`, a curated ~90-icon subset of
  [Lucide](https://lucide.dev) (ISC license, see `assets/icons/line/LICENSE`).
- Brand marks: `assets/icons/brand/*.svg`, from [Simple Icons](https://simpleicons.org) (CC0, see
  `assets/icons/brand/LICENSE.md`), recolored via `assets/icons/brand/colors.typ`.

Add more line icons by dropping a `kebab-case.svg` (with `stroke="currentColor"`) into
`assets/icons/line/` — no code change needed. Add brand marks the same way in `assets/icons/brand/`
plus a hex entry in `colors.typ`.

## Fonts

Archivo (500/600/700/800), IBM Plex Sans (400/500/600), IBM Plex Mono (400/500/600) — all
OFL-1.1, vendored as static weights under `assets/fonts/` (Typst 0.14 doesn't render variable
fonts correctly, so no single variable-font file is used). See each family's `OFL.txt` for
license text.
