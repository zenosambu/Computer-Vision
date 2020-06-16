function [ imgout ] = pyr_reduce( img )
kerld = [1 4 6 4 1]/16;
kernel = kron(kerld,kerld');
img = im2double(img);
sz = size(img);
imgout = [];
for p = 1:size(img,3)
	img1 = img(:,:,p);
	imgFilt = imfilter(img1,kernel,'replicate','same');
	imgout(:,:,p) = imgFilt(1:2:sz(1),1:2:sz(2));
end
end