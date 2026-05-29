% 初始设置
% 清空工作空间，关闭无关页面
clc,clear,close all;
 
% 绘图变量
% font_size =10;     axis_size = 10;       line_width = 0.5;    legend_size = 10.5; 
% figure_width = 14;  figure_height =8;    BiaValue = 0;      marker_size = 12;
%
fs=500;%采样频率
duration=2;%信号采样时间
N=fs*duration; %总采样点数
dt=1/fs;
t=0:dt:duration-1/fs;%时间向量
%参数
a1=3;f1=30;phi1=0.6;
a2=2;f2=45;phi2=-0.8;
a3=1;f3=70;phi3=2;
%正弦信号汇总
s1=a1*cos(2*pi*f1*t+phi1);
s2=a1*cos(2*pi*f2*t+phi2);
s3=a1*cos(2*pi*f3*t+phi3);
%合成信号
s=s1+s2+s3;
S=fft(s);

figure

%% 
%figure 
subplot(3,1,2)
plot(abs(S))
xlabel('Samples采样点')      %设置 x 轴的标签为 "时间 (s)"
ylabel('Magnitude幅值' )      %设置 y 轴的标签为 "信号幅值"。
title('fft(s)取模值')

%figure
subplot(3,1,3)
plot(t, s)
xlabel('时间 (s)')      %设置 x 轴的标签为 "时间 (s)"
ylabel('信号幅值' )      %设置 y 轴的标签为 "信号幅值"。
title('合成后的信号波形') %设置字体大小和字体类型。

%% 这一段代码证明信号在做完fft变换之后，如果不进行abs()的操作的话得到是复数
% % subplot(3,1,1)
% % plot(S)
% % title('fft(s)没有取模值')


