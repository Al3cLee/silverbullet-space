#import "preamble_standalone.typ": *
#show: template-doc-main
// #show: bib-main-doc // Use this line if you have bibliography.

#abstract[Group conjugation can be regarded as a way to construct new transformations
  out of given ones.
  Given a group element $g in G$, conjugating it with all $h in H subset G$ produces an equivalence class,
  known as the conjugacy class $[g] = {attach(g, tl: h) : h in H}$ of $g$ under $H$.
  Given a group $G$, for each element $g in G$ we can find the conjugacy class of $g$ under $G$ itself.
  This gives a useful partition of $G$.]

#include "child.typ"
