function [P] = camcalibDLT(inp1,inp2)
%CAMCALIBDLT Summary of this function goes here
%   Detailed explanation goes here
[M,~] = size(inp1);
A = zeros(M*2,12);
m = 1;
for i = 1:M
    A(m,:) = [zeros(1,4) inp1(i,:)  -inp2(i,2)*inp1(i,:)];
    A(m+1,:) = [inp1(i,:) zeros(1,4)  -inp2(i,1)*inp1(i,:)];
    m = m+2;
end
Mat = transpose(A)*A;
[U,S,V] = svd(Mat);
P(1,:) = V(1:4,12);
P(2,:) = V(5:8,12);
P(3,:) = V(9:12,12);

return















end

