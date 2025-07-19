# Index

Hi! This is the [[knowledge garden]] of [[Wentao Li]], built with [Silverbullet](https://silverbullet.md), containing my notes on [[physics]], [[math]] and [[computer-science]]. After the initial loading (which might take a little while) this website will remain available _even without internet connection_.

## Usage

Blue words are click-able. They are either wiki-links to pages within this [SilverBullet space](https://silverbullet.md/Spaces) or URL links to outside webpages.

The current page is [[index]], click the “house” icon on the upper right corner to get back here. You can search for pages via `Cmd-K` (`Ctrl-K` for Windows), or via clicking the “page” icon. Full text search is available via `Cmd-Shift-F` (`Ctrl-Shift-F` for Windows).

Below are the last 5 edited pages: 

${template.each(query[[
  from index.tag "page"
  order by _.lastModified desc
  limit 5
]], templates.pageItem)}

To see what I’m currently working on, see the [[unfinished pages]].

Pages are organized by tags instead of folders. A complete list of tags is available below. For each `<tag>`, there is a page called `<tag>` which serves as its table of contents, i.e. lists all of its relevant pages and sub-tags.

${query[[from index.tag "tag" where name:startsWith("meta") == false select {Tag = name, Page = "[["..name.."]]"} ]]}

Start wherever you like and click around, but keep in mind you can always search for stuff.

## Background

See [[knowledge garden]].