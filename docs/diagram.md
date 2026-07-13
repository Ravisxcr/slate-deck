# diagram()

![Diagram slide](assets/gallery/diagram.png)

Source: `src/components/diagram.typ`. A manual-placement node/edge diagram primitive for
architecture diagrams, flowcharts, and ER diagrams. Backs the `diagram` slide kind
(`slide.typ`'s `_diagram-slide`) but is directly callable inside any `content` slide body too —
`examples/demo.typ` does both (see the request-path example using `kind: "diagram"`, and the
flowchart/ER examples calling `diagram()` inline).

**Deliberately no auto-layout.** There is no graph solver, no force-directed placement, no
automatic node arrangement. You place every node explicitly on a `(col:, row:)` grid, the same
way you'd place boxes on a whiteboard. This is a scope decision, not a missing feature — see
[index.md](index.md#design-philosophy-why-some-things-are-the-way-they-are). What *is*
automatic is edge routing around other nodes (below).

```typst
#diagram(
  (
    (id: "cdn", pos: (col: 0, row: 0), icon: "globe", label: [CloudFront]),
    (id: "api", pos: (col: 1, row: 0), icon: "server", label: [API Gateway]),
    (id: "db", pos: (col: 1, row: 1), icon: "database", label: [DynamoDB], accent: true),
  ),
  edges: (
    (from: "cdn", to: "api"),
    (from: "api", to: "db", label: [write]),
  ),
  cols: 2,
  rows: 2,
  theme: "dark",
)
```

## Signature

```typst
diagram(
  nodes,                                          // positional: array of node dicts
  edges: (),                                       // array of edge dicts
  cols: 3, rows: 2,                                 // canvas grid dimensions
  cell: (width: 150pt, height: 80pt),                // per-cell box size
  gutter: (x: spacing.xl, y: spacing.lg),             // gap between cells
  table-style: (header-height: 22pt, row-height: 18pt), // shared with er-table()
  theme: "light",                                        // "light" | "dark"
)
```

## Nodes

Two kinds, selected by `kind: "box"` (default) or `kind: "table"`.

### Box nodes

```typst
(id: "fn", pos: (col: 2, row: 0), icon: "boxes", label: [Lambda])
```

| field | required | notes |
|---|---|---|
| `id` | yes | string, referenced by edges |
| `pos` | yes | `(col:, row:)`, 0-indexed |
| `label` | yes | content |
| `icon` | no | Lucide name (or brand name with `icon-brand: true`) |
| `icon-layout` | no | `"top"` (default, icon above label) or `"left"` (icon beside label) |
| `icon-brand` | no | bool, passed through to `icon(..., brand: ...)` |
| `icon-color` | no | override icon color |
| `accent` | no | bool — accent border + `accent-soft` fill, for highlighting one node |
| `span` | no | `(colspan:, rowspan:)` — grow the box across multiple cells |

### Table nodes

```typst
(
  id: "customers", pos: (col: 0, row: 0), kind: "table",
  name: "customers",
  columns: (
    (name: "id", type: "uuid", key: "pk"),
    (name: "email", type: "text"),
  ),
)
```

Delegates to [`er-table()`](components.md#er-tablename-columns-width-220pt-height-auto-header-height-22pt-row-height-18pt-accent-false),
passed a fixed pixel `width`/`height` computed from the node's grid cell so the table's own
internal row math (`header-height + row * row-height`) always matches the coordinates `diagram()`
uses for row-anchor edges (see below). `accent: true` on the node passes through to `er-table`'s
accent header treatment.

## Edges

```typst
(from: "fn", to: "cache", style: "dashed", arrow: "both", label: [cache])
```

| field | required | notes |
|---|---|---|
| `from`, `to` | yes | node id string, or `(id:, row:)` for a row anchor into a table node |
| `arrow` | no | `"end"` (default), `"both"`, or `"none"` |
| `style` | no | `"solid"` (default) or `"dashed"` |
| `color` | no | override line color (default `ink-faint`) |
| `bend` | no | `"auto"` (default), `"h-then-v"`, or `"v-then-h"` — see routing below |
| `label` | no | content, placed at the longest segment's midpoint with a background-matched pill |
| `label-offset` | no | `(dx:, dy:)` nudge for the label |

### Row anchors

`(id: "orders", row: 1)` targets a zero-height horizontal slice at that row's vertical center
inside a `kind: "table"` node — the classic ER-diagram "line points at this specific column, not
the whole table" anchor.

```typst
edges: ((from: (id: "orders", row: 1), to: (id: "customers", row: 0), label: [FK]),)
```

## Edge routing

Three route shapes, chosen by node geometry (`_route()`):

1. **Straight line** — nodes share a row or column; clipped to box edges, not centers.
2. **2-segment elbow** — nodes don't share a row/column and neither endpoint is a row anchor.
   `bend: "auto"` picks `h-then-v` or `v-then-h` based on which axis has the larger gap; you can
   force either explicitly.
3. **"Z" route** — one endpoint is a row anchor (zero height). A center-based elbow would bend at
   the target's center-x, landing *inside* the table box and hiding under it, so row anchors
   instead exit the source's facing edge, jog vertically at a midpoint, and enter the target's
   facing edge laterally.

### Obstacle avoidance is a bounded search, not pathfinding

Every other node on the canvas is a potential obstacle for a given edge (source/target's own boxes
are excluded). `_elbow-route`/`_z-route` first try the default route; if it crosses an obstacle
box (inflated by a 4pt clearance), they try a small fixed number of alternates
(`_route-max-tries = 5`, stepping the bend coordinate `_route-step = 14pt` at a time, both
directions) and take the first collision-free one. If none of those clear either, it falls back to
the original unrouted default rather than searching further.

This resolves *most* third-node crossings automatically, but it is explicitly not a general
solver — a same-row/same-column straight connector never detours around an obstacle at all (see
`_route()`'s straight-line branches, which skip obstacle checking entirely), and a very congested
cell can exhaust the bounded search. If a specific edge still visually crosses a node:

- Leave a routing "lane" — an empty row or column between the nodes the edge needs to clear.
- Or pick `bend: "h-then-v"` / `"v-then-h"` explicitly to force a different corner than
  `"auto"` would choose.

## Coordinate math

`_node-positions()` computes every node's absolute canvas position by pure arithmetic off
`(col, row)` — no measurement, no iterative layout:

```
x0 = col * (cell.width + gutter.x)
y0 = row * (cell.height + gutter.y)
w  = colspan * cell.width + (colspan - 1) * gutter.x
h  = rowspan * cell.height + (rowspan - 1) * gutter.y
```

The whole diagram is then wrapped in a fixed-size `box(width: canvas-w, height: canvas-h, ...)`
where `canvas-w`/`canvas-h` are `cols`/`rows` times cell+gutter — so `cols:`/`rows:` must match
the actual extent of your `pos` values (including any `span`) or nodes will render outside the
box's nominal bounds (they'll still draw — Typst doesn't clip a `stack` — but the box's own
reported size will undercount).

## Theming

`theme: "light"` (paper background, `border`-colored box strokes) or `"dark"` (navy background,
`on-navy-muted`-transparentized strokes) picks every node/edge default color via the theme state,
same as every other component — see [design-tokens.md](design-tokens.md). Per-node/edge
`accent`/`color` overrides layer on top of that base.
