clear;
close all;
clc;
fs = 1024; % 采样率
N = 1024; % 信号长度
nfft = N;
n = 0:1:N-1;
n1 = fs * (0:nfft/2-1) / nfft; % 时间
x = 1.5 * cos(2 * pi * 98 * n / fs) + 2 * cos(2 * pi * 99 * n / fs) + 3 * cos(2 * pi * 100. * n / fs) + 3.5 * cos(2 * pi * 101 * n / fs);
range_win = hamming(N);   %海明窗
%range_win = hanning(N);   %汉宁窗
x=x.*range_win';


% figure
% plot(range_win);

% L = 64;
% wvtool(hamming(L))

% Hs = hamming(64,'symmetric');%symmetric' 对称的  a
% Hp = hamming(63,'periodic');%periodic 周期的  b
% %wvt = wvtool(Hs,Hp);
% a = wvtool(Hs); %wvtool是画窗函数的
% b = wvtool(Hp);
%legend(wvt.CurrentAxes,'Symmetric','Periodic')

%------------------------------------原始信号---------------------------------------------
figure(1);
plot(n, x, 'LineWidth', 2, 'Color', 'b');
ax1 = gca;  % 获取当前子图的坐标轴对象
ax1.FontSize = 25;  % 设置坐标轴上文字的字体大小
xlabel('采样点数','FontSize',30);
ylabel('幅值','FontSize',30);
title('原始信号','FontSize',30);

% 信号的FFT
%-------------------------------------信号的FFT-------------------------------------------------
XK = fft(x, nfft);
figure(2);
subplot(211);
plot(n1, 2 * abs(XK(1:(N/2))) / N);%信号的频谱
grid minor;
title('信号的FFT');


% CZT频谱
f1 = 93; % 细化起始范围
f2 = 106; % 细化结束范围
M = 200; % 细化倍数
w = exp(-1j * 2 * pi * (f2 - f1) / (fs * M));%M是频谱细化的倍数，也就是CZT计算得到的频谱点数
a = exp(1j * 2 * pi * f1 / fs);
xk = czt(x, M, w, a);%x是时域信号 M是细化倍数 w是参数1 a是参数2
h = 0:1:M-1;
f0 = (f2 - f1) / M * h + f1;%f1是细化起始范围

% %-------------------------------------CZT频谱细化后------------------------------------
subplot(212);
plot(f0, 2 * abs(xk) / N);
xlabel('f');
ylabel('value');
title('CZT频谱细化后');

%-----------------------------------对比FFT和CZT频谱---------------------------------------
% % 对比FFT和CZT频谱
% figure(3);
% subplot(211);
% plot(n1, 2 * abs(XK(1:(N/2))) / N, 'b', 'LineWidth', 3);
% grid on;
% title('FFT和CZT仿真对比','FontSize',30);
% ax1 = gca;  % 获取当前子图的坐标轴对象
% ax1.FontSize = 25;  % 设置坐标轴上文字的字体大小
% xlabel('Frequency (Hz)','FontSize',30);
% ylabel('Amplitude','FontSize',30);
% legend('FFT','FontSize',25);
% subplot(212);
% plot(f0, 2 * abs(xk) / N, 'r', 'LineWidth', 3);
% ax1 = gca;  % 获取当前子图的坐标轴对象
% ax1.FontSize = 25;  % 设置坐标轴上文字的字体大小
% grid on;
% % title('CZT频谱细化后');
% xlabel('Frequency (Hz)','FontSize',30);
% ylabel('Amplitude','FontSize',30);
% legend('CZT','FontSize',25);
