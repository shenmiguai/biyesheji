function [y, xtrend] = polydetrend(x, fs, order)
% x: 带有趋势项的信号
% fs: 信号采样频率
% order: 最小二乘法拟合多项式阶数
x = x(:); % 转为列向量
N = length(x);
t = (0:N-1)' / fs;
a = polyfit(t, x, order); % 用最小二乘法拟合x的多项式系数a
xtrend = polyval(a, t); % 构成趋势项
y = x - xtrend; % 去除趋势项
end 