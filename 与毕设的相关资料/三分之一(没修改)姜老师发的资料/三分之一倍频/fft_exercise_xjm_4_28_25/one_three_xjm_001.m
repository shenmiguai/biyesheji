% % 初始设置
% % 清空工作空间，关闭无关页面
% clc,clear,close all;
% 
% fs = 400; 
% N=8192;
% wn=sqrt(N)*randn(1,N);%均值为零，方差=N的高斯随机序列
% p0=2e-5;% 参考声压
% f=[1.00 1.25 1.600 2.00 3.15 4.00 5.00 6.30 8.00];%基准中心频率
% f1=[20.00 25.0 31.5 40.0 50.0 63.0 80];
% fc=[f1,100*f,1000*f,10000*f];
% cf=[-50.5,-44.7,-39.4,-34.6,-30.2,-26.2,-22.5,-19.1,-16.1,-13.4,-10.9,-8.6,-6.6,-48,-3.2,-1.9,-0.8,0,0.6,1.0,1.2,1.3,1.2,1.0,0.5,-0.1,-1.1,-2.5,-4.3,-6.6,-9.3];%20-16000Hz A声级计权值
% t1=0; t2=8;
% x=wn(t1*fs+1 : t2*fs);%截取需要处理的数据段
% %x = wn(t1*fs+l : t2*fs); % 截取需要处理的数据段
% n=length(x);
% t=(0:1/fs:(n-1)/fs);
% w=hanning(n);%汉宁窗
% xx=1.633*x.*w;%加汉宁窗(恢复系数为1.633)
% nfft=2^nextpow2(n); %nextpow2(n)-取最接近的较大2次幂
% a=fft(xx,nfft);
% %%%%%%1/3倍频程计算%%%%%%%%%%%%%%%%%%%
% oc6 = 2^(1/6);
% nc=length(cf);
% yc=zeros(1,nc);
% for j = 1:nc   
%       fl = fc(j)/oc6;  % 下限频率   
%       fu = fc(j)*oc6;      % 上限频率
%       nl = round(fl*nfft/fs+1);  % 下限频率对应的序号
%       nu = round(fu*nfft/fs+1);  % 上限频率对应的序号
%       if fu > fs/2     % 如果上限频率大于折叠频率则循环中断
%          m = j-1; break;
%       end
%     % 以每个中心频率段为通带进行带通频域滤波 
%       b = zeros(1,nfft);
%       b(nl:nu) = a(nl:nu);
%       b(nfft-nu+1:nfft-nl+1) = a(nfft-nu+1:nfft-nl+1);
%       c = ifft(b,nfft);
%     %计算对应每个中心频率段的有效值
%       yc(j) = sqrt(var(real(c(1:n))));
% end
% aj_sum=0;
% for i=1:nc
%     Lp1(i)=20*log10(yc(i)/p0);%未计权1/3倍频程声压级
% end
% 
% for j=1:nc
%     aj_sum=aj_sum+10^(0.1*Lp1(j));
% end
% 
% Lp=10*log10(aj_sum);
% subplot(212);
% bar(Lp1(1:30),'k');
% xlabel('频率/hz');
% ylabel('功率(dB)' )  ;    %设置 y 轴的标签为 "信号幅值"。
% title('高斯白噪声的三分之一倍频程幅') ;
%     
%书上—_有错误
% 初始设置
clc, clear, close all;

fs = 800; 
N = 8192;%采样点数设置
wn = sqrt(5)*randn(1,N); % 均值为零，方差=N的高斯随机序列 
%wn=@(t) sin(50*2*pi*t) +sin(20*2*pi*t) + randn(size(t));
p0 = 2e-5; % 参考声压
f = [1.00 1.25 1.60 2.00 3.15 4.00 5.00 6.30 8.00]; % 基准中心频率
f1 = [20.00 25.0 31.5 40.0 50.0 63.0 80];
fc = [f, 100*f, 1000*f, 10000*f]; % 合并频率
cf = [-50.5, -44.7, -39.4, -34.6, -30.2, -26.2, -22.5, -19.1, -16.1, -13.4,...
      -10.9, -8.6, -6.6, -48, -3.2, -1.9, -0.8, 0, 0.6, 1.0, 1.2, 1.3,...
      1.2, 1.0, 0.5, -0.1, -1.1, -2.5, -4.3, -6.6, -9.3]; % 20-16000Hz A声级计权值
t1 = 0; t2 = 8;

x = wn(t1*fs+1 : t2*fs); % 截取需要处理的数据段
n = length(x);
t = (0:1/fs:(n-1)/fs);

w = hanning(n); % 汉宁窗
xx = 1.633 * x .* w; % 加汉宁窗（恢复系数为 1.633）

nfft = 2^nextpow2(n); % nextpow2(n) - 取最接近的较大 2 次幂
a = fft(xx, nfft);

%%%%%% 1/3倍频程计算 %%%%%%
oc6 = 2^(1/6);
nc = length(cf); % 基准频率的个数
yc = zeros(1, nc); % 初始化 yc 数组

for j = 1:nc   
    fl = fc(j) / oc6;  % 下限频率   
    fu = fc(j) * oc6;  % 上限频率
    nl = round(fl * nfft / fs + 1);  % 下限频率对应的序号
    nu = round(fu * nfft / fs + 1);  % 上限频率对应的序号
    if fu > fs / 2     % 如果上限频率大于折叠频率则循环中断
        m = j - 1;break
    end
    % 以每个中心频率段为通带进行带通频域滤波 
    b = zeros(1, nfft);
    b(nl:nu) = a(nl:nu);
    b(nfft - nu + 1 : nfft - nl + 1) = a(nfft - nu + 1 : nfft - nl + 1);
    c = ifft(b, nfft);
    % 计算对应每个中心频率段的有效值
    yc(j) = sqrt(var(real(c(1:n))));
end

aj_sumn = 0;
% 修改此处的循环范围，避免超过 yc 的大小
for i = 1:nc  % 使用 nc 作为上限
    Lp1(i) = 20 * log10(yc(i) / p0); % 未计权 1/3 倍频程声压级
end

% 计算总的声压级
for j = 1:nc
    aj_sumn = aj_sumn + 10^(0.1 * Lp1(j));
end

Lp = 10 * log10(aj_sumn); % 总的声压级

% 绘图
figure
bar(Lp1(1:nc), 'k');  % 确保绘制的频率范围和 yc 一致
xlabel('频率 (Hz)');
ylabel('功率 (dB)'); % 设置 y 轴的标签为 "信号幅值"
title('高斯白噪声的三分之一倍频程幅');





