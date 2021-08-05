---
title: "GSoC'21: Quarter Progress"
date: 2021-08-03T18:48:00+05:30
draft: false
categories: ["News", "GSoC"]
description: "Quarter Progress with Google Summer of Code 2021 project under NumFOCUS: Aitik Gupta"
displayInList: true
author: Aitik Gupta

resources:
- name: featuredImage
  src: "AitikGupta_GSoC.png"
  params:
    showOnTop: true
---

**“<ins>Matplotlib, I want 多个汉字 in between my text.</ins>”**

Let's say you wanted some (多个汉字 -> multiple Chinese characters) in between your English text, to be rendered by Matplotlib.

Or conversely, let's say you use a Chinese font with Matplotlib, but you had English text in between (which is quite common).

> Assumption: the Chinese font doesn't have those English glyphs, and vice versa

With this short writeup, I'll talk about how does a migration from a font-first to a text-first approach in Matplotlib looks like, which ideally solves the above problem.
### Have the fonts?
Logically, the very first step to solving this would be to ask whether you _have_ multiple fonts, right?

Matplotlib doesn't ship [CJK](https://en.wikipedia.org/wiki/List_of_CJK_fonts) (Chinese Japanese Korean) fonts, which ideally contains these Chinese glyphs. It does try to cover most grounds with the [default font](https://matplotlib.org/stable/users/dflt_style_changes.html#normal-text) it ships with, however.

So if you don't have a font to render your Chinese characters, go ahead and install one! Matplotlib will find your installed fonts.
### Parse the fonts
This is where things get interesting, and what my [previous writeup](https://matplotlib.org/matplotblog/posts/gsoc_2021_prequarter/) was all about..

> Parsing the whole family to get multiple fonts for given font properties

## FT2Font Magic!
To give you an idea about how things used to work for Matplotlib:
1. A single font was chosen _at draw time_
		 (fixed: re [previous writeup]((https://matplotlib.org/matplotblog/posts/gsoc_2021_prequarter/)))
2. Every character displayed in your document was rendered by only that font
		 (partially fixed: re <ins>_this writeup_</ins>)

> FT2Font is a matplotlib-to-font module, which provides high-level Python API to interact with a _single font's operations_ like read/draw/extract/etc.

Being written in C++, the module needs wrappers around it to be converted into a [Python extension](https://docs.python.org/3/extending/extending.html) using Python's C-API.

> It allows us to use C++ functions directly from Python!

So wherever you see a use of font within the library (by library I mean the readable Python codebase XD), you could have derived that:
```
FT2Font === SingleFont
```

Things are be a bit different now however..
## Designing a multi-font system
FT2Font is basically itself a wrapper around a library called [FreeType](https://www.freetype.org/), which is a freely available software library to render fonts.

<p align="center">
    <figure>
        <img src="https://user-images.githubusercontent.com/43996118/128352387-76a3f52a-20fc-4853-b624-0c91844fc785.png" alt="FT2Font Naming" />
        <figcaption style="text-align: center; font-style: italic;">How FT2Font was named</figcaption>
    </figure>
</p>

In my initial proposal.. while looking around how FT2Font is structured, I figured:
```
Oh, looks like all we need are Faces!
```
> If you don't know what faces/glyphs/ligatures are, head over to why [Text Hates You](https://gankra.github.io/blah/text-hates-you/). I can guarantee you'll definitely enjoy some real life examples of why text rendering is hard. 🥲

Anyway, if you already know what Faces are, it might strike you:

If we already have all the faces we need from multiple fonts (let's say we created a child of FT2Font.. which only <ins>tracks the faces</ins> for its families), we should be able to render everything from that parent FT2Font right?

As I later figured out while finding segfaults in implementing this design:
```
Each FT2Font is linked to a single FT_Library object!
```

If you tried to load the face/glyph/character (basically anything) from a different FT2Font object.. you'll run into serious segfaults. (because one object linked to an `FT_Library` can't really access another object which has it's own `FT_Library`)
```cpp
// face is linked to FT2Font; which is
// linked to a single FT_Library object
FT_Face face = this->get_face();
FT_Get_Glyph(face->glyph, &placeholder); // works like a charm

// somehow get another FT2Font's face
FT_Face family_face = this->get_family_member()->get_face();
FT_Get_Glyph(family_face->glyph, &placeholder); // segfaults!
```

Realizing this took a good amount of time! After this I quickly came up with a recursive approach, wherein we:
1. Create a list of FT2Font objects within Python, and pass it down to FT2Font
2. FT2Font will hold pointers to its families via a \
		`std::vector<FT2Font *> fallback_list`
3. Find if the character we want is available in the current font
    1. If the character is available, use that FT2Font to render that character
    2. If the character isn't found, go to step 3 again, but now iterate through the `fallback_list`
4. That's it!

A quick overhaul of the above piece of code^
```cpp
bool ft_get_glyph(FT_Glyph &placeholder) {
	FT_Error not_found = FT_Get_Glyph(this->get_face(), &placeholder);
	if (not_found) return False;
	else return True;
}

// within driver code
for (uint i=0; i<fallback_list.size(); i++) {
	// iterate through all FT2Font objects
	bool was_found = fallback_list[i]->ft_get_glyph(placeholder);
	if (was_found) break;
}
```

With the idea surrounding this implementation, the [Agg backend](https://matplotlib.org/stable/api/backend_agg_api.html) is able to render a document (either through GUI, or a PNG) with multiple fonts!

<p align="center">
    <figure>
        <img src="https://user-images.githubusercontent.com/43996118/128347495-1f4f858d-33d3-4119-8732-5b26c4e9ca2a.png" alt="ChineseInBetween" />
        <figcaption style="text-align: center; font-style: italic;">PNG straight outta Matplotlib!</figcaption>
    </figure>
</p>

## Python C-API is hard, at first!
I've spent days at Python C-API's [argument doc](https://docs.python.org/3/c-api/arg.html), and it's hard to get what you need at first, ngl.

But, with the help of some amazing people in GSoC community ([@srijan-paul](https://srijan-paul.github.io/), [@atharvaraykar](https://atharvaraykar.me/)) and amazing mentors, blockers begone!

## So are we done?
Oh no. XD

Things work just fine for the Agg backend, but to generate a PDF/PS/SVG with multiple fonts is another story altogether! I think I'll save that for later.

<p align="center">
    <figure>
        <img src="https://user-images.githubusercontent.com/43996118/128350093-13695b91-5ad2-4f96-91f5-8373ee7a189e.gif" alt="ThankYouDwight" />
        <figcaption style="text-align: center; font-style: italic;">If you've been following the progress so far, mayn you're awesome!</figcaption>
    </figure>
</p>

#### NOTE: This blog post is also available at my [personal website](https://aitikgupta.github.io/gsoc-quarter/).
