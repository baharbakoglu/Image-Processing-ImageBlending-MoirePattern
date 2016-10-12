
imgA = im2double(imread('MonaLisa.jpg'));
imgB = im2double(imread('MonaLisa.jpg')); 

imgA = imresize(imgA,[size(imgB,1) size(imgB,2)]);%quantize ImgA with ImgB

[h,w,~] = size(imgA);
[yim,xim]=meshgrid(1:w,1:h); % pixel coordinates
figure, imshow(imgA);
h = imfreehand;    % select a region from A image
maskA = createMask(h);%Region Mask
maskA3=repmat(maskA,[1,1,3]);
ImA=imdilate(maskA3,ones(30)).*imgA; % Region Image
centY=sum(sum(maskA.*xim))./sum(maskA(:)); % Center coordinates of region
centX=sum(sum(maskA.*yim))./sum(maskA(:));
hold on
plot(centX,centY,'r+');
figure,imshow(imgB) 
[x,y,button]=ginput(1); % Where will you paste selected region in Image B?
hold on
plot(x,y,'r+');
shiftx=round(x)-round(centX);
shifty=round(y)-round(centY);
shiftedIm=circshift(ImA,[shifty,shiftx]);
shiftedMask=circshift(maskA3,[shifty,shiftx]);
maskb = 1-shiftedMask;

level = 5;
pyramidB = genPyr(imgB,'laplace',level); % the Laplacian pyramid ImgB
pyramidA = genPyr(shiftedIm,'lap',level); % the Laplacian pyramid ImgA
pyramidBlend = cell(1,level); % the blended pyramid
for p = 1:level
    [Mp Np ~] = size(pyramidA{p});
	maskap = imresize(shiftedMask,[Mp Np]);
	pyramidBlend{p} = pyramidA{p}.*maskap + pyramidB{p}.*(1-maskap);
end
blendedImg = pyrReconstruct(pyramidBlend);
figure,imshow(blendedImg)

