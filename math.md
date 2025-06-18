The subtags of `math` are
${query[[from index.tag "tag" where name:startsWith("math/") select name]]}

The pages tagged with `math` or its subtags are
${template.each(query[[
  from index.tag "page"
  where matchSubTag(tags, "math")
]], templates.fullPageItem
)}