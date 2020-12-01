function data_transmitting(wavin,wavout,SNR,times)

% wavin = 'M_stego.wav';
% wavout = 'M_stego2.wav';
% SNR = 100;
if nargin<4
    type = 0;
end
lsb_tran(wavin,wavout,SNR)

% 剪切攻击
if nargin>3
    [wav,Fs] = audioread(wavout);
    [m,n] = size(wav);
    wav(floor(m*times):end,:)=0;
    audiowrite(wavout,wav,Fs);
end

end