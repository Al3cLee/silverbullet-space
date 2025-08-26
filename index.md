# Index

Hi! This is the [[knowledge_garden]] of [[Wentao_Li]], built with [Silverbullet](https://silverbullet.md), containing my notes on [[physics]], [[math]] and [[computer-science]]. After the initial loading (which might take a little while) this website will remain available _even without internet connection_.

## Usage

* Blue words are click-able. They are either wiki-links to pages within this [SilverBullet space](https://silverbullet.md/Spaces) or URL links to external webpages.
* The current page is [[index]], click the "house" icon on the upper right corner to get back here.
* You can search for pages via `Cmd-K` (`Ctrl-K` for Windows), or via clicking the "page" icon. On mobile devices, tap with 2 fingers to search.
* Full text search is available via `Cmd-S` (`Ctrl-S` for Windows).
* Dark theme is available via clicking on the "command" icon and selecting "Editor: Toggle Dark Mode". Or, you can simply push this button: ${widgets.commandButton("Editor: Toggle Dark Mode")}

Below are the last 5 edited pages: 

${template.each(query[[
  from index.tag "page"
  order by _.lastModified desc
  limit 5
]], templates.pageItem)}

To see what I’m currently working on, see the [[unfinished_pages]].

Pages are organized by tags instead of folders. A complete list of tags is available below. For each `<tag>`, there is a page called `<tag>` which serves as its table of contents, i.e. lists all of its relevant pages and sub-tags.

${query[[from index.tag "tag" where name:startsWith("meta") == false select {Tag = name, Page = "[["..name.."]]"} ]]}

Start wherever you like and click around, but keep in mind you can always search for stuff.

## Background

See [[knowledge_garden]].