%---------------------------------------------------------
clear;
clc;close all;
%data_dir = './36波形.xlsx'; %可
data_dir = 'E:\matlab2021aa\sum_proj\三分之一倍频\新三分之一倍频程_xjm\36波形.xlsx'; %可
Signal = xlsread(data_dir);   % 读Excel文件
%Signal = readmatrix(data_dir);   % 读Excel文件 
p=Signal(:,1);%第一列 %xjm %时间没有减一
t = Signal(:,1)-1;            % 取第一列时间序列，减1处理
dt = t(2)-t(1);               % 时间间隔（假设是均匀采样）这段代码就是针对等时间间隔的采样。
fs = 1/dt;  %fs=8192 奈奎斯特采样频率
x=Signal(:,2);%速度值
%fc=[1.0000 1.2599 1.5874 1.9952 2.5119 3.1623 3.9811 5.0119 6.3096 7.9433 10.0000 12.5893 15.8489 19.9526 25.1189 31.6228 39.8107 50.1187 63.0957 79.4328 100.0000 125.8925 158.4893 199.5262 251.1886 316.2278 398.1072 501.1872 630.9573 794.3282 1000.0000 1258.9254 1584.8932 1995.2623 2511.8864 3162.2777 3981.0717 5011.8723 6309.5734 7943.2823 10000.0000 12589.2541 15848.9319 19952.6231];
fc= [1 1.25 1.6 2 2.5 3.15 4 5 6.3 8 10 12.5 16 20 25 31.5 40 50 63 80 100 125 160 200 250 315 400 500 630 800 1000 1250 1600 2000 2500 3150 4000 5000 6300 8000 10000 12500 16000 20000 25000 31500 40000 50000 63000 80000 100000 125000 160000 200000];
%xjm  % fc=1~20khz  %fc(54x1)

oc6=2^(1/6);%中心频率与下限频率的比值 %oc6=1.1225
nc=length(fc);%取中心频率总的长度  %nc=54
n=length(x);%输入数据的长度 %n=2048
nfft=2^nextpow2(n);%大于并接近n的2的幂次方长度  %2048
a=fft(x,nfft);%FFT变换  a=(2048x1) % a复数



%% -------------------------------频谱细化------------------------------
% disp(fc(1));
% disp(fc(44));
% f1=fc(1);
% f2=fc(44);
% M = 1000; % 细化倍数
% w = exp(-1j * 2 * pi * (f2 - f1) / (fs * M));%M是频谱细化的倍数，也就是CZT计算得到的频谱点数
% h = exp(1j * 2 * pi * f1 / fs);
% xihua= czt(x, M, w, h);%(1000x1) %x是时域信号 M是细化倍数 w是参数1 a是参数2
% h = 0:1:M-1;
% f0 = (f2 - f1) / M * h + f1;%f1是细化起始范围
% figure
% plot(f0, 2 * abs(xihua) / n);%f0=(1x1000)
% xlabel('f');
% ylabel('value');
% title('CZT频谱细化后');

% %----------------------------------fft------------------------------------
% figure%普通fft图
% tt= fs * (0:nfft/2-1) / nfft; % 时间% n1=(1x1024)
% plot(tt, 2 * abs(a(1:(n/2)))/n);%信号的频谱
%%
yc = zeros(1,nc);
for j=1:nc %nc=44
    fl=fc(j)/oc6; 
    fu=fc(j)*oc6;  %fc=20khz对应fl=224480hz
    nl=round(fl*nfft/fs+1); %下限频率对应的序号
    nu=round(fu*nfft/fs+1);%上限频率对应的序号  
    if fu>fs/2 %如果上限频率大于半谱频率则循环中断
        m=j-1; disp(m);
        break  %判断有效的频率，当一旦出现频率值超过fs/2时，立即停止后边数据的检查，因为出现了f太大的信号，不符合奈奎斯特定律     
    end
    disp(j);     
    b=zeros(1,nfft);%1x2048
    b(nl:nu)=a(nl:nu);
    b(nfft-nu+1:nfft-nl+1)=a(nfft-nu+1:nfft-nl+1);%以每个中心频率段为通带进行带通频域滤波
    c=ifft(b,nfft);%c是复数  
    yc(j)=sqrt(var(real(c(1:n)))); %该公式认为信号c是零均值的  %yc=RMS %每个中心频率段的RMS 	%计算对应每个中心频率段的有效值%注意，matlab函数var和std认为操作数是度量总体的一个样本，所以使用的公式是实际值与期望值之差的平方和再除以（N-1）
