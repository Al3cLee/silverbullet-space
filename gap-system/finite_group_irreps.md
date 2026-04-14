---
finished: true
---

#math/groups
#math/representations
#computer-science/gap

# Finite Group Irreducible Representations in GAP

**Motivation.** A representation of a group $G$ is a homomorphism $\rho: G \to GL(V)$ — a way to make $G$ act on a vector space by invertible linear maps. Decomposing a representation into *irreducible* pieces (those with no proper invariant subspace) is the central problem of representation theory. For finite groups, GAP can compute this automatically. For infinite groups, we must construct and verify irreducible representations by hand. Understanding both paths, and the matrix machinery behind them, is the foundation of the work in [[gap-system/Tutorial/irrep_3-braid]].

**Discussion.** For a finite group given as a permutation group, GAP's `IrreducibleRepresentations` computes all irreps at once:
```gap
S3 := SymmetricGroup(3);;
irreps := IrreducibleRepresentations(S3);;
# Returns a list of 3 group homomorphisms to matrix groups.
# Their dimensions are 1, 1, 2  (matching 1^2 + 1^2 + 2^2 = 6 = |S3|).
for rho in irreps do
    Print(Dimension(Range(rho)), "\n");   # prints the rep dimension
od;
```
This works because the number of irreps of a finite group equals the number of conjugacy classes, and their dimensions $d_i$ satisfy $\sum d_i^2 = |G|$. GAP uses character theory internally.

For an **infinite group** such as the braid group $B_3$, none of this applies. The right strategy is:

1. Write down explicit matrices for each generator, motivated by the algebra one wants to represent.
2. Verify by direct matrix computation that the defining relations hold.
3. Check irreducibility: a representation on $V$ is irreducible iff there is no proper subspace of $V$ preserved by every matrix in the image.

The verification of relations is straightforward matrix arithmetic in GAP. The key primitives are:
```gap
id2   := IdentityMat(2, Rationals);;   # 2x2 identity over Q
zero2 := NullMat(2, 2, Rationals);;    # 2x2 zero matrix

M1 := [[-1,0],[2,2]] * One(Rationals);;
M2 := [[2,1],[0,-1]] * One(Rationals);;

M1*M2*M1 = M2*M1*M2;   # test braid relation: => true
(M1 - 2*id2)*(M1 + id2) = zero2;  # test Hecke relation: => true
```
The `* One(Rationals)` idiom coerces the integer literal matrix into a matrix over `Rationals`, which is necessary for GAP to treat it as a linear algebra object rather than a list of integers.

### Checking Irreducibility

For a 2-dimensional representation, irreducibility is equivalent to: there is no common eigenvector of $M_1$ and $M_2$. We check this by finding the eigenspaces of $M_1$ (one for each eigenvalue) and testing whether $M_2$ preserves any of them:
```gap
# Right null-space of (M1 - ev*I): right eigenvectors for eigenvalue ev
ev := 2;;
egsp := NullspaceMat(TransposedMat(M1 - ev*id2));;
for v in egsp do
    if M2*v = ev*v or M2*v = (-1)*v then
        Print("Invariant subspace found!\n");
    fi;
od;
```
The pitfall here is that GAP's `NullspaceMat(A)` returns the *left* null-space (row vectors $v$ with $v \cdot A = 0$). To get right eigenvectors (column vectors with $A \cdot v = 0$), one must transpose: `NullspaceMat(TransposedMat(A))`.

### The Hecke Algebra Shortcut

The Iwahori–Hecke algebra $H_n(q)$ is the quotient of $\mathbb{C}[B_n]$ by the relations $(T_i - q)(T_i + 1) = 0$. Its irreps are in bijection with those of $B_n$ that factor through $H_n(q)$, and — crucially — $\dim H_n(q) = n!$, the same as $|\mathbb{C}[S_n]|$. So the irreps of $H_n(q)$ have the same dimensions and count as those of $S_n$, computable from $\sum d_i^2 = n!$.

For $q = 2$ (a generic rational parameter), all matrix entries are integers, making exact arithmetic over `Rationals` in GAP clean and fast. At $q = 1$ the Hecke relation becomes $T_i^2 = 1$, recovering the symmetric group, which serves as a cross-check.

**Result.** For any collection of matrices $M_1, \ldots, M_{n-1}$ proposed as images of the generators of $B_n$:

- Check all braid relations $M_i M_{i+1} M_i = M_{i+1} M_i M_{i+1}$ and far-commutativity $M_i M_j = M_j M_i$ for $|i-j| \geq 2$.
- Check the Hecke relation $(M_i - q \cdot I)(M_i + I) = 0$ for each $i$.
- Check irreducibility by showing no common eigenvector exists.
- Count: dimensions $d_1, d_2, \ldots$ should satisfy $\sum d_i^2 = n!$ to confirm all irreps are found.

All four checks are implemented in `braid_check.g` via `CheckRep` and `CheckIrreducible2d`.

**Remark.** For 1-dimensional representations, the irreducibility check is vacuous (a 1-d space has no proper subspaces), but non-isomorphism between two 1-d irreps must be verified separately: they are distinct iff they assign different scalars to some generator. The 1-d irreps of $H_n(q)$ are precisely the trivial-deformed ($T_i \mapsto q$) and the sign-deformed ($T_i \mapsto -1$); any $q \neq -1$ makes them distinct.

## Glossary
- **Irreducible representation (irrep)**: A representation with no proper non-zero invariant subspace.
- **`IrreducibleRepresentations(G)`**: GAP function computing all irreps of a finite group `G`.
- **`IdentityMat(n, field)`**: Returns the $n\times n$ identity matrix over `field`.
- **`NullMat(n, m, field)`**: Returns an $n\times m$ zero matrix over `field`.
- **`NullspaceMat(A)`**: Returns a basis for the left null-space of `A` (row vectors $v$ with $v\cdot A = 0$).
- **`* One(Rationals)`**: Coerces a matrix of integers into a GAP matrix over `Rationals`.
- **Hecke algebra $H_n(q)$**: The quotient of $\mathbb{C}[B_n]$ by $(T_i-q)(T_i+1)=0$; its irreps give irreps of $B_n$.
- **Generic parameter**: A value of $q$ that is not a root of unity and does not make $H_n(q)$ non-semisimple.
- **Eigenspace**: The set of vectors sent to scalar multiples of themselves by a linear map.
