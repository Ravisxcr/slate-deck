#import "theme.typ": *
#import "components/kicker.typ": kicker as kicker-label
#import "components/icon.typ": icon
#import "components/columns.typ": cols, numbered-grid
#import "components/card.typ": compare-card, team-card
#import "components/stat.typ": stat-hero
#import "components/quote.typ": pull-quote
#import "components/code.typ": code-block
#import "components/diagram.typ": diagram

#let _footer-progress(progress, fill) = {
  if progress != none {
    place(bottom + right, dx: -spacing.page-x, dy: -spacing.page-y)[
      #text(font: fonts.mono, size: type-scale.number, fill: fill)[#progress]
    ]
  }
}

#let _title-slide(eyebrow: none, eyebrow-icon: none, title: none, subtitle: none, byline: ()) = context {
  let t = typeset-theme.get()
  page(fill: t.paper)[
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
            icon(eyebrow-icon, size: 13pt, color: t.accent),
            text(font: fonts.mono, size: type-scale.eyebrow, tracking: 0.08em, fill: t.ink-muted)[#upper(eyebrow)],
          )
        } else {
          text(font: fonts.mono, size: type-scale.eyebrow, tracking: 0.08em, fill: t.ink-muted)[#upper(eyebrow)]
        }
      ]
    }
    #place(top + left, dx: spacing.page-x, dy: 170pt)[
      #box(width: 750pt)[
        #text(font: fonts.display, weight: 800, size: type-scale.display, fill: t.ink)[#title]
        #if subtitle != none {
          v(spacing.lg)
          box(width: 550pt)[
            #text(font: fonts.body, size: type-scale.body-lg, fill: t.ink-muted)[#subtitle]
          ]
        }
      ]
    ]
    #if byline.len() > 0 {
      place(bottom + left, dx: spacing.page-x, dy: -spacing.xl)[
        #grid(
          columns: byline.len() * (auto,),
          column-gutter: spacing.xxl / 2,
          ..byline.map(b => text(font: fonts.mono, size: type-scale.number, fill: t.ink-muted)[#b])
        )
      ]
    }
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

#let _content-slide(kicker: none, title: none, progress: none, body) = context {
  let t = typeset-theme.get()
  page(fill: t.paper)[
    #pad(x: spacing.page-x, y: spacing.page-y)[
      #if kicker != none [
        #kicker-label(kicker)
        #v(spacing.sm)
      ]
      #if title != none [
        #text(font: fonts.display, weight: 700, size: type-scale.h2, fill: t.ink)[#title]
        #v(spacing.xl)
      ]
      #body
    ]
    #_footer-progress(progress, t.ink-faint)
  ]
}

#let _compare-slide(kicker: none, title: none, left: none, right: none, progress: none) = context {
  let t = typeset-theme.get()
  page(fill: t.paper)[
    #pad(x: spacing.page-x, y: spacing.page-y)[
      #if kicker != none [
        #kicker-label(kicker)
        #v(spacing.sm)
      ]
      #if title != none [
        #text(font: fonts.display, weight: 700, size: type-scale.h2, fill: t.ink)[#title]
        #v(spacing.xxl - spacing.xs)
      ]
      #grid(
        columns: (1fr, 1fr),
        column-gutter: spacing.xl,
        compare-card(left.label, left.title, left.items, recommended: left.at("recommended", default: false)),
        compare-card(right.label, right.title, right.items, recommended: right.at("recommended", default: false)),
      )
    ]
    #_footer-progress(progress, t.ink-faint)
  ]
}

#let _stat-slide(
  kicker: none,
  kicker-icon: none,
  value: none,
  caption: none,
  note: none,
  theme: "light",
  color: none,
  fill: none,
  bg: none,
  progress: none,
  ..rest,
) = context {
  let t = typeset-theme.get()
  let explicit-fill = if fill != none { fill } else if bg != none { bg } else if color != none { color } else { none }
  let is-dark = theme in ("dark", "navy")
  let is-accent = theme in ("accent",)
  let page-bg = if explicit-fill != none {
    explicit-fill
  } else if is-dark {
    t.navy
  } else if is-accent {
    t.accent
  } else {
    t.paper
  }
  let kicker-fill = if is-dark {
    t.on-navy-accent
  } else if is-accent {
    t.on-accent
  } else {
    t.accent
  }
  let note-fill = if is-dark {
    t.on-navy-muted
  } else if is-accent {
    t.on-accent-muted
  } else {
    t.ink-muted
  }
  let footer-fill = if is-dark {
    t.on-navy-muted
  } else if is-accent {
    t.on-accent-muted
  } else {
    t.ink-faint
  }
  let stat-on = if is-dark { "navy" } else if is-accent { "accent" } else { "paper" }
  page(fill: page-bg)[
    #pad(x: spacing.page-x, y: spacing.page-y)[
      #if kicker != none [
        #if kicker-icon != none {
          grid(
            columns: (auto, auto),
            column-gutter: spacing.sm,
            align: horizon,
            icon(kicker-icon, size: 11pt, color: kicker-fill),
            text(font: fonts.mono, size: type-scale.eyebrow, tracking: 0.08em, fill: kicker-fill)[#upper(kicker)],
          )
        } else {
          text(font: fonts.mono, size: type-scale.eyebrow, tracking: 0.08em, fill: kicker-fill)[#upper(kicker)]
        }
      ]
      #v(spacing.xxl)
      #stat-hero(value, caption, on: stat-on)
    ]
    #if note != none {
      place(bottom + left, dx: spacing.page-x, dy: -spacing.xl)[
        #box(width: 500pt)[
          #text(font: fonts.body, size: type-scale.body, fill: note-fill)[#note]
        ]
      ]
    }
    #_footer-progress(progress, footer-fill)
  ]
}

