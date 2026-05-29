%% //Standard Procedure
%% //作者：大萌             
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
set(gca,'LooseInset',get(gca,'TightInset')+[BiaValue,0,0,0],'FontName','Times New Roman','FontSize',font_size);
plot(t, y, 'b-', 'LineWidth', line_width)
set(gca,'FontSize',font_size,'FontName','Times New Roman')
xlim([0 1])
ylim([-6 6])
set(gca,'XTick',0:0.25:1)
set(gca,'YTick',-6:3:6)
xlabel('时间 (s)', 'FontSize', font_size, 'FontName', 'Times New Roman')
ylabel('信号幅值', 'FontSize', font_size, 'FontName', 'Times New Roman')
title('原信号波形', 'FontSize', font_size*1.5, 'FontName', 'Times New Roman')
 
%% //绘制理想信号波形 
t = 0:0.0001:10;
y = 3*sin(2*pi*10*t);

figure
set(gcf,'Unit','centimeters','Position',[3 3 3+figure_width 3+figure_height]);
set(gca,'LooseInset',get(gca,'TightInset')+[BiaValue,0,0,0],'FontName','Times New Roman','FontSize',font_size);
plot(t, y, 'b-', 'LineWidth', line_width)
set(gca,'FontSize',font_size,'FontName','Times New Roman')
xlim([0 1])
ylim([-4 4])
set(gca,'XTick',0:0.25:1)
set(gca,'YTick',-4:2:4)
xlabel('时间 (s)', 'FontSize', font_size, 'FontName', 'Times New Roman')
ylabel('信号幅值', 'FontSize', font_size, 'FontName', 'Times New Roman')
title('理想信号波形', 'FontSize', font_size*1.5, 'FontName', 'Times New Roman')
 
%% //采样，采样频率：100Hz，采样时长：1s
t = 0:0.01:1;
y = 3*sin(2*pi*10*t) + sin(2*pi*40*t) + sin(2*pi*200*t);
 
figure
set(gcf,'Unit','centimeters','Position',[3 3 3+figure_width 3+figure_height]);
set(gca,'LooseInset',get(gca,'TightInset')+[BiaValue,0,0,0],'FontName','Times New Roman','FontSize',font_size);
plot(t, y, 'b-', 'LineWidth', line_width)
set(gca,'FontSize',font_size,'FontName','Times New Roman')
xlim([0 1])
ylim([-6 6])
set(gca,'XTick',0:0.25:1)
set(gca,'YTick',-6:3:6)
xlabel('时间 (s)', 'FontSize', font_size, 'FontName', 'Times New Roman')
ylabel('信号幅值', 'FontSize', font_size, 'FontName', 'Times New Roman')
title('原信号采样后的波形', 'FontSize', font_size*1.5, 'FontName', 'Times New Roman')
 
 %% //信号分析
% % 数据长度
% datalength = length(y);
% % 对数据进行FFT
% yFFT = fft(y, datalength);
% mag = abs(yFFT);
% % 幅值归一化
% mag = mag*2/datalength;
% pha = angle(yFFT)*180/pi;
% % 对无效相位进行置0
% for i = 1:datalength
%     if (mag(1,i)<0.3)
%         pha(1,i) = 0;
%     end
% end
% % 序列坐标
% n = 0:datalength-1;
% % 采样频率
% fs = 1/0.01;
% % 序列频率
% f = (0:datalength-1)*fs/datalength;
%  
% figure
% set(gcf,'Unit','centimeters','Position',[3 3 3+figure_width 3+figure_height]);
% set(gca,'LooseInset',get(gca,'TightInset')+[BiaValue,0,0,0],'FontName','Times New Roman','FontSize',font_size);
% stem(f(1:datalength/2), mag(1:datalength/2), 'b-', 'LineWidth', line_width)
% set(gca,'FontSize',font_size,'FontName','Times New Roman')
% xlim([0 50])
% ylim([0 4])
% set(gca,'XTick',0:10:50)
% set(gca,'YTick',0:1:4)
% xlabel('频率 (Hz)', 'FontSize', font_size, 'FontName', 'Times New Roman')
% ylabel('幅值', 'FontSize', font_size, 'FontName', 'Times New Roman')
% title('采样信号的频域分析', 'FontSize', font_size*1.5, 'FontName', 'Times New Roman')
%  
% figure
% set(gcf,'Unit','centimeters','Position',[3 3 3+figure_width 3+figure_height]);
% set(gca,'LooseInset',get(gca,'TightInset')+[BiaValue,0,0,0],'FontName','Times New Roman','FontSize',font_size);
% stem(f(1:datalength/2), pha(1:datalength/2), 'b-', 'LineWidth', line_width)
% set(gca,'FontSize',font_size,'FontName','Times New Roman')
% xlim([0 50])
% ylim([-100 200])
% set(gca,'XTick',0:10:50)
% set(gca,'YTick',-100:100:200)
% xlabel('频率 (Hz)', 'FontSize', font_size, 'FontName', 'Times New Roman')
% ylabel('相位 (deg)', 'FontSize', font_size, 'FontName', 'Times New Roman')
% title('采样信号的频域分析', 'FontSize', font_size*1.5, 'FontName', 'Times New Roman')
 
 %% //滤波器低通滤波
filtercoe = [0.0282,  0.0188,  -0.0095, -0.0477, -0.0527, 0.0122,... 
             0.1386,  0.2661,  0.3197,  0.2661,  0.1386,  0.0122,... 
             -0.0527, -0.0477, -0.0095, 0.0188,  0.0282];
% load('filter_e3.mat')

y_Filter = filter(filtercoe, 1, y);
%1为滤波器的分母系数，表示这是一个FIR滤波器（有限冲激响应滤波器
 
% 绘制滤波后的信号
figure
set(gcf,'Unit','centimeters','Position',[3 3 3+figure_width 3+figure_height]);
set(gca,'LooseInset',get(gca,'TightInset')+[BiaValue,0,0,0],'FontName','Times New Roman','FontSize',font_size);
plot(t, y_Filter, 'b-', 'LineWidth', line_width)
set(gca,'FontSize',font_size,'FontName','Times New Roman')
xlim([0 1])
ylim([-6 6])
set(gca,'XTick',0:0.25:1)
set(gca,'YTick',-6:3:6)
xlabel('时间 (s)', 'FontSize', font_size, 'FontName', 'Times New Roman')
ylabel('信号幅值', 'FontSize', font_size, 'FontName', 'Times New Roman')
title('滤波后的信号', 'FontSize', font_size*1.5, 'FontName', 'Times New Roman')