---
title: "Aitik Gupta joins as a Student Developer under GSoC'21"
date: 2021-05-19T20:03:57+05:30
draft: false
categories: ["News", "GSoC"]
description: "Introduction about Aitik Gupta, Google Summer of Code 2021 Intern under the parent organisation: NumFOCUS"
displayInList: true
author: Aitik Gupta

resources:
- name: featuredImage
  src: "AitikGupta_GSoC.png"
  params:
    showOnTop: true
---

**<ins>The day of result, was a very, very long day.</ins>**

With this small writeup, I intend to talk about everything before _that day_, my experiences, my journey, and the role of Matplotlib throughout!

## About Me
I am a third-year undergraduate student currently pursuing a Dual Degree (B.Tech + M.Tech) in Information Technology at Indian Institute of Information Technology, Gwalior.

During my sophomore year, my interests started expanding in the domain of Machine Learning, where I learnt about various amazing open-source libraries like *NumPy*, *SciPy*, *pandas*, and *Matplotlib*! Gradually, in my third year, I explored the field of Computer Vision during my internship at a startup, where a big chunk of my work was to integrate their native C++ codebase to Android via JNI calls.

To actuate my learnings from the internship, I worked upon my own research along with a [friend from my university](https://linkedin.com/in/aaditagarwal). The paper was accepted in CoDS-COMAD’21 and is published at ACM Digital Library. ([Link](https://dl.acm.org/doi/abs/10.1145/3430984.3430986), if anyone's interested)

During this period, I also picked up the knack for open-source and started glaring at various issues (and pull requests) in libraries, including OpenCV [[contributions](https://github.com/opencv/opencv/issues?q=author%3Aaitikgupta+)] and NumPy [[contributions](https://github.com/numpy/numpy/issues?q=author%3Aaitikgupta+)].

I quickly got involved in Matplotlib’s community; it was very welcoming and beginner-friendly.

**Fun fact: Its dev call was the very first I attended with people from all around the world!**

## First Contributions
We all mess up, my [very first PR](https://github.com/opencv/opencv/pull/18440) to an organisation like OpenCV went horrible, till date, it looks like this:
![OpenCV_PR](https://user-images.githubusercontent.com/43996118/118848259-35d6e300-b8ec-11eb-8cdc-387e9f5a37a3.png)

In all honesty, I added a single commit with only a few lines of diff.
> However, I pulled all the changes from upstream `master` to my working branch, whereas the PR was to be made on `3.4` branch.

I'm sure I could've done tons of things to solve it, but at that time I couldn't do anything - imagine the anxiety!

At this point when I look back at those fumbled PRs, I feel like they were important for my learning process.

**Fun Fact: Because of one of these initial contributions, I got a shiny little badge [[Mars 2020 Helicopter Contributor](https://github.com/readme/nasa-ingenuity-helicopter)] on GitHub!**

<img src="https://github.githubassets.com/images/modules/profile/badge--mars-64.png" style="width: 25%">


## Getting started with Matplotlib
It was around initial weeks of November last year, I was scanning through `Good First Issue` and `New Feature` labels, I realised a pattern - most <ins>Mathtext</ins> related issues were unattended.

To make it simple, Mathtext is a part of Matplotlib which parses mathematical expressions and provides TeX-like outputs, for example:
<span><img src="https://matplotlib.org/stable/_images/mathmpl/math-050e387807.png" style="width: 25%"></span>

I scanned the related source code to try to figure out how to solve those Mathtext issues. Eventually, with the help of maintainers reviewing the PRs and <ins>a lot of verbose discussions</ins> on GitHub issues/pull requests and on the [Gitter](https://gitter.im/matplotlib/matplotlib) channel, I was able to get my initial PRs merged!

## Learning throughout the process
Most of us use libraries without understanding the underlining structure of them, which sometimes can cause downstream bugs!

While I was studying Matplotlib's architecture, I figured that I could use the same ideology for one of my [own projects](https://aitikgupta.github.io/swi-ml/)!

Matplotlib uses a global dictionary-like object named as `rcParams`, I used a smaller interface, similar to rcParams, in [swi-ml](https://pypi.org/project/swi-ml/) - a small Python library I wrote, implementing a subset of ML algorithms, with a <ins>switchable backend</ins>.


## Where does GSoC fit?
It was around January, I had a conversation with one of the maintainers (hey [Antony](https://github.com/anntzer)!) about the long-list of issues with the current ways of handling texts/fonts in the library.

After compiling them into an order, after few tweaks from maintainers, [GSoC Idea-List](https://github.com/matplotlib/matplotlib/wiki/GSOC-2021-ideas) for Matplotlib was born. And so did my journey of building a strong proposal!

## About the Project
#### Proposal Link: [Google Docs](https://docs.google.com/document/d/11PrXKjMHhl0rcQB4p_W9JY_AbPCkYuoTT0t85937nB0/edit?usp=sharing) (will stay alive after GSoC), [GSoC Website](https://storage.googleapis.com/summerofcode-prod.appspot.com/gsoc/core_project/doc/6319153410998272_1617936740_GSoC_Proposal_-_Matplotlib.pdf?Expires=1621539234&GoogleAccessId=summerofcode-prod%40appspot.gserviceaccount.com&Signature=QU8uSdPnXpa%2FooDtzVnzclz809LHjh9eU7Y7iR%2FH1NM32CBgzBO4%2FFbMeDmMsoic91B%2BKrPZEljzGt%2Fx9jtQeCR9X4O53JJLPVjw9Bg%2Fzb2YKjGzDk0oFMRPXjg9ct%2BV58PD6f4De1ucqARLtHGjis5jhK1W08LNiHAo88NB6BaL8Q5hqcTBgunLytTNBJh5lW2kD8eR2WeENnW9HdIe53aCdyxJkYpkgILJRoNLCvp111AJGC3RLYba9VKeU6w2CdrumPfRP45FX6fJlrKnClvxyf5VHo3uIjA3fGNWIQKwGgcd1ocGuFN3YnDTS4xkX3uiNplwTM4aGLQNhtrMqA%3D%3D) (not so sure)

### Revisiting Text/Font Handling
The aim of the project is divided into 3 subgoals:

1. **Font-Fallback**: A redesigned text-first font interface - essentially parsing all family before rendering a "tofu".

    *(similar to specifying <ins>font-family in CSS</ins>!)*
2. **Font Subsetting**: Every exported PS/PDF would contain embedded glyphs subsetted from the whole font.

    *(imagine a plot with just a single letter "a", would you like it if the PDF you exported from Matplotlib to <ins>embed the whole font</ins> file within it?)*

3. Most mpl backends would use the <ins>unified TeX exporting</ins> mechanism

**Mentors** [Thomas A Caswell](https://github.com/tacaswell), [Antony Lee](https://github.com/anntzer), [Hannah](https://github.com/story645).

Thanks a lot for spending time reading the blog! I'll be back with my progress in subsequent posts.


##### NOTE: This blog post is also available at my [personal website](https://aitikgupta.github.io/gsoc-intro/)!

