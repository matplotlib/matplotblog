---
title: "GSoC Coding Phase 1 Blog 2"
date: 2020-06-24T16:47:51+05:30
draft: false
categories: ["News", "GSoC"]
description: "Progress Report for the second half of the Google Summer of Code 2020 Phase 1 for the Baseline Images Problem"
displayInList: true
author: Sidharth Bansal
---

Google Summer of Code 2020's first evaluation is about to complete. This post discusses about the progress so far in the last two weeks of the first coding period from 15 June to 30 June 2020.

## Completion of the demo package

We successfully created the demo app and uploaded it to the test.pypi. It contains the main and the secondary package. The main package is analogous to the matplotlib and secondary package is analogous to the matplotlib_baseline_images package as discussed in the previous blog.

## Learning more about the Git and mpl workflow 

I came across another way to merge the master into the branch to resolve conflicts is by rebasing the master. I understood how to create modular commits inside a pull request for easy reviewal process and better understandability of the code.  

## Creation of the matplotlib_baseline_images package

Then, we implemented the similar changes to create the `matplotlib_baseline_images` package. Finally, we were successful in uploading it to the [test.pypi](https://test.pypi.org/project/matplotlib.baseline-images/3.3.0rc1/#history). This package is involved in the `sub-wheels` directory so that more packages can be added in the same directory, if needed in future.  The `matplotlib_baseline_images` package contain baseline images for both `matplotlib` and `mpl_toolkits`.
Some changes were required in the main `matplotlib` package's setup.py so that it will not take information from the packages present in the `sub-wheels` directory. 

## Symlinking the baseline images

As baseline images are moved out of the `lib/matplotlib` and `lib/mpl_toolkits` directory. We symlinked the locations where they are used, namely in `lib/matplotlib/testing/decorator.py`, `tools/triage_tests.py`, `lib/matplotlib/tests/__init__.py` and `lib/mpl_toolkits/tests/__init__.py`.

## Creation of the tests/test_data directory

There are some test data that is present in the `baseline_images` which doesn't need to be moved to the `matplotlib_baseline_images` package. So, that is stored under the `lib/matplotlib/tests/test_data` folder.

## Understanding Travis, Appvoyer and Azure-pipelines

I came across the Continuous Integration tools used at mpl. We tried to install the `matplotlib` followed by `matplotlib_baseline_images` package in all three travis, appvoyer and azure-pipeline.

## Future Goals

Once the [current PR](https://github.com/matplotlib/matplotlib/pull/17557) is merged, we will move to the [Proposal for the baseline images problem](https://github.com/matplotlib/matplotlib/issues/16447).

## Daily Meet-ups

Everyday meeting initiated at [11:00pm IST](https://everytimezone.com/) via Zoom. Meeting notes are present at HackMD.

I am grateful to be part of such a great community. Project is really interesting and challenging :) Thanks Antony and Hannah for helping me so far.  
  