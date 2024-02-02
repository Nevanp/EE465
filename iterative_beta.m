clear all
%% Receiver circuit
f_s = 1;
len = 21;
M = len - 1;
n_sps = 4;
span = M/n_sps;
beta = 0.25;
fc = 1/(2*n_sps);
%% Transmitter circuit
df = 1/2000; % frequency increment in cycles/sample
f = [0:df:0.5-df/2]; % cycles/sample; 0 to almost 1/2

hsrrc_rx = firrcos(M,1/8,beta,1,'rolloff','sqrt');
hsrrc_rx = hsrrc_rx/sum(abs(hsrrc_rx));
H_hat_rx = freqz(hsrrc_rx,1,2*pi*f);
% Raised Cosine for comparison
hrc = conv(hsrrc_rx,hsrrc_rx);
H_hat_rc = freqz(hrc, 1, 2*pi*f);


% iterate window and beta
count = 1;
MER = 0;
for bet = 0.00:0.005:1
    for kis = 0:0.01:5
    count = count + 1;
    w = kaiser(21, kis);
    hsrrc_tx = firrcos(M,1/8,bet,1,'rolloff','sqrt').*w';
    H_hat_tx = freqz(hsrrc_tx,1,2*pi*f);
    %plot each iteration
    h_d = conv(hsrrc_tx,hsrrc_rx);
    err = 0;
    for i = 0:4
        err = err + (h_d(i*4+1))^2;
    end
    err = 2*err;
    MER_cur = max(abs(h_d).^2)/err;
    MER_cur = 10*log10(MER_cur);
    if MER_cur > MER
        stopband = max(abs(H_hat_tx(400:900)));
        passband = max(abs(H_hat_tx));
        atten = 20*log10(passband/stopband);
        if atten > 40
        MER = MER_cur;
        spec = strcat(num2str(bet),"/",num2str(kis));
        end
    end
    end
end

