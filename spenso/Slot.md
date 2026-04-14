---
finished: false
---

#spenso/TensorStructure/Slot
#computer-science/rust
#math
#physics

# Tensor Slot (`Slot`)

**Motivation.** A tensor “leg” is meaningful only when we know both (1) its symbolic label and (2) the space it lives in. In `spenso`, `AbstractIndex` gives the label, while `Representation` gives the space (Lorentz, Euclidean, etc., plus dimension). `Slot` combines them into one atomic unit that the rest of the structure system can reason about safely.

**Discussion.** In `spenso/src/structure/slot.rs`, the core type is small, but each field carries a specific part of tensor meaning, so it helps to read it line by line.
```rust
pub struct Slot<T: RepName, Aind = AbstractIndex> {
    pub(crate) rep: Representation<T>, // geometric side: space + dimension
    pub aind: Aind,                    // symbolic side: contraction label
}
```
Read this as: a slot is the minimal “geometry + label” package. This is generic in two directions:
- `T`: the representation type (`Lorentz`, `DualLorentz`, `LibraryRep`, ...).
- `Aind`: the abstract-index type (defaults to `AbstractIndex`, but any `AbsInd` can work).

Key behaviors:
- `IsAbstractSlot` trait gives common slot operations (`aind`, `dim`, `reindex`, conversion helpers).
- `DualSlotTo` provides `dual()` and `matches()`.
- `matches()` checks *both* geometry and label: representation dual compatibility and same abstract index.

Why this matters for beginners: in many libraries, these checks happen late at runtime. Here, Rust’s type system helps earlier. For example, `Slot<Lorentz>` and `Slot<DualLorentz>` are distinct types, so upper/lower orientation is explicit in types, not only in comments.

With `shadowing` enabled, slots also convert to Symbolica expressions. A slot may serialize as something like `lor(4,0)`, and lowered dual forms can be wrapped by `dind(...)` so covariance/contravariance survives symbolic transforms.

**Result.** A useful beginner test is to construct one upper Lorentz slot, derive its dual, and then check exactly what `matches()` is validating. The following program does that in the same order you would reason about the math notation:
```rust
use spenso::structure::representation::{DualLorentz, Lorentz, RepName, Representation};
use spenso::structure::slot::{DualSlotTo, IsAbstractSlot, Slot};

// Build the representation first: 4-dimensional Lorentz space.
let lor: Representation<Lorentz> = Lorentz {}.new_rep(4);

// Create one slot with abstract index 0 (think of it as μ).
let mu_up: Slot<Lorentz> = lor.slot(0);

// Flip only the geometric orientation; keep the same abstract label.
let mu_down: Slot<DualLorentz> = mu_up.dual();

// A valid contraction pair needs dual-compatible reps and equal index labels.
assert!(mu_up.matches(&mu_down));
assert_eq!(mu_up.aind(), mu_down.aind());
assert_eq!(mu_up.dim(), mu_down.dim());
```
From this one example, the larger composition chain becomes easier to parse: `Slot` values are assembled into ordered/named structures, those structures parameterize tensor objects, and tensor objects are then connected and contracted in network execution.

**Remark.** `Slot` does not, by itself, store tensor data values; it only describes index structure. Also, compile-time guarantees are strongest when using concrete representation types (`Lorentz`, `DualLorentz`). If you convert to dynamic `LibraryRep`, you gain runtime flexibility but lose some compile-time strictness. This tradeoff is intentional, especially for interop layers like Python bindings.

## Glossary
- **Slot**: Pair of representation + abstract index describing one tensor leg.
- **Representation**: Type-level description of index space and duality behavior (plus dimension when wrapped in `Representation<T>`).
- **Dual representation**: Partner space (for example $V$ and $V^{*}$) used for raising/lowering and valid contractions.
- **Generic type parameter**: Placeholder type in Rust (`T`, `Aind`) that is chosen when the type is used.
- **Default type parameter**: A generic with a fallback (`Aind = AbstractIndex`).
- **Trait bound**: Constraint like `T: RepName` that specifies required behavior.
- **Associated type**: A trait-defined type slot (for example `type Dual` in representation-related traits).
- **Static dispatch**: Compile-time method resolution through generics/traits, often enabling optimizations and stronger checks.
- **Dynamic dispatch / runtime representation**: Behavior chosen at runtime (for example through enums like `LibraryRep`).
- **Type erasure (informal)**: Replacing concrete generic type information with a runtime form, losing some compile-time specificity.
- **`derive` macros**: `#[derive(...)]` auto-implements common traits like `Clone`, `Eq`, `Hash`, `Serialize`.
- **`Copy` vs `Clone`**: `Copy` means cheap implicit bitwise copy; `Clone` is explicit duplication via `.clone()`.
- **`Result<T, E>`**: Rust’s error-handling type for recoverable failures.
- **Feature flag**: Cargo option that conditionally compiles code (`shadowing` here).
- **AST (Abstract Syntax Tree)**: Tree representation of symbolic expressions used by CAS tooling.
- **Contraction**: Summation over repeated compatible indices in tensor algebra.
- **Covariant / contravariant**: Lower-index / upper-index orientation in tensor notation, encoded through representation duality.
