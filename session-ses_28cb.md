# Knowledge garden note-writing skill

**Session ID:** ses_28cb98d9affeYRhakN6yakymKU
**Created:** 4/10/2026, 1:24:49 AM
**Updated:** 4/10/2026, 1:30:33 AM

---

## User

read this knowledge garden, especially @atomic_notes.md  and @knowledge_garden.md . load all global skills. fetch necessary info from https://silverbullet.md . Then, write a skill file specifying how to interact with this knowledge garden and how to write notes, containing at least: 1. the tagging system: #domain/subdomain/smaller_subdomain; 2. markdown syntax and wikilink syntax, esp. linking to a section or transclusions; 3. note style should be atomic, a la @atomic_notes.md ; 4. when and how to use wiki-links; 5. default yaml frontmatter attribute `finished: fase`.

---

## Assistant (Build · GLM-5.1 · 50.2s)

_Thinking:_

The user wants me to:
1. Read the knowledge garden files (already provided)
2. Load all global skills
3. Fetch info from https://silverbullet.md
4. Write a skill file for interacting with this knowledge garden

Let me start by loading skills and fetching the SilverBullet docs in parallel.

**Tool: skill**

**Input:**
```json
{
  "name": "skill-creator"
}
```

**Output:**
```
<skill_content name="skill-creator">
# Skill: skill-creator

# Skill Creator

This skill provides guidance for creating effective skills.

## About Skills

Skills are modular, self-contained packages that extend AI capabilities by providing
specialized knowledge, workflows, and tools. Think of them as "onboarding guides" for specific
domains or tasks—they transform OpenCode from a general-purpose agent into a specialized agent
equipped with procedural knowledge that no model can fully possess.

### What Skills Provide

1. Specialized workflows - Multi-step procedures for specific domains
2. Tool integrations - Instructions for working with specific file formats or APIs
3. Domain expertise - Company-specific knowledge, schemas, business logic
4. Bundled resources - Scripts, references, and assets for complex and repetitive tasks

### Anatomy of a Skill

Every skill consists of a required SKILL.md file and optional bundled resources:

```
skill-name/
├── SKILL.md (required)
│   ├── YAML frontmatter metadata (required)
│   │   ├── name: (required)
│   │   └── description: (required)
│   └── Markdown instructions (required)
└── Bundled Resources (optional)
    ├── scripts/          - Executable code (Python/Bash/etc.)
    ├── references/       - Documentation intended to be loaded into context as needed
    └── assets/           - Files used in output (templates, icons, fonts, etc.)
```

#### SKILL.md (required)

**Metadata Quality:** The `name` and `description` in YAML frontmatter determine when OpenCode will use the skill. Be specific about what the skill does and when to use it. Use the third-person (e.g. "This skill should be used when..." instead of "Use this skill when...").

#### Bundled Resources (optional)

##### Scripts (`scripts/`)

Executable code (Python/Bash/etc.) for tasks that require deterministic reliability or are repeatedly rewritten.

- **When to include**: When the same code is being rewritten repeatedly or deterministic reliability is needed
- **Example**: `scripts/rotate_pdf.py` for PDF rotation tasks
- **Benefits**: Token efficient, deterministic, may be executed without loading into context
- **Note**: Scripts may still need to be read by OpenCode for patching or environment-specific adjustments

##### References (`references/`)

Documentation and reference material intended to be loaded as needed into context to inform OpenCode's process and thinking.

- **When to include**: For documentation that OpenCode should reference while working
- **Examples**: `references/finance.md` for financial schemas, `references/mnda.md` for company NDA template, `references/policies.md` for company policies, `references/api_docs.md` for API specifications
- **Use cases**: Database schemas, API documentation, domain knowledge, company policies, detailed workflow guides
- **Benefits**: Keeps SKILL.md lean, loaded only when OpenCode determines it's needed
- **Best practice**: If files are large (>10k words), include grep search patterns in SKILL.md
- **Avoid duplication**: Information should live in either SKILL.md or references files, not both. Prefer references files for detailed information unless it's truly core to the skill—this keeps SKILL.md lean while making information discoverable without hogging the context window. Keep only essential procedural instructions and workflow guidance in SKILL.md; move detailed reference material, schemas, and examples to references files.

##### Assets (`assets/`)

Files not intended to be loaded into context, but rather used within the output OpenCode produces.

- **When to include**: When the skill needs files that will be used in the final output
- **Examples**: `assets/logo.png` for brand assets, `assets/slides.pptx` for PowerPoint templates, `assets/frontend-template/` for HTML/React boilerplate, `assets/font.ttf` for typography
- **Use cases**: Templates, images, icons, boilerplate code, fonts, sample documents that get copied or modified
- **Benefits**: Separates output resources from documentation, enables OpenCode to use files without loading them into context

### Progressive Disclosure Design Principle

Skills use a three-level loading system to manage context efficiently:

1. **Metadata (name + description)** - Always in context (~100 words)
2. **SKILL.md body** - When skill triggers (<5k words)
3. **Bundled resources** - As needed by OpenCode (Unlimited*)

*Unlimited because scripts can be executed without reading into context window.

## Skill Creation Process

To create a skill, follow the "Skill Creation Process" in order, skipping steps only if there is a clear reason why they are not applicable.

### Step 1: Understanding the Skill with Concrete Examples

Skip this step only when the skill's usage patterns are already clearly understood. It remains valuable even when working with an existing skill.

To create an effective skill, clearly understand concrete examples of how the skill will be used. This understanding can come from either direct user examples or generated examples that are validated with user feedback.

For example, when building an image-editor skill, relevant questions include:

- "What functionality should the image-editor skill support? Editing, rotating, anything else?"
- "Can you give some examples of how this skill would be used?"
- "I can imagine users asking for things like 'Remove the red-eye from this image' or 'Rotate this image'. Are there other ways you imagine this skill being used?"
- "What would a user say that should trigger this skill?"

To avoid overwhelming users, avoid asking too many questions in a single message. Start with the most important questions and follow up as needed for better effectiveness.

Conclude this step when there is a clear sense of the functionality the skill should support.

### Step 2: Planning the Reusable Skill Contents

To turn concrete examples into an effective skill, analyze each example by:

1. Considering how to execute on the example from scratch
2. Identifying what scripts, references, and assets would be helpful when executing these workflows repeatedly

Example: When building a `pdf-editor` skill to handle queries like "Help me rotate this PDF," the analysis shows:

1. Rotating a PDF requires re-writing the same code each time
2. A `scripts/rotate_pdf.py` script would be helpful to store in the skill

Example: When designing a `frontend-webapp-builder` skill for queries like "Build me a todo app" or "Build me a dashboard to track my steps," the analysis shows:

1. Writing a frontend webapp requires the same boilerplate HTML/React each time
2. An `assets/hello-world/` template containing the boilerplate HTML/React project files would be helpful to store in the skill

Example: When building a `big-query` skill to handle queries like "How many users have logged in today?" the analysis shows:

1. Querying BigQuery requires re-discovering the table schemas and relationships each time
2. A `references/schema.md` file documenting the table schemas would be helpful to store in the skill

To establish the skill's contents, analyze each concrete example to create a list of the reusable resources to include: scripts, references, and assets.

### Step 3: Initializing the Skill

At this point, it is time to actually create the skill.

Skip this step only if the skill being developed already exists, and iteration or packaging is needed. In this case, continue to the next step.

When creating a new skill from scratch, always run the `init_skill.py` script. The script conveniently generates a new template skill directory that automatically includes everything a skill requires, making the skill creation process much more efficient and reliable.

Usage:

```bash
scripts/init_skill.py <skill-name> --path <output-directory>
```

The script:

- Creates the skill directory at the specified path
- Generates a SKILL.md template with proper frontmatter and TODO placeholders
- Creates example resource directories: `scripts/`, `references/`, and `assets/`
- Adds example files in each directory that can be customized or deleted

After initialization, customize or remove the generated SKILL.md and example files as needed.

### Step 4: Edit the Skill

When editing the (newly-generated or existing) skill, remember that the skill is being created for another instance of OpenCode to use. Focus on including information that would be beneficial and non-obvious to OpenCode. Consider what procedural knowledge, domain-specific details, or reusable assets would help another OpenCode instance execute these tasks more effectively.

#### Start with Reusable Skill Contents

To begin implementation, start with the reusable resources identified above: `scripts/`, `references/`, and `assets/` files. Note that this step may require user input. For example, when implementing a `brand-guidelines` skill, the user may need to provide brand assets or templates to store in `assets/`, or documentation to store in `references/`.

Also, delete any example files and directories not needed for the skill. The initialization script creates example files in `scripts/`, `references/`, and `assets/` to demonstrate structure, but most skills won't need all of them.

#### Update SKILL.md

**Writing Style:** Write the entire skill using **imperative/infinitive form** (verb-first instructions), not second person. Use objective, instructional language (e.g., "To accomplish X, do Y" rather than "You should do X" or "If you need to do X"). This maintains consistency and clarity for AI consumption.

To complete SKILL.md, answer the following questions:

1. What is the purpose of the skill, in a few sentences?
2. When should the skill be used?
3. In practice, how should OpenCode use the skill? All reusable skill contents developed above should be referenced so that OpenCode knows how to use them.

### Step 5: Packaging a Skill

Once the skill is ready, it should be packaged into a distributable zip file that gets shared with the user. The packaging process automatically validates the skill first to ensure it meets all requirements:

```bash
scripts/package_skill.py <path/to/skill-folder>
```

Optional output directory specification:

```bash
scripts/package_skill.py <path/to/skill-folder> ./dist
```

The packaging script will:

1. **Validate** the skill automatically, checking:
   - YAML frontmatter format and required fields
   - Skill naming conventions and directory structure
   - Description completeness and quality
   - File organization and resource references

2. **Package** the skill if validation passes, creating a zip file named after the skill (e.g., `my-skill.zip`) that includes all files and maintains the proper directory structure for distribution.

If validation fails, the script will report the errors and exit without creating a package. Fix any validation errors and run the packaging command again.

### Step 6: Iterate

After testing the skill, users may request improvements. Often this happens right after using the skill, with fresh context of how the skill performed.

**Iteration workflow:**
1. Use the skill on real tasks
2. Notice struggles or inefficiencies
3. Identify how SKILL.md or bundled resources should be updated
4. Implement changes and test again

Base directory for this skill: file:///Users/wentaoli/.config/opencode/skills/skill-creator
Relative paths in this skill (e.g., scripts/, reference/) are relative to this base directory.
Note: file list is sampled.

<skill_files>
<file>/Users/wentaoli/.config/opencode/skills/skill-creator/LICENSE.txt</file>
<file>/Users/wentaoli/.config/opencode/skills/skill-creator/scripts/quick_validate.py</file>
<file>/Users/wentaoli/.config/opencode/skills/skill-creator/scripts/package_skill.py</file>
<file>/Users/wentaoli/.config/opencode/skills/skill-creator/scripts/init_skill.py</file>
</skill_files>
</skill_content>
```

