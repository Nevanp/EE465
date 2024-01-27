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
w = kaiser(21, 2);
hsrrc_tx = rcosdesign(0.385, span, n_sps).*w';
H_hat_tx = freqz(hsrrc_tx,1,2*pi*f);

hsrrc_rx = rcosdesign(beta, span, n_sps);
H_hat_rx = freqz(hsrrc_rx,1,2*pi*f);
% Raised Cosine for comparison
hrc = conv(hsrrc_rx,hsrrc_rx);
H_hat_rc = freqz(hrc, 1, 2*pi*f);

x = [(1-2^-17) (1-2^-17) (1-2^-17) -1 -1 -1 -1 (1-2^-17) (1-2^-17) (1-2^-17) (1-2^-17) (1-2^-17) (1-2^-17) (1-2^-17) -1 -1 -1 -1 (1-2^-17) (1-2^-17) (1-2^-17)];
coef_scaled = hsrrc_tx/0.6846;
coef_verilog = ceil(coef_scaled*2^17);
a = round(round(conv(x,coef_verilog))/2*(1-2^-17))
coef_verilog = coef_verilog';
 
figure(1)
plot(f,20*log10(abs(H_hat_rx)/max(abs(H_hat_tx))),'r', ...
f,20*log10(abs(H_hat_tx)/max(abs(H_hat_tx))),'--b','LineWidth',2);
legend('Receiver','Transmitter');
ylabel('H_{hat}(\Omega) for RC and SRRC');
xlabel('\Omega');
grid;

figure(2)
plot(f,20*log10(abs(H_hat_rc)),'r', ...
f,20*log10(abs(H_hat_rx.*H_hat_tx)),'--b','LineWidth',2);
legend('Ideal','Convolved Tx/Rx');
ylabel('H_{hat}(\Omega) for RC and SRRC');
xlabel('\Omega');
grid;

figure(3)
plot(0:40,hrc,'r*', 0:40,conv(hsrrc_tx,hsrrc_rx),'bd', 'MarkerSize',8);
ylabel('h_{rc}[n] and h_{srrc}[n]');
legend('Ideal','Convolved Tx/Rx');
xlabel('n');
grid;


no_mult = 2.^(round(x.*new_coef')-17);

sum(abs(no_mult))
nm = round(conv(x,no_mult)*2^17)

