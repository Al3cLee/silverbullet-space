---
finished: false
---
  
#computer-science/tool

# opencode LSP Tool

**Motivation.** opencode exposes an experimental Language Server Protocol tool that lets AI agents perform semantic code navigation — go to definition, find references, discover trait implementations, and inspect symbol hierarchies — without resorting to heuristic regex search. This note documents how the tool works, how to test it, and what its current limitations are.

**Discussion.** The LSP tool is gated behind `OPENCODE_EXPERIMENTAL=true` (or `OPENCODE_EXPERIMENTAL_LSP_TOOL=true`). When enabled, it communicates with a running language server (e.g. rust-analyzer for Rust) via the standard LSP protocol over stdio. The agent sends requests through opencode's `lsp` tool invocation; opencode proxies them to the server and returns structured JSON results.

The parameter schema is defined in `packages/opencode/src/tool/lsp.ts`:

```typescript
z.object({
  operation: z.enum([
    "goToDefinition", "findReferences", "hover", "documentSymbol",
    "workspaceSymbol", "goToImplementation", "prepareCallHierarchy",
    "incomingCalls", "outgoingCalls",
  ]),
  filePath: z.string(),
  line: z.number().int().min(1),      // 1-based
  character: z.number().int().min(1),  // 1-based
})
```

## Operations and Observability

Each operation requires a `filePath` (relative or absolute) and a `line`/`character` position (1-based). The `character` must point at or inside the symbol of interest — position sensitivity matters.

| Operation | What it does | Array it returns |
|-----------|-------------|----------------|
| `documentSymbol` | Lists all symbols in a file with hierarchy |  `{name, kind, containerName, range}` |
| `workspaceSymbol` | Searches symbols across the project |  `{name, kind, location}` |
| `goToDefinition` | Resolves a symbol reference to its definition |  locations (URI + range) |
| `findReferences` | Finds all references to a symbol |  locations |
| `goToImplementation` | Finds trait implementations for a type |  locations |
| `hover` | Shows type info and docs for a symbol |  `{contents, range}` (may be null) |
| `prepareCallHierarchy` | Prepares a call hierarchy item for a function |  `{name, kind, detail, range}` |
| `incomingCalls` | Callers of a function  |  call hierarchy items or "No results found" |
| `outgoingCalls` | Callees of a function  |  call hierarchy items or "No results found" |

The `incomingCalls` and `outgoingCalls` operations require `prepareCallHierarchy` first.

## Testing Workflow

Testing LSP operations is different from testing shell commands because the LSP server must be running and have analyzed the project. Here is a repeatable workflow:

1. **Prepare a minimal project** with known symbols. A Rust crate with `Cargo.toml` is ideal — rust-analyzer indexes it on save.
2. **Verify the server is responsive** by running `documentSymbol` on any file. If you get structured results, the server is active.
3. **Test each operation** with a known position on a known symbol. Record whether the result matches expectation.
4. **Compare with rg** by running the equivalent grep-based search and noting what LSP catches that rg misses (and vice versa).

**Observable signals** that LSP is working:
- `documentSymbol` returns a non-empty array of `{name, kind}` objects (kinds: 23=Struct, 12=Function, 8=Field, 6=Variable, etc.).
- `workspaceSymbol` returns symbols across the project when given `line: 1, character: 1` on any project file.
- `findReferences` returns locations across multiple files.
- If you get empty arrays or `"No results found for ..."` messages, the server may be indexing or the position may be wrong.

**Observable signals** that LSP is NOT working:
- The tool returns an error about "no LSP server" or similar.
- `documentSymbol` returns an empty array `[]` on a file that clearly has symbols.
- The `OPENCODE_EXPERIMENTAL` environment variable is not set.

## Proven Results for Rust

Tested on a minimal Rust crate (`testrepo`) with `OPENCODE_EXPERIMENTAL=true`:

| Operation | Result | Notes |
|-----------|--------|-------|
| `documentSymbol` | PASS | Returns structured hierarchy with `containerName` |
| `workspaceSymbol` | PASS | Finds structs across files |
| `goToDefinition` | PASS | Resolves `use` statements through module system |
| `findReferences` | PASS | Finds type-position and constructor references |
| `goToImplementation` | PASS | Finds `#[derive]` expansions for structs |
| `prepareCallHierarchy` | PASS | Returns function signature |
| `incomingCalls` | EMPTY | Returned no callers despite `main()` calling the function — likely rust-analyzer limitation |
| `outgoingCalls` | EMPTY | Same limitation as incomingCalls |
| `hover` | PARTIAL | Position-sensitive; may return generic keyword docs |