**Tool: skill**

**Input:**
```json
{
  "name": "note-writer"
}
```

**Output:**
```
<skill_content name="note-writer">
# Skill: note-writer

# Technical Writing Style Guide

## Purpose

This guide defines the standards for writing technical documents, including reports, code documentation, and technical notes. Always follow this guide when producing any technical content.

## Definition of Technical Content

**Technical content** refers to notes or documents that require a certain amount of technical knowledge to work through and understand, as opposed to shallow notes that are merely quotes and comments. Technical notes are often written by hand first and then typeset. For subjects like physics and mathematics, almost all notes are technical.

---

## Narration Stages

Every technical note or document should follow a four-part structure:

1. motivation
2. discussion
3. results
4. remarks

Each part is called a "narration stage". After all four stages are reached, you have completed a narration cycle. Then, you may start again with a new motivation stage.

ALL technical notes are ALWAYS a combination of one or more narration cycles. Each narration cycle always contains the four parts. A technical note's structure can look like this:

```markdown
**Motivation.** ...
**Discussion.** ...
**Result.** ...
**Remark.**...
**Remark.**

**Motivation.** Building on our previous result, we are now curious to define... via... which we do not know yet... so let us consider...
**Discussion.** ...
**Result.** ...
**Remark.**...
```

### 1. Motivation

Start with motivation paragraphs that establish the context against which the question or topic to be considered is set. The motivation raises the question that the rest of the document will address.

### 2. Discussion

After the motivation paragraph, engage in detailed discussion. In mathematics this is often organized in a "claim-proof" structure, but qualitative arguments (which are not formally rigorous) and analogies are often invoked in other fields.

**Important**: Do not write down the word "proof" explicitly before starting the discussion. Simply let the discussion proceed naturally after the motivation paragraph.

### 3. Results

When the discussion yields a result, explicitly write down a result paragraph. For math notes this is typically a theorem; for physics this paragraph summarizes the result and may include qualitative descriptions.

Each "result" should:
- Be a summary of either a theoretical result or an experimental finding
- Begin with assumptions
- Expand on methods
- Emphasize the end results obtained

Example format: "For [xx], assuming [xxx], by doing [xxx] and [xxx], we have that [xxx]."

### 4. Remarks

After arriving at a result, take time to reflect on the Q&A session and make remarks. Remarks can be qualitative arguments which, without understanding technical details, are hard to appreciate. Imagine there is an inquisitive reader who might challenge your argument, and answer this inquisitive reader.

Following each result, include remarks concerning:
- The result's scope: this follows from the key assumptions made during the derivation.
- Room for improvement: this follows from the result's scope and derivation.
---
## Style Conventions

- ALWAYS use a bold run-in title in the first paragraph of each part: the first paragraph of motivation should be `**Motivation. ** We consider ...`, etc.
- Titles indicate **topics**, not sections of the structure. DO NOT use markdown headings to indicate narration stage.
- ALWAYS use a continuous narration flow, in spite of non-text elements inserted into a paragraph, e.g. code blocks, equations, pictures. NEVER let these disrupt your narration flow. For code blocks, let your narration flow into the comments in the code, and then flow back to text.
- NEVER use bullet lists for purposes other than plainly listing things.

---

## Domain-Specific Guidelines

### Physics Notes

**Separation of Formalism and Applications**: A physical formalism (i.e., a "theory") and its applications are often written in the same chapter in textbooks. This prevents the reader from separating the specifics from general considerations and postulates. In technical physics notes, separate the formalism from its applications.

**Problem with Context-Limited Examples**: A theory is often elaborated exclusively within the context of an example. While a good motivational part is always appreciated, being limited to one specific case can be annoying (e.g., a chapter on angular momentum that only discusses spin-1/2).

**Approach**:
- Take notes on the formalism without relying on its applications
- When only knowing about a specific case, take notes on this case only and refrain from naming the note as "some theory"

### Computer Science Notes

**Logical Order Challenges**: In computer science, especially the less "theoretical" parts, logical reasoning is not usually the key. Instead, various concepts are often intertwined, one depending on another without having an overall pre-determined logical order.

**Approach**:
- Find good motivation first. Software cannot take shape without solid motivation. The motivation is often that a tedious task can be automated with code.
- Start with this motivation and bring up new concepts that it produces.
- When earlier concepts require later ones to elaborate, do not hesitate to mention the later ones (in wiki-links). Arranging concepts in a perfectly logical order is against the nature of programs—functionalities are developed with each other in mind, not in a rigid logical sequence.

**Clarity Enhancements**:
- ALWAYS provide a glossary of technical terms: any new jargon introduced in this note MUST be included.
- Always try to provide a real-life example which seem trivial but embeds insightful conceptual progress.
- Provide a minimum working example for each key concept.

Base directory for this skill: file:///Users/wentaoli/.config/opencode/skills/note-writer
Relative paths in this skill (e.g., scripts/, reference/) are relative to this base directory.
Note: file list is sampled.

<skill_files>

</skill_files>
</skill_content>
```

