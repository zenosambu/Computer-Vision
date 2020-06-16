%% Visualization of three point correspondences in both images
im1=imread('im1.jpg');
im2=imread('im2.jpg');

% points L, M, N in image 1
lmn1=1.0e+03*[...
    1.3715 1.0775;...
    1.8675 1.0575;...
    1.3835 1.4415];

% points L, M, N in image 2

lmn2=1.0e+03*[...
    1.1555 1.0335;...
    1.6595 1.0255;...
    1.1755 1.3975];

figure;imshow(im1);hold on;
plot(lmn1(:,1),lmn1(:,2),'c+','MarkerSize',10);
labels={'L','M','N'};
for i=1:length(labels)
    ti=text(lmn1(i,1),lmn1(i,2),labels{i});
    ti.Color='cyan';
    ti.FontSize=20;
end
figure;imshow(im2);hold on;
plot(lmn2(:,1),lmn2(:,2),'c+','MarkerSize',10);
labels={'L','M','N'};
for i=1:length(labels)
    ti=text(lmn2(i,1),lmn2(i,2),labels{i});
    ti.Color='cyan';
    ti.FontSize=20;
end

%% The task is to implement the missing function 'trianglin.m'.
% The algorithm is described on slides 31 and 32 of Lecture 8.
% Output should be the homogeneous coordinates of the triangulated point.
L=trianglin(P1,P2,[lmn1(1,:) 1],[lmn2(1,:) 1]);
M=trianglin(P1,P2,[lmn1(2,:) 1],[lmn2(2,:) 1]);
N=trianglin(P1,P2,[lmn1(3,:) 1],[lmn2(3,:) 1]);

%% we can then compute the width and height of the picture on the book cover
picture_width_mm=norm(L(1:3)/L(4)-M(1:3)/M(4))
picture_height_mm=norm(L(1:3)/L(4)-N(1:3)/N(4))