---
finished: true
---

#math/groups
#computer-science/gap

# Building a Group in GAP

**Motivation.** GAP (Groups, Algorithms, Programming) is a computer algebra system specialized for discrete algebra, and the most basic task in GAP is constructing a group object. There are three natural ways to do this: by specifying generators and relations (a finitely presented group), by specifying generating permutations, or by taking a quotient of an existing group. Each method produces a different kind of GAP object with different computational properties, and choosing the right one matters enormously for what you can subsequently compute.

**Discussion.** The most general construction is the **finitely presented group** (FpGroup). Starting from a free group on named generators,
```gap
F := FreeGroup("a", "b");;   # free group on generators a, b
a := F.1;;  b := F.2;;       # bind the generators to variables
```
we impose relations by quotienting:
```gap
G := F / [ a*b*a^-1*b^-1 ];; # add the relation aba^{-1}b^{-1} = 1, i.e. ab = ba
```
The list passed to `/` is the list of *relators* — words that are declared equal to the identity. GAP stores the presentation but does not enumerate the group. As a result, `Size(G)` may run forever if the group is infinite, and `Elements(G)` is unavailable. The FpGroup representation is the right choice when you want to state a presentation precisely and do not need to enumerate elements — for example, the braid group [[gap-system/building_a_group#Quotients]].

When the group *is* finite and you have a concrete action on a set, a **permutation group** is far more efficient:
```gap
S3 := SymmetricGroup(3);;     # S_3 as a permutation group on {1,2,3}
Size(S3);                     # => 6 (instant)
Elements(S3);                 # => list of all 6 permutations
```
GAP knows many structural facts about permutation groups — conjugacy classes, character tables, Sylow subgroups — all without any additional work from the user.

A third option is a **matrix group**, obtained by giving generating matrices:
```gap
GL2Q := Group( [[-1,0],[2,2]]*One(Rationals),
               [[2,1],[0,-1]]*One(Rationals) );;
```
Matrix groups are the natural target when constructing representations.

### Quotients

Given any FpGroup `G` whose generators are `g1, g2, …`, adding more relations produces a quotient:
```gap
# B3: the 3-braid group (one Artin relation)
F3 := FreeGroup("s1","s2");;
s1 := F3.1;;  s2 := F3.2;;
B3 := F3 / [ s1*s2*s1*(s2*s1*s2)^-1 ];;

# S3 = B3 / <s1^2, s2^2>: kill the squares to get the symmetric group
g1 := B3.1;;  g2 := B3.2;;
S3_fp := B3 / [ g1^2, g2^2 ];;
Size(S3_fp);  # => 6
```
This is the algebraic statement that $S_n \cong B_n / \langle \sigma_i^2 \rangle$: the symmetric group is the quotient of the braid group by the involution relations. See [[gap-system/Tutorial/irrep_3-braid]] for how this quotient is exploited.

**Result.** For a finitely presented group `G` defined by `FreeGroup` and `/[...]`, GAP stores the generators and relators. `RelatorsOfFpGroup(G)` retrieves them. `Size(G)` works if the group is finite and GAP can run a coset enumeration (Todd–Coxeter); it may fail or loop for infinite groups. For a permutation group or matrix group, `Size` is always fast. The available operations depend on the representation:

| Kind | `Size` | `Elements` | `IrreducibleRepresentations` |
|------|--------|-----------|------------------------------|
| FpGroup (infinite) | loops | unavailable | unavailable |
| FpGroup (finite) | Todd–Coxeter | slow | unavailable |
| PermGroup | instant | fast | available (finite) |
| MatrixGroup | varies | slow | unavailable directly |

**Remark.** A common mistake is to call `IrreducibleRepresentations` on an FpGroup representing an infinite group such as the braid group. GAP will either error or loop. The correct approach for infinite groups is to construct representations by hand as matrix maps satisfying the defining relations, and verify them explicitly — as done in the [[gap-system/Tutorial/irrep_3-braid]] tutorial.

## Glossary
- **FpGroup**: A finitely presented group — a free group quotiented by a list of relator words.
- **Relator**: A word in the generators declared equal to the identity. The relation $ab = ba$ is stored as the relator $aba^{-1}b^{-1}$.
- **PermGroup**: A group represented as a set of permutations acting on $\{1,\ldots,n\}$.
- **`FreeGroup("a","b")`**: Creates the free group on generators named `a` and `b`.
- **`F / [...]`**: Quotients the group `F` by the normal closure of the listed relators.
- **`SymmetricGroup(n)`**: GAP built-in for $S_n$ as a permutation group.
- **Todd–Coxeter**: The coset enumeration algorithm GAP uses to compute the order of a finitely presented group.
