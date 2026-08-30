# Getting Started

This guide will help you install **SlateDeck**, set up your environment, and author your first presentation in minutes.

---

## 1. Installation

SlateDeck is distributed as a self-contained Typst package with bundled fonts and icons.

Clone or download the repository, then run the installer script from the project root:

### Windows (PowerShell)
```powershell
./install.ps1
```

### macOS & Linux
```sh
chmod +x ./install.sh
./install.sh
```

### What the installer does
1. Copies the package manifest, source files, and icon assets into your local Typst packages directory:
   - **Windows**: `%LOCALAPPDATA%\typst\packages\local\slatedeck\0.1.0\`
   - **macOS**: `~/Library/Application Support/typst/packages/local/slatedeck/0.1.0/`
   - **Linux**: `~/.local/share/typst/packages/local/slatedeck/0.1.0/`
2. **Automatically installs and registers all bundled fonts** (Archivo, IBM Plex Sans, IBM Plex Mono) into your user font directory and environment.

Once installed, any `.typ` file on your machine can import SlateDeck with:
```typst
#import "@local/slatedeck:0.1.0": *
```

---

## 2. Compiling Presentations (Zero Config)

Because the installer registers the bundled fonts into your system, you can compile and watch your presentations directly **without passing any font path flags**:

### Live Preview with Watch Mode

To automatically recompile your slides whenever you save your document:
```sh
typst watch my-deck.typ my-deck.pdf
```

### Single Compile to PDF

```sh
typst compile my-deck.typ my-deck.pdf
```

### Exporting Slide Images (PNG)

To export every slide as an individual high-resolution PNG image (e.g. for web embedding, social media, or previews):
```sh
typst compile --format png my-deck.typ "slide-{p}.png"
```

!!! tip "Optional Manual `--font-path` Flag"
    If you are working on an airgapped machine or prefer not to install fonts into your user profile, you can still optionally supply `--font-path assets/fonts` during compilation.

---

## 3. Your First Presentation

Create a new file called `my-deck.typ` and paste the following boilerplate:

```typst
#import "@local/slatedeck:0.1.0": *

// Initialize the presentation system
#show: deck.with(
  title: "Engineering Architecture 2026",
  author: "Platform Engineering Team",
  accent-hue: 250deg, // Violet-blue accent
)

// Slide 1: Cover Title Slide
#slide(
  kind: "title",
  eyebrow: [Internal Tech Talk],
  eyebrow-icon: "terminal",
  title: [Scalable Systems in Practice],
  subtitle: [Design patterns for high-throughput distributed microservices.],
  byline: ([Alex Rivera], [Staff Architect], [July 2026]),
)

// Slide 2: Section Divider
#slide(
  kind: "section",
  label: [Part 01],
  title: [System Architecture Overview],
  blurb: [High-level topology and traffic flow through our edge gateway.],
  progress: [01 / 03],
)

// Slide 3: Content Slide with Numbered Cards
#slide(
  kicker: [Key Principles],
  title: [Three pillars of our architectural refactor],
  progress: [02 / 03],
)[
  #numbered-grid((
    ([Stateless Compute], [All session data is externalized to distributed caches.]),
    ([Asynchronous Events], [Decoupled workflows communicate via persistent message queues.]),
    ([Automated Failover], [Multi-region replication with sub-second health checks.]),
  ), columns: 3)
]

// Slide 4: Closing Slide
#slide(
  kind: "closing",
  title: [Thank You],
  subtitle: [Questions, discussion, and code walk.],
  footer: [github.com/company/architecture · #architecture-channel],
)
```

Start editing with live preview:
```sh
typst watch my-deck.typ my-deck.pdf
```

---

## 4. Core Concepts for Slide Authors

### 1. Global Deck Configuration (`#show: deck.with(...)`)

Always place the `#show: deck.with(...)` rule at the very top of your document. It initializes the presentation engine, sets up 16:9 widescreen dimensions (960pt × 540pt), embeds PDF metadata, zeroes unsafe default margins, and derives the complete OKLCH theme palette from your chosen accent hue.

```typst
#import "@local/slatedeck:0.1.0": *

#show: deck.with(
  title: "MongoDB Deep Dive",
  author: "Ravi",
  accent: rgb("#00ED64"), // Familiar RGB or Hex notation (e.g. "#00ED64", rgb("#6f789a"))
  // accent-hue: 140deg,  // Hue angle notation is also fully supported
)
```

#### Global Configuration Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `title` | `string` | `none` | Presentation title embedded into PDF metadata (`document.title`). |
| `author` | `string` | `none` | Author / team name embedded into PDF metadata (`document.author`). |
| `accent` | `color` / `str` / `angle` | `auto` | Primary deck accent. Accepts `rgb("#6f789a")`, hex string `"#6f789a"`, or angle `140deg`. |
| `accent-hue` | `angle` / `color` / `str` | `250deg` | Base hue angle or color generating all accent and tinted color tokens. |
| `accent-chroma` | `float` | `auto` (0.16) | Perceptual chroma / saturation intensity of the accent color in OKLCH space. |
| `progress` | `bool` | `false` | When `true`, automatically renders slide progress (e.g. `01 / 10`) on all slides across the deck. |

#### Popular Brand Hue Presets

| Accent Hue | Tone / Identity | Recommended For |
|---|---|---|
| `140deg` – `145deg` | **Forest / Emerald Green** | MongoDB, Node.js, Spring, FinTech & Growth talks |
| `215deg` | **Cloud Electric Blue** | Cloud architecture, Kubernetes, AWS/GCP/Azure |
| `250deg` | **Royal Indigo / Violet** *(Default)* | Developer platforms, systems engineering |
| `30deg` | **Warm Amber / Coral** | Product demos, design systems, consumer pitches |
| `345deg` | **Crimson Rose** | Executive updates, security incident response |

### 2. The `#slide(...)` Function
Every slide in your presentation is created with a single call to `#slide(...)`. 
- Pass `kind:` to choose one of the 11 built-in layouts (e.g. `kind: "title"`, `kind: "stat"`, `kind: "code"`, `kind: "diagram"`).
- If `kind:` is omitted, it defaults to `"content"`, which accepts a kicker, headline title, and a freeform body block `[ ... ]`.

### 3. Dynamic Mid-Deck Rebranding
In addition to the global `#show: deck.with(...)` rule, you can dynamically update the theme state at any point in your deck using `#typeset-theme.update(...)`:

```typst
#typeset-theme.update(make-theme(accent-hue: 15deg))
```

---

## 5. Presentation Authoring Tips & Best Practices

!!! note "Controlled Vertical Spacing"
    SlateDeck precisely regulates vertical rhythm using explicit spacing tokens (`spacing.xs` to `spacing.xxl`). Typst's default paragraph spacing is zeroed inside slides to prevent content from silently overflowing onto extra pages. When creating custom layouts inside `content` slides, use stack spacing (`stack(spacing: 12pt, ...)`) or explicit vertical gaps (`#v(14pt)`).

!!! tip "Using Code Blocks"
    When writing code inside slides, prefer passing raw code blocks ` ```lang ... ``` ` rather than escaped strings. This gives you native editor syntax highlighting while editing your slides.

---

## Next Steps

- Explore all slide layouts in the [**Slide Kinds Reference**](slides.md).
- Learn about cards, grids, and tables in the [**Components Reference**](components.md).
- Create system diagrams with the [**Diagrams & Architecture Guide**](diagram.md).
- Customize colors and fonts in [**Design Tokens & Theming**](design-tokens.md).