**Result.** The LSP tool is functional for 6 of 9 operations. The call hierarchy operations (`incomingCalls`/`outgoingCalls`) returned empty in our test project — this may be a rust-analyzer limitation for small/simple call graphs. The 5 core operations (`workspaceSymbol`, `goToDefinition`, `findReferences`, `goToImplementation`, `documentSymbol`) work reliably and provide significant advantages over regex-based search for Rust projects.

**Remark.** Position sensitivity is the main usability concern: `goToImplementation` must target the struct/enum definition line itself, not the `struct` keyword or a `#[derive]` attribute above it. Similarly, `findReferences` requires the character to be on or inside the symbol name. When using the LSP tool in skills like [[repo-ripper]], always call `documentSymbol` or `workspaceSymbol` first to locate the exact position, then use that position for subsequent operations.

The call hierarchy operations (`incomingCalls`/`outgoingCalls`) are useful when they work but should not be the sole source of call-graph information — always fall back to `findReferences` and `rg` pattern matching as a safety net. This is reflected in the [[repo-ripper]] skill's Rust LSP Enhancement section, which uses `findReferences` for cross-reference discovery and only supplements with call hierarchy.

## Language-Specific Behavior

### Julia (LanguageServer.jl)

Julia's multiple dispatch creates a semantic distinction that does not exist in Rust or most other languages. Two operations that are nearly synonymous in Rust — `goToImplementation` and `findReferences` — diverge significantly in Julia:

| Operation | On `AbstractAnimal` (abstract type) | On `fight` (function) |
|-----------|--------------------------------------|----------------------|
| `goToImplementation` | All concrete subtypes: `Dog`, `Cat`, `Cock`, `Human` | All method dispatches (6 methods) |
| `findReferences` | Every place `AbstractAnimal` appears in type annotations, `where` clauses, method signatures | All call sites + all method definitions |

In Rust, `goToImplementation` finds **trait implementations** (`impl Debug for FooBar`). In Julia, `goToImplementation` on an abstract type finds **subtypes** and on a function finds **method dispatches**. This makes `goToImplementation` the single most valuable LSP operation for Julia projects, because it embodies Julia's core semantic model: types defined by their subtypes and functions defined by their methods.

**Motivation.** The `opencode` built-in `julials` server consistently failed with "Connection is closed" errors. `LanguageServer.jl` takes much time to start, and after lengthy debugging I still wasn’t able to get it working with opencode. A more fundamental alternative is [[JETLS]], which ships as a standalone compiled executable rather than a Julia package.

**Discussion.** JETLS is installed as a Julia app via `Pkg.Apps`:

```bash
julia -e 'using Pkg; Pkg.Apps.add(; url="https://github.com/aviatesk/JETLS.jl", rev="release")'
```

