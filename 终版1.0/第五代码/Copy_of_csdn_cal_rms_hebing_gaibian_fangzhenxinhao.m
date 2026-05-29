%% \\自定义的信号，加噪声、平滑处理、最小二乘、三分之一倍频程
%% \\无FIR滤波
%%\\持续的时间 采样点数  幅度
%% \\
clear;
clc;close all;
%fc=[1.0000 1.2599 1.5874 1.9952 2.5119 3.1623 3.9811 5.0119 6.3096 7.9433 10.0000 12.5893 15.8489 19.9526 25.1189 31.6228 39.8107 50.1187 63.0957 79.4328 100.0000 125.8925 158.4893 199.5262 251.1886 316.2278 398.1072 501.1872 630.9573 794.3282 1000.0000 1258.9254 1584.8932 1995.2623 2511.8864 3162.2777 3981.0717 5011.8723 6309.5734 7943.2823 10000.0000 12589.2541 15848.9319 19952.6231];
fc= [1 1.25 1.6 2 2.5 3.15 4 5 6.3 8 10 12.5 16 20 25 31.5 40 50 63 80 100 125 160 200 250 315 400 500 630 800 1000 1250 1600 2000 2500 3150 4000 5000 6300 8000 10000 12500 16000 20000 25000 31500 40000 50000 63000 80000 100000 125000 160000 200000];

%% 模拟信号
Adc=0;  %直流分量幅度
A1=2;   %频率F1信号的幅度
A2=6; %频率F2信号的幅度
A3=9; %频率F2信号的幅度
F1=10;  %信号1频率(Hz)
F2=500;  %信号2频率(Hz)
F3=800;  %信号2频率(Hz)

fs = 8192; %采样频率(Hz)
T = 2;  % 总时长（秒）%T的间隔=1.220703125000000e-04
N = fs * T;  % N=16384 总采样点数
Ts = 1/fs;% 采样间隔
t =0:Ts:T-Ts;

P1=0; %信号1相位(度)
P2=0;  %信号2相位(度)
P3=0; %信号3相位(度)% N=256;%采样点数  %t=[0:1/Fs:N/Fs]; %采样时刻

%信号
%sig=Adc+A1*sin(2*pi*F1*t+pi*P1/180)+A2*cos(2*pi*F2*t+pi*P2/180)+A3*sin(2*pi*F3*t+pi*P3/180);%仿真软件
sig= 2*sin(2*pi*10*t) + 6*cos(2*pi*500*t) + 9*sin(2*pi*800*t); 
% sig= 2*sin(2*pi*2*t); 

plot(sig);%显示原始信号
title('原始信号');


% sig= 2*sin(2*pi*10*t) + 6*cos(2*pi*500*t) + 9*sin(2*pi*800*t); %仿真软件
% sig_zhuanzhi=sig';
% t_zhaunzhi=t';
% shuzu=[t_zhaunzhi,sig_zhuanzhi];%16384x2 double %输出OSA测试的数据
%% \\对原始信号进行时频分析
figure(1) 
subplot(3,1,1)
pspectrum(sig,fs,'spectrogram','TimeResolution',1/fs*100,'OverlapPercent',99,'Leakage',0.85)
hold on;%sig=（2048x1）
% % 加窗
% w = hamming(length(sig));        % 列向量窗函数
% sig_win = sig .* w;              % 加窗
% gain = 1 / mean(w);              % 幅度修正系数
% sig_win = sig_win * gain;        % 修正后的信号
%% 信号平滑处理
% 生成含噪声的信号
noise=0.5*randn(size(t));
sig = sig + noise;

% 使用smoothdata
window_size = 20;
y_smooth = smoothdata(sig, 'movmean', window_size);

% 手动卷积实现
kernel = ones(window_size, 1)/window_size;
y_smooth_conv = conv(sig, kernel, 'same');
% 绘图比较
figure;
plot(t, sig, 'b', t, y_smooth, 'r', 'LineWidth', 1.5);
legend('原始信号', '移动平均');

