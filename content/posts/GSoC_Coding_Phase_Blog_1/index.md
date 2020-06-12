---
title: "GSoC Coding Phase 1 Blog 1"
date: 2020-06-09T16:47:51+05:30
draft: false
categories: ["News", "GSoC"]
description: "Progress Report for the first half of the Google Summer of Code 2020 Phase 1 for the Baseline Images Problem"
displayInList: true
author: Sidharth Bansal
---

I Sidharth Bansal, was waiting for the coding period to start from the March end so that I can make my hands dirty with the code. Finally, coding period has started. Two weeks have passed. This blog contains information about the progress so far from 1 June to 14 June 2020.

## Movement from mpl-test and mpl packages to mpl and mpl-baseline-images packages

Initially, we thought of creating a [mpl-test and mpl package](https://github.com/matplotlib/matplotlib/pull/17434). Mpl-test package would contain the test suite and baseline images while the other package would contain parts of repository other than test and baseline-images related files and folders.
We changed our decision to creation of [mpl and mpl-baseline-images packages](https://github.com/matplotlib/matplotlib/pull/17557) as we don't need to create separate package for entire test suite. Our main aim was to eliminate baseline_images from the repository. Mpl-baseline-images package will contain the data[/baseline images] and related information. The other package will contain files and folders other than baseline images.
We are now trying to create the following structure for the repository: 
```
mpl/
  setup.py
  lib/mpl/...
  lib/mpl/tests/...  [contains the tests .py files]
  baseline_images/
    setup.py
    data/...  [contains the image files]
```
It will involve:
- Symlinking baseline images out.
- Creating a wheel/sdist with just the baseline images; uploading it to testpypi (so that one can do `pip install mpl-baseline-images`).

## Following prototype modelling

I am creating a prototype first with two packages - main package and sub-wheel package. Once the demo app works well on [Test PyPi](https://test.pypi.org/), we can do similar changes to the main mpl repository.
The structure of demo app is analogous to the work needed for separation of baseline-images to a new package mpl-baseline-images as given below:
```
testrepo/
  setup.py
  lib/testpkg/__init__.py
  baseline_images/setup.py
  baseline_images/testdata.txt
```
This will also include related MANIFEST files and setup.cfg.template files. The setup.py will also contain logic for exclusion of baseline-images folder from the main mpl-package.

## Following Enhancements over iterations

After the [current PR](https://github.com/matplotlib/matplotlib/pull/17557) is merged, we will focus on eliminating the baseline-images from the mpl-baseline-images package. Then we will do similar changes for the Travis CI.

## Bi weekly meet-ups scheduled

Every Tuesday and every Friday meeting is initiated at [8:30pm IST](https://everytimezone.com/) via [Zoom](https://zoom.us/j/95996536871). Meeting notes are present at [HackMD](https://hackmd.io/pY25bSkCSRymk_7nX68xtw).


I am grateful to be part of such a great community. Project is really interesting and challenging :) Thanks Antony and Hannah for helping me so far.  
  