%% 滤波器1 低通  切比雪夫2
%设计切比雪夫2模拟滤波器
%通带截止频率：fp（单位Hz）
%通带衰减：Rp（单位dB）
%阻带截止频率：fs（单位Hz）
%阻带衰减：Rs（单位dB）
 
fp=1900;fs=2200;%低通示例，理想截止频率2000Hz左右
%fp=5100;fs=4800;%高通示例  理想截止频率5000Hz左右
%fp=[1100,1900];fs=[900,2100];%带通示例 理想上限截止频率2000Hz，下限截止频率1000Hz
%fp=[900,2100];fs=[1100,1900];%带阻示例 理想上限截止频率2000Hz，下限截止频率1000Hz
Rp=1;Rs=40; 
fm=12000; %信号频率最大值，单位Hz
filter_type=1;%1:低通，2：高通，3：带通，4：带阻
 
Wp=2*pi*fp;Ws=2*pi*fs;    %转换为模拟角频率，单位rad/s
%滤波器的阶数：N
%衰减3dB时的截止频率：Wc（单位rad/s）
%b：系统函数的分子
%a：系统函数的分母
[N,Wc]=cheb2ord(Wp,Ws,Rp,Rs,'s');%计算切比雪夫模拟滤波器参数，‘s’表示Wp和Ws都是模拟角频率
switch filter_type
    case 1
        [b,a]=cheby2(N,Rs,Wp,'low','s');%设计切比雪夫2低通滤波器
    case 2
        [b,a]=cheby2(N,Rs,Wp,'high','s');%设计切比雪夫2高通滤波器
    case 3
        [b,a]=cheby2(N,Rs,Wp,'bandpass','s');%设计切比雪夫2带通滤波器
    case 4
        [b,a]=cheby2(N,Rs,Wp,'stop','s');%设计切比雪夫2带阻滤波器
end
[H,W]=freqs(b,a);%W:模拟角频率，H:模拟滤波器的系统函数
mag=abs(H);%幅度
pha=angle(H);%相位
db=20*log10((mag+eps)/max(mag));%转换为分贝
f=W/(2*pi);%将模拟角频率转为Hz
subplot(2,1,1);plot(f,db);
title('模拟滤波器幅频曲线');xlabel('频率（Hz）');ylabel('幅度（dB）');
axis([0 fm -80 5]); %坐标范围调整
subplot(2,1,2);plot(f,pha);
title('模拟滤波器相频曲线');xlabel('频率（Hz）');ylabel('相位（rad）');
axis([0 fm -4 4]); %坐标范围调整


%% 滤波器2 高通  切比雪夫2
%设计切比雪夫2模拟滤波器
%通带截止频率：fp（单位Hz）
%通带衰减：Rp（单位dB）
%阻带截止频率：fs（单位Hz）
%阻带衰减：Rs（单位dB）
clear
clc
%技术指标要求设置，按自己需求更改即可
filter_type=1;%1:低通，2：高通，3：带通，4：带阻
switch filter_type
    case 3
        %低通示例，理想截止频率2000Hz左右
        fp=1900;fs=2200;
    case 2
        %高通示例  理想截止频率5000Hz左右
        fp=5100;fs=4800;
    case 3
        %带通示例 理想上限截止频率2000Hz，下限截止频率1000Hz
        fp=[1100,1900];fs=[900,2100];
    case 4
        %带阻示例 理想上限截止频率2000Hz，下限截止频率1000Hz
        fp=[900,2100];fs=[1100,1900];
end
fm=12000; %信号频率最大值，单位Hz
Rp=1;Rs=40; 
 
Wp=2*pi*fp;Ws=2*pi*fs;    %转换为模拟角频率，单位rad/s
%滤波器的阶数：N
%衰减3dB时的截止频率：Wc（单位rad/s）
%b：系统函数的分子
%a：系统函数的分母
[N,Wc]=cheb2ord(Wp,Ws,Rp,Rs,'s');%计算切比雪夫模拟滤波器参数
switch filter_type
    case 1
        [b,a]=cheby2(N,Rs,Wp,'low','s');%设计切比雪夫2低通滤波器
    case 2
        [b,a]=cheby2(N,Rs,Wp,'high','s');%设计切比雪夫2高通滤波器
    case 3
        [b,a]=cheby2(N,Rs,Wp,'bandpass','s');%设计切比雪夫2带通滤波器
    case 4
        [b,a]=cheby2(N,Rs,Wp,'stop','s');%设计切比雪夫2带阻滤波器
end
[H,W]=freqs(b,a);%W:模拟角频率，H:模拟滤波器的系统函数
mag=abs(H);%幅度
pha=angle(H);%相位
db=20*log10((mag+eps)/max(mag));%转换为分贝
f=W/(2*pi);%将模拟角频率转为Hz
subplot(2,1,1);plot(f,db);
title('模拟滤波器幅频曲线');xlabel('频率（Hz）');ylabel('幅度（dB）');
axis([0 fm -80 5]); %坐标范围调整
subplot(2,1,2);plot(f,pha);
title('模拟滤波器相频曲线');xlabel('频率（Hz）');ylabel('相位（rad）');
axis([0 fm -4 4]); %坐标范围调整