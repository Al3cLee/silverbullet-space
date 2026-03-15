
👋 Welcome! This is the [[knowledge_garden]] of [[Wentao_Li]], built with [Silverbullet](https://silverbullet.md), containing my notes on [[tag:physics|physics]], [[tag:math|math]] and [[tag:computer-science|computer science]]. 

## Performance Tip

The initial loading may take a little while, since this website is _not_ static `html`, instead it is a full-fledged web application in read-only mode. After the initial loading, this website will remain available _even without internet connection_.

To obtain the best viewing (and editing!) experience, deploy this website locally to instantly load everything, including attachments. To see how, visit [[README]] or [[README_ZH]]. If accessed online, most content will load fairly quickly, but long academic papers appearing in pages entitled “Refs/...” will take a few seconds to load.

## How To Use This Website

- Blue words are click-able. They are either wiki-links to pages within this [SilverBullet space](https://silverbullet.md/Spaces) or URL links to external webpages.

- The current page is [[index]], click the "home" button on the upper right corner to get back here. You can search for pages via `Cmd-K` (`Ctrl-K` for Windows), or via clicking the "book" button.

- Full-text search is available via the "search" button. If the search is slow or keeps saying “Loading...”, click the "terminal" button and run the command "Silversearch: Reindex".

- Dark theme is available via clicking on the "command" button and selecting "Editor: Toggle Dark Mode". Or, you can simply push this button: ${widgets.commandButton("Editor: Toggle Dark Mode")}

- On mobile devices, click on the three dots button to view the various buttons.

- The source code of this website is hosted on GitHub, see [[README]] or [[README_ZH]]. All PDF notes typeset with `Typst` or `LaTeX` are also source-controlled in the GitHub repository, so cloning the repository also allows you to do a _really_ full-text search.

Below are the last 5 edited pages:

${query[[
  from index.tag "page"
  select {Page = "[[".. name .."]]"}
  order by lastModified desc
  limit 5
]]}

To see what I’m currently working on, see the [[unfinished_pages|unfinished pages]].

## Tags

Pages are organized by tags instead of folders. A complete list of tags is available below, but you can always explore tags via the command “Navigate: Tag Picker”. For each tag `<tagName>`, there is a page called `tag:<tagName>` which serves as its table of contents, i.e. lists all of its relevant pages and sub-tags.

Clicking on a hashtag like #this-one will bring you to its page. Such pages have titles like

* `📍 tagName`

and as the name suggests, they help you navigate this space, just like pins on a map. For more details on tags, see [[tag_system]].

${query[[from index.tag "tag" where name:startsWith("meta") == false and name:startsWith("maturity")==false select {Page = "[[tag:"..name.."|"..name.."]]"} order by name ]]}

Start wherever you like and click around, but keep in mind you can always search for stuff.
