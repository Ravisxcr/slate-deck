# Slide Kinds Reference

SlateDeck provides **11 built-in slide layouts** covering title slides, section dividers, structured content, code demonstrations, comparisons, metrics, quotes, team rosters, and architecture diagrams.

Every slide is authored using the unified `#slide(...)` function:

```typst
#slide(
  kind: "content", // Slide layout type (defaults to "content")
  kicker: [Topic],
  title: [Slide Title],
  progress: [02 / 10], // Optional slide progress marker
)[
  // Body content (for "content" slides)
]
```

> [!NOTE]
> **Progress Indicator**
> Every slide kind (except `title` and `closing`) accepts the optional `progress:` parameter, rendering an elegant monospace progress counter in the bottom-right corner (e.g. `progress: [03 / 12]`).

---

## 1. `title` — Cover Slide

![Title Slide](assets/gallery/title.png)

The primary presentation cover slide. Features a vertical accent bar on the left edge, an optional eyebrow label with icon, large display title, subtitle, and an evenly spaced byline row.

### Parameters

| Parameter | Type | Default | Required? | Description |
|---|---|---|---|---|
| `title` | `content` | `none` | **Yes** | Main presentation title (rendered in large Archivo Display bold). |
| `eyebrow` | `content` | `none` | Optional | Small uppercase mono label displayed above the title. |
| `eyebrow-icon` | `string` | `none` | Optional | Name of a Lucide icon displayed adjacent to the eyebrow. |
| `subtitle` | `content` | `none` | Optional | Descriptive subtitle copy in muted text color. |
| `byline` | `array` | `()` | Optional | Array of metadata items displayed along the bottom, e.g. `([Author], [Team], [Date])`. |

### Example

```typst
#slide(
  kind: "title",
  eyebrow: [SlateDeck — Presentation Framework],
  eyebrow-icon: "terminal",
  title: [Slides That Read Like a Spec],
  subtitle: [A structured Typst template system for corporate updates and developer talks.],
  byline: ([Jordan Reyes], [Platform Engineering], [Jul 2026]),
)
```

---

## 2. `section` — Chapter Divider

![Section Divider](assets/gallery/section.png)

A full-bleed slide filled with your deck's `accent` color. Used to introduce major agenda transitions and sections.

### Parameters

| Parameter | Type | Default | Required? | Description |
|---|---|---|---|---|
| `title` | `content` | `none` | **Yes** | Chapter or section headline (rendered in high-contrast on-accent text). |
| `label` | `content` | `none` | Optional | Upper-left kicker label, e.g. `[Section 02]`. |
| `blurb` | `content` | `none` | Optional | Short paragraph describing the section's objectives. |
| `progress` | `content` | `none` | Optional | Monospace slide marker, e.g. `[02 / 10]`. |

### Example

```typst
#slide(
  kind: "section",
  label: [Section 02],
  title: [Architecture & Rollout Plan],
  blurb: [Detailed migration phases, data layer isolation, and risk mitigation strategies.],
  progress: [02 / 10],
)
```

---

## 3. `content` — General Purpose (Default)

![Content Slide](assets/gallery/content.png)

The primary workhorse slide layout. Provides a standardized kicker and headline header, leaving the remaining canvas available for any combination of components, grids, bullet lists, or raw Typst markup.

### Parameters

| Parameter | Type | Default | Required? | Description |
|---|---|---|---|---|
| `body` | `content` | `[]` | **Yes** | Positional content block passed inside `[ ... ]`. |
| `kicker` | `content` | `none` | Optional | Uppercase mono label above the headline in accent color. |
| `title` | `content` | `none` | Optional | Primary slide headline (Archivo 34pt bold). |
| `progress` | `content` | `none` | Optional | Bottom-right progress marker. |

### Example

