# Design Tokens & Theming

SlateDeck is built on a mathematical design system engineered specifically for 16:9 widescreen presentation displays (960pt × 540pt).

Every color, font weight, type size, and vertical margin is declared as a reusable **design token**, ensuring consistent visual hierarchy across your entire slide deck.

---

## 1. The One-Line Rebrand System

Instead of editing dozens of hex colors across individual slides, SlateDeck generates its entire palette dynamically from your chosen **accent color** (as a `color` or hex string):

```typst
#show: deck.with(
  title: "MongoDB Architecture",
  author: "Ravi",
  accent: rgb("#00ED64"), // Color or hex string "#00ED64"
  theme: "dark",          // "light", "dark" (navy), "charcoal" (black), "slate", or custom color
)
```

### Configuration Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `title` | `string` | `none` | Document title for PDF export metadata (`document.title`). |
| `author` | `string` | `none` | Author / organization for PDF metadata (`document.author`). |
| `accent` | `color` / `str` | `rgb("#4e61d8")` | Primary deck accent color. Accepts `rgb("#00ED64")` or hex string `"#00ED64"`. |
| `theme` | `string` / `color` | `"light"` | Global theme canvas: `"light"`, `"dark"` / `"navy"`, `"charcoal"` / `"black"`, `"slate"`, or custom `color`. |
| `progress` | `bool` | `false` | When `true`, enables slide progress numbers across all slides. |

### Global Themes & Dark Shades

| Theme Preset | Background | Tone / Style |
|---|---|---|
| `"light"` *(Default)* | `oklch(98.5%, 0.004, 80deg)` | Ultra-light warm canvas with dark ink typography. |
| `"dark"` / `"navy"` | `oklch(16%, 0.015, hue)` | Accent-tinted deep navy canvas for developer talks & system briefs. |
| `"charcoal"` / `"black"` | `oklch(13%, 0.004, 80deg)` | Deep neutral pitch-dark canvas (`#111318`) with high contrast. |
| `"slate"` / `"midnight"` | `oklch(18%, 0.02, 240deg)` | Modern slate dark-blue canvas (`#0f172a`). |
| Custom `color` | e.g. `rgb("#0f172a")` | Any custom background color; text contrast is auto-computed. |

### Popular Brand Color Presets

| Brand Color | Hex / RGB | Tone / Identity |
|---|---|---|
| **Indigo / Violet** *(Default)* | `rgb("#4e61d8")` | Enterprise tech, developer tools |
| **Electric Blue** | `rgb("#2563eb")` | Cloud infrastructure, security |
| **Emerald Green** | `rgb("#00ED64")` | MongoDB, data platforms, growth |
| **Teal / Cyan** | `rgb("#06b6d4")` | Analytics, developer platforms |
| **Amber / Coral** | `rgb("#f59e0b")` | Product launches, creative pitches |
| **Crimson Rose** | `rgb("#e11d48")` | Executive summaries, incident reports |

---

## 2. Color Palette Tokens

Every color in SlateDeck is calculated with guaranteed perceptual contrast ratios.

| Token | Type | Description & Role |
|---|---|---|
| `paper` | `color` | Ultra-light warm canvas background for default slides. |
| `ink` | `color` | High-contrast primary dark text on light backgrounds. |
| `ink-muted` | `color` | Secondary text, bullet body copy, and subtitles. |
| `ink-faint` | `color` | Tertiary text, footnote labels, and subtle borders. |
| `border` | `color` | Card borders and divider lines on light slides. |
| `accent` | `color` | The signature accent color — kickers, links, focus borders. |
| `accent-soft` | `color` | 5% opacity accent fill for recommended cards and pills. |
| `on-accent` | `color` | High-contrast primary light/dark text on accent backgrounds. |
| `on-accent-muted` | `color` | Secondary text on accent backgrounds (section slides). |
| `navy` | `color` | Rich dark backdrop for `stat`, `code`, and dark diagrams. |
| `on-navy` | `color` | Primary light text on dark navy backgrounds. |
| `on-navy-muted` | `color` | Secondary muted text on dark navy backgrounds. |
| `on-navy-accent` | `color` | Readable accent-tinted kicker text on navy backdrops. |

### Accessing Color Tokens in Custom Markup

If you are authoring a custom element and wish to use the active theme's colors:

```typst
#import "@local/slatedeck:0.1.0": typeset-theme

#context {
  let theme = typeset-theme.get()
  rect(
    fill: theme.accent-soft,
    stroke: 1.5pt + theme.accent,
    radius: 4pt,
    inset: 12pt,
    text(fill: theme.ink)[Custom themed container]
  )
}
```

---

## 3. Typography System

SlateDeck uses three open-source font families, each tailored for a specific presentation role:

| Family | Static Weights | Role & Usage |
|---|---|---|
| **Archivo** | 500, 600, 700, 800 | **Display**: Cover titles, section headers, big-stat numbers, and headlines. |
| **IBM Plex Sans** | 400, 500, 600 | **Body**: Paragraphs, bullet descriptions, card text, and captions. |
| **IBM Plex Mono** | 400, 500, 600 | **Monospace**: Category kickers, slide progress numbers, and code blocks. |

### Type Scale (`type-scale`)

| Token | Size | Primary Usage |
|---|---|---|
| `eyebrow` | `10pt` | Cover slide eyebrow kicker. |
| `kicker` | `11pt` | Standard slide category label. |
| `body` | `11pt` | Primary body text and bullet descriptions. |
| `code` | `13pt` | Code block syntax text. |
| `body-lg` | `14pt` | Subtitle text on title and section slides. |
| `number` | `20pt` | Numbered grid indices and bottom-right slide progress. |
| `quote` | `32pt` | Large pull-quote text. |
| `h2` | `34pt` | Standard content slide headline. |
| `display-sm`| `56pt` | Section divider and closing slide titles. |
| `display` | `66pt` | Main cover title on `title` slides. |
| `stat` | `170pt` | Oversized metric numbers on `stat` slides. |

---

## 4. Spacing Scale (`spacing`)

A proportional t-shirt spacing scale ensures consistent rhythm and eliminates arbitrary pixel offsets:

| Token | Value | Typical Usage |
|---|---|---|
| `spacing.xs` | `8pt` | Tight inline icon-to-text spacing. |
| `spacing.sm` | `14pt` | Space between kicker label and headline title. |
| `spacing.md` | `20pt` | Gap between icons and card text. |
| `spacing.lg` | `34pt` | Internal card padding and small section gaps. |
| `spacing.xl` | `56pt` | Space between headline title and body content. |
| `spacing.xxl` | `70pt` | Major vertical section breaks. |
| `spacing.page-x` | `60pt` | Standard horizontal slide margin. |
| `spacing.page-y` | `40pt` | Standard vertical slide margin. |

---

## 5. Page Dimensions & Aspect Ratio

- **Dimensions**: `960pt × 540pt` (standard 16:9 widescreen ratio, equivalent to 13.333in × 7.5in).
- **Resolution**: Fully vector-rendered — sharp at any presentation display resolution (1080p, 4K, 8K).
