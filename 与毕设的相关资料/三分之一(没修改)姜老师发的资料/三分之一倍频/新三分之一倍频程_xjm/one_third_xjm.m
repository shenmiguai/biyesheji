clear
clc
close all  %30个fc
fc= [25 31.5 40 50 63 80 100 125 160 200 250 315 400 500 630 800 1000 1250 1600 2000 2500 3150 4000 5000 6300 8000 10000 12500 16000 20000];
data_dir = './data/36波形.xlsx';% 指定要读取的数据文件路径

%% 读取excel数据
Signal = xlsread(data_dir);   % 读Excel文件
%t = Signal(:,1)-1;            % 取第一列为时间序列，减1处理
%dt = t(2)-t(1);               % 时间间隔（假设是均匀采样）这段代码就是针对等时间间隔的采样。
%fs_up = 1/dt;                 % fs_up 是实际的采样频率   %这样dt=0.000012几。 fs=8192   fs/2=4096太小了  只有22个点   因为if fu > fs/2  
matrixs = Signal(:,2:end);    % 速度信号（可以有多通道）
%% 
[a, L] = size(matrixs);              %2048 1 获取数据矩阵的尺寸，a是采样点数，b是通道数
L_db_Matrix = [];                    % 初始化一个空矩阵，用来存储每个通道的dB值结果

for i = 1:L                          % 对每个通道数据进行处理
    channel_value = matrixs(:,i);   % 取出第i个通道的数据
    %fs = 1/dt;                       % 根据时间间隔计算采样频率
    fs = 500000;                       % 根据时间间隔计算采样频率
    oc6 = 2^(1/6);                   % 每个频带上下限的倍数因子（1/6倍频程）
    nc = length(fc);                % 30 个频率
    n = length(channel_value);      % 2048个 当前通道的数据长度（采样点数量）
    nfft = 2^nextpow2(n);           % 找到比n大的最小的2的次方，用于FFT加速
    value = channel_value;          % 复制当前通道的数据，后面用于FFT处理
    for j = 1:nc                     % 对每个频带进行处理
        fl = fc(j)/oc6;             % 当前频带的下限频率
        fu = fc(j)*oc6;             % 当前频带的上限频率
        nl = round(fl*nfft/fs + 1); % 下限频率对应在FFT结果中的下标
        nu = round(fu*nfft/fs + 1); % 上限频率对应在FFT结果中的上标

        value_fft = fft(value, nfft);  % 做FFT变换
        if fu > fs/2                  %   % 如果频率超了采样率（奈奎斯特频率），停止
            m = j - 1;             
            break;
        end

        b = zeros(1, nfft);            % 创建全0频谱
        b(nl:nu) = value_fft(nl:nu);   % 只保留需要频带的FFT分量。or 只保留当前频带内的正频率部分
        b(nfft-nu+1:nfft-nl+1) = value_fft(nfft-nu+1:nfft-nl+1); % 也保留对应的负频率（对称）
        c = ifft(b, nfft);              % 逆FFT回来
        yc(j) = sqrt(var(real(c(1:n)))); %取实际值,计算该频带信号的有效值（RMS），作为能量表示
    end                                 %方差（var）% sqrt(var())就是这个频带的RMS值。
% A计权
yc=10*log10(yc/1e-10);
cf=zeros(1:m);
cf(1,11:44)=[-70.4 -63.4 -56.7 -50.5, -44.7, -39.4, -34.6, -30.2, -26.2, -22.5, -19.1, -16.1, -13.4,...
      -10.9, -8.6, -6.6, -48, -3.2, -1.9, -0.8, 0, 0.6, 1.0, 1.2, 1.3,...
      1.2, 1.0, 0.5, -0.1, -1.1, -2.5, -4.3, -6.6, -9.3]; % 20-16000Hz A声级计权值
yc=yc(1:m)+cf(1:m);
%% %-----------------------绘制输入时程曲线图形----------------------------- 
%subplot(2,1,1); 
%t=0:1/fs:(n-1)/fs;
%plot(t,x);
%xlabel('时间(s)'); 
%ylabel('加速度(m/s^2)'); 
%grid on;
%------------------------绘制A声级------------------------------------- 
figure; 
plot(fc(14:m),yc(14:m),'r-s','LineWidth',1.5); %从20Hz开始画，因此取14
xlabel('频率(Hz)'); 
ylabel('A声级(dB)'); 
grid on; 
set(gca,'xscale','log','xtick',fc,'XLim',[20 20000],'Fontname','宋体','Fontsize',12); 
set(gcf,'Position',[250,200,800,500]); sa=yc(1,14:44); save('006.txt','sa','-ascii' );
%-----------------------连续等效A声级------------------------------------
if fc(1,m)>=20000 
    i_num=44-14+1; 
else i_num=m-14+1; 
    disp('频率区间未到20kHz，等效连续A声级计算不准确！！！'); 
end
L=[];LeqA=0; 
L=yc(1,14:44); 
for i=1:i_num 
    LeqA=LeqA+10^(0.1*L(1,i)); 
