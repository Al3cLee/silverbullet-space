#computer-science/Linux
#computer-science/tool

This is a plugin manager for `zsh`. GitHub repo is [here](https://github.com/zdharma-continuum/zinit). It features “lazy” loading of plugins (known as the Turbo mode in the language of `zinit`) which loads plugins _after_ the shell prompt itself appears. This way new shells can be opened almost instantly without any noticeable lag.

A caveat is that `zinit` uses `zi` as an alias for its command `zinit`, which is also used by the excellent path-jumper [[zoxide]]. A way to circumvent this clash is by adding

```bash
(( ${+aliases[zi]} )) && unalias zi
```

after `zinit` is loaded and before `eval "$(zoxide init zsh)"` is called in your `.zshrc`.

The configuration of `zinit` can take a little while to understand, in particular its two-line syntax of options and its `ice` declaration. My `.zshrc` is as follows, with sensitive info deleted.

```bash
source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"

# Remove zi alias set by zinit (conflicts with zoxide's zi or other tools)
(( ${+aliases[zi]} )) && unalias zi

# Autosuggestions
zinit wait lucid atload'_zsh_autosuggest_start' light-mode for \
    zsh-users/zsh-autosuggestions

# Autocomplete
zinit ice wait lucid
zinit light zdharma-continuum/fast-syntax-highlighting

# Load pure theme
# See https://github.com/zdharma-continuum/zinit/blob/main/README.md#introduction
zinit ice pick"async.zsh" src"pure.zsh" # with zsh-async library that's bundled with it.
zinit light sindresorhus/pure

# FZF
zinit ice wait"1" lucid
zinit snippet OMZP::fzf

# Prompt functions (required for themes)
zinit ice wait lucid
zinit snippet OMZL::prompt_info_functions.zsh

export VISUAL=nvim
export EDITOR="$VISUAL"

# Clean PATH management: Use Zsh's path array for unique additions
typeset -U path=(
    # System and brew paths (prioritize high)
    /usr/local/bin
    /System/Cryptexes/App/usr/bin
    /usr/bin
    /bin
    /usr/sbin
    /sbin
    /opt/homebrew/bin
    /opt/homebrew/Cellar

    # Other path entries
    
    # Add existing PATH for safety
    ${path}
)
export PATH

# User configuration
. "$HOME/.local/bin/env"

# yazi config
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

# Initialize completions (after plugins load)
autoload -Uz compinit && compinit -C

eval "$(zoxide init zsh)"
```