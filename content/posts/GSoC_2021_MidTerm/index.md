---
title: "GSoC'21: Mid-Term Progress"
date: 2021-07-02T08:32:05+05:30
draft: false
categories: ["News", "GSoC"]
description: "Mid-Term Progress with Google Summer of Code 2021 project under NumFOCUS: Aitik Gupta"
displayInList: true
author: Aitik Gupta

resources:
- name: featuredImage
  src: "AitikGupta_GSoC.png"
  params:
    showOnTop: true
---

**"<ins>Aitik, how is your GSoC going?</ins>"**

Well, it's been a while since I last wrote. But I wasn't spending time watching _Loki_ either! (that's a lie.)

During this period the project took on some interesting (and stressful) curves, which I intend to talk about in this small writeup.
## New Mentor!
The first week of coding period, and I met one of my new mentors, [Jouni](https://github.com/jkseppan). Without him, along with [Tom](https://github.com/tacaswell) and [Antony](https://github.com/anntzer), the project wouldn't have moved _an inch_.

It was initially Jouni's [PR](https://github.com/matplotlib/matplotlib/pull/18143) which was my starting point of the first milestone in my proposal, <ins>Font Subsetting</ins>.

## What is Font Subsetting anyway?
As was proposed by Tom, a good way to understand something is to document your journey along the way! (well, that's what GSoC wants us to follow anyway right?)

Taking an excerpt from one of the paragraphs I wrote [here](https://github.com/matplotlib/matplotlib/blob/a94f52121cea4194a5d6f6fc94eafdfb03394628/doc/users/fonts.rst#subsetting):
> Font Subsetting can be used before generating documents, to embed only the _required_ glyphs within the documents. Fonts can be considered as a collection of these glyphs, so ultimately the goal of subsetting is to find out which glyphs are required for a certain array of characters, and embed only those within the output.

Now this may seem straightforward, right?
#### Wrong.
The glyph programs can call their own subprograms, for example, characters like `ä` could be composed by calling subprograms for `a` and `¨`; or `→` could be composed by a program that changes the display matrix and calls the subprogram for `←`.

Since the subsetter has to find out _all such subprograms_ being called by _every glyph_ included in the subset, this is a generally difficult problem!

Something which one of my mentors said which _really_ stuck with me:
> Matplotlib isn't a font library, and shouldn't try to be one.

It's really easy to fall into the trap of trying to do _everything_ within your own project, which ends up rather _hurting_ itself.
<hr>

To give an analogy, <ins>Google Docs</ins> try to do _a lot_ of things with its platform, from basic text editing to full-fledged project management.

Compared with <ins>Notion</ins>, whose whole _niche_ is to provide a platform for project management (among other things), **some people tend to choose the latter for their specific needs.**

<hr>

Since this analogy holds true even for Matplotlib, it uses external dependencies like [FreeType](https://www.freetype.org/), [ttconv](https://github.com/sandflow/ttconv), and newly proposed [fontTools](https://github.com/fonttools/fonttools) to handle font subsetting, embedding, rendering, and related stuff.

PS: If that font stuff didn't make sense, I would recommend going through a friendly tutorial I wrote, which is all about [Matplotlib and Fonts](https://matplotlib.org/stable/users/fonts.html)!
## Unexpected Complications
Matplotlib uses an external dependency `ttconv` which was initially forked into Matplotlib's repository **in 2003**!
>  ttconv was a standalone commandline utility for converting TrueType fonts to subsetted Type 3 fonts (among other features) written in 1995, which Matplotlib forked in order to make it work as a library.

Over the time, there were a lot of issues with it which were either hard to fix, or didn't attract a lot of attention. (See the above paragraph for a valid reason)

One major utility which is still used is `convert_ttf_to_ps`, which takes a _font path_ as input and converts it into a Type 3 or Type 42 PostScript font, which can be embedded within PS/EPS output documents. The guide I wrote (mentioned just above the recent heading) contains decent descriptions, the differences between these type of fonts, etc.

#### So we need to convert that _font path_ input to a _font buffer_ input.
Why do we need to? Type 42 subsetting isn't really supported by ttconv, so we use a new dependency called fontTools, whose 'full-time job' is to subset Type 42 fonts for us (among other things).

> It provides us with a font buffer, however ttconv expects a font path to embed that font

Easily enough, this can be done by Python's `tempfile.NamedTemporaryFile`:
```python
with tempfile.NamedTemporaryFile(suffix=".ttf") as tmp:
	# fontdata is the subsetted buffer
	# returned from fontTools
	tmp.write(fontdata.getvalue())

	# TODO: allow convert_ttf_to_ps
	# to input file objects (BytesIO)
	convert_ttf_to_ps(
		os.fsencode(tmp.name),
		fh,
		fonttype,
		glyph_ids,
	)
```

***But this is far from a clean API; in terms of separation of \*reading\* the file from \*parsing\* the data.***

What we _ideally_ want is to pass the buffer down to `convert_ttf_to_ps`, and modify the embedding code of `ttconv` (written in C++). And _here_ we come across a lot of unexplored codebase, _which wasn't touched a lot ever since it was forked_.

Funnily enough, just yesterday, after spending a lot of quality time, me and my mentors figured out that the **whole logging system of ttconv was broken**, all because of a single debugging function. 🥲

<hr>

This is still an ongoing problem that we need to tackle over the coming weeks, hopefully by the next time I write one of these blogs, it gets resolved!

Again, thanks a ton for spending time reading these blogs. :D
#### NOTE: This blog post is also available at my [personal website](https://aitikgupta.github.io/gsoc-mid/).
