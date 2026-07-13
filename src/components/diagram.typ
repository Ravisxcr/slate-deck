#import "../theme.typ": typeset-theme, fonts, spacing
#import "icon.typ": icon
#import "er-table.typ": er-table

// Node positions are pure arithmetic off an explicit (col, row) grid -- no auto-layout/graph
// solver. 0-indexed so the math below is multiplication-only and matches Typst's own array
// indexing convention.
#let _node-positions(nodes, cell, gutter) = {
  let positions = (:)
  for n in nodes {
    let span = n.at("span", default: (:))
    let colspan = span.at("colspan", default: 1)
    let rowspan = span.at("rowspan", default: 1)
    let x0 = n.pos.col * (cell.width + gutter.x)
    let y0 = n.pos.row * (cell.height + gutter.y)
    let w = colspan * cell.width + (colspan - 1) * gutter.x
    let h = rowspan * cell.height + (rowspan - 1) * gutter.y
    positions.insert(n.id, (x: x0, y: y0, w: w, h: h, node: n))
  }
  positions
}

#let _abs-len(l) = if l < 0pt { -l } else { l }

// An edge endpoint is either a plain node id (whole-node anchor) or `(id:, row:)` (a row anchor
// into a `kind: "table"` node -- a zero-height horizontal slice at that row's rendered y, using
// the same header-height/row-height constants passed to er-table() so the two always agree).
#let _ref-id(r) = if type(r) == str { r } else { r.id }
#let _ref-row(r) = if type(r) == dictionary { r.at("row", default: none) } else { none }

#let _anchor-box(ref, positions, table-style) = {
  let id = _ref-id(ref)
  let p = positions.at(id)
  let row = _ref-row(ref)
  if row == none {
    (x: p.x, y: p.y, w: p.w, h: p.h)
  } else {
    let ry = p.y + table-style.header-height + row * table-style.row-height + table-style.row-height / 2
    (x: p.x, y: ry, w: p.w, h: 0pt)
  }
}

// Does axis-aligned segment p0->p1 pass through `box` (inflated by `clearance` so a route has to
// clear some daylight around a node, not just avoid overlapping its exact border)?
#let _seg-hits-box(p0, p1, box, clearance) = {
  let bx0 = box.x - clearance
  let by0 = box.y - clearance
  let bx1 = box.x + box.w + clearance
  let by1 = box.y + box.h + clearance
  if _abs-len(p1.y - p0.y) < 0.5pt {
    let y = p0.y
    let xlo = calc.min(p0.x, p1.x)
    let xhi = calc.max(p0.x, p1.x)
    y > by0 and y < by1 and xhi > bx0 and xlo < bx1
  } else if _abs-len(p1.x - p0.x) < 0.5pt {
    let x = p0.x
    let ylo = calc.min(p0.y, p1.y)
    let yhi = calc.max(p0.y, p1.y)
    x > bx0 and x < bx1 and yhi > by0 and ylo < by1
  } else {
    false
  }
}

#let _path-hits-any(pts, boxes, clearance) = {
  let hit = false
  for i in range(pts.len() - 1) {
    for b in boxes {
      if _seg-hits-box(pts.at(i), pts.at(i + 1), b, clearance) {
        hit = true
      }
    }
  }
  hit
}

// Bounded fallback search, not a solver: a handful of deterministic alternative routes, tried in
// order, first collision-free one wins. Keeps the "no auto-layout/graph solver" scope from
// CLAUDE.local.md -- this never explores node placement or an unbounded route space, it only
// nudges the bend line of the existing 2-segment elbow shape outward in fixed steps.
#let _route-max-tries = 5
#let _route-step = 14pt

// `mode` picks which leg comes first; `bend-coord` is the shared x (h-then-v) or y (v-then-h) of
// the elbow's corner, overridable so the search below can slide it away from an obstacle.
#let _elbow-pts(s, t, mode, bend-coord) = {
  let scx = s.x + s.w / 2
  let scy = s.y + s.h / 2
  let tcx = t.x + t.w / 2
  let tcy = t.y + t.h / 2
  let dx = tcx - scx
  let dy = tcy - scy
  if mode == "h-then-v" {
    let exit-x = if dx > 0pt { s.x + s.w } else { s.x }
    let entry-y = if dy > 0pt { t.y } else { t.y + t.h }
    ((x: exit-x, y: scy), (x: bend-coord, y: scy), (x: bend-coord, y: entry-y))
  } else {
    let exit-y = if dy > 0pt { s.y + s.h } else { s.y }
    let entry-x = if dx > 0pt { t.x } else { t.x + t.w }
    ((x: scx, y: exit-y), (x: scx, y: bend-coord), (x: entry-x, y: bend-coord))
  }
}

