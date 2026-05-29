%---------------------------------------------------------
%A声级，等效连续A声级，倍频带声压级
%调用子函数：NR.m;
%作者：huaym;
clear;
clc;close all;
%输入需要分析的时程数据
s = load('E:\matlab2021aa\sum_proj\三分之一倍频\新三分之一倍频程_xjm/sudu.mat');
x=s.matrixs(:,1); %针对一列数据
fs =524288;      %采样频率，大于40kHz等效A声级数据准确，大于2000Hz倍频带声压级可运行；
%yc=zeros(1,1000);
%定义1/3倍频程中心频率
f=[1.00 1.25 1.60 2.00 2.50 3.15 4.00 5.00 6.30 8.00];
fc=[f,10*f,100*f,1000*f,10000*f,100000*f];
%中心频率与下限频率的比值
oc6=2^(1/6);
%取中心频率总的长度
nc=length(fc);
%输入数据的长度
n=length(x);
%大于并接近n的2的幂次方长度
nfft=2^nextpow2(n);
%FFT变换
a=fft(x,nfft);

for j=1:nc
    fl=fc(j)/oc6; %下限频率
    fu=fc(j)*oc6;%上限频率
    nl=round(fl*nfft/fs+1); %下限频率对应的序号
    nu=round(fu*nfft/fs+1);%上限频率对应的序号  
    if fu>fs/2 %如果上限频率大于半谱频率则循环中断
        m=j-1;break
    end
    
    %以每个中心频率段为通带进行带通频域滤波
    b=zeros(1,nfft);
    b(nl:nu)=a(nl:nu);
    b(nfft-nu+1:nfft-nl+1)=a(nfft-nu+1:nfft-nl+1);
    c=ifft(b,nfft);
	    %计算对应每个中心频率段的有效值
    %注意，matlab函数var和std认为操作数是度量总体的一个样本，所以
    %使用的公式是实际值与期望值之差的平方和再除以（N-1）
    yc(j)=sqrt(var(real(c(1:n)))); %该公式认为信号c是零均值的
end
yc=10*log10(yc/1e-10);
%A计权

cf=zeros(1,m);
cf(1,11:44)=[-70.4,-63.4,-56.7,-50.5,-44.7,-39.4,-34.6,-30.2,-26.2,-22.5,-19.1,-16.1,-13.4,-10.9,-8.6,...
    -6.6,-4.8,-3.2,-1.9,-0.8,0,0.6,1.0,1.2,1.3,1.2,1.0,0.5,-0.1,-1.1,-2.5,-4.3,-6.6,-9.3]; 

yc=yc(1:m)+cf(1:m);
%%
%-----------------------绘制输入时程曲线图形-----------------------------
figure 
t=0:1/fs:(n-1)/fs;
plot(t,x);
xlabel('时间(s)');
ylabel('加速度(m/s^2)');
grid on;
title('输入时程曲线图形');

%------------------------绘制A声级-------------------------------------
figure;
plot(fc(14:m),yc(14:m),'r-s','LineWidth',1.5);          %从20Hz开始画，因此取14
xlabel('频率(Hz)');
ylabel('A声级(dB)');
grid on;
set(gca,'xscale','log','xtick',fc,'XLim',[20 20000],'Fontname','宋体','Fontsize',12);
set(gcf,'Position',[250,200,800,500]);
sa=yc(1,14:44);
save('006.txt','sa','-ascii' );
title('绘制A声级');

%-----------------------连续等效A声级的值------------------------------------
if fc(1,m)>=20000
    i_num=44-14+1;
else
    i_num=m-14+1;
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
   else
     nr(1,i)=(yc(1,i)-9.16)/0.97;
   end
end
plot(fc(16:m),nr(16:m),'r-s','LineWidth',1.5);          %从31.5Hz开始画，因此取16;
set(gca,'xscale','log','xtick',fc,'XLim',[31.5 8000],'Fontname','宋体','Fontsize',12);
xlabel('频率(Hz)');
ylabel('倍频带声压级(dB)');
grid on;
hold on;
nr_num=nr(1,31);                                        %1000Hz对应的倍频带声压级
[NR_db,nr_num_]=NR(nr_num);
NR_c=[31.5,63.0,125.0,250.0,500.0,1000.0,2000.0,4000.0,8000.0];
plot(NR_c,NR_db,'b:o','LineWidth',1.5);
legend('倍频带声压级',sprintf('NR=%i 倍频带声压级限值',nr_num_));
set(gcf,'Position',[250,200,1200,500]);

