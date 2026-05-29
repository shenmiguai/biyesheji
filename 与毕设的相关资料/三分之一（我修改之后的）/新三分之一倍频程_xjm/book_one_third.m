clear;clc;close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fni=input('三分之一倍频处理-输入数据文件名：','s');
fid=fopen(fni,'r');
sf=fscanf(fid,'%f',1);%采样频率
fno=fscanf(fid,'%s',1);%输出数据文件名
x=fscanf(fid,'%f',[1,inf]);%按行输入数据
status=fclose(fid);

%定义三分之一倍频程的中心频率
f=[1.00 1.25 1.60 2.00 3.15 4.00 5.00 6.300 8.00];
fc=[f,10*f,100*f,1000*f,10000*f];
%中心频率与下线频率的比值
oc6=2^(1/6);
nc=length(fc);%取中心频率总的长度
%输入数据的长度
n=length(x);
%大于并最接近n的2的幂次方长度
nfft=2^nextpow2(n);
%FFT变换
a=fft(x,nfft);
for j=1:nc
    fl=fc(j)/oc6;
    fu=fc(j)*oc6;
    nl=round(fl*nfft/sf+1);%下线频率对应的序号
    nu=round(fl*nfft/sf+1);
%如果上限频率大于折叠频率则循环中断
    if fu >sf/2
        m=j-1;
	break;
    end
%以每一个中心频率段为通带进行带通频域滤波
    b=zeros(l,nfft);
    b(nl:nu)=a(nl:nu);
    b(nfft-nu+l:nfft-nl+l)=a(nfft-nu+l:nfft-nl+1);
    c=ifft (b, nfft);
    %计算对应每个中心频率段的有效值
    yc(j)=sqrt(var(real(b(1:n))));
end

%绘制输人时程曲线图形
subplot(2,1,1);
t=0:1/sf:(n-1)/sf;
plot(t,x);
xlabel('时间(s)');
ylabel('加速度(g)');
grid on;
%绘制三分之一倍频程有效值图形
subplot(2,1,2);
plot(fc(l:m),yc(1:m));
xlabel('频率(Hz)');
ylabel('有效值');
grid on;
%打开文件输出三分之一倍频程数据
fid=fopen (fno,'w');
for k=l: m
	fprintf (fid,'%f %f\n',fc (k),yc (k));
end
status=fclose(fid);





















