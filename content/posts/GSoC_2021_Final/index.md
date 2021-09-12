---
title: "GSoC'21: Final Report"
date: 2021-08-17T17:36:40+05:30
draft: false
categories: ["News", "GSoC"]
description: "Google Summer of Code 2021: Final Report - Aitik Gupta"
displayInList: true
author: Aitik Gupta

resources:
- name: featuredImage
  src: "AitikGupta_GSoC.png"
  params:
    showOnTop: true
---

**<ins>Matplotlib: Revisiting Text/Font Handling</ins>**

To kick things off for the final report, here's a [meme](https://user-images.githubusercontent.com/43996118/129448683-bc136398-afeb-40ac-bbb7-0576757baf3c.jpg) to nudge about the [previous blogs](https://matplotlib.org/matplotblog/categories/gsoc/).
## About Matplotlib
Matplotlib is a comprehensive library for creating static, animated, and interactive visualizations, which has become a _de-facto Python plotting library_.

Much of the implementation behind its font manager is inspired by [W3C](https://www.w3.org/) compliant algorithms, allowing users to interact with font properties like `font-size`, `font-weight`, `font-family`, etc.

#### However, the way Matplotlib handled fonts and general text layout was not ideal, which is what Summer 2021 was all about.

> By "not ideal", I do not mean that the library has design flaws, but that the design was engineered in the early 2000s, and is now _outdated_.

(..more on this later)

### About the Project
(PS: here's [the link](https://docs.google.com/document/d/11PrXKjMHhl0rcQB4p_W9JY_AbPCkYuoTT0t85937nB0/view#heading=h.feg5pv3x59u2) to my GSoC proposal, if you're interested)

Overall, the project was divided into two major subgoals:
1. Font Subsetting
2. Font Fallback

But before we take each of them on, we should get an idea about some basic terminology for fonts (which are a _lot_, and are rightly _confusing_)

The [PR: Clarify/Improve docs on family-names vs generic-families](https://github.com/matplotlib/matplotlib/pull/20346/files) brings about a bit of clarity about some of these terms. The next section has a linked PR which also explains the types of fonts and how that is relevant to Matplotlib.
## Font Subsetting
An easy-to-read guide on Fonts and Matplotlib was created with [PR: [Doc] Font Types and Font Subsetting](https://github.com/matplotlib/matplotlib/pull/20450), which is currently live at [Matplotlib's DevDocs](https://matplotlib.org/devdocs/users/fonts.html).

Taking an excerpt from one of my previous blogs (and [the doc](https://matplotlib.org/devdocs/users/fonts.html#subsetting)):

> Fonts can be considered as a collection of these glyphs, so ultimately the goal of subsetting is to find out which glyphs are <ins>required</ins> for a certain array of characters, and embed <ins>only those</ins> within the output.

PDF, PS/EPS and SVG output document formats are special, as in **the text within them can be <ins>editable</ins>**, i.e, one can copy/search text from documents (for eg, from a PDF file) if the text is editable.

### Matplotlib and Subsetting
The PDF, PS/EPS and SVG backends used to support font subsetting, _only for a few types_. What that means is, before Summer '21, Matplotlib could generate Type 3 subsets for PDF, PS/EPS backends, but it <ins>*could not*</ins> generate Type 42 / TrueType subsets.

With [PR: Type42 subsetting in PS/PDF](https://github.com/matplotlib/matplotlib/pull/20391) merged in, users can expect their PDF/PS/EPS documents to contains subsetted glyphs from the original fonts.

This is especially benefitial for people who wish to use <ins>commercial</ins> (or [CJK](https://en.wikipedia.org/wiki/CJK_characters)) fonts. Licenses for many fonts ***require*** subsetting such that they can’t be trivially copied from the output files generated from Matplotlib.

## Font Fallback
Matplotlib was designed to work with a single font at runtime. A user _could_ specify a `font.family`, which was supposed to correspond to [CSS](https://www.w3schools.com/cssref/pr_font_font-family.asp) properties, but that was only used to find a _single_ font present on the user's system.

Once that font was found (which is almost always found, since Matplotlib ships with a set of default fonts), all the user text was rendered only through that font. (which used to give out "<ins>tofu</ins>" if a character wasn't found)

---

It might seem like an _outdated_ approach for text rendering, now that we have these concepts like font-fallback, <ins>but these concepts weren't very well discussed in early 2000s</ins>. Even getting a single font to work _was considered a hard engineering problem_.

This was primarily because of the lack of **any standardization** for representation of fonts (Adobe had their own font representation, and so did Apple, Microsoft, etc.)


| ![Previous](https://user-images.githubusercontent.com/43996118/128605750-9d76fa4a-ce57-45c6-af23-761334d48ef7.png) | ![After](https://user-images.githubusercontent.com/43996118/128605746-9f79ebeb-c03d-407e-9e27-c3203a210908.png) |
|--------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------|
<p align="middle">
    <ins>Previous</ins> (notice <i>Tofus</i>) VS  <ins>After</ins> (CJK font as fallback)
</p>

To migrate from a font-first approach to a text-first approach, there are multiple steps involved:

### Parsing the whole font family
The very first (and crucial!) step is to get to a point where we have multiple font paths (ideally individual font files for the whole family). That is achieved with either:
- [PR: [with findfont diff] Parsing all families in font_manager](https://github.com/matplotlib/matplotlib/pull/20496), or
- [PR: [without findfont diff] Parsing all families in font_manager](https://github.com/matplotlib/matplotlib/pull/20549)

Quoting one of my [previous](https://matplotlib.org/matplotblog/posts/gsoc_2021_prequarter/) blogs:
> Don’t break, a lot at stake!

My first approach was to change the existing public `findfont` API to incorporate multiple filepaths. Since Matplotlib has a _very huge_ userbase, there's a high chance it would break a chunk of people's workflow:

<p align="center">
  <img src="https://user-images.githubusercontent.com/43996118/129636132-47b141b3-f149-49b7-b0c0-67c256bd6ee1.png" alt="FamilyParsingFlowChart" width="60%" />
  First PR (left), Second PR (right)
</p>

### FT2Font Overhaul
Once we get a list of font paths, we need to change the internal representation of a "font". Matplotlib has a utility called FT2Font, which is written in C++, and used with wrappers as a Python extension, which in turn is used throughout the backends. For all intents and purposes, it used to mean: ```FT2Font === SingleFont``` (if you're interested, here's a [meme](https://user-images.githubusercontent.com/43996118/128352387-76a3f52a-20fc-4853-b624-0c91844fc785.png) about how FT2Font was named!)

But that is not the case anymore, here's a flowchart to explain what happens now:
<p align="center">
  <img src="https://user-images.githubusercontent.com/43996118/129720023-14f5d67f-f279-433f-ad78-e5eccb6c784a.png" alt="FamilyParsingFlowChart" width="100%" />
  Font-Fallback Algorithm
</p>

With [PR: Implement Font-Fallback in Matplotlib](https://github.com/matplotlib/matplotlib/pull/20740), every FT2Font object has a `std::vector<FT2Font *> fallback_list`, which is used for filling the parent cache, as can be seen in the self-explanatory flowchart.

For simplicity, only one type of cache (<ins>character -> FT2Font</ins>) is shown, whereas in actual implementation there's 2 types of caches, one shown above, and another for glyphs (<ins>glyph_id -> FT2Font</ins>).

> Note: Only the parent's APIs are used in some backends, so for each of the individual public functions like `load_glyph`, `load_char`, `get_kerning`, etc., we find the FT2Font object which has that glyph from the parent FT2Font cache!

### Multi-Font embedding in PDF/PS/EPS
Now that we have multiple fonts to render a string, we also need to embed them for those special backends (i.e., PDF/PS, etc.). This was done with some patches to specific backends:
- [PR: Implement multi-font embedding for PDF Backend](https://github.com/matplotlib/matplotlib/pull/20804)
- [PR: Implement multi-font embedding for PS Backend](https://github.com/matplotlib/matplotlib/pull/20832)

With this, one could create a PDF or a PS/EPS document with multiple fonts which are embedded (and subsetted!).

## Conclusion
From small contributions to eventually working on a core module of such a huge library, the road was not what I had imagined, and I learnt a lot while designing solutions to these problems.

#### The work I did would eventually end up affecting every single Matplotlib user.
...since all plots will work their way through the new codepath!

I think that single statement is worth the <ins>whole GSoC project</ins>.

### Pull Request Statistics
For the sake of statistics (and to make GSoC sound a bit less intimidating), here's a list of contributions I made to Matplotlib <ins>before Summer '21</ins>, most of which are only a few lines of diff:

|  Created At  	| PR Title                                                                                                                	|       Diff      	| Status 	|
|:------------:	|-------------------------------------------------------------------------------------------------------------------------	|:---------------:	|:------:	|
|  Nov 2, 2020 	| [Expand ScalarMappable.set_array to accept array-like inputs](https://github.com/matplotlib/matplotlib/pull/18870)      	|     (+28 −4)    	| MERGED 	|
|  Nov 8, 2020 	| [Add overset and underset support for mathtext](https://github.com/matplotlib/matplotlib/pull/18916)                    	|     (+71 −0)    	| MERGED 	|
| Nov 14, 2020 	| [Strictly increasing check with test coverage for streamplot grid](https://github.com/matplotlib/matplotlib/pull/18947) 	|     (+54 −2)    	| MERGED 	|
| Jan 11, 2021 	| [WIP: Add support to edit subplot configurations via textbox](https://github.com/matplotlib/matplotlib/pull/19271)      	|    (+51 −11)    	|  DRAFT 	|
| Jan 18, 2021 	| [Fix over/under mathtext symbols](https://github.com/matplotlib/matplotlib/pull/19314)                                  	| (+7,459 −4,169) 	| MERGED 	|
| Feb 11, 2021 	| [Add overset/underset whatsnew entry](https://github.com/matplotlib/matplotlib/pull/19497)                              	|    (+28 −17)    	| MERGED 	|
| May 15, 2021 	| [Warn user when mathtext font is used for ticks](https://github.com/matplotlib/matplotlib/pull/20235)                   	|     (+28 −0)    	| MERGED 	|

Here's a list of PRs I opened <ins>during Summer'21</ins>:
- [Status: ✅] [Clarify/Improve docs on family-names vs generic-families](https://github.com/matplotlib/matplotlib/pull/20346)
- [Status: ✅] [Add parse_math in Text and default it False for TextBox](https://github.com/matplotlib/matplotlib/pull/20367)
- [Status: ✅] [Type42 subsetting in PS/PDF](https://github.com/matplotlib/matplotlib/pull/20391)
- [Status: ✅] [[Doc] Font Types and Font Subsetting](https://github.com/matplotlib/matplotlib/pull/20450)
- [Status: 🚧] [[with findfont diff] Parsing all families in font_manager](https://github.com/matplotlib/matplotlib/pull/20496)
- [Status: 🚧] [[without findfont diff] Parsing all families in font_manager](https://github.com/matplotlib/matplotlib/pull/20549)
- [Status: 🚧] [Implement Font-Fallback in Matplotlib](https://github.com/matplotlib/matplotlib/pull/20740)
- [Status: 🚧] [Implement multi-font embedding for PDF Backend](https://github.com/matplotlib/matplotlib/pull/20804)
- [Status: 🚧] [Implement multi-font embedding for PS Backend](https://github.com/matplotlib/matplotlib/pull/20832)


## Acknowledgements
From learning about software engineering fundamentals from [Tom](https://github.com/tacaswell) to learning about nitty-gritty details about font representations from [Jouni](https://github.com/jkseppan);

From learning through [Antony](https://github.com/anntzer)'s patches and pointers to receiving amazing feedback on these blogs from [Hannah](https://github.com/story645), it has been an adventure! 💯

_Special Mentions: [Frank](https://github.com/sauerburger), [Srijan](https://github.com/srijan-paul) and [Atharva](https://github.com/tfidfwastaken) for their helping hands!_

And lastly, _you_, the reader; if you've been following my [previous blogs](https://matplotlib.org/matplotblog/categories/gsoc/), or if you've landed at this one directly, I thank you nevertheless. (one last [meme](https://user-images.githubusercontent.com/43996118/126441988-5a2067fd-055e-44e5-86e9-4dddf47abc9d.png), I promise!)

I know I speak for every developer out there, when I say <ins>***it means a lot***</ins> when you choose to look at their journey or their work product; it could as well be a tiny website, or it could be as big as designing a complete library!

<hr>

> I'm grateful to [Maptlotlib](https://matplotlib.org/) (under the parent organisation: [NumFOCUS](https://numfocus.org/)), and of course, [Google Summer of Code](https://summerofcode.withgoogle.com/) for this incredible learning opportunity.

Farewell, reader! :')

<p align="center">
  <img src="https://user-images.githubusercontent.com/43996118/118876008-5e6dd580-b90a-11eb-96db-0abc930c6993.png" alt="MatplotlibGSoC" />
  Consider contributing to Matplotlib (Open Source in general) ❤️
</p>

#### NOTE: This blog post is also available at my [personal website](https://aitikgupta.github.io/gsoc-final/).
