function y = accleration_velocity_displacement(x, fs, fl, fu, it)
    n = length(x);
    nfft = 2^nextpow2(n);
    c = 1; % 变换稀疏   g=9.8m/s2;
    y = fft(x, nfft);
    df = fs/nfft;
    ni = round(fl/df+1);
    na = round(fu/df+1);
    dw = 2*pi*df;
    w1 = 0:dw:2*pi*(0.5*fs);
    w2 = -2*pi*(0.5*fs-df):dw:-dw;
    w = [w1 w2];
    w = w.^it;
    a = zeros(1, nfft);
    a(2:nfft-1) = y(2:nfft-1)./w(2:nfft-1)';    
    if it == 2;
        y = -a;
    else 
        a1 = imag(a);
        a2 = real(a);
        y = a1-a2*i;
    end
    a = zeros(1, nfft);
    a(ni:na) = y(ni:na);
    a(nfft-na+1:nfft-ni+1) = y(nfft-na+1:nfft-ni+1);
    y = ifft(a, nfft);
    y = real(y(1:n))*c;
end
    