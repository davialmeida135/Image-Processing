#align(center)[
  #text(size: 16pt, weight: "bold")[Question 4: Median Filter Implementation]
]

#v(1.5em)

#counter(heading).update(0)

= Introduction

This section details the implementation of a non-linear spatial filter—specifically, the median filter—developed entirely from scratch in C. The primary objective of this task was to evaluate the filter's effectiveness in removing impulse noise, commonly known as salt-and-pepper noise, from digital images without relying on external computer vision libraries.

= Implementation Methodology

The image parsing and memory allocation procedures remained consistent with the previous implementations, utilizing a one-dimensional array to efficiently map the 2D pixel grid and optimize CPU cache access.

== Median Filter Algorithm

Unlike spatial convolution, which applies a linear mathematical combination of neighborhood pixels using a weighted mask, the median filter is an order-statistic (non-linear) filter. For a given pixel, a $3 times 3$ sliding window extracts the intensities of the 9 neighboring pixels into a temporary array.

To determine the median, this temporary array is sorted in ascending order utilizing the C standard library's `qsort` algorithm. The median value—located exactly at the center of the sorted array (index 4 for a 9-element array)—is then assigned to the corresponding central pixel in the output image. As with the convolution operations, the algorithm strictly respects the image boundaries, ignoring a safe margin of $k = floor(d/2)$ pixels to prevent segmentation faults.

= Results: Noise Reduction

The algorithm was tested on images artificially corrupted with salt-and-pepper noise. In this specific type of degradation, affected pixels take on extreme outlier values (either $0$ for pepper or $255$ for salt). 

Because the median filter relies on spatial sorting, these extreme outliers are naturally pushed to the extremities of the sorted array. This mechanism guarantees that a healthy, representative median intensity replaces the corrupted pixel. The results demonstrate that the filter successfully eliminates the impulse noise while preserving the sharpness of the edges significantly better than a standard low-pass (mean) filter would.

#v(1em)

#grid(
  columns: (1fr, 1fr),
  gutter: 20pt,
  align(center)[
    #image("original_bear.png", width: 100%)
    Original Image (Salt & Pepper Noise)
  ],
  align(center)[
    #image("resultado_mediana_bear.png", width: 100%)
    Median Filter Result ($5 times 5$)
  ]
)
#grid(
  columns: (1fr, 1fr),
  gutter: 20pt,
  align(center)[
    #image("original_boat.png", width: 100%)
    Original Image (Salt & Pepper Noise)
  ],
  align(center)[
    #image("resultado_mediana_boat.png", width: 100%)
    Median Filter Result ($5 times 5$)
  ]
)

= Conclusion

The from-scratch implementation of the median filter proved highly robust for its intended use case. By replacing linear matrix multiplications with array sorting techniques, the algorithm successfully isolated and removed extreme outlier noise. This exercise highlighted the importance of non-linear filters in preserving structural integrity and edge details during noise reduction tasks.