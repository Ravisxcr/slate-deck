#import "theme.typ": *
#import "components/kicker.typ": kicker as kicker-label
#import "components/icon.typ": icon
#import "components/columns.typ": cols, numbered-grid
#import "components/card.typ": compare-card, team-card
#import "components/stat.typ": stat-hero, stat-grid
#import "components/quote.typ": pull-quote
#import "components/code.typ": code-block
#import "components/diagram.typ": diagram

#let _footer-progress(progress, fill) = {
  let auto-prog = typeset-progress.get()
  let show-auto = (progress == true) or (progress == none and auto-prog == true)
  if show-auto {
    let cur = counter(page).get().first()
    let tot = counter(page).final().first()
    let digits = calc.max(2, str(tot).len())
    let pad(n) = {
      let s = str(n)
      "0" * calc.max(0, digits - s.len()) + s
    }
    let label = pad(cur) + " / " + pad(tot)
    place(bottom + right, dx: -spacing.page-x, dy: -spacing.page-y)[
      #text(font: fonts.mono, size: type-scale.number, fill: fill)[#label]
    ]
  } else if progress != none and progress != false {
    place(bottom + right, dx: -spacing.page-x, dy: -spacing.page-y)[
      #text(font: fonts.mono, size: type-scale.number, fill: fill)[#progress]
    ]
  }
}

#let _resolve-slide-theme(t, theme-override) = {
  if theme-override == auto or theme-override == none {
    (
      bg: t.bg,
      is-dark: t.is-dark,
      ink: t.ink,
      ink-muted: t.ink-muted,
      ink-faint: t.ink-faint,
      border: t.border,
      kicker-fill: t.accent-kicker,
      footer-fill: if t.is-dark { t.on-navy-muted } else { t.ink-faint },
    )
  } else if theme-override in ("dark", "navy") {
    (
      bg: t.navy,
      is-dark: true,
      ink: t.on-navy,
      ink-muted: t.on-navy-muted,
      ink-faint: t.on-navy-muted.transparentize(35%),
      border: oklch(28%, 0.015, oklch(t.accent).components().at(2)),
      kicker-fill: t.on-navy-accent,
      footer-fill: t.on-navy-muted,
    )
  } else if theme-override in ("charcoal", "black", "neutral-dark", "pure-dark") {
    (
      bg: t.charcoal,
      is-dark: true,
      ink: oklch(98%, 0.005, 80deg),
      ink-muted: oklch(70%, 0.01, 80deg),
      ink-faint: oklch(50%, 0.01, 80deg),
      border: oklch(28%, 0.005, 80deg),
      kicker-fill: t.on-navy-accent,
      footer-fill: oklch(70%, 0.01, 80deg),
    )
  } else if theme-override in ("slate", "midnight") {
    (
      bg: oklch(18%, 0.02, 240deg),
      is-dark: true,
      ink: oklch(98%, 0.01, 240deg),
      ink-muted: oklch(70%, 0.02, 240deg),
      ink-faint: oklch(50%, 0.02, 240deg),
      border: oklch(28%, 0.02, 240deg),
      kicker-fill: t.on-navy-accent,
      footer-fill: oklch(70%, 0.02, 240deg),
    )
  } else if theme-override in ("accent",) {
    (
      bg: t.accent,
      is-dark: true,
      ink: t.on-accent,
      ink-muted: t.on-accent-muted,
      ink-faint: t.on-accent-muted,
      border: t.on-accent-muted,
      kicker-fill: t.on-accent,
      footer-fill: t.on-accent-muted,
    )
  } else if type(theme-override) == color {
    let comp = oklch(theme-override).components()
    let is-d = comp.at(0) < 60%
    (
      bg: theme-override,
      is-dark: is-d,
      ink: if is-d { oklch(98%, 0.01, comp.at(2)) } else { oklch(20%, 0.01, 80deg) },
      ink-muted: if is-d { oklch(70%, 0.03, comp.at(2)) } else { oklch(45%, 0.02, 80deg) },
      ink-faint: if is-d { oklch(50%, 0.02, comp.at(2)) } else { oklch(65%, 0.01, 80deg) },
      border: if is-d { oklch(28%, 0.015, comp.at(2)) } else { oklch(88%, 0.006, 80deg) },
      kicker-fill: if is-d { t.on-navy-accent } else { t.accent },
      footer-fill: if is-d { oklch(70%, 0.03, comp.at(2)) } else { oklch(65%, 0.01, 80deg) },
    )
  } else {
    (
      bg: t.paper,
      is-dark: false,
      ink: oklch(20%, 0.01, 80deg),
      ink-muted: oklch(45%, 0.02, 80deg),
      ink-faint: oklch(65%, 0.01, 80deg),
      border: oklch(88%, 0.006, 80deg),
      kicker-fill: t.accent,
      footer-fill: oklch(65%, 0.01, 80deg),
    )
  }
}

