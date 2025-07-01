---
tags: 
- "computer-science/LaTeX"
finished: true
---

# BibLaTeX

BibLaTeX is a [[bibliography management]] LaTeX package. Using it is similar to other packages: declare `\usepackage[backend=biber]{biblatex}` in the preamble (`biber` is a command-line tool that compiles BibLaTeX related code) and do what you want in the `.tex` file, then compile. But the compilation is a bit complicated.

Before running `biblatex <file>.tex`, the `.tex` file needs to be complied by a LaTeX compiler which produces PDF, for example `xelatex <file>.tex`. Then, we should run `biber <file>`, not `biber <file>.tex`, note that the postfix is left out. Finally, running the PDF engine once or twice more will produce the desired result.

## Integration with CTeX

BibLaTeX does _not_ communicate well with the `ctex` package, for example even if your document type is `ctexart`, the bibliography section produced by the BibLaTeX command `\printbibliography` would still bear the title “References” instead of “参考文献”. This is not normal because in the `ctexart` document type, macros such as `\bibname` are in Chinese by default (see section 6.2 of the CTeX documentation).

A work-around is to assume that BibLaTeX has no knowledge of CTeX at all and manually enforce the title of the bibliography section upon printing it: `\printbibliography[title=参考文献]`. See section 3.8.2 of the BibLaTeX documentation for details, and note that `heading` and `title` are different.
