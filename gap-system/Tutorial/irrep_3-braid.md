---
finished: true
---

#math/groups
#math/representations
#math/braid-groups
#computer-science/gap

# Irreducible Representations of the 3-Braid Group in GAP

**Motivation.** The 3-braid group $B_3 = \langle \sigma_1, \sigma_2 \mid \sigma_1\sigma_2\sigma_1 = \sigma_2\sigma_1\sigma_2 \rangle$ is infinite, so GAP's built-in `IrreducibleRepresentations` cannot be applied to it. We want all finite-dimensional irreducible representations of $B_3$ over $\mathbb{Q}$, with explicit matrices, verified by GAP's exact arithmetic. The route is through the Iwahori–Hecke algebra $H_3(q)$, whose representation theory is classical and completely explicit. See [[gap-system/finite_group_irreps]] for the general framework.

**Discussion.** The Hecke algebra $H_3(q)$ is the quotient of $\mathbb{Q}[B_3]$ by the quadratic relations $(T_i - q)(T_i + 1) = 0$ for $i = 1, 2$. Every representation of $H_3(q)$ is automatically a representation of $B_3$. Since $\dim H_3(q) = 3! = 6$, the dimensions of its irreps must satisfy $\sum d_i^2 = 6 = 1^2 + 1^2 + 2^2$, giving exactly three irreps of dimensions 1, 1, 2. This matches the count for $S_3$, which is the $q = 1$ specialisation.

We work at $q = 2$, a generic rational value (not a root of unity), so all matrix entries are integers and GAP operates entirely over `Rationals` without needing cyclotomic fields.

**Defining $B_3$ as an FpGroup.** The construction follows the pattern in [[gap-system/building_a_group]]:
```gap
F3 := FreeGroup("s1","s2");;
s1_free := F3.1;;  s2_free := F3.2;;
B3 := F3 / [ s1_free*s2_free*s1_free*(s2_free*s1_free*s2_free)^-1 ];;
g1 := B3.1;;  g2 := B3.2;;
```
`RelatorsOfFpGroup(B3)` will display `[ s1*s2*s1*s2^-1*s1^-1*s2^-1 ]`, confirming the Artin relation $\sigma_1\sigma_2\sigma_1(\sigma_2\sigma_1\sigma_2)^{-1} = 1$ is stored.

**The three irreps.** The two 1-dimensional irreps come from the Hecke eigenvalues $q$ and $-1$:

$$
V_1: \quad \sigma_i \mapsto [[q]] \qquad V_2: \quad \sigma_i \mapsto [[-1]]
$$

The unique 2-dimensional irrep comes from the reduced Burau representation (sign-flipped). At $q = 2$:

$$
V_3: \quad \sigma_1 \mapsto M_1 = \begin{pmatrix}-1 & 0 \\ 2 & 2\end{pmatrix}, \qquad \sigma_2 \mapsto M_2 = \begin{pmatrix}2 & 1 \\ 0 & -1\end{pmatrix}
$$

In GAP:
```gap
q     := 2;;
id2   := IdentityMat(2, Rationals);;
zero2 := NullMat(2, 2, Rationals);;

V3_s1 := [[-1,0],[q,q]] * One(Rationals);;
V3_s2 := [[q,1],[0,-1]] * One(Rationals);;
```

**Verification.** The helper `CheckRep` in `braid_check.g` tests three conditions at once: the braid relation, and both Hecke relations. Calling it:
```gap
Read("braid_check.g");;
CheckRep("V3", V3_s1, V3_s2, id2, zero2, q);;
```
produces confirmation that $M_1 M_2 M_1 = M_2 M_1 M_2$ and $(M_i - 2I)(M_i + I) = 0$. The explicit computation for the braid relation is:

$$
M_1 M_2 = \begin{pmatrix}-q & -1 \\ q^2 & 0\end{pmatrix}, \qquad M_1 M_2 M_1 = \begin{pmatrix}0 & -q \\ -q^2 & 0\end{pmatrix} = M_2 M_1 M_2 \checkmark
$$

**Irreducibility.** Since $V_3$ is 2-dimensional, we need to check that no vector is a simultaneous eigenvector of both $M_1$ and $M_2$. The Hecke relation forces eigenvalues of $M_1$ to be $q = 2$ and $-1$. For each eigenspace we ask whether $M_2$ maps it into itself:
```gap
CheckIrreducible2d(V3_s1, V3_s2, q, id2);;
# => "No common eigenvector => representation is IRREDUCIBLE"
```
Concretely: the eigenvector of $M_1$ for eigenvalue $q$ is $[0,1]^T$, and $M_2 [0,1]^T = [1,-1]^T$, which is not proportional to $[0,1]^T$ for $q \neq 0$. The eigenvector for $-1$ is $[q+1, -q]^T$, and $M_2$ applied to it gives $q[q,1]^T$, not proportional to $[q+1,-q]^T$ (that would require $q = -1/2$). So $V_3$ is irreducible for $q = 2$.

**Result.** Over $\mathbb{Q}$ at $q = 2$, the three irreducible representations of $B_3$ (via $H_3(q)$) are:

| Rep | Dim | $\sigma_1$ | $\sigma_2$ |
|-----|-----|-----------|-----------|
| $V_1$ (trivial-def.) | 1 | $[[2]]$ | $[[2]]$ |
| $V_2$ (sign-def.) | 1 | $[[-1]]$ | $[[-1]]$ |
| $V_3$ (standard) | 2 | $[[-1,0],[2,2]]$ | $[[2,1],[0,-1]]$ |