#let _elbow-route(s, t, bend, obstacles, clearance) = {
  let scx = s.x + s.w / 2
  let scy = s.y + s.h / 2
  let tcx = t.x + t.w / 2
  let tcy = t.y + t.h / 2
  let dx = tcx - scx
  let dy = tcy - scy
  let preferred = if bend == "auto" {
    if _abs-len(dx) >= _abs-len(dy) { "h-then-v" } else { "v-then-h" }
  } else { bend }
  // Explicit bend choices stay authoritative (only offset-searched); "auto" may also try the
  // other leg order before resorting to offsets.
  let modes = if bend == "auto" {
    if preferred == "h-then-v" { ("h-then-v", "v-then-h") } else { ("v-then-h", "h-then-v") }
  } else {
    (preferred,)
  }
  let default-coord = (m) => if m == "h-then-v" { tcx } else { tcy }
  // The bend/corner coordinate doubles as the final segment's touch-point on the target box (its
  // x for h-then-v, its y for v-then-h) -- sliding it past the target's own span on that axis
  // would make the route "enter" a point beyond the box edge instead of on it, i.e. an arrow that
  // ends in empty space. Clamp every candidate to the target's span so it still lands on the box.
  let clamp-coord = (m, v) => if m == "h-then-v" {
    calc.max(t.x, calc.min(v, t.x + t.w))
  } else {
    calc.max(t.y, calc.min(v, t.y + t.h))
  }

  let found = none
  for mode in modes {
    if found == none {
      let pts = _elbow-pts(s, t, mode, default-coord(mode))
      if not _path-hits-any(pts, obstacles, clearance) { found = pts }
    }
  }
  if found == none {
    for i in range(1, _route-max-tries + 1) {
      for mode in modes {
        for sign in (1, -1) {
          if found == none {
            let coord = clamp-coord(mode, default-coord(mode) + sign * _route-step * i)
            let pts = _elbow-pts(s, t, mode, coord)
            if not _path-hits-any(pts, obstacles, clearance) { found = pts }
          }
        }
      }
    }
  }
  if found == none {
    _elbow-pts(s, t, modes.at(0), default-coord(modes.at(0)))
  } else {
    found
  }
}

// Row anchors (zero-height slices into a table node) only ever have meaningful left/right edges
// -- entering from the "top/bottom" of a single row doesn't make sense, and an h-then-v elbow
// would bend at the target's center-x, which lands *inside* the target box and gets hidden under
// it. Force a lateral "Z" route instead: exit source's facing edge, jog vertically at `mid-x`,
// enter target's facing edge.
#let _z-pts(s, t, mid-x) = {
  let scy = s.y + s.h / 2
  let tcy = t.y + t.h / 2
  let dx = (t.x + t.w / 2) - (s.x + s.w / 2)
  if dx > 0pt {
    ((x: s.x + s.w, y: scy), (x: mid-x, y: scy), (x: mid-x, y: tcy), (x: t.x, y: tcy))
  } else {
    ((x: s.x, y: scy), (x: mid-x, y: scy), (x: mid-x, y: tcy), (x: t.x + t.w, y: tcy))
  }
}

#let _z-route(s, t, obstacles, clearance) = {
  let dx = (t.x + t.w / 2) - (s.x + s.w / 2)
  let default-mid = if dx > 0pt { (s.x + s.w + t.x) / 2 } else { (s.x + t.x + t.w) / 2 }

  let found = none
  let default-pts = _z-pts(s, t, default-mid)
  if not _path-hits-any(default-pts, obstacles, clearance) { found = default-pts }
  if found == none {
    for i in range(1, _route-max-tries + 1) {
      for sign in (1, -1) {
        if found == none {
          let pts = _z-pts(s, t, default-mid + sign * _route-step * i)
          if not _path-hits-any(pts, obstacles, clearance) { found = pts }
        }
      }
    }
  }
  if found == none { default-pts } else { found }
}

// 2-segment right-angle "elbow" when nodes don't share a row/column, otherwise a single straight
// segment clipped to box edges (not centers). Every point is an absolute canvas coordinate. When
// `obstacles` is non-empty, the elbow/Z-route branches run a small bounded search (see
// `_elbow-route`/`_z-route`) for a path that clears every obstacle box; the collinear
// (same-row/same-column) straight-line case below is left unrouted around obstacles since a
// detour there would need a perpendicular jog rather than sliding an existing bend -- still worth
// a routing-lane row/column if that case gets crowded.
#let _route(s, t, bend: "auto", obstacles: (), clearance: 4pt) = {
  let scx = s.x + s.w / 2
  let scy = s.y + s.h / 2
  let tcx = t.x + t.w / 2
  let tcy = t.y + t.h / 2
  let dx = tcx - scx
  let dy = tcy - scy
  if _abs-len(dy) < 0.5pt {
    if dx > 0pt {
      ((x: s.x + s.w, y: scy), (x: t.x, y: tcy))
    } else {
      ((x: s.x, y: scy), (x: t.x + t.w, y: tcy))
    }
  } else if _abs-len(dx) < 0.5pt {
    if dy > 0pt {
      ((x: scx, y: s.y + s.h), (x: tcx, y: t.y))
    } else {
      ((x: scx, y: s.y), (x: tcx, y: t.y + t.h))
    }
  } else if s.h == 0pt or t.h == 0pt {
    _z-route(s, t, obstacles, clearance)
  } else {
    _elbow-route(s, t, bend, obstacles, clearance)
  }
}

