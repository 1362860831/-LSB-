function lsb_tran(wavin,wavout,SNR)

fid = fopen(wavin,'r'); 
header = fread(fid,40,'uint8');             %前44个字节是wav头放着不管
dsize = fread(fid,1,'uint32');
stego  = fread(fid,inf,'uint16');           %数据文件部分
fclose(fid);

%加入给定信噪比的噪声
stego2 = awgn(stego,SNR);                   %这里的SNR单位是dB

out = fopen(wavout,'w');
fwrite(out,header,'uint8');
fwrite(out,dsize,'uint32');
fwrite(out,stego2,'uint16');
fclose(out);

end