#import "../theme.typ": typeset-theme, fonts, spacing

// Reorders items so they fill columns top-to-bottom (column-first) rather than left-to-right (row-first).
#let reorder-grid-items(items, columns: 2, direction: "row") = {
  let is-col = direction in ("col", "column", "col-first", "column-first", "ttb", "vertical")
  let n = items.len()
  if not is-col or columns <= 1 or n <= 1 {
    return items
  }
  let r-count = calc.ceil(n / columns)
  let short-cols = r-count * columns - n
  let full-cols = columns - short-cols
  let result = ()
  for r in range(r-count) {
    for c in range(columns) {
      let col-len = if c < full-cols { r-count } else { r-count - 1 }
      let col-start = if c < full-cols { c * r-count } else { full-cols * r-count + (c - full-cols) * (r-count - 1) }
      if r < col-len {
        result.push(items.at(col-start + r))
      } else {
        result.push([])
      }
    }
  }
  result
}

// Generic N-up column layout for card grids, icon rows, etc.
#let cols(
  items,
  columns: 2,
  direction: "row",
  row-gutter: spacing.lg,
  column-gutter: spacing.xl,
) = {
  let ordered = reorder-grid-items(items, columns: columns, direction: direction)
  grid(
    columns: (1fr,) * columns,
    row-gutter: row-gutter,
    column-gutter: column-gutter,
    ..ordered
  )
}

// The "01 / 02 / 03 / 04" numbered bullet grid from the mockup's content slide: big accent
// number, bold title, muted sub-line. `items` is an array of (title, body) pairs.
#let numbered-grid(
  items,
  columns: 2,
  direction: "row",
  row-gutter: spacing.lg,
  column-gutter: spacing.xl,
) = context {
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
  let ordered = reorder-grid-items(cells, columns: columns, direction: direction)
  grid(
    columns: (1fr,) * columns,
    row-gutter: row-gutter,
    column-gutter: column-gutter,
    ..ordered
  )
}
