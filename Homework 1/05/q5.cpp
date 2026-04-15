#include <opencv2/opencv.hpp>

#include <cmath>
#include <cstdlib>
#include <iostream>

using cv::Mat;

namespace {

void shift_dft_quadrants(Mat& mag) {
	// Move low frequencies to the center for radial filter construction.
	mag = mag(cv::Rect(0, 0, mag.cols & -2, mag.rows & -2));

	const int cx = mag.cols / 2;
	const int cy = mag.rows / 2;

	Mat q0(mag, cv::Rect(0, 0, cx, cy));
	Mat q1(mag, cv::Rect(cx, 0, cx, cy));
	Mat q2(mag, cv::Rect(0, cy, cx, cy));
	Mat q3(mag, cv::Rect(cx, cy, cx, cy));

	Mat tmp;
	q0.copyTo(tmp);
	q3.copyTo(q0);
	tmp.copyTo(q3);

	q1.copyTo(tmp);
	q2.copyTo(q1);
	tmp.copyTo(q2);
}

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

Mat high_frequency_emphasis(const Mat& gray, double k1, double k2, double d0) {
	Mat float_img;
	
	gray.convertTo(float_img, CV_32F);
	Mat planes[] = {float_img, Mat::zeros(float_img.size(), CV_32F)};
	Mat spectrum;
	cv::merge(planes, 2, spectrum);

	cv::dft(spectrum, spectrum);
	shift_dft_quadrants(spectrum);

	Mat hhp = make_gaussian_high_pass(spectrum.rows, spectrum.cols, d0);
	Mat emphasis = k1 + k2 * hhp;

	cv::split(spectrum, planes);
	planes[0] = planes[0].mul(emphasis);
	planes[1] = planes[1].mul(emphasis);
	cv::merge(planes, 2, spectrum);

	shift_dft_quadrants(spectrum);
	Mat inverse;
	cv::idft(spectrum, inverse, cv::DFT_REAL_OUTPUT | cv::DFT_SCALE);

	Mat output;
	cv::normalize(inverse, output, 0.0, 255.0, cv::NORM_MINMAX);
	output.convertTo(output, CV_8U);

	return output;
}

}  // namespace

int main(int argc, char* argv[]) {
	if (argc < 2) {
		std::cout << "Usage: " << argv[0]
				  << " <input_image> [k1] [k2] [d0] [output_image]" << std::endl;
		return 1;
	}

	const double k1 = (argc > 2) ? std::atof(argv[2]) : 0.5;
	const double k2 = (argc > 3) ? std::atof(argv[3]) : 1.5;
	const double d0 = (argc > 4) ? std::atof(argv[4]) : 30.0;
	const std::string output_path = (argc > 5) ? argv[5] : "q5.png";

	if (k1 < 0.0 || k2 <= 0.0 || d0 <= 0.0) {
		std::cout << "Error: expected k1 >= 0, k2 > 0, d0 > 0." << std::endl;
		return 1;
	}

	Mat img = cv::imread(cv::samples::findFile(argv[1]), cv::IMREAD_GRAYSCALE);
	if (img.empty()) {
		std::cout << "Error: cannot load image " << argv[1] << std::endl;
		return 1;
	}

	Mat result = high_frequency_emphasis(img, k1, k2, d0);

	if (!cv::imwrite(output_path, result)) {
		std::cout << "Error: cannot save output " << output_path << std::endl;
		return 1;
	}

	std::cout << "Image loaded: " << img.cols << "x" << img.rows << std::endl;
	std::cout << "Parameters: k1=" << k1 << ", k2=" << k2 << ", d0=" << d0 << std::endl;
	std::cout << "Output saved to: " << output_path << std::endl;

	cv::imshow("Before", img);
	cv::imshow("After (High-Frequency Emphasis)", result);
	cv::waitKey(0);

	return 0;
}