This places the `jetls` binary at `~/.julia/bin/jetls`. The opencode configuration in `~/.config/opencode/opencode.json` disables the broken built-in `julials` entry and adds a custom `jetls` entry:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "lsp": {
    "julials": {
      "disabled": true
    },
    "jetls": {
      "command": [
        "jetls",
        "serve",
        "--stdio"
      ],
      "extensions": [".jl"]
    }
  }
}
```

After restarting opencode, all LSP operations work correctly. `documentSymbol` returns the full type hierarchy, `hover` returns formatted markdown with struct fields and supertype chains, and both `goToDefinition` and `goToImplementation` resolve correctly across files.

**Result.** JETLS is the working Julia LSP server for opencode. The `julials` (LanguageServer.jl) approach is unreliable because it depends on LanguageServer.jl being globally installed, starts slowly (~20–30 s), and requires explicit `--project` flag management. JETLS is a compiled executable that starts in under a second and requires no project-specific configuration.

**Remark.** opencode's LSP client is hardwired to communicate over stdio: it reads from `process.stdout` and writes to `process.stdin` using `vscode-jsonrpc`'s `StreamMessageReader`/`StreamMessageWriter` (see `packages/opencode/src/lsp/client.ts`). JETLS also supports pipe (`--pipe-listen`, `--pipe-connect`) and TCP socket (`--socket`) modes, but opencode has no code to initiate those connections. The `--stdio` flag is therefore the only viable option.

---

**Motivation.** JETLS's documentation includes a warning: *"When using stdio mode, any `println(stdout, ...)` in your code or dependency packages may corrupt the LSP protocol and break the connection."* This is worth understanding precisely, since opencode cannot use the safer pipe or socket modes.

**Discussion.** In stdio mode, the LSP JSON-RPC byte stream is carried over the same stdin/stdout as the Julia process itself. The protocol is length-prefixed:

```
Content-Length: 97\r\n
\r\n
{"jsonrpc":"2.0","id":1,"method":"textDocument/hover",...}
```

opencode reads `Content-Length: N` and then reads exactly N bytes of JSON. Any foreign byte — even a single character — written to stdout causes the parser to lose sync permanently, with no recovery. JETLS analyzes Julia source files by loading and type-checking them, which means it executes `using SomePackage` internally. If any of those packages prints to stdout inside their `__init__()` function, the output corrupts the stream.

The key distinction is between top-level code and `__init__`. Top-level module code runs only at precompile time, is serialized into the `.ji` cache, and is never re-executed when the package is loaded at runtime. The `__init__()` function, by contrast, is designed to run every time the package is loaded — precisely because it handles runtime-only setup (C library state, hardware connections, etc.) that cannot be serialized. This makes `__init__` the sole danger zone.

The risk is therefore package-specific. Well-maintained packages use `@info` and `@warn` (which go to stderr, not stdout) for any runtime messages. A small number of packages, historically in the scientific computing ecosystem, print banners or status messages via `println` in `__init__`. The canonical example is Nemo.jl (computer algebra), which prints a welcome banner controllable only via `ENV["NEMO_PRINT_BANNER"] = "false"`. Polymake.jl is another known offender. The Julia community generally regards this practice as "user-hostile" (Kristoffer Carlsson, Julia Discourse, 2020) and it has become rarer in newer packages.

**Result.** A project is safe in stdio mode if none of its transitive dependencies call `println(stdout, ...)` (or bare `println`, `print`) inside `__init__()`. The safe alternative for package authors is to use `@info`/`@warn`, which route through Julia's logging system to stderr. For a given project, the risk can be assessed by checking whether any dependency has a `println`/`print` call in its `__init__` function. For projects with no external dependencies (stdlib only), the risk is zero.

**Remark.** The `println` calls in `main.jl` of a script-style Julia project are not a concern: JETLS never executes script files, it only parses and statically analyzes them. The risk materializes only through packages that JETLS loads via `using`. A quick audit suffices: search the source of each direct dependency for `println` or `print(` inside `__init__` blocks. The `Suppressor.jl` package exists to redirect stdout for blocks of user-controlled code (`@suppress begin ... end`), but it cannot help with JETLS's own internal `using` calls — only the package author or a pipe/socket transport can fix that problem structurally.

---

**Motivation.** For a project with many dependencies, manually inspecting every `__init__` function for `println` calls is impractical. A faster empirical test is possible by exploiting the fact that `@info`/`@warn` go to stderr while `println` goes to stdout — the two can be cleanly separated at the shell level.

**Discussion.** Running the following suppresses stderr entirely and leaves only stdout visible:

```bash
julia --project=. --startup-file=no -e 'using PackageA, PackageB' 2>/dev/null
```

If the terminal stays blank, no dependency wrote to stdout during loading and the project is safe for stdio mode. For a project with many direct dependencies, enumerate them automatically from `Project.toml` rather than typing them by hand:

```bash
julia --project=. --startup-file=no -e '
import Pkg
for name in keys(Pkg.project().dependencies)
    @eval using $(Symbol(name))
end
' 2>/dev/null
```

This loads every direct dependency and, by extension, all transitive dependencies those packages pull in — since `__init__` runs for every package in the transitive closure, any offending transitive package will emit its stdout output when the direct dep that loads it is `using`-ed. There is no need to enumerate transitive dependencies separately.

One subtlety: on the first run, Julia may precompile packages and emit `[ Info: Precompiling ... ]` messages. These go to stderr and are suppressed by `2>/dev/null`. On a warm cache (second run), only runtime `__init__` output remains. Running the script twice ensures a clean result.

**Result.** A blank terminal after the second run of the above script is a reliable green light: no dependency in the transitive closure writes to stdout at load time, and JETLS stdio mode is safe for this project.

**Remark.** The REPL (`julia> using Foo`) gives the same information in principle but is harder to interpret: the REPL renders stderr-level messages (`@warn`, precompilation info) inline, making it difficult to distinguish stdout from stderr by eye. The shell script with `2>/dev/null` gives an unambiguous answer.
