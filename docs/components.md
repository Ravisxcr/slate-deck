# Components

Source: `src/components/*.typ`. These are the pieces `slide.typ` composes into full slide
layouts, but every one of them is also usable standalone inside a `content`-kind slide body (or,
in the case of `er-table()`, anywhere at all) when you need a custom layout the built-in slide
kinds don't cover.

`icon()` and `diagram()`/`er-table()` are big enough to warrant their own pages:
[icons-and-fonts.md](icons-and-fonts.md), [diagram.md](diagram.md).

## `kicker(body, color: none, size: type-scale.kicker)`

`src/components/kicker.typ`. Uppercase, letter-spaced (`tracking: 0.08em`) mono label in the
accent color by default. `slide.typ` uses its own inline copy for the section/stat/code kickers
that need a different fill per background (`kicker-label` import) — this standalone version is
for use inside a `content` slide body or wherever you want an eyebrow-style label without a full
slide kind around it.

```typst
#kicker[Component: icon()]
```

## `cols(items, columns: 2, row-gutter: spacing.lg, column-gutter: spacing.xl)`

`src/components/columns.typ`. Generic N-up grid — each entry in `items` is one grid cell's
content. Used directly for icon-swatch rows and the `team` slide's card grid.

```typst
#cols(
  ("terminal", "git-branch", "package").map(name => icon(name, size: 18pt)),
  columns: 3,
)
```

## `numbered-grid(items, columns: 2, row-gutter: spacing.lg, column-gutter: spacing.xl)`

`src/components/columns.typ`. The "01 / 02 / 03 / 04" numbered-bullet layout from the mockup's
content slide: big accent index number, bold title, muted body line. `items` is an array of
`(title, body)` pairs (plain 2-tuples, not a named dict).

```typst
#numbered-grid((
  ([Inconsistent typography], [Every team hand-rolled fonts and spacing.]),
  ([No code-native layout], [Snippets always broke indentation in slideware.]),
), columns: 2)
```

## `compare-card(label, title, items, recommended: false)`

`src/components/card.typ`. Bordered card, fixed `height: 320pt` (not `100%` — see the "phantom
extra page" gotcha in [getting-started.md](getting-started.md#gotchas)). `recommended: true`
switches to an accent border + `accent-soft` fill. `items` is an array of content lines rendered
as a bulletless stack. This is what backs the `compare` slide kind's two cards, but is callable
directly if you want a comparison card outside that layout (e.g. three-up instead of two).

## `team-card(name, role)`

`src/components/card.typ`. Dashed-border photo placeholder + name + role, stacked. Backs the
`team` slide kind.

## `stat-hero(value, caption, on: "navy")`

`src/components/stat.typ`. The oversized hero-number treatment from the `stat` slide kind, usable
standalone if you want a stat callout inside a `content` slide instead of a dedicated full-bleed
`stat` slide. `on: "navy"` (default) or `on: "paper"` picks the foreground color pairing.

```typst
#stat-hero([6x], [faster from outline to reviewed deck])
```

## `pull-quote(body, name, role)`

`src/components/quote.typ`. Accent rule + large quote text + avatar placeholder + attribution.
Backs the `quote` slide kind; body text is capped to 750pt width internally.

## `code-block(body, lang: none, numbers: true, theme: "dark", highlight: ())`

`src/components/code.typ`. Line-numbered code block. Backs the `code` slide kind, but is directly
usable in any `content` slide body.

- **`body`** — either a plain string, or a fenced ` ```lang ... ``` ` raw block. Prefer the raw
  block in source: you get real editor syntax highlighting and indentation while writing the
  deck, rather than an escaped string literal. `lang:` overrides the fence's own tag when both are
  given.
- **`highlight`** — array of line numbers and/or inclusive ranges, e.g. `(3, (5, 7))` tints lines
  3, 5, 6, 7 with the accent-tinted background. Handled by the module-level
  `expand-highlight()` helper. Each line renders as its own single-line `raw` call (matching the
  mockup's hand-styled spans), not a full multi-line syntax pass — so highlighting is a background
  tint per row, not semantic token coloring beyond what `raw` already gives per-line.
- **`theme`** — `"dark"` (default, navy background) or `"light"` (paper background); flips every
  color (fill, border, text, line numbers, highlight tint) via the module's `pick(light, dark)`
  helper.

```typst
#code-block(```typ
#slide(kind: "content")[
  = Rollout timeline
  - Week 1: internal dogfood
]
```, highlight: (2,))
```

## `er-table(name, columns, width: 220pt, height: auto, header-height: 22pt, row-height: 18pt, accent: false)`

`src/components/er-table.typ`. Standalone DB/ER schema table: header bar (name) + one row per
column, with a key icon (`key-round` for `key: "pk"`, `key` for `key: "fk"`). Has no dependency on
`diagram.typ` — usable directly in any content slide — but `diagram()` also calls it for
`kind: "table"` nodes, passing a fixed `height` so the row math the diagram uses for edge anchors
(`header-height + row * row-height`) always agrees with what's actually rendered. See
[diagram.md](diagram.md#table-nodes) for that interaction.

```typst
#er-table("customers", (
  (name: "id", type: "uuid", key: "pk"),
  (name: "email", type: "text"),
  (name: "created_at", type: "timestamp"),
))
```

## Adding a new component

Follow the pattern every existing component uses:

1. `#import "../theme.typ": typeset-theme, fonts, spacing, type-scale` (whichever tokens you
   need) at the top of the file.
2. Wrap the function body in `context { let t = typeset-theme.get(); ... }` if it reads any color
   token — `typeset-theme` is document state and requires a context block to read.
3. Never hardcode a color literal (`oklch(...)`, `rgb(...)`) — use a token from `t` or `theme.typ`
   instead. See [design-tokens.md](design-tokens.md).
4. Control your own vertical rhythm with explicit `v()`/`stack(spacing: ...)` — don't rely on
   Typst's default paragraph/block spacing, which `deck()` zeroes out project-wide (see
   [getting-started.md](getting-started.md#gotchas)).
5. Re-export it from `src/lib.typ` if it's meant to be part of the public API.
