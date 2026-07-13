#import "../theme.typ": typeset-theme
#import "/assets/icons/brand/colors.typ": brand-colors

// Line icons (curated Lucide subset, assets/icons/line/*.svg) ship with stroke="currentColor" --
// icon() swaps that token for the resolved fill color. Brand marks (assets/icons/brand/*.svg,
// from simple-icons) ship with no fill at all (defaults to black), so they get an explicit
// `fill="#hex"` injected on the <svg> root instead, using the brand-colors lookup table.
#let icon(name, size: 1em, color: none, brand: false, baseline: 15%) = context {
  let dir = if brand { "brand" } else { "line" }
  let path = "/assets/icons/" + dir + "/" + name + ".svg"
  let svg = read(path)
  let colored = if brand {
    let hex = brand-colors.at(name, default: rgb("#000000")).to-hex()
    svg.replace("<svg ", "<svg fill=\"" + hex + "\" ")
  } else {
    let fill = if color != none { color } else { typeset-theme.get().accent }
    svg.replace("currentColor", fill.to-hex())
  }
  box(
    width: size,
    height: size,
    baseline: baseline,
    image(bytes(colored), format: "svg", width: size, height: size),
  )
}
