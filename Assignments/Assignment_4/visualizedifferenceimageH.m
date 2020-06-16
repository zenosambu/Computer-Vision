function D=visualizedifferenceimageH(im1,im2,H)


r2=size(im2,1);
c2=size(im2,2);

r1=size(im1,1);
c1=size(im1,2);

[X1,Y1]=meshgrid(1:c1,1:r1);
[X2,Y2]=meshgrid(1:c2,1:r2);

Hi=inv(H);
p1=Hi*[X2(:)'; Y2(:)'; ones(1,r2*c2)];
Xh=p1(1,:)./p1(3,:);
Xh=reshape(Xh,r2,c2);
Yh=p1(2,:)./p1(3,:);
Yh=reshape(Yh,r2,c2);

if size(im1,3)==3 
  Zr=interp2(X1,Y1,double(im1(:,:,1)),Xh,Yh,'*linear',0);
  Zg=interp2(X1,Y1,double(im1(:,:,2)),Xh,Yh,'*linear',0);
  Zb=interp2(X1,Y1,double(im1(:,:,3)),Xh,Yh,'*linear',0);
  Z=zeros(r2,c2,3);
  Z(:,:,1)=Zr;Z(:,:,2)=Zg;Z(:,:,3)=Zb;
else
Z=interp2(X1,Y1,double(im1),Xh,Yh,'*linear',0);
end

D=(abs(double(im2)-Z));