%% 最小二乘法去除趋势项
% 去除3次趋势项
[y3, xtrend3] = polydetrend(sig, fs, 3);
figure;
subplot(3, 1, 1); plot(t,sig); title('原始信号');grid on;
subplot(3, 1, 2); plot(t,y3); title('去除非线性趋势项后信号(polyfit拟合非线性方法)');grid on;
subplot(3, 1, 3); plot(t,xtrend3); title('非线性趋势项'); grid on;

%% FFT分析
L1=length(sig);              % 信号长度 % L1=16384
NFFT1=2^nextpow2(L1);      % 取大于信号长度的最近的2的幂次，做FFT时效率更高
Xk1=fft(sig,NFFT1);          % 对信号做快速傅里叶变换（频谱分析）
mag1=abs(Xk1);             % 计算频谱幅值

% 单边谱幅值修正
mag1(2:NFFT1/2) = 2 * mag1(2:NFFT1/2); % 幅值加倍（除直流）
mag1_single = mag1(1:NFFT1/2);          % 取正频率部分
db1 = 20*log10(mag1_single);            % 转换为dB % 1x8192 double
% 频率轴
k1=0:NFFT1/2-1;            % 正半部分的频率（实数信号的频谱对称）
f1 = k1 * fs/ NFFT1;      % 使用正确的fs值
figure
subplot(2,1,1);plot(t,sig);%0~1ms
title('振动信号_____时域图');
xlabel('Time（s）');ylabel('Amplitude');

subplot(2,1,2);
plot(f1, db1);
title('振动信号____单边__频谱图'); 
xlabel('Frequency（Hz）');ylabel('Amplitude（dB）')

%% 
oc6=2^(1/6);%中心频率与下限频率的比值 %oc6=1.1225
nc=length(fc);%取中心频率总的长度  %nc=54
n=length(sig);%输入数据的长度 %n=2048
nfft=2^nextpow2(n);%大于并接近n的2的幂次方长度  %2048
a=fft(sig,nfft);%FFT变换  a=(2048x1) % a复数
%%
yc = zeros(1,nc);
for j=1:nc %nc=44
    fl=fc(j)/oc6; 
    fu=fc(j)*oc6;  %fc=20khz对应fl=224480hz
    nl=round(fl*nfft/fs+1); %下限频率对应的序号
    nu=round(fu*nfft/fs+1);%上限频率对应的序号  
    if fu>fs/2 %如果上限频率大于半谱频率则循环中断
        m=j-1; disp(m);
        break  %判断有效的频率，当一旦出现频率值超过fs/2时，立即停止后边数据的检查，因为出现了f太大的信号，不符合奈奎斯特定律     
    end
    disp(j);     
    b=zeros(1,nfft);%1x2048
    b(nl:nu)=a(nl:nu);
    b(nfft-nu+1:nfft-nl+1)=a(nfft-nu+1:nfft-nl+1);%以每个中心频率段为通带进行带通频域滤波
    c=ifft(b,nfft);%c是复数  
    yc(j)=sqrt(var(real(c(1:n)))); %该公式认为信号c是零均值的  %yc=RMS %每个中心频率段的RMS 	%计算对应每个中心频率段的有效值%注意，matlab函数var和std认为操作数是度量总体的一个样本，所以使用的公式是实际值与期望值之差的平方和再除以（N-1）
end

%% ------------------绘制输入时域曲线图形---------图一------------------------
figure(4)
subplot(313)
t=0:1/fs:(n-1)/fs;
plot(t, sig); % 增加线条宽度
xlabel('时间(s)', 'FontName', '宋体', 'FontSize', 14); % 增加字体大小
ylabel('加速度(m/s^2)', 'FontName', '宋体', 'FontSize', 14); % 增加字体大小
grid on;
grid minor; % 显示次要网格线
title('输入时域曲线图形', 'FontName', '宋体', 'FontSize', 16); % 增加标题字体大小
saveas(gcf, 'saved_figure_1.png');

