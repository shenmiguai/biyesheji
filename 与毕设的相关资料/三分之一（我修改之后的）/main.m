%% 加注释
% 通常导出的 txt 文件是以 g 为单位的加速度；
% 而 mat 格式的数据是以 m/s² 为单位；
% 软件中约定：1g = 9.8066 m/s²；
% 如果采集的是三轴加速度振动数据，通常为了得到“烈度”需要对加速度积分，单位从 m/s² 变为 m/s；
% 文件命名时：
%   - 带有 “liedu” 字样的文件表示已经做了积分（即表示烈度）；
%   - 不带 “liedu” 的就是原始加速度数据；
%   - 文件应该统一放在 ./data 文件夹中，命名例如：
%       4713-1234-122rpm-2662kw-QC-liedu-1.xlsx
%       4713-1234-122rpm-2662kw-QC-1.xlsx

clear;  % 清除工作区中的所有变量
clc;    % 清空命令窗口内容

data_dir = './data';  % 指定数据文件夹的路径

% 判断 data_dir 文件夹是否存在
if exist(data_dir)     
    % 查找该文件夹中所有扩展名为 .xlsx 的 Excel 文件，并存入结构体数组 File
    File = dir(fullfile(data_dir,'*.xlsx'));  
    
    % 提取 File 中所有文件的 name 字段（即文件名），组成一个列向量 cell 数组 FileNames
    FileNames = {File.name}';  
    
    % 遍历所有 Excel 文件
    for name_id = 1:size(FileNames,1);
        % 取出当前文件名，注意这里是 cell 里的内容（不是 cell 本身）
        doc_name = FileNames{name_id};   
        
        % 定义中频中心频率数组，用于 1/3 倍频程分析（单位：Hz）
        f_zhong = [10 12.5 16 20 25 31.5 40 50 63 80 100 125 160 200 250];% 频率带使用的是常见的三分之一倍频程频率（10Hz 到 250Hz）。
        
        % 调用自定义函数 cal_db_rms，输入当前 Excel 文件名和频率数组
        cal_db_rms(doc_name, f_zhong);
    end
else
    % 如果 data 文件夹不存在或为空，输出提示信息
    fprintf('请添加xlsx格式文件数据');
end



%% 原版
% 通常导出的txt是以g为单位；
% mat 格式以m/s2单位；
% 软件当中 g = 9.8066 m/s2；
% 如果采集的是三轴加速度振动数据时，表示烈度通常需要进行积分，m/s2转换为m/s;
% 在存放是数据时，只需要按照（4713-1234-122rpm-2662kw-QC-liedu-1；
% 4713-1234-122rpm-2662kw-QC-1）区分开来即可；存放在data文件夹当中；
% clear;clc;
% data_dir = './data';
% if exist(data_dir)
%     File = dir(fullfile(data_dir,'*.xlsx'));  
%     FileNames = {File.name}';
%     for name_id = 1:size(FileNames,1);
%         doc_name = FileNames(name_id);
%         f_zhong = [10 12.5 16 20 25 31.5 40 50 63 80 100 125 160 200 250];
%         cal_db_rms(doc_name, f_zhong);
%     end
% else
%     fprintf('请添加xlsx格式文件数据');
% end



