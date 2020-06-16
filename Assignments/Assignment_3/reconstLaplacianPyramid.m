function [ IMG ] = reconstLaplacianPyramid( pyramid )
for p = length(pyramid)-1:-1:1
	pyramid{p} = pyramid{p}+pyr_expand(pyramid{p+1});
end
IMG = pyramid{1};
end