%[tm,sig]=rdsamp('mitdb/100',1);
load('ecg100.mat');
ecg100=sig(1:10000); %signal to denoise
x=1:length(ecg100);  % time samples


P = 10;      % patch half-width
M = 2000;    % neighbourhood search half-width

lambda = 0.6*0.02;

%% Denosing

tic;[u iter] = NLM_ECG(ecg100,lambda,P,M);toc;
% tic;u_z = NLM_ECG_z(ecg100,lambda,P,M);toc;

%% Plot results
figure(1);
% subplot(2,1,1);
plot(x,ecg100,'r');
hold on;
plot(x,u,'b')
xlabel('Numer próbki');
ylabel('mV');
title('Bez poprawki');
hold off;
%legend('Oryginalny sygna³','Sygna³ odszumiony');
% subplot(2,1,2);
% plot(x,ecg100,'r');
% hold on;
% plot(x,u_z,'b')
% xlabel('Numer próbki');
% ylabel('mV');
% title('Z poprawk¹');
% legend('Oryginalny sygna³','Sygna³ odszumiony');
% hold off;



