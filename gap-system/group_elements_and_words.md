---
finished: true
---

#math/groups
#computer-science/gap

# Group Elements and Words in GAP

**Motivation.** Once a group is built in GAP (see [[gap-system/building_a_group]]), the natural next question is: how do I refer to specific elements, combine them, and evaluate maps on them? In a finitely presented group, every element is a *word* in the generators, and arithmetic is done by concatenating and reducing these words. In a permutation group, elements are permutations and multiplication is composition. Bridging these two worlds — evaluating a word in an FpGroup inside a concrete matrix or permutation group — is the key operation for working with group representations.

**Discussion.** In a permutation group, elements are written in cycle notation and combine by function composition:
```gap
p := (1,2,3);;    # the 3-cycle sending 1->2->3->1
q := (1,2);;      # the transposition swapping 1 and 2
p*q;              # => (2,3)   (apply p first, then q, rightmost first in GAP)
p^-1;             # => (1,3,2)
p^3;              # => ()      the identity
```
Note GAP's convention: `p*q` means apply `p` *first*, then `q` (left-to-right action on points).

In an FpGroup the elements are formal words. Accessing the generators by index gives the two sides of the group from which words are built:
```gap
F3 := FreeGroup("s1","s2");;
B3 := F3 / [ F3.1*F3.2*F3.1*(F3.2*F3.1*F3.2)^-1 ];;
g1 := B3.1;;  g2 := B3.2;;  # Artin generators sigma_1, sigma_2

w := g1*g2*g1;;   # the word sigma_1 sigma_2 sigma_1 (Garside element)
w^-1;;            # its inverse
w^2;;             # w composed with itself
```
GAP does not enumerate the elements of `B3` (it is infinite), but it can still store and manipulate words. Two words are *equal in the group* if one can be reduced to the other using the relators; GAP uses Tietze transformations for this in FpGroups.

### Homomorphisms and ImageElm

The most useful bridge between an abstract group and a concrete matrix or permutation group is a homomorphism. `GroupHomomorphismByImages` builds one by declaring where each generator goes:
```gap
S3 := SymmetricGroup(3);;
phi := GroupHomomorphismByImages(B3, S3, [g1,g2], [(1,2),(2,3)]);;
```
GAP checks that the declared images satisfy all relators of the source group before accepting. Given a valid homomorphism `phi`, `ImageElm(phi, g)` evaluates it on any group element `g`:
```gap
ImageElm(phi, g1);         # => (1,2)
ImageElm(phi, g1*g2*g1);   # => (1,3)   (the Garside element -> transposition (1,3))
ImageElm(phi, g1^2);       # => ()       (square of sigma_1 maps to identity in S3)
```
The last line reflects the algebraic fact that $S_3 = B_3 / \langle \sigma_i^2 \rangle$: the squares, which are non-trivial in $B_3$, become trivial in $S_3$.

For infinite or complicated source groups, `GroupHomomorphismByImages` may return `fail` if GAP cannot verify the relation. A safe fallback is `GroupHomomorphismByFunction`, which bypasses GAP's internal check and trusts a user-supplied function:
```gap
phi_safe := GroupHomomorphismByFunction(B3, S3,
    function(w)
        return MappedWord(UnderlyingElement(w),
                          GeneratorsOfGroup(B3), [(1,2),(2,3)]);
    end);;
```
`MappedWord(word, gens, imgs)` evaluates the word by substituting each generator with its image and composing — it is the universal property of free groups made explicit.

**Result.** For an FpGroup `G` with generators `[g1,g2]` and a target group `H`:

- `GroupHomomorphismByImages(G, H, [g1,g2], [h1,h2])` constructs a hom if `h1,h2` satisfy all relators of `G` in `H`, otherwise returns `fail`.
- `ImageElm(phi, w)` evaluates `phi` on the word `w`, returning an element of `H`.
- `MappedWord(UnderlyingElement(w), GeneratorsOfGroup(G), [h1,h2])` does the same thing without the relator check, and is the safest path when `GroupHomomorphismByImages` balks at an infinite group.

**Remark.** A subtle point: `g1^2` is a non-trivial word in `B3` (the braid group has no relation killing it), but `ImageElm(phi, g1^2)` evaluates to the identity `()` in `S3`. This is not a bug — it correctly reflects that the quotient map $B_3 \to S_3$ sends $\sigma_1^2$ to $e$. The word `g1^2` is non-trivial in `B3` but trivial in the image. Equality of words in an FpGroup (`=`) tests equality in the *quotient*, not as free words. To test equality as free words, use `UnderlyingElement`.

## Glossary
- **Word**: An element of a free group or FpGroup; a finite string of generators and their inverses.
- **Relator**: A word declared equal to the identity, used to define quotient groups.
- **`ImageElm(phi, g)`**: Evaluates the homomorphism `phi` on the group element `g`.
- **`GroupHomomorphismByImages(G,H,gens,imgs)`**: Builds a homomorphism by specifying generator images; checks relators.
- **`GroupHomomorphismByFunction(G,H,f)`**: Builds a homomorphism from a raw GAP function; no automatic relation check.
- **`MappedWord(w,gens,imgs)`**: Evaluates a free word `w` by substituting generators with images.
- **`UnderlyingElement(g)`**: Returns the free-group word underlying an FpGroup element.
- **Cycle notation**: The standard notation for permutations, e.g. `(1,2,3)` means $1\mapsto 2\mapsto 3\mapsto 1$.