end

%%
%% ------------------绘制输入时域曲线图形---------图一------------------------
% figure 
% t=0:1/fs:(n-1)/fs;
% plot(t,x);
% xlabel('时间(s)');
% ylabel('加速度(m/s^2)');
% set(gca,'Fontname','宋体','Fontsize',12);
% set(gcf,'Position',[350,250,800,500]);
% grid on;
% title('输入时域曲线图形');



t=0:1/fs:(n-1)/fs;
set(groot, 'ScreenPixelsPerInch', 300);% 设置图像分辨率
plot(t, x,'b-','LineWidth', 1.5); % 增加线条宽度
xlabel('时间(s)', 'FontName', '宋体', 'FontSize', 14); % 增加字体大小
ylabel('加速度(m/s^2)', 'FontName', '宋体', 'FontSize', 14); % 增加字体大小
% ---------------------------模板级别-----------------------------
set(gca, 'FontName', '宋体', 'FontSize', 12);
set(gcf, 'Position', [350, 250, 800, 500]);
grid on;
grid minor; % 显示次要网格线
title('输入时域曲线图形', 'FontName', '宋体', 'FontSize', 16); % 增加标题字体大小

 saveas(gcf, 'saved_figure_1.png');


%-----------------bar(x_values, yc(1:m)); ---图二-----等宽---------------------------------
% figure
% x_values = 1:m;
% bar(x_values, yc(1:m), 'BarWidth', 0.8); % 画柱状图
% 
% xticks(x_values);
% xticklabels(fc(1:m)); % 设置 X 轴为频率标签
% grid minor;
% xlabel('三分之一倍频中心频率(Hz)');
% ylabel('每一频段的RMS值');
% title('1/3倍频每一中心频率的RMS值');

%论文配图
figure
set(groot, 'ScreenPixelsPerInch', 300);% 设置图像分辨率
x_values = 1:m;
bar(x_values, yc(1:m), 'BarWidth', 0.8); % 画柱状图
xticks(x_values);
xticklabels(fc(1:m)); % 设置 X 轴为频率标签
xlabel('三分之一倍频中心频率(Hz)', 'FontName', '宋体', 'FontSize', 14); % 增加字体大小
ylabel('每一频段的RMS值', 'FontName', '宋体', 'FontSize', 14); % 增加字体大小
% -----模板级别-----
set(gca, 'FontName', '宋体', 'FontSize', 12);
set(gcf,'Position',[150,150,800,500]);
grid on;
grid minor; % 显示次要网格线
title('1/3倍频每一中心频率的RMS值', 'FontName', '宋体', 'FontSize', 16); % 标题字体大小
saveas(gcf, 'saved_figure_2.png');

%%%-------------plot一下趋势图-----bar(x_values, yc(1:m));-----图三----连续-------------------
% figure
% x_values = 1:m;
% plot(x_values, yc(1:m)); % 画柱状图
% 
% xticks(x_values);
% xticklabels(fc(1:m)); % 设置 X 轴为频率标签
% 
% grid minor;
% xlabel('三分之一倍频中心频率(Hz)');
% ylabel('每一频段的RMS值');
% title('1/3倍频每一中心频率的RMS趋势图');

