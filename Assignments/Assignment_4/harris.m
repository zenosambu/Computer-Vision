function [x,y,cornerImg]=harris(img,sigma,relTh,k)
%HARRIS Corner detection for images.
%   [X,Y]=HARRIS(IMG) computes harris corner features for the image
%   IMG and returns the corner coordinates as two vectors X and Y. 
%   Standard values for parameters are used except differentation is
%   computed by Gaussian derivatives.
%
%   [X,Y]=HARRIS(IMG,SIGMA,RELTH,K) spesifies the parameters SIGMA
%   (default 1), RELTH (relative threshold, default 0.0001), and K
%   (default 0.04).

if nargin<4 | isempty(k)
  k=0.04; %k=0.04;
end

if nargin<2 | isempty(sigma)
  sigma=1; %sigma=0.7;
end

if nargin<3 | isempty(relTh)
  relTh=0.0001; %relTh=0.0001; %Relative threshold
end

g=gaussian2(sigma); %smoothing window
[tmp,gx,gy]=gaussian2(0.5); %derivatives

%Ix=filter2([-2 -1 0 1 2],img,'same');  
%Iy=filter2([-2 -1 0 1 2]',img,'same');  
Ix=filter2(gx,img,'same');  
Iy=filter2(gy,img,'same');  

Ix2Sm=filter2(g,Ix.^2);
Iy2Sm=filter2(g,Iy.^2);

IxIySm=filter2(g,Ix.*Iy);


detC = (Ix2Sm.*Iy2Sm)-(IxIySm.*IxIySm);
traceC = Ix2Sm+Iy2Sm;

R=detC-k*traceC.^2;

clear Ix Iy Ix2Sm Iy2Sm IxIySm detC traceC

maxCornerValue=max(R(:));

%Take only cornerness maxima
maxImg=colfilt(R,[3 3],'sliding','max([x(1:4,:);x(6:9,:)])');
%maxImg=colfilt(R,[5 5],'sliding','max([x(1:12,:);x(14:25,:)])');

%maxImg=nlfilter(R,[3 3],'neighbormax');
cornerImg=R>maxImg; %test if cornerness is larger than neighborhood

[y,x]=find(R>relTh*maxCornerValue & cornerImg); %threshold

%Remove responses from image borders
[r,c]=size(R);
idx=find(x<3 | x>c-2 | y<3 | y>r-2);
x(idx)=[]; 
y(idx)=[];

% Parabolic interpolation 
for i=1:length(x)
    [m,dx]=maxinterp(R(y(i),x(i)+(-1:1)));
    [m,dy]=maxinterp(R(y(i)+(-1:1),x(i)));
    x(i)=x(i)+dx;
    y(i)=y(i)+dy;
end

if nargout<2
  x=[x y];
end
