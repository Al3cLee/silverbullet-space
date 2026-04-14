---
finished: false
---

#spenso/Tutorial/Tensors
#computer-science/rust
#math
#physics

# Tutorial: Constructing a Minkowski Tensor from Scratch

**Motivation.** While higher-level APIs often hide the complexity of tensor construction, understanding how to manually assemble a tensor from its core components is essential for debugging and performance optimization. We want to build a Minkowski metric tensor $g_{\mu\nu}$ using the low-level types defined in the `spenso` source code. This involves a journey from symbolic labels to a fully populated numerical container, ensuring every step respects the library's internal invariants.

**Discussion.** The construction follows a strict linear pipeline. First, we define our **labels** using [[spenso/Abstract_Index]]. Because we want a "symbolic" feel, we use names like "mu" and "nu" instead of raw integers. Next, we define the **space** these indices inhabit using the `Minkowski` [[spenso/Representation]]. Since Minkowski space is self-dual, we don't need to worry about upper/lower index distinctions during the initial space definition.

Once we have labels and a space, we fuse them into **slots** using [[spenso/Slot]]. These slots are the individual "legs" of our tensor. However, a tensor isn't just a list of legs; it needs a canonical [[spenso/Structure]]. When we collect our slots into an `OrderedStructure`, the library may reorder them to satisfy its internal sorting invariants (Self-Dual -> Base -> Dual). We must pay attention to the `PermutedStructure` returned during this process, as it tells us how to align our raw data vector with the final sorted legs. Finally, we wrap the structure and a data vector into a `DenseTensor` as explained in [[spenso/Tensors]].

**Result.** In the following example, we construct a 4D Minkowski metric tensor from the ground up. We use the `shadowing` feature to allow string-based symbolic labels.

```rust
use spenso::structure::abstract_index::AbstractIndex;
use spenso::structure::representation::{Minkowski, BaseRepName};
use spenso::structure::slot::Slot;
use spenso::structure::ordered::OrderedStructure;
use spenso::structure::permuted::PermutedStructure;
use spenso::tensors::data::DenseTensor;

// Step 1: Create symbolic index labels. 
// We use TryFrom to turn strings into AbstractIndex::Symbol variants.
let mu = AbstractIndex::try_from("mu").expect("Valid symbol name");
let nu = AbstractIndex::try_from("nu").expect("Valid symbol name");

// Step 2: Define the 4D Minkowski representation.
let mink = Minkowski::selfless_rep(4);

// Step 3: Create the slots (the 'legs' of our tensor g_mu_nu).
let leg_mu = mink.slot(mu);
let leg_nu = mink.slot(nu);

// Step 4: Assemble into a canonical OrderedStructure.
// The library returns a PermutedStructure to track any reordering.
let perm_struct: PermutedStructure<OrderedStructure<Minkowski>> = 
    vec![leg_mu, leg_nu].into_iter().collect();

// Step 5: Define the numerical data (Metric signature: diag(1, -1, -1, -1)).
// In a 4x4 flat array, the diagonal elements are at indices 0, 5, 10, 15.
let mut data = vec![0.0; 16];
data[0] = 1.0;  data[5] = -1.0; data[10] = -1.0; data[15] = -1.0;

// Step 6: Create the final Tensor.
let g_tensor = DenseTensor::new(perm_struct.structure, data)
    .expect("Data size 16 matches 4x4 structure");

// Verification: Access g_{0,0} which should be 1.0.
let val = g_tensor.get_owned([0, 0]).unwrap();
assert_eq!(val, 1.0);
```
By following this path, we've moved from symbolic abstractions down to a concrete, high-performance data structure.

**Remark.** Why go through all these steps? In "pure" Rust, without using high-level builders, this process guarantees that your tensor is perfectly compatible with the rest of the `spenso` ecosystem (like the network contraction engine). The most common "trap" for beginners is ignoring the `PermutedStructure`—if you define your data assuming one index order but the library sorts it into another, your tensor will produce incorrect results during contraction. Always treat the `OrderedStructure` as the ground truth for your data layout.


## Recommended Learning Path

To fully understand the architecture of `spenso` and the concepts discussed in this tutorial, I recommend the following targeted study path through the [RustBook](https://doc.rust-lang.org/book/):

1. **Foundations (Chapters 1–3):** Get comfortable with the basic syntax, variables, and control flow.
2. **Ownership & Borrowing (Chapter 4):** This is the core of Rust's memory safety model and is critical for understanding `spenso`'s design.
3. **Structuring Data (Chapters 5–6):** Focus on `struct` and `enum` definitions. `spenso` uses `enum` variants (like `AbstractIndex` and `DataTensor`) to model its various states.
4. **Interfaces (Chapter 10):** Study Generics and Traits. This is the heart of `spenso`'s type-safe design, where `Representation` (as a trait) ensures geometric validity at compile-time.

Approach this by reading a chapter, then returning to the relevant `spenso` note to map these new concepts back to the library's implementation.

## Glossary
- **Pipeline**: The sequence of steps (Labels -> Representation -> Slots -> Structure -> Tensor) required to build a tensor.
- **Minkowski**: A specific representation type in `spenso` where the metric is not the identity, eg. $\text{diag}(1, -1, -1, -1)$.
- **Symbolic Index**: An index identified by a name (like "mu") rather than a simple number.
- **`try_from`**: A fallible conversion method in Rust; it returns a `Result` that we must handle.
- **`expect()`**: A method that gets the value from a `Result` or crashes with an error message if the conversion failed.
- **`vec![0.0; 16]`**: Rust syntax for creating a vector of 16 zeros.
- **Diagonal elements**: The components $g_{ii}$ where both indices are the same.
- **Sorting Invariant**: The library's internal rule for how slots must be ordered (e.g., keeping self-dual reps at the front).
- **Contraction Engine**: The part of the library that performs Einstein summation over tensor networks.
- **Duality**: The relationship between upper (contravariant) and lower (covariant) indices. In Minkowski space, this often involves a sign change.
- **`shadowing` feature**: A compile-time option in `spenso` that enables advanced symbolic features like string-named indices.
