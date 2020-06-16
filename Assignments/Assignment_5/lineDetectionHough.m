%% Demonstration of Matlab built-in functionality for line detection by Hough transform
% https://se.mathworks.com/help/images/hough-transform.html

% Read an image, rotate and show.
I = imread('circuit.tif');
rotI = imrotate(I,33,'crop');
figure;imshow(rotI)

% Find Canny edges.
BW = edge(rotI,'canny');
figure;imshow(BW);

% Compute the Hough transform of the binary image returned by 'edge'.
[H,theta,rho] = hough(BW);

% Display the transform, H, returned by the hough function.
figure
imshow(imadjust(mat2gray(H)),[],...
       'XData',theta,...
       'YData',rho,...
       'InitialMagnification','fit');
xlabel('\theta (degrees)')
ylabel('\rho')
axis on
axis normal
hold on
colormap(hot)

% Detect 30 strongest peaks in the Hough transform space.
P = houghpeaks(H,30,'threshold',0,'NHoodSize',[9 3]);%,'threshold',ceil(0.1*max(H(:))));

% Superimpose a plot on the image of the transform that identifies the peaks.
t = theta(P(:,2));
r = rho(P(:,1));
plot(t,r,'s','color','black');

% Visualize detected lines on top of the Canny edges.
figure; 
imshow((BW)); hold on
x=1:size(BW,2);
for k=1:size(P,1)
    yk=(-x*cos(theta(P(k,2))/180*pi)+rho(P(k,1)))./sin(theta(P(k,2))/180*pi);
    plot(x,yk,'m-');
end