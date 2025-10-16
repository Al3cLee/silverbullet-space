---
tags:
- "computer-science/tool"
- "computer-science/Linux"
finished: false
---

# zoxide

[Zoxide](https://github.com/ajeetdsouza/zoxide) is a CLI tool written in Rust that adds intelligent ranking and selection to the traditional `cd` command. It remembers the top paths visited and allows fuzzy commands. Use it and type long paths no more.

## Usage

* Install.
* Run `z long/path/somewhere` where the path is exact.
* Run `z`. This tells `zoxide` to remember this path and return to `$HOME`.
* Now, `z somewhere` would call [[fzf]] to search for `somewhere` in the paths it knows, and find the "top choice" defined by `zoxide`'s algorithm. In this case, it take you to `long/path/somewhere`.
* Use `zi <keyword>` to search for `<keyword>` _and produce an interactive choice panel_ (hence the added `i`). This is useful when `<keyword>` appears in many paths known to `zoxide`.
