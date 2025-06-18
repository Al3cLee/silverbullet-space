The subtags of `physics` are:
${query[[from index.tag "tag" where name:startsWith("physics/") select name]]}

The pages tagged with `physics` or its subtags are:
${template.each(query[[
  from index.tag "page"
  where matchSubTag(tags, "physics")
]], templates.fullPageItem
)}