%论文配图
figure
set(groot, 'ScreenPixelsPerInch', 300);% 设置图像分辨率
x_values = 1:m;
plot(x_values, yc(1:m),'b-','LineWidth',0.9); % 画柱状图
%bar(x_values, yc(1:m), 'BarWidth', 0.8); % 画柱状图
xticks(x_values);
xticklabels(fc(1:m)); % 设置 X 轴为频率标签
xlabel('三分之一倍频中心频率(Hz)', 'FontName', '宋体', 'FontSize', 14); % 增加字体大小
ylabel('每一频段的RMS值', 'FontName', '宋体', 'FontSize', 14); % 增加字体大小
% -----模板级别-----
set(gca, 'FontName', '宋体', 'FontSize', 12);
set(gcf,'Position',[150,150,800,500]);
grid on;
grid minor; % 显示次要网格线
title('1/3倍频程RMS连续谱', 'FontName', '宋体', 'FontSize', 16); % 增加标题字体大小
 saveas(gcf, 'saved_figure_3.png');                                                                                                                                                                                                    
%% 附加功能
%---------------------------绘制功率谱-------------------------------
%fs_fft=44100; %40k soundfs=44100

%ff=linspace(0,fs_fft/2,ceil(n/2));%ff=ff'; %x轴
ff=linspace(0,fs/2,ceil(n/2));
Amplitude=2*abs(a)/nfft; %a=fft(x,nfft);%Amplitude_x是取模，归一化，的线性尺度的幅度谱
Amplitude(1)=Amplitude(1)/n;%Amplitude(1)直流分量在单边谱分析中的处理方式和其他频率分量不同。
Power=Amplitude.*Amplitude;
Power=20*log10(Power);%dB单位的“功率谱”

% figure
% %subplot 311
% plot(log10(ff),Power(1:ceil(n/2)),'b-','LineWidth',0.8);
% grid minor;
% xlabel('log10(ff)');
% ylabel('db(功率谱)');
% title('信号的功率谱');
% %set(gca,'Fontname','宋体','Fontsize',12);
% set(gcf,'Position',[150,260,800,500]);

%论文配图
figure
set(groot, 'ScreenPixelsPerInch', 300);% 设置图像分辨率
plot(log10(ff),Power(1:ceil(n/2)),'b-','LineWidth',0.8);
xlabel('log10(ff)', 'FontName', '宋体', 'FontSize', 14); % 增加字体大小
ylabel('db(功率谱)', 'FontName', '宋体', 'FontSize', 14); % 增加字体大小
% -------模板级别--------
set(gca, 'FontName', '宋体', 'FontSize', 12);
set(gcf,'Position',[150,150,800,500]);
grid on;
grid minor; % 显示次要网格线
title('信号的功率谱', 'FontName', '宋体', 'FontSize', 16); % 增加标题字体大小
saveas(gcf, 'saved_figure_4.png');

%-----------------------------------绘制信号幅频---------------------------------
%论文配图
figure
set(groot, 'ScreenPixelsPerInch', 300);% 设置图像分辨率
plot(log10(ff),Amplitude(1:ceil(n/2)),'b-','LineWidth',0.8);
xlabel('log10(ff)', 'FontName', '宋体', 'FontSize', 14); % 增加字体大小
ylabel('幅度', 'FontName', '宋体', 'FontSize', 14); % 增加字体大小
% -----模板级别-----
set(gca, 'FontName', '宋体', 'FontSize', 12);
set(gcf,'Position',[150,150,800,500]);
grid on;
grid minor; % 显示次要网格线
title('信号幅频', 'FontName', '宋体', 'FontSize', 16); % 增加标题字体大小
saveas(gcf, 'saved_figure_5.png');
%-----------------------------------绘制信号实频---------------------------------
% r=real(a);
% figure
% %subplot 312
% plot(log10(ff),r(1:ceil(n/2)),'b-','LineWidth',0.3);
% grid on;
% xlabel('log10(ff)');
% ylabel('实频');
% title('信号实频');
% set(gca,'Fontname','宋体','Fontsize',12);
% set(gcf,'Position',[150,260,800,500]);

