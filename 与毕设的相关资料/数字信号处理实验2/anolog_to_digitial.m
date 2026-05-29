%% //数字信号处理：绘制信号的采样与重建
%% //作者：大萌-xjm              
%% //日期：2025年4月21日
 
%% //初始设置
% 清空工作空间，关闭无关页面
clc,clear,close all;
 
% 绘图变量
font_size = 12; axis_size = 10; line_width = 2; legend_size = 10; marker_size = 12;
figure_width = 10; figure_height = 4; BiaValue = 0;
 
%% //原信号
% x = cos(2*pi*t) + cos(6*pi*t) + cos(10*pi*t)
 
% 原信号时域波形
dt = 0.001;
t  = 0 : dt : 2;
xt = cos(2*pi*t) + cos(6*pi*t) + cos(10*pi*t);
 
% 抽样信号相关参数
% 滤波器截止频率
wc = 20*pi;
% 采样间隔
Ts = 0.05;
% 采样角频率
ws = 2*pi/Ts;
% 抽样信号
t_  = -2 : dt : 2;
ht_ = Ts*wc/pi*sinc(wc/pi*t_);
 
% 采样后信号的波形
% 滤波器时域采样点数
N = 41;
n  = 0 : Ts : Ts*(N-1);
xn = cos(2*pi*n) + cos(6*pi*n) + cos(10*pi*n);
 
% 方法1：采用卷积方法恢复信号
% 对采样后的信号进行内插0，序列长度调整成与原信号一样
xn_Interpolation = zeros(1, length(t));
xn_Interpolation(1, 1:50:end) = xn;
% 卷积
xc_ = conv(xn_Interpolation, ht_);
 
% % 方法2：恢复信号（向量化编程实现：本质还是卷积运算）
% ht = Ts*wc/pi*sinc(wc/pi*t);
% xc = xn*Ts*wc/pi*sinc((wc/pi)*(ones(length(n),1)*t-n'*ones(1,length(t))));
 
%% 
figure 
plot(t,ht)
%% 绘图  原信号-->采样后的信号
figure
set(gcf,'Unit','centimeters','Position',[3 3 3+figure_width 3+figure_height]);
set(gca,'LooseInset',get(gca,'TightInset')+[BiaValue,0,0,0],'FontName','<宋体>','FontSize',font_size);
plot(t, xt, 'r-', 'LineWidth', line_width)
hold on
stem(n, xn, 'LineWidth', line_width)
set(gca,'FontSize',font_size,'FontName','<宋体>')
xlim([0 2])
ylim([-4 4])
title('原信号-->采样后的信号')
set(gca,'XTick',0 : 0.5 : 2)
set(gca,'YTick',-4 : 2 : 4)
xlabel('时间 (s)', 'FontSize', font_size, 'FontName', '<宋体>')
ylabel('信号强度', 'FontSize', font_size, 'FontName', '<宋体>')
legend({'原信号', '采样后的信号'}, 'FontSize', legend_size, 'FontName', '<宋体>', 'Location', 'NorthEast');

 %% 绘图  抽样信号的强度

figure
set(gcf,'Unit','centimeters','Position',[3 3 3+figure_width 3+figure_height]);
set(gca,'LooseInset',get(gca,'TightInset')+[BiaValue,0,0,0],'FontName','<宋体>','FontSize',font_size);
plot(t_, ht_, 'b-', 'LineWidth', line_width)
set(gca,'FontSize',font_size,'FontName','<宋体>')
xlim([-2 2])
ylim([-0.4 1.2])
title('抽样信号的强度')
set(gca,'XTick',-2 : 1 : 2)
set(gca,'YTick',-0.4 : 0.4 : 1.2)
xlabel('时间 (s)', 'FontSize', font_size, 'FontName', '<宋体>')
ylabel('抽样信号的强度', 'FontSize', font_size, 'FontName', '<宋体>')
 
%% 绘图 原信号-->重建的信号
figure
set(gcf,'Unit','centimeters','Position',[3 3 3+figure_width 3+figure_height]);
set(gca,'LooseInset',get(gca,'TightInset')+[BiaValue,0,0,0],'FontName','<宋体>','FontSize',font_size);
plot(t, xt, 'r-', 'LineWidth', line_width)
hold on
plot(t, xc_(1,2001:2000+length(t)), 'b-.', 'LineWidth', line_width)
set(gca,'FontSize',font_size,'FontName','<宋体>')
xlim([0 2])
ylim([-4 4])
title('原信号-->重建的信号')
set(gca,'XTick',0 : 0.5 : 2)
set(gca,'YTick',-4 : 2 : 4)
xlabel('时间 (s)', 'FontSize', font_size, 'FontName', '<宋体>')
ylabel('信号强度', 'FontSize', font_size, 'FontName', '<宋体>')
legend({'原信号', '重建的信号'}, 'FontSize', legend_size, 'FontName', '<宋体>', 'Location', 'NorthEast');
 
%% 绘图 信号误差
figure
set(gcf,'Unit','centimeters','Position',[3 3 3+figure_width 3+figure_height]);
set(gca,'LooseInset',get(gca,'TightInset')+[BiaValue,0,0,0],'FontName','<宋体>','FontSize',font_size);
plot(t, xt - xc_(1,2001:2000+length(t)), 'r-', 'LineWidth', line_width)
set(gca,'FontSize',font_size,'FontName','<宋体>')
xlim([0 2])
ylim([-0.4 0.4])
title('信号误差')
set(gca,'XTick',0 : 0.5 : 2)
set(gca,'YTick',-0.4 : 0.2 : 0.4)
xlabel('时间 (s)', 'FontSize', font_size, 'FontName', '<宋体>')
ylabel('信号误差', 'FontSize', font_size, 'FontName', '<宋体>')