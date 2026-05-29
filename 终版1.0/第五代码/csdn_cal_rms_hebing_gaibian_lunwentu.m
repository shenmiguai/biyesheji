%% \\ 画出所有的论文图像，对excel数据进行处理
%% \\ 时频图、FIR滤波、频域特征、3D时频图、2D热力图
%% \\ 最小二乘法去趋势项、FIR滤波前后对比、三分之一倍频程谱

%% \\假如FIR低通滤波
clear;
clc;close all;
fc=[1.0000 1.2599 1.5874 1.9952 2.5119 3.1623 3.9811 5.0119 6.3096 7.9433 10.0000 12.5893 15.8489 19.9526 25.1189 31.6228 39.8107 50.1187 63.0957 79.4328 100.0000 125.8925 158.4893 199.5262 251.1886 316.2278 398.1072 501.1872 630.9573 794.3282 1000.0000 1258.9254 1584.8932 1995.2623 2511.8864 3162.2777 3981.0717 5011.8723 6309.5734 7943.2823 10000.0000 12589.2541 15848.9319 19952.6231];
%fc= [1 1.25 1.6 2 2.5 3.15 4 5 6.3 8 10 12.5 16 20 25 31.5 40 50 63 80 100 125 160 200 250 315 400 500 630 800 1000 1250 1600 2000 2500 3150 4000 5000 6300 8000 10000 12500 16000 20000 25000 31500 40000 50000 63000 80000 100000 125000 160000 200000];

%% %% 1. 导入信号
data_dir = 'E:\matlab2021aa\sum_proj\三分之一倍频\新三分之一倍频程_xjm\36波形.xlsx'; %可
Signal = xlsread(data_dir);   % 读Excel文件
t=Signal(:,1);%第一列 %xjm %时间没有减一
sig= Signal(:,2);  %加速度值  
dt = t(2)-t(1);  % 时间间隔（假设是均匀采样）这段代码就是针对等时间间隔的采样。
fs = 1/dt;  %fs=8192 奈奎斯特采样频率
%% 绘制3D图
window = 128;            % 每一帧的窗口长度（单位：采样点）
noverlap = 100;           % 帧之间的重叠长度（单位：采样点）% 避免信息丢失，提高时间分辨率
nfft = 2^nextpow2(length(sig));             % FFT 点数 %nfft 的值影响频率分辨率（点越多越细）。
[S,F,T] = spectrogram(sig, window, noverlap, nfft, fs); % spectrogram 对信号 sig 做短时傅里叶变换
% T=1x69
% abs(S)=1025x69
% F=1025x1

% 绘制 3D 时频图
%这类图通常用于振动信号分析、声音信号分析、机械故障诊断等时变信号的研究
figure(5)
mesh(T, F, abs(S));      % mesh 函数绘制一个3D网格图
axis tight;%坐标轴范围紧贴数据；
xlabel('Time (s)');ylabel('Frequency (Hz)');zlabel('Magnitude');
title('3D 时频图（Spectrogram）');
view(35, 60);       % 设定3D视角角度
shading interp;  % 插值平滑颜色过渡
colormap turbo;          % 配色
colorbar;%图例 %添加一个颜色条 %颜色与幅度的对应关系，方便观察哪些频率成分强、哪些弱。


figure(7)
subplot(211)
% 2D热力图（频率-时间-强度）
imagesc(T, F, 20*log10(abs(S)));  % 对数刻度显示
axis tight;%坐标轴范围紧贴数据；
xlabel('Time (s)');ylabel('Frequency (Hz)');zlabel('强度');
title('2D热力图（频率-时间-强度）');
axis xy; colorbar;


% 3D曲面图（更平滑的可视化）
subplot(212)
surf(T, F, abs(S));
view(35, 60); 
shading interp;  % 插值平滑颜色过渡
xlabel('Time (s)');ylabel('Frequency (Hz)');zlabel('Magnitude');
title('振动信号3D曲面图');
% 时间分辨率：减小window可提高时间精度，但降低频率分辨率
% 频率分辨率：增大nfft可细化频率刻度，但增加计算量
% 重叠率：noverlap接近window时（如 80%），频谱过渡更平滑

