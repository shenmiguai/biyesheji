function [output]=func(~,~,app)
            global starttime;
            global endtime;
            global SoundY;
            global SoundFFT;
            global SoundFs;
            global N
            global fc
            global oc6
            global nc
            global value; 
            starttime=starttime+N;
            endtime=endtime+N;
            y1=SoundY(starttime:endtime);%y是（1x4411）
%             sound(y1,SoundFs);        %starttime=246960
%             %endstime=251370      %sounddFs=44100
%             %N=4410
            tt=(starttime:endtime)/SoundFs;%tt=(1x4411)
            tt=tt'%tt=(4411x1)
 %  xjm        plot(app.TIMECH,tt,y1);drawnow;
            plot(tt,y1);drawnow;
%用 plot(x, y) 画图时,只要x和y有相同的元素个数,即便一个是列向量、
%一个是行向量，MATLAB 也会自动处理成《兼容》形状：
             
 %  xjm     app.Average.Value=mean(y1); 
 %  xjm     app.RMS.Value=rms(y1);
 %  xjm     app.Peak.Value=max(y1);
%  xjm      app.VPP.Value=peak2peak(y1);
            nfft = 2^nextpow2(N);
            SoundFFT=fft(y1,nfft);            
            ff=linspace(0,SoundFs/2,ceil(N/2));%ff=(1x2205)double
            ff=ff';%ff'=(2205x1)double  
            SoundA=2*abs(SoundFFT)/nfft;  %SoundFFT=(1x8192)  %nfft=8192个  %SoundA是取模，归一化，得到的线性尺度的幅度谱
            SoundA(1)=SoundA(1)/N; %SoundA是通过对FFT取模并归一化后得到的,线性尺度的幅度谱  %SoundA(1)直流分量在单边谱分析中的处理方式和其他频率分量不同。
%每次提取的y1都是新的数据段（新的时间窗口),所以它的内容在变，它的直流分量也就随之改变。
            Power=SoundA.*SoundA; %Power=(1x8192)
            Power=20*log10(Power);%dB单位的“功率谱”,也就是常说的“每个频率上能量有多大”。
            
            switch value
                case('功率谱')
%  xjm              plot(app.FANALYSIS,log10(ff),Power(1:ceil(N/2)));
                    plot(log10(ff),Power(1:ceil(N/2))); %因为 FFT 的结果是对称的，前半部分（从 0 到 N/2 的频率）包含了我们关心的主要信息，
                    %后半部分是前半部分的镜像，通常我们只取 前半部分的数据，也就是从 1 到 ceil(N/2) 的频率区间。
                    %从 Power 数组中取出从第 1 个到第 ceil(N/2) 个元素。
                    %也就是说，取出 频率从 0 Hz 到最大频率的一半 的功率值。
               
                case('幅频')%SoundA
%  xjm              plot(app.FANALYSIS,log10(ff),SoundA(1:ceil(N/2)));
                    plot(log10(ff),SoundA(1:ceil(N/2)));

                case('相频')%phase
                    ph = angle(SoundFFT)*180/pi;
%  xjm              plot(app.FANALYSIS,log10(ff),ph(1:ceil(N/2)));
                    plot(log10(ff),ph(1:ceil(N/2)));
                case('实频')
                    r=real(SoundFFT);
%  xjm              plot(app.FANALYSIS,log10(ff),r(1:ceil(N/2)));
                    plot(log10(ff),r(1:ceil(N/2)));                    
                case('虛频')
                    i=imag(SoundFFT);
%  xjm              plot(app.FANALYSIS,log10(ff),i(1:ceil(N/2)));
                    plot(log10(ff),i(1:ceil(N/2)));
            end
            drawnow;
             yc = zeros(1,nc); %计算倍频程谱  yc有50个 
                for j = 1:nc 
                    fl = fc(j)/oc6; % 下限频率 
                    fu = fc(j)*oc6; % 上限频率 
                    nl = round(fl*nfft/SoundFs+1); % 下限频率序号
                    nu = round(fu*nfft/SoundFs+1); % 上限频率序号 
                    
                    if fu > SoundFs/2 % 上限频率大于折叠频率 
                        m = j-1; 
                        break 
                    end 
                    % 以每个中心频率段为通带进行累加
                        b = zeros(1,nfft);
                        b(nl:nu) = SoundA(nl:nu);
                        b(nfft-nu+1:nfft-nl+1) = SoundA(nfft-nu+1:nfft-nl+1); 
                        yc(j) = sqrt(var(real(b(1:N))));%N=4410 %yc=RMS
                end 
                disp(m);%xjm
%xjm             bar(app.ONETHIRDANALYSIS,yc(13:m));drawnow;
%from_zhongyao   bar(fc(13:m),yc(13:m));%zhongyao_259行
%               xjm=yc(13:m);%33个
                bar(yc(13:m));drawnow; %强制 MATLAB 立即刷新图形窗口，更新绘图结果。           
                                
                Z=spectrogram(y1,2048,1024);%计算短时傅里叶变换
                Size=size(Z);
                P=20*log10(sqrt(Z.* conj(Z)));%复数矩阵 Z 转换为（dB）单位的幅度谱
                X=linspace(0,SoundFs/2, Size(1));X=X';%SoundFs=44100  %X的范围0~1
                Y=linspace(starttime/SoundFs,endtime/SoundFs, Size(2));Y=Y';
%xjm            surf(app.f_t_A,X,Y,P','FaceAlpha',0.3);drawnow;
                surf(X,Y,P','FaceAlpha',0.3);%将曲面图的表面设置为“30% 不透明”，也就是“70% 透明”。
                drawnow;               
%xjm            hold(app.f_t_A,"on");
        end