#let _image-slide(image: none, caption-title: none, caption-body: none, progress: none) = context {
  let t = typeset-theme.get()
  page(fill: t.border)[
    #box(width: 100%, height: 100%, clip: true)[#image]
    #if caption-title != none {
      place(bottom + left)[
        #block(fill: t.navy, inset: (x: spacing.xxl / 2, y: spacing.lg))[
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
    #_footer-progress(progress, t.ink-faint)
  ]
}

#let _code-slide(
  body: none,
  code: none,
  kicker: none,
  kicker-icon: none,
  title: none,
  lang: none,
  theme: "light",
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
  let is-light = theme == "light"
  let bg = if is-light { t.paper } else { t.navy }
  let title-fill = if is-light { t.ink } else { t.on-navy }
  let kicker-fill = if is-light { t.accent } else { t.on-navy-accent }
  let footer-fill = if is-light { t.ink-faint } else { t.on-navy-muted }
  page(fill: bg)[
    #pad(x: spacing.page-x, y: spacing.page-y)[
      #if kicker != none [
        #if kicker-icon != none {
          grid(
            columns: (auto, auto),
            column-gutter: spacing.sm,
            align: horizon,
            icon(kicker-icon, size: 11pt, color: kicker-fill),
            text(font: fonts.mono, size: type-scale.eyebrow, tracking: 0.08em, fill: kicker-fill)[#upper(kicker)],
          )
        } else {
          text(font: fonts.mono, size: type-scale.eyebrow, tracking: 0.08em, fill: kicker-fill)[#upper(kicker)]
        }
        #v(spacing.sm)
      ]
      #if title != none [
        #text(font: fonts.display, weight: 700, size: 30pt, fill: title-fill)[#title]
        #v(spacing.xxl - spacing.xs)
      ]
      #code-block(actual-code, lang: lang, theme: theme, highlight: highlight)
    ]
    #_footer-progress(progress, footer-fill)
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
  theme: "dark",
  progress: none,
) = context {
  let t = typeset-theme.get()
  let is-light = theme == "light"
  let bg = if is-light { t.paper } else { t.navy }
  let title-fill = if is-light { t.ink } else { t.on-navy }
  let kicker-fill = if is-light { t.accent } else { t.on-navy-accent }
  let footer-fill = if is-light { t.ink-faint } else { t.on-navy-muted }
  page(fill: bg)[
    #pad(x: spacing.page-x, y: spacing.page-y)[
      #if kicker != none [
        #if kicker-icon != none {
          grid(
            columns: (auto, auto),
            column-gutter: spacing.sm,
            align: horizon,
            icon(kicker-icon, size: 11pt, color: kicker-fill),
            text(font: fonts.mono, size: type-scale.eyebrow, tracking: 0.08em, fill: kicker-fill)[#upper(kicker)],
          )
        } else {
          text(font: fonts.mono, size: type-scale.eyebrow, tracking: 0.08em, fill: kicker-fill)[#upper(kicker)]
        }
        #v(spacing.sm)
      ]
      #if title != none [
        #text(font: fonts.display, weight: 700, size: 30pt, fill: title-fill)[#title]
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
          theme: theme,
        )
      ]
    ]
    #_footer-progress(progress, footer-fill)
  ]
}

#let _quote-slide(quote: none, name: none, role: none, progress: none) = context {
  let t = typeset-theme.get()
  page(fill: t.paper)[
    #place(horizon + left, dx: 80pt)[
      #box(width: page-size.width - 160pt)[
        #pull-quote(quote, name, role)
      ]
    ]
    #_footer-progress(progress, t.ink-faint)
  ]
}

#let _team-slide(kicker: none, title: none, members: (), columns: 4, progress: none) = context {
  let t = typeset-theme.get()
  page(fill: t.paper)[
    #pad(x: spacing.page-x, y: spacing.page-y)[
      #if kicker != none [
        #kicker-label(kicker)
        #v(spacing.sm)
      ]
      #if title != none [
        #text(font: fonts.display, weight: 700, size: type-scale.h2, fill: t.ink)[#title]
        #v(spacing.xxl)
      ]
      #cols(members.map(m => team-card(m.name, m.role)), columns: columns)
    ]
    #_footer-progress(progress, t.ink-faint)
  ]
}

#let _closing-slide(title: none, subtitle: none, footer: none) = context {
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