#let _title-slide(eyebrow: none, eyebrow-icon: none, title: none, subtitle: none, byline: (), progress: none, theme: auto) = context {
  let t = typeset-theme.get()
  let st = _resolve-slide-theme(t, theme)
  page(fill: st.bg)[
    #place(top + left, dx: 0pt, dy: 0pt)[
      #rect(width: 7pt, height: page-size.height, fill: t.accent)
    ]
    #if eyebrow != none {
      place(top + left, dx: spacing.page-x, dy: spacing.xl)[
        #if eyebrow-icon != none {
          grid(
            columns: (auto, auto),
            column-gutter: spacing.sm,
            align: horizon,
            icon(eyebrow-icon, size: 13pt, color: st.kicker-fill),
            text(font: fonts.mono, size: type-scale.eyebrow, tracking: 0.08em, fill: st.ink-muted)[#upper(eyebrow)],
          )
        } else {
          text(font: fonts.mono, size: type-scale.eyebrow, tracking: 0.08em, fill: st.ink-muted)[#upper(eyebrow)]
        }
      ]
    }
    #place(top + left, dx: spacing.page-x, dy: 170pt)[
      #box(width: 750pt)[
        #text(font: fonts.display, weight: 800, size: type-scale.display, fill: st.ink)[#title]
        #if subtitle != none {
          v(spacing.lg)
          box(width: 550pt)[
            #text(font: fonts.body, size: type-scale.body-lg, fill: st.ink-muted)[#subtitle]
          ]
        }
      ]
    ]
    #if byline.len() > 0 {
      place(bottom + left, dx: spacing.page-x, dy: -spacing.xl)[
        #grid(
          columns: byline.len() * (auto,),
          column-gutter: spacing.xxl / 2,
          ..byline.map(b => text(font: fonts.mono, size: type-scale.number, fill: st.ink-muted)[#b])
        )
      ]
    }
    #_footer-progress(progress, st.footer-fill)
  ]
}

#let _section-slide(label: none, title: none, blurb: none, progress: none) = context {
  let t = typeset-theme.get()
  page(fill: t.accent)[
    #if label != none {
      place(top + left, dx: spacing.page-x, dy: spacing.xl)[
        #text(font: fonts.mono, size: type-scale.eyebrow, tracking: 0.08em, fill: t.on-accent-muted)[#upper(label)]
      ]
    }
    #place(top + left, dx: spacing.page-x, dy: 200pt)[
      #box(width: 750pt)[
        #text(font: fonts.display, weight: 800, size: type-scale.display-sm, fill: t.on-accent)[#title]
      ]
    ]
    #if blurb != none {
      place(bottom + left, dx: spacing.page-x, dy: -spacing.xl)[
        #box(width: 600pt)[
          #text(font: fonts.body, size: type-scale.body-lg, fill: t.on-accent-muted)[#blurb]
        ]
      ]
    }
    #_footer-progress(progress, t.on-accent-muted)
  ]
}

