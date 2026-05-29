clear;clc;
f_zhong = [10 12.5 16 20 25 31.5 40 50 63 80 100 125 160 200 250];
data_dir = './data/加速度1.xlsx';


%% excel
Signal = xlsread(data_dir);
t = Signal(:,1)-1;
dt = t(2)-t(1);
fs_up = 1/dt;
matrixs = Signal(:,2:end);

%% 判断是否需要积分
[a, b] = size(matrixs);
L_db_Matrix = [];
for i = 1:b;
    channel_value = matrixs(:,i);
    fs = 1/dt;
    f = f_zhong;
    fc = [f 10*f 100*f 1000*f];
    oc6 = 2^(1/6);
    nc = length(fc);
    n = length(channel_value);
    nfft = 2^nextpow2(n);

    value = channel_value;

    for j = 1:nc;
        fl = fc(j)/oc6;           % 下限频率
        fu = fc(j)*oc6;           % 上线频率
        nl = round(fl*nfft/fs+1) % 上限频率对应的序号
        nu = round(fu*nfft/fs+1) % 下线频率对应的序号

        value_fft = fft(value,nfft);
        if fu>fs_up
            m = j-1;
            break;
        end
        b = zeros(1,nfft);
        b(nl:nu) = value_fft(nl:nu);
        b(nfft-nu+1:nfft-nl+1) = value_fft(nfft-nu+1:nfft-nl+1);
        c = ifft(b, nfft);
        yc(j) = sqrt(var(real(c(1:n))));
    end
            a0 = 1*10^(-6);
            L_db = 20 * log10(yc/a0);
            L_db_Matrix = [L_db_Matrix; L_db];
    %L_db_Matrix = [L_db_Matrix; yc];
end
%% 写入excel
mean_value = 10*log10(mean(10.^(L_db_Matrix/10),1));
db_mean =  [L_db_Matrix' mean_value'];
db_mean = roundn(db_mean,-5);
mat_w_db = [fc(1:size(L_db_Matrix,2))' db_mean];
[mm, nn] = size(mat_w_db);
a = {};
for i = 1:nn-2;
    a = [a num2str(i)];
end
index = ['频率',a,'平均值'];
data_cell = mat2cell(mat_w_db,ones(mm,1),ones(nn,1));
result = [index; data_cell];

% 导出结果
name_ = split(string(doc_name),".");
name = name_(1);
excel_dir = strcat('./导出结果/', name, '.xlsx');
if exist(excel_dir);
    delete(excel_dir);
end
xlswrite(excel_dir, result);
%end
