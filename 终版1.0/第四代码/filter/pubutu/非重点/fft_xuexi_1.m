%% //Standard Procedure
clc,clear,close all;
fs=500;
 %% //绘制原信号波形  1khz  采样时长：1s
t = 0:0.001:1-0.001;%1000个
% y = 3*sin(2*pi*10*t) + sin(2*pi*500*t) + sin(2*pi*800*t); 
%  y =5*sin(2*pi*500*t) + sin(2*pi*800*t); 
% y=5*sin(2*pi*100*t); 
a1=3;f1=30;phi1=0.6;
a2=2;f2=45;phi2=-0.8;
a3=1;f3=70;phi3=2;
%正弦信号汇总
s1=a1*cos(2*pi*f1*t+phi1); % 幅值3  频率30
s2=a2*cos(2*pi*f2*t+phi2); % 幅值2  频率45 
s3=a3*cos(2*pi*f3*t+phi3); % 幅值1  频率70
%合成信号
y=s1+s2+s3;
figure
plot(t, y, 'b-');
xlabel('时间 (s)');ylabel('信号幅值');title('原信号波形');
%% //信号分析% 数据长度
datalength = length(y);% 信号长度 1001     
NFFT1=2^nextpow2(datalength);%1024     % 取大于信号长度的最近的2的幂次，做FFT时效率更高
Xk1=fft(y,NFFT1);          % 对信号做快速傅里叶变换（频谱分析）
mag1=abs(Xk1);             % 计算频谱幅值
figure(7)
f_full = fs * (0:NFFT1-1) / NFFT1;  % 生成完整频率轴（0 到 fs）
plot(f_full(1:datalength), mag1(1:datalength));  % 显示前 datalength 点（与原信号长度一致）
title('FFT 模值');
%% \\                  % NFFT1是采样点数
S_oneSide=Xk1(1:NFFT1/2);%因为对称性所以左边的三个尖峰已经包含了足够的信息，所以我们不需要考右边镜像的3个尖峰

f=fs*(0:NFFT1/2-1)/NFFT1; %然后将x轴将样本索引值改为频率值
S_meg=abs(S_oneSide)/(NFFT1/2);%并通过将信号幅值除以样本数的一半，来调整y轴的数值，这样就得到了信号的频域图
figure(8)
plot(f,S_meg)  %信号的幅度表示各个正弦分量的幅值，各个频率值表示了各个频率分量的频率
xlabel('Frequency(hz)')      %设置 x 轴的标签为 "时间 (s)"
ylabel('Amplitude' )      %设置 y 轴的标签为 "信号幅值"。
title('单边频谱') ;


