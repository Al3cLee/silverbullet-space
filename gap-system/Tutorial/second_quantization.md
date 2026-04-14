---
finished: true
---

#physics/quantum-fields
#physics/condensed-matter
#math/groups
#math/representations
#computer-science/gap

# Second Quantization and Braid Groups in GAP — a Complete Tutorial

**Motivation.** Second quantization is, at its heart, a systematic way to handle the statistics of identical quantum particles. Bosons and fermions differ by the sign acquired when two particles are exchanged: the many-body state picks up a factor of $+1$ (bosons) or $-1$ (fermions). This exchange symmetry is precisely the action of the symmetric group $S_N$, and the projectors onto the symmetric and antisymmetric subspaces are weighted sums over $S_N$. A computer algebra system like GAP, which is built for exact discrete algebra, is therefore the natural environment to verify these combinatorial facts. This tutorial walks through the GAP scripts in the `gap-system` project, building from permutation groups up to Fock space operators and braid group representations. The prerequisite building blocks are collected in [[gap-system/building_a_group]], [[gap-system/group_elements_and_words]], and [[gap-system/finite_group_irreps]].

**Discussion.** We start with the simplest non-trivial case: $S_3$ acting on a 3-particle state. GAP represents $S_N$ as a permutation group and can enumerate all elements in an instant:
```gap
N  := 3;;
SN := SymmetricGroup(N);;   # S_3, permutation group on {1,2,3}
# Iterate over all 6 permutations:
for p in SN do
    Print(p, "  parity: ", SignPerm(p), "\n");
od;
```
`SignPerm(p)` returns $+1$ for even permutations and $-1$ for odd ones. This is the foundation of `test_snippet1.g`. The key insight for second quantization is that the symmetrization projector is just the group average of the action of $S_N$, weighted by $\zeta^{|p|}$ where $\zeta = +1$ for bosons and $\zeta = -1$ for fermions:

$$
P_\zeta = \frac{1}{N!} \sum_{\pi \in S_N} \zeta^{|\pi|} \hat{\pi}
$$

In GAP this becomes a loop over `SN`, applied to a state vector:
```gap
SymmProjector := function(state, zeta)
    local N, SN, result, p, permuted, coeff;
    N  := Length(state);
    SN := SymmetricGroup(N);
    result := [];
    for p in SN do
        # zeta^|p|: the statistics weight.  |p| = 0 (even) -> +1; |p| = 1 (odd) -> zeta.
        coeff    := zeta^((1 - SignPerm(p))/2);
        # Act on the state: the i-th slot of the permuted state comes from slot i^p.
        # In GAP, i^p means: apply permutation p to the point i.
        permuted := List([1..N], i -> state[i^p]);
        Add(result, [coeff/Factorial(N), permuted]);
    od;
    return result;
end;;
```
The notation `i^p` is GAP's way of applying the permutation `p` to the integer `i` — it is the point-action. A bosonic 2-particle state $|0,1\rangle$ symmetrizes to $\tfrac{1}{2}(|0,1\rangle + |1,0\rangle)$; a fermionic one gives $\tfrac{1}{2}(|0,1\rangle - |1,0\rangle)$. The full tests are in `test_snippet2.g`.

**Result.** The projector satisfies $P_\zeta^2 = P_\zeta$ (idempotence) and $P_+^\dagger P_- = 0$ (orthogonality of bosonic and fermionic sectors). Both are verified in `test_snippet3.g` and `test_snippet4.g` by explicit computation in GAP's exact arithmetic over $\mathbb{Q}$. For a state with occupation numbers $n_0, n_1, \ldots$, the norm squared of its projected form is

$$
\|P_\zeta |\psi\rangle\|^2 = \frac{1}{N!} \prod_\alpha n_\alpha!
$$

(for bosons; zero if any $n_\alpha > 1$ for fermions). `test_snippet5.g` checks this formula via `Collected(state)` to extract the occupation numbers.

---

**Motivation.** Having established the projectors, the natural next step is to implement the creation and annihilation operators that map between different total occupation numbers. These are the operators $\hat{a}_\alpha^\dagger$ (add one particle to mode $\alpha$) and $\hat{a}_\alpha$ (remove one), and they satisfy the canonical (anti)commutation relations which are the defining algebraic structure of any quantum field theory.

