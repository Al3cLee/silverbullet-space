---
finished: true
---

#computer-science/julia
#computer-science/silverbullet

# Add Julia Syntax Highlighting to SilverBullet

## Problem

SilverBullet's CodeMirror 6 integration hardcodes supported fenced code block languages in `client/languages.ts`. Julia is not among them, so ` ```julia ` blocks render without syntax highlighting.

Space-lua's `syntax.define` only creates custom markdown delimiters (like `$...$` for LaTeX) — it cannot add new code block language highlighters.

## Plan

### 1. Clone and enter the SilverBullet repo

```bash
git clone https://github.com/silverbulletmd/silverbullet.git
cd silverbullet
npm install
```

### 2. Add `@plutojl/lang-julia` dependency to `package.json`

In `package.json`, add to the `dependencies` object (alphabetically, between `@codemirror/lang-javascript` and `@codemirror/lang-markdown`):

```json
"@plutojl/lang-julia": "^0.12.2",
```

Check the latest version at <https://www.npmjs.com/package/@plutojl/lang-julia>.

Then install:

```bash
npm install
```

### 3. Add Julia to `lazyLanguages` in `client/languages.ts`

This is the **only source file** that needs modification. Add one entry to the `lazyLanguages` object, alphabetically between `"java"` and `"json"`:

```typescript
julia: async () => (await import("@plutojl/lang-julia")).julia(),
```

Note: `@plutojl/lang-julia` is a native Lezer grammar (like `@codemirror/lang-javascript` or `@codemirror/lang-css`), **not** a legacy StreamLanguage — so no `StreamLanguage.define()` wrapper is needed. The import returns a `Language` directly via `.julia()`.

The module is lazy — it's code-split via dynamic `import()` and only fetched when a ` ```julia ` block is first encountered. No impact on initial load size.

### 4. Build locally

```bash
npm run build
```

This runs both `build:plugs` and `build:client`. The output binary lands in `dist/`.

To run locally for testing:

```bash
dist/silverbullet <path-to-your-space>
```

To install system-wide (optional):

```bash
npm link
```

Or copy the binary from `dist/` to somewhere on your `PATH`.

### 5. Verify

Open any page with a Julia code block and confirm syntax highlighting is active (keywords like `function`, `end`, `struct`, string interpolation `$(...)`, etc. should be colored).

## Files Changed

| File | Change |
|---|---|
| `package.json` | Add `"@plutojl/lang-julia": "^1.0.1"` to `dependencies` |
| `client/languages.ts` | Add `julia` entry to `lazyLanguages` object |

## Notes

- `@plutojl/lang-julia` is a Lezer-based CodeMirror 6 language package maintained by [JuliaPluto](https://github.com/JuliaPluto/lang-julia). It is the standard Julia grammar for CodeMirror 6.
- This change cannot be done from space-lua or any space-level configuration — it requires modifying SilverBullet itself.
- Consider contributing this upstream with a PR to <https://github.com/silverbulletmd/silverbullet> so others benefit.