function convert(wavin,rate)
[wav,Fs] = audioread(wavin);
audiowrite('temp.ogg',wav,Fs,'Quality',rate);
[wav2,Fs2] = audioread('temp.ogg');
audiowrite(wavin,wav2,Fs2);
end
