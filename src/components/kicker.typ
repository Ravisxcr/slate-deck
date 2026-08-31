#import "../theme.typ": typeset-theme, fonts, type-scale

// Uppercase, letter-spaced mono label used above every headline (matches the mockup's
// "Why this matters" / "Component: icon()" style eyebrow text).
#let kicker(body, color: none, size: type-scale.kicker) = context {
  let t = typeset-theme.get()
  let fill = if color != none { color } else { t.accent-kicker }
  text(
    font: fonts.mono,
    size: size,
    weight: 500,
    fill: fill,
    tracking: 0.08em,
  )[#upper(body)]
}
