
## matchSubTag(tbl, tag)
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

## noteLink
```space-lua
function pdfLink(path)
  local base = js.window.location.origin
  local name = path:match("([^/]+)$")
  local url
  if base:find("localhost") then
  url = base.."/.fs/"..path
  else
  url = "https://static.wentaoli.xyz/"..path
  end
return "["..name.."]("..url..")"
end

-- function noteLink(noteName) -- Use with just the note project title, no .pdf
    --local base = js.window.location.origin
    --local notePath = base.."/.fs/typeset-notes/"..noteName.."/"..noteName..".pdf"
   -- return "["..noteName..".pdf]("..notePath..")"
-- end

function noteLink(noteName)
  local base = js.window.location.origin
  local notePath

  if base:find("localhost") then
    notePath = base .. "/.fs/typeset-notes/"..noteName.."/"..noteName..".pdf"
  else
    notePath = "https://static.wentaoli.xyz/typeset-notes/"..noteName.."/"..noteName..".pdf"
  end

  return "["..noteName..".pdf]("..notePath..")"
end

function refLink(refName) -- Use with just the reference title, no .pdf
    local base = js.window.location.origin
    local refPath  -- = base.."/.fs/Refs/"..refName..".pdf"

    if base:find("localhost:") then
      refPath = base.."/.fs/Refs/"..refName..".pdf"
    else
      refPath = "https://static.wentaoli.xyz/Refs/"..refName..".pdf"
    end
    return "["..refName..".pdf]("..refPath..")"
end
```

```space-style
.sb-lua-directive-inline:has(.katex-html) {
  border: none !important;
}
```

## Dark Theme
```space-style
html[data-theme="dark"] {
  --root-color: rgb(217,222,232);
  --root-background-color: rgb(52,57,68);
  --top-background-color: rgb(67,72,83);
  --bhs-background-color: rgb(67,72,83);
  --editor-panels-bottom-background-color: rgb(67,72,83);
  --subtle-background-color: rgba(25,26,29,0.4);
}
```

## Tag Page
```space-lua
virtualPage.define {
  pattern = "tag:(.+)",
  run = function(tagName)
    local text = "# 📍"..tagName.."\n\n"
    local allObjects = query[[
      from index.tag(tagName)
      order by ref
    ]]
    local tagParts = tagName:split("/")
    local parentTags = {}
    for i in ipairs(tagParts) do
      local slice = table.pack(table.unpack(tagParts, 1, i))
      if i != #tagParts then
        table.insert(parentTags, {name=table.concat(slice, "/")})
      end
    end
    if #parentTags > 0 then
      text = text .. "## Parent tags\n"
        ..markdown.objectsToTable(parentTags, {
          renderCell=function(value, key)
            if key == "name" then
              return "[[tag:" .. value .."|#"..value.. "]]"
            end
          end  
          }).. "\n\n"
    end
    local subTags = query[[
      from index.tag "tag"
      where string.startsWith(_.name, tagName .. "/")
      select {name="[[tag:"..name.."|#"..name.."]]"}
      order by name
    ]]
    if #subTags > 0 then
      text = text.."## Subtags\n"
      .. markdown.objectsToTable(subTags).."\n\n"
    end
    local taggedPages = query[[
      from p = index.tag "page"
      where matchSubTag(p.tags, tagName)
      select {Page = "[["..p.name.."]]"}
      order by name
    ]]
    if #taggedPages > 0 then
      text = text .. "## Pages\n"
        .. markdown.objectsToTable(taggedPages).. "\n\n"
    end
    local taggedTasks = query[[
      from allObjects where table.includes(_.itags, "task")
    ]]
    
    if #taggedTasks > 0 then
      text = text .. "## Tasks\n"
        .. template.each(taggedTasks, templates.taskItem).. "\n"
    end
    local taggedItems = query[[
      from allObjects where table.includes(_.itags, "item")
    ]]
    
    if #taggedItems > 0 then
      text = text .. "## Items\n"
        .. template.each(taggedItems, templates.itemItem).. "\n"
    end
    local taggedData = query[[
      from allObjects where table.includes(_.itags, "data")
    ]]
    if #taggedData > 0 then
      text = text .. "## Data\n"
        .. markdown.objectsToTable(taggedData) .. "\n"
    end
    local taggedParagraphs = query[[
      from allObjects where table.includes(_.itags, "paragraph")
    ]]
    if #taggedParagraphs > 0 then
      text = text .. "## Paragraphs\n"
        .. template.each(taggedParagraphs, templates.paragraphItem)
        .. "\n"
    end
    return text
  end
}
```

## Light Theme
```space-style
html{
  --editor-width: 1100px;
  
  /*--root-background-color: rgb(256,251,243);*/
  --top-background-color: rgba(248,248,248,0.5);
  --top-border-color: rgb(256,256,256);
  --bhs-background-color: rgb(67,72,83);
  /*--subtle-background-color: rgba(25,26,29,0.4);*/
  --link-color: rgb(59,124,160);
  --ui-accent-color: rgb(59,124,160);
  --modal-hint-background-color: rgb(68,79,207);
  --editor-table-head-background-color: rgb(244,247,254);
  --editor-table-head-color: rgb(75,102,159);
}
```