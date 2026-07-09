#import "../theme.typ": typeset-theme, fonts, type-scale, spacing

// Pull-quote: accent rule, large display-weight quote, avatar placeholder + attribution.
#let pull-quote(body, name, role) = context {
  let t = typeset-theme.get()
  stack(
    spacing: spacing.xl,
    rect(width: 40pt, height: 4pt, fill: t.accent),
    box(width: 750pt)[
      #text(font: fonts.display, weight: 600, size: type-scale.quote, fill: t.ink)[#body]
    ],
    grid(
      columns: (auto, auto),
      column-gutter: spacing.md,
      align: horizon,
      block(
        width: 32pt,
        height: 32pt,
        radius: 50%,
        fill: t.border,
        stroke: (paint: t.ink-faint, dash: "dashed"),
        align(center + horizon)[
          #text(font: fonts.mono, size: 7pt, fill: t.ink-faint)[photo]
        ],
      ),
      stack(
        spacing: 4pt,
        text(font: fonts.body, size: 13pt, weight: 600, fill: t.ink)[#name],
        text(font: fonts.body, size: 11pt, fill: t.ink-muted)[#role],
      ),
    ),
  )
}
