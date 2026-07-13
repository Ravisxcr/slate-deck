#import "../theme.typ": typeset-theme, fonts, type-scale, spacing

// Oversized hero-number component for the big-stat slide, on-navy by default.
#let stat-hero(value, caption, on: "navy") = context {
  let t = typeset-theme.get()
  let fg = if on == "navy" { t.on-navy } else { t.ink }
  let fg-muted = if on == "navy" { t.on-navy-muted } else { t.ink-muted }
  grid(
    columns: (auto, auto),
    column-gutter: spacing.md,
    align: bottom,
    text(font: fonts.display, weight: 800, size: type-scale.stat, fill: fg)[#value],
    box(width: 260pt)[
      #text(font: fonts.display, weight: 700, size: 24pt, fill: fg-muted)[#caption]
    ],
  )
}
