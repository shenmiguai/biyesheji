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
fc= [1 1.25 1.6 2 2.5 3.15 4 5 6.3 8 10 12.5 16 20 25 31.5 40 50 63 80 100 125 160 200 250 315 400 500 630 800 1000 1250 1600 2000 2500 3150 4000 5000 6300 8000 10000 12500 16000 20000 25000 31500 40000 50000 63000 80000 100000 125000 160000 200000];
%xjm  % fc=1~20khz  %fc(54x1)

oc6=2^(1/6);%中心频率与下限频率的比值 %oc6=1.1225
nc=length(fc);%取中心频率总的长度  %nc=54
n=length(x);%输入数据的长度 %n=2048
nfft=2^nextpow2(n);%大于并接近n的2的幂次方长度  %2048
a=fft(x,nfft);%FFT变换  a=(2048x1) % a复数
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
    b=zeros(1,nfft);
    b(nl:nu)=a(nl:nu);
    b(nfft-nu+1:nfft-nl+1)=a(nfft-nu+1:nfft-nl+1);%以每个中心频率段为通带进行带通频域滤波
    c=ifft(b,nfft);%c是复数  
    yc(j)=sqrt(var(real(c(1:n)))); %该公式认为信号c是零均值的  %yc=RMS %每个中心频率段的RMS 	%计算对应每个中心频率段的有效值%注意，matlab函数var和std认为操作数是度量总体的一个样本，所以使用的公式是实际值与期望值之差的平方和再除以（N-1）
end

%---------------------------绘制功率谱-------------------------------
fs_fft=44100; %40k soundfs=44100
ff=linspace(0,fs_fft/2,ceil(n/2));%ff=ff'; %x轴
% ff=linspace(0,fs/2,ceil(n/2));
Amplitude=2*abs(a)/nfft; %a=fft(x,nfft);%Amplitude_x是取模，归一化，的线性尺度的幅度谱
Amplitude(1)=Amplitude(1)/n;%Amplitude(1)直流分量在单边谱分析中的处理方式和其他频率分量不同。
Power=Amplitude.*Amplitude;
Power=20*log10(Power);%dB单位的“功率谱”

figure
subplot 311
plot(log10(ff),Power(1:ceil(n/2)),'b-','LineWidth',0.3);
grid minor;
xlabel('log10(ff)');
ylabel('db(功率谱)');
title('信号的功率谱');
%set(gca,'Fontname','宋体','Fontsize',12);
set(gcf,'Position',[150,260,800,500]);
%-----------------------------绘制信号实频---------------------------------
r=real(a);
subplot 312
plot(log10(ff),r(1:ceil(n/2)),'b-','LineWidth',0.3);
grid on;
xlabel('log10(ff)');
ylabel('实频');
title('信号实频');
% set(gca,'Fontname','宋体','Fontsize',12);
% set(gcf,'Position',[150,260,800,500]);

%-----------------------------绘制信号虚频---------------------------------
% figure
i=imag(a);
subplot 313
plot(log10(ff),i(1:ceil(n/2)),'b-','LineWidth',0.3);
grid on;
xlabel('log10(ff)');
ylabel('虚频');
title('信号虚频');

%-----------------------------绘制bar_RMS值---------------------------------
figure  
bar(yc(1:m));
grid on
xlabel('三分之一倍频中心频率序号');
ylabel('RMS值');
title('有效值RMS');
set(gca,'Fontname','宋体','Fontsize',12);
set(gcf,'Position',[150,250,800,500]);

%--------------三分之一倍频每一中心频率的RMS值------------------------
figure 
bar(fc(1:m),yc(1:m)); 
grid minor;
%grid on;
xlabel('三分之一倍频中心频率(Hz)');
ylabel('每一频段的RMS值');
set(gca,'xscale','log','xtick',fc(1:m),'Fontname','宋体','Fontsize',12);
set(gcf,'Position',[800,120,800,500]);
title('1/3倍频每一中心频率的RMS值');



%%                                                                                                                                                                                                      
%-----------------------绘制输入时域曲线图形-----------------------------
figure 
t=0:1/fs:(n-1)/fs;
plot(t,x);
xlabel('时间(s)');
ylabel('加速度(m/s^2)');
set(gca,'Fontname','宋体','Fontsize',12);
set(gcf,'Position',[350,250,800,500]);
grid on;
title('输入时域曲线图形');

%-------------------------------------绘制A声级-------------------------------------------------------------------
yc=10*log10(yc/1e-10); %yc=(1x60) 
%yc = 20 * log10(yc / (20e-5)); %严格标准写法  
%yc = 20 * log10(yc /1 * 10^(-6));  % 参考加速度（通常是1微米/秒??）

%xjm
%A声级修正
cf1=zeros(1,m);%m=36
cf1(1,11:41)=[-70.4,-63.4,-56.7,-50.5,-44.7,-39.4,-34.6,-30.2,-26.2,-22.5,-19.1,-16.1,-13.4,-10.9,-8.6,...
    -6.6,-4.8,-3.2,-1.9,-0.8,0,0.6,1.0,1.2,1.3,1.2,1.0,0.5,-0.1,-1.1,-2.5];%20~20khz
yc1=yc(1:m)+cf1(1:m);%10~20khz  %10零对应0~8hz

figure 
plot(fc(14:m),yc1(14:m),'r-s','LineWidth',1.5);          %从20Hz开始画，因此取14。20hz是第十四个频率
xlabel('频率(Hz)');
ylabel('A声级(dB)');
grid on;
set(gca,'xscale','log','xtick',fc,'XLim',[20 20000],'Fontname','宋体','Fontsize',12);
set(gcf,'Position',[250,200,800,500]);
sa=yc(1,14:44);
%save('006.txt','sa','-ascii' );%保存到文件种不需要
title('绘制A声级');


%----------------------绘制A声级的柱状图(可不画，形式不同罢了)------------------------
% figure ;%绘制bar
% bar(fc(14:m),yc(14:m)); % 调整柱宽
% grid on;
% xlabel('频率(Hz)');
% ylabel('A声级(dB)');
% set(gca,'xscale','log','xtick',fc,'XLim',[20 20000],'YLim',[0 120],'Fontname','宋体','Fontsize',12);
% set(gcf,'Position',[250,100,800,500]);
% title('A声级柱状图');

%title设置

%----------------------绘制A声级的柱状图(可不画，形式不同罢了)------------------------