%% \\对原始信号进行时频分析
% ① 时频图
figure(1) 
subplot(1,2,1)
pspectrum(sig,fs,'spectrogram','TimeResolution',1/fs*100,'OverlapPercent',99,'Leakage',0.85)
hold on;%sig=（2048x1）
title('原信号时频图', 'FontSize', 10); % 增加标题字体大小
% ② 加窗
% sig_win = sig .* hamming(length(sig)); %未进行能量修正
w = hamming(length(sig));        % 列向量窗函数
sig_win = sig .* w;              % 加窗
gain = 1 / mean(w);              % 幅度修正系数
sig_win = sig_win * gain;        % 修正后的信号

% ③ 进行fft
L1=length(sig_win);              % 信号长度
NFFT1=2^nextpow2(L1);      % 取大于信号长度的最近的2的幂次，做FFT时效率更高
Xk1=fft(sig_win,NFFT1);          % 对信号做快速傅里叶变换（频谱分析）
mag1=abs(Xk1);             % 计算频谱幅值
db1=20*log10(mag1);         % 将幅值转换为 dB（对数刻度，常用于频谱分析）% db1=20*log10((mag1+eps)/max(mag1)); % 可选的归一化dB计算方式（防止 log(0)）
k1=0:NFFT1/2-1;             % 保留前半部分的频率（实数信号的频谱对称）
f1=k1*fs/NFFT1/(1e3);       % 将频率从Hz转为KHz（便于显示）

figure
subplot(6,1,1);plot(t,sig);%0~1ms
title('滤波前____振动信号_____时域图');
xlabel('Time（s）');ylabel('Amplitude');

subplot(6,1,2);plot(f1,db1(1:NFFT1/2)); 
title('滤波前____振动信号____频谱图'); 
xlabel('Frequency（KHz）');ylabel('Amplitude（dB）')

% ④ 低通滤波
Hd = FIR_lowpass_returnFilter;%低通
[b,a]=tf(Hd);            % 调用生成的滤波器 %将滤波器对象 hd 转换为 传递函数形式
[H,W]=freqz(b,a);        % 数字滤波器系统函数
mag=abs(H);   % Amplitude

db=20*log10(mag);% convert to dB   %db=20*log10((mag+eps)/max(mag));% convert to dB
pha=angle(H); % Phase
f2 = W * fs / (2 * pi) / 1e3;   % 单位：KHz
%W：是对应的角频率向量（以弧度为单位，范围为 [0, π]），默认会生成 512 个点。
subplot(613);plot(f2,db);
title('FIR滤波器-————幅频曲线');
xlabel('Frequency（KHz）');ylabel('Amplitude（dB）');grid minor;

subplot(614);plot(f2,pha);
title('FIR滤波器————相频曲线');
xlabel('Frequency（KHz）');ylabel('Phase（rad）'); 
% ⑤ 对加窗振动信号进行低通滤波
sig_win = sig_win(:);                   % 保证是列向量（多余保险）
y_filter=filter(b,a,sig_win); %低通 %加窗
% y_filter=filter(b,a,sig); %低通
subplot(615);plot(t,y_filter);
title('滤波后——扫频信号——时域图');
xlabel('Time（s）');ylabel('Amplitude');
L3=length(y_filter);
NFFT3=2^nextpow2(L3);
Xk3=fft(y_filter,NFFT3);  % fft analysis
mag3=abs(Xk3);     % Amplitude
db3=20*log10(mag3);  % convert to dB %db3=20*log10((mag3+eps)/max(mag3));  % convert to dB
k3=0:NFFT3/2-1;
f3=fs*k3/NFFT3/(1e3);  %convert to KHz units
%----------------绘图——-------------------
subplot(616);plot(f3,db3(1:NFFT3/2));
title('滤波后——振动信号——频谱图');
xlabel('Frequency（KHz）');ylabel('Amplitude（dB）');grid on;
% ⑥ 滤波后信号时频分析 
figure(1)
subplot(1,2,2);
y_filter = real(y_filter);  % 强制变为列向量并取实部
pspectrum(y_filter,fs,'spectrogram','TimeResolution',1/fs*100,'OverlapPercent',99,'Leakage',0.85);
title('FIR的滤波图', 'FontSize', 10); % 增加标题字体大小