end
LeqA=10*log10(LeqA); 
L=sprintf('等效连续A声级为：%.2f',LeqA); 
disp(L); 
%-------------------------绘制倍频带声压级（NR曲线）------------------------- 
figure; 
nr=[]; 
for i=1:length(yc) 
    if yc(1,i)>50 
        nr(1,i)=(yc(1,i)-16.7)/0.83; 
    else nr(1,i)=(yc(1,i)-9.16)/0.97; 
    end
end
plot(fc(16:m),nr(16:m),'r-s','LineWidth',1.5); %从31.5Hz开始画，因此取16; 
set(gca,'xscale','log','xtick',fc,'XLim',[31.5 8000],'Fontname','宋体','Fontsize',12); 
xlabel('频率(Hz)'); 
ylabel('倍频带声压级(dB)'); 
grid on; 
hold on; 
nr_num=nr(1,31); %1000Hz对应的倍频带声压级 
[NR_db,nr_num_]=NR(nr_num); 
NR_c=[31.5,63.0,125.0,250.0,500.0,1000.0,2000.0,4000.0,8000.0]; 
plot(NR_c,NR_db,'b:o','LineWidth',1.5); 
legend('倍频带声压级',sprintf('NR=%i 倍频带声压级限值',nr_num_)); 
set(gcf,'Position',[250,200,1200,500]);


















%% 
subplot
    %% 每通道的dB声压级计算
%20*log10(RMS/参考值)就是标准的声压级公式
    a0 = 1 * 10^(-6);                  % 参考加速度（通常是1微米/秒²）
    L_db = 20 * log10(yc/a0);        % 使用声学分贝计算公式将RMS转换为dB值

    L_db_Matrix = [L_db_Matrix; L_db]; %  L_db_Matrix 会增加一行，包含 L_db 的数据
                                       %将当前通道的dB值加入结果矩阵中
    %L_db_Matrix = [L_db_Matrix; yc]; % （可选）你也可以不转dB，只看原始RMS值
end

%% 写入excel
%% 后处理 & 整理结果
% 平均dB值不能直接算，要先能量平均，再转回dB。
mean_value = 10*log10(mean(10.^(L_db_Matrix/10),1)); % 先转回来线性平均，再转dB
db_mean =  [L_db_Matrix' mean_value']; % 拼在一起（每个通道 + 平均值）
db_mean = roundn(db_mean,-5);          % 保留5位小数
db_mean_1=db_mean(:,2); %取出速度这一列
mat_w_db = [fc(1:size(L_db_Matrix,2))' db_mean_1]; % 加上频率列


%% 绘图
figure
x_values =(mat_w_db(:,1)); 
y_values =(mat_w_db(:,2));
bar(x_values, y_values,'BarWidth',5);  % 第一列数据作为 X 轴，第二列数据作为 Y 轴
xlabel('频率hz');  % X 轴标签
ylabel('db');  % Y 轴标签
title('速度的db分布');  % 图形标题
% grid on;  % 显示网格

a(3) = figure(3);
set(gcf,'color','white'); %设定figure的背景颜色
set(gca,'FontSize',10);
plot(fc,y_values'); 
title('1/3倍频程');
xlabel('中心频率/Hz');
ylabel('声压级/Db');
set(gcf,'position',[100,100, 700, 400]); %设定figure的位置和大小 get current figure



%% 转成对数坐标但是有问题
% figure 
%   set(gca,'FontSize',16)
%   semilogx(x_values, y_values,'r-','linewidth',2)
% %   hold on
% %   semilogx(one_third_freq_preferred,bands,'ro','MarkerSize',10)
%   xlabel('Frequency (Hz)')
%   ylabel('Sound absorption coefficient')
%   legend('Narrow bands','1/3 octave bands',4)
%   set(gca,'ylim',[0 1])


%% 准备导出到Excel
% % 为了Excel里第一行可以加上漂亮的标题行，比如：频率, 1通道, 2通道, ..., 平均值。
% [mm, nn] = size(mat_w_db);% 数据行列数
% a = {};
% for i = 1:nn-2
%     a = [a num2str(i)];   % 通道标题，比如 "1", "2", "3", ...
% end
% index = ['频率',a,'平均值']; % 列标题
% data_cell = mat2cell(mat_w_db,ones(mm,1),ones(nn,1));
% result = [index; data_cell];% 最终整理好的单元格数据
% 
%% 导出到Excel文件
% doc_name= '加速度1处理结果.xlsx';
% name_ = split(string(doc_name), ".");   % 把doc_name（文件名）按"."分开，比如"加速度1.xlsx"分成["加速度1", "xlsx"]
% name = name_(1);                        % 取分开的第一部分，也就是"加速度1"，不要后缀
% excel_dir = strcat('./导出结果/', name, '.xlsx');  % 拼接出新的保存路径，比如'./导出结果/加速度1.xlsx'
% 
% if exist(excel_dir)                     % 检查这个保存路径下的Excel文件是否已经存在
%     delete(excel_dir);                  % 如果已经存在，就删除旧的Excel文件，防止写入出错
% end
% xlswrite(excel_dir, result);             % 把变量result里的数据写进新的Excel文件（保存结果）
% %end
