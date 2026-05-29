
figure();
% 自定义x轴为等间距索引值
m=14;
x_values = 1:14;

% 绘制柱状图，设置均匀的x轴
bar(x_values, aaa(:,2), 'BarWidth', 0.8); % 调整柱宽


% 设置x轴的刻度和标签为实际的倍频程中心频率
xticks(x_values);
xticklabels(aaa(:,1));

%xticklabels(arrayfun(@(f) sprintf('%.2f', f), fc(1:m), 'UniformOutput', false));


% 设置x轴标签和y轴标签
xlabel('倍频程中心频率');
ylabel('平均功率');
title('1/3 倍频程频谱图（间断的频率显示）');
grid on;
% 如果需要旋转x轴标签以避免重叠
set(gca, 'XTickLabelRotation', 45);