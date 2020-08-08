---
title: "GSoC Coding Phase 3 Blog 1"
date: 2020-08-08T09:47:51+05:30
draft: false
categories: ["News", "GSoC"]
description: "Progress Report for the first half of the Google Summer of Code 2020 Phase 3 for the Baseline Images Problem"
displayInList: true
author: Sidharth Bansal
---

Google Summer of Code 2020's second evaluation is completed. I passed!!! Hurray! Now we are in the mid way of the last evaluation. This post discusses about the progress so far in the first two weeks of the third coding period from 26 July to 9 August 2020.

## Completion of the modification logic for the matplotlib_baseline_images package

We successfully created the `matplotlib_baseline_image_generation` command line flag for baseline image generation for `matplotlib` and `mpl_toolkits` in the previous months. It was generating the matplotlib and the matplotlib toolkit baseline images successfully. Now, we modified the existing flow to generate any missing baseline images, which would be fetched from the `master` branch on doing `git pull` or `git checkout -b feature_branch`. 

We initially thought of creating a command line flag `generate_baseline_images_for_test "test_a,test_b"`, but later on analysis of the approach, we came to the conclusion that the developer will not know about the test names to be given along with the flag. So, we tried to generate the missing images by `generate_missing` without the test names. This worked successfully. 

## Adopting reusability and Do not Repeat Yourself (DRY) Principles

Later, we refactored the `matplot_baseline_image_generation` and `generate_missing` command line flags to single command line flag `matplotlib_baseline_image_generation` as the logic was similar for both of them. Now, the image generation on the time of fresh install of matplotlib and the generation of missing baseline images works with the `python3 -pytest lib/matplotlib matplotlib_baseline_image_generation` for the `lib/matplotlib` folder and `python3 -pytest lib/mpl_toolkits matplotlib_baseline_image_generation` for the `lib/mpl_toolkits` folder.

## Writing the documentation

We have written documentation explaining the following scenarios:
1. How to generate the baseline images on a fresh install of matplotlib?
2. How to generate the missing baseline images on fetching changes from master?
3. How to install the `matplotlib_baseline_images_package` to be used for testing by the developer? 
4. How to intentionally change an image?

## Refactoring and improving the code quality before merging

Right now, we are trying to refactor the code and maintain git clean history. The [current PR](https://github.com/matplotlib/matplotlib/pull/17793) is under review. I am working on the suggested changes. We are trying to merge this :)

## Daily Meet-ups

Monday to Thursday meeting initiated at [11:00pm IST](https://everytimezone.com/) via Zoom. Meeting notes are present at HackMD.

I am grateful to be part of such a great community. Project is really interesting and challenging :) Thanks Thomas, Antony and Hannah for helping me so far.  
  