#let _content-slide(kicker: none, kicker-icon: none, title: none, progress: none, theme: auto, body) = context {
  let t = typeset-theme.get()
  let st = _resolve-slide-theme(t, theme)
  page(fill: st.bg)[
    #pad(x: spacing.page-x, y: spacing.page-y)[
      #if kicker != none [
        #if kicker-icon != none {
          grid(
            columns: (auto, auto),
            column-gutter: spacing.sm,
            align: horizon,
            icon(kicker-icon, size: 11pt, color: st.kicker-fill),
            text(font: fonts.mono, size: type-scale.eyebrow, tracking: 0.08em, fill: st.kicker-fill)[#upper(kicker)],
          )
        } else {
          kicker-label(kicker, color: st.kicker-fill)
        }
        #v(spacing.sm)
      ]
      #if title != none [
        #text(font: fonts.display, weight: 700, size: type-scale.h2, fill: st.ink)[#title]
        #v(spacing.xl)
      ]
      #body
    ]
    #_footer-progress(progress, st.footer-fill)
  ]
}

#let _compare-slide(kicker: none, kicker-icon: none, title: none, left: none, right: none, progress: none, theme: auto) = context {
  let t = typeset-theme.get()
  let st = _resolve-slide-theme(t, theme)
  page(fill: st.bg)[
    #pad(x: spacing.page-x, y: spacing.page-y)[
      #if kicker != none [
        #if kicker-icon != none {
          grid(
            columns: (auto, auto),
            column-gutter: spacing.sm,
            align: horizon,
            icon(kicker-icon, size: 11pt, color: st.kicker-fill),
            text(font: fonts.mono, size: type-scale.eyebrow, tracking: 0.08em, fill: st.kicker-fill)[#upper(kicker)],
          )
        } else {
          kicker-label(kicker, color: st.kicker-fill)
        }
        #v(spacing.sm)
      ]
      #if title != none [
        #text(font: fonts.display, weight: 700, size: type-scale.h2, fill: st.ink)[#title]
        #v(spacing.xxl - spacing.xs)
      ]
      #grid(
        columns: (1fr, 1fr),
        column-gutter: spacing.xl,
        compare-card(left.label, left.title, left.items, recommended: left.at("recommended", default: false)),
        compare-card(right.label, right.title, right.items, recommended: right.at("recommended", default: false)),
      )
    ]
    #_footer-progress(progress, st.footer-fill)
  ]
}

#let _stat-slide(
  kicker: none,
  kicker-icon: none,
  value: none,
  caption: none,
  stats: (),
  columns: auto,
  direction: "row",
  size: auto,
  row-gutter: auto,
  column-gutter: auto,
  note: none,
  theme: auto,
  color: none,
  fill: none,
  bg: none,
  progress: none,
  ..rest,
) = context {
  let t = typeset-theme.get()
  let st = _resolve-slide-theme(t, theme)
  let explicit-fill = if fill != none { fill } else if bg != none { bg } else if color != none { color } else { none }
  let page-bg = if explicit-fill != none { explicit-fill } else { st.bg }
  let stat-on = if st.is-dark { "navy" } else { "paper" }

  let normalized-stats = if stats.len() > 0 {
    stats
  } else if value != none {
    ((value: value, caption: caption),)
  } else {
    ()
  }

  let is-single = normalized-stats.len() == 1 and columns == auto and size == auto

  let top-v-gap = if is-single {
    spacing.xxl
  } else if normalized-stats.len() <= 2 {
    spacing.xl
  } else {
    spacing.lg
  }

  page(fill: page-bg)[
    #pad(x: spacing.page-x, y: spacing.page-y)[
      #if kicker != none [
        #if kicker-icon != none {
          grid(
            columns: (auto, auto),
            column-gutter: spacing.sm,
            align: horizon,
            icon(kicker-icon, size: 11pt, color: st.kicker-fill),
            text(font: fonts.mono, size: type-scale.eyebrow, tracking: 0.08em, fill: st.kicker-fill)[#upper(kicker)],
          )
        } else {
          text(font: fonts.mono, size: type-scale.eyebrow, tracking: 0.08em, fill: st.kicker-fill)[#upper(kicker)]
        }
      ]
      #v(top-v-gap)
      #if is-single {
        let s = normalized-stats.at(0)
        let (val, cap) = if type(s) == dictionary {
          (s.at("value", default: s.at("val", default: "")), s.at("caption", default: s.at("cap", default: "")))
        } else if type(s) == array {
          (s.at(0, default: ""), s.at(1, default: ""))
        } else {
          (s, "")
        }
        stat-hero(val, cap, on: stat-on)
      } else {
        stat-grid(
          normalized-stats,
          columns: columns,
          direction: direction,
          on: stat-on,
          size: size,
          row-gutter: row-gutter,
          column-gutter: column-gutter,
        )
      }
    ]
    #if note != none {
      place(bottom + left, dx: spacing.page-x, dy: -spacing.xl)[
        #box(width: 500pt)[
          #text(font: fonts.body, size: type-scale.body, fill: st.ink-muted)[#note]
        ]
      ]
    }
    #_footer-progress(progress, st.footer-fill)
  ]
}

