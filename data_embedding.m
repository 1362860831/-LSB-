function  [control,M,bin_seed] = data_embedding(wavin,wavout,password,image,bit)



image = rgb2gray(image);
% figure()
% imshow(image)

[m,n] = size(image);
text = reshape(image,m*n,1);

 [control,M,bin_seed] = lsb_enc(wavin, wavout, text, password,bit);

% x=audioread(wavin);
% y=audioread(wavout);
% x = x(:,1);
% y = y(:,1);
% global g;
% g =[g sum((x-y).^2)];
% disp(g);

end