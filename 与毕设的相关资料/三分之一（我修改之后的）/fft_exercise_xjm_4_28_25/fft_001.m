% 初始设置
% 清空工作空间，关闭无关页面
clc,clear,close all;

dt=0.02; 
N=512;
n=0:N-1;   
t=n*dt;
fs=1/dt;  
f=n/(N*dt);
f1=3;   f2=10;
x=0.5*sin(2*pi*f1*t)+cos(2*pi*f2*t);
y=fft(x);



figure(1)
subplot(2,1,1)
plot(t,x);%绘制原来的    时域信号
xlabel('时间/s')           
title('原始信号的时间域') 


subplot(2,1,2)
plot(f,abs(y)*2/N);%绘制原来的信号的振幅谱
xlabel('频率/hz')
ylabel('振幅' ) 
title('原始振幅谱');
xlim([0 50]);

figure(2)
y_oneSide=y(1:N/2);%因为对称性所以左边的三个尖峰已经包含了足够的信息，所以我们不需要考右边镜像的3个尖峰
f=fs*(0:N/2-1)/N; %然后将x轴将样本索引值改为频率值
y_meg=abs(y_oneSide)/(N/2);%并通过将信号幅值除以样本数的一半，来调整y轴的数值，这样就得到了信号的频域图
plot(f,y_meg)  %信号的幅度表示各个正弦分量的幅值，各个频率值表示了各个频率分量的频率
xlim([0 50]);
ylim([0 1]);
xlabel('Frequency(hz)')      %设置 x 轴的标签为 "时间 (s)"
ylabel('Amplitude' )      %设置 y 轴的标签为 "信号幅值"。
title('Frequency-domin plot单边频谱') 


%% 补零
figure (3)
x=[x,zeros(1,10000)];
x=[x,zeros(1,10000)];%做零填充，也就是将零幅值的信号附加到原始信号样本的后边
n=length(x);
S=fft(x);
y_oneSide=S(1:n/2);%因为对称性所以左边的三个尖峰已经包含了足够的信息，所以我们不需要考右边镜像的3个尖峰
f=fs*(0:n/2-1)/n %然后将x轴将样本索引值改为频率值
y_meg=abs(y_oneSide)/(n/2);%并通过将信号幅值除以样本数的一半，来调整y轴的数值，这样就得到了信号的频域图
plot(f,y_meg)  
xlim([0 50]);
ylim([0 0.03]);

%% 有错误
% subplot(2,2,3)
% nfft = 2^nextpow2(N); % 大于并最接近n的2的幂次方长度
% a = fft(x,nfft);      % FFT变换
% plot(f,a);%绘制原来的信号的振幅谱
% xlabel('频率/hz')
% ylabel('振幅' ) 
% title('原始振幅谱');
% xlim([0 50]);


%% 做零填充
%做零填充
% figure
% s=[s,zeros(1,1000)];%做零填充，也就是将零幅值的信号附加到原始信号样本的后边
% n=length(s);
% S=fft(s);
% y_oneSide=S(1:n/2);%因为对称性所以左边的三个尖峰已经包含了足够的信息，所以我们不需要考右边镜像的3个尖峰
% f=fs*(0:n/2-1)/n %然后将x轴将样本索引值改为频率值
% y_meg=abs(y_oneSide)/(n/2);%并通过将信号幅值除以样本数的一半，来调整y轴的数值，这样就得到了信号的频域图
% plot(f,y_meg)  %信号的幅度表示各个正弦分量的幅值，各个频率值表示了各个频率分量的频率


%% 通过这一段代码就可以得到是s1 s2 s3 正弦信号的频率与幅值了
% figure
% S=fft(s);
% %这句S=fft(s)代码有没有都一样，因为用的就是补零之后的s，工作区s的数值已经改变为补零之后的数值了。但是如果把这一段代码挪到前边就不一样了，使用的是没有补零的s
% y_oneSide=S(1:N/2);%因为对称性所以左边的三个尖峰已经包含了足够的信息，所以我们不需要考右边镜像的3个尖峰
% f=fs*(0:N/2-1)/N; %然后将x轴将样本索引值改为频率值
% y_meg=abs(y_oneSide)/(N/2);%并通过将信号幅值除以样本数的一半，来调整y轴的数值，这样就得到了信号的频域图
% plot(f,y_meg)  %信号的幅度表示各个正弦分量的幅值，各个频率值表示了各个频率分量的频率
% xlabel('Frequency(hz)')      %设置 x 轴的标签为 "时间 (s)"
% ylabel('Amplitude' )      %设置 y 轴的标签为 "信号幅值"。
% title('Frequency-domin plot单边频谱') 





%% 双边谱一般没有什么用，得到图中的六个尖峰呈现对称分布
% figure
% plot(abs(S))
% xlabel('Samples采样点')      %设置 x 轴的标签为 "时间 (s)"
% ylabel('Magnitude幅值' )      %设置 y 轴的标签为 "信号幅值"。
% title('fft(s)取模值,双边频谱')%得到图中的六个尖峰呈现对称分布，因为对称性所以左边的三个尖峰已经包含了足够的信息，所以我们不需要考右边镜像的3个尖峰

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