```typst
#slide(
  kicker: [Design Principles],
  title: [Three core improvements in the new pipeline],
  progress: [03 / 10],
)[
  #numbered-grid((
    ([Predictable Layouts], [No hand-crafted coordinate offsets or brittle CSS boxes.]),
    ([Integrated Code Blocks], [Syntax highlighting and line numbers rendered natively.]),
    ([Instant Rebranding], [Derive the entire color scheme from a single hue degree.]),
  ), columns: 3)
]
```

---

## 4. `compare` — Feature & Option Comparison

![Compare Slide](assets/gallery/mongodb-compare.png)

A structured two-column comparison layout. Each column is rendered as a clean bordered card. Setting `recommended: true` on either card applies an accent border and soft accent fill to emphasize the preferred option.

### Parameters

| Parameter | Type | Default | Required? | Description |
|---|---|---|---|---|
| `left` | `dictionary` | `none` | **Yes** | Left card definition: `(label:, title:, items:, recommended:)`. |
| `right` | `dictionary` | `none` | **Yes** | Right card definition: `(label:, title:, items:, recommended:)`. |
| `kicker` | `content` | `none` | Optional | Uppercase mono kicker label. |
| `title` | `content` | `none` | Optional | Slide headline. |
| `progress` | `content` | `none` | Optional | Bottom-right progress marker. |

### Card Dictionary Fields
- `label`: Small uppercase card header (e.g. `[Option A]`).
- `title`: Main card title (e.g. `[Self-Hosted Solution]`).
- `items`: Array of content items rendered as bulletless feature lines.
- `recommended`: Boolean (`true` / `false`). Toggles accent highlight styling.

### Example

```typst
#slide(
  kind: "compare",
  kicker: [Architecture Evaluation],
  title: [Tradeoff Analysis: REST vs Event Streams],
  left: (
    label: [Synchronous REST],
    title: [Direct HTTP Endpoints],
    items: (
      [Simple request-response semantics],
      [Point-to-point coupling between services],
      [Cascading latency under downstream load],
    ),
  ),
  right: (
    label: [Event-Driven (Recommended)],
    title: [Kafka Event Streaming],
    items: (
      [Fully asynchronous and decoupled processing],
      [Buffer spikes with durable message logs],
      [Enables real-time analytics subscribers],
    ),
    recommended: true,
  ),
  progress: [04 / 10],
)
```

---

## 5. `stat` — Key Metric Hero

![Stat Slide](assets/gallery/stat.png)

A high-contrast, dark navy slide featuring an oversized hero number (170pt display font) paired with a bold caption and optional explanatory footnote.

### Parameters

| Parameter | Type | Default | Required? | Description |
|---|---|---|---|---|
| `value` | `content` | `none` | **Yes** | Large metric value or key stat (e.g. `[6x]`, `[99.9%]`, `[45ms]`). |
| `caption` | `content` | `none` | **Yes** | Bold description rendered directly adjacent to the number. |
| `kicker` | `content` | `none` | Optional | Accent-tinted mono kicker at the top. |
| `note` | `content` | `none` | Optional | Footnote or source citation anchored at the bottom-left. |
| `progress` | `content` | `none` | Optional | Bottom-right progress marker. |

### Example

```typst
#slide(
  kind: "stat",
  kicker: [Performance Benchmark],
  value: [10x],
  caption: [Faster query execution after columnar indexing],
  note: [Measured across 50M records on standard cloud instances.],
  progress: [05 / 10],
)
```

---

## 6. `code` — Syntax-Highlighted Code Showcase

![Code Slide](assets/gallery/mongodb-code.png)

A dedicated slide for presenting syntax-highlighted source code with line numbers, custom language tagging, and accent line highlights.

### Parameters

