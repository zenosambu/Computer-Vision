function output1 = estimateFnorm(x1,x2)
x1=transpose(x1);
x2=transpose(x2);


centroid1 = mean(x1, 2);

dist1 = sqrt(sum((x1 - repmat(centroid1, 1, size(x1, 2))) .^ 2, 1));

mean_dist1 = mean(dist1);

Nmatrix1 = [sqrt(2) / mean_dist1, 0, -sqrt(2) / mean_dist1 * centroid1(1);...
           0, sqrt(2) / mean_dist1, -sqrt(2) / mean_dist1 * centroid1(2);...
           0, 0, 1];
       
centroid2 = mean(x2, 2);

dist2 = sqrt(sum((x2 - repmat(centroid2, 1, size(x2, 2))) .^ 2, 1));

mean_dist2 = mean(dist2);

Nmatrix2 = [sqrt(2) / mean_dist2, 0, -sqrt(2) / mean_dist2 * centroid2(1);...
           0, sqrt(2) / mean_dist2, -sqrt(2) / mean_dist2 * centroid2(2);...
           0, 0, 1];
       
new_x1 = Nmatrix1 * x1;
new_x2 = Nmatrix2 * x2;


fx1 = transpose(new_x1 ./ repmat(new_x1(3, :), [3, 1]));
fx2 = transpose(new_x2 ./ repmat(new_x2(3, :), [3, 1]));

ou= estimateF(fx1,fx2);

output1 = Nmatrix2' * ou * Nmatrix1;



end

