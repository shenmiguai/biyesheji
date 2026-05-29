% xw=1.633*x.*window';     % 加汉宁窗(恢复系数为1.633)，能量修正系数使加窗后能量保证不变
% mag=abs(fft(xw,nfft));
% Pxx_1=mag.^2/N/fs;
% f=(0:nfft/2-1)/nfft*fs;
% plot(f,Pxx_1(1:512)*2),title('Pxx_11')

fs = 1000;
t = 0:1/fs:1-1/fs;
x = cos(2*pi*100*t) + randn(size(t));

N = length(x);
xdft = fft(x);
xdft = xdft(1:N/2+1);
psdx = (1/(fs*N)) * abs(xdft).^2;
psdx(2:end-1) = 2*psdx(2:end-1);
freq = 0:fs/length(x):fs/2;

plot(freq,pow2db(psdx))
grid on
title("Periodogram Using FFT")
xlabel("Frequency (Hz)")
ylabel("Power/Frequency (dB/Hz)")