#import "../theme.typ": typeset-theme, fonts, spacing

// Bordered card for the build-vs-buy comparison slide. `recommended: true` flips it to an
// accent-tinted fill + accent border, matching the mockup's "Option B -- recommended" card.
#let compare-card(label, title, items, recommended: false) = context {
  let t = typeset-theme.get()
  let border-color = if recommended { t.accent } else { t.border }
  let label-color = if recommended { t.accent-kicker } else { t.ink-faint }
  let fill-color = if recommended {
    if t.is-dark { t.accent.transparentize(85%) } else { t.accent-soft }
  } else {
    t.card-bg
  }
  block(
    width: 100%,
    height: 320pt,
    breakable: false,
    stroke: 1.5pt + border-color,
    radius: 2pt,
    fill: fill-color,
    inset: spacing.lg,
  )[
    #text(font: fonts.mono, size: 9pt, tracking: 0.08em, fill: label-color)[#upper(label)]
    #v(spacing.sm)
    #text(font: fonts.display, weight: 700, size: 18pt, fill: t.ink)[#title]
    #v(spacing.sm)
    #line(length: 100%, stroke: 1pt + t.border)
    #v(spacing.sm)
    #stack(
      spacing: 10pt,
      ..items.map(i => text(font: fonts.body, size: 11pt, fill: t.ink-muted)[#i]),
    )
  ]
}

// Photo-placeholder + name + role card for the team-grid slide.
// Supports custom image/photo/avatar, customizable corner radius (e.g. 50% for circles), and custom photo height.
#let team-card(
  name,
  role,
  photo: none,
  image: none,
  avatar: none,
  radius: 3pt,
  height: 90pt,
) = context {
  let t = typeset-theme.get()
  let effective-photo = if photo != none { photo } else if image != none { image } else if avatar != none { avatar } else { none }
  
  let photo-block = if effective-photo == none {
    block(
      width: 100%,
      height: height,
      radius: radius,
      fill: if t.is-dark { t.card-bg } else { t.border },
      stroke: (paint: t.ink-faint, dash: "dashed"),
      align(center + horizon)[
        #text(font: fonts.mono, size: 8pt, fill: t.ink-faint)[photo]
      ],
    )
  } else {
    let img-content = if type(effective-photo) == str {
      std.image(effective-photo, width: 100%, height: 100%, fit: "cover")
    } else {
      effective-photo
    }
    block(
      width: 100%,
      height: height,
      radius: radius,
      clip: true,
      stroke: 0.5pt + t.border,
      fill: if t.is-dark { t.card-bg } else { t.border },
      img-content,
    )
  }

  stack(
    spacing: 10pt,
    photo-block,
    text(font: fonts.body, size: 13pt, weight: 600, fill: t.ink)[#name],
    text(font: fonts.body, size: 10pt, fill: t.ink-muted)[#role],
  )
}
