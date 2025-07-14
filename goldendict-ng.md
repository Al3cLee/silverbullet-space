---
tags: 
- "computer-science/tool"
- "workflow"
finished: false
---

# Goldendict-ng

The “next-generation” (hence the postfix `-ng`) [Goldendict](http://www.goldendict.org/) program with many [additional features](https://github.com/xiaoyifang/goldendict-ng#some-features-compared-to-the-original-goldendict). It is being actively developed for most major platforms, _including MacOS_, while [Goldendict](https://github.com/goldendict/goldendict) only releases Windows builds. Github repository [here](https://github.com/xiaoyifang/goldendict-ng).

## Full-text search

By design, dictionaries are mappings from entries to articles that explain them, and upon the user’s request, dictionary lookup programs search the list of entries for articles. They _cannot_ search from articles directly. Like Goldendict, Goldendict-ng also supports full-text search. This is probably its most striking advantage over other dictionary lookup programs. 

For example, an English-Chinese dictionary gives Chinese articles that explain English words. With its help the user can translate English into Chinese, but _not the other way round_. In full-text search, however, searching for a Chinese word returns its appearances in articles explaining English entries, which helps the user translate Chinese into English.

## Configuration

* **Quick Lookup.** Add `super + c super + c` to the `Hotkeys` configuration, then tick the box “send translated text to main window” in `Popup`. This way, holding `super` and hitting `c` twice will switch to the main window and look up the selected text. 
