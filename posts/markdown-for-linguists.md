---
title: Markdown for linguists
published: 2020-08-27
tags: linguistics, writing, software, markdown, pandoc
---

# Introduction

Here, I want to make the case for using Markdown as a linguist by anecdote. Maybe this is like those [cooking blogs](https://twitter.com/redford/status/1256988715349471232) that provide rambling, irrelevant stories before getting to the recipe you're there for. In any case, I describe the tools and workflow that I use in the [next section](#setup), if that's what you're here for.

Anyway, I used to do virtually all of my writing in LaTeX, like many linguists. There are many advantages to using LaTeX. It's relatively easy to write mathematical formulae, it renders professional and easy to read documents, it's immensely customizable, there are many useful linguistics-specific packages, and so on. On top of all that, [Overleaf](https://www.overleaf.com/) provides a convenient Google Docs-like cloud service so there's no need to worry about different installations on different machines.

But writing in LaTeX *sucks*. As typesetting software, it's excellent, but for actually putting words on the page, I find it extremely cumbersome. I find it hard to maintain a steady writing flow. If something renders weird or if there's an error---it's not hard to miss a closing bracket---who knows how long it might take to fix. Also LaTeX markup is ugly and I do a lot of my editing in the same document I write in. These are maybe petty complaints, but when I'm trying to write, *I just wanna write*.

Two other factors caused me to look for an alternative, both involving Overleaf. While I love Overleaf, some mysterious behavior on the site caused me to lose paragraphs of writing. I also use [Zotero](https://www.zotero.org/) to manage my bibliography, and the way it was integrated with Overleaf was not ideal for me.

While all of this stuff was annoying, I wasn't going back to Word or Google Docs. Nothing is more annoying than encountering phantom italics, or strange font mismatches, or mysteriously corrupted documents. I prefer plain text documents for this very reason. Plus many of the benefits of LaTeX, especially math support and tree rendering, are too good to give up. Finally, and maybe more radically, I wanted to sever *content* from *typesetting* as much as possible, which LaTeX gets close to, but doesn't quite achieve. When I work on the content, I don't want to worry about the typesetting of that content and vice versa.

The solution to these problems for me is [Markdown](https://en.wikipedia.org/wiki/Markdown) with [Pandoc](https://pandoc.org/). Markdown is a fairly straightforward and readable plain text markup language. If you want to make something italic, you just put it between `*` like so: `*italic thing*`. If you want to include something in bold, you put it between `**` like so: `**bold thing**`. If you want to include a header, there's a few options, but here's a simple one:

    # Header

    Rest of document.

What if you want subheaders, or subsubheaders? Easy, add more `#`:

    ## Subheader

    ### Subsubheader

This is just to illustrate that Markdown is pretty simple, independently legible, and captures the bread and butter of document creation.

Pandoc is what makes the whole thing work, though. Pandoc is a program that converts documents from one format to another, like Markdown to docx or HTML. Or most importantly, pdf *via* LaTeX [^pdf]. Pandoc's markdown implements a number of functions that you might be familiar with from LaTeX, including math support and footnotes. It also supports citations with .bib files, working well with Zotero with the [Better BibTeX extension](https://github.com/retorquere/zotero-better-bibtex). Essentially all of the formatting stuff can be done in separate metadata or template files. There are far too many details to list here, and you can find the details in [Pandoc's manual](https://pandoc.org/MANUAL.html). Almost every feature I used in LaTeX was represented in some way in Pandoc's markdown.[^html]

[^pdf]: Pandoc first converts Markdown to LaTeX and then compiles that LaTeX into a pdf. As will probably be clear, this gets us basically all LaTeX functionality for free.

[^html]: Pandoc also has applications beyond document creation, like in web development. This blog post, for example, is written in markdown and then converted to html through Hakyll's Pandoc support. Pretty cool! I don't have full-fledged math support set up as of publication, but I still could, if I chose, render mathematical formulae like $\exists x\forall y [\phi(y)\to\psi(y,x)]$. I'll graciously spare you from that for the time being.

Unfortunately (and unsurprisingly), Pandoc's markdown doesn't support interlinear glosses in an intuitive way. Obviously this renders Pandoc unusable for most linguists. Because Pandoc is so flexible there are several work-arounds. Pandoc supports raw LaTeX, so we could simply drop, say, raw [gb4e](https://ctan.org/pkg/gb4e?lang=en) syntax in the document with the appropriate fences that tell Pandoc it's raw LaTeX. But putting all numbered examples in raw LaTeX like that makes the document increasingly illegible, which neuters one of the reasons to use Markdown in the first place.

The solution to this is Pandoc's filter support. The mechanics of Pandoc aren't really important, but the idea is that when converting from one document to another, it builds an abstract representation of the input document and then converts that abstract representation to the output format. Filters operate on this abstract structure, which has advantages over running a script over the input or output documents themselves.

So, I wrote a filter, [pangb4e](https://github.com/gunnarnl/pangb4e), that basically implements a simple Markdown friendly syntax for numbered examples and glossing, which generates gb4e syntax when converting to LaTeX/pdf.

So a numbered example containing a gloss and a label looks like this in Markdown:

```markdown
(@) {#example}
    \gll C'est un gloss.
    [dem.cop]{.smallcaps} a gloss
    "This is a gloss.
```

And renders just as the following gb4e syntax would in a LaTeX document:

```latex
\begin{exe}
    \ex\label{example} \gll C'est un gloss.
    [dem.cop]{.smallcaps} a gloss
    "This is a gloss.
\end{exe}
```
There are more examples in the link there. What about trees? For now, unfortunately, I have to use raw LaTeX blocks[^tree] or include an image.

[^tree]: Tree syntax isn't going to be very legible in any case, so I don't consider this a huge problem.

# Tools and workflow {#setup}

My setup will probably seem obnoxiously similar to that of a software developer (and maybe it is obnoxious!), but software development and academic writing are not all that different in the year 2020. Software development involves one or more people writing source code---plain text files---which is then compiled into a finished product---a program. The source code is where most of the work is done, and developers want to be able to integrate each other's code and track and compare changes in the code over time. Compiling the program might involve all kinds of dependencies, which developers will also want to keep track of and ensure are in working order. This is not really any different than the process that academics using LaTeX use: we write in plain text tex files---the "source code"---and compile them into pdfs---the finished product. Compilation of these documents might involve dependencies like figures stored as images. Projects with multiple authors need to share up-to-date versions of these documents so that the authors don't end up diverging too much.

Software developers have sophisticated tools to manage products, and I see no reason to reinvent the wheel. I've tried to write this post for linguists who aren't necessarily familiar with the tools discussed below. Hopefully I've succeeded, and the gist is conveyed clearly. Most of this stuff is of the easy-to-learn-hard-to-master variety. I think for a linguist, a basic understanding is all you'd need to successfully use this workflow. Much of this stuff is applicable beyond document creation, and should integrate well with work that involves statistical methods (e.g., R/Python coding), which is increasingly common in the field.

I do assume a Unix-based OS (Mac/Linux), and the view probably looks pretty different from Windows, especially where the command-line is concerned.

## Atom

My text editor of choice is [Atom](atom.io). For Markdown syntax support, I use *language-pfm*, and *markdown-preview-plus* to preview.

To make Atom more amenable to writing than programming, I use the *pen paper coffee* theme, and the *typewriter* package to clean things up. If you use one pane, the *zen* package might be preferable.

Atom has a useful [snippets](https://flight-manual.atom.io/using-atom/sections/snippets/) tool that generates a lot of commonly used syntax easily. I have a snippet for numbered examples, for example.

Additionally, I generally use a two pane setup. The left pane is the document I'm writing, and the right pane contains fieldwork data (which is stored in plain text files in Toolbox format), the preview through *markdown-preview-plus*, or an overlaid pdf.

I use Atom to code as well, so it's a nice one stop shop for most of the work I'm doing.

## Zotero

For references, I use [Zotero](https://www.zotero.org/). Zotero is an extremely useful reference management tool. It manages pdfs and other files connected to those references, and has cloud storage for both references and pdfs. This takes a lot of the headache out of finding pdfs on my computer and building a bibliography in my documents. It's also free and open source, unlike other reference management software. I highly endorse it. Even if the rest of this seems unappealing, check out Zotero. I wish I had discovered it when I had started grad school.

To use those references with Pandoc, I use the [Better BibTeX extension](https://github.com/retorquere/zotero-better-bibtex) to export my citations as one big .bib file that Pandoc can access. It also organizes the citation keys, making them easy to remember.[^refs]

[^refs]: There's a few Atom packages that integrate with Zotero. I've tried a few, but because the keys I use are so simple (e.g., `author2020`), I don't usually need to look them up. I just need to know the first author's name and the year.

## Git and Github

While I was moving to Markdown, I was also reorganizing my projects as [git](https://git-scm.com/) repositories. Git is a version control tool that tracks changes to projects over time, and enables collaboration by ensuring that everyone is on the same page.

This is obviously useful for tracking the evolution of a document over time. It is probably also useful for collaboration, but I admittedly haven't had the opportunity to use it in that way yet and can't comment on how well it works relative to other collaboration tools.

For cloud storage, I use [Github](https://github.com/). For projects that involve proprietary data (corpora for instance), I set these repositories to push to Google Drive.

## Pandoc

I configure Pandoc differently depending on what I'm rendering, big surprise. If the document is part of a larger project or one that requires a lot of arguments to Pandoc, I usually write a Makefile. Generally, my arguments will include a separate metadata file for formatting, a file that will be included as a header for LaTeX/pdf rendering, a number of Lua filters, and Pandoc-Citeproc for citation support.

### Metadata and header file

I use yaml-formatted metadata files to spell out formatting parameters. Here's a sample:

```yaml
---
bibliography: path/to/bibliography.bib
csl: path/to/ussfl.csl
reference-section-title: References

fontsize: 12pt
margin-left: 1.25in
margin-right: 1.25in
margin-top: 1in
margin-bottom: 1in
fontfamily: mathpazo
indent: true
numbersections: true
linestretch: 1.5
---
```

Most of these parameters should be fairly self-explanatory. Notice that the csl file tells Pandoc to format citations using the [Unified Style Sheet for Linguistics](https://www.linguisticsociety.org/resource/unified-style-sheet). This was pulled from Zotero's style repository.

The header file is just used to tell LaTeX to load some additional packages and LaTeX commands. This could also be done by modifying the LaTeX template that Pandoc uses directly. I haven't needed to do this, and the header file is safer and more transparent.

### Lua filters

Pandoc's functionality can be greatly increased with the use of filters. It's possible to write filters for Pandoc in its native Haskell or in Python, but Pandoc also has a built in Lua interpreter with a library for working with Pandoc's abstract structure trees. Lua filters are easy to write, and because Lua support is provided by Pandoc itself, the user doesn't need to worry about having Haskell or Python installed on their system.

Again, I get interlinear glossing support from [pangb4e](https://github.com/gunnarnl/pangb4e). This simply translates a markdown-esque syntax for numbered examples into gb4e syntax when converting documents to LaTeX or pdf *via* LaTeX.

In addition, I have filters that allow me to make colored text for comments to myself in pdfs, and a filter[^secnum] that inserts proper section numbers when I reference them in the document.

There's plenty of others [here](https://github.com/pandoc/lua-filters).

[^secnum]: Based on [this Stack Overflow post](https://stackoverflow.com/questions/54128461/how-to-use-latex-section-numbers-in-pandoc-cross-reference).

### Makefile

Pandoc is usually run just by plugging a command like the following into the command line:

    pandoc document.md -o document.pdf

This will convert a markdown file called "document.md" into a pdf called "document.pdf", both in the current working directory.

However, because my workflow involves a number of filters and external documents, converting to pdf would look more like this:

    pandoc document.md -o document.pdf --metadata-file=path/to/metadata-files/metadata.yaml --include-in-header=path/to/metadata-files/header.tex --filter pandoc-citeproc --lua-filter path/to/lua-filters/pangb4e.lua --lua-filter path/to/lua-filters/comments.lua --lua-filter path/to/lua-filters/sectionnumbers.lua

Obviously this is a line-full to type. Instead of typing this every time I want to compile a document, I instead usually use a [Makefile](https://www.gnu.org/software/make/manual/html_node/Overview.html) in the folder the document is housed. Then, all I have to do is run `make` from the terminal in the respective folder. An extremely simple and useful Makefile could look like this:

```makefile
pdf:
    pandoc document.md -o document.pdf \
    --metadata-file=path/to/metadata-files/metadata.yaml \
    --include-in-header=path/to/metadata-files/header.tex \
    --filter pandoc-citeproc \
    --lua-filter path/to/lua-filters/pangb4e.lua \
    --lua-filter path/to/lua-filters/comments.lua \
    --lua-filter path/to/lua-filters/sectionnumbers.lua

all: pdf

clean:
    rm -f document.pdf
```

If you run `make` in the folder with this Makefile, it'll run that `pandoc` command from earlier. If you run `make clean`, it'll delete those files. Make can also track dependencies, run multiple commands in one go or selectively, and more. There's a lot to be said about using Makefiles with Pandoc that I'll leave unsaid here.

## Workflow from a bird's eye view

First, I create a folder for the project and copy over a template main markdown file, metadata yaml file, header tex file, and Makefile. Then I initialize a git repository, and hook it up to Github. Then I write in the main markdown file, and push to Github, write in the main markdown file, and push to Github, and so on. When I've got some real material in the document, I'll run `make` to check on the pdf, play with the formatting in metadata file if need be, etc., then go back to writing. Then, I'll repeat this process *ad infinitum* because no project is ever finished.

You might be wondering: "What about errors???" I rarely encounter serious errors compiling documents this way. When I do, it's usually because I've stuck something weird in a math or raw LaTeX span, which sufficiently limits where I need to look for the source of the error. One con with this workflow is that if I do need to look deeper for the error, I have to convert the markdown file to a .tex file and cross-reference the line number indicated in the error message with that file. This isn't that different from a usual LaTeX workflow, though, and overall I've had to deal with significantly fewer errors because I'm writing significantly fewer LaTeX commands.
