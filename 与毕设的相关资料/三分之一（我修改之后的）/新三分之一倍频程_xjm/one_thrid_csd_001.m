%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 三分之一倍频程处理
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear              % Remove items from workspace, freeing up system memory
clc                % Clear Command Window
clf                % Clear current figure window
close all hidden   % removal draws only those lines that are not obscured
                   % by other objects in the field of view.
format long %设置数值输出格式为长格式，即显示更多的小数位数
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 加载数据
fun = @(t) sin(50*2*pi*t) +sin(20*2*pi*t) + randn(size(t));
fs = 300;                       % 采样频率
n = 1000;                      % 数据长度
t = 0:1/fs:(n-1)/fs;            % 建立离散时间列向量
x = fun(t);                     % 产生时间序列数据

% 定义三分之一倍频程的中心频率
f = [1.00 1.25 1.60 2.00 2.50 3.15 4.00 5.00 6.300 8.00];
fc = [f,10*f,100*f,1000*f,10000*f];
oc6 = 2^(1/6);        % 中心频率与下限频率的比值
nc = length(fc);      % 取中心频率总的长度     
nfft = 2^nextpow2(n); % 大于并最接近n的2的幂次方长度
a = fft(x,nfft);      % FFT变换
yc = zeros(1,nc);  %中心频率段的有效值
for j = 1:nc   
      fl = fc(j)/oc6;  % 下限频率   
      fu = fc(j)*oc6;      % 上限频率
      nl = round(fl*nfft/fs+1);  % 下限频率对应的序号
      nu = round(fu*nfft/fs+1);  % 上限频率对应的序号
      if fu > fs/2     % 如果上限频率大于折叠频率则循环中断
         m = j-1; break
      end
    % 以每个中心频率段为通带进行带通频域滤波 
      b = zeros(1,nfft);
      b(nl:nu) = a(nl:nu);
      b(nfft-nu+1:nfft-nl+1) = a(nfft-nu+1:nfft-nl+1);
      c = ifft(b,nfft);
    %计算对应每个中心频率段的有效值
      yc(j) = sqrt(var(real(b(1:n))));
end
%绘制输入时程曲线图形
subplot(2,1,1);plot(t,x);
xlabel('时间　(s)');ylabel('加速度 (g)');grid on;                     
%绘制三分之一倍频程有效值图形
subplot(2,1,2); plot(fc(1:m),yc(1:m));
xlabel('频率 (Hz)');ylabel('有效值'); grid on;