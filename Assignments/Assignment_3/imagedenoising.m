%% Uncomment the commented code lines and implement missing functions 
% (and anything else that is asked or needed)

%% Load test images.
% Note: Must be double precision in the interval [0,1].
im = double(rgb2gray(imread('department2.jpg')))/255;

%% Add noise 
% "salt and pepper" noise
imns = imnoise(im,'salt & pepper',0.1);
% zero-mean Gaussian noise
imng = im+0.05*randn(size(im));
imng(imng<0) = 0; imng(imng>1) = 1;

%% Apply Gaussian filter of size 11x11 and std 2.5 
sigmad=2.5;
h = fspecial('gaussian', [11 11],2.5);
%% Instead of directly filtering with h, make a separable implementation
% where you use horizontal and vertical 1D convolutions

gflt_imns=conv2(h(1,:),h(:,1),imns);
gflt_imng=conv2(h(1,:),h(:,1),imng);


% That is, replace the above two lines, you can use conv2 instead
% The result should not change.

%% Apply median filtering, use neighborhood size 5x5
medflt_imns = medfilt2(imns,[5 5]);  %%Replace with median filtered image
medflt_imng = medfilt2(imng,[5 5]);  %%Replace with median filtered image
% That is, replace the above two lines, you can use matlab built-in function medfilt2

%% Set bilateral filter parameters.
w     = 5;       % bilateral filter half-width, filter size = 2*w+1 = 11
sigma = [2.5 0.1]; % bilateral filter standard deviations

%% Apply bilateral filter to each image.
% bflt_imns=zeros(size(im));%%Replace with bilateral filtered image
% bflt_imng=zeros(size(im));%%Replace with bilateral filtered image
bflt_imns = bilateralfilter(imns,w,sigma);
bflt_imng = bilateralfilter(imng,w,sigma);
%% That is, you need to implement bilateralfilter.m and use it above
% Use formulas (3.34)-(3.37) from Szeliski's book 
% with values sigma_d=sigma(1), sigma_r=sigma(2)

%% Display grayscale input image and filtered output.
figure(1); clf;
set(gcf,'Name','Filtering Results');

subplot(2,4,1); imagesc(imns);
axis image; colormap gray;
title('Input Image');

subplot(2,4,2); imagesc(gflt_imns);
axis image; colormap gray;
title('Result of Gaussian Filtering');

subplot(2,4,3); imagesc(medflt_imns);
axis image; colormap gray;
title('Result of Median Filtering');

subplot(2,4,4); imagesc(bflt_imns);
axis image; colormap gray;
title('Result of Bilateral Filtering');

subplot(2,4,5); imagesc(imng);
axis image; colormap gray;
title('Input Image');

subplot(2,4,6); imagesc(gflt_imng);
axis image; colormap gray;
title('Result of Gaussian Filtering');

subplot(2,4,7); imagesc(medflt_imng);
axis image; colormap gray;
title('Result of Median Filtering');

subplot(2,4,8); imagesc(bflt_imng);
axis image; colormap gray;
title('Result of Bilateral Filtering');