#let _image-slide(image: none, caption-title: none, caption-body: none, progress: none, theme: auto) = context {
  let t = typeset-theme.get()
  let st = _resolve-slide-theme(t, theme)
  page(fill: st.border)[
    #box(width: 100%, height: 100%, clip: true)[#image]
    #if caption-title != none {
      place(bottom + left)[
        #block(fill: if st.is-dark { t.charcoal } else { t.navy }, inset: (x: spacing.xxl / 2, y: spacing.lg))[
          #grid(
            columns: (auto, auto),
            column-gutter: spacing.md,
            align: horizon,
            text(font: fonts.display, weight: 700, size: 16pt, fill: t.on-navy)[#caption-title],
            if caption-body != none {
              text(font: fonts.body, size: type-scale.body, fill: t.on-navy-muted)[#caption-body]
            } else { [] },
          )
        ]
      ]
    }
    #_footer-progress(progress, st.footer-fill)
  ]
}

#let _code-slide(
  body: none,
  code: none,
  kicker: none,
  kicker-icon: none,
  title: none,
  lang: none,
  theme: auto,
  highlight: (),
  progress: none,
  ..rest,
) = context {
  let actual-code = if code != none {
    code
  } else if body != none {
    body
  } else if rest.pos().len() > 0 {
    rest.pos().at(0)
  } else {
    ""
  }
  let t = typeset-theme.get()
  let st = _resolve-slide-theme(t, theme)
  let code-theme = if st.is-dark { "dark" } else { "light" }
  page(fill: st.bg)[
    #pad(x: spacing.page-x, y: spacing.page-y)[
      #if kicker != none [
        #if kicker-icon != none {
          grid(
            columns: (auto, auto),
            column-gutter: spacing.sm,
            align: horizon,
            icon(kicker-icon, size: 11pt, color: st.kicker-fill),
            text(font: fonts.mono, size: type-scale.eyebrow, tracking: 0.08em, fill: st.kicker-fill)[#upper(kicker)],
          )
        } else {
          text(font: fonts.mono, size: type-scale.eyebrow, tracking: 0.08em, fill: st.kicker-fill)[#upper(kicker)]
        }
        #v(spacing.sm)
      ]
      #if title != none [
        #text(font: fonts.display, weight: 700, size: 30pt, fill: st.ink)[#title]
        #v(spacing.xxl - spacing.xs)
      ]
      #code-block(actual-code, lang: lang, theme: code-theme, highlight: highlight)
    ]
    #_footer-progress(progress, st.footer-fill)
  ]
}

#let _diagram-slide(
  kicker: none,
  kicker-icon: none,
  title: none,
  nodes: (),
  edges: (),
  cols: 3,
  rows: 2,
  cell: (width: 150pt, height: 80pt),
  gutter: (x: spacing.xl, y: spacing.lg),
  table-style: (header-height: 22pt, row-height: 18pt),
  theme: auto,
  progress: none,
) = context {
  let t = typeset-theme.get()
  let st = _resolve-slide-theme(t, theme)
  let diag-theme = if st.is-dark { "dark" } else { "light" }
  page(fill: st.bg)[
    #pad(x: spacing.page-x, y: spacing.page-y)[
      #if kicker != none [
        #if kicker-icon != none {
          grid(
            columns: (auto, auto),
            column-gutter: spacing.sm,
            align: horizon,
            icon(kicker-icon, size: 11pt, color: st.kicker-fill),
            text(font: fonts.mono, size: type-scale.eyebrow, tracking: 0.08em, fill: st.kicker-fill)[#upper(kicker)],
          )
        } else {
          text(font: fonts.mono, size: type-scale.eyebrow, tracking: 0.08em, fill: st.kicker-fill)[#upper(kicker)]
        }
        #v(spacing.sm)
      ]
      #if title != none [
        #text(font: fonts.display, weight: 700, size: 30pt, fill: st.ink)[#title]
        #v(spacing.xxl - spacing.xs)
      ]
      #align(center)[
        #diagram(
          nodes,
          edges: edges,
          cols: cols,
          rows: rows,
          cell: cell,
          gutter: gutter,
          table-style: table-style,
          theme: diag-theme,
        )
      ]
    ]
    #_footer-progress(progress, st.footer-fill)
  ]
}

