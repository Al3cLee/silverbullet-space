Here lists the pages that are not finished yet. Having metadate `finished=true` does not mean a page will not be updates, but having matadata `finished=false` means it definitely needs editing.

${template.each(query[[from index.tag "page" where finished == false]], templates.pageItem)}