**Tool: webfetch**

**Input:**
```json
{
  "url": "https://silverbullet.md/Links",
  "format": "markdown"
}
```

**Output:**
```
       Links
```

**Tool: webfetch**

**Input:**
```json
{
  "url": "https://silverbullet.md/Objects",
  "format": "markdown"
}
```

**Output:**
```
       Objects
```

**Tool: webfetch**

**Input:**
```json
{
  "url": "https://silverbullet.md/Transclusions",
  "format": "markdown"
}
```

**Error:**
```
The operation was aborted.
```

---

## Assistant (Build · GLM-5.1 · 5.7s)

The SilverBullet pages returned minimal content. Let me fetch more specific pages with the full URLs.

**Tool: webfetch**

**Input:**
```json
{
  "format": "markdown",
  "url": "https://silverbullet.md/Links%23Internal%20link%20format"
}
```

**Output:**
```
       Links#Internal link format
```

**Tool: webfetch**

**Input:**
```json
{
  "format": "markdown",
  "url": "https://silverbullet.md/Objects%23Tags"
}
```

**Output:**
```
       Objects#Tags
```

**Tool: webfetch**

**Input:**
```json
{
  "format": "markdown",
  "url": "https://silverbullet.md/Transclusions",
  "timeout": 60
}
```

