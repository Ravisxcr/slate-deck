#import "theme.typ": *

// Call once at the top of a deck via `#show: deck.with(..)`. Builds the theme from an accent
// color (RGB / hex string) and optional global theme ("light", "dark", "navy", "charcoal", "slate", "black"),
// stores it for every component to read, and sets deck-wide text defaults.
// Does not itself emit a page -- `slide()` (src/slide.typ) creates one page per slide via the `page()`
// function so each slide can carry its own background/margins.
#let deck(
  title: none,
  author: none,
  accent: rgb("#4e61d8"),
  theme: "light",
  progress: false,
  body,
) = {
  let built = make-theme(accent: accent, theme: theme)
  set document(title: title) if title != none
  set document(author: author) if author != none
  set page(width: page-size.width, height: page-size.height, margin: 0pt)
  set text(font: fonts.body, size: type-scale.body)
  // Vertical rhythm between blocks/paragraphs is controlled explicitly with v() throughout the
  // component set, so the implicit par/block spacing (default 1.2em) is zeroed here -- otherwise
  // it stacks with the explicit v() calls and slides silently overflow onto an extra page.
  set par(leading: 0.62em, spacing: 0pt)
  set block(spacing: 0pt)
  typeset-theme.update(built)
  typeset-progress.update(progress)
  body
}
