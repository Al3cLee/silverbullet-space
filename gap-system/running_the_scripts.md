---
finished: true
---

#computer-science/gap

# Running the GAP Scripts

**Motivation.** The `gap-system` project (at `~/Desktop/undergrad/10-26spring/code/gap-system/`) contains a set of self-contained GAP scripts that verify the mathematics described in [[gap-system/Tutorial/second_quantization]] and [[gap-system/Tutorial/irrep_3-braid]]. This note explains how to run them and what each one demonstrates.

**Discussion.** All scripts are run with the GAP binary at `~/Downloads/gap-4.15.1/gap`. The `-q` flag suppresses the startup banner, giving clean output. Every script ends with `QUIT;`, so it exits automatically. The general invocation is:
```bash
cd ~/Desktop/undergrad/10-26spring/code/gap-system
~/Downloads/gap-4.15.1/gap -q <script>.g
```
Each script is self-contained: it defines all functions it needs, runs tests with `Assert`, prints results, and exits. A clean run prints no error messages and ends with a summary line.

**The scripts and what they verify.**

`test_snippet1.g` — Symmetric group $S_3$, permutation parity. Enumerates all 6 elements of $S_3$, calls `SignPerm` on each, and asserts that `(1,2)` is odd and `(1,2,3)` is even. Entry point for understanding how GAP represents permutations.

`test_snippet2.g` — Symmetrization projector $P_\zeta$. Applies the (anti)symmetrization average over $S_N$ to 2-particle states, for $\zeta = \pm 1$. Verifies that bosonic states add symmetrically and fermionic states add with a sign.

`test_snippet3.g` — Idempotence $P_\zeta^2 = P_\zeta$. Applies the projector twice to 2- and 3-particle states and checks the result equals a single application.

`test_snippet4.g` — Orthogonality $\langle P_+ \psi | P_- \psi \rangle = 0$. Checks that the bosonic and fermionic projections of the same state are orthogonal.

`test_snippet5.g` — Norm squared formula. Checks $\|P_\zeta|\psi\rangle\|^2 = \frac{1}{N!}\prod_\alpha n_\alpha!$ (bosons) and $0$ if any $n_\alpha > 1$ (fermions).

`test_snippet6.g` — Creation and annihilation operators. Applies `Create` and `Annihilate` to Fock states, checks prefactors of $\sqrt{n_\alpha}$ (bosonic) and Jordan–Wigner signs (fermionic), and verifies `fail` is returned when a fermionic mode is doubly occupied.

`test_snippet7.g` — (Anti)commutation relations. Verifies $[\hat{a}_\alpha, \hat{a}_{\alpha'}^\dagger]_{-\zeta} = \delta_{\alpha\alpha'}$ by explicit double application on several Fock states.

`test_snippet8.g` — 1-body operator in the eigenbasis. Checks $\langle \hat{H}_1 \rangle = \sum_\alpha \varepsilon_\alpha n_\alpha$ for concrete Fock states.

`test_snippet9.g` — 2-body operator. Checks the diagonal 2-body energy $\frac{1}{2}\sum_{\alpha\beta} U_{\alpha\beta} n_\alpha(n_\beta - \delta_{\alpha\beta})$.

`braid_b2.g` — Irreps of $B_2 \cong \mathbb{Z}$. Defines $B_2$ as an FpGroup, constructs the two 1-dimensional Hecke-algebra representations at $q=2$, and verifies the Hecke relation. See [[gap-system/Tutorial/irrep_3-braid]].

`braid_b3.g` — Irreps of $B_3$. Defines $B_3$, constructs all three irreps $V_1, V_2, V_3$, verifies braid and Hecke relations, checks irreducibility of $V_3$, and cross-checks at $q = E(5)$ and $q = 1$.

`braid_hom.g` — Homomorphism objects for $B_3$. Wraps the three irreps as `GroupHomomorphismByImages` objects, evaluates them on the Garside element $\Delta = \sigma_1\sigma_2\sigma_1$, and verifies $\Delta^2 = q^3 I_2$ (Schur's lemma for the central element).

`braid_quotient.g` — $S_N$ as a quotient of $B_N$. Explicitly constructs $S_2 = B_2/\langle\sigma_1^2\rangle$ and $S_3 = B_3/\langle\sigma_1^2, \sigma_2^2\rangle$ as FpGroups, builds the quotient homomorphism $B_3 \to S_3$ sending $\sigma_i \mapsto (i,i+1)$, and cross-checks the $q=1$ matrix specialisation.

**Result.** Running all thirteen scripts in sequence should produce zero errors. A convenient one-liner:
```bash
cd ~/Desktop/undergrad/10-26spring/code/gap-system
for f in test_snippet{1..9}.g braid_b2.g braid_b3.g braid_hom.g braid_quotient.g; do
    echo "=== $f ===" && ~/Downloads/gap-4.15.1/gap -q $f
done
```

**Remark.** `braid_b3.g`, `braid_hom.g`, and `braid_quotient.g` all call `Read("braid_check.g")` to load the shared helper functions `CheckRep` and `CheckIrreducible2d`. They must therefore be run from the `gap-system/` directory (or the path in `Read` must be adjusted). The snippet scripts are fully self-contained and can be run from any directory by passing the full path.

## File Map

| Script | Topic | Key GAP primitives |
|--------|-------|--------------------|
| `test_snippet1.g` | Permutation parity | `SymmetricGroup`, `SignPerm` |
| `test_snippet2.g` | Symmetrization | `SignPerm`, `List`, `Factorial` |
| `test_snippet3.g` | Idempotence $P^2=P$ | `Collected`, `Filtered` |
| `test_snippet4.g` | Orthogonality $P_+\perp P_-$ | inner product loop |
| `test_snippet5.g` | Norm formula | `Collected`, `Product` |
| `test_snippet6.g` | Creation/annihilation | `ShallowCopy`, `Sqrt`, `Sum` |
| `test_snippet7.g` | (Anti)commutators | operator composition |
| `test_snippet8.g` | 1-body operator | index loop |
| `test_snippet9.g` | 2-body operator | double index loop |
| `braid_b2.g` | $B_2$ irreps | `FreeGroup`, `NullMat`, `IdentityMat` |
| `braid_b3.g` | $B_3$ irreps | `NullspaceMat`, `TransposedMat`, `E(k)` |
| `braid_hom.g` | Hom objects | `GroupHomomorphismByImages`, `ImageElm` |
| `braid_quotient.g` | $S_N = B_N/\sigma_i^2$ | `Size`, quotient FpGroup |
| `braid_check.g` | Shared helpers | `CheckRep`, `CheckIrreducible2d` |
