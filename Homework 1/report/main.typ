#import "@preview/abntyp:0.1.2": *

// Configuração do documento usando o template article
#show: artigo.with(
  titulo: "First Term Assignment",
  autores: (
    (
      name: "Artur Revorêdo Pinto",
      affiliation: "Bacharelando em Inteligência Artificial, 20260001867, <artur.revoredo.116@ufrn.edu.br>",
    ),
    (
      name: "Davi Diogenes Ferreira de Almeida",
      affiliation: "Bacharelando em Inteligência Artificial, 20260001900, <davi.almeida.135@ufrn.edu.br>",
    ),
    (
      name: "Gabriel Carvalho Pereira Silva",
      affiliation: "Bacharelando em Tecnologia da Informação, 20230035087, <gabriel.carvalho.997@ufrn.edu.br>",
    ),
  ),
)


#align(center)[
  #text(size: 16pt, weight: "bold")[Question 1: Sampling and quantization]
]
#v(1.5em)

= Question
Describe, in your own words, what are sampling and quantization. Given the function $f(x) = −0.5x^2 + 3.5x + 1$, generate the binary code that represents the digitized signal using a sampling rate of 0.5 units in the interval [0, 5] and 16 grey levels. Consider that the grey levels 0 and 15 are equal to the function values 0 and 7.5, respectively.

= Sampling

Sampling is the act of measuring a signal in regular intervals, selecting a finite number of points on a continuous function. E.g.: Imagine a continuous signal $f(t) = t^2$ with infinite points. The sampling process consists on choosing specific os periodic values of $t$ and applying the $f(t)$ function to it. We can sample values for $t=0, 1, 2, 3$, getting as final result the following points: $[(0,0),(1,1),(2,4),(3,9)]$

= Quantization

On quantization we digitize the range of a function or, in other words, we limit the possible values to a discrete level. E.g.: We can quantize a set of sampled numbers $[0.2, 0.7, 1.3, 1.8, 2.6]$ to the integer range, getting [$0, 1, 1, 2, 3$].

= Generating the binary code

== Sampling points
To start, we are going to identify all the sampling points that are going to be calculated, considering a 0.5 sampling rate on the [0, 5] interval:

$x = {0, 0.5, 1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5}$

Now, applying the given function to this values, we get:

#figure(
  table(
    columns: (auto, auto),
    stroke: none,
    table.hline(stroke: 1.5pt),
    [*$x$*], [*$f(x) = −0.5x^2 + 3.5x + 1$*],
    table.hline(stroke: 0.75pt),
    [$0.0$], [$	−0.5(0) + 0 + 1 = 1.0$],
    [$0.5$], [$−0.5(0.25) + 3.5(0.5) + 1 = 2.625$],
    [$1$], [$−0.5(1.0) + 3.5(1.0) + 1 = 4.0$],
    [$1.5$], [$−0.5(2.25) + 3.5(1.5) + 1 = 5.125$],
    [$2$], [$−0.5(4.0) + 3.5(2.0) + 1 = 6.0$],
    [$2.5$], [$−0.5(6.25) + 3.5(2.5) + 1 = 6.625$],
    [$3$], [$−0.5(9.0) + 3.5(3.0) + 1 = 7.0$],
    [$3.5$], [$−0.5(12.25) + 3.5(3.5) + 1 = 7.125$],
    [$4$], [$−0.5(16.0) + 3.5(4.0) + 1 = 7.0$],
    [$4.5$], [$−0.5(20.25) + 3.5(4.5) + 1 = 6.625$],
    [$4$], [$−0.5(25.0) + 3.5(5.0) + 1 = 6.0$],
    table.hline(stroke: 1.5pt),
  ),
  caption: [Results of applying the function to the sampling points],
  kind: table,
)

== Converting to grayscale

Now that we sampled the following decimal values:
$ {1.0, 2.625, 4.0, 5.125, 6.0, 6.625, 7.0, 7.125, 7.0, 6.625, 6.0} $

We are going to map the values to grayscale integers with the following linear function:

$ g = "round"(frac(f(x),7.5) * 15) $

Applying this function to the sampled values:

