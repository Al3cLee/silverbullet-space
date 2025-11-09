#import "@preview/ctheorems:1.1.3": *
#show: thmrules
#let result = thmbox(
        "theorem",
              "Result",
              base_level:1,
              separator:[*.* ],
              fill: rgb("#eeecec"))
#import "@preview/physica:0.9.5": *
#set page(paper: "a4", numbering: "1")
#set heading(numbering: "1.1. ")
// #set text(font: "New Computer Modern")
#set par(leading: 0.5em, spacing: 1em, first-line-indent: 2em, justify: true)
#show raw: set text(font: "Fira Code")

#show heading: set block(above: 1em, below: 1em)
#show link: set text(fill: maroon)
#show ref: set text(fill: maroon)
#show raw.where(block: true): block.with(
  fill: rgb("#f5f5f5"),     // Light gray background
  inset: 1em,               // Padding inside
  width: 100%,              // Full width
  radius: 0pt               // No rounded corners
)

#show heading.where(level: 1): it => {
  counter(math.equation).update(0)
  it
}
#set math.equation(numbering: (..nums) => {
  let section = counter(heading).get().first()
  numbering("(1.1)", section, ..nums)
})


#show figure: it => {
  if it.kind in ("theorem", "definition", "postulate", "axiom") {
    block(it)
  } else {
    it
  }
}



// begin-document


#set document(title: [A Brief Introduction to Typst], date: auto)
#show title: it => {align(center,it)}
#title()

#align(center)[
#datetime.today().display("[month repr:short] [day padding:none], [year]")
]
#block(height: 0.5em)

// #outline()

Typst is an open-source markup format. It has a free web app that charges for some Pro features such as git integration and Zotero connection, but its compiler, CLI and VS Code extension are all free.

This is a brief introduction to Typst and its ecosystem (the "Typst Universe"), from the perspective of someone already familiar with Markdown and LaTeX.

= Why another markup format?

Typst is a markup language _integrated with scripting_. This allows the user to easily write scripts that are tailored to their specific needs, so that they depend less on heavy, external packages.

This gives rise to another advantage of Typst: lightweight. Built with Rust, its #link("https://github.com/typst/typst/releases/tag/v0.13.1")[binaries] are typically less than `20MB` in size, and it compiles to `PDF` blazingly fast (try the web app #link("https://typst.app") and see for yourself). A full-fledged technical paper is compiled and previewed in real time like a plain markdown file.


= Markup in Typst

The markup syntax of Typst inherits neither LaTeX nor Markdown. 
The #link("https://typst.app/docs/tutorial/writing-in-typst/")[official tutorial about basic markup] explains it in detail. Instead of `#`, Typst uses `=` to indicate sections, because the latter is reserved for "functions": 

```typst
#<some-function>(<arguments>)
```

For example, figures are placed in the document by #link("https://typst.app/docs/reference/model/figure/")[the `figure` function]. 
Functions, rather than the markup syntax, is what makes Typst special.

== Math

