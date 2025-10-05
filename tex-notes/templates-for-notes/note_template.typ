#import "@preview/physica:0.9.5": *
#set page(paper: "a4", numbering: "1")
#show heading.where(level: 1): it => {
  counter(math.equation).update(0)
  it
}

// Number equations under 1st-level sections.
#set math.equation(numbering: (..nums) => {
  let section = counter(heading).get().first()
  numbering("(1.1)", section, ..nums)
})
#set heading(numbering: "1.1. ")

// Mimic LaTeX look.
// #set text(font: "New Computer Modern")
#set par(leading: 0.5em, spacing: 1em, first-line-indent: 2em, justify: true)
#show heading: set block(above: 1.2em, below: 1em)

// Color for links, disable for printing in black&white.
#show link: set text(fill: maroon)
#show ref: set text(fill: maroon)

// Gray box and font setting for code blocks.
#show raw: set text(font: "Fira Code")
#show raw.where(block: true): block.with(
  fill: rgb("#f5f5f5"),     // Light gray background
  inset: 1em,               // Padding inside
  width: 100%,              // Full width
  radius: 4pt               // Rounded corners (optional)
)

// Suppress equation numbering if not labelled.
// Add empty label to avoid recursion. Works as long as 
// you don't put `@` in your document.
// #show math.equation: it => {
//   if it.block and not it.has("label") [
//     #counter(math.equation).update(v => v - 1)
//     #math.equation(it.body, block: true, numbering: none)#label("")
//   ] else {
//     it
//   }  
// }

// Package for proclamation-like environments.
#import "@preview/theorion:0.4.0": *
#import cosmos.simple: *
#show: show-theorion
#set-inherited-levels(1)

// Noindent for proclamations.
#show figure: it => {
  if it.kind in ("theorem", "definition", "postulate", "axiom") {
    block(it)
  } else {
    it
  }
}

// Noindent script for ad hoc tweaks
#let noindent(x) = [#block[#x]]
// Define customized remark environment.
#let (remark-counter, remark-box, remark, show-remark) = make-frame(
  "remark",
  "Remark",  // The title that will appear
  counter: theorem-counter,  // or inherit from an existing counter if needed
  inherited-levels: 1,  
  inherited-from: heading,  
  render: (prefix: none, title: "", full-title: auto, body) => block[
    #strong[#full-title.]#sym.space#body
  ],
)
#show: show-remark

#let (motivation-counter, motivation-box, motivation, show-motivation) = make-frame(
  "motivation",
  "Motivation",  // The title that will appear
  counter: theorem-counter,  // or inherit from an existing counter if needed
  inherited-levels: 1,  
  inherited-from: heading,  
  render: (prefix: none, title: "", full-title: auto, body) => block[
    #strong[#full-title.]#sym.space#body
  ],
)
#show: show-motivation

// Define customized result environment, wrapped in a 
// gray box and `inset`ted to emphasize.
#let (result-counter, result-box, result, show-result) = make-frame(
  "result",
  "Result",  // The title that will appear
  counter: none,  // or inherit from an existing counter if needed
  inherited-levels: 1,  
  inherited-from: heading,  
  render: (prefix: none, title: "", full-title: auto, body) => [
    #block(
      fill: rgb("#eeecec"),  // Light grey background
      // stroke: rgb("#cccccc"), // Grey border
      radius: 0pt,           // Rounded corners
      inset: 1.2em,           // Padding inside the box
      width: 100%,           // Full width
      [#strong[#full-title.]#sym.space#body]
    )
  ],
)
#show: show-result

// Custom `graybox` environment.
#let graybox(x)= [#block(
      fill: rgb("#eeecec"),  // Light grey background
      // stroke: rgb("#cccccc"), // Grey border
      radius: 0pt,           // Rounded corners
      inset: 1.2em,           // Padding inside the box
      width: 100%,           // Full width
      [#x]
)]

#let solution(x)= [
    #graybox[*Solution.* #x]
]

// Here begins our document.

#align(center, text(20pt)[
  *Title*
])

#align(center)[
#datetime.today().display("[month repr:short] [day], [year]")
]
#block(height: 0.5em)

// #outline()

= First Section

Text starts here. Only results are numbered with 
their own counter.

// #bibliography("ref.bib")

