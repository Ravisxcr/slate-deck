#let c = oklch(55%, 0.16, 250deg)
#let raw = read("/assets/icons/line/terminal.svg")
#let colored = raw.replace("currentColor", c.to-hex())
#box(width: 3cm, height: 3cm, image(bytes(colored), format: "svg"))

#let braw = read("/assets/icons/brand/react.svg")
#box(width: 3cm, height: 3cm, image(bytes(braw), format: "svg"))
