# Standalone Components Reference

In addition to full-slide layouts, SlateDeck provides a library of **modular UI components**. Every component is directly usable inside a standard `content` slide body, allowing you to compose rich, multi-element layouts effortlessly.

---

## Component Index

| Component | Use Case |
|---|---|
| [`icon()`](#1-icon) | Render Lucide line icons or full-color brand logos with automatic baseline alignment. |
| [`kicker()`](#2-kicker) | Uppercase letter-spaced mono category label in accent color. |
| [`numbered-grid()`](#3-numbered-grid) | "01 / 02 / 03" indexed cards with bold titles and descriptive copy. |
| [`cols()`](#4-cols) | Generic N-column grid helper for multi-item layouts. |
| [`compare-card()`](#5-compare-card) | Structured feature/option card with optional accent recommendation highlight. |
| [`team-card()`](#6-team-card) | Team member card with avatar placeholder, name, and role. |
| [`image-card()`](#7-image-card) | Framed container for PNG, JPG, and SVG assets with optional title & caption. |
| [`stat-hero()`](#8-stat-hero) | Oversized hero number paired with adjacent bold caption. |
| [`stat-grid()`](#9-stat-grid) | Multi-stat metric grid with configurable columns and flow direction. |
| [`pull-quote()`](#10-pull-quote) | Formatted testimonial with accent rule and author attribution. |
| [`code-block()`](#11-code-block) | Syntax-highlighted code block with line numbering and row highlights. |
| [`er-table()`](#12-er-table) | Database / ER schema table with column types and primary/foreign key badges. |

---

## 1. `icon()`

Renders any of the 1,750+ bundled SVG line icons or developer brand marks. Sizes and baseline-aligns automatically to surrounding text.

### Signature
```typst
#icon(name, size: 1em, color: none, brand: false, baseline: 15%)
```

### Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `name` | `string` | *Positional* | Name of the icon file in kebab-case (e.g. `"terminal"`, `"git-branch"`, `"docker"`). |
| `size` | `length` | `1em` | Width and height of the icon box. |
| `color` | `color` | `theme.accent` | Fill/stroke color for line icons (defaults to the active accent color). |
| `brand` | `bool` | `false` | When `true`, loads the official full-color brand logo from the brand collection. |
| `baseline` | `ratio` | `15%` | Vertical baseline offset to align smoothly with typography. |

### Examples

```typst
// Line icons inheriting accent color:
#icon("terminal")
#icon("git-branch", size: 18pt)
#icon("shield-check", color: rgb("#10b981"))

// Full-color brand marks:
#icon("react", brand: true, size: 24pt)
#icon("python", brand: true, size: 24pt)
#icon("docker", brand: true, size: 24pt)
```

---

## 2. `kicker()`

Renders an uppercase, letter-spaced (`tracking: 0.08em`) monospace category label in the active accent color.

### Signature
```typst
#kicker(body, color: none, size: 11pt)
```

### Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `body` | `content` | *Positional* | Label text to display. |
| `color` | `color` | `theme.accent` | Text color override. |
| `size` | `length` | `11pt` | Font size (defaults to `type-scale.kicker`). |

### Example

```typst
#kicker[Performance Optimization]
```

---

## 3. `numbered-grid()`

Renders the signature "01 / 02 / 03 / 04" indexed cards: large accent numbers paired with bold titles and explanatory body text.

### Signature
```typst
#numbered-grid(items, columns: 2, direction: "row", row-gutter: 34pt, column-gutter: 56pt)
```

### Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `items` | `array` | *Positional* | Array of `(title, description)` tuples or 2-element arrays. |
| `columns` | `int` | `2` | Number of columns in the grid. |
| `direction` | `string` | `"row"` | Flow order: `"row"` (left-to-right across rows) or `"column"` (top-to-bottom per column). |
| `row-gutter` | `length` | `34pt` | Vertical spacing between rows. |
| `column-gutter` | `length` | `56pt` | Horizontal spacing between columns. |

### Example

```typst
#slide(kicker: [Roadmap], title: [Next Steps for the Infrastructure Team])[
  #numbered-grid((
    ([Zero-Trust Network], [Enforce mTLS communication across all internal VPCs.]),
    ([Distributed Tracing], [Instrument OpenTelemetry spans across all microservices.]),
    ([Automated Canary], [Deploy rollouts with automated latency-regression rollback.]),
    ([Cost Optimization], [Migrate background workers to spot compute instances.]),
  ), columns: 2, direction: "column")
]
```

---

## 4. `cols()`

A generic N-column grid helper for arranging any collection of content blocks, cards, or icon lists.

### Signature
```typst
#cols(items, columns: 2, direction: "row", row-gutter: 34pt, column-gutter: 56pt)
```

### Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `items` | `array` | *Positional* | Array of content blocks to place into grid cells. |
| `columns` | `int` | `2` | Number of columns across the grid. |
| `direction` | `string` | `"row"` | Flow order: `"row"` (left-to-right) or `"column"` (top-to-bottom per column). |
| `row-gutter` | `length` | `34pt` | Vertical spacing between rows. |
| `column-gutter` | `length` | `56pt` | Horizontal spacing between columns. |

### Example

```typst
#cols(
  ("docker", "kubernetes", "linux", "googlecloud").map(name => {
    stack(
      spacing: 8pt,
      align(center, icon(name, brand: true, size: 32pt)),
      align(center, text(font: fonts.mono, size: 10pt)[#name]),
    )
  }),
  columns: 4,
)
```

---

## 5. `compare-card()`

A standalone comparison card with an upper label, title, divider line, and list of feature items. Setting `recommended: true` applies an accent border and soft tinted background.

### Signature
```typst
#compare-card(label, title, items, recommended: false)
```

### Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `label` | `content` | *Positional* | Top mono kicker text (e.g. `[Option A]`). |
| `title` | `content` | *Positional* | Main card heading. |
| `items` | `array` | *Positional* | Array of content lines. |
| `recommended` | `bool` | `false` | When `true`, highlights the card with an accent border and tint. |

### Example

```typst
#slide(kicker: [Evaluation], title: [Storage Engine Comparison])[
  #grid(
    columns: (1fr, 1fr, 1fr),
    column-gutter: 20pt,
    compare-card([Option 1], [In-Memory], ([Ultra-low latency], [Ephemeral storage])),
    compare-card([Option 2], [Relational], ([Strong ACID consistency], [Higher write latency])),
    compare-card([Option 3], [Document DB], ([Flexible JSON schema], [Scalable clustering]), recommended: true),
  )
]
```

---

## 6. `team-card()`

Renders a structured team card with an avatar/photo block (or dashed placeholder), prominent name, and role description.

### Signature
```typst
#team-card(name, role, photo: none, radius: 3pt, height: 90pt)
```

### Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `name` | `content` | *Positional* | Person's name (13pt semibold). |
| `role` | `content` | *Positional* | Person's title, team, or role description. |
| `photo` / `avatar` / `image` | `content` / `string` | `none` | Custom photo image path (e.g. `"assets/jordan.jpg"`) or `image(...)` content. |
| `radius` | `length` / `ratio` | `3pt` | Corner radius for the avatar box (use `50%` for circular avatars). |
| `height` | `length` | `90pt` | Height of the photo/avatar container block. |

### Example

```typst
// Default placeholder:
#team-card([Marcus Vance], [Principal Infrastructure Architect])

// Circular avatar with custom photo:
#team-card(
  [Priya Nathan],
  [VP Platform Engineering],
  photo: "assets/priya.jpg",
  radius: 50%,
)
```

---

---

## 7. `image-card()`

A styled framed container for PNG, JPG, and SVG assets with support for corner radius, optional border, title, and descriptive caption.

### Signature
```typst
#image-card(image, caption: none, title: none, fit: "contain", radius: 4pt, width: 100%, height: auto)
```

### Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `image` | `content` / `string` | *Positional* | Asset file path string (e.g. `"assets/diagram.png"`, `"assets/logo.svg"`) or `image(...)` content. |
| `title` | `content` | `none` | Bold title above the image. |
| `caption` | `content` | `none` | Monospace caption label below the image. |
| `fit` | `string` | `"contain"` | Scaling mode: `"contain"`, `"cover"`, or `"stretch"`. |
| `radius` | `length` | `4pt` | Corner radius for the frame. |
| `stroke` | `stroke` / `bool` / `auto` | `auto` | Border stroke (default `1pt + border`). |
| `fill` | `color` / `auto` | `auto` | Container background fill. |
| `width` | `length` / `ratio` | `100%` | Card width. |
| `height` | `length` / `auto` | `auto` | Card height. |

### Example

```typst
#slide(kicker: [Architecture], title: [Cluster Topology])[
  #grid(
    columns: (1fr, 1fr),
    column-gutter: 24pt,
    [
      #text(weight: 600)[Primary & Secondary Topology]
      - Automatic failover in under 2 seconds
      - Raft-based consensus protocol
    ],
    image-card("assets/topology.svg", title: [Replica Set Architecture], caption: [Figure 1.1]),
  )
]
```

---

## 8. `stat-hero()`

Displays a metric value (170pt hero display font or custom size) paired with an adjacent bold caption.

### Signature
```typst
#stat-hero(value, caption, on: "paper", size: auto)
```

### Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `value` | `content` | *Positional* | Big number or metric (e.g. `[10x]`, `[99.99%]`). |
| `caption` | `content` | *Positional* | Bold accompanying description text. |
| `on` | `string` | `"paper"` | Background mode: `"paper"` (dark text), `"navy"` / `"dark"` (light text), or `"accent"`. |
| `size` | `string` or `length` | `auto` | Size preset: `"hero"` (170pt), `"lg"` (88pt), `"md"` (64pt), `"sm"` (46pt), or custom length. |

### Example

```typst
#slide(kicker: [Throughput Gains], title: [Batch Processing Optimization])[
  #stat-hero([4.5x], [increase in records processed per second], on: "paper")
]
```

---

## 9. `stat-grid()`

Renders a grid of multiple metrics arranged across columns with customizable flow direction.

### Signature
```typst
#stat-grid(stats, columns: auto, direction: "row", on: "paper", size: auto)
```

### Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `stats` | `array` | *Positional* | Array of stat pairs `(([val], [cap]), ...)` or dictionaries `((value: [..], caption: [..]), ...)`. |
| `columns` | `int` or `auto` | `auto` | Number of columns in the grid (defaults to `auto` based on count). |
| `direction` | `string` | `"row"` | Flow order: `"row"` (left-to-right) or `"column"` (top-to-bottom per column). |
| `on` | `string` | `"paper"` | Background mode: `"paper"`, `"navy"`, or `"accent"`. |
| `size` | `string` or `length` | `auto` | Metric display size (`"hero"`, `"lg"`, `"md"`, `"sm"`). |

### Example

```typst
#slide(kicker: [Scale], title: [Global Infrastructure Metrics])[
  #stat-grid((
    ([17], [years in production]),
    ([99.99%], [uptime SLA]),
    ([10M+], [active clusters]),
    ([200+], [regions worldwide]),
  ), columns: 2, direction: "column")
]
```

---

## 10. `pull-quote()`

A testimonial pull-quote with a prominent accent rule, large quote typography (32pt), and an author avatar badge with name and role.

### Signature
```typst
#pull-quote(body, name, role, photo: none, radius: 50%, size: 32pt)
```

### Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `body` | `content` | *Positional* | Main quote text. |
| `name` | `content` | *Positional* | Attribution name. |
| `role` | `content` | *Positional* | Role or company title. |
| `photo` / `avatar` / `image` | `content` / `string` | `none` | Custom photo image path (e.g. `"assets/david.jpg"`) or `image(...)` content. |
| `radius` | `length` / `ratio` | `50%` | Avatar corner radius (default `50%` for circle). |
| `size` | `length` | `32pt` | Diameter / size of the avatar badge. |

### Example

```typst
#pull-quote(
  [Adopting standard schema tables in our architectural reviews reduced API integration errors by 60%.],
  [David Chen],
  [Head of Developer Experience],
  photo: "assets/david.jpg",
  radius: 50%,
)
```

---

## 11. `code-block()`

A line-numbered, syntax-highlighted code container with row highlighting and theme toggling.

### Signature
```typst
#code-block(body, lang: none, numbers: true, theme: "light", highlight: ())
```

### Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `body` | `string` or `raw` | *Positional* | Source code string or raw block ` ```lang ... ``` `. |
| `lang` | `string` | `none` | Language syntax identifier (e.g. `"typ"`, `"rust"`, `"python"`, `"json"`). |
| `numbers` | `bool` | `true` | When `true`, displays 1-indexed line numbers in the gutter. |
| `theme` | `string` | `"light"` | Color scheme: `"light"` (paper container) or `"dark"` (navy container). |
| `highlight` | `array` | `()` | Line numbers or inclusive tuples to tint with accent color, e.g. `(2, (4, 6))`. |

### Example

```typst
#slide(kicker: [Implementation], title: [Defining Custom Middleware])[
  #code-block(```rust
  pub async fn auth_middleware(
      req: Request<Body>,
      next: Next<Body>,
  ) -> Result<Response, StatusCode> {
      let token = req.headers().get("Authorization")
          .ok_or(StatusCode::UNAUTHORIZED)?;
      // Validate session token with identity provider
      next.run(req).await
  }
  ```, lang: "rust", highlight: (5, 6), theme: "dark")
]
```

---

## 12. `er-table()`

A standalone database / ER schema table displaying a stylized table header, column names, data types, and primary/foreign key badges.

### Signature
```typst
#er-table(
  name,
  columns,
  width: 220pt,
  height: auto,
  header-height: 22pt,
  row-height: 18pt,
  accent: false,
)
```

### Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `name` | `string` | *Positional* | Table name displayed in the header bar. |
| `columns` | `array` | *Positional* | Array of column dictionaries: `((name:, type:, key:), ...)`. |
| `width` | `length` | `220pt` | Total width of the table card. |
| `height` | `length` or `auto` | `auto` | Total height (automatically calculated if `auto`). |
| `header-height` | `length` | `22pt` | Height of the header bar. |
| `row-height` | `length` | `18pt` | Height of each column row. |
| `accent` | `bool` | `false` | When `true`, fills the header bar and border with the accent color. |

### Column Dictionary Fields
- `name`: Column identifier string (e.g. `"user_id"`).
- `type`: Data type string (e.g. `"uuid"`, `"varchar"`, `"timestamp"`).
- `key`: Optional key badge: `"pk"` (Primary Key, displays key icon) or `"fk"` (Foreign Key).

### Example

```typst
#slide(kicker: [Database Schema], title: [Relational Model for Order Processing])[
  #grid(
    columns: (auto, auto),
    column-gutter: 40pt,
    er-table("users", (
      (name: "id",         type: "uuid",      key: "pk"),
      (name: "email",      type: "varchar"),
      (name: "created_at", type: "timestamp"),
    ), accent: true),
    er-table("orders", (
      (name: "id",         type: "uuid",      key: "pk"),
      (name: "user_id",    type: "uuid",      key: "fk"),
      (name: "amount",     type: "numeric"),
      (name: "status",     type: "varchar"),
    )),
  )
]
```
