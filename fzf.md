---
tags:
- "computer-science/Linux"
- "workflow"
finished: true
---

# fzf

[Fzf](https://github.com/junegunn/fzf) is an interactive command-line tool which takes some input, _live_ searches inside it with a fuzzy algorithm and produces (or even previews) the result.

## Examples

- **Command history.** `Ctrl+R` to search command history.
- **File viewing.** `cat <file> | fzf` to search in `<file>`. Because `fzf` is interactive, this is better than simply `vim <file> /<pattern>`.
- **Integration with `cd`.** `Opt+C` to search and `cd` into a directory.
- **Autocompletion.** `** Tab` triggers autocompletion with `fzf`.
