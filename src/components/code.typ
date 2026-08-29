#import "../theme.typ": typeset-theme, fonts, type-scale, spacing

// Expands a highlight spec into a flat set of 1-indexed line numbers. Each item is either a
// single line number (5) or an inclusive range ((5, 7)).
#let expand-highlight(highlight) = {
  let lines = ()
  for item in highlight {
    if type(item) == array {
      let (from, to) = item
      for i in range(from, to + 1) { lines.push(i) }
    } else {
      lines.push(item)
    }
  }
  lines
}

// A ```lang ... ``` fence written on its own lines parses as a `sequence` wrapping the `raw`
// node (plus surrounding whitespace text), not a bare `raw` value -- unwrap it so code-block can
// read `.text`/`.lang` off the actual raw node either way.
#let _find-raw(body) = {
  if body == none {
    none
  } else if type(body) == str {
    none
  } else if type(body) == content {
    if body.func() == raw {
      body
    } else if body.has("children") {
      let found = none
      for child in body.children {
        if found == none { found = _find-raw(child) }
      }
      found
    } else if body.has("body") {
      _find-raw(body.body)
    } else {
      none
    }
  } else {
    none
  }
}

#let _extract-text(body) = {
  if body == none {
    ""
  } else if type(body) == str {
    body
  } else if type(body) == content {
    if body.has("text") {
      body.text
    } else if body.has("children") {
      body.children.map(_extract-text).join("")
    } else if body.has("body") {
      _extract-text(body.body)
    } else {
      ""
    }
  } else {
    repr(body)
  }
}

#let _is-ident(s) = {
  s.len() > 0 and s.clusters().all(c => (
    (c >= "a" and c <= "z") or 
    (c >= "A" and c <= "Z") or 
    (c >= "0" and c <= "9") or 
    c in ("_", "-", "+", "#")
  ))
}

#let _parse-raw-node(raw-node, lang-override) = {
  let text = raw-node.text
  let node-lang = raw-node.at("lang", default: none)
  if node-lang != none {
    let resolved = if lang-override != none { lang-override } else { node-lang }
    (text, resolved)
  } else {
    // When inline raw block fence contains a language header (e.g. ```js\n...\n``` inside brackets),
    // Typst may store the language on line 1 of .text instead of in .lang
    let lines = text.split("\n")
    if lines.len() > 1 and _is-ident(lines.at(0).trim()) {
      let inferred-lang = lines.at(0).trim()
      let rest-text = lines.slice(1).join("\n")
      let resolved = if lang-override != none { lang-override } else { inferred-lang }
      (rest-text, resolved)
    } else {
      let resolved = if lang-override != none { lang-override } else { "typ" }
      (text, resolved)
    }
  }
}

// Line-numbered code block for the "code" slide kind. Accepts either a plain string or a
// ```lang ... ``` raw block (so callers get real syntax-aware fencing + editor highlighting
// instead of an escaped string) -- `lang` overrides the fence's own tag when given. `highlight`
// takes line numbers / inclusive ranges (e.g. `(3, (5, 7))`) and tints those rows with the
// accent color; each line is still rendered as its own `raw` (single-line highlighter, matching
// the mockup's hand-styled spans) rather than a full multi-line syntax highlight pass.
#let code-block(
  body: none,
  code: none,
  lang: none, 
  numbers: true, 
  theme: "light", 
  highlight: (),
  ..rest,
) = context {
  let actual-body = if body != none {
    body
  } else if code != none {
    code
  } else if rest.pos().len() > 0 {
    rest.pos().at(0)
  } else {
    ""
  }

  let t = typeset-theme.get()
  let is-light = theme == "light"
  let pick(light, dark) = if is-light { light } else { dark }
  let fill = pick(t.paper, t.navy.darken(8%))
  let stroke = pick(1pt + t.border, 1pt + t.on-navy-muted.transparentize(75%))
  let text-fill = pick(t.ink, t.on-navy)
  let number-fill = pick(t.ink-faint, t.on-navy-muted.transparentize(35%))
  let highlight-fill = pick(t.accent-soft, t.accent.transparentize(85%))

  let raw-node = _find-raw(actual-body)
  let (text-content, resolved-lang) = if type(actual-body) == str {
    (actual-body, if lang != none { lang } else { "typ" })
  } else if raw-node != none {
    _parse-raw-node(raw-node, lang)
  } else {
    (_extract-text(actual-body), if lang != none { lang } else { "typ" })
  }
  let lines = text-content.trim("\n").split("\n")
  let highlighted = expand-highlight(highlight)

  block(
    width: 100%,
    fill: fill,
    stroke: stroke,
    radius: 3pt,
    inset: (x: 24pt, y: 16pt),
  )[
    #set text(font: fonts.mono, size: type-scale.code, fill: text-fill)
    #let children = ()
    #for (i, l) in lines.enumerate(start: 1) {
      if numbers {
        children.push(align(right, text(fill: number-fill)[#i]))
      }
      children.push([#h(spacing.md)#raw(l, lang: resolved-lang)])
    }
    #grid(
      columns: if numbers { (auto, 1fr) } else { (1fr,) },
      column-gutter: 0pt,
      row-gutter: 0pt,
      inset: (y: 0.45em),
      fill: (x, y) => if (y + 1) in highlighted { highlight-fill },
      ..children
    )
  ]
}
