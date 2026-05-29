% View filter characteristics
hd = Bandpass_FIR;       % 根据自动生成滤波器的脚本文件名进行修改
[b,a]=tf(hd);            % 调用生成的滤波器
%tf 函数将离散时间滤波器对象hd转换为传递函数形式，返回滤波器的分子系数b和分母系数a
[H,W]=freqz(b,a);        % 数字滤波器系统函数
mag=abs(H);   % Amplitude
db=20*log10(mag);% convert to dB %db=20*log10((mag+eps)/max(mag));% convert to dB

pha=angle(H); % Phase
f2=W*1e4/(2*pi)/(1e3); % convert to MHz units
% notice：上述转换成频率公式中的1e4为生成滤波器时的采样频率
 subplot(3,2,3);plot(f2,db);
title('FIR滤波器幅频曲线');
xlabel('Frequency（MHz）');ylabel('Amplitude（dB）');
subplot(3,2,4);plot(f2,pha);
title('FIR滤波器相频曲线');
xlabel('Frequency（MHz）');ylabel('Phase（rad）');

% Start filter signal
y=filter(b,a,x); % a,b为系统函数的系数，x为待滤波的信号，y为滤波后输出后的信号