%---------------------------图二-------离散----等宽---------------------------------
%论文配图
figure(4)
subplot(312)
x_values = 1:m;
bar(x_values, yc(1:m), 'BarWidth', 0.8); % 画柱状图
xticks(x_values);
xticklabels(fc(1:m)); % 设置 X 轴为频率标签
xlabel('三分之一倍频中心频率(Hz)', 'FontName', '宋体', 'FontSize', 14); % 增加字体大小
ylabel('每一频段的RMS值', 'FontName', '宋体', 'FontSize', 14); % 增加字体大小
grid on;
grid minor; % 显示次要网格线
title('1/3倍频每一中心频率的RMS值', 'FontName', '宋体', 'FontSize', 10); % 标题字体大小
saveas(gcf, 'saved_figure_2.png');

%%%-----------------------plot---------图三----连续-------------------
%论文配图
figure(4)
subplot(311)
set(groot, 'ScreenPixelsPerInch', 300);% 设置图像分辨率
x_values = 1:m;
plot(x_values, yc(1:m),'r-','LineWidth',2.5); % 画柱状图   %蓝色'b-'
xticks(x_values);
xticklabels(fc(1:m)); % 设置 X 轴为频率标签
xlabel('三分之一倍频中心频率(Hz)', 'FontName', '宋体', 'FontSize', 14); % 增加字体大小
ylabel('每一频段的RMS值', 'FontName', '宋体', 'FontSize', 14); % 增加字体大小
grid on;
grid minor; % 显示次要网格线
title('1/3倍频程RMS连续谱', 'FontName', '宋体', 'FontSize', 10); % 增加标题字体大小
 saveas(gcf, 'saved_figure_3.png');  
 
%% \\ 附加功能
% %---------------------------------绘制功率谱-------------------------------
% ff=linspace(0,fs/2,ceil(n/2));
% Amplitude=2*abs(a)/nfft; %a=fft(x,nfft);%Amplitude_x是取模，归一化，的线性尺度的幅度谱
% Amplitude(1)=Amplitude(1)/n;%Amplitude(1)直流分量在单边谱分析中的处理方式和其他频率分量不同。
% Power=Amplitude.*Amplitude;
% Power=20*log10(Power);%dB单位的“功率谱”
%论文配图
% figure
% subplot(511)
% set(groot, 'ScreenPixelsPerInch', 300);% 设置图像分辨率
% plot(log10(ff),Power(1:ceil(n/2)),'b-','LineWidth',0.8);
% xlabel('log10(ff)', 'FontName', '宋体', 'FontSize', 14); % 增加字体大小
% ylabel('db(功率谱)', 'FontName', '宋体', 'FontSize', 14); % 增加字体大小
% % -------模板级别--------
% set(gca, 'FontName', '宋体', 'FontSize', 12);
% % set(gcf,'Position',[150,150,800,500]);
% grid on;
% grid minor; % 显示次要网格线
% title('信号的功率谱', 'FontName', '宋体', 'FontSize', 16); % 增加标题字体大小
% saveas(gcf, 'saved_figure_4.png');

