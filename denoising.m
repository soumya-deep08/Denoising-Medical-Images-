% Define the URL of the image.
image_url = 'https://imgs.search.brave.com/iSKBDdnwz-zji-aN_eA7DETQrNGJXWgSH9ZZL-IvAFk/rs:fit:500:0:0:0/g:ce/aHR0cHM6Ly9tZWRp/YS5pc3RvY2twaG90/by5jb20vaWQvMTE3/MzE1OTc0MC9waG90/by9jdC1zY2FuLW9m/LXRob3JheC1hbmQt/YWJkb21lbi5qcGc_/cz02MTJ4NjEyJnc9/MCZrPTIwJmM9MmNW/d1RQdmNSam9QZERE/WnBXb1NOaFZPSkts/RlFMVlVjQm1mbnR6/Y2QzMD0';
	
% Define a local path to save the downloaded image.
local_image_path = 'C:\Users\91880\OneDrive\Documents\SEM-5\DSP.jpeg';

% Download the image from the URL and save it locally.
websave(local_image_path, image_url);

% Read the image from the local file.
original_image = imread(local_image_path);

% Convert to grayscale if the image is in color.
if size(original_image, 3) == 3
    original_image = rgb2gray(original_image);
end

% Add Gaussian noise to the original image.
noisy_image = imnoise(original_image, 'gaussian', 0.1);

% Define FIR filter (e.g., Gaussian filter).
sigma = 1;
 % Standard deviation for Gaussian filter.
filter_size = 2 * ceil(3 * sigma) + 1; 
% Choose an appropriate size.
filter_fir = fspecial('gaussian', filter_size, sigma);

% Apply FIR filter.
denoised_image_fir = imfilter(noisy_image, filter_fir);

% Define IIR filter (Butterworth filter).
n = 2; 
% Order of the Butterworth filter.
D0 = 0.1 * min(size(original_image)); 
% Normalized cutoff frequency.

% Create Butterworth filter.
[U, V] = dftuv(size(original_image, 1), size(original_image, 2));
D = sqrt(U.^2 + V.^2);
butterworth_filter = 1 ./ (1 + (D ./ D0).^(2 * n));

% Apply IIR filter in the frequency domain.
noisy_image_fft = fft2(double(noisy_image));
denoised_image_iir_fft = noisy_image_fft .* butterworth_filter;
denoised_image_iir = real(ifft2(denoised_image_iir_fft));
denoised_image_iir = uint8(denoised_image_iir);

% Display the images.
figure;

subplot(3, 1, 1), imshow(original_image), title('Original Image');
subplot(3, 1, 2), imshow(noisy_image), title('Noisy Image');
subplot(3, 1, 3), imshow(denoised_image_fir), title('Denoised using FIR');

figure;

subplot(3, 1, 1), imshow(original_image), title('Original Image');
subplot(3, 1, 2), imshow(noisy_image), title('Noisy Image');
subplot(3, 1, 3), imshow(denoised_image_iir), title('Denoised using IIR');

function [U, V] = dftuv(M, N)

    % Computes meshgrid frequency matrices.
    u = 0:(M - 1);
    v = 0:(N - 1);
    idx = find(u > M / 2);
    u(idx) = u(idx) - M;
    idy = find(v > N / 2);
    v(idy) = v(idy) - N;
    [V, U] = meshgrid(v, u);

end


