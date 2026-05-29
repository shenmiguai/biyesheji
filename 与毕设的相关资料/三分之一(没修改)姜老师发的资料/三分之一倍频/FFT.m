clear;clc;

data_dir = './data/加速度.xlsx';

%% excel
Signal = xlsread(data_dir);
t = Signal(:,1)-1;
dt = t(2)-t(1);
fs = 1/dt;
ax = Signal(:,2)';
N  = length(ax);
n  = 0:N-1;
f  = n*fs/N;
point =N;
t = 0:1/fs:(point-1)/fs; %时间轴
%fft 
ax_fft     = fft(ax, N);

%%
%plot-1
subplot(2,1,1);
plot(t,ax);
xlabel('t');ylabel('ax');

subplot(2,1,2);
plot(f,abs(ax_fft));
axis([0 500 0 35]);
xlabel('f');ylabel('FFT-ax');
