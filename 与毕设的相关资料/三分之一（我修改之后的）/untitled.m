%%
% figure();
% % 自定义x轴为等间距索引值
% m=14;
% x_values = 1:14;
% 
% % 绘制柱状图，设置均匀的x轴
% bar(x_values, aaa(:,2), 'BarWidth', 0.8); % 调整柱宽
% 
% 
% % 设置x轴的刻度和标签为实际的倍频程中心频率
% xticks(x_values);
% xticklabels(aaa(:,1));
% 
% %xticklabels(arrayfun(@(f) sprintf('%.2f', f), fc(1:m), 'UniformOutput', false));
% 
% 
% % 设置x轴标签和y轴标签
% xlabel('倍频程中心频率');
% ylabel('平均功率');
% title('1/3 倍频程频谱图（间断的频率显示）');
% grid on;
% % 如果需要旋转x轴标签以避免重叠
% set(gca, 'XTickLabelRotation', 45);

%%
clear; clc; close all
% y=[15 20 26 17 29 18; 13 28 24 10 22 11];
% %yerr=[1 0.8 1.2 1.1 0.9 0.85 5 1.1 1.9 1.1 0.9 0.8];
% h1=bar(y,0.65);
% xticklabels({'猫','狗'})


%水平柱状图
% x = [1980 1990 2000];
% y = [10 50 100 200; 42 55 50 48; 30 20 44 40];
% barh(x,y)
% xlabel('Snowfall')
% ylabel('Year')
% legend({'Springfield','Fairview','Bristol','Jamesville'})

% figure  %改变所有柱子的颜色
% b = bar(1:10);
% b.FaceColor = [0.6 0.5 0.2]; %调整柱状图的RGB颜色

% figure  %
% x = [1 2 3];
% vals = [2 3 6; 11 23 26];
% b = bar(x,vals);
% xtips1 = b(1).XEndPoints;
% ytips1 = b(1).YEndPoints;
% labels1 = string(b(1).YData);
% text(xtips1,ytips1,labels1,'HorizontalAlignment','center',...
%     'VerticalAlignment','bottom')

% figure
% y = [1 2 3; 4 5 6];% 同时画123和456两组柱状图
% bar(y);

% figure 
% %x指定了柱子在 x 轴上的位置，y是一个 2 行 3 列的矩阵，
% %会绘制两组柱子，每组三个，分别位于x所指定的位置。
% x = [1 2 3];
% y = [4 5 6; 7 8 9];
% bar(x, y);


% x = [1 2 3 4];% 定义 x 轴位置
% y = [10 20 15 25; 12 18 22 28];% 定义柱子高度数据
% bar(x, y,0.8);% 绘制柱状图
% title('柱状图示例');% 设置图形标题
% xlabel('类别');% 设置 x 轴标签
% ylabel('数值');% 设置 y 轴标签
% legend('第一组', '第二组');  % 设置图例  


x = [25 31.5 40 50 63 80 100 125 160 200 250 315 400 500 630 800 1000 1250 1600 2000 2500 3150 4000 5000 6300 8000 10000 12500 16000 19997];
y=(1:30);
x1=20*log10(x);
bar(x1, y,1);
