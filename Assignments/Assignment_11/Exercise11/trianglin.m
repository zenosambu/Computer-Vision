function [result] = trianglin(P1,P2,p1,p2)
%TRIANGLIN Summary of this function goes here
%   Detailed explanation goes here
[m,~] = size(p1);

L1(1,:) = [0 -p1(3) p1(2)];
L1(2,:) = [p1(3) 0 -p1(1)];
L1(3,:) = [-p1(2) p1(1) 0];

L2(1,:) = [0 -p2(3) p2(2)];
L2(2,:) = [p2(3) 0 -p2(1)];
L2(3,:) = [-p2(2) p2(1) 0];

C1 = L1 * P1;
C2 = L2 * P2;

MAT(1,:) = C1(1,:);
MAT(2,:) = C1(2,:);

MAT(3,:) = C2(1,:);
MAT(4,:) = C2(2,:);

MATT = transpose(MAT)*MAT;


[S,U,V] = svd(MATT);
[~,m] = size(V);
result = V(:,m);
k = 1/result(4);
result(1) = k *result(1);
result(2) = k *result(2);
result(3) = k *result(3);
result(4) = result(4) * k;




    

end

