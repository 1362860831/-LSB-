function [control,M,bin_seed]=lsb_enc(wavin, wavout, text, pass, embeded_bit)


% 考虑到wav格式的文件有个头
% 所以还要做一些裁剪
fid = fopen(wavin,'r');
header = fread(fid,40,'uint8');                  % 前40个字节并没有什么用，最后按照正常的还回去就好了
dsize = fread(fid,1,'uint32');
[cover,len_cover] = fread(fid,inf,'uint16');           % 剩下的就是波形数据了
fclose(fid);

% [cover,Fs] = audioread(wavin);
% cover = cover(:,1);
% len_cover = length(cover);


bin   = d2b(double(text),8);
[m,n] = size(bin);
M     = d2b(m,40)';
len_msg = m*n;

% 随机产生加密位置
seed = randperm(255,1);
rand('seed',seed);
pos = randperm(len_cover-56,len_msg);
bin_seed = d2b(seed,8);

% 流加密
bitx = 1*xor(reshape(bin,m*n,1), prng(pass, len_msg));
binx = reshape(bitx, m, n);                             % 要嵌入的部分

if (len_cover >= len_msg+56)
    % 最开始的8个用于藏控制帧，这个部分和口令pass有关
    control = d2b(mod(sum(double(pass)),256),8)';
    cover(1:8) = bitset(cover(1:8),embeded_bit,control(1:8));
    % 之后的40个用于藏传输信息的大小
    cover(9:48) = bitset(cover(9:48),embeded_bit,M(1:40));
    % 之后8位用来保存隐藏信息的位置    
    cover(49:56) = bitset(cover(49:56),embeded_bit,bin_seed(1:8)');
    % 剩下的部分藏传输的密文
    cover(56+pos) = bitset(cover(56+pos),embeded_bit,binx(1:len_msg)');
    % 将文件还原成wav格式
    out = fopen(wavout,'w');
    fwrite(out,header,'uint8');
    fwrite(out,dsize,'uint32')
    fwrite(out,cover,'uint16');
    fclose(out);
else
    error('Message is too long!');
end
end

function b = d2b( d, n )
% 将double转换成二进制
d = d(:);
power = ones (length (d), 1) * (2 .^ (0 : n-1) );
d = d * ones (1, n);
b = floor (rem(d, 2*power) ./ power);
end

function out = prng( key, L )
% 利用随机数种子和口令key产生密钥
pass = sum(double(key).*(1:length(key)));
rand('seed', pass);
out = (rand(L, 1)>0.5);     %这样最终产生的是L长的二进制比特流作为密钥
end