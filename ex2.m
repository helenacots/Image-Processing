function ex2(image)

I=im2double(imread(image));
%apply morphological filter to remove the minimas and maximas
%before segmenting the image
%closing: tancar els minims
%opening: tancar els maxims
se=strel('square',10);
im=imclose(I,se);
im=imopen(im,se);

L=watershed(im,8);
L=im2double(label2rgb(L));%normalitzar de 0 a 1
L=L(:,:,1:3).*I;%multiply each component RGB by the original image
figure(2)
imshow(L), title('Ex 2: Extrema Killer and Watershed')

end