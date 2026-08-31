#import "../theme.typ": typeset-theme, fonts, type-scale, spacing

// Pull-quote: accent rule, large display-weight quote, avatar placeholder or custom photo + attribution.
#let pull-quote(
  body,
  name,
  role,
  photo: none,
  image: none,
  avatar: none,
  radius: 50%,
  size: 32pt,
) = context {
  let t = typeset-theme.get()
  let effective-photo = if photo != none { photo } else if image != none { image } else if avatar != none { avatar } else { none }

  let photo-block = if effective-photo == none {
    block(
      width: size,
      height: size,
      radius: radius,
      fill: if t.is-dark { t.card-bg } else { t.border },
      stroke: (paint: t.ink-faint, dash: "dashed"),
      align(center + horizon)[
        #text(font: fonts.mono, size: 7pt, fill: t.ink-faint)[photo]
      ],
    )
  } else {
    let img-content = if type(effective-photo) == str {
      std.image(effective-photo, width: 100%, height: 100%, fit: "cover")
    } else {
      effective-photo
    }
    block(
      width: size,
      height: size,
      radius: radius,
      clip: true,
      stroke: 0.5pt + t.border,
      fill: if t.is-dark { t.card-bg } else { t.border },
      img-content,
    )
  }

  stack(
    spacing: spacing.xl,
    rect(width: 40pt, height: 4pt, fill: t.accent),
    box(width: 750pt)[
      #text(font: fonts.display, weight: 600, size: type-scale.quote, fill: t.ink)[#body]
    ],
    grid(
      columns: (auto, auto),
      column-gutter: spacing.md,
      align: horizon,
      photo-block,
      stack(
        spacing: 4pt,
        text(font: fonts.body, size: 13pt, weight: 600, fill: t.ink)[#name],
        text(font: fonts.body, size: 11pt, fill: t.ink-muted)[#role],
      ),
    ),
  )
}
