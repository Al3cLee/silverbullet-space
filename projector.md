---
tags: 
- "math/algebra"
latex-note: true
finished: true
---

# Projector

1. A projector is an operator that preserves a subspace and kills everything else, i.e. maps everything else to the null vector.
2. There is a 1-to-1 correspondence between a subspace and the projector that preserves it.
3. Projectors are idempotent: applying them once is the same as applying them many times.
4. Given a subspace V and its projector, the projector onto its orthogonal complement V^\perp can be easily calculated; this is intuitive from the perspective that a projector is simply the identity within the subspace it corresponds to, so “the identity of V^\perp” is simply the identity of the whole vector space minus the identity of V. 
![[images/orthogonal-complement-projector.svg]]
5. Because projectors are basis independent, they can be constructed without explicitly knowing the basis vectors for the subspace.

## LaTeX Note

${pdfPath("projector")}