#let _quote-slide(quote: none, name: none, role: none, progress: none, theme: auto) = context {
  let t = typeset-theme.get()
  let st = _resolve-slide-theme(t, theme)
  page(fill: st.bg)[
    #place(horizon + left, dx: 80pt)[
      #box(width: page-size.width - 160pt)[
        #pull-quote(quote, name, role)
      ]
    ]
    #_footer-progress(progress, st.footer-fill)
  ]
}

#let _team-slide(kicker: none, kicker-icon: none, title: none, members: (), columns: 4, progress: none, theme: auto) = context {
  let t = typeset-theme.get()
  let st = _resolve-slide-theme(t, theme)
  page(fill: st.bg)[
    #pad(x: spacing.page-x, y: spacing.page-y)[
      #if kicker != none [
        #if kicker-icon != none {
          grid(
            columns: (auto, auto),
            column-gutter: spacing.sm,
            align: horizon,
            icon(kicker-icon, size: 11pt, color: st.kicker-fill),
            text(font: fonts.mono, size: type-scale.eyebrow, tracking: 0.08em, fill: st.kicker-fill)[#upper(kicker)],
          )
        } else {
          kicker-label(kicker, color: st.kicker-fill)
        }
        #v(spacing.sm)
      ]
      #if title != none [
        #text(font: fonts.display, weight: 700, size: type-scale.h2, fill: st.ink)[#title]
        #v(spacing.xxl)
      ]
      #cols(members.map(m => team-card(m.name, m.role)), columns: columns)
    ]
    #_footer-progress(progress, st.footer-fill)
  ]
}

#let _closing-slide(title: none, subtitle: none, footer: none, progress: none) = context {
  let t = typeset-theme.get()
  page(fill: t.accent)[
    #place(top + left, dx: spacing.page-x, dy: 200pt)[
      #box(width: 700pt)[
        #text(font: fonts.display, weight: 800, size: type-scale.display-sm, fill: t.on-accent)[#title]
        #if subtitle != none {
          v(spacing.md)
          text(font: fonts.body, size: type-scale.body-lg, fill: t.on-accent-muted)[#subtitle]
        }
      ]
    ]
    #if footer != none {
      place(bottom + left, dx: spacing.page-x, dy: -spacing.xl)[
        #text(font: fonts.mono, size: type-scale.number, fill: t.on-accent)[#footer]
      ]
    }
    #_footer-progress(progress, t.on-accent-muted)
  ]
}

// Single dispatcher. `kind` selects which of the layouts above renders; unknown/omitted kind
// falls back to "content" (kicker + headline + free-form body).
#let slide(kind: "content", ..args) = {
  let named = args.named()
  let pos = args.pos()
  if kind == "title" {
    _title-slide(..named, ..pos)
  } else if kind == "section" {
    _section-slide(..named, ..pos)
  } else if kind == "compare" {
    _compare-slide(..named, ..pos)
  } else if kind == "stat" {
    _stat-slide(..named, ..pos)
  } else if kind == "image" {
    _image-slide(..named, ..pos)
  } else if kind == "code" {
    _code-slide(..named, ..pos)
  } else if kind == "diagram" {
    _diagram-slide(..named, ..pos)
  } else if kind == "quote" {
    _quote-slide(..named, ..pos)
  } else if kind == "team" {
    _team-slide(..named, ..pos)
  } else if kind == "closing" {
    _closing-slide(..named, ..pos)
  } else {
    _content-slide(..named, pos.at(0, default: []))
  }
}
