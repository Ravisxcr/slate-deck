#import "../theme.typ": typeset-theme, fonts, type-scale, spacing

// Line-numbered code block for the "code" slide kind. Each line is highlighted independently
// (matches the mockup's own hand-styled spans rather than a full multi-line highlighter).
#let code-block(body, lang: "typ", numbers: true, theme: "dark") = context {
  let t = typeset-theme.get()
  let is-light = theme == "light"
  let fill = if is-light { t.paper } else { t.navy.darken(8%) }
  let stroke = if is-light { 1pt + t.border } else { 1pt + t.on-navy-muted.transparentize(75%) }
  let text-fill = if is-light { t.ink } else { t.on-navy }
  let number-fill = if is-light { t.ink-faint } else { t.on-navy-muted.transparentize(35%) }
  let lines = body.trim("\n").split("\n")
  block(
    width: 100%,
    fill: fill,
    stroke: stroke,
    radius: 3pt,
    inset: (x: 24pt, y: 20pt),
  )[
    #set text(font: fonts.mono, size: type-scale.code, fill: text-fill)
    #let children = ()
    #for (i, l) in lines.enumerate(start: 1) {
      if numbers {
        children.push(align(right, text(fill: number-fill)[#i]))
      }
      children.push(raw(l, lang: lang))
    }
    #grid(
      columns: if numbers { (auto, 1fr) } else { (1fr,) },
      column-gutter: spacing.lg,
      row-gutter: 0.9em,
      ..children
    )
  ]
}