#figure(
  table(
    columns: (auto, auto),
    stroke: none,
    table.hline(stroke: 1.5pt),
    [*$x$*], [*$g = "round"(frac(f(x),7.5) * 15)$*],
    table.hline(stroke: 0.75pt),
    [$1.0$], [$2$],
    [$2.625$], [$5$],
    [$4.0$], [$8$],
    [$5.125$], [$10$],
    [$6.0$], [$12$],
    [$6.625$], [$13$],
    [$7.0$], [$14$],
    [$7.125$], [$14$],
    [$7.0$], [$14$],
    [$6.625$], [$13$],
    [$6.0$], [$12$],
    table.hline(stroke: 1.5pt),
  ),
  caption: [Results of applying the function to the sampled values],
  kind: table,
)

== Converting to binary
Now we transform the obtained values into binary numbers in 4-bit format

#figure(
  table(
    columns: (auto, auto),
    stroke: none,
    table.hline(stroke: 1.5pt),
    [*$x$*], [*Binary*],
    table.hline(stroke: 0.75pt),
    [$2$], [$0010$],
    [$5$], [$0101$],
    [$8$], [$1000$],
    [$10$], [$1010$],
    [$12$], [$1100$],
    [$13$], [$1101$],
    [$14$], [$1110$],
    [$14$], [$1110$],
    [$14$], [$1110$],
    [$13$], [$1101$],
    [$12$], [$1100$],
    table.hline(stroke: 1.5pt),
  ),
  caption: [Results of transforming the quantized values into binary],
  kind: table,
)

So the binary code that represents the digitized signal is:

0010 0101 1000 1010 1100 1101 1110 1110 1110 1101 1100

#align(center)[
  #text(size: 16pt, weight: "bold")[Question 2: Spatial Convolution Implementation]
]

#v(1.5em)
#counter(heading).update(0)

= Introduction

This report describes the implementation of digital image processing algorithms in the spatial domain, developed entirely from scratch in C, without relying on external computer vision libraries. The image format chosen for testing was PGM (_Portable Gray Map_).

= Implementation Methodology

Reading and writing PGM images were handled by directly parsing the files at both byte and text levels (depending on the file's _magic number_). To optimize CPU cache memory access, image pixels were allocated sequentially in a single one-dimensional array. A mathematical flattening formula (`index = y * width + x`) was utilized to simulate 2D matrix coordinate access.

== Convolution Algorithm

The spatial convolution was implemented by encapsulating the new pixel calculation within a modular function. To prevent segmentation faults and memory boundary violations — which occur when the neighborhood window extends beyond the image limits — we strictly followed the geometric restriction outlined in the project specification.

Let $d$ be the size of the square _kernel_ (which must have odd dimensions). The algorithm explicitly ignores the first and last $k = floor(d/2)$ rows and columns. Two nested `for` loops define this valid "safe zone" for processing. The ignored boundary pixels are left completely unprocessed, retaining their initial zero (black) values provided by the `calloc()` memory allocation.

= Results: Low-Pass and High-Pass Filters

The algorithms were tested on the sample image provided in the virtual classroom. Two distinct convolution filters were applied using $3 times 3$ kernels:

1.  *Low-Pass Filter (Mean Filter):* This _kernel_ assigns a weight of $1$ to all positions, requiring a normalization factor of $9$. The theoretical expectation is a smoothed (blurred) image, which effectively reduces high-frequency noise at the cost of edge sharpness.
2.  *High-Pass Filter (Laplacian):* This _kernel_ is designed to highlight abrupt intensity transitions. The expected result is a predominantly dark image where only the edges and contours of the original objects are illuminated. In this specific implementation, negative convolution results were clamped to zero (black).

The visual comparison of the obtained results is presented below.

#v(1em)

// Grid block to display images side-by-side
#grid(
  columns: (1fr, 1fr, 1fr),
  gutter: 10pt,
  align(center)[
    #image("img/original_bear.png", width: 100%)
    Original Image
  ],
  align(center)[
    #image("img/resultado_low_pass_bear.png", width: 100%)
    Low-Pass Filter (Mean)
  ],
  align(center)[
    #image("resultado_high_pass_bear.png", width: 100%)
    High-Pass Filter (Laplacian)
  ]
)

