---
title: "GSoC 2020 Work Product - Baseline Images Problem"
date: 2020-08-16T09:47:51+05:30
draft: false
categories: ["News", "GSoC"]
description: "Final Work Product Report for the Google Summer of Code 2020 for the Baseline Images Problem"
displayInList: true
author: Sidharth Bansal
---

Google Summer of Code 2020 is completed. Hurray!! This post discusses about the progress so far in the three months of the coding period from 1 June to 24 August 2020 regarding the project `Baseline Images Problem` under `matplotlib` organisation under the umbrella of `NumFOCUS` organization.

## Project Details: 

This project helps with the difficulty in adding/modifying tests which require a baseline image. Baseline images are problematic because
- Baseline images cause the repo size to grow rather quickly.
- Baseline images force matplotlib contributors to pin to a somewhat old version of FreeType because nearly every release of FreeType causes tiny rasterization changes that would entail regenerating all baseline images (and thus cause even more repo size growth).

So, the idea is to not store the baseline images in the repository, instead to create them from the existing tests.

## Creation of the matplotlib_baseline_images package

We had created the `matplotlib_baseline_images` package. This package is involved in the sub-wheels directory so that more packages can be added in the same directory, if needed in future. The `matplotlib_baseline_images` package contain baseline images for both `matplotlib` and `mpl_toolkits`. 
The package can be installed by using `python3 -mpip install matplotlib_baseline_images`.

## Creation of the matplotlib baseline image generation flag

We successfully created the `generate_missing` command line flag for baseline image generation for `matplotlib` and `mpl_toolkits` in the previous months. It was generating the `matplotlib` and the `mpl_toolkits` baseline images initially. Now, we have also modified the existing flow to generate any missing baseline images, which would be fetched from the `master` branch on doing `git pull` or `git checkout -b feature_branch`. 

Now, the image generation on the time of fresh install of matplotlib and the generation of missing baseline images works with the `python3 -pytest lib/matplotlib matplotlib_baseline_image_generation` for the `lib/matplotlib` folder and `python3 -pytest lib/mpl_toolkits matplotlib_baseline_image_generation` for the `lib/mpl_toolkits` folder.

## Documentation

We have written documentation explaining the following scenarios:
1. How to generate the baseline images on a fresh install of matplotlib?
2. How to generate the missing baseline images on fetching changes from master?
3. How to install the `matplotlib_baseline_images_package` to be used for testing by the developer? 
4. How to intentionally change an image?

## Links to the work done

- [Proposal](https://storage.googleapis.com/summerofcode-prod.appspot.com/gsoc/core_project/doc/6456687923298304_1585668871_MatPlotLib_GSoc_Proposal__Baseline_Images_Problem.pdf?Expires=1597725704&GoogleAccessId=summerofcode-prod%40appspot.gserviceaccount.com&Signature=xyvO7MmMbNmW3BFz8J3JXUovI3xfZLBll4UPWZqZvHbOfPAu6PAK9enC4vXBCTwgH%2BXQ%2FxU57P3K1G0MAXvtAI7Wq0zhEfpZNXOPUQnipqRkkGdJYLLiFkIV93R6M83Z04Z%2BxyX3pepIPPaHTTNkXoxkXVyG2bx5jwtBnTTmCn1peOURPmsjOkdSp5w57vkTxzlGal5li%2FaV4sseGP8kzGtQ2YxljfZXura0WX5uA7bcNumdqMXUJ2eeqTxOwucUh8uOj6b%2BLn21d3py2KA%2FyxBuaBF8rwdqZM%2ByEeuNJ8aPAoR5kUS%2FUq7kjCyOIfuwb8%2F84TafLa91oGd4wMFNKA%3D%3D)
- [Issue](https://github.com/matplotlib/matplotlib/issues/16447)
- [Pull Request](https://github.com/matplotlib/matplotlib/pull/17793)
- [Blog Posts](https://matplotlib.org/matplotblog/categories/gsoc/)

## Mentors

- Thomas A Caswell
- Hannah
- Antony Lee

I am grateful to be part of such a great community. Project is really interesting and challenging :)

Thanks Thomas, Antony and Hannah for helping me to complete this project.
  