**Output:**
```
       Transclusions     

---

description: Inline embedding of one page's content inside another.

## tags: glossary

Transclusions are an extension of the [Markdown](Markdown) syntax enabling inline embedding of content.

The general syntax is `![path](path)`. Two types of transclusions are currently supported:

# Media

Syntax: `![path/to/image.jpg](path/to/image.jpg)` see [Document#Embedding](Document#Embedding) for more details.

Media resizing is also supported: ![Document#Media resizing](Document#Media resizing)

# Pages

Syntax: \* `![page name](page name)` embed an entire page \* `![page name#header](page name#header)` embed only a section (guarded by the given header)
```

**Tool: webfetch**

**Input:**
```json
{
  "format": "markdown",
  "url": "https://silverbullet.md/Markdown"
}
```

**Output:**
```
       Markdown     

Markdown is a plain text formatting system [originally developed by John Gruber](https://daringfireball.net/projects/markdown/). It has since been standardized into [CommonMark](https://commonmark.org/), which is what SilverBullet uses (with [Markdown/Extensions](Markdown/Extensions)). While a bit more technical than [WYSIWYG](https://pl.wikipedia.org/wiki/WYSIWYG)\-style editing (like MS Word), the nice thing about markdown is that it is a relatively easy-to-learn format, and you can read files even without special tools (like SilverBullet).

This means that *you will always have access to your content* even if you switch tools. It also means that you can use multiple tools at the same time to edit these files. You don’t have to use SilverBullet exclusively.

There is a bit of a caveat here: Markdown is limited in certain ways, and various tools using markdown as the underlying file format (like SilverBullet) need features that are not directly supported by markdown. As a result, different tools introduce extensions to markdown that are not standard nor interoperable. While in some cases, these tools converge on particular pieces of syntax (such as the non-standard `[page link](page link)` syntax), some level of divergence in the markdown that each tool supports is unavoidable. SilverBullet is complicit in this as well. It adds a few extensions that are not widely supported and assigns new meaning to certain markdown features to implement novel features. In its defense, all these features are optional. If you want to just write plain markdown, you can.

See [Markdown/Extensions](Markdown/Extensions) for more details on these SilverBullet-specific extensions.

More about markdown:

-   [Markdown/Basics](Markdown/Basics): learn some the markdown basics
-   [Markdown/Extensions](Markdown/Extensions): learn about SilverBullet’s set of markdown extensions
-   [Markdown/Syntax Highlighting](Markdown/Syntax Highlighting): languages that SilverBullet supports syntax highlighting for
```

**Tool: glob**

**Input:**
```json
{
  "pattern": "**/*.md",
  "path": "/Users/wentaoli/silverbullet-space-agent"
}
```

**Output:**
```
/Users/wentaoli/silverbullet-space-agent/spenso/Structure.md
/Users/wentaoli/silverbullet-space-agent/Refs/Gorantla_et_al_Tensor_Network_Non-invertible_2024.md
/Users/wentaoli/silverbullet-space-agent/spenso/Tutorial/Constructing_Tensors.md
/Users/wentaoli/silverbullet-space-agent/spenso/Representation.md
/Users/wentaoli/silverbullet-space-agent/spenso/Tensors.md
/Users/wentaoli/silverbullet-space-agent/spenso/Slot.md
/Users/wentaoli/silverbullet-space-agent/spenso/Abstract_Index.md
/Users/wentaoli/silverbullet-space-agent/Library/mrmugame/Silverbullet-Math.md
/Users/wentaoli/silverbullet-space-agent/custom_functions.md
/Users/wentaoli/silverbullet-space-agent/git.md
/Users/wentaoli/silverbullet-space-agent/index.md
/Users/wentaoli/silverbullet-space-agent/nonlinear_fiber_optics.md
/Users/wentaoli/silverbullet-space-agent/Symbolica.md
/Users/wentaoli/silverbullet-space-agent/Blogs/Bells_inequality_and_paradigm_shift.md
/Users/wentaoli/silverbullet-space-agent/Refs/Guo_et_al_New_Framework_2025.md
/Users/wentaoli/silverbullet-space-agent/uv.md
/Users/wentaoli/silverbullet-space-agent/zinit.md
/Users/wentaoli/silverbullet-space-agent/Ghostty.md
/Users/wentaoli/silverbullet-space-agent/Refs/Coecke_and_Paquette_Categories_2009.md
/Users/wentaoli/silverbullet-space-agent/Refs/Wetering_ZX-calculus_2020.md
/Users/wentaoli/silverbullet-space-agent/Refs/Shao_Whats_Done_2024.md
/Users/wentaoli/silverbullet-space-agent/README.md
/Users/wentaoli/silverbullet-space-agent/projector.md
/Users/wentaoli/silverbullet-space-agent/Typst.md
/Users/wentaoli/silverbullet-space-agent/Sochocki_formula.md
/Users/wentaoli/silverbullet-space-agent/second_quantization.md
/Users/wentaoli/silverbullet-space-agent/ref_page_template.md
/Users/wentaoli/silverbullet-space-agent/README_ZH.md
/Users/wentaoli/silverbullet-space-agent/Wentao_Li.md
/Users/wentaoli/silverbullet-space-agent/technical note template.md
/Users/wentaoli/silverbullet-space-agent/CONFIG.md
/Users/wentaoli/silverbullet-space-agent/mean_field_theory.md
/Users/wentaoli/silverbullet-space-agent/atomic_notes.md
/Users/wentaoli/silverbullet-space-agent/Library/Al3cLee/Silversearch-Chinese-Tokenizer.md
/Users/wentaoli/silverbullet-space-agent/Library/mrmugame/Silversearch.md
/Users/wentaoli/silverbullet-space-agent/tag_system.md
/Users/wentaoli/silverbullet-space-agent/Heaviside_step_function.md
/Users/wentaoli/silverbullet-space-agent/scaling_equation.md
/Users/wentaoli/silverbullet-space-agent/unfinished_pages.md
/Users/wentaoli/silverbullet-space-agent/Web_Neighbors.md
/Users/wentaoli/silverbullet-space-agent/goldendict-ng.md
/Users/wentaoli/silverbullet-space-agent/OpenInTerminal.md
/Users/wentaoli/silverbullet-space-agent/Anki.md
/Users/wentaoli/silverbullet-space-agent/zoxide.md
/Users/wentaoli/silverbullet-space-agent/WezTerm.md
/Users/wentaoli/silverbullet-space-agent/Vivaldi_browser.md
/Users/wentaoli/silverbullet-space-agent/fzf.md
/Users/wentaoli/silverbullet-space-agent/Affinity_Designer.md
/Users/wentaoli/silverbullet-space-agent/theory_vs_experiment.md
/Users/wentaoli/silverbullet-space-agent/BibLaTeX.md
/Users/wentaoli/silverbullet-space-agent/bibliography_management.md
/Users/wentaoli/silverbullet-space-agent/technical_note.md
/Users/wentaoli/silverbullet-space-agent/minimum_working_example.md
/Users/wentaoli/silverbullet-space-agent/knowledge_garden.md
```

---

## Assistant (Build · GLM-5.1 · 6.0s)

**Tool: webfetch**

**Input:**
```json
{
  "format": "markdown",
  "url": "https://silverbullet.md/Markdown/Extensions"
}
```

**Output:**
```
       Extensions     

In addition to supporting [Markdown/Basics|markdown basics](Markdown/Basics|markdown basics) as standardized by [CommonMark](https://commonmark.org/), SilverBullet relies on the following extensions:

-   [Link](Link)
-   [Frontmatter](Frontmatter) and [Attribute](Attribute)
-   [Markdown/Fenced Code Block](Markdown/Fenced Code Block)
-   [Transclusions](Transclusions) syntax
-   [Markdown/Admonition](Markdown/Admonition)
-   [Markdown/Hashtags](Markdown/Hashtags)
-   [Space Lua](Space Lua) expressions
-   [Tables](https://www.markdownguide.org/extended-syntax/#tables)
-   [Task lists](https://www.markdownguide.org/extended-syntax/#task-lists)
-   [Highlight](https://www.markdownguide.org/extended-syntax/#highlight)
-   [Automatic URL linking](https://www.markdownguide.org/extended-syntax/#automatic-url-linking)
-   [Subscript](https://www.markdownguide.org/extended-syntax/#subscript) and [superscript](https://www.markdownguide.org/extended-syntax/#superscript)
-   [Footnotes](https://www.markdownlang.com/extended/footnotes.html)
```

**Tool: read**

**Input:**
```json
{
  "filePath": "/Users/wentaoli/silverbullet-space-agent/tag_system.md"
}
```

**Output:**
```
<path>/Users/wentaoli/silverbullet-space-agent/tag_system.md</path>
<type>file</type>
<content>
1: ---
2: finished: true
3: ---
4: 
5: #workflow
6: 
7: # Tag system
8: 
9: File systems on computers typically consist of folders, and each file must belong to one and _only one_ folder. This is not how the ideas of a human being naturally behave.
10: 
11: An idea might be related to many topics. The topics themselves fit nicely into a tree-like structure: a subject has sub-fields, e.g. quantum mechanics is a sub-topic of physics.
12: 
13: It is therefore sensible to arrange ideas (and more generally speaking, any information) flatly inside _one_ big folder, and upon creating each piece of information, attach it to various topics by tagging it.
14: 
15: Each object in SilverBullet has a main `tag` which is its “data type”, e.g. page, task, item, etc. Then, it has some extra `tags` (a Lua array) that indicate its topics.
16: 
17: For example, [[second_quantization]] belongs to topics #physics/quantum-fields and #physics/condensed-matter. So its `tag` is `"page"` while its `tags` is a Lua array of two items.
18: 
19: Tags are very helpful when you want to retrieve information from a collection of notes. Instead of searching or clicking through a folder, you can [query](https://silverbullet.md/Space%20Lua/Lua%20Integrated%20Query) this collection, just like asking questions to a human. For example, you can query for pages that simultaneously fall under two different topics. SilverBullet has [[Library/Std/Infrastructure/Query Templates]] that help you write queries quickly.
20: 
21: At https://silverbullet.md/Tag there is more information about how tags work in SilverBullet. The page [[custom_functions]] contains some Lua scripts which help query pages via their tags.
22: 
23: ---
24: 
25: In the database version of Logseq, there are also two kinds of tags: the main `tag` indicating the type of “stuff” an element is, and some `properties` serving as extra metadata.

(End of file - total 25 lines)
</content>
```

**Tool: read**

**Input:**
```json
{
  "filePath": "/Users/wentaoli/silverbullet-space-agent/ref_page_template.md"
}
```

**Output:**
```
<path>/Users/wentaoli/silverbullet-space-agent/ref_page_template.md</path>
<type>file</type>
<content>
1: ---
2: command: "New Reference Page"
3: suggestedName: "Refs/"
4: confirmName: true
5: openIfExists: true
6: tags: meta/template/page
7: ---
8: 
9: ---
10: url:
11: date:
12: title:
13: ---
14: 
15: ## Attachments

(End of file - total 15 lines)
</content>
```

**Tool: read**

**Input:**
```json
{
  "filePath": "/Users/wentaoli/silverbullet-space-agent/technical note template.md"
}
```

**Output:**
```
<path>/Users/wentaoli/silverbullet-space-agent/technical note template.md</path>
<type>file</type>
<content>
1: ---
2: command: "New Note"
3: confirmName: true
4: openIfExists: true
5: tags: meta/template/page
6: ---
7: 
8: ---
9: finished: false
10: ---
11: 
12: #|^|

(End of file - total 12 lines)
</content>
```

**Tool: read**

**Input:**
```json
{
  "filePath": "/Users/wentaoli/silverbullet-space-agent/technical_note.md"
}
```

**Output:**
```
<path>/Users/wentaoli/silverbullet-space-agent/technical_note.md</path>
<type>file</type>
<content>
1: ---
2: tags: "workflow"
3: ---
4: 
5: # Technical Note
6: 
7: By “technical” we refer to notes which require a certain amount of technical knowledge to work through and then understand, as opposed to notes which are merely quotes and comments. Technical notes are often written by hand first and then typeset, while shallower notes are often typed in the first place. For subjects like physics and mathematics almost all notes are technical.
8: 
9: ---
10: 
11: Technical notes investigate a topic in detail. This can be re-framed into “asking relevant questions concerning a topic, and then answering them in detail”. There could be multiple iterations of this Q&A process within a single piece of note. 
12: 
13: I usually start a technical note with motivation paragraphs, establishing the context against which the question to be considered is set. 
14: 
15: Then I would go on to discuss the question raised in the motivation paragraph in detail. In mathematics this is often organized in a “claim-proof” structure, but in other fields it is hard to categorize everything in the discussions as “proof” because qualitative arguments (which are not formally rigorous) and analogies are often invoked.
16: 
17: Therefore I do not like to write down the word “proof” explicitly before starting the discussion. After the motivation paragraph I simply let my inner dialogue run riot.
18: 
19: When the discussion yields some result I would explicitly write down a result paragraph. For math notes it is typically a theorem; for physics this paragraph is simply the summary of a result, which _could_ include qualitative descriptions.
20: 
21: After arriving at a result I take time to reflect on the Q&A session and make remarks. Remarks can also be qualitative arguments which, without understanding technical details, are hard to appreciate.
22: 
23: ---
24: 
25: To sum up, a typical technical note consists of
26: 
27: 1. motivation,
28: 2. discussion,
29: 3. results, and
30: 4. remarks
31: 
32: In the context of Q&A, the motivation paragraph raises a question, the discussion and result sections answer it, and then the remark section reflects upon this Q&A process. 
33: 
34: In this knowledge garden, technical notes are usually structured as above, but the different parts may not be marked explicitly by a title (e.g. `## Motivation`). Instead, horizontal rules are inserted between different stages of narration, while titles indicate topics.
35: 
36: ## Physics notes
37: 
38: A physical formalism (i.e. a “theory”) and its applications are often written in the same chapter in textbooks. This prevents the reader from separating the specifics from general considerations and postulates, so in my notes a formalism is often separated from its applications. 
39: 
40: Actually, it is often the case that a theory is elaborated _exclusively within the context of an example_. While one would always appreciate a good motivational part, that this part limits the scope of the whole note can be annoying, e.g. a chapter on the addition of angular momentum usually starts with the spin-1/2 example, but some books dwell on this particular case and provide nothing else.
41: 
42: My approach is to 
43: 
44: * take notes on the formalism without relying on its applications, and
45: * when only knowing about a specific case, take notes on this case only and refrain from naming the note as “some theory”.
46: 
47: ## Computer science notes
48: 
49: In computer science, especially the less “theoretical” parts of it, logical reasoning is not usually the key. Instead the various concepts are often intertwined, one depending on another without having an overall pre-determined logical order.
50: 
51: My approach is to try my best in finding a good motivation, for a software cannot take shape without a solid motivation. The motivation is often that a tedious task can be automated with code in computer science. 
52: 
53: Anyway, I start with this motivation and bring up new concepts that it produces. But there are always cases where earlier concepts require later ones to elaborate, in such cases I don’t hesitate at all to mention the later ones (in wiki-links), since arranging them in a perfectly logical order is against the very nature of programs. Functionalities are developed with each other in mind, not in a rigid logical sequence.
54: 
55: A helpful way to make CS notes clearer is providing a glossary of technical terms. Besides, providing a [[minimum_working_example]] is also essential.

(End of file - total 55 lines)
</content>
```

**Tool: read**

**Input:**
```json
{
  "filePath": "/Users/wentaoli/silverbullet-space-agent/CONFIG.md"
}
```

**Output:**
```
<path>/Users/wentaoli/silverbullet-space-agent/CONFIG.md</path>
<type>file</type>
<content>
1: This is where you configure SilverBullet to your liking. See [[Library/Std/Config]] for a full list of configuration options.
2: 
3: ```space-lua
4: config.set("silversearch.tokenizers", {
5:   ["Library/LelouchHe/silversearch-chinese-tokenizer.js"] = {},
6:   ["Library/Al3cLee/silversearch-chinese-tokenizer.js"] = {}
7: })
8: ```
9: 
10: - 这是一些测试文本
11: 
12: ```space-lua
13: config.set {
14:   actionButtons = {
15:     {
16:       icon = "home",
17:       description = "Go to the index page",
18:       run = function()
19:         editor.invokeCommand("Navigate: Home")
20:       end
21:     },
22:     {
23:       icon = "book",
24:       description = "Open page",
25:       run = function()
26:         editor.invokeCommand("Navigate: Page Picker")
27:       end
28:     },
29:     {
30:       icon = "search",
31:       description = "Search",
32:       run = function()
33:         editor.invokeCommand("Silversearch: Search")
34:       end
35:     },
36:     {
37:       icon = "terminal",
38:       description = "Run command",
39:       run = function()
40:         editor.invokeCommand "Open Command Palette"
41:       end,
42:     }
43:   }
44: }
45: ```

(End of file - total 45 lines)
</content>
```

---

## Assistant (Build · GLM-5.1 · 3.5s)

**Tool: webfetch**

**Input:**
```json
{
  "format": "markdown",
  "url": "https://silverbullet.md/Link"
}
```

**Output:**
```
       Link     

---

description: A wiki-link or Markdown link connecting pages in your space.

## tags: glossary

In SilverBullet, you can create links to pages or documents inside your space as well as to external resources, using different link formats.

# External links

-   *Markdown links*, using the `[title](URL)` syntax, for instance: [SilverBullet community](https://community.silverbullet.md). If the URL contains a space or closing parenthesis, you can enclose the URL in angled brackets.
-   *"[AutoLinks](https://spec.commonmark.org/current/#autolinks)"*, like [https://community.silverbullet.md](https://community.silverbullet.md)
-   *“Naked” URL links* (AKA *"Bare URLs"*), like [https://community.silverbullet.md](https://community.silverbullet.md)

# Internal links

-   *Relative internal links*, using the `[title](<relative specifier><link>)` format. The *relative specifier* can be used to move up the file tree (or down, if you picture a file tree like this 🌳) relative to the page the link is on, similar to POSIX file systems `/../`. The *link* has to conform to the [#Link syntax (String refs)|link syntax](#Link syntax \(String refs\)|link syntax)
-   *Absolute internal links* (also called wikilinks) using the `[<link>](<link>)` syntax. Again the *link* has to conform to the link syntax. A alias can be added like this `[<link>|This link points to <link>](<link>|This link points to <link>)`

# Link syntax (String refs)

The link or “string refs” has to follow some specific formatting: \* A string ref starting with `^` links to a meta page, see [#Caret page links|caret page links](#Caret page links|caret page links) \* The "core" (After a possible `^` and before a `@` or `#`) of a string ref is a [Names|name](Names|name) or [Paths|path](Paths|path). \* The core of a string ref can also be empty, an empty path points to the current page for links, and to the index page for `editor.navigate` \* A string ref can end three ways: \* `#` followed by a string (which can also contain `#`). This will point to the header equal to that string. (Notably you can't link to every possible header, because e.g. `]]` will restrict you inside a wikilink for example.), e.g. [SilverBullet#Introduction](SilverBullet#Introduction) - `@` followed by an upper or lowercase `L` followed by a number, optionally followed by an upper or lowercase `C` followed by a number (e.g. `@l12c13`). This will point to the corresponding line and column inside a page (both 1-based), e.g. [CHANGELOG@L12c42](CHANGELOG@L12c42) - `@` followed by a number *n*. This will point to the *nth* character in the page (0-based), e.g. [CHANGELOG@123](CHANGELOG@123)

# Caret page links

[Meta Page](Meta Page) are excluded from link auto complete in many contexts. However, you may still want to reference a meta page outside of a “meta context.” To make it easier to reference, you can use the caret syntax: `[^Library/Std](^Library/Std)`. Semantically this has the same meaning as `[LIbrary/Std](LIbrary/Std)`. The only difference is that auto complete will *only* complete meta pages.
```

**Tool: webfetch**

**Input:**
```json
{
  "format": "markdown",
  "url": "https://silverbullet.md/Markdown/Hashtags"
}
```

**Output:**
```
       Hashtags     

---

description: "An inline #tag that annotates a page or object for categorisation and querying."

## tags: glossary

Hashtag syntax (`#my-tag`) can be used to explicitly assign a [Tag](Tag) to an [Object](Object).

# Scope rules

-   If a hashtag is the only content in a paragraph (at most with additional hashtags), it applies to the **page**.
-   If a hashtag is used inside of an item (bullet point, or ordered list), it applies to that **item**.
-   If a hashtag is used inside of a [Task](Task), it applies to that **task**.
-   If a hashtag is used inside of a paragraph, they apply to the **paragraph**.
-   If you create a [Markdown/Fenced Code Block](Markdown/Fenced Code Block) with a hashtag as language, it applies the tag to that [Object/data](Object/data).

## Examples

#page-tag-example

Paragraph #paragraph-tag-example

-   Item #item-tag-example
-   \[ \] Task #task-tag-example

```#data-example
name: Hank
```

# Naming rules

Hashtags can contain letters, dashes, underscores and other characters, but not: - Whitespace (space, newline, etc.) - Characters from this list: `!@#$%^&*(),.?":{}|<>\` - Digits only (e.g. #123)

If you need your tags to contain these characters, you have to surround the tag content with angle brackets like this: #
```

**Tool: read**

**Input:**
```json
{
  "filePath": "/Users/wentaoli/silverbullet-space-agent/second_quantization.md",
  "limit": 30
}
```

**Output:**
```
<path>/Users/wentaoli/silverbullet-space-agent/second_quantization.md</path>
<type>file</type>
<content>
1: ---
2: finished: true
3: ---
4: 
5: #physics/quantum-fields
6: #physics/condensed-matter
7: 
8: # Second Quantization 
9: 
10: 1. Fock states are constructed via (anti)symmetrizing and normalizing product states. They only depend on occupation numbers and are orthonormal. 
11: 2. Creation and annihilation operators couple Fock states with different total occupation numbers. The number operator can be constructed from them.
12: 3. Under the Fock basis, a generic operator can be expressed in terms of creation and annihilation operators. This is known as the “second quantized form” of operators.
13: 4. Properties of Fock states are often related to properties of permutations.
14: 
15: LaTeX Note: ${noteLink("second_quantization")}

(End of file - total 15 lines)
</content>
```

**Tool: read**

**Input:**
```json
{
  "filePath": "/Users/wentaoli/silverbullet-space-agent/unfinished_pages.md"
}
```

**Output:**
```
<path>/Users/wentaoli/silverbullet-space-agent/unfinished_pages.md</path>
<type>file</type>
<content>
1: Here lists the pages that are not finished yet. Having metadata `finished=true` does not mean a page will not be further edited (after all, in principle every page would be updated continuously), but having metadata `finished=false` means it definitely needs editing, which usually means I have some floating thoughts yet to be pinned down to notes.
2: 
3: ${template.each(query[[from index.tag "page" where finished == false]], templates.pageItem)}
4: 
5: Below are the to-do items scattered around this space.
6: 
7: ${template.each(query[[from index.tag "task"]],templates.taskItem)}

(End of file - total 7 lines)
</content>
```

---

## Assistant (Build · GLM-5.1 · 4.0s)

Now I have all the information I need. Let me also look at a few more example notes to understand the patterns better, and then create the skill.

**Tool: read**

**Input:**
```json
{
  "filePath": "/Users/wentaoli/silverbullet-space-agent/Sochocki_formula.md"
}
```

**Output:**
```
<path>/Users/wentaoli/silverbullet-space-agent/Sochocki_formula.md</path>
<type>file</type>
<content>
1: ---
2: tags: 
3: - "math/complex-analysis"
4: finished: true
5: ---
6: 
7: # The Sochocki Formula
8: 
9: When integrating a “one over _z_” term, it is customary in complex analysis to add a infinitely small imaginary part to the denominator. After evaluating the integral with this small imaginary part (usually using the residue theorem), we use the so-called Sochocki formula to convert it back to an integral on the real axis.
10: 
11: LaTeX note: ${noteLink("sochocki-formula")}

(End of file - total 11 lines)
</content>
```

**Tool: read**

**Input:**
```json
{
  "filePath": "/Users/wentaoli/silverbullet-space-agent/mean_field_theory.md"
}
```

**Output:**
```
<path>/Users/wentaoli/silverbullet-space-agent/mean_field_theory.md</path>
<type>file</type>
<content>
1: ---
2: finished: false
3: ---
4: 
5: #physics/statistical-mechanics
6: #physics/spin-glass
7: 
8: ## Mean Field Theory

(End of file - total 8 lines)
</content>
```

**Tool: read**

**Input:**
```json
{
  "filePath": "/Users/wentaoli/silverbullet-space-agent/index.md"
}
```

**Output:**
```
<path>/Users/wentaoli/silverbullet-space-agent/index.md</path>
<type>file</type>
<content>
1: 
2: 👋 Welcome! This is the [[knowledge_garden]] of [[Wentao_Li]], built with [Silverbullet](https://silverbullet.md), containing my notes on [[tag:physics|physics]], [[tag:math|math]] and [[tag:computer-science|computer science]]. 
3: 
4: ## Performance Tip
5: 
6: The initial loading may take a little while, since this website is _not_ static `html`, instead it is a full-fledged web application in read-only mode. After the initial loading, this website will remain available _even without internet connection_.
7: 
8: To obtain the best viewing (and editing!) experience, deploy this website locally to instantly load everything, including attachments. Visit [[README]] or [[README_ZH]] for instruction.
9: 
10: ## How To Use This Website
11: 
12: - Blue words are click-able. They are either wiki-links to pages within this [SilverBullet space](https://silverbullet.md/Spaces) or URL links to external webpages.
13: 
14: - The current page is [[index]], click the "home" button on the upper right corner to get back here. You can search for pages via `Cmd-K` (`Ctrl-K` for Windows), or via clicking the "book" button.
15: 
16: - Full-text search is available via the "search" button. If the search is slow or keeps saying “Loading...”, click the "terminal" button and run the command "Silversearch: Reindex".
17: 
18: - Dark theme is available via clicking on the "command" button and selecting "Editor: Toggle Dark Mode". Or, you can simply push this button: ${widgets.commandButton("Editor: Toggle Dark Mode")}
19: 
20: - On mobile devices, click the three dots button to view the various buttons.
21: 
22: - The source code of this website is hosted on GitHub, see [[README]] or [[README_ZH]]. My PDF notes typeset with `Typst` or `LaTeX` are also open-source; they are located in the directory [`silverbullet-space/typeset-notes`](https://github.com/Al3cLee/silverbullet-space/tree/main/typeset-notes). Feel free to play around with their source code.
23: 
24: Below are the last 5 edited pages:
25: 
26: ${query[[
27:   from index.tag "page"
28:   select {Page = "[[".. name .."]]"}
29:   order by lastModified desc
30:   limit 5
31: ]]}
32: 
33: To see what I’m currently working on, see the [[unfinished_pages|unfinished pages]].
34: 
35: ## Tags
36: 
37: Pages are organized by tags instead of folders. A complete list of tags is available below, but you can always explore tags via the command “Navigate: Tag Picker”. For each tag `<tagName>`, there is a page called `tag:<tagName>` which serves as its table of contents, i.e. lists all of its relevant pages and sub-tags.
38: 
39: Clicking on a hashtag like #this-one will bring you to its page. Such pages have titles like
40: 
41: * `📍 tagName`
42: 
43: and as the name suggests, they help you navigate this space, just like pins on a map. For more details on tags, see [[tag_system]].
44: 
45: ${query[[from index.tag "tag" where name:startsWith("meta") == false and name:startsWith("maturity")==false select {Page = "[[tag:"..name.."|"..name.."]]"} order by name ]]}
46: 
47: Start wherever you like and click around, but keep in mind you can always search for stuff.
48: 
49: * [沪ICP备2026010579号](https://beian.miit.gov.cn/), [沪公网安备31011002007839号](https://beian.mps.gov.cn/#/query/webSearch?code=31011002007839)

(End of file - total 49 lines)
</content>
```

---

## Assistant (Build · GLM-5.1 · 2.7s)

Now I have a comprehensive understanding of the knowledge garden. Let me create the skill file.

**Tool: bash**

**Input:**
```json
{
  "command": "ls /Users/wentaoli/.config/opencode/skills/",
  "description": "List existing skills directory"
}
```

**Output:**
```
julia-datafitting
note-writer
repo-ripper
skill-creator

```

---

## Assistant (Build · GLM-5.1 · 6.6s)

**Tool: bash**

**Input:**
```json
{
  "command": "mkdir -p /Users/wentaoli/.config/opencode/skills/knowledge-garden",
  "description": "Create skill directory"
}
```

---

## Assistant (Build · GLM-5.1 · 56.0s)

**Tool: write**

**Input:**
```json
{
  "filePath": "/Users/wentaoli/.config/opencode/skills/knowledge-garden/SKILL.md",
  "content": "---\nname: knowledge-garden\ndescription: This skill should be used when writing, editing, or organizing notes in a SilverBullet-based knowledge garden. It covers the tagging system, wikilink and transclusion syntax, atomic note style, and frontmatter conventions specific to this space.\n---\n\n# Knowledge Garden Skill\n\n## Purpose\n\nThis skill governs how to write, edit, and organize notes in a SilverBullet-based knowledge garden. The knowledge garden is a flat collection of interconnected markdown files where notes are linked by wikilinks, organized by a hierarchical tag system, and kept atomic — each note addresses one and only one topic.\n\n## 1. Tagging System\n\nTags replace folders as the primary organization mechanism. Every note carries one or more hierarchical hashtags of the form:\n\n```\n#domain/subdomain/smaller_subdomain\n```\n\n### Rules\n\n- Use lowercase with hyphens for multi-word segments: `#computer-science`, `#quantum-field-theory`.\n- Slashes create hierarchy: `#physics/quantum-fields`, `#physics/condensed-matter`, `#physics/statistical-mechanics/spin-glass`.\n- A note can have multiple tags when the topic spans domains, e.g. a note on second quantization may carry both `#physics/quantum-fields` and `#physics/condensed-matter`.\n- Place page-level tags as standalone paragraphs (hashtags alone on a line) so they apply to the entire page, per SilverBullet scope rules.\n\n### Where to put tags\n\nThere are two equivalent conventions used in this garden:\n\n1. **Frontmatter `tags` list** — a YAML list under the `tags` key in the frontmatter.\n2. **Inline hashtags** — standalone `#tag` lines in the body.\n\nEither or both may appear. When using inline hashtags, place them immediately after the frontmatter, before the first heading. Example:\n\n```markdown\n---\nfinished: false\n---\n\n#physics/quantum-fields\n#physics/condensed-matter\n\n# Second Quantization\n```\n\n### Tag vs tags\n\nSilverBullet distinguishes `tag` (the object type, always `\"page\"` for pages) from `tags` (user-defined topic tags). Never set `tag` manually; only set `tags`.\n\n## 2. Markdown and Wikilink Syntax\n\nThis garden runs on SilverBullet, which extends CommonMark markdown. The key extensions are:\n\n### Wikilinks (Internal Links)\n\n- **Link to a page**: `[[page_name]]` — renders as a clickable link to that page.\n- **Link with alias**: `[[page_name|display text]]` — the pipe `|` separates the target from the displayed label.\n- **Link to a section**: `[[page_name#Section Title]]` — links to a specific heading within a page.\n- **Link to a line**: `[[page_name@L5]]` — links to line 5 of the page.\n\n### Markdown-style Internal Links\n\nSilverBullet also supports `[display text](page_name)` for internal links. The wikilink syntax `[[...]]` is preferred in this garden for internal references.\n\n### External Links\n\nUse standard markdown: `[title](https://example.com)`.\n\n### Transclusions (Content Embedding)\n\nTransclusions embed content from another page inline:\n\n- **Embed an entire page**: `![[page_name]]`\n- **Embed a section**: `![[page_name#Header]]` — embeds only the content under that heading.\n\n### When to Use Wikilinks vs Transclusions\n\n- Use **wikilinks** `[[...]]` to reference or navigate to another note. This is the default way to connect notes.\n- Use **transclusions** `![[...]]` only when the actual content of the other page should appear inline, e.g. embedding a shared definition or a template snippet.\n\n## 3. Atomic Note Style\n\nEvery note in this garden should be atomic: it addresses **one and only one topic** and contains no more information than is absolutely necessary for that topic.\n\n### Principles\n\n1. **Focus**: One note, one topic. If a note starts to address two distinct questions, split it into two notes and link them.\n2. **Clarity**: The note title (H1 heading) should precisely state the single topic. Avoid vague titles like \"Miscellaneous\" or \"Chapter 3 Notes\".\n3. **Link over embed**: When a concept depends on another, link to it rather than duplicating its content. Let the reader follow links at their own pace.\n4. **Self-contained**: A note should be understandable on its own or by following a small number of wikilinks, not by requiring the reader to have read a long sequence of preceding notes.\n\n### Why Atomic\n\n- Atomic notes make focusing easier for the writer.\n- Atomic notes are easier to categorize (their tags align tightly with their content).\n- Atomic notes are more likely to be actively used and memorized.\n- Atomic notes are less intimidating for the reader.\n- Atomic notes enable the reader to learn at their own pace along their own preferred path.\n\n### Technical Notes\n\nFor technical notes (physics, mathematics, computer science), follow the narration-cycle structure from the `note-writer` skill: **motivation → discussion → results → remarks**. Separate narration cycles with horizontal rules (`---`). Titles indicate topics, not narration stages — do not use headings like \"## Motivation\".\n\n## 4. When and How to Use Wikilinks\n\n### When to Link\n\n- **Every mention of a concept that has (or should have) its own note**: If you write \"the [[Sochocki_formula]]\" and that concept deserves its own atomic note, link it. If the note does not yet exist, link anyway — SilverBullet shows it as a broken link that can be followed to create the page.\n- **Forward references**: In computer science notes especially, do not hesitate to link to concepts that have not been introduced yet. Arrange concepts in a natural rather than rigidly logical order.\n- **Cross-domain connections**: When a note spans domains (e.g. both physics and math), link to the relevant notes in each domain.\n\n### How to Link\n\n- **First mention**: Link the first occurrence of a concept in a note. Subsequent mentions in the same note need not be linked unless clarity demands it.\n- **Prefer `[[snake_case]]` page names**: Page names use `snake_case` (e.g. `[[mean_field_theory]]`, `[[second_quantization]]`). The H1 heading on the page may use title case or other formatting.\n- **Section links for precision**: When referring to a specific part of a long note, use `[[page_name#Section]]` to link directly to the relevant section.\n\n### When NOT to Link\n\n- Do not link common words or concepts that are universal knowledge in the note's domain.\n- Do not over-link within a single note; link the first mention and move on.\n\n## 5. Frontmatter Convention\n\nEvery note must include YAML frontmatter with at minimum the `finished` attribute:\n\n```yaml\n---\nfinished: false\n---\n```\n\n### The `finished` Attribute\n\n- `finished: false` — the note is a work in progress and needs further editing. It will appear on the `unfinished_pages` query.\n- `finished: true` — the note is in a stable state. This does not mean it will never be edited again, only that it is not actively incomplete.\n\n**Default**: Always set `finished: false` when creating a new note. Change to `finished: true` only when the note reaches a coherent, self-contained state.\n\n### Other Frontmatter Fields\n\n- `tags`: A YAML list of topic tags (alternative or supplement to inline hashtags). Example: `tags: [\"math/complex-analysis\"]`.\n- `url`, `date`, `title`: Used for reference pages (notes about external sources). See the reference page template.\n\n## 6. Note Creation Workflow\n\n1. Determine the single topic the note will address. If it covers more than one, split.\n2. Create the file with `snake_case.md` naming.\n3. Add frontmatter with `finished: false`.\n4. Add tag(s) — either as frontmatter `tags` list or inline `#domain/subdomain` lines.\n5. Write the H1 heading as the topic title.\n6. Write the note body following the atomic and (for technical notes) narration-cycle principles.\n7. Insert `[[wikilinks]]` for every concept that has or deserves its own note.\n8. When the note reaches a coherent state, set `finished: true`.\n\n## 7. Reference\n\n- Knowledge garden overview: `knowledge_garden.md`\n- Atomic notes philosophy: `atomic_notes.md`\n- Tag system details: `tag_system.md`\n- Technical note style: `technical_note.md`\n- SilverBullet links: https://silverbullet.md/Link\n- SilverBullet transclusions: https://silverbullet.md/Transclusions\n- SilverBullet hashtags: https://silverbullet.md/Markdown/Hashtags\n"
}
```

**Output:**
```
Wrote file successfully.
```

---

## Assistant (Build · GLM-5.1 · 8.7s)

Created the skill at `/Users/wentaoli/.config/opencode/skills/knowledge-garden/SKILL.md`. It covers all five requirements:

1. **Tagging system** — hierarchical `#domain/subdomain/smaller_subdomain` with conventions for placement and multi-tagging
2. **Markdown & wikilink syntax** — `[[page]]`, `[[page#Section]]`, `[[page|alias]]`, transclusions `![[page]]` and `![[page#Section]]`, and when to use each
3. **Atomic note style** — one topic per note, with rationale and technical note narration-cycle integration
4. **When and how to use wikilinks** — first-mention linking, forward references, snake_case naming, section links, and when not to link
5. **Default frontmatter** — `finished: false` on all new notes, with explanation of its semantics

---

## User

add some keywords to this skill file's frontmatter.

---

## Assistant (Build · GLM-5.1 · 3.9s)

_Thinking:_

The user wants me to add keywords to the skill file's frontmatter. Let me read the current file first to see what's there.

**Tool: read**

**Input:**
```json
{
  "filePath": "/Users/wentaoli/.config/opencode/skills/knowledge-garden/SKILL.md",
  "limit": 10
}
```

**Output:**
```
<path>/Users/wentaoli/.config/opencode/skills/knowledge-garden/SKILL.md</path>
<type>file</type>
<content>
1: ---
2: name: knowledge-garden
3: description: This skill should be used when writing, editing, or organizing notes in a SilverBullet-based knowledge garden. It covers the tagging system, wikilink and transclusion syntax, atomic note style, and frontmatter conventions specific to this space.
4: ---
5: 
6: # Knowledge Garden Skill
7: 
8: ## Purpose
9: 
10: This skill governs how to write, edit, and organize notes in a SilverBullet-based knowledge garden. The knowledge garden is a flat collection of interconnected markdown files where notes are linked by wikilinks, organized by a hierarchical tag system, and kept atomic — each note addresses one and only one topic.

(Showing lines 1-10 of 165. Use offset=11 to continue.)
</content>
```

---

## Assistant (Build · GLM-5.1 · 7.4s)

**Tool: edit**

**Input:**
```json
{
  "filePath": "/Users/wentaoli/.config/opencode/skills/knowledge-garden/SKILL.md",
  "oldString": "---\nname: knowledge-garden\ndescription: This skill should be used when writing, editing, or organizing notes in a SilverBullet-based knowledge garden. It covers the tagging system, wikilink and transclusion syntax, atomic note style, and frontmatter conventions specific to this space.\n---",
  "newString": "---\nname: knowledge-garden\ndescription: This skill should be used when writing, editing, or organizing notes in a SilverBullet-based knowledge garden. It covers the tagging system, wikilink and transclusion syntax, atomic note style, and frontmatter conventions specific to this space.\nkeywords:\n  - silverbullet\n  - knowledge-garden\n  - atomic-notes\n  - wikilinks\n  - transclusions\n  - tagging\n  - note-taking\n  - pkm\n  - zettelkasten\n  - frontmatter\n---"
}
```

**Output:**
```
Edit applied successfully.
```

---

## Assistant (Build · GLM-5.1 · 3.5s)

Done. Added keywords: `silverbullet`, `knowledge-garden`, `atomic-notes`, `wikilinks`, `transclusions`, `tagging`, `note-taking`, `pkm`, `zettelkasten`, `frontmatter`.

---

