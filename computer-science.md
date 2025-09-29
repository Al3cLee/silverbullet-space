Here lists all pages tagged with `computer-science` or its subtags.

Tags under `computer-science` are
${query[[from index.tag "tag" where string.startsWith(name, "computer-science") select name]]}

Pages tagged with `computer-science` or its subtags are
${template.each(query[[from index.tag "page" where matchSubTag(tags, "computer-science")]], templates.pageItem)}
