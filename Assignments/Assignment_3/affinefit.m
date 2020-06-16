function [A,b]=affinefit(x,y)
%
% solves A and b so that norm(y-(Ax+b*ones(1,n)),'fro') is minimised
%
% x=2*n
% y=2*n

n=size(x,2);
X=[x' ones(n,1)];
S=inv(X'*X);

v1=S*X'*y(1,:)';
v2=S*X'*y(2,:)';

A=[v1(1:2) v2(1:2)]';
b=[v1(3);v2(3)];
end

