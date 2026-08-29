# Icons and Fonts

SlateDeck bundles a comprehensive library of **1,750+ vector icons** and static weights of three open-source font families to ensure your presentations look flawless on any operating system.

---

## 1. Vector Icon System

All icons are rendered natively as vector SVGs using the `#icon(...)` component:

```typst
#icon("git-branch")                           // Line icon inheriting accent color
#icon("terminal", size: 20pt, color: red)      // Custom size and color override
#icon("react", brand: true, size: 24pt)       // Official full-color brand mark
```

### Icon Categories

SlateDeck organizes icons into two categories:

### A. Line Icons (1,750+ Lucide Icons)
- Vendored from the [Lucide](https://lucide.dev) project (ISC License).
- Any standard Lucide icon name in `kebab-case` works instantly (e.g. `"terminal"`, `"shield"`, `"database"`, `"cpu"`, `"network"`, `"layers"`, `"sparkles"`, `"search"`, `"zap"`).
- **Color inheritance**: By default, line icons automatically inherit the deck's active `accent` color. Pass `color: ...` to override.

### B. Developer Brand Marks
- Sourced from [Simple Icons](https://simpleicons.org) (CC0 License).
- Rendered in their official brand color palettes when you pass `brand: true`.
- Included developer brands:

| Brand Name | Identifier (`name:`) | Example Usage |
|---|---|---|
| **Docker** | `"docker"` | `#icon("docker", brand: true)` |
| **Kubernetes** | `"kubernetes"` | `#icon("kubernetes", brand: true)` |
| **GitHub** | `"github"` | `#icon("github", brand: true)` |
| **GitLab** | `"gitlab"` | `#icon("gitlab", brand: true)` |
| **Python** | `"python"` | `#icon("python", brand: true)` |
| **React** | `"react"` | `#icon("react", brand: true)` |
| **TypeScript** | `"typescript"` | `#icon("typescript", brand: true)` |
| **JavaScript** | `"javascript"` | `#icon("javascript", brand: true)` |
| **Go** | `"go"` | `#icon("go", brand: true)` |
| **Rust** | `"rust"` | `#icon("rust", brand: true)` |
| **Node.js** | `"nodedotjs"` | `#icon("nodedotjs", brand: true)` |
| **PostgreSQL** | `"postgresql"` | `#icon("postgresql", brand: true)` |
| **Redis** | `"redis"` | `#icon("redis", brand: true)` |
| **Google Cloud** | `"googlecloud"` | `#icon("googlecloud", brand: true)` |
| **Linux** | `"linux"` | `#icon("linux", brand: true)` |
| **GraphQL** | `"graphql"` | `#icon("graphql", brand: true)` |
| **Figma** | `"figma"` | `#icon("figma", brand: true)` |

---

## 2. Automatic Inline Baseline Alignment

When you place an icon inside a line of text, `#icon()` automatically adjusts its vertical baseline (`baseline: 15%`) so the icon aligns perfectly with adjacent typography:

```typst
#slide(title: [Deployment Complete])[
  Check out the latest release on #icon("github", brand: true) #link("https://github.com")[GitHub]
  or inspect container metrics with #icon("activity") #text(weight: 600)[Live Telemetry].
]
```

---

## 3. Adding Custom Icons

### Adding a Custom Line Icon
1. Save your SVG file with `stroke="currentColor"` in `assets/icons/line/<name>.svg`.
2. Use it directly in your deck: `#icon("<name>")`.

### Adding a Custom Brand Logo
1. Place your brand SVG in `assets/icons/brand/<name>.svg`.
2. Add its official hex color in `assets/icons/brand/colors.typ`.
3. Render it with `#icon("<name>", brand: true)`.

---

## 4. Bundled Typography & Automatic Discovery

To guarantee reproducible rendering across Windows, macOS, and Linux, SlateDeck bundles static weights of three font families:

| Font Family | Available Weights | License | Primary Purpose |
|---|---|---|---|
| **Archivo** | Medium (500), SemiBold (600), Bold (700), ExtraBold (800) | SIL OFL 1.1 | Display titles, section headers, big stats |
| **IBM Plex Sans** | Regular (400), Medium (500), SemiBold (600) | SIL OFL 1.1 | Body copy, bullet descriptions, card text |
| **IBM Plex Mono** | Regular (400), Medium (500), SemiBold (600) | SIL OFL 1.1 | Category kickers, code blocks, slide markers |

### Zero-Configuration Font Discovery

When you run `./install.ps1` (Windows) or `./install.sh` (macOS/Linux), the installer automatically registers these font files into your user font library.

You can compile or watch decks directly with zero CLI flags:
```sh
typst watch my-deck.typ my-deck.pdf
typst compile my-deck.typ my-deck.pdf
```
