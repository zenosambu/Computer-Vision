%% The first part uses Matlab's Computer Vision System Toolbox
%% Harris corners are extracted and matched
%% and a planar projective transformation between the views is estimated
I1 = (imread('Boston1.png'));
I2 = (imread('Boston2m.png'));

points1 = detectHarrisFeatures(I1);
points2 = detectHarrisFeatures(I2);

[f1, vpts1] = extractFeatures(I1, points1);
[f2, vpts2] = extractFeatures(I2, points2);

indexPairs = matchFeatures(f1, f2) ;
matchedPoints1 = vpts1(indexPairs(:, 1));
matchedPoints2 = vpts2(indexPairs(:, 2));

% The candidate point matches are visualized as follows:
figure; ax = axes;
showMatchedFeatures(I1,I2,matchedPoints1,matchedPoints2,'montage','Parent',ax);
title(ax, 'Candidate point matches');
legend(ax, 'Matched points 1','Matched points 2');

% The estimation of projective transformation is covered later in lectures
% but it can be done as follows using Matlab built-in functionality:
[tform,inlierPoints2,inlierPoints1] = estimateGeometricTransform(matchedPoints2,matchedPoints1,'projective');

% The correctness of the estimated transformation can be verified by
% checking the difference image after alignment
H1to2p=inv(tform.T');
D=visualizedifferenceimageH(I1,I2,H1to2p);
figure;imagesc(D);axis image;colormap('gray');
title('Difference image after geometric registration');

% The correct point matches can be now visualised since the 
% projective transformation is estimated successfully
figure; ax=axes;
showMatchedFeatures(I1,I2,inlierPoints1,inlierPoints2,'montage','Parent',ax);
title('Matched inlier points');


%% The previous part illustrated Matlab's built-in capabilities.
%% Let's try to do Harris corner extraction and matching using our own
%% implementation in a less black-box manner.

% Harris corner extraction, take a look at the source code of harris.m
[x1,y1]=harris(I1);
[x2,y2]=harris(I2);

n=size(x1,1);
m=size(x2,1);

% We pre-allocate the memory for the 15*15 image patches extracted
% around each corner point from both images
w=7;
patchA=zeros(2*w+1,2*w+1,n);
patchB=zeros(2*w+1,2*w+1,m);

% The following part extracts the patches using bilinear interpolation
[X,Y]=meshgrid(1:size(I1,2),1:size(I1,1));
[Xp,Yp]=meshgrid(-w:w,-w:w);
mA=zeros(1,n);sA=zeros(1,n);
mB=zeros(1,m);sB=zeros(1,m);
for i=1:n
    patchA(:,:,i)=interp2(X,Y,double(I1),Xp+x1(i),Yp+y1(i),'*linear',0);
    mA(i)=sum(sum(patchA(:,:,i)))/((2*w+1)^2);
    sA(i)=sqrt(sum(sum((patchA(:,:,i)-mA(i)).^2)));
end
for j=1:m
    patchB(:,:,j)=interp2(X,Y,double(I2),Xp+x2(j),Yp+y2(j),'*linear',0);
    mB(j)=sum(sum(patchB(:,:,j)))/((2*w+1)^2);
    sB(j)=sqrt(sum(sum((patchB(:,:,j)-mB(j)).^2)));
end

% We compute the sum of squared differences (SSD) of pixels' intensities
% for all pairs of patches extracted from the two images
% SumOfSquaredDiff=zeros(n,m);
% for i=1:n
%     for j=1:m
%         SumOfSquaredDiff(i,j)=sum(sum((patchA(:,:,i)-patchB(:,:,j)).^2));
%     end
% end

NCC=zeros(n,m);
for j=1:m
    mediab(j) = mean2(patchB(:,:,j));
end
for i = 1:n
    mediaa(i) = mean2(patchA(:,:,i));
end
for i=1:n
    for j=1:m
        NCC(i,j) = (sum(sum((patchA(:,:,i)-mediaa(i)).*(patchB(:,:,j)-mediab(j)))))/...
            sqrt((sum(sum((patchA(:,:,i)-mediaa(i)).^2)))*(sum(sum((patchB(:,:,j)-mediab(j)).^2))));
    end
end
% Next we compute pairs of patches that are mutually nearest neighbors
% according to the SSD measure
% [ss2,ids2]=min(SumOfSquaredDiff,[],2);
% [ss1,ids1]=min(SumOfSquaredDiff,[],1);
% pairs=[];
% for k=1:n
%     if k==ids1(ids2(k))
%         pairs=[pairs;k ids2(k) ss2(k)];
%     end
% end

[nn2,idn2]=max(NCC,[],2);
[nn1,idn1]=max(NCC,[],1);
pairsncc=[];
for k=1:n
    if k==idn1(idn2(k))
        pairsncc=[pairsncc;k idn2(k) nn2(k)];
    end
end


[sorted_ncc,id_ncc]=sort(pairsncc(:,3),1,'descend');
disp(length(id_ncc))
% Next we visualize the 40 best matches which are mutual nearest neighbors
% and have the smallest SSD values
Nvis=40;
montage=[I1 I2];
figure;imagesc(montage);axis image; colormap('gray');hold on
title('The best 40 matches according to NCC measure');
for k=1:min(length(id_ncc),40)
    l=id_ncc(k);
    plot(x1(pairsncc(l,1)),y1(pairsncc(l,1)),'mx');
    plot(x2(pairsncc(l,2))+size(I1,2),y2(pairsncc(l,2)),'mx');
    plot([x1(pairsncc(l,1)); x2(pairsncc(l,2))+size(I1,2)],[y1(pairsncc(l,1)); y2(pairsncc(l,2))],'c-','LineWidth',1);
end

% montage=[I1 I2];
% figure;imagesc(montage);axis image; colormap('gray');hold on
% title('The best 40 matches according to SSD measure');
% for k=1:min(length(id_ssd),40)
%     l=id_ssd(k);
%     plot(x1(pairs(l,1)),y1(pairs(l,1)),'mx');
%     plot(x2(pairs(l,2))+size(I1,2),y2(pairs(l,2)),'mx');
%     plot([x1(pairs(l,1)); x2(pairs(l,2))+size(I1,2)],[y1(pairs(l,1)); y2(pairs(l,2))],'c-','LineWidth',1);
% end

% Finally, since we have estimated the planar projective transformation
% we can check that how many of the nearest neighbor matches actually
% are correct correspondences 

x1nn=x1(pairsncc(:,1));y1nn=y1(pairsncc(:,1));
x2nn=x2(pairsncc(:,2));y2nn=y2(pairsncc(:,2));

p1to2=H1to2p*[x1nn(:)'; y1nn(:)'; ones(1,length(x1nn))];
p1to2=p1to2(1:2,:)./p1to2([3 3],:);

pdiff=sqrt(sum(([x2nn(:) y2nn(:)]-p1to2').^2,2));

% The criterion for the match being a correct is that its correspondence in
% the second image should be at most 2 pixels away from the transformed
% location
n_correct=sum(pdiff<2);
display(n_correct);

%% Now, your task is to do matching in similar manner but using normalised 
%% cross-correlation (NCC) instead of SSD. You should also report the 
%% number of correct correspondences for NCC as shown above for SSD.
%%
%% HINT: The row 80 above implements equation (1) from the exercise sheet, 
%% and you need to replace it with implementation of equation (2).
%% Thereafter, you can proceed as above but notice the following details:
%% You need to determine the mutually nearest neighbors by
%% finding pairs for which NCC is maximized (i.e. not minimized like SSD).
%% Also, you need to sort the matches in descending order in terms of NCC
%% in order to find the best matches (i.e. not ascending order as with SSD). 
%% Do not use matlab built-in function normxcorr2 as it is designed for
%% computing NCC in a sliding window manner between the image and template.