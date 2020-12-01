clear;
close all;
clc;

% 用来隐藏信息的比特位
% bit = 1;              %嵌入比特
SNR = 15;             %SNR单位是dB
rate = 50;            %压缩比率，取[0,100]，100的质量最高，压缩程度最少

f=[];                   %水印的欧氏距离
g=[];                   %载体的欧氏距离
NC = [];                %归一化相关系数
PSNR = [];              %pSNR

for bit = 10:16       %改变比特位
% for SNR = 0:5:20       %改变白噪声信噪比
% for times = 0.1:0.1:1 %改变裁剪比率
% for rate = 50:10:100    %改变压缩率
% 嵌入
wavin = 'M.wav';
wavout = 'M_stego.wav';
password = 'mypassword123';
image = imread('C.jpg');

[control,M,bin_seed] = data_embedding(wavin,wavout,password,image,bit);
a = audioread(wavin);
b = audioread(wavout);
PSNR = [PSNR pSNR(a,b)];
g = [g sum(sum((a-b).^2))];

% 比较一下嵌入LSB之后的音频与原来音频的差别

% 传输
wavin = 'M_stego.wav';
wavout = 'M_stego2.wav';
data_transmitting(wavin,wavout,SNR);
% data_transmitting(wavin,wavout,SNR,times);

% 压缩
wavin = 'M_stego2.wav';
convert(wavin,rate);

% 提取
wavin = 'M_stego2.wav';
% msg = data_extracting(wavin,password,bit);
msg = data_extracting(wavin,password,bit,control,M,bin_seed);

image = rgb2gray(image);
NC =  [NC nc(image,msg)];

f = [f sum(sum((msg-image).^2))];
end
% end
% end
% end