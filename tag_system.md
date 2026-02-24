---
finished: true
---

#workflow

# Tag system

File systems on computers typically consist of folders, and each file must belong to one and _only one_ folder. This is not how the ideas of a human being naturally behave.

An idea might be related to many topics. The topics themselves fit nicely into a tree-like structure: a subject has sub-fields, e.g. quantum mechanics is a sub-topic of physics.

It is therefore sensible to arrange ideas (and more generally speaking, any information) flatly inside _one_ big folder, and upon creating each piece of information, attach it to various topics by tagging it.

Each object in SilverBullet has a main `tag` which is its “data type”, e.g. page, task, item, etc. Then, it has some extra `tags` (a Lua array) that indicate its topics.

For example, [[second_quantization]] belongs to topics #physics/quantum-field-theory and #physics/condensed-matter. So its `tag` is `"page"` while its `tags` is a Lua array of two items.

Tags are very helpful when you want to retrieve information from a collection of notes. Instead of searching or clicking through a folder, you can [query](https://silverbullet.md/Space%20Lua/Lua%20Integrated%20Query) this collection, just like asking questions to a human. For example, you can query for pages that simultaneously fall under two different topics. SilverBullet has [[Library/Std/Infrastructure/Query Templates]] that help you write queries quickly.

At https://silverbullet.md/Tag there is more information about how tags work in SilverBullet. The page [[custom_functions]] contains some Lua scripts which help query pages via their tags.

---

In the database version of Logseq, there are also two kinds of tags: the main `tag` indicating the type of “stuff” an element is, and some `properties` serving as extra metadata.
