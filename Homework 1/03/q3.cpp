#include <opencv2/opencv.hpp>

#include <algorithm>
#include <cstdlib>
#include <iostream>

using cv::Mat;

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

int main(int argc, char* argv[]) {
    if (argc < 2) {
        std::cout << "Usage: " << argv[0] << " <input.png>" << std::endl;
        return 1;
    }

    Mat img = cv::imread(cv::samples::findFile(argv[1]), cv::IMREAD_GRAYSCALE);
    if (img.empty()) {
        std::cout << "Error: cannot load image " << argv[1] << std::endl;
        return 1;
    }
    
    std::cout << "Image loaded: " << img.cols << "x" << img.rows << std::endl;
    
    const int K = 256;
    Mat equalized = histogram_equalization(img, K);

    if (!cv::imwrite("q3.png", equalized)) {
        std::cout << "Error: cannot save output q3.png" << std::endl;
        return 1;
    }
    std::cout << "\nOutput saved to: q3.png" << std::endl;

    cv::imshow("Before", img);
    cv::imshow("After", equalized);
    cv::waitKey(0);

    return 0;
}