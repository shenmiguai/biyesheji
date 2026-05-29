% clear
% clc
% close all
% %----------调用外部文件----------%
% data_dir = 'E:\matlab2021aa\sum_proj\三分之一倍频\新三分之一倍频程_xjm\36波形.xlsx'; %可
% data= xlsread(data_dir);   % 读Excel文件
% time = data(:,1);  % 时间数据
% speed = data(:,2); % 速度数据
% Fs = 1000; % 采样频率（请根据实际情况调整）
% 
% % 2. 计算短时傅里叶变换（STFT）
% window = 256;  % 设置窗函数大小
% noverlap = 128; % 设置重叠样本点数
% nfft = 512;  % 设置 FFT 计算点数
% 
% [S,F,T] = spectrogram(speed, window, noverlap, nfft, Fs); 
% 
% % 3. 绘制瀑布图
% figure;
% waterfall(T, F, abs(S)');
% xlabel('时间 (s)');
% ylabel('频率 (Hz)');
% zlabel('幅值');
% title('振动信号瀑布图');

% %% 示例：生成一个足够长的信号（1秒钟的 100Hz 正弦波）
% fs = 44100;
% t = 0:1/fs:1-1/fs;
% sig = sin(2*pi*100*t); % 确保信号足够长！
% 
% % 窗口参数
% window = 2048;
% noverlap = 1024;
% nfft = 2048;
% 
% % 计算谱图
% [S,F,T] = spectrogram(sig, window, noverlap, nfft, fs);
% 
% % 检查输出维度
% disp(size(S)); % 应该是 [1025, N]，N>1
% disp(length(F)); % 应该是 1025
% disp(length(T)); % 应该是 N，N>1
% 
% % 取 dB 幅度谱并绘图
% P = 20*log10(abs(S)); % P 是 1025xN
% surf(F, T, P.', 'EdgeColor', 'none'); % 注意转置
% axis tight;
% view(0, 90);
% xlabel('Frequency (Hz)');
% ylabel('Time (s)');
% title('Spectrogram');
% colorbar;

%% 生成一个示例信号（你也可以替换成你自己的信号 y）
Fs = 1000;                  % 采样频率 1000 Hz
t = 0:1/Fs:10;              % 时间 0~10 秒
y = chirp(t, 100, 10, 200); % 线性扫频信号，100Hz -> 200Hz，持续10秒

% 计算短时傅里叶变换
window = 256;            % 每一帧的窗口长度
noverlap = 200;          % 帧之间的重叠长度
nfft = 1024;             % FFT 点数
[S,F,T] = spectrogram(y, window, noverlap, nfft, Fs);

% 绘制 3D 时频图
figure;
mesh(T, F, abs(S));      % 绘制3D网格图
axis tight;
xlabel('Time (s)');ylabel('Frequency (Hz)');zlabel('Magnitude');
title('3D 时频图（Spectrogram）');
view(45, 60);             % 设定3D视角角度
colormap turbo;          % 配色



