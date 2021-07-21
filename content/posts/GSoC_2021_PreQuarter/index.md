---
title: "GSoC'21: Pre-Quarter Progress"
date: 2021-07-19T07:32:05+05:30
draft: false
categories: ["News", "GSoC"]
description: "Pre-Quarter Progress with Google Summer of Code 2021 project under NumFOCUS: Aitik Gupta"
displayInList: true
author: Aitik Gupta

resources:
- name: featuredImage
  src: "AitikGupta_GSoC.png"
  params:
    showOnTop: true
---

**“<ins>Well? Did you get it working?!</ins>”**

Before I answer that question, if you're missing the context, check out my [previous blog](https://matplotlib.org/matplotblog/posts/gsoc_2021_midterm/)'s last few lines.. promise it won't take you more than 30 seconds to get the whole problem!

With this short writeup, I intend to talk about _what_ we did and _why_ we did, what we did. XD

## Ostrich Algorithm
Ring any bells? Remember OS (Operating Systems)? It's one of the core CS subjects which I bunked then and regret now. (╥﹏╥)

The [wikipedia page](https://en.wikipedia.org/wiki/Ostrich_algorithm) has a 2-liner explaination if you have no idea what's an Ostrich Algorithm.. but I know most of y'all won't bother clicking it XD, so here goes:
> Ostrich algorithm is a strategy of ignoring potential problems by "sticking one's head in the sand and pretending there is no problem"

An important thing to note: it is used when it is more **cost-effective** to _allow the problem to occur than to attempt its prevention_.

As you might've guessed by now, we ultimately ended up with the *not-so-clean* API (more on this later).

## What was the problem?
The highest level overview of the problem was:

```
❌ fontTools -> buffer -> ttconv_with_buffer
✅ fontTools -> buffer -> tempfile -> ttconv_with_file
```
The first approach created corrupted outputs, however the second approach worked fine. A point to note here would be that *Method 1* is better in terms of separation of *reading* the file from *parsing* the data.

1. [fontTools](https://github.com/fonttools/fonttools) handles the Type42 subsetting for us, whereas [ttconv](https://github.com/matplotlib/matplotlib/tree/master/extern/ttconv) handles the embedding.
2. `ttconv_with_buffer` is a modification to the original `ttconv_with_file`; that allows it to input a file buffer instead of a file-path

You might be tempted to say:
> "Well, `ttconv_with_buffer` must be wrongly modified, duh."

Logically, yes. `ttconv` was designed to work with a file-path and not a file-object (buffer), and modifying a codebase **written in 1998** turned out to be a larger pain than we anticipated.
#### It came to a point where one of my mentors decided to implement everything in Python!
He even did, but <ins>the efforts</ins> to get it to production / or to fix `ttconv` embedding were ⋙ to just get on with the second method. That damn ostrich really helped us get out of that debugging hell. 🙃
## Font Fallback - initial steps
Finally, we're onto the second subgoal for the summer: [Font Fallback](https://www.w3schools.com/css/css_font_fallbacks.asp)!

To give an idea about how things work right now:
1. User asks Matplotlib to use certain font families, specified by:
```python
matplotlib.rcParams["font-family"] = ["list", "of", "font", "families"]
```
2. This list is used to search for available fonts on a user's system.
3. However, in current (and previous) versions of Matplotlib:
> <ins>As soon as a font is found by iterating the font-family, **all text** is rendered by that _and only that_ font.</ins>

You can immediately see the problems with this approach; using the same font for every character will not render any glyph which isn't present in that font, and will instead spit out a square rectangle called "tofu" (read the first line [here](https://www.google.com/get/noto/)).

And that is exactly the first milestone! That is, parsing the _<ins>entire list</ins>_ of font families to get an intermediate representation of a multi-font interface.
## Don't break, a lot at stake!
Imagine if you had the superpower to change Python standard library's internal functions, _without_ consulting anybody. Let's say you wanted to write a solution by hooking in and changing, let's say `str("dumb")` implementation by returning:
```ipython
>>> str("dumb")
["d", "u", "m", "b"]
```
Pretty "<ins>dumb</ins>", right? xD

For your usecase it might work fine, but it would also mean breaking the _entire_ Python userbase' workflow, not to mention the 1000000+ libraries that depend on the original functionality.

On a similar note, Matplotlib has a public API known as `findfont(prop: str)`, which when given a string (or [FontProperties](https://matplotlib.org/stable/api/font_manager_api.html#matplotlib.font_manager.FontProperties)) finds you a font that best matches the given properties in your system.

It is used <ins>throughout the library</ins>, as well as at multiple other places, including downstream libraries. Being naive as I was, I changed this function signature and submitted the [PR](https://github.com/matplotlib/matplotlib/pull/20496). 🥲

Had an insightful discussion about this with my mentors, and soon enough raised the [other PR](https://github.com/matplotlib/matplotlib/pull/20549), which didn't touch the `findfont` API at all.

---

One last thing to note: Even if we do complete the first milestone, we wouldn't be done yet, since this is just parsing the entire list to get multiple fonts..

We still need to migrate the library's internal implementation from **font-first** to **text-first**!


But that's for later, for now:
![OnceAgainThankingYou](https://user-images.githubusercontent.com/43996118/126441988-5a2067fd-055e-44e5-86e9-4dddf47abc9d.png)

#### NOTE: This blog post is also available at my [personal website](https://aitikgupta.github.io/gsoc-pre-quarter/).
