function A = generateLaplacianPyramid(IMG ,tipo, livello)
A = cell(1,livello);
A{1} = im2double(IMG);
for p = 2:livello
    A{p} = pyr_reduce(A{p-1});
end

if strcmp(tipo,'gauss'), return; end
for p = livello-1:-1:1
	osz = size(A{p+1})*2-1;
	A{p} = A{p}(1:osz(1),1:osz(2),:);
end
for p = 1:livello-1
	A{p} = A{p}-pyr_expand(A{p+1});
end
end


