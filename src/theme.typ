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

// Builds the full color token set from a single accent hue/chroma, so a rebrand is a one-line
// config change (`deck.with(accent-hue: ..)`) instead of touching every component.
#let make-theme(accent-hue: 250deg, accent-chroma: 0.16) = (
  paper: oklch(98.5%, 0.004, 80deg),
  ink: oklch(20%, 0.01, 80deg),
  ink-muted: oklch(45%, 0.02, 80deg),
  ink-faint: oklch(65%, 0.01, 80deg),
  border: oklch(88%, 0.006, 80deg),
  accent: oklch(55%, accent-chroma, accent-hue),
  accent-soft: oklch(55%, accent-chroma, accent-hue, 5%),
  on-accent: oklch(98%, 0.01, accent-hue),
  on-accent-muted: oklch(92%, 0.03, accent-hue),
  navy: oklch(16%, 0.01, accent-hue),
  on-navy: oklch(98%, 0.01, accent-hue),
  on-navy-muted: oklch(70%, 0.03, accent-hue),
  on-navy-accent: oklch(65%, accent-chroma - 0.02, accent-hue),
)

#let typeset-theme = state("typeset-theme", make-theme())
#let typeset-progress = state("typeset-progress", false)
