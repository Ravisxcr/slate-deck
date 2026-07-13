# typeset docs

Reference documentation for the `typeset` Typst package (`src/`). This is the API/architecture
reference; for a quick pitch and the visual gallery see the
[repo README](https://github.com/Ravisxcr/slate-deck#readme).

| page | covers |
|---|---|
| [getting-started.md](getting-started.md) | Install, compile, first deck, project layout |
| [design-tokens.md](design-tokens.md) | Color, typography, spacing, the 1920×1080→960×540 coordinate system |
| [slides.md](slides.md) | `slide(kind: "...")` — every slide kind and its parameters |
| [components.md](components.md) | Standalone components (`icon`, `kicker`, `cols`, cards, `code-block`, `er-table`, ...) |
| [diagram.md](diagram.md) | `diagram()` — node/edge placement, anchors, and the elbow-routing algorithm |
| [icons-and-fonts.md](icons-and-fonts.md) | Icon families, adding new icons, vendored fonts |

## Gallery

Every image below is a real render (`typst compile`) of a full example deck in `examples/` — no
design tool, no manual touch-up. `examples/mongodb.typ` is a ~10-slide technical talk built end
to end on the public API; `examples/showcase.typ` demonstrates components reused outside their
default slide kind and a live mid-deck rebrand. The per-kind reference gallery (every slide kind
in isolation, including `image`/`quote`/`team`) is in [slides.md](slides.md).

| | |
|---|---|
| ![Title slide, MongoDB deep dive deck](assets/gallery/mongodb-title.png) | ![Section divider, MongoDB deck](assets/gallery/mongodb-section.png) |
| **`title`** — cover slide, accent bar, kicker, byline | **`section`** — full-accent divider between deck sections |
| ![Content slide with two-column body and a syntax-highlighted code block](assets/gallery/mongodb-content.png) | ![Compare slide with a recommended option highlighted](assets/gallery/mongodb-compare.png) |
| **`content`** — free-form body; here, an icon list beside `code-block()` | **`compare`** — two-column cards, recommended option highlighted |
| ![Dark code slide with a syntax-highlighted MongoDB aggregation pipeline](assets/gallery/mongodb-code.png) | ![Stat slide with a large 17 hero number](assets/gallery/mongodb-stat.png) |
| **`code`** — line-numbered, syntax-colored code block | **`stat`** — navy background, oversized hero number |
| ![Grid of sixteen full-color brand-mark icons](assets/gallery/showcase-brand-icons.png) | ![Three compare-card components reused outside the compare slide kind](assets/gallery/showcase-compare-reuse.png) |
| **`icon(brand: true)`** — full-color marks, any Lucide-shaped grid | **`compare-card()`** — a component, not just a slide kind, reused three-up |
| ![Stat slide in a different accent color, proving the one-line rebrand](assets/gallery/showcase-rebrand-stat.png) | ![Closing slide, MongoDB deck](assets/gallery/mongodb-closing.png) |
| **Live rebrand** — same `stat-hero()`, only `accent-hue` changed | **`closing`** — mirrors `title` on accent background |

## How the package fits together

```
src/lib.typ            re-exports the public API (this is what #import pulls in)
  ├─ page.typ           deck() — sets up the page, theme state, text defaults
  ├─ theme.typ           color/type/spacing tokens, make-theme(accent-hue, accent-chroma)
  ├─ slide.typ           slide(kind: "...") dispatcher — one function per slide kind
  └─ components/         building blocks slide.typ composes, also usable standalone
      ├─ icon.typ          SVG icon() — line icons + brand marks
      ├─ kicker.typ         uppercase mono label
      ├─ columns.typ        cols() / numbered-grid()
      ├─ card.typ            compare-card() / team-card()
      ├─ stat.typ             stat-hero()
      ├─ quote.typ             pull-quote()
      ├─ code.typ               code-block()
      ├─ diagram.typ             diagram() — manual node/edge placement + routing
      └─ er-table.typ             er-table() — DB schema table (used by diagram() too)
```

Everything reads its colors from a single piece of document state, `typeset-theme`
(`theme.typ`), written once by `deck()` at the top of a document. That's what makes a rebrand a
one-line change (`deck.with(accent-hue: 145deg)`) instead of a find-and-replace across every
component.

## Design philosophy (why some things are the way they are)

- **Structured parameters, not markup parsing.** `slide()` takes named parameters
  (`title:`, `kicker:`, ...), not a content block it introspects for headings. Typst has no
  stable public API for querying node types inside a passed-in content tree, so parsing
  `[= Headline\nSubtitle]` back into a title/subtitle pair would be fragile. See
  [slides.md](slides.md).
- **No auto-layout in `diagram()`.** Nodes are placed on an explicit `(col:, row:)` grid; there's
  no graph solver. Edges get a small bounded search to route around *other* nodes, but this is a
  handful of deterministic alternate routes, not pathfinding. See [diagram.md](diagram.md).
- **Every component reads theme, none hardcode color.** If you're adding a component and reach
  for a literal `oklch(...)` or hex value, that's almost always wrong — pull the token from
  `typeset-theme.get()` instead (see [design-tokens.md](design-tokens.md)).
- **Explicit vertical rhythm.** `deck()` zeros Typst's default paragraph/block spacing
  (`set par(spacing: 0pt)`, `set block(spacing: 0pt)`); every component spaces itself with
  explicit `v()` calls. Skipping this in a new component causes silent overflow onto a phantom
  extra page rather than a compile error — see the "Gotchas" note in
  [getting-started.md](getting-started.md#gotchas).
