#import "../theme.typ": typeset-theme, fonts, spacing
#import "icon.typ": icon

// DB/ER schema table: header bar + one row per column, with a small key icon marking primary/
// foreign keys. Standalone (no dependency on diagram.typ) so it's usable in any content slide;
// diagram.typ also calls this for `kind: "table"` nodes, passing a fixed `height` so the row
// math there (header-height + row * row-height) always matches what's actually rendered here.
#let er-table(
  name,
  columns,
  width: 220pt,
  height: auto,
  header-height: 22pt,
  row-height: 18pt,
  accent: false,
) = context {
  let t = typeset-theme.get()
  let h = if height == auto { header-height + row-height * columns.len() } else { height }
  block(
    width: width,
    height: h,
    breakable: false,
    clip: true,
    stroke: 1pt + (if accent { t.accent } else { t.border }),
    radius: 2pt,
    fill: t.paper,
  )[
    #block(
      width: 100%,
      height: header-height,
      fill: if accent { t.accent } else { t.navy },
      inset: (x: spacing.sm, y: 0pt),
    )[
      #align(horizon)[
        #text(
          font: fonts.mono, weight: 600, size: 10pt,
          fill: if accent { t.on-accent } else { t.on-navy },
        )[#upper(name)]
      ]
    ]
    #for c in columns {
      block(
        width: 100%,
        height: row-height,
        inset: (x: spacing.sm, y: 0pt),
        stroke: (top: 0.5pt + t.border),
      )[
        #align(horizon)[
          #grid(
            columns: (12pt, 1fr, auto),
            column-gutter: 6pt,
            align: (center + horizon, left, right),
            if c.at("key", default: none) == "pk" {
              icon("key-round", size: 9pt, color: t.accent)
            } else if c.at("key", default: none) == "fk" {
              icon("key", size: 9pt, color: t.ink-faint)
            } else { [] },
            text(font: fonts.mono, size: 9pt, fill: t.ink)[#c.name],
            text(font: fonts.mono, size: 8pt, fill: t.ink-faint)[#c.type],
          )
        ]
      ]
    }
  ]
}
