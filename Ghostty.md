---
tags:
- "workflow"
- "computer-science/tool"
finished: true
---

# [Ghostty](https://ghostty.org/)

The terminal I used. This was to replace the default "Terminal"
app of MacOS, and Ghostty claimed to require little configuration,
so it was a natural choice. I have now converted to NeoVim and
[[WezTerm]], both configurable through Lua.

I use the `zsh` shell; Ghostty should be installed via `homebrew` rather than a `.dmg` file so that the `$PATH` environment variable can be appended with `$GHOSTTY\_BIN\_DIR` upon installation. See [discussions on Github](https://github.com/ghostty-org/ghostty/discussions/4725). Otherwise, the terminal app itself works fine, but upon

```zsh
which ghostty
```

the shell returns `command not found`.

Ghostty is both a terminal app and a CLI tool. Running

```zsh
ghostty ghostty +list-themes
```

would return a very impressive color theme picker running directly in the terminal. Running

```zsh
ghostty +list-keybinds --default
```

produces a list of key bindings provided by default.

In particular, creating splits (via `super + d`) is extremely fast.
