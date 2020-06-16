function [output1] = estimateF(punto1,punto2)
fun = ones(11,9);
for i = 1:11
    fun(i,:) = [punto1(i,1)*punto2(i,1) punto2(i,1)*punto1(i,2) punto2(i,1) punto2(i,2)*punto1(i,1) punto1(i,2)*punto2(i,2) punto2(i,2) punto1(i,1) punto1(i,2) 1];
end
sk = transpose(fun)*fun;
[U,S,V] = svd(sk);
[m,n] = size(V);
fundamental = zeros(3,3);
fundamental(1,1) = V(1,n);
fundamental(1,2) = V(2,n);
fundamental(1,3) = V(3,n);
fundamental(2,1) = V(4,n);
fundamental(2,2) = V(5,n);
fundamental(2,3) = V(6,n);
fundamental(3,1) = V(7,n);
fundamental(3,2) = V(8,n);
fundamental(3,3) = V(9,n);

[U1,S1,V1] = svd(fundamental);
[m,n] = size(V1);
V1(m,n) = 0;

fundamental_final = U1 * S1 *transpose(V1);



output1 = fundamental_final;
end

