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

#let _resolve-accent(accent, accent-hue, accent-chroma) = {
  let raw = if accent != auto and accent != none { accent } else { accent-hue }
  if type(raw) == color {
    let comp = oklch(raw).components()
    let hue = comp.at(2)
    let chroma = if accent-chroma != auto and accent-chroma != none { accent-chroma } else { comp.at(1) }
    (hue, chroma)
  } else if type(raw) == str {
    let col = rgb(raw)
    let comp = oklch(col).components()
    let hue = comp.at(2)
    let chroma = if accent-chroma != auto and accent-chroma != none { accent-chroma } else { comp.at(1) }
    (hue, chroma)
  } else if type(raw) == angle {
    let chroma = if accent-chroma != auto and accent-chroma != none { accent-chroma } else { 0.16 }
    (raw, chroma)
  } else if type(raw) in (int, float) {
    let chroma = if accent-chroma != auto and accent-chroma != none { accent-chroma } else { 0.16 }
    (raw * 1deg, chroma)
  } else {
    panic("accent must be a color (e.g. rgb(\"#6f789a\")), hex string (e.g. \"#6f789a\"), or hue angle (e.g. 140deg)")
  }
}

// Builds the full color token set from a single accent color, hex string, or hue angle, so a rebrand is a one-line
// config change (`deck.with(accent: "#6f789a")` or `deck.with(accent-hue: 140deg)`) instead of touching every component.
#let make-theme(..args, accent: auto, accent-hue: 250deg, accent-chroma: auto) = {
  let pos = args.pos()
  let pos-accent = if pos.len() > 0 { pos.at(0) } else { auto }
  let effective-accent = if pos-accent != auto { pos-accent } else { accent }
  let (hue, chroma) = _resolve-accent(effective-accent, accent-hue, accent-chroma)
  (
    paper: oklch(98.5%, 0.004, 80deg),
    ink: oklch(20%, 0.01, 80deg),
    ink-muted: oklch(45%, 0.02, 80deg),
    ink-faint: oklch(65%, 0.01, 80deg),
    border: oklch(88%, 0.006, 80deg),
    accent: oklch(55%, chroma, hue),
    accent-soft: oklch(55%, chroma, hue, 5%),
    on-accent: oklch(98%, 0.01, hue),
    on-accent-muted: oklch(92%, 0.03, hue),
    navy: oklch(16%, 0.01, hue),
    on-navy: oklch(98%, 0.01, hue),
    on-navy-muted: oklch(70%, 0.03, hue),
    on-navy-accent: oklch(65%, calc.max(0.01, chroma - 0.02), hue),
  )
}

#let typeset-theme = state("typeset-theme", make-theme())
#let typeset-progress = state("typeset-progress", false)