**Discussion.** In the occupation-number basis, the operators act as:
```gap
Annihilate := function(fockState, alpha, zeta)
    local n_alpha, prefactor, newState;
    n_alpha := fockState[alpha + 1];   # occupancy of mode alpha (1-indexed list)
    if n_alpha = 0 then return fail; fi;   # cannot remove from empty mode
    newState          := ShallowCopy(fockState);
    newState[alpha+1] := n_alpha - 1;
    prefactor := Sqrt(n_alpha);
    if zeta = -1 then
        # Fermionic Jordan-Wigner phase: (-1)^(number of particles in modes < alpha)
        prefactor := prefactor * (-1)^Sum(fockState{[1..alpha]});
    fi;
    return [prefactor, newState];
end;;
```
The fermionic case introduces the Jordan–Wigner phase factor, which keeps track of the anti-commutation sign accumulated when moving an operator past all occupied modes to the left of $\alpha$. Without it, successive applications of fermionic operators would not reproduce the canonical anticommutation relation $\{\hat{a}_\alpha, \hat{a}_{\alpha'}^\dagger\} = \delta_{\alpha\alpha'}$.

The (anti)commutator $[\hat{a}_\alpha, \hat{a}_{\alpha'}^\dagger]_{-\zeta} = \hat{a}_\alpha \hat{a}_{\alpha'}^\dagger - \zeta \hat{a}_{\alpha'}^\dagger \hat{a}_\alpha$ is verified in `test_snippet7.g` by applying both orderings to a concrete Fock state and checking the scalar coefficient equals $\delta_{\alpha\alpha'}$:
```gap
CommutatorTest := function(fock, alpha, alphaPrime, zeta)
    local c1, c2, step1, step2;
    # Term 1:  a_alpha  a^dag_{alpha'} |fock>
    step1 := Create(fock, alphaPrime, zeta);;
    ...
    # Term 2:  a^dag_{alpha'}  a_alpha  |fock>
    step1 := Annihilate(fock, alpha, zeta);;
    ...
    return c1 - zeta * c2;
end;;
```
For $\alpha = \alpha'$ both bosonic and fermionic versions return 1; for $\alpha \neq \alpha'$ they return 0.

**Result.** The number operator $\hat{n}_\alpha = \hat{a}_\alpha^\dagger \hat{a}_\alpha$ is just the composition `Create(Annihilate(...))`, and its eigenvalue on $|n_0, n_1, \ldots\rangle$ is $n_\alpha$. The 1-body operator $\hat{H}_1 = \sum_\alpha \varepsilon_\alpha \hat{n}_\alpha$ in the eigenbasis becomes a simple dot product with the occupation vector:
```gap
OneBodyOperator := function(fockState, eigenvalues)
    local val, i;
    val := 0;
    for i in [0..Length(fockState)-1] do
        val := val + fockState[i+1] * eigenvalues[i+1];
    od;
    return val;
end;;
# On |2,1,0> with eigenvalues [0,1,2]:  2*0 + 1*1 + 0*2 = 1
```
The 2-body operator $\hat{H}_2 = \frac{1}{2}\sum_{\alpha\beta} U_{\alpha\beta} \hat{n}_\alpha(\hat{n}_\beta - \delta_{\alpha\beta})$ is implemented analogously in `test_snippet9.g`.

---

**Motivation.** So far the symmetric group $S_N$ has played the role of the statistics group. But there is a deeper object lurking here: the braid group $B_N$. The statistics of quantum particles in two spatial dimensions is not constrained to $\pm 1$; particles can pick up any phase $e^{i\theta}$ (anyons), and the relevant symmetry group is $B_N$ rather than $S_N$. The symmetric group is merely the quotient $S_N = B_N / \langle \sigma_i^2 \rangle$ — the braid group with the constraint that every crossing is its own inverse.

**Discussion.** The 3-braid group $B_3$ is defined in GAP as a finitely presented group, as detailed in [[gap-system/Tutorial/irrep_3-braid]]:
```gap
F3 := FreeGroup("s1","s2");;
s1 := F3.1;;  s2 := F3.2;;
B3 := F3 / [ s1*s2*s1*(s2*s1*s2)^-1 ];;   # single Artin relation
g1 := B3.1;;  g2 := B3.2;;
```
To recover $S_3$, one adds the involution relations $\sigma_i^2 = 1$:
```gap
S3_fp   := B3 / [ g1^2, g2^2 ];;   # Size = 6
S3_perm := SymmetricGroup(3);;
quot    := GroupHomomorphismByImages(B3, S3_perm, [g1,g2], [(1,2),(2,3)]);;
```
The homomorphism `quot` sends $\sigma_i$ to the adjacent transposition $(i,i+1)$, the precise permutation that exchanges particles $i$ and $i+1$. The squares $\sigma_i^2$ map to the identity `()` — they are in the kernel — while in $B_3$ itself they are non-trivial: a double crossing of two strands is a non-trivial loop in the configuration space of particles.

The irreducible representations of $B_3$ via the Hecke algebra $H_3(q)$ at $q = 2$ produce three matrix representations:
```gap
V3_s1 := [[-1,0],[2,2]] * One(Rationals);;
V3_s2 := [[2,1],[0,-1]] * One(Rationals);;
phi3  := GroupHomomorphismByImages(B3, Group(V3_s1,V3_s2), [g1,g2], [V3_s1,V3_s2]);;
```
At $q = 1$ these matrices specialise to $M_1 = [[-1,0],[1,1]]$, $M_2 = [[1,1],[0,-1]]$, which satisfy $M_i^2 = I_2$ and therefore factor through $S_3$, giving back the standard 2-dimensional irrep of the symmetric group — the same symmetry group that organizes the Fock space of 3 indistinguishable particles.

**Result.** The chain of algebraic relationships is:

$$
B_3 \xrightarrow{\text{quotient by } \sigma_i^2 = 1} S_3 \xrightarrow{\text{act on Fock space}} \text{second quantization}
$$

The braid group controls the full statistics (including anyonic), the symmetric group controls conventional bosonic and fermionic statistics, and the Fock space projectors $P_\pm$ are the concrete realization of the $S_N$ action. The Hecke algebra $H_n(q)$ interpolates between the two: at $q = 1$ it is $\mathbb{C}[S_n]$, at generic $q$ its representations are representations of $B_n$ with a deformed quadratic relation. This is the algebraic skeleton of fractional statistics.

**Remark.** All the computations in this tutorial are exact: GAP uses rational arithmetic throughout, and no floating-point approximation is ever made. The `Sqrt` calls in the creation/annihilation operators produce GAP's symbolic square roots, which compare and combine exactly. This is a crucial advantage of a computer algebra system over a numerical library: the correctness of the (anti)commutation relations, the idempotence of the projectors, and the braid relation for the matrix representations are all verified as equalities, not as floating-point coincidences.

## Glossary
- **Fock state**: A many-body quantum state labeled by occupation numbers $|n_0, n_1, \ldots\rangle$, one per mode.
- **Occupation number**: The number of particles in a given single-particle mode.
- **Symmetrization projector $P_\zeta$**: The operator $\frac{1}{N!}\sum_\pi \zeta^{|\pi|}\hat\pi$ projecting onto the (anti)symmetric subspace.
- **`SignPerm(p)`**: GAP function returning $+1$ for even and $-1$ for odd permutations.
- **`i^p`**: GAP notation for the point-action: apply permutation `p` to the integer `i`.
- **Jordan–Wigner phase**: The sign $(-1)^{\sum_{\beta < \alpha} n_\beta}$ attached to fermionic creation/annihilation to enforce anticommutation across different modes.
- **Braid group $B_N$**: The group of $N$-strand braids; the fundamental group of the configuration space of $N$ indistinguishable particles in the plane.
- **Artin relation**: $\sigma_i\sigma_{i+1}\sigma_i = \sigma_{i+1}\sigma_i\sigma_{i+1}$; the defining relation of $B_N$ beyond $i=1$.
- **Hecke algebra $H_N(q)$**: Quotient of $\mathbb{Q}[B_N]$ by $(T_i-q)(T_i+1)=0$; interpolates between $B_N$ (no quotient) and $S_N$ (at $q=1$).
- **Anyon**: A particle in 2D whose exchange phase $e^{i\theta}$ can be anything, not just $\pm 1$; described by $B_N$ representations.
- **`ShallowCopy`**: GAP function creating a one-level copy of a list, so modifications do not affect the original.
- **`Collected(list)`**: GAP function returning `[[value, count], ...]` — the multiset decomposition of a list.
- **`Assert(0, cond, msg)`**: GAP assertion: halts with `msg` if `cond` is false; the `0` is the assertion level.
