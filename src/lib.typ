#import "page.typ": deck
#import "slide.typ": slide
#import "components/icon.typ": icon
#import "components/kicker.typ": kicker
#import "components/columns.typ": cols, numbered-grid
#import "components/card.typ": compare-card, team-card, image-card, image-frame, image-grid, collage
#import "components/stat.typ": stat-hero, stat-grid
#import "components/quote.typ": pull-quote
#import "components/code.typ": code-block
#import "components/diagram.typ": diagram
#import "components/er-table.typ": er-table
#import "theme.typ": make-theme, typeset-theme, typeset-progress, spacing, type-scale, fonts

#let typeset = (
  deck: deck,
  slide: slide,
  icon: icon,
  kicker: kicker,
  cols: cols,
  numbered-grid: numbered-grid,
  compare-card: compare-card,
  team-card: team-card,
  image-card: image-card,
  image-frame: image-frame,
  image-grid: image-grid,
  collage: collage,
  stat-hero: stat-hero,
  stat-grid: stat-grid,
  pull-quote: pull-quote,
  code-block: code-block,
  diagram: diagram,
  er-table: er-table,
  make-theme: make-theme,
)
