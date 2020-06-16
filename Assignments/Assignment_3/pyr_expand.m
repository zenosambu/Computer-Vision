function [ imgout ] = pyr_expand( img )
kernel_width = 5; 
kernel1d = [.25-.375/2 .25 .375 .25 .25-.375/2];
kernel = kron(kernel1d,kernel1d')*4;
kernel00 = kernel(1:2:kernel_width,1:2:kernel_width); 
kernel01 = kernel(1:2:kernel_width,2:2:kernel_width); 
kernel10 = kernel(2:2:kernel_width,1:2:kernel_width); 
kernel11 = kernel(2:2:kernel_width,2:2:kernel_width); 
img = im2double(img);
dimensione = size(img(:,:,1));
dim = dimensione*2-1;
imgout = zeros(dim(1),dim(2),size(img,3));
for p = 1:size(img,3)
	img1 = img(:,:,p);
	img1ph = padarray(img1,[0 1],'replicate','both');
	img1pv = padarray(img1,[1 0],'replicate','both'); 
	img00 = imfilter(img1,kernel00,'replicate','same');
	img01 = conv2(img1pv,kernel01,'valid');
	img10 = conv2(img1ph,kernel10,'valid');
	img11 = conv2(img1,kernel11,'valid');
	imgout(1:2:dim(1),1:2:dim(2),p) = img00;
	imgout(2:2:dim(1),1:2:dim(2),p) = img10;
	imgout(1:2:dim(1),2:2:dim(2),p) = img01;
	imgout(2:2:dim(1),2:2:dim(2),p) = img11;
end
end