function [g,gx,gy,gxx,gyy,gxy]=gaussian2(sigma,N)
%GAUSSIAN returns 2D gaussian filter and its derivatives to the 2nd order
%   [g,gx,gy,gxx,gyy,gxy]=gaussian(sigma)
%   [g,gx,gy,gxx,gyy,gxy]=gaussian(sigma,N)

if nargin<2
  N=2*max(4,ceil(6*sigma))+1;
end

[X,Y]=meshgrid(1:N);

mu1=(N-1)/2+1;
mu2=(N-1)/2+1;
g=1/(2*pi*sigma)*exp(-0.5*((X-mu1).^2/sigma + (Y-mu2).^2/sigma ));

gx=-1/(2*pi*sigma^2)*exp(-0.5*((X-mu1).^2/sigma + (Y-mu2).^2/sigma )).*(X-mu1);

gy=-1/(2*pi*sigma^2)*exp(-0.5*((X-mu1).^2/sigma + (Y-mu2).^2/sigma )).*(Y-mu2);

gxx=1/(2*pi*sigma^3)*exp(-0.5*((X-mu1).^2/sigma + (Y-mu2).^2/sigma ...
    )).*(X-mu1).^2 - 1/(2*pi*sigma^2)*exp(-0.5*((X-mu1).^2/sigma + ...
    (Y-mu2).^2/sigma ));

gyy=1/(2*pi*sigma^3)*exp(-0.5*((X-mu1).^2/sigma + (Y-mu2).^2/sigma ...
    )).*(Y-mu2).^2 - 1/(2*pi*sigma^2)*exp(-0.5*((X-mu1).^2/sigma + ...
    (Y-mu2).^2/sigma ));

gxy=1/(2*pi*sigma^3)*exp(-0.5*((X-mu1).^2/sigma + (Y-mu2).^2/sigma ...
    )).*(X-mu1).*(Y-mu2);
