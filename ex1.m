%% extract watersheds from the image
function ex1(image)
I=im2double(imread(image));
L=watershed(I,8);
L=im2double(label2rgb(L));%normalitzar de 0 a 1
L=L(:,:,1:3).*I;%multiply each component RGB by the original image
figure(1)
imshow(L), title('Ex 1: Watershed')
end

