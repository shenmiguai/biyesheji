clear;clc;clf;
data_dir = './data/加速度1.xlsx';

% Signal = xlsread(data_dir);
% 
% t = Signal(:,1)'-1;
% dt = t(2)-t(1);
% fs = 1/dt;
% value = Signal(:,2)';
% 
% 
% n_value = length(value);
% N = 2^nextpow2(n_value);

L_db_Matrix = [];

fs   = 256;
N    = 1024;
n_value = N;
t    = 0:1/fs:(N-1)/fs;
value=2+0.3*cos(2*pi*10*t-pi*30/180)+0.5*cos(2*pi*65*t+pi*90/180);


win = hamming(N);
value = 1.586*value.*win.'; % 海明窗修正系数

%----------------------------------------------------------
% -----------------------FFT-------------------------------
%----------------------------------------------------------
n  = 0:N-1;
f_axis  = n*fs/N;
%point =N;
%t = 0:1/fs:(point-1)/fs; %时间轴

%fft
value_fft  = fft(value, N);


Ayy = abs(value_fft)/(N/2);
Ayy(1)=Ayy(1)/2;

%plot-1
figure(1);
subplot(2,1,1);
plot(t,value);
xlabel('t');ylabel('a');

subplot(2,1,2);
plot(f_axis,Ayy);
axis([0 80 0 0.03]);
xlabel('f');ylabel('FFT-value');


%----------------------------------------------------------
% -----------------------db-rms----------------------------
%----------------------------------------------------------

%f_center = [10 12.5 16 20 25 31.5 40 50 63 80 100 125 160 200 250];
%fc = [f_center 10*f_center 100*f_center 1000*f_center];


fl_all = [0.87 1.09 1.38 1.74 2.19 2.76 3.48 4.38 5.52 6.69 8.77 11.1 13.9 17.5 22.1 27.8 35.1 44.2  55.7  70.2] ;
fc_all = [1    0.25 1.6  2    2.5  3.15 4    5    6.3  8    10   12.5 16   20   25   31.5 40   50    63    80  ];
fu_all = [1.09 1.38 1.74 2.19 2.76 3.48 4.38 5.52 6.96 8.77 11.1 13.9 17.5 22.1 27.8 35.1 44.2 55.7  70.2  88.4];

nc = length(fc_all);
%oc6 = 2^(1/6);


for j = 1:nc;
    %fl = fc(j)/oc6;           % 下限频率
    %fu = fc(j)*oc6;           % 上线频率
    fl = fl_all(j);
    fu = fu_all(j);
    
    nl = round(fl*N/fs+1) % 上限频率对应的序号
    nu = round(fu*N/fs+1) % 下线频率对应的序号

    value_fft = fft(value,N);
    if fu>fs
        m = j-1;
        break;
    end
    b = zeros(1,N);
    b(nl:nu) = value_fft(nl:nu);
    b(N-nu+1:N-nl+1) = value_fft(N-nu+1:N-nl+1);
    c = ifft(b, N);
    yc(j) = sqrt(var(real(c(1:n_value))));
    
    %yc(j) =  rms(c);
end

% a0 = 1*10^(-3);
% L_db = 20 * log10(yc/a0);
L_db_Matrix = [L_db_Matrix; yc];

%plot-2

figure(2);
% 自定义x轴为等间距索引值
m=20;
x_values = 1:20;

% 绘制柱状图，设置均匀的x轴
bar(x_values, yc(1:20), 'BarWidth', 0.8); % 调整柱宽
xticks(1:1:20);
xticklabels(fc_all);




