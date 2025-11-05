---
tags: 
- "computer-science/tool"
- "workflow"
finished: true
---

# Goldendict-ng

The “next-generation” (hence the postfix `-ng`) [Goldendict](http://www.goldendict.org/) program with many [additional features](https://github.com/xiaoyifang/goldendict-ng#some-features-compared-to-the-original-goldendict). It is being actively developed for most major platforms, _including MacOS_, while [Goldendict](https://github.com/goldendict/goldendict) only releases Windows builds. Github repository [here](https://github.com/xiaoyifang/goldendict-ng).

## Full-text search

By design, dictionaries are mappings from entries to articles that explain them, and upon the user’s request, dictionary lookup programs search the list of entries for articles. They _cannot_ search from articles directly. Like Goldendict, Goldendict-ng also supports full-text search. This is probably its most striking advantage over other dictionary lookup programs.

For example, a uni-directional English-Chinese dictionary gives Chinese articles that explain English words. With its help the user can translate English into Chinese, but _not the other way round_. In full-text search, however, searching for a Chinese word returns the English entries it helps to explain, _which probably includes its English translation._ Therefore, a uni-directional dictionary becomes bi-directional under full-text search.

There are many more benefits to full-text search than bidiretional translation. Because it expands the scope of searching, full-text search usually returns richer content, and the user is more likely to chance upon interesting language facts. Of course there is penalty; the user has to sort through the often numerous and distracting search results to find useful information.

## Configuration

* Quick Lookup. Add `super + c super + c` to the `Hotkeys` configuration, then tick the box “send translated text to main window” in `Popup`. This way, holding `super` and hitting `c` twice will switch to the main window and look up the selected text.
* [[Anki]] integration. Follow the [relevant documentation](https://xiaoyifang.github.io/goldendict-ng/topic_anki/) and configure Goldendict-ng to add an article to Anki as a card, but note that at any given time, _there can only be one target Anki deck_.
