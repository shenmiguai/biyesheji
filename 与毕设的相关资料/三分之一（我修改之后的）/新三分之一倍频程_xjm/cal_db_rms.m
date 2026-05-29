%% //功能：计算信号的分贝均方根值”（Calculate Decibel RMS）
% 计算db 和 RMS值
%计算一段振动信号的倍频程带声压级（dB值）并导出到Excel文件的程序。
%是基于中心频率法的一种简单实现
%% 这份cal_db_rms.m代码的总体功能就是：
%读取一个振动信号文件 →做三分之一倍频程带分析（每个中心频率）→算出每一通道和整体的声压级（dB）→最后导出成一个漂亮的Excel表格！
%% cal_db_rms

%%
clear;clc;% 清空工作区和命令行
f_zhong = [10 12.5 16 20 25 31.5 40 50 63 80 100 125 160 200 250];%三分之一倍频程分析常用的中心频率（单位Hz）。
data_dir = './36波形.xlsx';% 指定要读取的数据文件路径

%% 从excel读数据
% 这里默认第1列是时间，2列及以后是加速度信号
Signal = xlsread(data_dir);   % 读Excel文件
p=Signal(:,1);%第一列 %xjm
t = Signal(:,1)-1;            % 取第一列时间序列，减1处理
dt = t(2)-t(1);               % 时间间隔（假设是均匀采样）这段代码就是针对等时间间隔的采样。
fs_up = 1/dt;                 % fs_up 是实际的采样频率
matrixs = Signal(:,2:end); %(2048x1)   % 后面的列是加速度信号（可以有多通道）

%% 判断是否需要积分_三分之一倍频程分析 + dB计算
%把每个通道的振动信号分成一堆频段，用FFT做带通滤波，计算每个频段的RMS（能量强度），然后转换成dB（响度大小）做特征提取。

[a, b] = size(matrixs);   %a=2048 b=1 % 获取数据矩阵的尺寸，a是采样点数，b是通道数
L_db_Matrix = [];                    % 初始化一个空矩阵，用来存储每个通道的dB值结果

for i = 1:b              %i=1                    % 对每个通道数据进行处理
    channel_value = matrixs(:,i); %第2列 速度 %(2048x1)        % 取出第i个通道的数据
    fs = 1/dt;       % fs=8192        % 根据时间间隔计算采样频率
    f = f_zhong;      % f=(1x15)       % 中心频率数组（1/3倍频程的标准频率）
    fc = [f 10*f 100*f 1000*f]; %10~25khz     % 扩展频率范围，包括原频率及其10倍、100倍、1000倍
    oc6 = 2^(1/6);                   % 每个频带上下限的倍数因子（1/6倍频程）
    nc = length(fc); %nc=60  fc个数    % 总共的频带数量
    n = length(channel_value);%n=2048      % 当前通道的数据长度（采样点数量）
    nfft = 2^nextpow2(n);   %nfft=2048     % 找到比n大的最小的2的次方，用于FFT加速

    
%% 每次只保留某个倍频程的频率范围，把其他频率清零。
%   然后逆变换回来，用方差（var）计算能量。
%   sqrt(var())就是这个频带的RMS值。
    yc = zeros(1,nc);
    value = channel_value;  %%value=(2048x1)  速度值 %复制当前通道的数据，后面用于FFT处理
    for j = 1:nc   %nc=60           % 对每个频带进行处理
        fl = fc(j)/oc6;             % 当前频带的下限频率
        fu = fc(j)*oc6;             % 当前频带的上限频率
        nl = round(fl*nfft/fs + 1); % 下限频率对应在FFT结果中的下标
        nu = round(fu*nfft/fs + 1); % 上限频率对应在FFT结果中的上标

        value_fft = fft(value, nfft);  % 做FFT变换
        if fu > fs_up                  %   % 如果频率超了采样率（奈奎斯特频率），停止
            m = j - 1;  
            disp(m);        %m=39
            break;
        end
        b = zeros(1, nfft);            % 创建全0频谱
        b(nl:nu) = value_fft(nl:nu);   % 只保留需要频带的FFT分量。or 只保留当前频带内的正频率部分
        b(nfft-nu+1:nfft-nl+1) = value_fft(nfft-nu+1:nfft-nl+1); % 也保留对应的负频率（对称）
        c = ifft(b, nfft);              % 逆FFT回来
        yc(j) = sqrt(var(real(c(1:n)))); %取实际值,计算该频带信号的有效值（RMS），作为能量表示
%         plot(yc(j));hold on;
end
figure (1)    
plot(yc);
grid on;
title('RMS值');


figure (2)
bar(yc);
grid on;
title('RMS值');
%% 每通道的dB声压级计算
%20*log10(RMS/参考值)就是标准的声压级公式
    a0 = 1 * 10^(-6);                  % 参考加速度（通常是1微米/秒²）
         L_db = 20 * log10(yc(1:m) / a0);        % 使用声学分贝计算公式将RMS转换为dB值
%        L_db = 20 * log10(yc/ a0);        % 使用声学分贝计算公式将RMS转换为dB值
    L_db_Matrix = [L_db_Matrix; L_db]; %L_db_Matrix=(1x39) % 将当前通道的dB值加入结果矩阵中
    %L_db_Matrix = [L_db_Matrix; yc]; % （可选）你也可以不转dB，只看原始RMS值
end

%% 写入excel
%% 后处理 & 整理结果
% 平均dB值不能直接算，要先能量平均，再转回dB。
mean_value = 10*log10(mean(10.^(L_db_Matrix/10),1)); % 先转回来线性平均，再转dB
db_mean =  [L_db_Matrix' mean_value']; % 拼在一起（每个通道 + 平均值）
db_mean = roundn(db_mean,-5);          % 保留5位小数
mat_w_db = [fc(1:size(L_db_Matrix,2))' db_mean]; % 加上频率列 %size(L_db_Matrix,2)=2 %fc(1:size(L_db_Matrix,2))'=(39x1)

%% 到这个位置就算出来速度和时间一起的db值了



%% 准备导出到Excel
% 为了Excel里第一行可以加上漂亮的标题行，比如：频率, 1通道, 2通道, ..., 平均值。
[mm, nn] = size(mat_w_db);% 数据行列数
a = {};
for i = 1:nn-2
    a = [a num2str(i)];   % 通道标题，比如 "1", "2", "3", ...
end
index = ['频率',a,'平均值']; % 列标题
data_cell = mat2cell(mat_w_db,ones(mm,1),ones(nn,1));
result = [index; data_cell];% 最终整理好的单元格数据

%% 导出到Excel文件
doc_name= '加速度1处理结果.xlsx';
name_ = split(string(doc_name), ".");   % 把doc_name（文件名）按"."分开，比如"加速度1.xlsx"分成["加速度1", "xlsx"]
name = name_(1);                        % 取分开的第一部分，也就是"加速度1"，不要后缀
excel_dir = strcat('./导出结果/', name, '.xlsx');  % 拼接出新的保存路径，比如'./导出结果/加速度1.xlsx'

if exist(excel_dir)                     % 检查这个保存路径下的Excel文件是否已经存在
    delete(excel_dir);                  % 如果已经存在，就删除旧的Excel文件，防止写入出错
end
xlswrite(excel_dir, result);             % 把变量result里的数据写进新的Excel文件（保存结果）
%end