figure (6)
subplot(211)
plot(t,sig,t,y_filter,'--','linewidth',2);
legend('原始信号','滤波后信号')
xlabel('时间(s)','FontSize', 8); % 增加字体大小
ylabel('速度(m/s)', 'FontSize', 8); % 增加字体大小
grid minor; % 显示次要网格线
title('FIR滤波前后对比', 'FontSize', 10); % 增加标题字体大小

%% 2. 最小二乘法去除线性趋势项
% % 去除1次趋势项
[p, s, mu] = polyfit(t,sig, 1);
% figure;
% subplot(4, 1, 1); plot(t,sig); title('原始信号');grid on;
% subplot(4, 1, 2); plot(t,detrend(sig));grid on; title('去除线性趋势项的原始信号(detrend去除线性趋势项方法)');
% subplot(4, 1, 3); plot(t,polyval(p,t)); grid on;title('去除线性趋势项后信号(polyfit拟合线性方法)');
% subplot(4, 1, 4); plot(t,detrend(sig)); grid on;title('线性趋势项');
% 
% % 去除3次趋势项
[y3, xtrend3] = polydetrend(sig, fs, 2);
% figure;
% subplot(3, 1, 1); plot(t,sig); title('原始信号');grid on;
% subplot(3, 1, 2); plot(t,y3); title('去除非线性趋势项后信号(polyfit拟合非线性方法)');grid on;
% subplot(3, 1, 3); plot(t,xtrend3); title('非线性趋势项'); grid on;

subplot(212)
plot(t,detrend(sig),t,polyval(p,t),'b',t,y3,'linewidth',2);
legend('原始信号','去除线性趋势项','去除三次趋势项');
xlabel('时间(s)','FontSize', 8); % 增加字体大小
ylabel('速度(m/s)', 'FontSize', 8); % 增加字体大小
grid minor; % 显示次要网格线
title('最小二乘法去除趋势项前后对比', 'FontSize', 10); % 增加标题字体大小

%% 
oc6=2^(1/6);%中心频率与下限频率的比值 %oc6=1.1225
nc=length(fc);%取中心频率总的长度  %nc=54
n=length(sig);%输入数据的长度 %n=2048
nfft=2^nextpow2(n);%大于并接近n的2的幂次方长度  %2048
a=fft(sig,nfft);%FFT变换  a=(2048x1) % a复数
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


%% 三分之一倍频图
%%%-------------plot一下趋势图-----bar(x_values, yc(1:m));-----图三----连续-------------------
%论文配图
figure(4)
subplot(311)
set(groot, 'ScreenPixelsPerInch', 300);% 设置图像分辨率
x_values = 1:m;
plot(x_values, yc(1:m),'r-','LineWidth',2.5); % 画柱状图% 黑色'k-'
%bar(x_values, yc(1:m), 'BarWidth', 0.8); % 画柱状图
xticks(x_values);
xticklabels(fc(1:m)); % 设置 X 轴为频率标签
xlabel('三分之一倍频中心频率(Hz)', 'FontName', '宋体', 'FontSize', 14); % 增加字体大小
ylabel('每一频段的RMS值', 'FontName', '宋体', 'FontSize', 14); % 增加字体大小
% -----模板级别-----
% set(gca, 'FontName', '宋体', 'FontSize', 12);
% set(gcf,'Position',[150,150,800,500]);
grid on;
grid minor; % 显示次要网格线
title('1/3倍频程RMS连续谱', 'FontName', '宋体', 'FontSize', 10); % 增加标题字体大小
hold on;

 saveas(gcf, 'saved_figure_3.png');  
