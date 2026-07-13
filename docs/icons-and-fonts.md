# Icons and fonts

## Icons

Source: `src/components/icon.typ`, assets under `assets/icons/`.

```typst
#icon("git-branch")            // line icon, inherits accent color + current text size
#icon("terminal", size: 20pt, color: rgb("#333"))
#icon("react", brand: true)    // brand mark, full-color, natural brand palette
```

Two families:

- **Line icons** — `assets/icons/line/*.svg`. The full [Lucide](https://lucide.dev) set (~1750
  SVGs, ISC license — see `assets/icons/line/LICENSE`), so any Lucide kebab-case name works out of
  the box (e.g. `"terminal"`, `"git-branch"`, `"database-zap"`). Source SVGs ship with
  `stroke="currentColor"`; `icon()` does a literal string replace of `currentColor` with the
  resolved fill color's hex, so recoloring is just swapping the `color:` argument (defaults to the
  theme's `accent` token).
- **Brand marks** — `assets/icons/brand/*.svg`, from [Simple Icons](https://simpleicons.org)
  (CC0, see `assets/icons/brand/LICENSE.md`). These ship with no fill baked in (default black), so
  `icon(..., brand: true)` injects an explicit `fill="#hex"` on the `<svg>` root instead, looked up
  by icon name in `assets/icons/brand/colors.typ` (`brand-colors` dict, defaulting to black if a
  name is missing from the table). Brand marks keep their real brand color regardless of the deck's
  accent hue — don't recolor them.

`icon()` sizes and baseline-aligns to the surrounding text automatically (`baseline: 15%` default,
matching Typst's own text baseline convention) — drop it inline in a sentence and it lines up
without manual offsetting.

### Adding a new icon

- **Line icon**: drop a `kebab-case.svg` with `stroke="currentColor"` into
  `assets/icons/line/`. No code change needed — `icon()` resolves by filename.
- **Brand mark**: drop a `kebab-case.svg` into `assets/icons/brand/`, plus a hex entry for that
  name in `assets/icons/brand/colors.typ`.

### Re-syncing the Lucide set

The full set was vendored via a sparse clone of `lucide-icons/lucide`'s `icons/` directory.
Re-sync periodically by re-running the same sparse-clone-and-copy, syncing **new filenames only**
— existing files in `assets/icons/line/` may be curated/hand-edited, so don't blindly overwrite
the whole directory on a re-sync.

## Fonts

Vendored under `assets/fonts/<Family>/`, one static `.ttf` per weight (plus that family's
`OFL.txt`). All three families are OFL-1.1, redistributable.

| family | weights | source |
|---|---|---|
| Archivo | 500, 600, 700, 800 | `Omnibus-Type/Archivo`, `fonts/ttf/` |
| IBM Plex Sans | 400, 500, 600 | `IBM/plex`, `packages/plex-sans/fonts/complete/ttf/` |
| IBM Plex Mono | 400, 500, 600 | `google/fonts`, `ofl/ibmplexmono/` (static files present there) |

**Static weights only, never variable fonts.** Typst 0.14 does not render variable fonts
correctly ("variable fonts are not currently supported and may render incorrectly" — confirmed by
testing the `google/fonts` variable `.ttf`s directly), so each weight is pulled from its family's
upstream *static*-TTF release rather than the variable-font builds `google/fonts` ships for some
families.

Decks must compile with `--font-path` pointing at (or including) `assets/fonts` — see
[getting-started.md](getting-started.md#fonts-require-font-path). If Typst's package system ever
exposes a way for a package to declare its own font path automatically, switch to that; as of
Typst 0.14 font loading is entirely caller-controlled via the CLI flag.
