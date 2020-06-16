%% The first part uses Matlab's Computer Vision System Toolbox
% SURF regions are extracted and matched and a similarity transformation 
% (i.e. rotation, translation and scale) between the views is estimated
I1 = (imread('boat1.png'));
I2 = (imread('boat6.png'));

points1 = detectSURFFeatures(I1);
points2 = detectSURFFeatures(I2);

% The SURF descriptor vectors for the detected features are stored in f1, f2 
[f1, vpts1] = extractFeatures(I1, points1);
[f2, vpts2] = extractFeatures(I2, points2);

indexPairs = matchFeatures(f1, f2) ;
matchedPoints1 = vpts1(indexPairs(:, 1));
matchedPoints2 = vpts2(indexPairs(:, 2));

% The estimation of geometric transformations is covered later in lectures
% but it can be done as follows using Matlab built-in functionality:
[tform,inlierPoints2,inlierPoints1] = ...
    estimateGeometricTransform(matchedPoints2,matchedPoints1,'similarity','MaxDistance',10);
H1to2p=inv(tform.T');H1to2p=H1to2p./H1to2p(end);
s=sqrt(det(H1to2p(1:2,1:2)));
R=H1to2p(1:2,1:2)/s;
t=H1to2p(1:2,3);

%% The previous part illustrated Matlab's built-in capabilities.

% Next, the task is to implement a similar blob detector as in SIFT. 
% In the example below the detections are pre-computed.
% Since we now know the true geometric transformation H1to2p we can 
% visualize those detections from both images which have large overlap.
% Your task is to implement the function scaleSpaceBlobs.m so that it
% outputs similar circular regions as pre-computed in 'blobs1' and 'blobs2'.


%% Replace 'blobs1' and 'blobs2' below with the output of the detector.
% load blobs1;
% load blobs2;
% Each row in 'blobs1' and 'blobs2' defines a circular region as follows:  
% [x y r filter_response]
% here x and y are the column and row coordinates of the circle center
% r is the radius of the circle, r=sqrt(2)*sigma (see slide 77 of Lecture 3)
% last column indicates the response of the Laplacian of Gaussian filter


% Below N is the number of strongest blobs that are returned.
% (strongest local maxima for the scale-normalized Laplacian of Gaussian)
% Fill in the missing parts in scaleSpaceBlobs.m
% Everything should then work if you uncomment the following three lines.

N=500;
blobs1=scaleSpaceBlobs(double(I1),N);
blobs2=scaleSpaceBlobs(double(I2),N);

NVIS=50;
% scale blob radius with factor 3 for better visualization
show_all_circles(I1, blobs1(1:NVIS,1), blobs1(1:NVIS,2), 3*sqrt(2)*blobs1(1:NVIS,3), 'y', 3);
show_all_circles(I2, blobs2(1:NVIS,1), blobs2(1:NVIS,2), 3*sqrt(2)*blobs2(1:NVIS,3), 'y', 3);

% below we illustrate detected regions with high overlap 
xy1to2=s*R*((blobs1(:,1:2))')+t*ones(1,size(blobs1,1));
blobs1t=[xy1to2' s*blobs1(:,3) blobs1(:,4)];

dmat=zeros(size(blobs1,1),size(blobs2,1));
for i=1:size(blobs1,1)
    for j=1:size(blobs2,1)
        dmat(i,j)=norm(blobs1t(i,1:3)-blobs2(j,1:3));
    end
end
[dist,nnids]=min(dmat);
[sdist,sids]=sort(dist(:),'ascend');
idlist=[nnids(sids)' sids(:) sdist(:)];

% We visualize 20 "matches" 
Nvis=20;

fig1=figure;
imshow([I1  I2]);hold on;
title('The top 20 nearest neighbors of blobs features');
    
% blod radii are scaled by factor 6 below for better visualization
t=[0:1:360]/180*pi;
for k=1:Nvis
    loc1=blobs1(idlist(k,1),1:2);
    r1=6*blobs1(idlist(k,1),3);
    loc2=blobs2(idlist(k,2),1:2);;
    r2=6*blobs2(idlist(k,2),3);
    figure(fig1);
    plot(loc1(1)+r1*cos(t),loc1(2)+r1*sin(t),'m-','LineWidth',3);
    plot(loc2(1)+r2*cos(t)+size(I1,2),loc2(2)+r2*sin(t),'m-','LineWidth',3);
    plot([loc1(1);loc2(1)+size(I1,2)],[loc1(2); loc2(2)],'c-');
end

