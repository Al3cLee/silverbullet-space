This is where you configure SilverBullet to your liking. See [[Library/Std/Config]] for a full list of configuration options.

```space-lua
config.set("silversearch.tokenizers", {
  ["Library/LelouchHe/silversearch-chinese-tokenizer.js"] = {},
  ["Library/Al3cLee/silversearch-chinese-tokenizer.js"] = {}
})
```

- 这是一些测试文本

```space-lua
config.set {
  actionButtons = {
    {
      icon = "home",
      description = "Go to the index page",
      run = function()
        editor.invokeCommand("Navigate: Home")
      end
    },
    {
      icon = "book",
      description = "Open page",
      run = function()
        editor.invokeCommand("Navigate: Page Picker")
      end
    },
    {
      icon = "search",
      description = "Search",
      run = function()
        editor.invokeCommand("Silversearch: Search")
      end
    },
    {
      icon = "terminal",
      description = "Run command",
      run = function()
        editor.invokeCommand "Open Command Palette"
      end,
    }
  }
}
```
