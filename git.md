---
tags: 
- "computer-science/tool"
- "computer-science/missing-semester"
---

# Git

Source: [Missing Semester lecture note from MIT](https://missing.csail.mit.edu/2020/version-control/), _Python Crash Course_

## Motivation

We want to jump between versions of a project. Also, we’d like to develop multiple files or functionalities in a project in parallel, then merge them together. Doing these with plain text files require backing up every version and every branch on disk, which is cumbersome. This can be alleviated by manipulating _references instead of actual files_; manipulations of on-disk files are to be _automated_.

Git provides a systematic way of manipulating references and automating the version-control-related editing of on-disk files. There are two kinds of references in Git: Hash strings, which are unique identifiers of objects, and references, which are maps from human-readable strings to Hash strings. Hash strings are fixed, while references can be manipulated.