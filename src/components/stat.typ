#import "../theme.typ": typeset-theme, fonts, type-scale, spacing
#import "columns.typ": reorder-grid-items

// Oversized hero-number component for the big-stat slide. Supports light (default), dark (navy), and accent themes.
// Optional `size:` can be "hero" (170pt), "lg" (88pt), "md" (64pt), "sm" (46pt), or custom length.
#let stat-hero(
  value,
  caption,
  on: "paper",
  theme: none,
  size: auto,
  val-size: auto,
  cap-size: auto,
  caption-width: auto,
) = context {
  let t = typeset-theme.get()
  let mode = if theme != none { theme } else { on }
  let is-dark = mode in ("navy", "dark")
  let is-accent = mode in ("accent",)
  let fg = if is-dark { t.on-navy } else if is-accent { t.on-accent } else { t.ink }
  let fg-muted = if is-dark { t.on-navy-muted } else if is-accent { t.on-accent-muted } else { t.ink-muted }
  
  let is-hero-size = size == "hero" or (size == auto and val-size == auto)
  let v-size = if val-size != auto {
    val-size
  } else if is-hero-size {
    type-scale.stat
  } else if size == "lg" {
    88pt
  } else if size == "md" {
    64pt
  } else if size == "sm" {
    46pt
  } else if type(size) == length {
    size
  } else {
    64pt
  }

  let c-size = if cap-size != auto {
    cap-size
  } else if is-hero-size {
    24pt
  } else if size == "lg" {
    18pt
  } else if size == "md" {
    15pt
  } else if size == "sm" {
    12pt
  } else {
    15pt
  }

  let cap-w = if caption-width != auto {
    caption-width
  } else if is-hero-size {
    260pt
  } else {
    1fr
  }

  let cap-block = if cap-w == 1fr {
    pad(bottom: v-size * 0.08)[
      #text(font: fonts.display, weight: 700, size: c-size, fill: fg-muted)[#caption]
    ]
  } else {
    box(width: cap-w)[
      #text(font: fonts.display, weight: 700, size: c-size, fill: fg-muted)[#caption]
    ]
  }

  grid(
    columns: (auto, if cap-w == 1fr { 1fr } else { auto }),
    column-gutter: spacing.md,
    align: bottom,
    text(font: fonts.display, weight: 800, size: v-size, fill: fg)[#value],
    cap-block,
  )
}

// Multi-stat grid with column and row flow direction support.
#let stat-grid(
  stats,
  columns: auto,
  direction: "row",
  on: "paper",
  theme: none,
  size: auto,
  row-gutter: auto,
  column-gutter: auto,
) = context {
  let n = stats.len()
  if n == 0 {
    return []
  }
  let cols-count = if columns != auto {
    columns
  } else if n == 1 {
    1
  } else if n in (2, 4) {
    2
  } else {
    3
  }
  
  let chosen-size = if size != auto {
    size
  } else if n == 1 {
    "hero"
  } else if n == 2 {
    "lg"
  } else if n <= 4 {
    "md"
  } else {
    "sm"
  }
  
  let r-gutter = if row-gutter != auto {
    row-gutter
  } else if n <= 2 {
    spacing.xxl
  } else if n <= 4 {
    spacing.xl
  } else {
    spacing.lg
  }
  
  let c-gutter = if column-gutter != auto {
    column-gutter
  } else {
    spacing.xl
  }
  
  let cells = ()
  for item in stats {
    let (val, cap) = if type(item) == dictionary {
      (item.at("value", default: item.at("val", default: "")), item.at("caption", default: item.at("cap", default: "")))
    } else if type(item) == array {
      (item.at(0, default: ""), item.at(1, default: ""))
    } else {
      (item, "")
    }
    cells.push(stat-hero(val, cap, on: on, theme: theme, size: chosen-size))
  }
  
  let ordered = reorder-grid-items(cells, columns: cols-count, direction: direction)
  grid(
    columns: (1fr,) * cols-count,
    row-gutter: r-gutter,
    column-gutter: c-gutter,
    ..ordered
  )
}
