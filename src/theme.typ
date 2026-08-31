// Design tokens. Coordinates ported from the 1920x1080px reference mockup at an exact 0.5
// px->pt factor (page is 960pt x 540pt) -- see CLAUDE.md "Coordinate system" for the table.

#let fonts = (
  display: "Archivo",
  body: "IBM Plex Sans",
  mono: "IBM Plex Mono",
)

#let spacing = (
  xs: 8pt,
  sm: 14pt,
  md: 20pt,
  lg: 34pt,
  xl: 56pt,
  xxl: 70pt,
  page-x: 60pt,
  page-y: 40pt,
)

#let type-scale = (
  kicker: 11pt,
  body: 11pt,
  body-lg: 14pt,
  eyebrow: 10pt,
  h2: 34pt,
  display-sm: 56pt,
  display: 66pt,
  stat: 170pt,
  quote: 32pt,
  code: 13pt,
  number: 20pt,
)

#let page-size = (width: 960pt, height: 540pt)

#let _resolve-accent(accent) = {
  let raw = if type(accent) == str {
    rgb(accent)
  } else if type(accent) == color {
    accent
  } else {
    panic("accent must be a color (e.g. rgb(\"#4e61d8\")) or hex string (e.g. \"#4e61d8\")")
  }
  let comp = oklch(raw).components()
  let hue = comp.at(2)
  let chroma = comp.at(1)
  (hue, chroma)
}

#let _resolve-img-path(p) = {
  if type(p) == str {
    if p.starts-with("/") or p.starts-with(".") { p } else { "/" + p }
  } else {
    p
  }
}

#let _resolve-bg(theme-val, hue) = {
  if type(theme-val) == color {
    theme-val
  } else if type(theme-val) == str {
    if theme-val in ("dark", "navy") {
      oklch(16%, 0.015, hue)
    } else if theme-val in ("charcoal", "black", "neutral-dark", "pure-dark") {
      oklch(13%, 0.004, 80deg)
    } else if theme-val in ("slate", "midnight") {
      oklch(18%, 0.02, 240deg)
    } else if theme-val in ("accent",) {
      none
    } else {
      oklch(98.5%, 0.004, 80deg)
    }
  } else {
    oklch(98.5%, 0.004, 80deg)
  }
}

// Builds the full color token set from a single accent color and an optional global theme ("light", "dark", "navy", "charcoal", "slate", "black").
#let make-theme(accent: rgb("#4e61d8"), theme: "light", ..args) = {
  let named = args.named()
  let pos = args.pos()
  let target-accent = if pos.len() > 0 { pos.at(0) } else { accent }
  let target-theme = if named.at("mode", default: none) != none { named.mode } else { theme }
  let (hue, chroma) = _resolve-accent(target-accent)
  let resolved-bg = _resolve-bg(target-theme, hue)
  let is-dark = if resolved-bg != none { oklch(resolved-bg).components().at(0) < 60% } else { true }
  (
    mode: if is-dark { "dark" } else { "light" },
    theme-name: if type(target-theme) == str { target-theme } else { "custom" },
    bg: if resolved-bg != none { resolved-bg } else { oklch(55%, chroma, hue) },
    is-dark: is-dark,
    paper: oklch(98.5%, 0.004, 80deg),
    ink: if is-dark { oklch(98%, 0.01, hue) } else { oklch(20%, 0.01, 80deg) },
    ink-muted: if is-dark { oklch(70%, 0.03, hue) } else { oklch(45%, 0.02, 80deg) },
    ink-faint: if is-dark { oklch(50%, 0.02, hue) } else { oklch(65%, 0.01, 80deg) },
    border: if is-dark { oklch(28%, 0.015, hue) } else { oklch(88%, 0.006, 80deg) },
    card-bg: if is-dark { oklch(20%, 0.01, hue) } else { none },
    accent: oklch(55%, chroma, hue),
    accent-kicker: if is-dark { oklch(65%, calc.max(0.01, chroma - 0.02), hue) } else { oklch(55%, chroma, hue) },
    accent-soft: oklch(55%, chroma, hue, 5%),
    on-accent: oklch(98%, 0.01, hue),
    on-accent-muted: oklch(92%, 0.03, hue),
    navy: oklch(16%, 0.01, hue),
    on-navy: oklch(98%, 0.01, hue),
    on-navy-muted: oklch(70%, 0.03, hue),
    on-navy-accent: oklch(65%, calc.max(0.01, chroma - 0.02), hue),
    charcoal: oklch(13%, 0.004, 80deg),
  )
}

#let typeset-theme = state("typeset-theme", make-theme())
#let typeset-progress = state("typeset-progress", false)
