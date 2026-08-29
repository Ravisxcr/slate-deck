# Design Tokens & Theming

SlateDeck is built on a mathematical design system engineered specifically for 16:9 widescreen presentation displays (960pt × 540pt).

Every color, font weight, type size, and vertical margin is declared as a reusable **design token**, ensuring consistent visual hierarchy across your entire slide deck.

---

## 1. The One-Line Rebrand System

Instead of editing dozens of hex colors across individual slides, SlateDeck generates its entire palette dynamically from a single **accent hue angle** using the native OKLCH perceptual color space:

```typst
#show: deck.with(
  title: "Quarterly Roadmap",
  accent-hue: 250deg,   // Royal Violet / Indigo (default)
  accent-chroma: 0.16,  // Accent saturation level (default: 0.16)
)
```

### Popular Brand Hue Presets

| Accent Hue | Visual Style | Example Tone |
|---|---|---|
| `250deg` | **Royal Indigo / Violet** *(Default)* | Enterprise tech, developer tools |
| `215deg` | **Deep Electric Blue** | Cloud infrastructure, security |
| `165deg` | **Emerald Teal** | Data science, analytics, sustainability |
| `145deg` | **Forest Green** | Financial tech, growth updates |
| `30deg`  | **Warm Coral / Amber** | Consumer products, creative pitches |
| `345deg` | **Crimson Rose** | Executive summaries, marketing |

---

## 2. Color Palette Tokens

Every color in SlateDeck is calculated with guaranteed perceptual contrast ratios.

| Token | OKLCH Definition | Description & Role |
|---|---|---|
| `paper` | `oklch(98.5%, 0.004, 80deg)` | Ultra-light warm canvas background for default slides. |
| `ink` | `oklch(20%, 0.01, 80deg)` | High-contrast primary dark text on light backgrounds. |
| `ink-muted` | `oklch(45%, 0.02, 80deg)` | Secondary text, bullet body copy, and subtitles. |
| `ink-faint` | `oklch(65%, 0.01, 80deg)` | Tertiary text, footnote labels, and subtle borders. |
| `border` | `oklch(88%, 0.006, 80deg)` | Card borders and divider lines on light slides. |
| `accent` | `oklch(55%, chroma, hue)` | The signature accent color — kickers, links, focus borders. |
| `accent-soft` | `oklch(55%, chroma, hue, 5%)` | 5% opacity accent fill for recommended cards and pills. |
| `on-accent` | `oklch(98%, 0.01, hue)` | High-contrast primary light text on accent backgrounds. |
| `on-accent-muted` | `oklch(92%, 0.03, hue)` | Secondary text on accent backgrounds (section slides). |
| `navy` | `oklch(16%, 0.01, hue)` | Rich dark backdrop for `stat`, `code`, and dark diagrams. |
| `on-navy` | `oklch(98%, 0.01, hue)` | Primary light text on dark navy backgrounds. |
| `on-navy-muted` | `oklch(70%, 0.03, hue)` | Secondary muted text on dark navy backgrounds. |
| `on-navy-accent` | `oklch(65%, chroma - 0.02, hue)` | Readable accent-tinted kicker text on navy backdrops. |

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