%论文配图
figure
r=real(a);
set(groot, 'ScreenPixelsPerInch', 300);% 设置图像分辨率
plot(log10(ff),r(1:ceil(n/2)),'b-','LineWidth',0.8);
xlabel('log10(ff)', 'FontName', '宋体', 'FontSize', 14); % 增加字体大小
ylabel('实频', 'FontName', '宋体', 'FontSize', 14); % 增加字体大小
% -----模板级别------
set(gca, 'FontName', '宋体', 'FontSize', 12);
set(gcf,'Position',[150,150,800,500]);
grid on;
grid minor; % 显示次要网格线
title('信号实频', 'FontName', '宋体', 'FontSize', 16); % 增加标题字体大小
saveas(gcf, 'saved_figure_6.png');


%-----------------------------绘制信号虚频---------------------------------
% figure
% i=imag(a);
% %subplot 313
% plot(log10(ff),i(1:ceil(n/2)),'b-','LineWidth',0.3);
% grid on;
% xlabel('log10(ff)');
% ylabel('虚频');
% title('信号虚频');

%论文配图
figure
i=imag(a);
set(groot, 'ScreenPixelsPerInch', 300);% 设置图像分辨率
plot(log10(ff),i(1:ceil(n/2)),'b-','LineWidth',0.8);
xlabel('log10(ff)', 'FontName', '宋体', 'FontSize', 14); % 增加字体大小
ylabel('虚频', 'FontName', '宋体', 'FontSize', 14); % 增加字体大小
% -----模板级别------
set(gca, 'FontName', '宋体', 'FontSize', 12);
set(gcf,'Position',[150,150,800,500]);
grid on;
grid minor; % 显示次要网格线
title('信号虚频', 'FontName', '宋体', 'FontSize', 16); % 增加标题字体大小
saveas(gcf, 'saved_figure_7.png');

%----------------------------------绘制信号相频----------------------------------
%论文配图
ph = angle(a)*180/pi;
figure
set(groot, 'ScreenPixelsPerInch', 300);% 设置图像分辨率
plot(log10(ff),ph(1:ceil(n/2)),'b-','LineWidth',0.7);
xlabel('log10(ff)', 'FontName', '宋体', 'FontSize', 14); % 增加字体大小
ylabel('相位', 'FontName', '宋体', 'FontSize', 14); % 增加字体大小
% -----模板级别-----
set(gca, 'FontName', '宋体', 'FontSize', 12);
set(gcf,'Position',[150,150,800,500]);
grid on;
grid minor; % 显示次要网格线
title('信号相频', 'FontName', '宋体', 'FontSize', 16); % 增加标题字体大小
saveas(gcf, 'saved_figure_8.png');
%% ---------------------------------各种图-------------------------------------------------------------------
% -------------------------------------绘制A声级-------------------------------------------------------------------
% yc=10*log10(yc/1e-10); %yc=(1x60) 
% %yc = 20 * log10(yc / (20e-5)); %严格标准写法  
% %yc = 20 * log10(yc /1 * 10^(-6));  % 参考加速度（通常是1微米/秒??）
% 
% %xjm
% %A声级修正
% cf1=zeros(1,m);%m=36
% cf1(1,11:41)=[-70.4,-63.4,-56.7,-50.5,-44.7,-39.4,-34.6,-30.2,-26.2,-22.5,-19.1,-16.1,-13.4,-10.9,-8.6,...
%     -6.6,-4.8,-3.2,-1.9,-0.8,0,0.6,1.0,1.2,1.3,1.2,1.0,0.5,-0.1,-1.1,-2.5];%20~20khz
% yc1=yc(1:m)+cf1(1:m);%10~20khz  %10零对应0~8hz
% 
% figure 
% plot(fc(14:m),yc1(14:m),'r-s','LineWidth',1.5);          %从20Hz开始画，因此取14。20hz是第十四个频率
% xlabel('频率(Hz)');
% ylabel('A声级(dB)');
% grid on;
% set(gca,'xscale','log','xtick',fc,'XLim',[20 20000],'Fontname','宋体','Fontsize',12);
% set(gcf,'Position',[250,200,800,500]);
% sa=yc(1,14:44);
% %save('006.txt','sa','-ascii' );%保存到文件种不需要
% title('绘制A声级');