#let _seg-dir(p0, p1) = {
  if p1.x > p0.x { "right" }
  else if p1.x < p0.x { "left" }
  else if p1.y > p0.y { "down" }
  else { "up" }
}

#let _seg-len(p0, p1) = _abs-len(p1.x - p0.x) + _abs-len(p1.y - p0.y)

// Every segment is axis-aligned, so an arrowhead only ever needs one of 4 fixed orientations.
#let _arrow-pts(tip, dir, size) = {
  if dir == "right" { (tip, (x: tip.x - size, y: tip.y - size / 2), (x: tip.x - size, y: tip.y + size / 2)) }
  else if dir == "left" { (tip, (x: tip.x + size, y: tip.y - size / 2), (x: tip.x + size, y: tip.y + size / 2)) }
  else if dir == "down" { (tip, (x: tip.x - size / 2, y: tip.y - size), (x: tip.x + size / 2, y: tip.y - size)) }
  else { (tip, (x: tip.x - size / 2, y: tip.y + size), (x: tip.x + size / 2, y: tip.y + size)) }
}

// Pulls a curve endpoint back opposite its direction of travel, so the stroke ends behind the
// arrowhead's base instead of poking through its tip.
#let _pull-back(p, dir, size) = {
  if dir == "right" { (x: p.x - size, y: p.y) }
  else if dir == "left" { (x: p.x + size, y: p.y) }
  else if dir == "down" { (x: p.x, y: p.y - size) }
  else { (x: p.x, y: p.y + size) }
}

#let _label-point(pts) = {
  let best-len = -1pt
  let best-mid = (x: 0pt, y: 0pt)
  for i in range(pts.len() - 1) {
    let p0 = pts.at(i)
    let p1 = pts.at(i + 1)
    let l = _seg-len(p0, p1)
    if l >= best-len {
      best-len = l
      best-mid = (x: (p0.x + p1.x) / 2, y: (p0.y + p1.y) / 2)
    }
  }
  best-mid
}