| Parameter | Type | Default | Required? | Description |
|---|---|---|---|---|
| `code` | `string` or `raw` | `none` | **Yes** | Source code text or raw block ` ```lang ... ``` `. |
| `title` | `content` | `none` | Optional | Slide headline. |
| `kicker` | `content` | `none` | Optional | Top mono label. |
| `kicker-icon` | `string` | `none` | Optional | Lucide icon name for kicker (e.g. `"terminal"`, `"code"`). |
| `lang` | `string` | `none` | Optional | Language identifier for syntax highlighting (e.g. `"js"`, `"rust"`, `"python"`, `"typ"`). |
| `theme` | `string` | `"dark"` | Optional | Code block color scheme: `"dark"` (navy backdrop) or `"light"` (paper backdrop). |
| `highlight` | `array` | `()` | Optional | Array of line numbers or inclusive ranges to highlight, e.g. `(3, (5, 7))`. |
| `progress` | `content` | `none` | Optional | Bottom-right progress marker. |

### Example

```typst
#slide(
  kind: "code",
  kicker: [Data Pipeline],
  kicker-icon: "database",
  title: [Aggregation Pipeline: Filter & Transform],
  lang: "js",
  highlight: (2, (4, 6)),
  code: ```js
  db.orders.aggregate([
    { $match: { status: "completed", year: 2026 } },
    { $group: {
        _id: "$region",
        totalRevenue: { $sum: "$amount" },
        orderCount: { $count: {} }
    }},
    { $sort: { totalRevenue: -1 } }
  ])
  ```,
  progress: [06 / 10],
)
```

---

## 7. `diagram` — System Architecture Canvas

![Diagram Slide](assets/gallery/diagram.png)

A full-canvas architectural diagram slide. Renders box nodes, database tables, and connecting arrows on an explicit column-row grid with automatic elbow connector routing.

For complete details on grid math, node properties, and connector routing, see the [**Diagrams Guide**](diagram.md).

### Parameters

| Parameter | Type | Default | Required? | Description |
|---|---|---|---|---|
| `nodes` | `array` | `()` | **Yes** | Array of node definition dictionaries. |
| `edges` | `array` | `()` | Optional | Array of edge connector dictionaries. |
| `title` | `content` | `none` | Optional | Slide headline. |
| `kicker` | `content` | `none` | Optional | Top mono label. |
| `kicker-icon` | `string` | `none` | Optional | Icon name for the kicker. |
| `cols` | `int` | `3` | Optional | Number of horizontal grid columns. |
| `rows` | `int` | `2` | Optional | Number of vertical grid rows. |
| `theme` | `string` | `"dark"` | Optional | Diagram color scheme: `"dark"` or `"light"`. |
| `cell` | `dictionary` | `(width: 150pt, height: 80pt)` | Optional | Dimensions of each grid cell. |
| `gutter` | `dictionary` | `(x: 56pt, y: 34pt)` | Optional | Horizontal and vertical gaps between cells. |
| `progress` | `content` | `none` | Optional | Bottom-right progress marker. |

### Example

```typst
#slide(
  kind: "diagram",
  kicker: [Infrastructure Topology],
  kicker-icon: "network",
  title: [Edge to Storage Request Flow],
  cols: 3,
  rows: 2,
  theme: "dark",
  nodes: (
    (id: "edge", pos: (col: 0, row: 0), icon: "globe", label: [CloudFront CDN]),
    (id: "gw",   pos: (col: 1, row: 0), icon: "server", label: [API Gateway]),
    (id: "auth", pos: (col: 1, row: 1), icon: "shield", label: [Auth Service]),
    (id: "db",   pos: (col: 2, row: 0), icon: "database", label: [Aurora DB], accent: true),
  ),
  edges: (
    (from: "edge", to: "gw"),
    (from: "gw",   to: "auth", label: [verify]),
    (from: "gw",   to: "db",   label: [query]),
  ),
  progress: [07 / 10],
)
```

---

## 8. `quote` — Pull-Quote & Testimonial

![Quote Slide](assets/gallery/quote.png)

A centered pull-quote layout featuring an accent bar, large display quote text (32pt), and an author avatar badge with role attribution.