% %-----------------------------------绘制信号幅频---------------------------------
% subplot(512)
% set(groot, 'ScreenPixelsPerInch', 300);% 设置图像分辨率
% plot(log10(ff),Amplitude(1:ceil(n/2)),'b-','LineWidth',0.8);
% xlabel('log10(ff)', 'FontName', '宋体', 'FontSize', 14); % 增加字体大小
% ylabel('幅度', 'FontName', '宋体', 'FontSize', 14); % 增加字体大小
% % -----模板级别-----
% set(gca, 'FontName', '宋体', 'FontSize', 12);
% % set(gcf,'Position',[150,150,800,500]);
% grid on;
% grid minor; % 显示次要网格线
% title('信号幅频', 'FontName', '宋体', 'FontSize', 16); % 增加标题字体大小
% saveas(gcf, 'saved_figure_5.png');
% %-----------------------------------绘制信号实频---------------------------------
% subplot(513)
% r=real(a);
% set(groot, 'ScreenPixelsPerInch', 300);% 设置图像分辨率
% plot(log10(ff),r(1:ceil(n/2)),'b-','LineWidth',0.8);
% xlabel('log10(ff)', 'FontName', '宋体', 'FontSize', 14); % 增加字体大小
% ylabel('实频', 'FontName', '宋体', 'FontSize', 14); % 增加字体大小
% % -----模板级别------
% set(gca, 'FontName', '宋体', 'FontSize', 12);
% % set(gcf,'Position',[150,150,800,500]);
% grid on;
% grid minor; % 显示次要网格线
% title('信号实频', 'FontName', '宋体', 'FontSize', 16); % 增加标题字体大小
% saveas(gcf, 'saved_figure_6.png');


% %-----------------------------绘制信号虚频---------------------------------
% subplot(514)
% i=imag(a);
% set(groot, 'ScreenPixelsPerInch', 300);% 设置图像分辨率
% plot(log10(ff),i(1:ceil(n/2)),'b-','LineWidth',0.8);
% xlabel('log10(ff)', 'FontName', '宋体', 'FontSize', 14); % 增加字体大小
% ylabel('虚频', 'FontName', '宋体', 'FontSize', 14); % 增加字体大小
% % -----模板级别------
% set(gca, 'FontName', '宋体', 'FontSize', 12);
% % set(gcf,'Position',[150,150,800,500]);
% grid on;
% grid minor; % 显示次要网格线
% title('信号虚频', 'FontName', '宋体', 'FontSize', 16); % 增加标题字体大小
% saveas(gcf, 'saved_figure_7.png');

% %----------------------------------绘制信号相频----------------------------------
% ph = angle(a)*180/pi;
% subplot(515)
% set(groot, 'ScreenPixelsPerInch', 300);% 设置图像分辨率
% plot(log10(ff),ph(1:ceil(n/2)),'b-','LineWidth',0.7);
% xlabel('log10(ff)', 'FontName', '宋体', 'FontSize', 14); % 增加字体大小
% ylabel('相位', 'FontName', '宋体', 'FontSize', 14); % 增加字体大小
% % -----模板级别-----
% set(gca, 'FontName', '宋体', 'FontSize', 12);
% % set(gcf,'Position',[150,150,800,500]);
% grid on;
% grid minor; % 显示次要网格线
% title('信号相频', 'FontName', '宋体', 'FontSize', 16); % 增加标题字体大小
% saveas(gcf, 'saved_figure_8.png');

%% 2. 最小二乘法去除线性趋势项
% %-------------------------------最小二乘法去除线性趋势项----------------------------------
% [p, s, mu] = polyfit(t,sig, 1);
% figure;
% subplot(4, 1, 1); plot(t,sig); title('原始信号');grid on;
% subplot(4, 1, 2); plot(t,detrend(sig));grid on; title('去除线性趋势项的原始信号(detrend去除线性趋势项方法)');
% subplot(4, 1, 3); plot(t,polyval(p,t)); grid on;title('去除线性趋势项后信号(polyfit拟合线性方法)');
% subplot(4, 1, 4); plot(t,detrend(sig)); grid on;title('线性趋势项');
% % 去除3次趋势项
% [y3, xtrend3] = polydetrend(sig, fs, 2);
% figure;
% subplot(3, 1, 1); plot(t,sig); title('原始信号');grid on;
% subplot(3, 1, 2); plot(t,y3); title('去除非线性趋势项后信号(polyfit拟合非线性方法)');grid on;
% subplot(3, 1, 3); plot(t,xtrend3); title('非线性趋势项'); grid on;
% 
