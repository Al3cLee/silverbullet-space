---
finished: false
---

#spenso/TensorStructure/Slot/AbstractIndex
#computer-science/rust
#math
#symbolic-computation

# Abstract Index (`AbstractIndex`)

**Motivation.** In tensor notation, an index like $\mu$ does two jobs: it gives a *name* to a tensor leg and it helps us decide which legs should contract. In code, we want this label to be richer than a raw integer. `spenso` therefore uses `AbstractIndex` as a dedicated label type, so index naming, dualization hints, dummy-index generation, and symbolic interop can all live in one place. This keeps “what the index is called” separate from “what vector space it belongs to” (that second part is handled by [[spenso/Slot]] and representations).

**Discussion.** `AbstractIndex` is an `enum` (sum type) in `spenso/src/structure/abstract_index.rs`. The main variants are:
- `Normal(usize)`: ordinary user-facing label.
- `Dualize(usize)`: same label value, but marked as dual/lowered in contexts that care.
- `Dummy(usize)`: auto-generated internal label used to avoid collisions during contraction workflows.
- `Added(usize)`: result of index arithmetic (`Add`/`AddAssign` impls).
- `Double(u16, u16)`: compact rational-like encoding used by Symbolica conversions.
- `Symbol(SerializableSymbol)`: symbolic variable index (only with `shadowing` feature).

Rust-side ergonomics are intentionally beginner-friendly:
- `From<usize>`, `From<isize>`, `From<i32>` convert integers into the right variant (negative signed values become `Dualize`).
- `Display` is implemented, so printing an index is straightforward.
- `DummyAind` is implemented, and `new_dummy()` uses an `AtomicUsize` counter, so dummy labels stay unique even if multiple threads create them.

With `shadowing` enabled, `ParseableAind` adds round-trip conversion between `AbstractIndex` and Symbolica `Atom`/`AtomView`, which is essential for symbolic manipulation pipelines.

**Result.** To make this concrete, we can walk through the smallest useful program in three conceptual moves: first we construct ordinary and dualized labels from integers, then we generate two dummy labels to see uniqueness, and finally we combine labels with `Add` to observe how arithmetic is represented at the type level.
```rust
use spenso::structure::abstract_index::AbstractIndex;
use spenso::structure::slot::DummyAind;

// Step 1: Signed/unsigned integer conversions choose semantic variants.
let i = AbstractIndex::from(3usize);     // -> Normal(3)
let j = AbstractIndex::from(-3isize);    // -> Dualize(3)
assert!(matches!(i, AbstractIndex::Normal(3)));
assert!(matches!(j, AbstractIndex::Dualize(3)));

// Step 2: Dummy generation is global and atomic, so IDs do not collide.
let d1 = AbstractIndex::new_dummy();
let d2 = AbstractIndex::new_dummy();
assert_ne!(d1, d2);

// Step 3: Arithmetic does not return a plain number; it records an Added label.
let sum = i + d1;
assert!(matches!(sum, AbstractIndex::Added(_)));
```
This tiny example already shows the design principle in action: `AbstractIndex` preserves semantic intent (`Normal`, `Dualize`, `Dummy`, `Added`) instead of collapsing everything into a single integer too early.

**Remark.** `AbstractIndex` is intentionally only a *label layer*. It does not know dimension, metric signature, or whether contraction is mathematically valid on its own. Those checks happen when you combine the index with a representation in a `Slot`. Also, `Double(_, _)` is not a general numeric index arithmetic type; for example, `Add` on `Double` panics by design. Treat it as an internal encoding variant, mostly for symbolic parsing/serialization.

## Glossary
- **Abstract index**: A symbolic label for a tensor leg (for example $\mu,i$) used to express contraction structure.
- **Concrete index**: A numeric position (`0`, `1`, `2`, …) used to read/write actual tensor components.
- **Enum**: A Rust type that can be one of several named variants (`Normal`, `Dummy`, etc.).
- **Trait**: A Rust interface of shared behavior (`Display`, `From`, `DummyAind`, `ParseableAind`).
- **`impl` block**: Where methods or trait implementations for a type are defined.
- **Generic**: Code parameterized by type (for example, slots can use different index types as long as trait bounds are satisfied).
- **Trait bound**: A requirement like `Aind: AbsInd`, meaning a type must implement a trait to be accepted.
- **Marker trait**: A trait used mainly to constrain types, often with no methods (here, `AbsInd` signals valid abstract-index types).
- **`From` / `Into`**: Standard Rust conversion traits used for ergonomic type conversion.
- **`AtomicUsize`**: A thread-safe integer type for lock-free shared counters.
- **`Ordering::Relaxed`**: An atomic memory ordering that guarantees atomicity for the counter update without stronger synchronization.
- **Dummy index**: Auto-generated internal label used to connect contracted legs safely.
- **CAS (Computer Algebra System)**: Symbolic math engine; here it refers to `symbolica`.
- **Feature flag**: Cargo-controlled compile-time switch (for example `shadowing`) enabling optional functionality.
- **Round-trip conversion**: Converting `AbstractIndex -> Atom -> AbstractIndex` without losing meaning.
- **Panic**: A runtime abort in Rust used for unrecoverable situations; here relevant to unsupported arithmetic on `Double`.
- **Thread-safe**: Safe to use concurrently from multiple threads without data races.
