// Extended gallery. demo.typ is the living spec (one example per mockup section, in mockup
// order) -- this file is a second example deck that pushes past that 1:1 mapping to show the
// package's actual range: components reused outside their default slide kind, icon() at
// arbitrary sizes/contexts, native Typst markup inside a content body, and a live mid-deck
// rebrand via theme state.
#import "../src/lib.typ": *
#import "../src/theme.typ": make-theme, typeset-theme

#show: deck.with(title: "typeset showcase", author: "Ravi", accent: rgb("#0ea5e9"))

#slide(
  kind: "title",
  eyebrow: [typeset — extended gallery],
  eyebrow-icon: "layers",
  title: [Not just eleven slide templates.],
  subtitle: [A small set of primitives -- icon(), cols(), the card/stat/quote components -- meant to be recombined, not just filled in.],
  byline: ([Ravi], [typeset], [Jul 2026]),
)

#slide(kicker: [Content is just Typst], title: [Slide bodies have no fixed schema])[
  #cols(
    (
      context {
        let t = typeset-theme.get()
        stack(
          spacing: spacing.md,
          ..(
            ("check-circle-2", [Native Typst markup — headings, math, footnotes all just work]),
            ("layers", [Nest any component inside any slide kind — nothing is sealed off]),
            ("git-branch", [A content body is one Typst value, not a slot-filling template]),
          ).map(((name, label)) => grid(
            columns: (auto, 1fr),
            column-gutter: spacing.md,
            align: top,
            icon(name, size: 15pt),
            text(font: fonts.body, size: 12pt, fill: t.ink-muted)[#label],
          ))
        )
      },
      context {
        let t = typeset-theme.get()
        set text(font: fonts.body, size: 12pt, fill: t.ink-muted)
        set list(marker: text(fill: t.accent)[•], spacing: spacing.sm)
        [
          - This is a plain Typst list
          - #strong[Bold] and #emph[italic] need zero setup
          - Nested lists work too:
            - like this
            - and this
        ]
      },
    ),
    columns: 2,
  )
]

#slide(kicker: [Component: icon()], title: [Sizes and baseline-aligns to whatever surrounds it])[
  #context {
    let t = typeset-theme.get()
    stack(
      spacing: spacing.xl,
      text(font: fonts.body, size: 13pt, fill: t.ink-muted)[
        Inline at body size — #icon("terminal") init, #icon("git-branch") branch, #icon("package") ship —
        or #text(size: 22pt, fill: t.ink)[dramatically larger #icon("terminal", size: 22pt) and still on the baseline].
      ],
      grid(
        columns: (auto, auto, auto, auto, auto),
        column-gutter: spacing.xl,
        align: bottom + center,
        ..(10pt, 16pt, 22pt, 30pt, 40pt).map(s => stack(
          spacing: spacing.xs,
          align(center)[#icon("zap", size: s)],
          align(center)[#text(font: fonts.mono, size: 8pt, fill: t.ink-faint)[#s]],
        ))
      ),
    )
  }
]

#slide(kicker: [Component: icon(brand: true)], title: [The full curated stack-icon set])[
  #context {
    let t = typeset-theme.get()
    cols(
      (
        "react", "python", "docker", "kubernetes", "github", "gitlab", "linux", "rust",
        "go", "postgresql", "redis", "graphql", "nodedotjs", "javascript", "typescript", "figma",
      ).map(name => box(
        width: 100%,
        stroke: 1pt + t.border,
        radius: 3pt,
        inset: 12pt,
      )[
        #align(center)[
          #icon(name, brand: true, size: 20pt)
          #v(6pt)
          #text(font: fonts.mono, size: 8pt, fill: t.ink-faint)[#name]
        ]
      ]),
      columns: 8,
      row-gutter: spacing.md,
      column-gutter: spacing.md,
    )
  }
]

#slide(kicker: [Component reuse], title: [compare-card isn't locked to the "compare" kind])[
  #v(spacing.sm)
  #grid(
    columns: (1fr, 1fr, 1fr),
    column-gutter: spacing.lg,
    compare-card(
      [Option A],
      [Status quo],
      ([Ships today], [No new dependency], [Same problems next quarter]),
    ),
    compare-card(
      [Option B],
      [Incremental fix],
      ([One sprint], [Patches the symptom], [Doesn't touch root cause]),
    ),
    compare-card(
      [Option C — recommended],
      [Rebuild on typeset],
      ([Two sprints], [Fixes root cause], [Every future deck inherits it]),
      recommended: true,
    ),
  )
]

#slide(kicker: [Component reuse], title: [stat-hero works on paper, not just the navy "stat" kind])[
  #v(spacing.xl)
  #stat-hero([12], [line + brand icons in the curated set — same component, `on: "ink"` instead of the default navy], on: "ink")
]

#slide(
  kind: "code",
  kicker: [Syntax highlighting isn't Typst-only],
  kicker-icon: "terminal",
  title: [`lang:` is passed straight to Typst's `raw`],
  lang: "py",
  code: "def rebrand(hue):\n    # one call away from a different-looking deck\n    return make_theme(accent_hue=hue)\n\nprint(rebrand(15))",
)

#slide(
  kind: "team",
  kicker: [team-card scales to whatever `columns` you pass],
  title: [Same component, six across instead of four],
  columns: 6,
  members: (
    (name: [Jordan Reyes], role: [Platform Eng]),
    (name: [Priya Nathan], role: [Dev Platform]),
    (name: [Marcus Ito], role: [Typography]),
    (name: [Ana Cole], role: [Design Systems]),
    (name: [Sam Okafor], role: [Icons]),
    (name: [Lena Vogt], role: [Docs]),
  ),
)

#slide(
  kind: "section",
  label: [Live rebrand],
  title: [Everything past this slide is one config line away],
  blurb: [No component below has changed — only `accent` did.],
  progress: [09 / 12],
)

// The "one-line rebrand" pitch, demonstrated rather than described: updating the theme state
// mid-document retroactively recolors every component from here on, with zero component edits.
#typeset-theme.update(make-theme(accent: rgb("#e11d48")))

#slide(kicker: [Same components, new accent], title: [accent: `#e11d48` — nothing else touched])[
  #numbered-grid((
    ([Still the same numbered-grid], [Every token — accent, accent-soft, on-navy-accent — derives from the accent color.]),
    ([Still the same icon() calls], [#icon("check-circle-2", size: 14pt) recolors automatically, no per-call override.]),
  ))
]

#slide(
  kind: "stat",
  kicker: [Rebrand, continued],
  value: [1],
  caption: [line of config to change every accent token in the deck],
  note: [Compare against the "Deck production time" stat slide in demo.typ — same component, different accent, zero edits.],
)

#slide(
  kind: "closing",
  title: [That's the range.],
  subtitle: [Eleven slide kinds, a handful of components, recombined freely — see demo.typ for the full spec.],
  footer: [typst.app/packages/typeset · \#design-systems],
)