#grid(
  columns: (1fr, 1fr, 1fr),
  gutter: 10pt,
  align(center)[
    #image("img/original_hill.png", width: 100%)
    Original Image
  ],
  align(center)[
    #image("img/resultado_low_pass_hill.png", width: 100%)
    Low-Pass Filter (Mean)
  ],
  align(center)[
    #image("img/resultado_high_pass_hill.png", width: 100%)
    High-Pass Filter (Laplacian)
  ]
)

= Conclusion

The implementation successfully applied convolution masks in the spatial domain. Isolating the mathematical logic into a dedicated header file (`convolutions.h`) allowed the main application to dynamically switch filters by merely swapping the _kernel_ matrix and its normalization factor, demonstrating a clean and robust software architecture.

#align(center)[
  #text(size: 16pt, weight: "bold")[Question 3: Histogram Equalization]
]

#v(1.5em)
#counter(heading).update(0)

= Introduction

This report describes the implementation of histogram equalization on images from scratch with C++. The algorithm was applied on low contrast PNG images. The OpenCV library was used to load the images on a format easier to manipulate.

= Equalization Algorithm

The histogram equalization algorithm can be divided into 4 steps:

+ Counting pixel intensities: The first step is to build a histogram of pixel intensities on the original image. This was implemented as an integer array of size K, with K being the amount of possible intensity values and $"hist"[k]="number of pixels with intensity k."$

+ Build the CDF: After counting the intensities, we build a Cumulative Distribution Function, where for every $k$ in the possible intensities range, $"cdf"[k] = "cdf"[k-1] + "hist"[k]$.

+ Normalize the CDF: With the CDF in hands, we normalize all its values to the $[0, K-1]$ range - relative to the number of pixels in the original image - so they now represent intensity levels. For every k intensity in the CDF, $"cdf"[k] = ("cdf"[k] * (K - 1)) / "pixel_count"$;

+ Create equalized image: The last step consists on creating a new image based on the original image and the normalized CDF built on the 3rd step. The formula is as simple as $"new_img"[i][j] = "cdf"["img"[i][j]]$.

= Implementation

The described steps were implemented as follows:
```cpp
Mat histogram_equalization(const Mat& img, int K) {
    int histogram[256] = {0};

    // Count pixel intensity frequencies
    for (int i = 0; i < img.rows; i++) {
        for (int j = 0; j < img.cols; j++) {
            histogram[img.at<unsigned char>(i, j)]++;
        }
    }

    // Compute the cumulative distribution function (CDF)
    int cdf[256] = {0};
    cdf[0] = histogram[0];
    for (int i = 1; i < 256; i++) {
        cdf[i] = cdf[i - 1] + histogram[i];
    }

    // Normalize the CDF to the range [0, K-1]
    const int img_size = img.rows * img.cols;
    for (int i = 0; i < 256; i++) {
        cdf[i] = (cdf[i] * (K - 1)) / img_size;
    }

    //Assign new pixel values based on the normalized CDF
    //Create a new image with grayscale 8bit unsigned char type
    Mat equalized_img(img.rows, img.cols, CV_8UC1);
    for (int i = 0; i < img.rows; i++) {
        for (int j = 0; j < img.cols; j++) {
            equalized_img.at<unsigned char>(i, j) = static_cast<unsigned char>(cdf[img.at<unsigned char>(i, j)]);
        }
    }
    return equalized_img;
}
```

= Results

After applying the developed function to 3 images, these were the results. The method is very effective on enhancing low contrast images.

#grid(
  columns: (1fr, 1fr, 1fr),
  gutter: 10pt,
  align(center)[
    #image("img/original_hill.png", width: 100%)
    Original Image 1
  ],
  align(center)[
    #image("img/woman.png", width: 100%)
    Original Image 2
  ],
  align(center)[
    #image("img/jacksonvile.png", width: 100%)
    Original Image 3
  ]
)

#grid(
  columns: (1fr, 1fr, 1fr),
  gutter: 10pt,
  align(center)[
    #image("img/equalized_hill.png", width: 100%)
    Equalized Image 1
  ],
  align(center)[
    #image("img/equalized_woman.png", width: 100%)
    Equalized Image 2
  ],
  align(center)[
    #image("img/equalized_jacksonvile.png", width: 100%)
    Equalized Image 3
  ]
)

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

