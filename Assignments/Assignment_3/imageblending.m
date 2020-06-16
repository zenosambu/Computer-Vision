%% Overview and instructions
% 
% Implement missing functions: 
% generateLaplacianPyramid.m and reconstLaplacianPyramid.m
%
% Notice that in this implementation the first level of a Gaussian pyramid 
% is the original image, and the last level of a Laplacian pyramid is the
% same as the corresponding level in the Gaussian pyramid. 

%% Load images and perform alignment (no need to modify this part)
man=(imread('man_color.jpg'));
man=im2double(imresize(man,0.5));
wolf=(imread('wolf_color.jpg'));
wolf=im2double(imresize(wolf,0.5));
%
% the pixel coordinates of eyes and chin have been manually found 
% from both images in order to enable affine alignment 
man_eyes_chin=[452 461;652 457;554 823];
wolf_eyes_chin=[851 919; 1159 947; 975 1451];
[A,b]=affinefit(man_eyes_chin', wolf_eyes_chin');

[X,Y]=meshgrid(1:size(man,2), 1:size(man,1));
pt=A*([X(:) Y(:)]')+b*ones(1,size(man,1)*size(man,2));

wolf_t=zeros(size(man));
for c=1:3
    wolf_t(:,:,c)=interp2(wolf(:,:,c),reshape(pt(1,:),[size(man,1) size(man,2)]),reshape(pt(2,:),[size(man,1) size(man,2)]));
end

imga=man;
imgb=wolf_t;

% Create masks that indicate the area of interest for image blending.
% Manually defined binary mask with an elliptical shape is constructed
% as well as its complement.
x0=553;y0=680;
a=160; b=190;
pixmask=find((((X(:)-x0)/a).^2+((Y(:)-y0)/b).^2)<1);

maskb = zeros(size(imga));
maskbw=zeros(size(imga,1),size(imga,2));
maskbw(pixmask)=1;
for c=1:3
    maskb(:,:,c)=maskbw;
end
maska = 1-maskb;

level = 8;

%% Make Laplacian image pyramids with 8 levels.
% Output is cell array (i.e. lpimga{i} is the Laplacian image at level i).
% The image at the final level is the base level image from the
% corresponding Gaussian pyramid.
% In the version below the second input is either 'lap' or 'gauss',
% and it defines whether to output Laplacian or Gaussian pyramid.
soz = size(imga);
new_immagine1 = zeros(2049,2049,3);
new_immagine1(1:soz(1),1:soz(2),:) = imga;
soz = size(imga);
new_immagine2 = zeros(2049,2049,3);
new_immagine2(1:soz(1),1:soz(2),:) = imgb;




lpimga = generateLaplacianPyramid(new_immagine1,'lap',level);
lpimgb = generateLaplacianPyramid(new_immagine2,'lap',level);

%% Check that reconstruction works by examining the error (which should be small)
ima=reconstLaplacianPyramid(lpimga);
max_reconstruction_error = max(abs(new_immagine1(:)-ima(:)))

%% Make Gaussian image pyramids of the mask images, maska and maskb
maska_1 = zeros(2049,2049,3);
maskb_1 = zeros(2049,2049,3);
maska_1(1:1107,1:1107,:) = maska;
maskb_1(1:1107,1:1107,:) = maskb;
gpmaska = generateLaplacianPyramid(maska,'gauss',level); %
gpmaskb = generateLaplacianPyramid(maskb,'gauss',level);

%% Make smooth masks in a simple manner for comparison (no need to modidy)
blurh = fspecial('gauss',60,20); 
smaska = imfilter(maska_1,blurh,'replicate');
smaskb = imfilter(maskb_1,blurh,'replicate');

%% In practice, you can also use the Gaussian pyramids of smoothed masks. 
% In this case, the blendings (simple & pyramid) will appear more similar.
gpsmaska = generateLaplacianPyramid(smaska,'gauss',level); 
gpsmaskb = generateLaplacianPyramid(smaskb,'gauss',level);

%% Blending
limgo = cell(1,level); % the blended pyramid
for p = 1:level
    % Blend the Laplacian images at each level 
    % (You can use either one of the two rows below.) 
    [Mp,Np,~] = size(lpimga{p});
	gpsmasa = imresize(smaska,[Mp Np]);
	gpsmasb = imresize(smaskb,[Mp Np]);
	limgo{p} = (lpimga{p}.*gpsmaska{p} + lpimgb{p}.*gpsmaskb{p})./(gpsmaska{p}+gpsmaskb{p});
% 	limgo{p} = (lpimga{p}.*gpsmasa + lpimgb{p}.*gpsmasb)./(gpsmasa+gpsmasb);
end

%% Reconstruct the blended image from its Laplacian pyramid  
imgo = reconstLaplacianPyramid(limgo);
imgo_final = imgo(1:1107,1:1107,:);

% Simple blending with smooth masks without a pyramid
imgo1 = smaska.*new_immagine1+smaskb.*new_immagine2;

immagine1_final = new_immagine1(1:1107,1:1107,3);
immagine2_final = new_immagine2(1:1107,1:1107,3);

imgo1_final = imgo1(1:1107,1:1107,:);
figure;
set(gcf,'Name','Blending Results');

subplot(2,3,1); imshow(imga);
axis image;
title('Input Image A');
subplot(2,3,2); imshow(imgb);
axis image;
title('Input Image B');

subplot(2,3,4); imshow(imgo1_final);
axis image;
title('Simple Blending');

% run the commented lines below to visualize results

subplot(2,3,5); imshow(imgo_final);
axis image;
title('Pyramid Blending');

differenza = imgo_final-imgo1_final;

subplot(2,3,6); imagesc(max(differenza,[],3));
axis image;axis off;colormap('gray');colorbar
title('Difference:');
