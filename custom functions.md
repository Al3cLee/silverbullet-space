```space-lua
-- Define a Boolean function that returns true iff
-- the desired <tag> is in the <tbl> or 
-- some <value> in <tbl> starts with <tag>. 
-- The <tbl> is the <tags> of a page.
function matchSubTag(tbl, tag)
  for _, value in ipairs(tbl) do -- The variable _ is the table index.
    if value == tag or string.startsWith(value,tag) then
      return true
    end
  end
  return false
end
```

```space-lua
-- Define a string function that takes the name `pdfName` 
-- and maps to the wikilink to a local document. 
-- Although Lua expressions won't be evaluated inside 
-- double square brackets, we can 
-- put these brackets explicitly around the string output.
function pdfPath(pdfName)
  pathLink = "[[tex-notes/"..pdfName.."/"..pdfName..".pdf]]"
  return pathLink
end
```

```space-lua
latex = {
  header = [[<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.22/dist/katex.min.css">]],
  katex = js.import("https://cdn.jsdelivr.net/npm/katex@0.16.22/+esm")
}

function latex.inline(expression)  
  local html = latex.katex.renderToString(expression, {
    trust = true,
    throwOnError = false,
    displayMode = false
  })
  
  return widget.new {
    html = "<span>" + latex.header + html + "</span>"
  }
end

function latex.block(expression)
  local html = latex.katex.renderToString(expression, {
    trust = true,
    throwOnError = false,
    displayMode = true
  })
  
  return widget.new {
    html = "<span>" + latex.header + html + "</span>"
  }
end 

slashcommand.define {
  name = "math",
  run = function()
    editor.insertAtCursor("${latex.inline[[]]}", false, true)
    editor.moveCursor(editor.getCursor() - 3)
  end
}

slashcommand.define {
  name = "equation",
  run = function()
    editor.insertAtCursor("${latex.block[[]]}", false, true)
    editor.moveCursor(editor.getCursor() - 3)
  end
}
```