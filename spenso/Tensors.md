---
finished: false
---

#spenso/Tensor
#computer-science/rust
#math
#physics

# Tensors (`DataTensor`)

**Motivation.** Now that we have a [[spenso/Structure]] (the skeleton), we need to fill it with numerical or symbolic values (the "flesh"). In most physics applications, we either have a few non-zero components (Sparse) or a completely filled block of data (Dense). `spenso` provides a unified `DataTensor` enum that lets you switch between these storage strategies without changing the rest of your contraction logic.

**Discussion.** The library primarily uses `DenseTensor<T, I>` and `SparseTensor<T, I>`. Both are grouped under the `DataTensor` enum.
-   **`DenseTensor`**: Stores values in a contiguous `Vec<T>`. This is fastest for most calculations where the tensor is small or mostly full.
-   **`SparseTensor`**: Stores values in a `HashMap`, where the key is a `FlatIndex`. This is essential for high-dimensional tensors (like those in many-body physics) where storing every zero would crash your memory.

The "volume" of a tensor is the product of its dimensions. For a `DenseTensor`, your input `Vec<T>` must have exactly this many elements. The library maps your multi-dimensional "expanded" indices (eg. $[0, 1, 3]$) to a single "flat" index (an integer) based on the order of slots in the [[spenso/Structure]].

**Result.** Here we create a functional 2x2 Dense tensor. We reuse the `PermutedStructure` from the [[spenso/Structure]] note to ensure our raw data correctly matches the library's sorted skeleton.

```rust
use spenso::structure::representation::{Lorentz, BaseRepName};
use spenso::structure::ordered::OrderedStructure;
use spenso::structure::permuted::PermutedStructure;
use spenso::tensors::data::DenseTensor;

// 1. Build the structure (e.g., a 2x2 matrix)
let lor = Lorentz::selfless_rep(2);
let legs = vec![lor.slot(0), lor.slot(1)];
let perm_struct: PermutedStructure<OrderedStructure<Lorentz>> = 
    legs.into_iter().collect();

// 2. Prepare raw data (a 2x2 identity matrix flattened)
let raw_data = vec![1.0, 0.0, 0.0, 1.0];

// 3. Assemble the Tensor
// We use .structure because DenseTensor expects the sorted version.
let tensor = DenseTensor::new(perm_struct.structure, raw_data)
    .expect("Data size must match structure volume (2x2=4)");

// 4. Access a component (index 0, 0)
let val = tensor.get_owned([0, 0]).unwrap();
assert_eq!(val, 1.0);
```
Note that if your `PermutedStructure` applied a swap, your `raw_data` would need to be permuted accordingly *before* calling `new()`, or you should use the library's transformation methods after construction.

**Remark.** The power of `DataTensor` is its genericity over the scalar type `T`. You can use `f64` for basic physics, `Complex<f64>` for quantum mechanics, or even `Atom` (from Symbolica) for pure symbolic algebra. Because the structure is decoupled from the data, the library can often perform "upgrades"—for example, multiplying a real tensor by a complex one and automatically returning a complex result.

## Glossary
- **`DataTensor`**: The top-level enum in `spenso` for any tensor that contains actual values.
- **`DenseTensor`**: A tensor that stores all values (including zeros) in a contiguous array.
- **`SparseTensor`**: A tensor that only stores non-zero values in a hash map.
- **Flat Index**: A single integer representing a position in the flattened data array.
- **Expanded Index**: A multi-dimensional coordinate (e.g., $[i, j, k]$) used to address tensor components.
- **Volume**: The total number of components in a tensor (product of all slot dimensions).
- **`f64`**: A standard 64-bit floating point number (real number).
- **`Complex<f64>`**: A complex number (real + imaginary parts).
- **`expect()`**: A Rust method that gets a value or crashes with a specific error message if it's missing (similar to `unwrap()`).
- **`get_owned()`**: A method to retrieve a copy of a tensor component at a specific expanded index.
- **Genericity**: The ability of code to work with different types (e.g., the same `DenseTensor` code works for both `f64` and `Complex`).
- **Scalar Type (`T`)**: The type of the individual numbers stored inside the tensor.
