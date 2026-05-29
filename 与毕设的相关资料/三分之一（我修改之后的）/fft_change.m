function [f, A] = fft_change(x, fs);
N = length(x);
Y = fft(x, N)/N;
YY = Y(1:N/2+1);
A = abs(YY);
f = (0:N/2)*fs/N;




