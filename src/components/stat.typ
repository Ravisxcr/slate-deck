#import "../theme.typ": typeset-theme, fonts, type-scale, spacing

// Oversized hero-number component for the big-stat slide. Supports light (default), dark (navy), and accent themes.
#let stat-hero(value, caption, on: "paper", theme: none) = context {
  let t = typeset-theme.get()
  let mode = if theme != none { theme } else { on }
  let is-dark = mode in ("navy", "dark")
  let is-accent = mode in ("accent",)
  let fg = if is-dark { t.on-navy } else if is-accent { t.on-accent } else { t.ink }
  let fg-muted = if is-dark { t.on-navy-muted } else if is-accent { t.on-accent-muted } else { t.ink-muted }
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
