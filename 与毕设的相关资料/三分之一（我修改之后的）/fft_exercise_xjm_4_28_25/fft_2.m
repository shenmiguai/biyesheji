% 初始设置
% 清空工作空间，关闭无关页面
clc,clear,close all;
 
fs=500;%采样频率
duration=2;%信号采样时间
%% 
%在现实世界中信号采样持续时间一般包含了非整数个周期的信号样本，比如将duration改为0.64
%比如duration=0.64,这个时候会发现频谱在临近的频率之间扩散，尖峰变的比较平缓而不再尖锐，
%这个时候为了解决这些问题，惯用的做法是做零填充，也就是将零幅值的信号附加到原始信号样本的后边
%在做完零填充之后，我们更新样本数量频谱图上出现了三个主瓣，而每个主瓣周围都出现了副瓣，我可以采用加窗的方法，来减少旁瓣干扰。
%所谓的加窗，就是将窗函数与原始信号相乘，然而在使用窗函数时，我需要调整缩放系数，已获得正确的振幅。
%duration=0.64;
N=fs*duration; %总采样点数
dt=1/fs;
t=0:dt:duration-1/fs;%时间向量
%参数
a1=3;f1=30;phi1=0.6;
a2=2;f2=45;phi2=-0.8;
a3=1;f3=70;phi3=2;
%正弦信号汇总
s1=a1*cos(2*pi*f1*t+phi1); % 幅值3  频率30
s2=a2*cos(2*pi*f2*t+phi2); % 幅值2  频率45 
s3=a3*cos(2*pi*f3*t+phi3); % 幅值1  频率70
%合成信号
s=s1+s2+s3;
S=fft(s);

%% 通过这一段代码就可以得到是s1 s2 s3 正弦信号的频率与幅值了
figure
S_oneSide=S(1:N/2);%因为对称性所以左边的三个尖峰已经包含了足够的信息，所以我们不需要考右边镜像的3个尖峰
f=fs*(0:N/2-1)/N; %然后将x轴将样本索引值改为频率值
S_meg=abs(S_oneSide)/(N/2);%并通过将信号幅值除以样本数的一半，来调整y轴的数值，这样就得到了信号的频域图
plot(f,S_meg)  %信号的幅度表示各个正弦分量的幅值，各个频率值表示了各个频率分量的频率
xlabel('Frequency(hz)')      %设置 x 轴的标签为 "时间 (s)"
ylabel('Amplitude' )      %设置 y 轴的标签为 "信号幅值"。
title('Frequency-domin plot单边频谱') 

%% 下边是获得三个正弦波量初始相位的代码
% phase1=angle(S_oneSide(f1*duration+1));
% phase2=angle(S_oneSide(f2*duration+1));
% phase3=angle(S_oneSide(f3*duration+1));
% figure
% subplot(3,1,1)
% stem(phase1)
% title('第1个正弦波的相位'); %高度0.6
% 
% subplot(3,1,2)
% stem(phase2)
% title('第2个正弦波的相位'); %高度-0.8
% 
% subplot(3,1,3)
% stem(phase3)
% title('第3个正弦波的相位'); %高度2


%

%% 这是合成之后的时域信号
% figure
% plot(t, s)
% xlabel('时间 (s)')      %设置 x 轴的标签为 "时间 (s)"
% ylabel('信号幅值' )      %设置 y 轴的标签为 "信号幅值"。
% title('合成后的信号波形') %设置字体大小和字体类型。

%% 这一段代码证明信号在做完fft变换之后，如果不进行abs()的操作的话得到是复数
% % subplot(3,1,1)
% % plot(S)
% % title('fft(s)没有取模值')


