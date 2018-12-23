function [num]=ex3(image)

%0. Have the image in grayscale
image=im2double(imread(image));
I=rgb2gray(image);
%1. Binarize image
imbin=imbinarize(I,0.9);
figure
subplot(2,2,1); imshow(imbin)
%% 2. Apply morphological filter remove noise
se=strel('disk',5);
imop=imopen(imbin,se);
im=imcomplement(imop);
subplot(2,2,2); imshow(im)

%% %3. Calculate the edges : advanced filter
se=strel('disk',1);
imbord=imdilate(im,se)-im;
subplot(2,2,3); imshow(imbord)
%% %4. Calculate the distance from each pixel to the
%nearest edge --> distance function
[D,~]=bwdist2(imop,'Chessboard');
%imshow(D,[])
%% 5. Apply a small dilation to join maximas that are very close together
se=strel('square',5);
imdil=imdilate(D,se);
subplot(2,2,4); imshow(imdil,[]) %obtenim el mateix que al 2.
suptitle('Process before segmentation')

%% 6. Watershed to the inverted distance function image
Dinv = imcomplement(imdil);
I=watershed(Dinv,8);
L=im2double(label2rgb(I));
%7. Restrict the result of the watershed only to the objects of interest
L=L(:,:,1:3).*imdil;
figure
subplot(1,2,1)
imshow(image)
title('Original Image')
subplot(1,2,2)
imshow(L)
title('Segmentation')
%% %8. count the number of connected components(groups of neighboring pixels
%of the same value).

CC=bwconncomp(I);
num=CC.NumObjects;

end
