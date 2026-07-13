# Design tokens

Source: `src/theme.typ`. Everything here is read through the `typeset-theme` state, never
hardcoded in a component — see [index.md](index.md#design-philosophy-why-some-things-are-the-way-they-are).

## Coordinate system

The design is derived from a reference mockup authored at **1920×1080px**. The Typst page is
**960pt × 540pt** (16:9, equal to a standard PowerPoint slide, 13.333in × 7.5in), which makes the
px→pt conversion factor exactly **0.5** — halve any pixel value pulled from the mockup.

| mockup (px) | typst (pt) | used for |
|---|---|---|
| 120 | 60 | horizontal page margin (`spacing.page-x`) |
| 80–100 | 40–50 | vertical page margin / top offset (`spacing.page-y`) |
| 14 | 7 | title-slide accent bar width |
| 20–22 | 10–11 | kicker / label text |
| 68 | 34 | content-slide headline (`type-scale.h2`) |
| 112–132 | 56–66 | title / section-divider display text |
| 340 | 170 | big-stat hero number (`type-scale.stat`) |
| 22 | 11 | body copy (`type-scale.body`) |
| 26 | 13 | code block text (`type-scale.code`) |

`page-size` in `theme.typ` is `(width: 960pt, height: 540pt)`. When porting any new measurement
out of the mockup, halve it and, if it recurs, add it to `spacing`/`type-scale` rather than
inlining a raw pt value in a component.

## Color

Built from a single accent hue via `make-theme(accent-hue: 250deg, accent-chroma: 0.16)`, using
Typst's native `oklch(lightness, chroma, hue)` constructor directly (no hex conversion). Call
`deck.with(accent-hue: ..., accent-chroma: ...)` once per document; every component reads the
result from the `typeset-theme` state.

| token | oklch | role |
|---|---|---|
| `paper` | `oklch(98.5%, 0.004, 80deg)` | light slide background |
| `ink` | `oklch(20%, 0.01, 80deg)` | primary text on `paper` |
| `ink-muted` | `oklch(45%, 0.02, 80deg)` | secondary text / body copy |
| `ink-faint` | `oklch(65%, 0.01, 80deg)` | tertiary labels, placeholders |
| `border` | `oklch(88%, 0.006, 80deg)` | hairlines, card borders |
| `accent` | `oklch(55%, chroma, hue)` | the one accent color — kickers, rules, links, highlights |
| `accent-soft` | `oklch(55%, chroma, hue, 5%)` | tinted fills (recommended-option cards, etc.) |
| `on-accent` | `oklch(98%, 0.01, hue)` | text/icons on an `accent` background (section dividers, closing) |
| `on-accent-muted` | `oklch(92%, 0.03, hue)` | secondary text on an `accent` background |
| `navy` | `oklch(16%, 0.01, hue)` | dark slide background (stat, code slides) |
| `on-navy` | `oklch(98%, 0.01, hue)` | primary text on `navy` |
| `on-navy-muted` | `oklch(70%, 0.03, hue)` | secondary text on `navy` |
| `on-navy-accent` | `oklch(65%, chroma - 0.02, hue)` | accent-tinted kicker text on `navy` (readable, less saturated than `accent`) |

Reading the theme inside a component:

```typst
#import "../theme.typ": typeset-theme

#context {
  let t = typeset-theme.get()
  text(fill: t.accent)[...]
}
```

`typeset-theme.get()` requires a `context` block since it's document state — every component in
`src/components/` already follows this pattern.

## Typography

Three families, one role each:

| family | weights | role |
|---|---|---|
| **Archivo** | 500, 600, 700, 800 | display — titles, section dividers, headlines, big-stat numbers, quote text. Always tight tracking (`-0.01em` to `-0.03em`) at large sizes. |
| **IBM Plex Sans** | 400, 500, 600 | body copy, bullet text, captions |
| **IBM Plex Mono** | 400, 500, 600 | kickers (uppercase, `tracking: 0.08em`), slide numbers/footers, code blocks, inline code |

Font roles are exposed as `fonts.display` / `fonts.body` / `fonts.mono` (`src/theme.typ`) — use
the role, not a literal family-name string, so a future font swap is one edit.

### Type scale (`type-scale`)

| token | size | used for |
|---|---|---|
| `kicker` / `body` | 11pt | body copy, kicker label size |
| `body-lg` | 14pt | title-slide subtitle |
| `eyebrow` | 10pt | title-slide eyebrow label |
| `h2` | 34pt | content-slide headline |
| `display-sm` | 56pt | section-divider / closing title |
| `display` | 66pt | title-slide headline |
| `stat` | 170pt | big-stat hero number |
| `quote` | 32pt | pull-quote text |
| `code` | 13pt | code block text |
| `number` | 20pt | footer progress marker / byline |

Some slide kinds use one-off literal sizes local to that layout (e.g. the code-slide title at
`30pt`) rather than a named token — that's intentional per the project convention: repeated
values go in `theme.typ`, one-off layout numbers local to a single slide kind stay as literals in
`slide.typ`.

## Spacing (`spacing`)

A t-shirt scale in pt, derived by the same 0.5 px→pt factor as the coordinate table above. Don't
hardcode a raw pt value for gaps/padding that recur — add to this scale instead.

| token | value | typical use |
|---|---|---|
| `xs` | 8pt | tight inline gaps |
| `sm` | 14pt | label-to-content gap |
| `md` | 20pt | icon-to-label gap |
| `lg` | 34pt | card padding, section gaps |
| `xl` | 56pt | headline-to-body gap |
| `xxl` | 70pt | large vertical section breaks |
| `page-x` | 60pt | horizontal page margin |
| `page-y` | 40pt | vertical page margin |