The math syntax of Typst, however, deserves an explicit mention. 
It removes much of the clutter in the usual LaTeX math syntax _out of the box_, including the backward dash `\` before symbols, the `\left`, `\right` declarations before brackets in order for them to stretch. The fraction syntax is especially elegant: for simple fractions where both the nominator and the denominator have only one term, a simple forward slash `/` suffices to make a fraction. But if you actually want the forward slash for, e.g. in-line math, you can either escape this character: `a\/b` $mapsto a \/ b$ or, more elegantly, use the built-in symbol `slash`: `a slash b` $mapsto a slash b$. For example, the following Typst code

```typst
$ sum_(n=1)^(infinity) alpha^n / n! = "e"^(alpha) $
```
produces the formula

$ sum_(n=0)^(infinity) alpha^n / n! = "e"^(alpha). $

When formulas get long, these little differences accumulate and dramatically improve the user's editing experience.

Also, rather than separately defined "in-line" and "display" math environments, not to mention "equation", "align" and friends, Typst has a unified environment for math, which is the single dollar sign. Put spaces around your formula to make it "display". Add line breaks (`\` instead of `\\`) and alignment symbols (still the `&` symbol) for multi-line math. All with single dollar signs.

== Reference

The label-reference syntax in Typst is  `<label>` and `@<label>[<supplement>]`,  
where the `@...` syntax is shorthand for the #link("https://typst.app/docs/reference/model/ref/")[`ref` function]. Typst automatically finds the #link("https://typst.app/docs/reference/model/figure/#parameters-kind")[`kind`] of the referenced element and attaches the appropriate text prefix, i.e. it produces "Equation (3.1)" instead of the bare number "3.1" when you reference equation 3.1. As a special case, passing an empty `supplement` gives back the bare number.

= Scripting in Typst

Examples of Typst scripts are collected here. I don't yet have the ability to do a top-down explanation on this, but Typst's scripting language is quite intuitive. Anyone with a bit of Python fluency should be able to learn it quickly: `value`s have #link("https://typst.app/docs/reference/scripting/#fields")[`fields`] and #link("https://typst.app/docs/reference/scripting/#methods")[`methods`], just like Python objects.
There are three different "modes" in Typst: text, math, and code. See #link("https://typst.app/docs/reference/syntax/","the documentation") for detail.

The two most important scripting keywords of Typst are
#link("https://typst.app/docs/reference/styling/#set-rules")[`set`] and
#link("https://typst.app/docs/reference/styling/#show-rules")[`show`].
The `set` keyword sets the
default values for some of the parameters of a function for all future uses of that function, while 
the `show` keyword redefines a function that is already defined.
In Typst, all styling elements (headings, code blocks, formulas, etc) are functions, so whenever you
tweak the styling, you are effectively redefining a function or setting its arguments.

== Formatting and dates 

The title of this document is typeset via 

```typst
#set document(title: [A Brief Introduction to Typst])
#show title: it => {align(center,it)}
// We see explicitly the re-defining of the function `title` here.
// The symbol => is an automatic concatenation of = and >.
#title()

#align(center)[
#datetime.today().display("[month repr:short] [day padding:none], [year]")
]
// Here, the second argument of `align`
// is given in a Typst idiom: contents in square brackets
// are automatically recognized as the `body` argument.
#block(height: 0.5em)
```

== Custom lists

To customize a numbered list environment, in LaTeX one needs the `enumitem` package. But in Typst it's very simple: to make a list numbered with "_Step n_", we write

```typst
#enum(numbering: n => emph[Step #n.], 
[#lorem(50)], 
// Fifty placeholder words; `#lorem` is the dummy text function
[another point]
)
```

which produces:

#enum(numbering: n => emph[Step #n.], 
[#lorem(50)],
[another point]
)

Further, we can wrap this in a function,

#let steps(..args) = {
  enum(
    numbering: n => emph[Step #n.],
    ..args
  )
}
```typst
#let steps(..args) = {
// The `..args` is a "sink" for an array of
// arguments you don't know how many there are.
  enum(
    numbering: n => emph[Step #n.],
    ..args
  )
}
// and call it like this:
// #steps([#lorem(50)],[another point])
```
so that it can be re-used throughout the document.
== Equation numbering

Equation numbering in this document is automatic. Consider the following equations.

#math.equation(block: true,numbering: none)[$ "First equation:" x=1 $]

$ "Second equation:" x^2=1 $ <another-label> 

The first equation is not numbered while the second is numbered and
inherits the section number "3". This inheritance is implemented as follows:

```typst
#show heading.where(level: 1): it => {
  counter(math.equation).update(0)
  it
}
#set math.equation(numbering: (..nums) => {
  let section = counter(heading).get().first()
  numbering("(1.1)", section, ..nums)
})

```
and the first equation is explicitly declared to have no numbering:

```typst
#math.equation(block: true, numbering: none)[$ "First equation:" x=1 $]
```
== Boxes and theorems

I like to put important parts of text into boxes, like the following one:

#result[Something _really_ important...]

This is easily realized with the #link("https://typst.app/universe/package/ctheorems","ctheorems package") and the following code.
```typst
#import "@preview/ctheorems:1.1.3": *
#show: thmrules
#let result = thmbox(
                     "theorem", // counter name
                     "Result", // head display name
                     base_level:1, // inherit level from heading
                     separator:[*.* ], // separator between head and body
                     fill: rgb("#eeecec")
                    )
```