%-----------------bar(x_values, yc(1:m)); ---图二-----等宽---------------------------------
%论文配图
figure(4)
subplot(312)
set(groot, 'ScreenPixelsPerInch', 300);% 设置图像分辨率
x_values = 1:m;
bar(x_values, yc(1:m), 'BarWidth', 0.8); % 画柱状图
xticks(x_values);
xticklabels(fc(1:m)); % 设置 X 轴为频率标签
xlabel('三分之一倍频中心频率(Hz)', 'FontName', '宋体', 'FontSize', 14); % 增加字体大小
ylabel('每一频段的RMS值', 'FontName', '宋体', 'FontSize', 14); % 增加字体大小
% -----模板级别-----
set(gca, 'FontName', '宋体', 'FontSize', 12);
% set(gcf,'Position',[150,150,800,500]);
grid on;
grid minor; % 显示次要网格线
title('1/3倍频每一中心频率的RMS值', 'FontName', '宋体', 'FontSize', 10); % 标题字体大小
saveas(gcf, 'saved_figure_2.png');

                                                                                                                                                                                                  
%% \\ 幅频 虚频 相频 时域 功率谱
%% ------------------绘制输入时域曲线图形-------------------------------
figure(3)
subplot(321)
t=0:1/fs:(n-1)/fs;
set(groot, 'ScreenPixelsPerInch', 300);% 设置图像分辨率
plot(t, sig,'k-','LineWidth',1); % 增加线条宽度
xlabel('时间(s)', 'FontName', '宋体', 'FontSize', 8); % 增加字体大小
ylabel('加速度(m/s^2)', 'FontName', '宋体', 'FontSize', 8); % 增加字体大小
% ---------------------------模板级别-----------------------------
% set(gca, 'FontName', '宋体', 'FontSize', 12);
% set(gcf, 'Position', [350, 250, 800, 500]);
grid on;
grid minor; % 显示次要网格线
title('输入时域曲线图形', 'FontName', '宋体', 'FontSize', 10); % 增加标题字体大小
saveas(gcf, 'saved_figure_1.png');

%---------------------------绘制功率谱-------------------------------
%fs_fft=44100; %40k soundfs=44100

%ff=linspace(0,fs_fft/2,ceil(n/2));%ff=ff'; %x轴
ff=linspace(0,fs/2,ceil(n/2));
Amplitude=2*abs(a)/nfft; %a=fft(x,nfft);%Amplitude_x是取模，归一化，的线性尺度的幅度谱
Amplitude(1)=Amplitude(1)/n;%Amplitude(1)直流分量在单边谱分析中的处理方式和其他频率分量不同。
Power=Amplitude.*Amplitude;
Power=20*log10(Power);%dB单位的“功率谱”

%论文配图
figure(3)
subplot(322)
set(groot, 'ScreenPixelsPerInch', 300);% 设置图像分辨率
plot(log10(ff),Power(1:ceil(n/2)),'k-','LineWidth',1);
xlabel('log10(ff)', 'FontName', '宋体', 'FontSize', 8); % 增加字体大小
ylabel('db(功率谱)', 'FontName', '宋体', 'FontSize', 8); % 增加字体大小
% -------模板级别--------
% set(gca, 'FontName', '宋体', 'FontSize', 12);
% set(gcf,'Position',[150,150,800,500]);
grid on;
grid minor; % 显示次要网格线
title('信号的功率谱', 'FontName', '宋体', 'FontSize', 10); % 增加标题字体大小
saveas(gcf, 'saved_figure_4.png');

