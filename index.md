# Index

👋 Welcome! This is the [[knowledge_garden]] of [[Wentao_Li]], built with [Silverbullet](https://silverbullet.md), containing my notes on [[tag:physics|physics]], [[tag:math|math]] and [[tag:computer-science|computer science]]. After the initial loading (which might take a little while) this website will remain available _even without internet connection_.

The source code of this website is available on GitHub; see [[README]] or [[README_ZH]]. This means you can deploy this very website as a web application locally on your machine. Also, all PDF notes typeset with `Typst` or `LaTeX` are source-controlled with this space, so cloning the repository also allows you to do a _really_ full-text search.

## Usage

- Blue words are click-able. They are either wiki-links to pages within this [SilverBullet space](https://silverbullet.md/Spaces) or URL links to external webpages.

- The current page is [[index]], click the "home" button on the upper right corner to get back here.You can search for pages via `Cmd-K` (`Ctrl-K` for Windows), or via clicking the "book" button. On mobile devices, tap with 2 fingers to search for pages.

- Full-text search is available via the "search" button. If the search is slow or keeps saying “Loading...”, click the rightmost "terminal" button and run the command "Silversearch: Reindex".

- Dark theme is available via clicking on the "command" button and selecting "Editor: Toggle Dark Mode". Or, you can simply push this button: ${widgets.commandButton("Editor: Toggle Dark Mode")}

- On mobile devices, click on the three dots button to view the various buttons.

Below are the last 5 edited pages:

${template.each(query[[
  from index.tag "page"
  order by _.lastModified desc
  limit 5
]], templates.pageItem)}

To see what I’m currently working on, see the [[unfinished_pages|unfinished pages]].

## Tags

Pages are organized by tags instead of folders. A complete list of tags is available below. For each tag `<tagName>`, there is a page called `<tag:tagName>` which serves as its table of contents, i.e. lists all of its relevant pages and sub-tags.

Clicking on a hashtag like #this-one will bring you to its page. Such pages have titles like `📍 blabla`, and as the name suggests, they help you navigate this space, just like pins on a map. For more details on tags, see [[tag_system]].

${query[[from index.tag "tag" where name:startsWith("meta") == false and name:startsWith("maturity")==false select {Page = "[[tag:"..name.."|"..name.."]]"} order by name ]]}

Start wherever you like and click around, but keep in mind you can always search for stuff.
