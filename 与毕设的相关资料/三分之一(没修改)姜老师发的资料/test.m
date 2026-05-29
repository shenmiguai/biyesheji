clear;clc;clf;
fs = 128;
N = 1024;
t = 0:1/fs:(N-1)/fs;
value=cos(2*pi*16*t);
n = 0:N-1;
f_axis = n*fs/N;

xdft = fft(value,N);
%xdft = xdft(1:N/2+1);
psdx = (1/(fs*N)) * abs(xdft).^2;
%psdx(2:end-1) = 2*psdx(2:end-1);

rms5 = sqrt( sum(psdx*fs/N) )