%-----------------------------------绘制信号幅频---------------------------------
%论文配图
figure(3)
subplot(323)
set(groot, 'ScreenPixelsPerInch', 300);% 设置图像分辨率
plot(log10(ff),Amplitude(1:ceil(n/2)),'k-','LineWidth',1);
xlabel('log10(ff)', 'FontName', '宋体', 'FontSize', 8); % 增加字体大小
ylabel('幅度', 'FontName', '宋体', 'FontSize', 8); % 增加字体大小
% -----模板级别-----
% set(gca, 'FontName', '宋体', 'FontSize', 12);
% set(gcf,'Position',[150,150,800,500]);
grid on;
grid minor; % 显示次要网格线
title('信号幅频', 'FontName', '宋体', 'FontSize', 10); % 增加标题字体大小
saveas(gcf, 'saved_figure_5.png');
%-----------------------------------绘制信号实频---------------------------------
figure(3)
subplot(324)
r=real(a);
set(groot, 'ScreenPixelsPerInch', 300);% 设置图像分辨率
plot(log10(ff),r(1:ceil(n/2)),'k-','LineWidth',1);
xlabel('log10(ff)', 'FontName', '宋体', 'FontSize', 8); % 增加字体大小
ylabel('实频', 'FontName', '宋体', 'FontSize', 8); % 增加字体大小
% -----模板级别------
% set(gca, 'FontName', '宋体', 'FontSize', 12);
% set(gcf,'Position',[150,150,800,500]);
grid on;
grid minor; % 显示次要网格线
title('信号实频', 'FontName', '宋体', 'FontSize', 10); % 增加标题字体大小
saveas(gcf, 'saved_figure_6.png');


%-----------------------------绘制信号虚频---------------------------------
%论文配图
figure(3)
subplot(325)
i=imag(a);
set(groot, 'ScreenPixelsPerInch', 300);% 设置图像分辨率
plot(log10(ff),i(1:ceil(n/2)),'k-','LineWidth',1);
xlabel('log10(ff)', 'FontName', '宋体', 'FontSize', 8); % 增加字体大小
ylabel('虚频', 'FontName', '宋体', 'FontSize', 8); % 增加字体大小
% -----模板级别------
% set(gca, 'FontName', '宋体', 'FontSize', 12);
% set(gcf,'Position',[150,150,800,500]);
grid on;
grid minor; % 显示次要网格线
title('信号虚频', 'FontName', '宋体', 'FontSize', 10); % 增加标题字体大小
saveas(gcf, 'saved_figure_7.png');

%----------------------------------绘制信号相频----------------------------------
%论文配图
figure(3)
subplot(326)
ph = angle(a)*180/pi;
set(groot, 'ScreenPixelsPerInch', 300);% 设置图像分辨率
plot(log10(ff),ph(1:ceil(n/2)),'k-','LineWidth',1);
xlabel('log10(ff)', 'FontName', '宋体', 'FontSize', 8); % 增加字体大小
ylabel('相位', 'FontName', '宋体', 'FontSize', 8); % 增加字体大小
% -----模板级别-----
% set(gca, 'FontName', '宋体', 'FontSize', 8);
% set(gcf,'Position',[150,150,800,500]);
grid on;
grid minor; % 显示次要网格线
title('信号相频', 'FontName', '宋体', 'FontSize', 10); % 增加标题字体大小
saveas(gcf, 'saved_figure_8.png');
%% ---------------------------------各种图-------------------------------------------------------------------
% -------------------------------------绘制A声级-------------------------------------------------------------------
% yc=10*log10(yc/1e-10); %yc=(1x60) 
% %yc = 20 * log10(yc / (20e-5)); %严格标准写法  
% %yc = 20 * log10(yc /1 * 10^(-6));  % 参考加速度（通常是1微米/秒??）
% 
% %xjm
% %A声级修正
% cf1=zeros(1,m);%m=36
% cf1(1,11:41)=[-70.4,-63.4,-56.7,-50.5,-44.7,-39.4,-34.6,-30.2,-26.2,-22.5,-19.1,-16.1,-13.4,-10.9,-8.6,...
%     -6.6,-4.8,-3.2,-1.9,-0.8,0,0.6,1.0,1.2,1.3,1.2,1.0,0.5,-0.1,-1.1,-2.5];%20~20khz
% yc1=yc(1:m)+cf1(1:m);%10~20khz  %10零对应0~8hz
% 
% figure 
% plot(fc(14:m),yc1(14:m),'r-s','LineWidth',1.5);          %从20Hz开始画，因此取14。20hz是第十四个频率
% xlabel('频率(Hz)');
% ylabel('A声级(dB)');
% grid on;
% set(gca,'xscale','log','xtick',fc,'XLim',[20 20000],'Fontname','宋体','Fontsize',12);
% set(gcf,'Position',[250,200,800,500]);
% sa=yc(1,14:44);
% %save('006.txt','sa','-ascii' );%保存到文件种不需要
% title('绘制A声级');