### Parameters

| Parameter | Type | Default | Required? | Description |
|---|---|---|---|---|
| `quote` | `content` | `none` | **Yes** | Main quote text block. |
| `name` | `content` | `none` | **Yes** | Attribution name. |
| `role` | `content` | `none` | Optional | Attribution title, company, or team role. |
| `progress` | `content` | `none` | Optional | Bottom-right progress marker. |

### Example

```typst
#slide(
  kind: "quote",
  quote: [Standardizing on a declarative slide format eliminated three days of manual deck touchups before every board meeting.],
  name: [Sarah Chen],
  role: [VP of Engineering, Enterprise Core],
  progress: [08 / 10],
)
```

---

## 9. `team` — Multi-Column Roster

![Team Slide](assets/gallery/team.png)

An N-column grid of team member cards, each featuring a photo placeholder block, prominent name, and role title.

### Parameters

| Parameter | Type | Default | Required? | Description |
|---|---|---|---|---|
| `members` | `array` | `()` | **Yes** | Array of member dictionaries: `((name: [...], role: [...]), ...)`. |
| `kicker` | `content` | `none` | Optional | Top mono kicker label. |
| `title` | `content` | `none` | Optional | Slide headline. |
| `columns` | `int` | `4` | Optional | Number of horizontal team card columns (default `4`). |
| `progress` | `content` | `none` | Optional | Bottom-right progress marker. |

### Example

```typst
#slide(
  kind: "team",
  kicker: [Core Contributors],
  title: [Project Leadership & Working Group],
  columns: 4,
  members: (
    (name: [Elena Rostova], role: [Tech Lead / Distributed Systems]),
    (name: [Marcus Vance],  role: [Staff SRE / Kubernetes Infra]),
    (name: [Priya Patel],   role: [Principal Security Architect]),
    (name: [David Kim],     role: [Senior Product Designer]),
  ),
  progress: [09 / 10],
)
```

---

## 10. `image` — Full-Bleed Media & Screenshot

![Image Slide](assets/gallery/image.png)

A full-bleed slide layout for high-resolution graphics, product UI screenshots, or architectural diagrams. Includes a navy caption bar pinned to the bottom-left corner.

### Parameters

| Parameter | Type | Default | Required? | Description |
|---|---|---|---|---|
| `image` | `content` | `none` | **Yes** | Any Typst image or box content (e.g. `image("photo.jpg", fit: "cover")`). |
| `caption-title` | `content` | `none` | Optional | Bold title within the bottom-left overlay bar. |
| `caption-body` | `content` | `none` | Optional | Secondary explanatory text within the overlay bar. |
| `progress` | `content` | `none` | Optional | Bottom-right progress marker. |

### Example

```typst
#slide(
  kind: "image",
  image: image("assets/dashboard.png", width: 100%, height: 100%, fit: "cover"),
  caption-title: [Real-Time Telemetry Dashboard],
  caption-body: [Monitoring live ingest latency across all regional clusters.],
  progress: [10 / 11],
)
```

---

## 11. `closing` — Outro & Contact

![Closing Slide](assets/gallery/closing.png)

A matching outro slide on full accent background. Perfect for thank-you messages, repository links, contact info, and concluding Q&A.

### Parameters

| Parameter | Type | Default | Required? | Description |
|---|---|---|---|---|
| `title` | `content` | `none` | **Yes** | Large concluding display headline. |
| `subtitle` | `content` | `none` | Optional | Supporting farewell or discussion prompt. |
| `footer` | `content` | `none` | Optional | Monospace link / contact footer anchored in the bottom-left. |

### Example

```typst
#slide(
  kind: "closing",
  title: [Thank You],
  subtitle: [Resources, benchmarks, and RFC specifications are available on the internal portal.],
  footer: [github.com/platform/roadmap · #engineering-talks],
)
```
