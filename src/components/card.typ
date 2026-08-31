#import "../theme.typ": typeset-theme, fonts, spacing, _resolve-img-path

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
      std.image(_resolve-img-path(effective-photo), width: 100%, height: 100%, fit: "cover")
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

// Styled framed image container for PNG, JPG, and SVG assets with optional border, caption, and title.
#let image-card(
  image,
  caption: none,
  title: none,
  fit: "contain",
  align: center + horizon,
  radius: 4pt,
  stroke: auto,
  fill: auto,
  inset: spacing.sm,
  width: 100%,
  height: auto,
) = context {
  let t = typeset-theme.get()
  let resolved-height = if height in ("fit", "full", "fill") { 340pt } else { height }
  let img-content = if type(image) == str {
    std.image(
      _resolve-img-path(image),
      width: if width != auto { 100% } else { auto },
      height: if resolved-height != auto { 100% } else { auto },
      fit: fit,
    )
  } else {
    image
  }
  let effective-stroke = if stroke == auto { 1pt + t.border } else if stroke == none or stroke == false { none } else { stroke }
  let effective-fill = if fill == auto { if t.is-dark { t.card-bg } else { none } } else { fill }

  block(
    width: width,
    height: resolved-height,
    radius: radius,
    stroke: effective-stroke,
    fill: effective-fill,
    inset: inset,
    clip: true,
  )[
    #if title != none [
      #text(font: fonts.body, weight: 600, size: 12pt, fill: t.ink)[#title]
      #v(spacing.xs)
    ]
    #std.align(align)[#img-content]
    #if caption != none [
      #v(spacing.xs)
      #std.align(align)[
        #text(font: fonts.mono, size: 9pt, fill: t.ink-muted)[#caption]
      ]
    ]
  ]
}

#let image-frame = image-card

// Multi-image grid / collage helper
#let image-grid(
  images,
  columns: auto,
  radius: 4pt,
  gutter: spacing.md,
  fit: auto,
  height: auto,
  align: center + horizon,
  width: 100%,
) = {
  let normalized-images = if type(images) == array {
    images
  } else {
    (images,)
  }

  let num-cols = if columns != auto {
    columns
  } else if normalized-images.len() == 1 {
    1
  } else if normalized-images.len() <= 4 {
    normalized-images.len()
  } else {
    3
  }

  let effective-fit = if fit != auto {
    fit
  } else if num-cols == 1 or normalized-images.len() == 1 {
    "contain"
  } else {
    "cover"
  }

  let effective-height = if height in ("fit", "full", "fill") {
    if num-cols == 1 { 340pt } else { 180pt }
  } else if height == auto {
    if num-cols == 1 or normalized-images.len() == 1 { 340pt } else { 180pt }
  } else {
    height
  }

  grid(
    columns: (1fr,) * num-cols,
    gutter: gutter,
    ..normalized-images.map(img => {
      if type(img) == str {
        image-card(img, radius: radius, fit: effective-fit, height: effective-height, align: align, width: width)
      } else if type(img) == dictionary {
        let card-fit = img.at("fit", default: effective-fit)
        let card-h = img.at("height", default: effective-height)
        let resolved-h = if card-h in ("fit", "full", "fill") { if num-cols == 1 { 340pt } else { 180pt } } else { card-h }
        image-card(
          img.at("src", default: img.at("image", default: img.at("photo", default: ""))),
          title: img.at("title", default: none),
          caption: img.at("caption", default: none),
          fit: card-fit,
          radius: img.at("radius", default: radius),
          height: resolved-h,
          align: img.at("align", default: align),
          width: img.at("width", default: width),
        )
      } else {
        img
      }
    })
  )
}

#let collage = image-grid