%%--------------------------------绘制A声级的柱状图(可不画，形式不同罢了)------------------------
% figure ;%绘制bar
% bar(fc(14:m),yc(14:m)); % 调整柱宽
% grid on;
% xlabel('频率(Hz)');
% ylabel('A声级(dB)');
% set(gca,'xscale','log','xtick',fc,'XLim',[20 20000],'YLim',[0 120],'Fontname','宋体','Fontsize',12);
% set(gcf,'Position',[250,100,800,500]);
% title('A声级柱状图');

%title设置


% %-------------------------------三分之一倍频程----宽度是-----width = fu - fl----------------------------------------
% 
% figure;
% hold on;
% for j = 1:m
%     fl = fc(j)/oc6; % 下限频率
%     fu = fc(j)*oc6; % 上限频率
%     width = fu - fl;
%    rectangle('Position', [fc(j)-width/2, 0, width, yc(j)], ...
%         'FaceColor', [0.2 0.5 0.8], ...
%       'EdgeColor', 'k');
% end
% set(gca, 'XScale', 'log'); % 对数坐标
% 
% % 添加中心频率刻度和标签
% set(gca, 'xtick', fc(1:m)); % 在每个中心频率上打刻度
% xticklabels(string(fc(1:m))); % 使用频率值作为标签（转为字符串）
% xtickangle(45); % 可选：旋转角度避免重叠
% 
% xlabel('中心频率 fc (Hz)', 'FontName','宋体','FontSize',12);
% ylabel('每一频段的 RMS 值', 'FontName','宋体','FontSize',12);
% title('1/3 - 倍频程频谱', 'FontName','宋体','FontSize',14);
% grid on;
% set(gcf,'Position',[800,120,800,500]);


%--------------------log对数坐标-----------柱不等宽--------1/3倍频程中心频率的RMS值---------bar(fc(1:m),yc(1:m));------------------------
% figure 
% bar(fc(1:m),yc(1:m));
% grid minor;
% %grid on;
% xlabel('中心频率fc(Hz)');
% ylabel('每一频段的RMS值');
% set(gca,'xscale','log','xtick',fc(1:m),'Fontname','宋体','Fontsize',12);
% set(gcf,'Position',[800,120,800,500]);
% title('1/3倍频每一中心频率的RMS值');

%论文配图
figure(4)
subplot(313)
set(groot, 'ScreenPixelsPerInch', 300);% 设置图像分辨率
bar(fc(1:m),yc(1:m),'barwidth',0.8);
% plot(log10(ff),Amplitude(1:ceil(n/2)),'b-','LineWidth',0.8);
xlabel('log10(fc)', 'FontName', '宋体', 'FontSize', 14); % 增加字体大小
ylabel('RMS值', 'FontName', '宋体', 'FontSize', 14); % 增加字体大小
% -----模板级别-----
set(gca, 'FontName', '宋体', 'FontSize', 12);
set(gcf,'Position',[150,150,800,500]);
grid on;
grid minor; % 显示次要网格线
title('对数坐标系的1/3倍频程谱', 'FontName', '宋体', 'FontSize', 16); % 增加标题字体大小


% %------------------中心频率序号-------绘制bar_RMS值--------图二-------------------------
% figure  
% bar(yc(1:m));
% grid on
% xlabel('三分之一倍频中心频率序号');
% ylabel('RMS值');
% title('三分之一倍频中心频率序号 有效值RMS');
% set(gca,'Fontname','宋体','Fontsize',12);
% set(gcf,'Position',[150,250,800,500]);
