% test tests 2
% Revision History
% Aug 17, 2017: Changed ``(length(f2)-1))'' to ''(length(f2)+1))
% in assignment statement Hrc_f(f2)=...
% (Due to Brian Daku)
%
clear all
% parameters for the filters
N_sps = 4; % number of samples per symbol
beta = 0.25; % roll off factor, script requires
             % beta be less than 1
N_rc = 41; % length of the impulse response
           % of the raised cosine filter
N_srrc = 21; % length of the impulse response of the
             % square root raised cosine filter
             
F_s = 1; % sampling rate in samples/second

f_6db = 1/2/N_sps; % 6 dB down point in cycles/sample
F_6db = F_s * f_6db; % 6 dB down point in Hz


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% time and frequency vectors
%
df = 1/2000; % frequency increment in cycles/sample
f = [0:df:0.5-df/2]; % cycles/sample; 0 to almost 1/2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% magnitude response for RC and SCCR filters
Hrc_f = zeros(1,length(f)); % reserve space for
% magnitude response of rc filter
Hsrrc_f = zeros(1,length(f)); % reserve space for
% magnitude response of srrc filter
f1 = find(f < f_6db*(1-beta)); % indices where
% H_f = 1
f2 = find( (f_6db*(1-beta)<= f) & ( f <=...
f_6db*(1+beta))); % indices where
% H_f is in transition
f3 = find(f > f_6db*(1+beta)); % indices where
% H_f = 0
Hrc_f(f1) = ones(1,length(f1));
Hrc_f(f2) = 0.5+0.5*cos(pi*(f2-f2(1))/(length(f2)-1));
Hrc_f(f3) = 0;

Hsrrc_f = sqrt(Hrc_f);
figure(1);
plot(f,(Hrc_f),'r', ...
f,(Hsrrc_f),'--b','LineWidth',2);
xlabel('frequency in cycles/sample')
ylabel('|H_{rc}(e^{2\pif})| and |H_{srrc}(e^{2\pif})|')
grid
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% find and plot the impulse response

h_rc=firrcos(N_rc-1,F_s/8,beta,F_s,'rolloff');
% impulse response of rc filter

h_srrc=firrcos(N_srrc-1,F_s/8,beta,F_s,'rolloff','sqrt');

% impulse response of srrc filter

figure(2)
plot(0:N_rc-1,h_rc,'r*', 0:N_srrc-1,h_srrc,'bd', 'MarkerSize',8);
ylabel('h_{rc}[n] and h_{srrc}[n]');
xlabel('n');
grid;

% set up window for srrc
w = kaiser(21, 3.9);
h_srrc_w = h_srrc.*w';

% Find and plot the frequency repsonses of the
% finite length RC and SRRC filters
H_hat_rc = freqz(h_rc,1,2*pi*f);
H_hat_srrc = freqz(h_srrc,1,2*pi*f);
H_hat_srrc_w = freqz(h_srrc_w,1,2*pi*f);

figure(3)
plot(f,20*log10(abs(H_hat_srrc)),'r', ...
f,20*log10(abs(H_hat_srrc_w)),'--b','LineWidth',2);
legend('No window','window');
ylabel('H_{hat}(\Omega) for RC and SRRC');
xlabel('\Omega');
grid;
