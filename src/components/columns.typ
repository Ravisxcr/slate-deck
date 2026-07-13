#import "../theme.typ": typeset-theme, fonts, spacing

// Generic N-up column layout for card grids, icon rows, etc.
#let cols(items, columns: 2, row-gutter: spacing.lg, column-gutter: spacing.xl) = {
  grid(
    columns: (1fr,) * columns,
    row-gutter: row-gutter,
    column-gutter: column-gutter,
    ..items
  )
}

// The "01 / 02 / 03 / 04" numbered bullet grid from the mockup's content slide: big accent
// number, bold title, muted sub-line. `items` is an array of (title, body) pairs.
#let numbered-grid(items, columns: 2, row-gutter: spacing.lg, column-gutter: spacing.xl) = context {
  let t = typeset-theme.get()
  let cells = ()
  for (i, item) in items.enumerate(start: 1) {
    let (title, body) = item
    let num = if i < 10 { "0" + str(i) } else { str(i) }
    cells.push(grid(
      columns: (auto, 1fr),
      column-gutter: spacing.md,
      text(font: fonts.display, weight: 800, size: 20pt, fill: t.accent)[#num],
      stack(
        spacing: 5pt,
        text(font: fonts.body, size: 15pt, weight: 600, fill: t.ink)[#title],
        text(font: fonts.body, size: 11pt, fill: t.ink-muted)[#body],
      ),
    ))
  }
  grid(
    columns: (1fr,) * columns,
    row-gutter: row-gutter,
    column-gutter: column-gutter,
    ..cells
  )
}