#let _draw-edge(edge, positions, table-style, t, bg) = {
  let from-id = _ref-id(edge.from)
  let to-id = _ref-id(edge.to)
  let s = _anchor-box(edge.from, positions, table-style)
  let tt = _anchor-box(edge.to, positions, table-style)
  // Every other node on the canvas is a potential obstacle for this edge's route -- the source
  // and target's own boxes are excluded since the route legitimately starts/ends inside them.
  let obstacles = ()
  for (id, p) in positions.pairs() {
    if id != from-id and id != to-id {
      obstacles.push((x: p.x, y: p.y, w: p.w, h: p.h))
    }
  }
  let pts = _route(s, tt, bend: edge.at("bend", default: "auto"), obstacles: obstacles)
  let arrow = edge.at("arrow", default: "end")
  let style = edge.at("style", default: "solid")
  let line-color = edge.at("color", default: none)
  if line-color == none { line-color = t.ink-faint }
  let arrow-size = 6pt
  let n = pts.len()
  let last-dir = _seg-dir(pts.at(n - 2), pts.at(n - 1))
  let first-dir = _seg-dir(pts.at(1), pts.at(0))

  let draw-pts = pts
  if arrow == "end" or arrow == "both" {
    draw-pts = draw-pts.slice(0, n - 1) + (_pull-back(draw-pts.at(n - 1), last-dir, arrow-size),)
  }
  if arrow == "both" {
    draw-pts = (_pull-back(draw-pts.at(0), first-dir, arrow-size),) + draw-pts.slice(1)
  }

  let stroke-spec = if style == "dashed" {
    (paint: line-color, thickness: 1.25pt, dash: "dashed")
  } else {
    (paint: line-color, thickness: 1.25pt)
  }

  let items = ()
  items.push(
    place(top + left, dx: 0pt, dy: 0pt)[
      #curve(
        stroke: stroke-spec,
        curve.move((draw-pts.at(0).x, draw-pts.at(0).y)),
        ..draw-pts.slice(1).map(p => curve.line((p.x, p.y))),
      )
    ],
  )
  if arrow == "end" or arrow == "both" {
    let tip = pts.at(n - 1)
    let vs = _arrow-pts(tip, last-dir, arrow-size).map(p => (p.x, p.y))
    items.push(place(top + left, dx: 0pt, dy: 0pt)[#polygon(fill: line-color, ..vs)])
  }
  if arrow == "both" {
    let tip0 = pts.at(0)
    let vs = _arrow-pts(tip0, first-dir, arrow-size).map(p => (p.x, p.y))
    items.push(place(top + left, dx: 0pt, dy: 0pt)[#polygon(fill: line-color, ..vs)])
  }
  if edge.at("label", default: none) != none {
    let mid = _label-point(pts)
    let off = edge.at("label-offset", default: (dx: 0pt, dy: 0pt))
    // context{} is pushed as a single deferred-content value (not a side-effecting block) so the
    // outer `items` mutation happens eagerly, even though `measure()` inside resolves later.
    items.push(context {
      let lbl = text(font: fonts.mono, size: 8pt, fill: t.ink-muted)[#edge.label]
      let sz = measure(lbl)
      place(top + left, dx: mid.x - sz.width / 2 - 3pt + off.dx, dy: mid.y - sz.height / 2 - 2pt + off.dy)[
        #box(fill: bg, inset: (x: 3pt, y: 2pt), radius: 2pt)[#lbl]
      ]
    })
  }
  stack(spacing: 0pt, ..items)
}

#let _render-box-node(node, w, h, t, border-color, fill-color, text-color) = {
  let acc = node.at("accent", default: false)
  let layout = node.at("icon-layout", default: "top")
  let ic = node.at("icon", default: none)
  let label = text(font: fonts.body, size: 10pt, weight: 600, fill: text-color)[#node.label]
  let content = if ic == none {
    align(center + horizon)[#label]
  } else if layout == "left" {
    grid(
      columns: (auto, 1fr),
      column-gutter: spacing.xs,
      align: horizon,
      icon(ic, size: 16pt, brand: node.at("icon-brand", default: false), color: node.at("icon-color", default: none)),
      label,
    )
  } else {
    stack(
      spacing: 6pt,
      align(center)[#icon(ic, size: 18pt, brand: node.at("icon-brand", default: false), color: node.at("icon-color", default: none))],
      align(center)[#label],
    )
  }
  block(
    width: w,
    height: h,
    breakable: false,
    clip: true,
    stroke: 1pt + (if acc { t.accent } else { border-color }),
    radius: 3pt,
    fill: if acc { t.accent-soft } else { fill-color },
    inset: spacing.sm,
  )[#align(center + horizon)[#content]]
}

// Manual-placement diagram primitive: nodes sit on an explicit (col, row) grid (0-indexed),
// edges reference node ids (or `(id:, row:)` for a row anchor into a table node) and are drawn
// as straight or right-angle elbow connectors. No auto-layout/graph solver -- see CLAUDE.local.md
// for why. Elbow and row-anchor routes run a small bounded search (see `_elbow-route`/`_z-route`
// in this file) to route around other nodes' boxes, so most third-node crossings resolve
// automatically; a same-row/same-column straight connector still doesn't detour, and a very
// congested cell can still exhaust the search -- leave a routing lane row/column or pick `bend`
// explicitly if a specific edge still crosses something.
#let diagram(
  nodes,
  edges: (),
  cols: 3,
  rows: 2,
  cell: (width: 150pt, height: 80pt),
  gutter: (x: spacing.xl, y: spacing.lg),
  table-style: (header-height: 22pt, row-height: 18pt),
  theme: "light",
) = context {
  let t = typeset-theme.get()
  let is-light = theme == "light"
  let bg = if is-light { t.paper } else { t.navy }
  let border-color = if is-light { t.border } else { t.on-navy-muted.transparentize(75%) }
  let fill-color = if is-light { t.paper } else { t.navy.darken(8%) }
  let text-color = if is-light { t.ink } else { t.on-navy }

  let positions = _node-positions(nodes, cell, gutter)
  let canvas-w = cols * cell.width + (cols - 1) * gutter.x
  let canvas-h = rows * cell.height + (rows - 1) * gutter.y

  let items = ()
  for e in edges {
    items.push(_draw-edge(e, positions, table-style, t, bg))
  }
  for p in positions.values() {
    let rendered = if p.node.at("kind", default: "box") == "table" {
      er-table(
        p.node.name,
        p.node.columns,
        width: p.w,
        height: p.h,
        header-height: table-style.header-height,
        row-height: table-style.row-height,
        accent: p.node.at("accent", default: false),
      )
    } else {
      _render-box-node(p.node, p.w, p.h, t, border-color, fill-color, text-color)
    }
    items.push(place(top + left, dx: p.x, dy: p.y)[#rendered])
  }

  box(width: canvas-w, height: canvas-h, stack(spacing: 0pt, ..items))
}
