%% 通过模拟滤波器设计IIR数字滤波器   冲激响应不变法
%原型：巴特沃斯模拟滤波器；变换方法：冲激响应不变法
%通带截止频率：fp（单位Hz）
%通带衰减：Rp（单位dB）
%阻带截止频率：fs（单位Hz）
%阻带衰减：Rs（单位dB）
clear
clc
%技术指标要求设置，按自己需求更改即可
filter_type=1;%1:低通，2：高通，3：带通，4：带阻
switch filter_type
    case 1
        %低通示例，理想截止频率2000Hz左右
        fp=1900;fs=2200;
        Fs=5000;%采样频率
    case 2
        %高通示例，理想截止频率5000Hz左右
        fp=6000;fs=4000;
        Fs=15000;%采样频率
    case 3
        %带通示例，理想上限截止频率2000Hz，下限截止频率1000Hz
        fp=[1100,1900];fs=[900,2100];
        Fs=5000;%采样频率
    case 4
        %带阻示例，理想上限截止频率2000Hz，下限截止频率1000Hz
        fp=[900,2100];fs=[1100,1900];
        Fs=5000;%采样频率
end
% fm=10000; %信号频率最大值，单位Hz
Rp=1;Rs=40;
 
Wp=2*pi*fp;Ws=2*pi*fs;    %转换为模拟角频率，单位rad/s
%滤波器的阶数：N
%衰减3dB时的截止频率：Wc（单位rad/s）
%b：系统函数的分子
%a：系统函数的分母
[N,Wc]=buttord(Wp,Ws,Rp,Rs,'s');%计算巴特沃斯模拟滤波器参数
switch filter_type
    case 1
        [b,a]=butter(N,Wc,'low','s');%设计巴特沃斯低通滤波器
    case 2
        [b,a]=butter(N,Wc,'high','s');%设计巴特沃斯高通滤波器
    case 3
        [b,a]=butter(N,Wc,'bandpass','s');%设计巴特沃斯带通滤波器
    case 4
        [b,a]=butter(N,Wc,'stop','s');%设计巴特沃斯带阻滤波器
end
[B,A]=impinvar(b,a,Fs);%冲激响应不变法
[H,W]=freqz(B,A);%数字滤波器系统函数
% [H,W]=freqs(b,a);%数字滤波器系统函数
mag=abs(H);%幅度
pha=angle(H);%相位
db=20*log10((mag+eps)/max(mag));%转换为分贝
f=W*Fs/(2*pi);%将数字角频率转为Hz
subplot(2,1,1);plot(f,db);
title('冲激响应法设计数字滤波器幅频曲线');xlabel('频率（Hz）');ylabel('幅度（dB）');
subplot(2,1,2);plot(f,pha);
title('冲激响应法设计数字滤波器相频曲线');xlabel('频率（Hz）');ylabel('相位（rad）');

%% 通过模拟滤波器设计IIR数字滤波器  双线性映射法 
%通过模拟滤波器设计IIR数字滤波器
%原型：巴特沃斯模拟滤波器；变换方法：双线性映射法
%通带截止频率：fp（单位Hz）
%通带衰减：Rp（单位dB）
%阻带截止频率：fs（单位Hz）
%阻带衰减：Rs（单位dB）
%采样频率：Fs（单位Hz）
clear
clc
%技术指标要求设置，按自己需求更改即可
filter_type=4;%1:低通，2：高通，3：带通，4：带阻
switch filter_type
    case 1
        %低通示例，理想截止频率2000Hz左右
        fp=1900;fs=2200;
        Fs=5000;%采样频率
    case 2
        %高通示例，理想截止频率5000Hz左右
        fp=6000;fs=4000;
        Fs=15000;%采样频率
    case 3
        %带通示例，理想上限截止频率2000Hz，下限截止频率1000Hz
        fp=[1100,1900];fs=[900,2100];
        Fs=5000;%采样频率
    case 4
        %带阻示例，理想上限截止频率2000Hz，下限截止频率1000Hz
        fp=[900,2100];fs=[1100,1900];
        Fs=5000;%采样频率
end
% fm=10000; %信号频率最大值，单位Hz
Rp=1;Rs=40;
 
wp=2*pi*fp/Fs; ws=2*pi*fs/Fs; %转换为数字角频率技术指标
Wp=abs((2*Fs)*tan(wp/2));Ws =abs((2*Fs)*tan(ws/2)); %将数字技术指标的反畸变为模拟指标
%滤波器的阶数：N
%3dB衰减时的截止频率：Wc（单位rad/s）
%b：系统函数的分子
%a：系统函数的分母
[N,Wc]=buttord(Wp,Ws,Rp,Rs,'s');%计算巴特沃斯模拟滤波器参数，‘s’表示Wp和Ws都是模拟角频率
switch filter_type
    case 1
        [b,a]=butter(N,Wc,'low','s');%设计巴特沃斯低通滤波器
    case 2
        [b,a]=butter(N,Wc,'high','s');%设计巴特沃斯高通滤波器
    case 3
        [b,a]=butter(N,Wc,'bandpass','s');%设计巴特沃斯带通滤波器
    case 4
        [b,a]=butter(N,Wc,'stop','s');%设计巴特沃斯带阻滤波器
end
[B,A]=bilinear(b,a,Fs);%冲激响应不变法
[H,W]=freqz(B,A);%数字滤波器系统函数
mag=abs(H);%幅度
pha=angle(H);%相位
db=20*log10((mag+eps)/max(mag));%转换为分贝
f=W*Fs/(2*pi);%将数字角频率转为Hz
subplot(2,1,1);plot(f,db);
title('双线性映射法设计数字滤波器幅频曲线');xlabel('频率（Hz）');ylabel('幅度（dB）');
subplot(2,1,2);plot(f,pha);
title('双线性映射法设计数字滤波器相频曲线');xlabel('频率（Hz）');ylabel('相位（rad）');