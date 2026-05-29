% 通常导出的txt是以g为单位；
% mat 格式以m/s2单位；
% 软件当中 g = 9.8066 m/s2；
% 如果采集的是三轴加速度振动数据时，表示烈度通常需要进行积分，m/s2转换为m/s;
% 在存放是数据时，只需要按照（4713-1234-122rpm-2662kw-QC-liedu-1；
% 4713-1234-122rpm-2662kw-QC-1）区分开来即可；存放在data文件夹当中；
clear;clc;
data_dir = './data';
if exist(data_dir)
    File = dir(fullfile(data_dir,'*.xlsx'));  
    FileNames = {File.name}';
    for name_id = 1:size(FileNames,1)
        doc_name = FileNames(name_id);
        f_zhong = [10 12.5 16 20 25 31.5 40 50 63 80 100 125 160 200 250];
        cal_db_rms(doc_name, f_zhong);
    end
else
    fprintf('请添加xlsx格式文件数据');
end


