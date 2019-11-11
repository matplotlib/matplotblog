---
title: "Creating the Warming Stripes in Matplotlib"
date: 2019-11-11T09:21:28+01:00
draft: false
description: "Ed Hawkins made this impressively simple plot to show how global temperatures have risen since 1880. Here is how to recreate it using matplotlib."
categories: ["tutorials", "academia"]
displayInList: true
author: Maximilian Nöthe

resources:
- name: featuredImage
  src: "thumbnail.png"
  params:
    showOnTop: false
---


![Warming Stripes](warming-stripes.png)

Earth's temperatures are rising and nothing shows this in a simpler,
more approachable graphic than the “Warming Stripes”.
Introduced by Prof. Ed Hawkins they show the temperatures either for
the global average or for your region as colored bars from blue to red for the last 170 years, available at [#ShowYourStripes](https://showyourstripes.info).

The stripes have since become the logo of the [Scientists for Future](https://scientistsforfuture.org).
Here is how you can recreate this yourself using matplotlib.

We are going to use the [HadCRUT4](https://www.metoffice.gov.uk/hadobs/hadcrut4/index.html) dataset, published by the Met Office.
It uses combined sea and land surface temperatures.
The dataset used for the warming stripes is the annual global average.

First, let's import everything we are going to use.
The plot will consist of a bar for each year, colored using a custom
color map. 

```python
import matplotlib.pyplot as plt
from matplotlib.patches import Rectangle
from matplotlib.collections import PatchCollection
from matplotlib.colors import ListedColormap
import pandas as pd
```

Then we define our time limits, our reference period for
the neutral color and the range around it for maximum saturation.

```python
FIRST = 1850
LAST = 2018  # inclusive

# Reference period for the center of the color scale
FIRST_REFERENCE = 1971
LAST_REFERENCE = 2000
LIM = 0.7 # degrees
```


Here we use pandas to read the fixed width text file, only the 
first two columns, which are the year and the deviation from the
mean from 1961 to 1990.
```python
# data from
# https://www.metoffice.gov.uk/hadobs/hadcrut4/data/current/time_series/HadCRUT.4.6.0.0.annual_ns_avg.txt
df = pd.read_fwf(
    'HadCRUT.4.6.0.0.annual_ns_avg.txt',
    index_col=0,
    usecols=(0, 1),
    names=['year', 'anomaly'],
    header=None,
)

anomaly = df.loc[FIRST:LAST, 'anomaly'].dropna()
reference = anomaly.loc[FIRST_REFERENCE:LAST_REFERENCE].mean()
```


This is our custom colormap, we could also use one of
the [colormaps](https://matplotlib.org/3.1.0/tutorials/colors/colormaps.html) that come with `matplotlib`, e.g. `coolwarm` or `RdBu`.
```python
# the colors in this colormap come from http://colorbrewer2.org
# the 8 more saturated colors from the 9 blues / 9 reds
cmap = ListedColormap([
    '#08306b', '#08519c', '#2171b5', '#4292c6',
    '#6baed6', '#9ecae1', '#c6dbef', '#deebf7',
    '#fee0d2', '#fcbba1', '#fc9272', '#fb6a4a',
    '#ef3b2c', '#cb181d', '#a50f15', '#67000d',
])
```

We create a figure with a single axes object that fills the full area
of the figure and does not have any axis ticks or labels.
```python
fig = plt.figure(figsize=(10, 1))

ax = fig.add_axes([0, 0, 1, 1])
ax.set_axis_off()
```

Finally, we create bars for each year, assign the
data, colormap and color limits and add it to the axes.
```python
# create a collection with a rectangle for each year
col = PatchCollection([
    Rectangle((y, 0), 1, 1)
    for y in range(FIRST, LAST + 1)
])

# set data, colormap and color limits
col.set_array(anomaly)
col.set_cmap(cmap)
col.set_clim(reference - LIM, reference + LIM)
ax.add_collection(col)
```


Make sure the axes limits are correct and save the figure.
```python
ax.set_ylim(0, 1)
ax.set_xlim(FIRST, LAST + 1)

fig.savefig('warming-stripes.png')
```

![Warming Stripes](warming-stripes.png)
