function msg = data_extracting(wavin,password,bit,control,M,bin_seed)


% wavin = 'M_stego2.wav';
% password = 'mypassword123';

if nargin<4
    msg = lsb_dec(wavin, password,bit);
else
    msg = lsb_dec(wavin, password,bit,control,M,bin_seed);
end
h = figure();
imshow(msg)
saveas(gcf,num2str(h.Number),'bmp')


end