%% //比较规范的数字信号处理过程
%% //作者：大萌_xjm             
%% //日期：2025年4月15日 
 
%% 初始设置
% 清空工作空间，关闭无关页面
clc,clear,close all;
 
% 绘图变量
font_size = 12;     axis_size = 10;       line_width = 2;    legend_size = 10.5; 
figure_width = 14;  figure_height = 8;    BiaValue = 0;      marker_size = 12;
 
%% //原信号 
%  //y = 3*sin(2*pi*10*t) + sin(2*pi*40*t) + sin(2*pi*200*t);
 
%% //绘制原信号波形
t = 0:0.0001:10;
y = 3*sin(2*pi*10*t) + sin(2*pi*40*t) + sin(2*pi*200*t);
 
figure 
set(gcf,'Unit','centimeters','Position',[3 3 3+figure_width 3+figure_height]);
set(gca,'LooseInset',get(gca,'TightInset')+[BiaValue,0,0,0],'FontName','<宋体>','FontSize',font_size);%设置当前坐标轴的属性
plot(t, y, 'b-', 'LineWidth', line_width)
set(gca,'FontSize',font_size,'FontName','<宋体>')

xlim([0 1])%设置 x 轴的范围从 0 到 1 秒。
ylim([-6 6])%设置 y 轴的范围从 -6 到 6。
set(gca,'XTick',0:0.25:1)%设置 x 轴的刻度，表示从 0 到 1 秒，每 0.25 秒一个刻度。
set(gca,'YTick',-6:3:6)%设置 y 轴的刻度，从 -6 到 6，每隔 3 一个刻度。

xlabel('时间 (s)', 'FontSize', font_size, 'FontName', '<宋体>')      %设置 x 轴的标签为 "时间 (s)"
ylabel('信号幅值', 'FontSize', font_size, 'FontName', '<宋体>')      %设置 y 轴的标签为 "信号幅值"。
title('原信号波形', 'FontSize', font_size*1.5, 'FontName', '<宋体>') %设置字体大小和字体类型。

%% //绘制理想信号波形 
% t = 0:0.0001:10;
% y = 3*sin(2*pi*10*t);
%  
% figure 
% set(gcf,'Unit','centimeters','Position',[3 3 3+figure_width 3+figure_height]);
% set(gca,'LooseInset',get(gca,'TightInset')+[BiaValue,0,0,0],'FontName','<宋体>','FontSize',font_size);
% plot(t, y, 'b-', 'LineWidth', line_width)
% set(gca,'FontSize',font_size,'FontName','<宋体>')
% xlim([0 1])
% ylim([-4 4])
% set(gca,'XTick',0:0.25:1)
% set(gca,'YTick',-4:2:4)
% xlabel('时间 (s)', 'FontSize', font_size, 'FontName', '<宋体>')
% ylabel('信号幅值', 'FontSize', font_size, 'FontName', '<宋体>')
% title('理想信号波形', 'FontSize', font_size*1.5, 'FontName', '<宋体>')
 
%% //采样，采样频率：100Hz，采样时长：1s
t = 0:0.01:1;
y = 3*sin(2*pi*10*t) + sin(2*pi*40*t) + sin(2*pi*200*t);

%绘制采样后的信号 
figure 
set(gcf,'Unit','centimeters','Position',[3 3 3+figure_width 3+figure_height]);
set(gca,'LooseInset',get(gca,'TightInset')+[BiaValue,0,0,0],'FontName','<宋体>','FontSize',font_size);
plot(t, y, 'b-', 'LineWidth', line_width)
set(gca,'FontSize',font_size,'FontName','<宋体>')
xlim([0 1])
ylim([-6 6])
set(gca,'XTick',0:0.25:1)
set(gca,'YTick',-6:3:6)
xlabel('时间 (s)', 'FontSize', font_size, 'FontName', '<宋体>')
ylabel('信号幅值', 'FontSize', font_size, 'FontName', '<宋体>')
title('原信号采样后的波形', 'FontSize', font_size*1.5, 'FontName', '<宋体>')


%% //滤波器低通滤波
% filtercoe = [0.0282,  0.0188,  -0.0095, -0.0477, -0.0527, 0.0122,... 
%              0.1386,  0.2661,  0.3197,  0.2661,  0.1386,  0.0122,... 
%              -0.0527, -0.0477, -0.0095, 0.0188,  0.0282];

load('filter_e3.mat')%导入滤波器的系数，等价于上边的那一系列系数
filtercoe=Num_001;%导入滤波器的系数，等价于上边的那一系列系数

y_Filter = filter(filtercoe, 1, y);
 
% 绘制滤波后的信号
figure
set(gcf,'Unit','centimeters','Position',[3 3 3+figure_width 3+figure_height]);
set(gca,'LooseInset',get(gca,'TightInset')+[BiaValue,0,0,0],'FontName','<宋体>','FontSize',font_size);
plot(t, y_Filter, 'b-', 'LineWidth', line_width)
set(gca,'FontSize',font_size,'FontName','<宋体>')
xlim([0 1])
ylim([-6 6])
set(gca,'XTick',0:0.25:1)
set(gca,'YTick',-6:3:6)
xlabel('时间 (s)', 'FontSize', font_size, 'FontName', '<宋体>')
ylabel('信号幅值', 'FontSize', font_size, 'FontName', '<宋体>')
title('滤波后的信号', 'FontSize', font_size*1.5, 'FontName', '<宋体>')