function PSNR = pSNR(img,imgn)
[h,w] = size(img);
[h2,w2] = size(imgn);
if(h~=h2 | w~=w2)
    error('ImageA <> ImageB');
end
B=8;                %编码一个像素用多少二进制位
MAX=2^B-1;          %图像有多少灰度级
MES=sum(sum((img-imgn).^2))/(h*w);     %均方差
PSNR=20*log10(MAX/sqrt(MES));           %峰值信噪比