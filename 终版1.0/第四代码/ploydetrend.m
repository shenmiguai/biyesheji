clear;
close all;
clc;

%% 1. 导入信号
data_dir = 'E:\matlab2021aa\sum_proj\三分之一倍频\新三分之一倍频程_xjm\36波形.xlsx'; %可
Signal = xlsread(data_dir);   % 读Excel文件
%Signal = readmatrix(data_dir);   % 读Excel文件 
t=Signal(:,1);%第一列 %xjm %时间没有减一
sig= Signal(:,2);            % 取第一列时间序列，减1处理
dt = t(2)-t(1);               % 时间间隔（假设是均匀采样）这段代码就是针对等时间间隔的采样。
fs = 1/dt;  %fs=8192 奈奎斯特采样频率
x=Signal(:,2);%速度值

%% 2. 去除线性趋势项
[p, s, mu] = polyfit(t,sig, 1);
figure;
subplot(4, 1, 1); plot(t,sig); title('原始信号');grid on;
subplot(4, 1, 2); plot(t,detrend(sig));grid on; title('去除线性趋势项的原始信号(detrend去除线性趋势项方法)');
subplot(4, 1, 3); plot(t,polyval(p,t)); grid on;title('去除线性趋势项后信号(polyfit拟合线性方法)');
subplot(4, 1, 4); plot(t,detrend(sig)); grid on;title('线性趋势项');

%% 去除3次趋势项
[y3, xtrend3] = polydetrend(sig, fs, 2);
figure;
subplot(3, 1, 1); plot(t,sig); title('原始信号');grid on;
subplot(3, 1, 2); plot(t,y3); title('去除非线性趋势项后信号(polyfit拟合非线性方法)');grid on;
subplot(3, 1, 3); plot(t,xtrend3); title('非线性趋势项'); grid on;
