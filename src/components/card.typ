#import "../theme.typ": typeset-theme, fonts, spacing

// Bordered card for the build-vs-buy comparison slide. `recommended: true` flips it to an
// accent-tinted fill + accent border, matching the mockup's "Option B -- recommended" card.
#let compare-card(label, title, items, recommended: false) = context {
  let t = typeset-theme.get()
  let border-color = if recommended { t.accent } else { t.border }
  let label-color = if recommended { t.accent-kicker } else { t.ink-faint }
  let fill-color = if recommended {
    if t.is-dark { t.accent.transparentize(85%) } else { t.accent-soft }
  } else {
    t.card-bg
  }
  block(
    width: 100%,
    height: 320pt,
    breakable: false,
    stroke: 1.5pt + border-color,
    radius: 2pt,
    fill: fill-color,
    inset: spacing.lg,
  )[
    #text(font: fonts.mono, size: 9pt, tracking: 0.08em, fill: label-color)[#upper(label)]
    #v(spacing.sm)
    #text(font: fonts.display, weight: 700, size: 18pt, fill: t.ink)[#title]
    #v(spacing.sm)
    #line(length: 100%, stroke: 1pt + t.border)
    #v(spacing.sm)
    #stack(
      spacing: 10pt,
      ..items.map(i => text(font: fonts.body, size: 11pt, fill: t.ink-muted)[#i]),
    )
  ]
}

// Photo-placeholder + name + role card for the team-grid slide.
#let team-card(name, role) = context {
  let t = typeset-theme.get()
  stack(
    spacing: 10pt,
    block(
      width: 100%,
      height: 90pt,
      radius: 3pt,
      fill: if t.is-dark { t.card-bg } else { t.border },
      stroke: (paint: t.ink-faint, dash: "dashed"),
      align(center + horizon)[
        #text(font: fonts.mono, size: 8pt, fill: t.ink-faint)[photo]
      ],
    ),
    text(font: fonts.body, size: 13pt, weight: 600, fill: t.ink)[#name],
    text(font: fonts.body, size: 10pt, fill: t.ink-muted)[#role],
  )
}
