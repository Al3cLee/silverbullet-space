---
finished: false
---

#spenso/TensorStructure/Slot/Representation
#computer-science/rust
#math
#physics

# Tensor Representation (`Representation`)

**Motivation.** In tensor algebra, indices like $\mu, \nu$ are not just labels; they are tied to specific mathematical spaces with distinct properties: dimension, metric signature (e.g., Minkowski vs Euclidean), and duality behavior (how they transform when raised or lowered). A raw index label needs this geometric context to become physically meaningful. `spenso` handles this by separating the label ([[spenso/Abstract_Index]]) from its geometric property (`Representation`), allowing the same labels to be reused across different spaces while maintaining strict mathematical consistency. These two are eventually combined into a [[spenso/Slot]].

**Discussion.** The representation system is built on a trait-first architecture to maximize compile-time safety. The `RepName` trait is the core interface, defining how a space behaves: its `Dual` type, its `Orientation` (directed/undirected), and its metric behavior (`is_neg`). 

For common spaces like `Lorentz` or `Minkowski`, the library provides concrete struct implementations:
```rust
#[derive(Default, ...)]
pub struct Minkowski {}
```
Because these are simple unit structs that derive `Default`, you can construct them using `Minkowski {}` or `Minkowski::default()`. These structs then satisfy traits like `RepName` and `BaseRepName`, which enable the library to treat them as valid geometric spaces in a type-safe way.

- **Static Dispatch**: When the index space is known at compile time, we use generic types like `Slot<Lorentz>`. This allows Rust to prevent nonsense like contracting a Lorentz index with a Color index before the code even runs.
- **Dynamic Dispatch**: For cases where indices must be handled at runtime (e.g., Python API or dynamic registries), `LibraryRep` provides an enum-based representation that erases specific types into a unified registry.
The `Representation<T>` struct wraps a `RepName` with a `Dimension`, which can be concrete (e.g., 4) or symbolic (e.g., $D$).

**Result.** To see this in practice, we can create a 4-dimensional Lorentz representation and then derive its dual to ensure they are mathematically consistent for contraction.
```rust
use spenso::structure::representation::{Lorentz, DualLorentz, RepName, BaseRepName, Representation};

// Step 1: Default-construct a Lorentz representation name.
let lor_name = Lorentz::default();

// Step 2: Wrap it with a dimension to get a full Representation object.
let minkowski_space: Representation<Lorentz> = lor_name.new_rep(4);

// Step 3: Duality is handled via trait-associated types.
let dual_space: Representation<DualLorentz> = minkowski_space.dual();

// They are distinct types, but they 'match' for valid contraction logic.
assert!(minkowski_space.rep.matches(&dual_space.rep));
```
This shows how the type system tracks "contravariant" vs "covariant" spaces explicitly, rather than just relying on sign conventions in index labels.

**Remark.** The design principle here is "make invalid states unrepresentable." By making `Lorentz` and `DualLorentz` distinct types, `spenso` forces the user (or the library's internal logic) to acknowledge the duality transformation. A key edge case is `Euclidean` or `Minkowski` (inline metric) spaces which are "self-dual": for these, `dual()` returns the same type, reflecting the physical reality that raising/lowering doesn't change the transformation behavior in those bases.

## Glossary
- **Representation**: The mathematical space (vector space) an index belongs to, defining its dimension and metric.
- **Self-dual**: A representation where the base and dual spaces are identical (e.g., Euclidean).
- **Dualizable**: A representation with distinct upper (base) and lower (dual) forms.
- **Metric signature**: The pattern of $\pm 1$ signs in the space's metric (e.g., $+---$).
- **Orientation**: Whether a space distinguishes between "source" and "target" (directed vs undirected).
- **LibraryRep**: A runtime-dynamic representation used when compile-time types are not enough.
- **Trait-first architecture**: A design where behavior is defined by traits first, allowing different implementations (static vs dynamic) to share the same logic.
- **Static Dispatch**: Choosing the code to run at compile-time based on types.
- **Dynamic Dispatch**: Choosing the code to run at runtime, often via vtables or enum matching.
- **Associated type**: A type defined within a trait (like `type Dual`) that differs for each implementation.
- **Symbolic Dimension**: A dimension represented as a variable (e.g., $D$) rather than a fixed integer.