$\sum d_i^2 = 1 + 1 + 4 = 6 = \dim H_3(q) = 3!$, confirming completeness.

---

**Motivation.** Having the irreps as matrices, a natural enrichment is to package them as GAP homomorphism objects, which then allow systematic evaluation on arbitrary braid words.

**Discussion.** `GroupHomomorphismByImages` tries to build the hom and verify the Artin relation in the target matrix group. Because the target is a matrix group (finite intersection of $GL_n(\mathbb{Q})$), the verification is just one matrix equality check and succeeds quickly:
```gap
GL2Q := Group(V3_s1, V3_s2);;
phi3  := GroupHomomorphismByImages(B3, GL2Q, [g1,g2], [V3_s1, V3_s2]);;
```
The variable name `Delta` must be avoided (it is a reserved GAP global for character tables). We use `garside` instead:
```gap
garside := g1*g2*g1;;           # sigma_1 sigma_2 sigma_1
ImageElm(phi3, garside);        # => [[0,-2],[-4,0]]
ImageElm(phi3, garside^2);      # => [[8,0],[0,8]] = q^3 * I_2
```
The last line is Schur's lemma in action: $\Delta^2$ lies in the center of $B_3$, so by Schur's lemma it must act as a scalar in any irrep. At $q = 2$ the scalar is $q^3 = 8$.

**Result.** The homomorphism object `phi3` can be evaluated on any word in $B_3$. The full twist $(\\sigma_1\sigma_2)^3$ also acts as a scalar ($8 \cdot I_2$), consistent with it being twice the Garside element.

**Remark.** At $q = 1$ the matrices specialise to the standard 2-dimensional irrep of $S_3$: $M_1 = [[-1,0],[1,1]]$, $M_2 = [[1,1],[0,-1]]$. One can verify $M_i^2 = I_2$, confirming that this representation factors through the quotient $B_3 \twoheadrightarrow S_3$. This is the bridge to [[gap-system/Tutorial/second_quantization]] where the symmetric group acts as the statistics group of identical particles.

---

**Motivation.** The symmetric group connection also goes the other way: we can build $S_3$ directly as a quotient of $B_3$ in GAP, making the algebraic relationship $S_3 \cong B_3/\langle \sigma_i^2 \rangle$ explicit.

**Discussion.** Adding the relations $\sigma_i^2 = 1$ to the existing FpGroup `B3` produces a new FpGroup:
```gap
S3_fp := B3 / [ g1^2, g2^2 ];;
Size(S3_fp);   # => 6  (Todd-Coxeter coset enumeration terminates)
```
The quotient map $\pi: B_3 \to S_3$ sends each $\sigma_i$ to the adjacent transposition $(i, i+1)$:
```gap
S3_perm := SymmetricGroup(3);;
quot := GroupHomomorphismByImages(B3, S3_perm, [g1,g2], [(1,2),(2,3)]);;
ImageElm(quot, garside);   # => (1,3)
```
The Garside element $\sigma_1\sigma_2\sigma_1$ maps to the transposition $(1,3)$: in cycle notation, $(1,2)\cdot(2,3)\cdot(1,2) = (1,3)$.

**Result.** `braid_quotient.g` assembles all these pieces: FpGroup construction of $B_2$ and $B_3$, the quotient by squares giving $S_2$ and $S_3$, the homomorphism to `SymmetricGroup(3)`, and the $q=1$ matrix cross-check. Running it produces the output confirming all the above.

**Remark.** The kernel of $\pi: B_3 \to S_3$ is the *pure braid group* $P_3$, the subgroup of braids where each strand returns to its starting position. $P_3$ is an infinite group (it is a free group of rank 2). The map $\pi$ is therefore far from injective — it collapses an infinite group to a finite one — and the irreps of $B_3$ that factor through $\pi$ (i.e. those satisfying $\sigma_i^2 = 1$) are exactly the irreps of $S_3$, which at $q=1$ are $V_1, V_2, V_3$ specialized to the symmetric group.

## Glossary
- **Artin relation**: The braid relation $\sigma_1\sigma_2\sigma_1 = \sigma_2\sigma_1\sigma_2$ defining $B_3$.
- **Hecke algebra $H_3(q)$**: Quotient of $\mathbb{Q}[B_3]$ by $(T_i-q)(T_i+1)=0$; dimension $3!=6$.
- **Generic $q$**: A value of $q$ that is not a root of unity; at $q=2$ all irrep matrices have integer entries.
- **Reduced Burau representation**: A classical family of braid group representations; $V_3$ is its $n=3$ instance.
- **Garside element**: $\Delta = \sigma_1\sigma_2\sigma_1$; its square $\Delta^2$ generates the center of $B_3$.
- **Pure braid group $P_3$**: The kernel of $B_3 \to S_3$; the braids where all strands return to their origin.
- **`CheckRep`**: Helper function in `braid_check.g` verifying braid and Hecke relations for a pair of matrices.
- **`CheckIrreducible2d`**: Helper function checking no common eigenvector exists for a 2-d rep.
- **`* One(Rationals)`**: Coerces a literal integer matrix into a GAP matrix over the rationals.
