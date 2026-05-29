%% \\正弦添加高斯白噪声
clc;
clear
t = 0:.001:.25;
s=5*cos(2*pi*50*t); 
figure(1);
subplot(211);
plot(t,s);
grid on;

r = s + 2*randn(size(t));
subplot(212);
plot(t,r);
grid on;
%% \\正弦求功率谱

t = 0:.001:.25;
x =5*cos(2*pi*50*t); 
figure;subplot(211);
plot(t,x);

Y = fft(x,256);
YY=fftshift(Y);
Pyy = YY.*conj(YY)/256;%计算功率谱密度


f = 1000/256*(-128:127);% X从1到256

subplot(212);
plot(f,Pyy(1:256))
title('Power spectral density')
xlabel('Frequency (Hz)')
axis([-120 120 0 1500]);
grid on

