%设计巴特沃斯模拟滤波器
%通带截止频率fp   %阻带截止频率fs
%通带截止频率:取决于滤波器的具体设计和应用需求，不能简单地认为就是频率下降到 3 分贝的时候。
clear
clc
filter_type=1;  %1:低通，2：高通，3：带通，4：带阻
switch filter_type
    case 1
        %低通示例，理想截止频率2000Hz左右
        fp=1900;fs=2200;
    case 2
        %高通示例，理想截止频率5000Hz左右
        fp=5100;fs=4700;
    case 3
        %带通示例，理想上限截止频率2000Hz，下限截止频率1000Hz
        fp=[1100,1900];fs=[900,2100];
    case 4
        %带阻示例，理想上限截止频率2000Hz，下限截止频率1000Hz
        fp=[900,2100];fs=[1100,1900];
end
%   fm=10000; %信号频率最大值，单位Hz
Rp=1;Rs=40; %通带衰减：Rp（单位dB）
            %阻带衰减：Rs（单位dB）
Wp=2*pi*fp;Ws=2*pi*fs;    %转换为模拟角频率，单位rad/s

[N,Wc]=buttord(Wp,Ws,Rp,Rs,'s');  %滤波器的阶数：N    %模 模 通衰 阻衰  %计算巴特沃斯模拟滤波器参数
%衰减3dB时的截止频率：Wc（单位rad/s）  %'s' 表示设计模拟滤波器。
switch filter_type
    case 1
        [b,a]=butter(N,Wc,'low','s');       %低通
    case 2
        [b,a]=butter(N,Wc,'high','s');      %高通
    case 3
        [b,a]=butter(N,Wc,'bandpass','s');  %带通
    case 4
        [b,a]=butter(N,Wc,'stop','s');      %带阻
end
[H,W]=freqs(b,a);%  W:模拟角频率，H:模拟滤波器的系统函数 %b：系统函数的分子  %a：系统函数的分母
mag=abs(H);%幅度
pha=angle(H);%相位
db=20*log10((mag+eps)/max(mag));%幅度转换为分贝 % eps=2.2204e-16 %防止除以零和数值不稳定
f=W/(2*pi);%将模拟角频率（rad/s）转为Hz

%-----------------------------------------绘图----------------------------------
subplot(2,1,1);plot(f,db);  %幅度转换为分贝
title('模拟滤波器幅频曲线');xlabel('频率（Hz）');ylabel('幅度（dB）');grid minor;
subplot(2,1,2);plot(f,pha); %相位
title('模拟滤波器相频曲线');xlabel('频率（Hz）');ylabel('相位（rad）');grid minor;