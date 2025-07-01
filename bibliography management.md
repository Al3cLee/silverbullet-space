---
tags: 
- "workflow"
- "computer-science/tool"
finished: true
---

# Bibliography management

To property address the reference, e.g. books or journal articles, in academic writing one needs to 

* indicate that some words or ideas are cited from some reference, and
* provide information about the cited references in a dedicated part of the written work, typically at its end.

The first task is known as providing in-line _citation_, and the second task is known as adding _bibliography_. Both give information about _references_ relevant to one’s current work.

These two tasks are often subject to rigid formatting conventions, e.g. [APA style](https://apastyle.apa.org/), [MLA style](https://www.mla.org/MLA-Style) or [_Nature_ journal style](https://www.nature.com/nature/for-authors/formatting-guide) (see the section “References” on this website), but manually adjusting the formatting is tedious. This motivates automating the formatting process. 

---

Automating the formatting of citations and the bibliography can be realized by dividing labor between the author and the writing software. The author points the software to some reference, and the software takes care of all formatting.

For the software to locate the reference we are pointing to, a unique identifier can be assigned to each reference. For example, a book can be uniquely identified by its ISBN number, an online talk by its Youtube URL. However, such identiers could be confusing to the human eye, since they are not written in natural language. This calls for the use of _bibliography keys_ which are human-readable, unique pointers to references. 

So now the workflow becomes

* the author points to a bibliography key in-line when a reference should be cited,
* the software locates the reference associated to the key and formats the citation,
* the author indicates at the end of the document that a bibliography section should be included and that it bears certain styles,
* the software formats the bibliography section as requested.

---

In particular, there are two types of bibliography management softwares:

* modules provided by writing softwares that can format citations and bibliographies, e.g. the [[BibLaTeX]] package of LaTeX, and
* bibliography database softwares that maintain a collection of references, their metadata and attachments, e.g. [Zotero](https://www.zotero.org/).

Together they form a complete bibliography management pipeline.