%%--------------------------------绘制A声级的柱状图(可不画，形式不同罢了)------------------------
% figure ;%绘制bar
% bar(fc(14:m),yc(14:m)); % 调整柱宽
% grid on;
% xlabel('频率(Hz)');
% ylabel('A声级(dB)');
% set(gca,'xscale','log','xtick',fc,'XLim',[20 20000],'YLim',[0 120],'Fontname','宋体','Fontsize',12);
% set(gcf,'Position',[250,100,800,500]);
% title('A声级柱状图');

%title设置


% %-------------------------------三分之一倍频程----宽度是-----width = fu - fl----------------------------------------
% 
% figure;
% hold on;
% for j = 1:m
%     fl = fc(j)/oc6; % 下限频率
%     fu = fc(j)*oc6; % 上限频率
%     width = fu - fl;
%    rectangle('Position', [fc(j)-width/2, 0, width, yc(j)], ...
%         'FaceColor', [0.2 0.5 0.8], ...
%       'EdgeColor', 'k');
% end
% set(gca, 'XScale', 'log'); % 对数坐标
% 
% % 添加中心频率刻度和标签
% set(gca, 'xtick', fc(1:m)); % 在每个中心频率上打刻度
% xticklabels(string(fc(1:m))); % 使用频率值作为标签（转为字符串）
% xtickangle(45); % 可选：旋转角度避免重叠
% 
% xlabel('中心频率 fc (Hz)', 'FontName','宋体','FontSize',12);
% ylabel('每一频段的 RMS 值', 'FontName','宋体','FontSize',12);
% title('1/3 - 倍频程频谱', 'FontName','宋体','FontSize',14);
% grid on;
% set(gcf,'Position',[800,120,800,500]);


%--------------------log对数坐标-----------柱不等宽--------1/3倍频程中心频率的RMS值---------bar(fc(1:m),yc(1:m));------------------------
% figure 
% bar(fc(1:m),yc(1:m));
% grid minor;
% %grid on;
% xlabel('中心频率fc(Hz)');
% ylabel('每一频段的RMS值');
% set(gca,'xscale','log','xtick',fc(1:m),'Fontname','宋体','Fontsize',12);
% set(gcf,'Position',[800,120,800,500]);
% title('1/3倍频每一中心频率的RMS值');

%论文配图
figure
set(groot, 'ScreenPixelsPerInch', 300);% 设置图像分辨率
bar(fc(1:m),yc(1:m),'barwidth',0.8);
% plot(log10(ff),Amplitude(1:ceil(n/2)),'b-','LineWidth',0.8);
xlabel('log10(fc)', 'FontName', '宋体', 'FontSize', 14); % 增加字体大小
ylabel('RMS值', 'FontName', '宋体', 'FontSize', 14); % 增加字体大小
% -----模板级别-----
set(gca, 'FontName', '宋体', 'FontSize', 12);
set(gcf,'Position',[150,150,800,500]);
grid on;
grid minor; % 显示次要网格线
title('对数坐标系的1/3倍频程谱', 'FontName', '宋体', 'FontSize', 16); % 增加标题字体大小


% %------------------中心频率序号-------绘制bar_RMS值--------图二-------------------------
% figure  
% bar(yc(1:m));
% grid on
% xlabel('三分之一倍频中心频率序号');
% ylabel('RMS值');
% title('三分之一倍频中心频率序号 有效值RMS');
% set(gca,'Fontname','宋体','Fontsize',12);
% set(gcf,'Position',[150,250,800,500]);
