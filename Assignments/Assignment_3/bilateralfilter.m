function output = bilateralfilter(image,w,sigma)

[dimx,dimy] = meshgrid(-w:w,-w:w);
G = exp(-(dimx.^2+dimy.^2)/(2*sigma(1)^2));
dim = size(image);
for i = 1:dim(1)
   for j = 1:dim(2)
         minimoi = max(i-w,1);
         minimoj = max(j-w,1);
         massimoi = min(i+w,dim(1));
         massimoj = min(j+w,dim(2));
         I = image(minimoi:massimoi,minimoj:massimoj);
         H = exp(-(I-image(i,j)).^2/(2*sigma(2)^2));
         M = H.*G((minimoi:massimoi)-i+w+1,(minimoj:massimoj)-j+w+1);
         output(i,j) = sum(M(:).*I(:))/sum(M(:));
               
   end
end


        
end
