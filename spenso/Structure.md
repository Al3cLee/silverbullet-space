---
finished: false
---

#spenso/TensorStructure/Structure
#computer-science/rust
#math
#physics

# Tensor Structure (`Structure`)

**Motivation.** If a [[spenso/Slot]] is a single bone, then a **Structure** is the complete skeleton. To perform tensor contractions or symbolic simplifications, the library cannot just work with a loose bag of legs. It needs a canonical, sorted "body plan" that describes how many legs there are, which mathematical spaces they belong to, and their orientation. In `spenso`, this is achieved by the `OrderedStructure` type, which ensures that indices are always sorted in a predictable way regardless of how the user provided them.

**Discussion.** The primary implementation is `OrderedStructure<R, Aind>`. While it stores a simple `Vec<Slot>`, it enforces a strict **sorting invariant** internally. It divides the slots into three distinct segments:
1.  **Self-Dual**: Spaces where the dual is the same as the base (e.g., Euclidean or Minkowski).
2.  **Base**: Non-self-dual spaces in their "base" form (typically contravariant or "upper" indices).
3.  **Dual**: Non-self-dual spaces in their "dual" form (typically covariant or "lower" indices).

This sorting is crucial because it allows the library to perform extremely fast graph-matching during network contraction. Instead of searching through all legs to find a match, it can jump directly to the relevant slice. When you want to add semantic context like a tensor's name (e.g., "$\gamma$"), you wrap the ordered structure into a `NamedStructure`. 

A key beginner concept is that the construction methods often return a `PermutedStructure<S>`. Since the library reorders your slots to satisfy its sorting invariant, it gives you back a "receipt" (a permutation) telling you exactly how your original order was changed. You will need this receipt later to align your raw numerical data with the tensor's internal legs.

**Result.** Here we construct a structure for a tensor with one upper Lorentz index and one lower Lorentz index. Notice how the library returns a `PermutedStructure` wrapper.

```rust
use spenso::structure::representation::{Lorentz, Representation, BaseRepName};
use spenso::structure::slot::Slot;
use spenso::structure::ordered::OrderedStructure;
use spenso::structure::permuted::PermutedStructure;

// 1. Prepare the building blocks (4D Lorentz)
let lor = Lorentz::selfless_rep(4);
let mu_up = lor.slot(0);    // upper index
let mu_down = mu_up.dual(); // lower index

// 2. Combine them into a raw list (in our chosen order)
let legs = vec![mu_down, mu_up];

// 3. Let the library build the canonical 'Ordered' structure
let perm_struct: PermutedStructure<OrderedStructure<Lorentz>> = 
    legs.into_iter().collect();

// Access the sorted internal structure
let sorted = &perm_struct.structure;

// Observe the sorting: Base (up) comes BEFORE Dual (down)
assert_eq!(sorted.get_slot(0).unwrap(), mu_up);
assert_eq!(sorted.get_slot(1).unwrap(), mu_down);

// Step 4: The 'inverse' tells us how to map our original data 
// to this new sorted skeleton.
println!("Permutation applied: {}", perm_struct.index_permutation);
```
The library takes care of the "canonicalization" so that any two tensors with the same legs will always have the same internal `OrderedStructure`, making them easy to compare or contract.

**Remark.** Why do we care about sorting? In a complex tensor network with hundreds of indices, checking for compatibility is the bottleneck. By forcing a specific order (Self-Dual - Base - Dual), the library transforms a $O(N^2)$ search problem into a near $O(1)$ lookup. The `PermutedStructure` is the essential bridge: it allows the library to be fast and rigid internally, while letting the user be flexible with how they define their tensors.

## Glossary
- **Structure**: The canonical "skeleton" of a tensor, defining the ordered sequence of its slots.
- **OrderedStructure**: The concrete type that enforces the sorting invariant (Self-Dual -> Base -> Dual).
- **NamedStructure**: A structure wrapper that adds a global name (e.g., "Metric") and additional arguments.
- **Sorting Invariant**: A rule that must always be true (here, the specific order of slots).
- **`Vec<T>`**: Rust's standard growable array type (Vector).
- **`collect()`**: A Rust method that turns an iterator (a stream of items) into a collection like a `Vec` or a `Structure`.
- **Permutation**: A record of how a list of items was reordered.
- **`unwrap()`**: A Rust method to get the value out of an `Option` or `Result`, panicking if it's empty. Use sparingly!
- **`Option<T>`**: A Rust type that represents a value that might be there (`Some`) or might be missing (`None`).
- **Graph Matching**: The process of finding which legs connect to each other in a network.
- **Canonical form**: A standard way of representing data so that equivalent items look identical.
- **Contravariant / Covariant**: Physicist terms for "upper" (Base) and "lower" (Dual) indices.
