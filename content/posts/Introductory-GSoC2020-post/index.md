---
title: "Sidharth Bansal joined as GSoC'20 intern"
date: 2020-05-06T21:47:36+05:30
draft: false
categories: ["News", "GSoC"]
description: "Introductory post about Sidharth Bansal, Google Summer of Code 2020 Intern for Baseline Image Problem Project under Numfocus"
displayInList: true
author: Sidharth Bansal

resources:
- name: featuredImage
  src: "GSoC.png"
  params:
    showOnTop: true
---

When I, Sidharth Bansal, heard I got selected in Google Summer of Code(GSOC) 2020 with Matplotlib under Numfocus, I was jumping and dancing. In this post, I talk about my past experiences, how I got selected for GSOC with Matplotlib, and my project details. 
I am grateful to the community :)


## About me: 

I am currently pursuing a Bachelor’s in Technology in Software Engineering at Delhi Technological University, Delhi, India. I started my journey of open source with Public Lab, an open-source organization as a full-stack Ruby on Rails web developer. I initially did the Google Summer of Code there. I built a Multi-Party Authentication System which involves authentication of the user through multiple websites linked like mapknitter.org and spectralworkbench.org with OmniAuth providers like Facebook, twitter, google, and Github. I also worked on a Multi-Tag Subscription project there. It involved tag/category subscription by the user so that users will be notified of subsequent posts in the category they subscribe to earlier. I have also mentored there as for Google Code-In and GSoC last year. I also worked there as a freelancer.

Apart from this, I also successfully completed an internship in the Google Payments team at Google, India this year as a Software Engineering Intern. I built a PAN Collection Flow there. PAN(Taxation Number) information is collected from the user if the total amount claimed by the user through Scratch cards in the current financial year exceeds PAN_LIMIT. Triggered PAN UI at the time of scratching the reward. Enabled Paisa-Offers to uplift their limit to grant Scratch Cards after crossing PAN_LIMIT. Used different technologies like Java, Guice, Android, Spanner Queues, Protocol Buffers, JUnit, etc.

I also have a keen interest in Machine Learning and Natural Language Processing and have done a couple of projects at my university. I have researched on `Query Expansion using fuzzy logic`. I will be publishing it in some time. It involves the fuzzification of the traditional wordnet for query expansion. 

Our paper `Experimental Comparison & Scientometric Inspection of Research for Word Embeddings` got accepted in ESCI Journal and Springer LNN past week.  It explains the ongoing trends in universal embeddings and compares them.

## Getting started with matplotlib

I chose matplotlib as it is an organization with so much cool stuff relating to plotting. I have always wanted to work on such things. People are really friendly, always eager to help!

## Taking Baby steps:

The first step is getting involved with the community. I started using the Gitter channel to know about the maintainers. I started learning the different pieces which tie up for the baseline image problem. I started with learning the system architecture of matplotlib. Then I installed the matplotlib, learned the cool tech stack related to matplotlib like sphinx, python, pypi etc.

## Keep on contributing and keep on learning:

Learning is a continuous task. Taking guidance from mentors about the various use case scenarios involved in the GSoC project helped me to gain a lot of insights. I solved a couple of small issues. I learned about the code-review process followed here, sphinx documentation, how releases work. I did [some PRs](https://github.com/matplotlib/matplotlib/pulls?q=is%3Apr+author%3ASidharthBansal+is%3Aclosed). It was a great learning experience.   

## About the Project:

[The project](https://github.com/matplotlib/matplotlib/issues/16447) is about the generation of baseline images instead of downloading them. The baseline images are problematic because they cause the repo size to grow rather quickly by adding more baseline images. Also, the baseline images force matplotlib contributors to pin to a somewhat old version of FreeType because nearly every release of FreeType causes tiny rasterization changes that would entail regenerating all baseline images. Thus, it causes even more repository size growth. 
The idea is not to store the baseline images at all in the Github repo. It involves dividing the matplotlib package into two separate packages - mpl-test and mpl-notest. Mpl-test will have test suite and related information. The functionality of mpl plotting library will be present in mpl-notest. We will then create the logic for generating and grabbing the latest release. Some caching will be done too. We will then implement an analogous strategy to the CI.  


**Mentor** [Antony Lee](https://github.com/anntzer)

Thanks a lot for reading….having a great time coding with great people at Matplotlib. I will be right back with my work progress in subsequent posts.