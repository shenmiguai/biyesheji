%% 功能：加速度_速度_位移
%% 
function y = accleration_velocity_displacement(x, fs, fl, fu, it)
%ACCLERATION_VELOCITY_DISPLACEMENT 对时域信号进行加速度/速度/位移的变换
%   x  : 输入信号（时域）
%   fs : 采样频率
%   fl : 截止频率下限
%   fu : 截止频率上限
%   it : 变换类型（0: 原信号；1: 积分一次；2: 积分两次）
%%
    n = length(x);                         % 获取信号长度
    nfft = 2^nextpow2(n);                  % 取不小于 n 的 2 的幂，作为 FFT 点数
   
    c = 1;% 变换稀疏   g=9.8m/s2;   % 缩放系数，默认设为1                              
    y = fft(x, nfft);                      % 对输入信号进行快速傅里叶变换（FFT）

    df = fs / nfft;                        % 频率分辨率（Hz）

    ni = round(fl / df + 1);              % 截止频率下限转换为索引
    na = round(fu / df + 1);              % 截止频率上限转换为索引

    dw = 2 * pi * df;                      % 角频率分辨率（rad/s）
    w1 = 0 : dw : 2 * pi * (0.5 * fs);     % 正频率部分的角频率序列
    w2 = -2 * pi * (0.5 * fs - df) : dw : -dw; % 负频率部分的角频率序列
    w = [w1, w2];                          % 拼接正负频率，形成完整角频率向量
    w = w .^ it;                           % 根据 it 次幂处理角频率，实现积分效果
    a = zeros(1, nfft);                    % 初始化频域数组 a
    a(2:nfft-1) = y(2:nfft-1) ./ w(2:nfft-1)'; % 对除第一个点和最后一个点进行变换(积分)。% 时域积分频域除以jw。时域微分频域乘以jw。
    if it == 2
        y = -a;                            % 二次积分时取相反数
    else
        a1 = imag(a);                      % 虚部
        a2 = real(a);                      % 实部
        y = a1 - a2 * 1i;                  % 复数旋转处理
    end
    a = zeros(1, nfft);                    % 重新初始化频域数组 a
    a(ni:na) = y(ni:na);                   % 保留 fl~fu 范围内的正频率部分，到a这个数组中
    a(nfft - na + 1 : nfft - ni + 1) = y(nfft - na + 1 : nfft - ni + 1);  % 对称保留负频率部分（共轭）                                      
    y = ifft(a, nfft);                     % 反傅里叶变换恢复时域
    y = real(y(1:n)) * c;                  % 取实部，裁剪回原始长度并缩放
end


    