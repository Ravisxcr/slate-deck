#import "../src/lib.typ": *

#show: deck.with(title: "typeset demo deck", author: "Ravi", accent-hue: 250deg)

#slide(
  kind: "title",
  eyebrow: [typeset — presentation package],
  eyebrow-icon: "terminal",
  title: [Slides that read like a spec.],
  subtitle: [A Typst template system for corporate updates and developer talks — built on a strict grid, one accent color, and typography that holds up at the back of the room.],
  byline: ([Jordan Reyes], [Platform Engineering], [Jul 2026]),
)

#slide(
  kind: "section",
  label: [Section 02],
  title: [Architecture & rollout plan],
  blurb: [What we're shipping, in what order, and who owns each piece.],
  progress: [02 / 10],
)

#slide(kicker: [Why this matters], title: [Three problems the old deck format created])[
  #numbered-grid((
    ([Inconsistent typography], [Every team hand-rolled fonts and spacing, so decks never matched each other.]),
    ([No code-native layout], [Pasting snippets into slideware always broke indentation and syntax color.]),
    ([Manual rebuilds every quarter], [Rebranding meant editing forty individual slide files by hand.]),
    ([Not version-controllable], [Binary deck files can't be diffed, reviewed, or merged like the rest of our docs.]),
  ))
]

#slide(
  kind: "compare",
  kicker: [Build vs. buy],
  title: [Two paths to a shared template],
  left: (
    label: [Option A],
    title: [Adopt a generic Typst theme],
    items: ([Ships this week], [No brand ownership], [Breaks on rebrand], [Generic component set]),
  ),
  right: (
    label: [Option B — recommended],
    title: [Build our own package],
    items: ([2 weeks to v1], [Full brand control], [One-line rebrand via config], [Components tuned to our content]),
    recommended: true,
  ),
)

#slide(
  kind: "stat",
  kicker: [Deck production time],
  value: [6x],
  caption: [faster from outline to reviewed deck],
  note: [Measured across 14 decks migrated from slideware to the package, Q2 2026.],
)

#slide(
  kind: "image",
  image: rect(width: 100%, height: 100%, fill: luma(230))[
    #align(center + horizon)[
      #text(font: "IBM Plex Mono", size: 13pt, fill: luma(100))[\[ product screenshot — drop full-bleed image here \]]
    ]
  ],
  caption-title: [Dashboard v2],
  caption-body: [Redesigned monitoring view, shipping with this release],
)

#slide(
  kind: "code",
  kicker: [API surface],
  kicker-icon: "code",
  title: [Declaring a slide is four lines],
  code: "#import \"@local/typeset:0.1.0\": *\n\nslide(kind: \"content\")[\n  = Rollout timeline\n  - Week 1: internal dogfood\n]",
)

#slide(
  kind: "quote",
  quote: [Switching to the shared template meant every team's deck finally looked like it came from the same company.],
  name: [Priya Nathan],
  role: [VP, Developer Platform],
)

#slide(
  kind: "team",
  kicker: [Who's building it],
  title: [The core package team],
  members: (
    (name: [Jordan Reyes], role: [Platform Eng]),
    (name: [Priya Nathan], role: [Dev Platform VP]),
    (name: [Marcus Ito], role: [Typography]),
    (name: [Ana Cole], role: [Design Systems]),
  ),
)

#slide(kicker: [Component: icon()], title: [One icon call, two icon families])[
  #text(font: "IBM Plex Mono", size: 10pt, tracking: 0.06em, fill: rgb("#7a7568"))[UI & CONCEPT ICONS — STROKE, SINGLE COLOR]
  #v(14pt)
  #cols(
    (
      "terminal", "git-branch", "package", "layers", "zap", "server",
    ).map(name => box(
      width: 100%,
      stroke: 1pt + rgb("#e0ddd3"),
      radius: 3pt,
      inset: 14pt,
    )[
      #align(center)[
        #icon(name, size: 18pt)
        #v(7pt)
        #text(size: 9pt, fill: rgb("#666052"))[#name]
      ]
    ]),
    columns: 6,
  )
  #v(28pt)
  #text(font: "IBM Plex Mono", size: 10pt, tracking: 0.06em, fill: rgb("#7a7568"))[STACK & TOOL MARKS — BRAND COLOR]
  #v(14pt)
  #cols(
    (
      ("react", "React"), ("python", "Python"), ("docker", "Docker"), ("kubernetes", "Kubernetes"), ("github", "GitHub"),
    ).map(((name, label)) => box(
      stroke: 1pt + rgb("#e0ddd3"),
      radius: 3pt,
      inset: (x: 16pt, y: 10pt),
    )[
      #icon(name, brand: true, size: 17pt)
      #h(8pt)
      #text(size: 11pt)[#label]
    ]),
    columns: 5,
  )
]

#slide(
  kind: "closing",
  title: [Thank you.],
  subtitle: [Package docs, install instructions, and source live at the link below.],
  footer: [typst.app/packages/typeset · \#design-systems],
)