Unlike spatial convolution, which applies a linear mathematical combination of neighborhood pixels using a weighted mask, the median filter is an order-statistic (non-linear) filter. For a given pixel, a $5 times 5$ sliding window extracts the intensities of the 25 neighboring pixels into a temporary array.

To determine the median, this temporary array is sorted in ascending order utilizing the C standard library's `qsort` algorithm. The median value—located exactly at the center of the sorted array (index 13 for a 25-element array)—is then assigned to the corresponding central pixel in the output image. As with the convolution operations, the algorithm strictly respects the image boundaries, ignoring a safe margin of $k = floor(d/2)$ pixels to prevent segmentation faults.

= Results: Noise Reduction

The algorithm was tested on images artificially corrupted with salt-and-pepper noise. In this specific type of degradation, affected pixels take on extreme outlier values (either $0$ for pepper or $255$ for salt). 

Because the median filter relies on spatial sorting, these extreme outliers are naturally pushed to the extremities of the sorted array. This mechanism guarantees that a healthy, representative median intensity replaces the corrupted pixel. The results demonstrate that the filter successfully eliminates the impulse noise while preserving the sharpness of the edges significantly better than a standard low-pass (mean) filter would.

#v(1em)

#grid(
  columns: (1fr, 1fr),
  gutter: 20pt,
  align(center)[
    #image("img/original_bear.png", width: 100%)
    Original Image (Salt & Pepper Noise)
  ],
  align(center)[
    #image("img/resultado_mediana_bear.png", width: 100%)
    Median Filter Result ($5 times 5$)
  ]
)
#grid(
  columns: (1fr, 1fr),
  gutter: 20pt,
  align(center)[
    #image("img/original_boat.png", width: 100%)
    Original Image (Salt & Pepper Noise)
  ],
  align(center)[
    #image("img/resultado_mediana_boat.png", width: 100%)
    Median Filter Result ($5 times 5$)
  ]
)

= Conclusion

The from-scratch implementation of the median filter proved highly robust for its intended use case. By replacing linear matrix multiplications with array sorting techniques, the algorithm successfully isolated and removed extreme outlier noise. This exercise highlighted the importance of non-linear filters in preserving structural integrity and edge details during noise reduction tasks.

#align(center)[
  #text(size: 16pt, weight: "bold")[Question 5:  High-Frequency Emphasis Filter]
]

#v(1.5em)
#counter(heading).update(0)

= Question
Using a Fourier transform library, implement the high-frequency emphasis
filter defined by: $g(x, y) = F^(−1) {[k_(1) + k_(2)H_("HP")(u, v)]F(u, v)}$
where $k_1 ≥ 0$ offsets the value the transfer function so as not to zero-out
the dc term, and $k_2 > 0$ controls the contribution of high frequencies.
Process the image “full body PET - original.jpg”, varying the values of $k_1$
and $k_2$ and select the best values, in your opinion.

= The operation

This operation emphasizes the high frequencies of the image, and is implemented in 8 steps:
+ Converting the image to Float and creating the complex spectrum
  ```cpp
  	gray.convertTo(float_img, CV_32F);
  	Mat planes[] = {float_img, Mat::zeros(float_img.size(), CV_32F)};
  	Mat spectrum;
  	cv::merge(planes, 2, spectrum);
  ```
+ Applying 2D DFT

  ```cpp
  cv::dft(spectrum, spectrum);
  ```

+ Shift quadrants to centralize low frequencies

+ Generate High-pass gaussian filter
  ```cpp
  Mat make_gaussian_high_pass(int rows, int cols, double d0) {
  	Mat h(rows, cols, CV_32F);
  
  	const float crow = static_cast<float>(rows) / 2.0f;
  	const float ccol = static_cast<float>(cols) / 2.0f;
  
  	for (int i = 0; i < rows; ++i) {
  		for (int j = 0; j < cols; ++j) {
  			const float du = static_cast<float>(i) - crow;
  			const float dv = static_cast<float>(j) - ccol;
  			const float d2 = du * du + dv * dv;
  
  			// Gaussian high-pass transfer function.
  			h.at<float>(i, j) = 1.0f - std::exp(-d2 / (2.0f * static_cast<float>(d0 * d0)));
  		}
  	}
  	return h;
  }
  ```

