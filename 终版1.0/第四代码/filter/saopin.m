%% \\ csdn链接https://blog.csdn.net/lishan132/article/details/103399200
%% \\ 
%% \\ 
clc
clear
close all
%% ① 生成扫频信号
% Fs = 10e6;          %  %1e6即信号的采样率10e6Hz = 10MHz
Fs =450000;          %  42khz
Time_start = 0;     % sample start time 
Time_finish = 1e-3; % sample finish time 1ms
min = 1 ;          % Fre_min： 1e6Hz = 1Hz 
max =300000;          % Fre_max:  30khz
t = Time_start:1/Fs:Time_finish-1/Fs;   % sample time point = (Time_finish-Time_start)*Fs
x = chirp(t,min,Time_finish,max);       % generate sweep signal
%%
figure
subplot(1,2,1)
pspectrum(x,Fs,'spectrogram','TimeResolution',1/Fs*100,'OverlapPercent',99,'Leakage',0.85)
%生成一个高分辨率、平滑的时频图，来展示信号 x 的频率如何随时间变化。
% 横轴：时间（单位秒）
% 纵轴：频率（单位 Hz）
% 颜色：功率强度（颜色越亮，能量越强）
% 对于扫频信号来说，你应该能看到一条频率随时间逐渐上升的亮色曲线

%% 滤波前信号分析 
figure(2)
subplot(3,2,1);plot(t,x);%0~1ms
title('滤波前____扫频信号_____时域图');
xlabel('Time（s）');ylabel('Amplitude');

x_win = x .* hamming(length(x))';% 添加汉明窗

%进行fft
L1=length(x_win);     %加窗         % 信号长度
% L1=length(x);              % 信号长度
NFFT1=2^nextpow2(L1);      % 取大于信号长度的最近的2的幂次，做FFT时效率更高
Xk1=fft(x,NFFT1);          % 对信号做快速傅里叶变换（频谱分析）
mag1=abs(Xk1);             % 计算频谱幅值

% db1=20*log10((mag1+eps)/max(mag1)); % 可选的归一化dB计算方式（防止 log(0)）
db1=20*log10(mag1);         % 将幅值转换为 dB（对数刻度，常用于频谱分析）

k1=0:NFFT1/2-1;             % 保留前半部分的频率（实数信号的频谱对称）
% f1=k1*Fs/NFFT1/(1e6);       % 将频率从Hz转为MHz（便于显示）
f1=k1*Fs/NFFT1/(1e3);       % 将频率从Hz转为KHz（便于显示）

subplot(3,2,2);plot(f1,db1(1:NFFT1/2)); 
title('滤波前____扫频信号____频谱图'); 
xlabel('Frequency（KHz）');ylabel('Amplitude（dB）')

%低通
Hd = FIR_lowpass_returnFilter;%低通
[b,a]=tf(Hd);            % 调用生成的滤波器 %将滤波器对象 hd 转换为 传递函数形式
[H,W]=freqz(b,a);        % 数字滤波器系统函数
mag=abs(H);   % Amplitude

db=20*log10(mag);% convert to dB   %db=20*log10((mag+eps)/max(mag));% convert to dB
pha=angle(H); % Phase
% f2=W*1e4/(2*pi)/(1e3); % convert to KHz units 
f2 = W * Fs / (2 * pi) / 1e3;   % 单位：KHz
%W：是对应的角频率向量（以弧度为单位，范围为 [0, π]），默认会生成 512 个点。

subplot(3,2,3);plot(f2,db);
title('FIR滤波器-————幅频曲线');
xlabel('Frequency（KHz）');ylabel('Amplitude（dB）');grid minor;


subplot(3,2,4);plot(f2,pha);
title('FIR滤波器————相频曲线');
xlabel('Frequency（KHz）');ylabel('Phase（rad）');

 
%% ④ 对扫频信号进行低通滤波
%带通 y=filter(b,a,x); % a,b为系统函数的系数，x为待滤波的信号，y为滤波后输出后的信号
%  y=filter(b,a,x);系统自带的函数
y=filter(b,a,x); %低通
subplot(3,2,5);plot(t,y);
title('滤波后——扫频信号——时域图');
xlabel('Time（s）');ylabel('Amplitude');
L3=length(y);
NFFT3=2^nextpow2(L3);
Xk3=fft(y,NFFT3);  % fft analysis
mag3=abs(Xk3);     % Amplitude
db3=20*log10(mag3);  % convert to dB %db3=20*log10((mag3+eps)/max(mag3));  % convert to dB
k3=0:NFFT3/2-1;
f3=Fs*k3/NFFT3/(1e3);  %convert to KHz units
%----------------绘图——-------------------
subplot(3,2,6);plot(f3,db3(1:NFFT3/2));
title('滤波后——扫频信号——频谱图');
xlabel('Frequency（KHz）');ylabel('Amplitude（dB）');grid on;
%% 对滤波后的信号进行时频分析 
figure(1)
subplot(122)
pspectrum(y,Fs,'spectrogram','TimeResolution',1/Fs*100,'OverlapPercent',99,'Leakage',0.85)