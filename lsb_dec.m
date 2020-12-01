function out = lsb_dec( wavin, pass,embeded_bit,control,m,bin_seed )

%Header = 1:40, Length = 41:43, Data = 44:end
fid = fopen(wavin,'r'); 
header = fread(fid,40,'uint8');             %前44个字节是wav头放着不管
dsize = fread(fid,1,'uint32');
[stego,stego_length ] = fread(fid,inf,'uint16');           %含有隐藏信息的数据文件部分
fclose(fid);

% 首先还原控制字部分，因为后面能否解密要考察对称密钥是否一致
if nargin<4
    control = bitget(stego(1:8),embeded_bit)';
else
    control = control';
end

if b2d(control) == mod(sum(double(pass)),256)
    % 提取隐藏文件的大小
    if nargin<5
        m = bitget(stego(9:48),embeded_bit);
    end
    len = b2d(m')*8;
    % 提取隐藏位置
    if nargin<6
        bin_seed = bitget(stego(49:56),embeded_bit)';
    end
    seed  = b2d(bin_seed);
    rand('seed',seed);
    pos = randperm(stego_length-56,len);
    
    % 提取密文信息，并解密
    dat = xor(bitget(stego(56+pos),embeded_bit),prng(pass,len));
    bin = reshape(dat,len/8,8);
    % 还原成十进制
    out = b2d(bin);
    out = uint8(reshape(out,sqrt(len/8),sqrt(len/8)));      %保持灰度图像编码uint8
else
    error('Password is wrong or message is corrupted!');
    out = [];
end
end

function d = b2d(b)
%将二进制还原成double
  if isempty(b)
    d = [];
  else   
    % 利用矩阵乘法实现还原
    d = b * (2 .^ (0:length(b(1,:)) - 1)');
  end
end

function out = prng( key, L )
% 利用随机数种子和口令key产生密钥
pass = sum(double(key).*(1:length(key)));
rand('seed', pass);
out = (rand(L, 1)>0.5);         %这样最终产生的是L长的二进制比特流作为密钥
end