+ Build emphasis filter
  ```c
  Mat emphasis = k1 + k2 * hhp;
  ```

+ Multiply both planes by the filter
  ```cpp
  	cv::split(spectrum, planes);
  	planes[0] = planes[0].mul(emphasis);
  	planes[1] = planes[1].mul(emphasis);
  	cv::merge(planes, 2, spectrum);
  ```

+ Undo the shift and apply reverse DFT to get spatial image back
  ```c
  	shift_dft_quadrants(spectrum);
  	Mat inverse;
  	cv::idft(spectrum, inverse, cv::DFT_REAL_OUTPUT | cv::DFT_SCALE);
  ```

+ Normalize and convert to 8-Bits
  ```c
  Mat output;
  cv::normalize(inverse, output, 0.0, 255.0, cv::NORM_MINMAX);
  output.convertTo(output, CV_8U);
  ```

= Results

Below are some of the most interesting results achieved through the operation:

#grid(
  columns: (1fr, 1fr, 1fr),
  gutter: 10pt,
  align(center)[
    #image("img/full_body.png", width: 100%)
    Original Image
  ],
  align(center)[
    #image("img/full_1_10.png", width: 100%)
    $k_1=1;k_2=10$
  ],
  align(center)[
    #image("img/full_10_1.png", width: 100%)
    $k_1=10;k_2=1$
  ]
)
#grid(
  columns: (1fr, 1fr, 1fr),
  gutter: 10pt,
  align(center)[
    #image("img/full_5_10.png", width: 100%)
    $k_1=5;k_2=10$
  ],
  align(center)[
    #image("img/full_1_1.png", width: 100%)
    $k_1=1;k_2=1$
  ],
  align(center)[
    #image("img/full_10_5.png", width: 100%)
    $k_1=10;k_2=5$
  ]
)

#v(1.5em)
#counter(heading).update(0)

#align(center)[
  #text(size: 16pt, weight: "bold")[Question 6: DTF properties]
]

= Question
Given the DFT translation property

$ f(x, y) e^(j 2 pi (u_0 x / M + v_0 y / N)) 
  <=> F(u - u_0, v - v_0) $

and

$ f(x - x_0, y - y_0) 
  <=> F(u, v) e^(-j 2 pi (u x_0 / M + v y_0 / N)) $

show that

$ f(x, y) (-1)^(x + y) 
  <=> F(u - M/2, v - N/2) $

= Proof

  $ f(x, y)(-1)^(x + y)
  &= f(x, y) e^(j pi (x + y)) && "   Euler's identity" \
  &= f(x, y) e^(2 j pi ((x + y)/2)) && "   Multiply and divide by 2"\
  &= f(x, y) e^(2 j pi (x/2 + y/2)) && "   Split into fractions"\
  &= f(x, y) e^(2 j pi (1 * x/2 + 1 * y/2)) && "   Multiply by multiplication identity"\
  &= f(x, y) e^(2 j pi ((M/M) * x/2 + (N/N) * y/2)) && "   Rewrite in terms of M and N"(N,M!=0)\
  &= f(x, y) e^(2 j pi ((M/2) * x/M + (N/2) * y/N)) && "   Switch denominators"\
  &<=> F(u - M/2, v - N/2) && "   First property"$

#v(1.5em)
#counter(heading).update(0)

#align(center)[
  #text(size: 16pt, weight: "bold")[Question 7: Image Recovering]
]

= Question
A professor of archeology doing research on currency exchange practices during the Roman Empire recently became aware that four Roman coins crucial to his research are listed in the holdings of the British Museum in London. Unfortunately, he was told after arriving there that the coins had been recently stolen. Further research on his part revealed that the museum keeps photographs of every item for which it is responsible. Unfortunately, the photos of the coins in question are blurred to the point where the date and other small markings are not readable. The cause of the blurring was the camera being out of focus when the pictures were taken. As an image processing expert and friend of the professor, you are asked as a favor to determine whether computer processing can be utilized to restore the images to the point where the professor can read the markings. You are told that the original camera used to take the photos is still available, as are other representative coins of the same era. Propose a step-by-step solution to this problem.
