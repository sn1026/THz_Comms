close all;
clear, clc;
load('Data/molecular_absorption.mat');


%% A_abs (Problem 1a and 2a)
for i = 1:65537
    f_one(i) = f(i);
    A_abs_1(i) = 10*log10(1/exp(-k(i)*1));
    A_abs_10(i) = 10*log10(1/exp(-k(i)*10));
    A_abs_100(i) = 10*log10(1/exp(-k(i)*100));
    A_abs_16cm(i)   = 10*log10(1/exp(-k(i)*.16)); %%FOR PART 2
    scaled_f(i) = f_one(i)/(10^12);
end


figure;
plot(scaled_f,A_abs_1);
hold on;
plot(scaled_f,A_abs_10);
plot(scaled_f,A_abs_100);
hold off;

xlim([0.1 10]);
ylim([0 600]);
legend('r=1','r=10','r=100');
xlabel('Frequency [THz]');
ylabel('Molecular Absorption Loss [dB]');
title('Absorption Loss from 300GHz - 10THz');

figure;
plot(scaled_f,A_abs_1);
hold on;
plot(scaled_f,A_abs_10);
plot(scaled_f,A_abs_100);
hold off;

xlim([0.95 1.15]);
ylim([0 200]);
legend('r=1','r=10','r=100');
xlabel('Frequency [THz]');
ylabel('Molecular Absorption Loss [dB]');
title('Absorption Loss from 300GHz - 10THz');



%% A_spread  (Problem 1b)
for i = 1:65537
    A_spread_1(i) = 10*log10((16*pi^2*1^2*f_one(i)^2)/((3*10^8)^2));
    A_spread_10(i) = 10*log10((16*pi^2*10^2*f_one(i)^2)/((3*10^8)^2));
    A_spread_100(i) = 10*log10((16*pi^2*100^2*f_one(i)^2)/((3*10^8)^2));
    ant_size(i) = (3*10^8)/(2*f(i)); %% Utilizing lambda/2 as optimal antenna size
    
end

figure;
plot(scaled_f,A_spread_1);
hold on;
plot(scaled_f,A_spread_10);
plot(scaled_f,A_spread_100);
hold off;

xlim([0.1 10]);
legend('r=1','r=10','r=100');
xlabel('Frequency [THz]');
ylabel('Spreading Loss [dB]');
title('Spreading Loss from 300GHz - 10THz');

figure;
plot(scaled_f,ant_size);
xlim([0.1 10]);
legend('Dipole antenna');
xlabel('Frequency [THz]');
ylabel('Antenna Size');
title('Antenna from 100GHz - 10THz');


%% Path Loss  (Problem 1c)
for i = 1:65537
    Pathloss_1(i) = A_abs_1(i) + A_spread_1(i);
    Pathloss_10(i) = A_abs_10(i) + A_spread_10(i);
    Pathloss_100(i) = A_abs_100(i) + A_spread_100(i);
end


figure;
plot(scaled_f,Pathloss_1);
hold on;
plot(scaled_f,Pathloss_10);
plot(scaled_f,Pathloss_100);
hold off;

xlim([0.1 10]);
ylim([50 600]);
legend('r=1','r=10','r=100');
xlabel('Frequency [THz]');
ylabel('Path Loss [dB]');
title('Path Loss from 300GHz - 10THz');


pathLoss_300GHz_1 = interp1(f_one,Pathloss_1,300*10^9)
pathLoss_300GHz_10 = interp1(f_one,Pathloss_10,300*10^9)
pathLoss_300GHz_100 = interp1(f_one,Pathloss_100,300*10^9)

spreadLoss_2p4GHz_1 = 10*log10((16*pi^2*1^2*(2.4*10^9)^2)/((3*10^8)^2))
spreadLoss_2p4GHz_10 = 10*log10((16*pi^2*10^2*(2.4*10^9)^2)/((3*10^8)^2))
spreadLoss_2p4GHz_100 = 10*log10((16*pi^2*100^2*(2.4*10^9)^2)/((3*10^8)^2))

spreadLoss_60GHz_1 = 10*log10((16*pi^2*1^2*(60*10^9)^2)/((3*10^8)^2))
spreadLoss_60GHz_10 = 10*log10((16*pi^2*10^2*(60*10^9)^2)/((3*10^8)^2))
spreadLoss_60GHz_100 = 10*log10((16*pi^2*100^2*(60*10^9)^2)/((3*10^8)^2))

spreadLoss_200THz_1 = 10*log10((16*pi^2*1^2*(200*10^12)^2)/((3*10^8)^2))
spreadLoss_200THz_10 = 10*log10((16*pi^2*10^2*(200*10^12)^2)/((3*10^8)^2));
spreadLoss_200THz_100 = 10*log10((16*pi^2*100^2*(200*10^12)^2)/((3*10^8)^2))

%%%%%% =====================

%% Part 2
load('Data/channel.mat');

for i = 1:11
    A_abs_16cm_t(i) = interp1(f_one,A_abs_16cm,f(i));
    A_spread_16cm(i) = 10*log10((16*pi^2*.16^2*f(i)^2)/((3*10^8)^2));
    scaled_f16cm(i) = f(i)/(10^12);
    Pathloss_16cm_t(i) = A_abs_16cm_t(i) + A_spread_16cm(i);
end

figure;
plot(scaled_f16cm,Pathloss_16cm_t);
hold on;
scatter(scaled_f16cm, H);
hold off;

xlim([0.95 1.1]);
legend('16cm Theoretical','16cm Experimental');
xlabel('Frequency [THz]');
ylabel('Path Loss [dB]');
title('Path Loss from 300GHz - 10THz');
