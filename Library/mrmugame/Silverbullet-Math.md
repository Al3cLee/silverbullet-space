---
name: Library/mrmugame/Silverbullet-Math
tags: meta/library
files:
  - Silverbullet-Math/katex.mjs
  - Silverbullet-Math/katex.min.css
  - Silverbullet-Math/fonts/KaTeX_Typewriter-Regular.woff2
  - Silverbullet-Math/fonts/KaTeX_Size4-Regular.woff2
  - Silverbullet-Math/fonts/KaTeX_Size3-Regular.woff2
  - Silverbullet-Math/fonts/KaTeX_Size2-Regular.woff2
  - Silverbullet-Math/fonts/KaTeX_Size1-Regular.woff2
  - Silverbullet-Math/fonts/KaTeX_Script-Regular.woff2
  - Silverbullet-Math/fonts/KaTeX_SansSerif-Regular.woff2
  - Silverbullet-Math/fonts/KaTeX_SansSerif-Italic.woff2
  - Silverbullet-Math/fonts/KaTeX_SansSerif-Bold.woff2
  - Silverbullet-Math/fonts/KaTeX_Math-Italic.woff2
  - Silverbullet-Math/fonts/KaTeX_Math-BoldItalic.woff2
  - Silverbullet-Math/fonts/KaTeX_Main-Regular.woff2
  - Silverbullet-Math/fonts/KaTeX_Main-Italic.woff2
  - Silverbullet-Math/fonts/KaTeX_Main-Bold.woff2
  - Silverbullet-Math/fonts/KaTeX_Main-BoldItalic.woff2
  - Silverbullet-Math/fonts/KaTeX_Fraktur-Regular.woff2
  - Silverbullet-Math/fonts/KaTeX_Fraktur-Bold.woff2
  - Silverbullet-Math/fonts/KaTeX_Caligraphic-Regular.woff2
  - Silverbullet-Math/fonts/KaTeX_Caligraphic-Bold.woff2
  - Silverbullet-Math/fonts/KaTeX_AMS-Regular.woff2
---

# Silverbullet Math
This library implements the `$ ... $` and the `$$ ... $$` syntax using the `syntax` API, which can be used to render inline and block level math respectively.
Both use $\href{https://katex.org/}{\KaTeX}$ under the hood.

## Examples
Let $S$ be a set and $\circ : S \times S \to S,\; (a, b) \mapsto a \cdot b$ be a binary operation, then the pair $(S, \circ)$ is called a *group* iff

1. $\forall a, b \in S, \; a \circ b \in S$ (completeness),
2. $\forall a,b,c \in S, \; (ab)c = a(bc)$ (associativity),
3. $\exists e \in S$ such that $\forall a \in S,\; ae=a=ea$ (identity) and
4. $\forall a \in S,\; \exists b \in S$ such that $ab=e=ba$ (inverse).

The Fourier transform of a complex-valued (Lebesgue) integrable function $f(x)$ on the real line, is the complex valued function $\hat {f}(\xi )$, defined by the integral

$$
\widehat{f}(\xi) = \int_{-\infty}^{\infty} f(x)\ e^{-i 2\pi \xi x}\,dx, \quad \forall \xi \in \mathbb{R}.
$$
## Info
The current $\KaTeX$ version is ${latex.katex.version}.

## Syntax
```space-lua
syntax.define {
  name = "LatexInline",
  startMarker = "\\$(?!\\{)",
  endMarker = "\\$(?!\\{)",
  mode = "inline",
  startMarkerClass = "sb-latex-mark",
  bodyClass = "sb-latex-body",
  endMarkerClass = "sb-latex-mark",
  render = function(body)
    return latex.inline(body)
  end
}

syntax.define {
  name = "LatexBlock",
  startMarker = "^\\$\\$$",
  endMarker = "^\\$\\$$",
  mode = "block",
  render = function(body)
    return latex.block(body)
  end
}
```

## Implementation
```space-lua
local location = "Library/mrmugame/Silverbullet-Math"

-- Inject the KaTeX stylesheet once into the document <head>.
-- Previously this was done by embedding a <link> tag inside every widget's
-- HTML string. That caused a per-render network round-trip (cache validation)
-- every time CodeMirror's virtual viewport destroyed and recreated a widget
-- on scroll, producing a visible flash of unstyled math — more noticeable on
-- slow connections. Injecting it once here means the browser loads the CSS
-- exactly once and it persists for the lifetime of the page.
-- The data-katex-css sentinel attribute prevents double-injection if this
-- space-lua block is evaluated more than once (e.g. after a reload).
if not js.window.document.querySelector("link[data-katex-css]") then
  local link = js.window.document.createElement("link")
  link.rel = "stylesheet"
  link.href = string.format(".fs/%s/katex.min.css", location)
  link.setAttribute("data-katex-css", "true")
  js.window.document.head.appendChild(link)
end

latex = {
  -- js.import resolves the ES module once at space-lua initialisation time.
  -- The resolved module object is stored here and reused for every render call,
  -- so there is no repeated module fetch or promise re-await on scroll.
  katex = js.import(string.format("%s.fs/%s/katex.mjs", system.getURLPrefix(), location))
}

function latex.inline(expression)
  -- Render inline math (displayMode = false keeps the formula on the same
  -- baseline as surrounding text).
  local html = latex.katex.renderToString(expression, {
    trust = true,
    throwOnError = false,
    displayMode = false
  })

  -- No <link> tag here: the stylesheet is already in <head>.
  return widget.new {
    display = "inline",
    html = "<span>" .. html .. "</span>"
  }
end

function latex.block(expression)
  -- Render display math (displayMode = true centres the formula on its own
  -- line with larger delimiters).
  local html = latex.katex.renderToString(expression, {
    trust = true,
    throwOnError = false,
    displayMode = true
  })

  -- No <link> tag here: the stylesheet is already in <head>.
  return widget.new {
    display = "block",
    html = "<span>" .. html .. "</span>"
  }
end
```

```space-style
.sb-lua-directive-inline:has(.katex-html) {
  border: none !important;
}
```
