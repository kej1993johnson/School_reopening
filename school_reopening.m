% Futility of school reopening
% This script runs sim_school to project the spread of the epidemic in a
% congregate setting like a school, and what will be detected from that
% outbreak, how long it will take to detect it, and how large the outbreak
% will grow. 

close all; clear all; clc
%% Start with calling a function with:
% INPUTS: 
% initial condition (I0) 
% transmission rate (Reff)
% percent symptomatic (psym)
% time to seek testing if symptomatic (tseek) 
% time to get test results back (tdelay)
% threshold for closing based on detected case (close_thresh)
% OUTPUTS:
% % infected over time (I_t)
% % detected cases over time (detI_t)
% time to detect first case (tfirst)
% outbreak size at time of detection (Ifirst)
% time to close (tclose)
% outbreak size at time of closing (Iclose)
 
% Set parameters 
I0 =1; % number of initial infections in a school of 1,000
N = 1000;
Reff = 2.5; 
psym = 0.21;
tseek = 3;
tdelay = 4;
sens = 0.85;
close_thresh = 1;
tvec = 0:0.01:120;
tvec = tvec';
alpha = 1/3; % 1/latency
gamma = 1/14; % 1/infection duration 
pSEIR = [alpha, gamma];


[I_t,cumI_t, detI_t, detcumI_t, tfirst, Ifirst, tclose, Iclose] = sim_school(I0,N, tvec, Reff, pSEIR, psym, tseek,tdelay,sens, close_thresh); 
%%
I0vec = linspace(0.4, 25,6);
I0vec = [0.4, 1, 3, 5,10,25]; % corresponding to low, medium, and high prevalence
colorsets2 = colormap(prism(6));
colorsets2= flip(colorsets2,1);
for i = 1:length(I0vec)
    I0i=I0vec(i);
    [I_t,cumI_t, detI_t, detcumI_t, tfirst, Ifirst, tclose, Iclose] = sim_school(I0i,N,tvec, Reff,pSEIR, psym, tseek,tdelay,sens, close_thresh); 
    I_ti(:,i)=I_t;
    cumI_ti(:,i) = cumI_t;
    detI_ti(:,i)=detI_t;
    detcumI_ti(:,i) = detcumI_t;
    tfirsti(i) = tfirst;
    Ifirsti(i) = Ifirst;
    tclosei(i) = tclose;
    Iclosei(i) = Iclose;
end
% record continuous iterating through I0
I0veccont = linspace(0.4,25,60);
for i = 1:length(I0veccont)
    I0i=I0veccont(i);
    [I_t,cumI_t, detI_t, detcumI_t, tfirst, Ifirst, tclose, Iclose] = sim_school(I0i,N,tvec, Reff,pSEIR, psym, tseek,tdelay,sens, close_thresh); 
    tfirstci(i) = tfirst;
    Ifirstci(i) = Ifirst;
    tcloseci(i) = tclose;
    Icloseci(i) = Iclose;
end
% calculate upperbound (1 in 10 reporting rate)

for i = 1:length(I0veccont)
    I0i=I0veccont(i);
    Reffi = 3.5;
    [I_t,cumI_t, detI_t, detcumI_t, tfirst, Ifirst, tclose, Iclose] = sim_school(I0i,N,tvec, Reffi,pSEIR, psym, tseek,tdelay,sens, close_thresh); 
    tfirstupi(i) = tfirst;
    Ifirstupi(i) = Ifirst;
    tcloseupi(i) = tclose;
    Icloseupi(i) = Iclose;
end
% calculate lowerbound (1 in 3 reporting rate)
I0veclo = .6.*linspace(0.4,10,60);
for i = 1:length(I0veccont)
    I0i=I0veccont(i);
    Reffi = 2.2;
    [I_t,cumI_t, detI_t, detcumI_t, tfirst, Ifirst, tclose, Iclose] = sim_school(I0i,N,tvec, Reffi,pSEIR, psym, tseek,tdelay,sens, close_thresh); 
    tfirstloi(i) = tfirst;
    Ifirstloi(i) = Ifirst;
    tcloseloi(i) = tclose;
    Icloseloi(i) = Iclose;
end

%% 4 panel figure varying I0, looking at infections and time to close
figure;
subplot(1,2,1)
for i = 1:length(I0vec)
plot(tvec, 100.*cumI_ti(:,i)./N, '-', 'Linewidth',2, 'color', colorsets2(i,:))
%plot(tvec, 100.*10.*detI_ti(:,i)./N, '-', 'Linewidth',2, 'color', colorsets2(i,:))
hold on 
end
plot([30 30], [0 100], 'k-', 'LineWidth', 2)
i30 = find(tvec==30);
plot(30, 100*cumI_ti(i30,2)./N, 'r*' ,'LineWidth', 5)
xlabel('time (days)')
xlim([0 tvec(end)])
%ylim([0 50])
%ylabel('% of school quarantined')
ylabel('% of school infected')
legend('4 in 10,000','1 in 1000','3 in 1000', '5 in 1000', '10 in 1000','25 in 1000', 'Location', 'NorthWest')
legend boxoff
set(gca,'FontSize',18,'LineWidth',1.5)
%title('Percent quarantined')
title('Percent infected')

subplot(1,2,2)
plot(I0veccont, tcloseci, 'k-', 'LineWidth', 2)
hold on
plot(I0veccont, tcloseupi, 'k--', 'LineWidth',2)
plot(I0veccont, tcloseloi, 'k--', 'LineWidth',2)
for i =1:length(I0vec)
plot(I0vec(i), tclosei(i), '*', 'LineWidth', 4, 'color', colorsets2(i,:))
hold on
end
xlabel('Initial infections (out of 1000)')
ylabel('Time to close (days)')
set(gca,'FontSize',14,'LineWidth',1.5, 'Xscale', 'log')
title('Time to close')
ylim([0 max(tcloseloi)+1])
xlim([I0veccont(1) I0veccont(end)])

figure;
for i = 1:length(I0vec)
plot(I0vec(i), Ifirsti(i), '*', 'LineWidth', 10, 'color', colorsets2(i,:))
hold on
end
plot(I0veccont, Ifirstci, 'k-', 'LineWidth', 2)
hold on
plot(I0veccont, Ifirstupi, 'k--', 'LineWidth',2)
plot(I0veccont, Ifirstloi, 'k--', 'LineWidth',2)
hold on
for i = 1:length(I0vec)
plot(I0vec(i), Ifirsti(i), '*', 'LineWidth', 8, 'color', colorsets2(i,:))
hold on
end
xlabel('Initial infections (out of 1000)')
ylabel('Actual infections')
legend('4 in 10,000','1 in 1000','3 in 1000', '5 in 1000', '10 in 1000','25 in 1000', 'Location', 'NorthWest')
legend boxoff
set(gca,'FontSize',18,'LineWidth',1.5)
title('Effect of prevalence on infections at first case')
ylim([0 max(Ifirsti)+2])
xlim([I0veccont(1) I0veccont(end)])


figure;
for i = 1:length(I0vec)
%plot(tvec, 100.*cumI_ti(:,i)./N, '-', 'Linewidth',2, 'color', colorsets2(i,:))
plot(tvec, 100.*10.*detI_ti(:,i)./N, '-', 'Linewidth',2, 'color', colorsets2(i,:))
hold on 
end
xlabel('time (days)')
xlim([0 tvec(end)])
ylim([0 70])
ylabel('% of school quarantined')
%ylabel('% of school infected')
legend('4 in 10,000','1 in 1000','3 in 1000', '5 in 1000', '10 in 1000','25 in 1000', 'Location', 'NorthWest')
legend boxoff
set(gca,'FontSize',18,'LineWidth',1.5)
title('Percent quarantined for different initial prevalences')
%title('Percent infected')




%% 6 panel figure for supplement varying I0
colorsets3 = [0.6667 0 1;0 0.5 0; 1 0 0];
figure;
subplot(3,2,1)
for i = 1:length(I0vec)
plot(tvec, cumI_ti(:,i), '-', 'Linewidth',2, 'color', colorsets2(i,:))
hold on 
end
xlabel('time(days)')
xlim([0 tvec(end)])
ylim([0 0.5*N])
ylabel('Cumulative Infections')
legend('4 in 10,000','1 in 1000','3 in 1000', '5 in 1000', '7 in 1000', '10 in 1000', 'Location', 'NorthWest')
legend boxoff
set(gca,'FontSize',14,'LineWidth',1.5)
title('Total infections')

subplot(3,2,2)
for i = 1:length(I0vec) 
plot(tvec, detcumI_ti(:,i), '--', 'Linewidth',2, 'color', colorsets2(i,:))
hold on
end
plot([tvec(1) tvec(end)], [1 1], 'k--', 'LineWidth',2)
plot([tvec(1) tvec(end)], [close_thresh*N/100, close_thresh*N/100], 'k-', 'LineWidth',2)
xlabel('time(days)')
xlim([0 tvec(end)])
ylim([0 (close_thresh*N/100)+10])
ylabel('Detected Infections')
legend('4 in 10,000','1 in 1000','3 in 1000', '5 in 1000', '7 in 1000', '10 in 1000', 'Location', 'NorthEast')
legend boxoff
set(gca,'FontSize',14,'LineWidth',1.5)
title('Expected cumulative detected infections')

subplot(3,2,3)
plot(I0veccont, tfirstci, 'k-', 'LineWidth',2)
hold on
%plot(I0veccont, tfirstupi, 'k--', 'LineWidth',2)
%plot(I0veccont, tfirstloi, 'k--', 'LineWidth',2)
for i =1:length(I0vec)
plot(I0vec(i), tfirsti(i), '*', 'LineWidth', 4, 'color', colorsets2(i,:))
hold on
end
xlabel('Initial infections (out of 1000)')
ylabel('Time to first detected infection (days)')
set(gca,'FontSize',14,'LineWidth',1.5)
title('Time to first detected case')
ylim([0 max(tfirsti)+1])

subplot(3,2,4)
plot(I0veccont, Ifirstci, 'b-', 'LineWidth', 2)
hold on
%plot(I0veccont, Ifirstupi, 'b--', 'LineWidth',2)
%plot(I0veccont, Ifirstloi, 'b--', 'LineWidth',2)

for i = 1:length(I0vec)
plot(I0vec(i), Ifirsti(i), '*', 'LineWidth', 4, 'color', colorsets2(i,:))
hold on
end
xlabel('Initial infections (out of 1000)')
ylabel('Number of infections')
set(gca,'FontSize',14,'LineWidth',1.5)
title('Number of infections at first detected case')
ylim([0 max(Ifirsti)+1])

subplot(3,2,5)
plot(I0veccont, tcloseci, 'k-', 'LineWidth', 2)
hold on
%plot(I0veccont, tcloseupi, 'k--', 'LineWidth',2)
%plot(I0veccont, tcloseloi, 'k--', 'LineWidth',2)

for i =1:length(I0vec)
plot(I0vec(i), tclosei(i), '*', 'LineWidth', 4, 'color', colorsets2(i,:))
hold on
end
xlabel('Initial infections (out of 1000)')
ylabel('Time to close (days)')
set(gca,'FontSize',14,'LineWidth',1.5)
title('Time to close')
ylim([0 max(tclosei)+1])

subplot(3,2,6)
plot(I0veccont,Icloseci, 'b-', 'LineWidth',2)
hold on
%plot(I0veccont, Icloseupi, 'b--', 'LineWidth',2)
%plot(I0veccont, Icloseloi, 'b--', 'LineWidth',2)
for i = 1:length(I0vec)
plot(I0vec(i), Iclosei(i), '*', 'LineWidth', 4, 'color', colorsets2(i,:))
hold on
end
xlabel('Initial infections (out of 1000)')
ylabel('Number of infections')
set(gca,'FontSize',14,'LineWidth',1.5)
title('Number of infections at close')
ylim([0 max(Icloseupi)+10])

% Compare total infections to detected infections

figure;
subplot(1,2,1)
i = 3;
plot(tvec, cumI_ti(:,i), '-', 'Linewidth',2, 'color', colorsets2(2,:))
hold on
plot(tvec, detcumI_ti(:,i), '--', 'Linewidth',2, 'color', colorsets2(2,:))
plot([tvec(1) tvec(end)], [1 1], 'k--', 'LineWidth',2)
plot([tvec(1) tvec(end)], [close_thresh*N/100, close_thresh*N/100], 'k-', 'LineWidth',2)
plot([tfirsti(i) tfirsti(i)], [0 Ifirsti(i)], 'k-', 'LineWidth',2)
plot([tclosei(i) tclosei(i)], [0 Iclosei(i)], 'k-', 'LineWidth',2)
xlabel('time (days)')
xlim([0 tvec(end)])
ylim([0 135])
ylabel('Infections')
legend('True infections', 'Detected cases', 'Location', 'NorthWest')
legend boxoff
title('Relationship between true infections and detected cases')
set(gca,'FontSize',18,'LineWidth',1.5)

ifirst = find(detcumI_ti(:,i)>1,1);
subplot(1,2,2)
plot(tvec(ifirst:end)-tfirsti(i), cumI_ti(ifirst:end,i)./detcumI_ti(ifirst:end,i), '-', 'Linewidth',2, 'color', colorsets2(2,:))
hold on
xlabel('time since first detected case (days)')
xlim([0 tvec(end)-tfirsti(i)])
%ylim([0 6])
%ylim([0 (close_thresh*N/100)+35])
ylabel('True infections per detected case')
title('True infections per case detected')
set(gca,'FontSize',18,'LineWidth',1.5)


%%  Vary transmission rate
figure;
subplot(2,2,1)
for i = 1:length(I0vec)
plot(tvec, 100.*cumI_ti(:,i)./N, '-', 'Linewidth',2, 'color', colorsets2(i,:))
%plot(tvec, 100.*10.*detI_ti(:,i)./N, '-', 'Linewidth',2, 'color', colorsets2(i,:))
hold on 
end
xlabel('time (days)')
xlim([0 tvec(end)])
i30 = find(tvec==30);
%plot(30, 100*cumI_ti(i30,2)./N, 'r*' ,'LineWidth', 8)
%ylim([0 50])
%ylabel('% of school quarantined')
ylabel('% of school infected')
legend('4 in 10,000','1 in 1000','3 in 1000', '5 in 1000', '10 in 1000','25 in 1000', 'Location', 'NorthWest')
legend boxoff
set(gca,'FontSize',18,'LineWidth',1.5)
%title('Percent quarantined')
title('Effect of prevalence on percent infected')

subplot(2,2,2)
plot(I0veccont, tcloseci, 'k-', 'LineWidth', 2)
hold on
plot(I0veccont, tcloseupi, 'k--', 'LineWidth',2)
plot(I0veccont, tcloseloi, 'k--', 'LineWidth',2)
for i =1:length(I0vec)
plot(I0vec(i), tclosei(i), '*', 'LineWidth', 10, 'color', colorsets2(i,:))
hold on
end
xlabel('Initial infections (out of 1000)')
ylabel('Time to close (days)')
set(gca,'FontSize',18,'LineWidth',1.5, 'Xscale', 'log')
title('Effect of prevalence on time to close')
ylim([5 max(tcloseloi)+1])
xlim([I0veccont(1) I0veccont(end)])


I0 = 5; % national average prevalence
Reffvec = [1.5, 2.5, 3, 3.5, 4, 5 ]; % corresponding to low, medium, and high prevalence
for i = 1:length(Reffvec)
    Reffi=Reffvec(i);
    [I_t,cumI_t, detI_t, detcumI_t, tfirst, Ifirst, tclose, Iclose] = sim_school(I0,N,tvec, Reffi,pSEIR, psym, tseek,tdelay,sens, close_thresh); 
    I_ti(:,i)=I_t;
    cumI_ti(:,i) = cumI_t;
    detI_ti(:,i)=detI_t;
    detcumI_ti(:,i) = detcumI_t;
    cumcases(:,i) = detcumI_t;
    tfirsti(i) = tfirst;
    Ifirsti(i) = Ifirst;
    tclosei(i) = tclose;
    Iclosei(i) = Iclose;
end
% record continuous iterating through Reff
Reffveccont = linspace(1.5,5,60);
for i = 1:length(I0veccont)
    Reffi=Reffveccont(i);
    [I_t,cumI_t, detI_t, detcumI_t, tfirst, Ifirst, tclose, Iclose] = sim_school(I0,N,tvec, Reffi,pSEIR, psym, tseek,tdelay,sens, close_thresh); 
    tfirstci(i) = tfirst;
    Ifirstci(i) = Ifirst;
    tcloseci(i) = tclose;
    Icloseci(i) = Iclose;
end
% calculate upperbound (1 in 10 reporting rate)

for i = 1:length(Reffveccont)
    Reffi=Reffveccont(i);
    I0i = 2*I0;
    [I_t,cumI_t, detI_t, detcumI_t, tfirst, Ifirst, tclose, Iclose] = sim_school(I0i,N,tvec, Reffi,pSEIR, psym, tseek,tdelay,sens, close_thresh); 
    tfirstupi(i) = tfirst;
    Ifirstupi(i) = Ifirst;
    tcloseupi(i) = tclose;
    Icloseupi(i) = Iclose;
end
% calculate lowerbound (1 in 3 reporting rate)

for i = 1:length(I0veccont)
    Reffi=Reffveccont(i);
    I0i = 0.6*I0;
    [I_t,cumI_t, detI_t, detcumI_t, tfirst, Ifirst, tclose, Iclose] = sim_school(I0i,N,tvec, Reffi,pSEIR, psym, tseek,tdelay,sens, close_thresh); 
    tfirstloi(i) = tfirst;
    Ifirstloi(i) = Ifirst;
    tcloseloi(i) = tclose;
    Icloseloi(i) = Iclose;
end


% 2 panels below varying Reff

subplot(2,2,3)
for i = 1:length(Reffvec)
%plot(tvec, 100.*10.*detI_ti(:,i)./N, '-', 'Linewidth',2, 'color', colorsets2(i,:))
plot(tvec, 100.*cumI_ti(:,i)./N, '-', 'Linewidth',2, 'color', colorsets2(i,:))
hold on 
end
xlabel('time (days)')
xlim([0 tvec(end)])
%ylim([0 50])
ylabel('% of school infected')
%ylabel('% of school quarantined')
legend('R_0=1.5','R_0=2.5', 'R_0=3', 'R_0=3.5', 'R_0=4', 'R_0=5', 'Location', 'NorthWest')
legend boxoff
set(gca,'FontSize',18,'LineWidth',1.5)
title('Effect of R_0 on percent infected')
%title('Percent quarantined')
ylim([0 100])

subplot(2,2,4)
plot(Reffveccont, tcloseci, 'k-', 'LineWidth', 2)
hold on
plot(Reffveccont, tcloseupi, 'k--', 'LineWidth',2)
plot(Reffveccont, tcloseloi, 'k--', 'LineWidth',2)
for i =1:length(I0vec)
plot(Reffvec(i), tclosei(i), '*', 'LineWidth', 10, 'color', colorsets2(i,:))
hold on
end
xlabel('R_0')
ylabel('Time to close (days)')
set(gca,'FontSize',18,'LineWidth',1.5)
title('Effect of R_0 on time to close')
ylim([5 max(tcloseloi)+1])
xlim([Reffveccont(1) Reffveccont(end)])

figure;
for i = 1:length(Reffvec)
plot(Reffvec(i), Ifirsti(i), '*', 'LineWidth', 8, 'color', colorsets2(i,:))
hold on
end
plot(Reffveccont, Ifirstci, 'k-', 'LineWidth', 2)
hold on
plot(Reffveccont, Ifirstupi, 'k--', 'LineWidth',2)
plot(Reffveccont, Ifirstloi, 'k--', 'LineWidth',2)
hold on
for i = 1:length(Reffvec)
plot(Reffvec(i), Ifirsti(i), '*', 'LineWidth', 8, 'color', colorsets2(i,:))
hold on
end
xlabel('R_0')
ylabel('Actual infections')
set(gca,'FontSize',18,'LineWidth',1.5)
title('Effect of R_0 on infections at first case')
legend('R_0=1.5','R_0=2.5', 'R_0=3', 'R_0=3.5', 'R_0=4', 'R_0=5', 'Location', 'NorthWest')
legend boxoff
ylim([0 max(Ifirsti)+2])
xlim([Reffveccont(1) Reffveccont(end)])


figure;
for i = 1:length(Reffvec)
plot(tvec, 100.*10.*detI_ti(:,i)./N, '-', 'Linewidth',2, 'color', colorsets2(i,:))
%plot(tvec, 100.*cumI_ti(:,i)./N, '-', 'Linewidth',2, 'color', colorsets2(i,:))
hold on 
end
xlabel('time (days)')
xlim([0 tvec(end)])
%ylim([0 50])
%ylabel('% of school infected')
ylabel('% of school quarantined')
legend('R_0=2.2','R_0=2.5', 'R_0=3', 'R_0=3.5', 'R_0=4', 'R_0=5', 'Location', 'NorthWest')
legend boxoff
set(gca,'FontSize',18,'LineWidth',1.5)
%title('Total infections')
title('Percent quarantined for different R_0')
ylim([0 70])

%% 6 panel figure for supplement varying R0

figure;
subplot(3,2,1)
for i = 1:length(Reffvec)
plot(tvec, cumI_ti(:,i), '-', 'Linewidth',2, 'color', colorsets2(i,:))
hold on 
end
xlabel('time (days)')
xlim([0 tvec(end)])
ylim([0 0.5*N])
ylabel('Cumulative Infections')
legend('R_0=2.2','R_0=2.5', 'R_0=3', 'R_0=3.5', 'R_0=4', 'R_0=5', 'Location', 'NorthWest')
legend boxoff
set(gca,'FontSize',14,'LineWidth',1.5)
title('Total infections')

subplot(3,2,2)
for i = 1:length(Reffvec) 
plot(tvec, detcumI_ti(:,i), '--', 'Linewidth',2, 'color', colorsets2(i,:))
hold on
end
plot([tvec(1) tvec(end)], [1 1], 'k--', 'LineWidth',2)
plot([tvec(1) tvec(end)], [close_thresh*N/100, close_thresh*N/100], 'k-', 'LineWidth',2)
xlabel('time(days)')
xlim([0 tvec(end)])
ylim([0 (close_thresh*N/100)+10])
ylabel('Detected Infections')
legend('R_0=2.2','R_0=2.5', 'R_0=3', 'R_0=3.5', 'R_0=4', 'R_0=5', 'Location', 'NorthEast')
legend boxoff
set(gca,'FontSize',14,'LineWidth',1.5)
title('Expected cumulative detected infections')

subplot(3,2,3)
plot(Reffveccont, tfirstci, 'k-', 'LineWidth',2)
hold on
%plot(I0veccont, tfirstupi, 'k--', 'LineWidth',2)
%plot(I0veccont, tfirstloi, 'k--', 'LineWidth',2)
for i =1:length(Reffvec)
plot(Reffvec(i), tfirsti(i), '*', 'LineWidth', 4, 'color', colorsets2(i,:))
hold on
end
xlabel('Initial infections (out of 1000)')
ylabel('Time to first detected infection (days)')
set(gca,'FontSize',14,'LineWidth',1.5)
title('Time to first detected case')
ylim([0 max(tfirsti)+1])

subplot(3,2,4)
plot(Reffveccont, Ifirstci, 'b-', 'LineWidth', 2)
hold on
%plot(I0veccont, Ifirstupi, 'b--', 'LineWidth',2)
%plot(I0veccont, Ifirstloi, 'b--', 'LineWidth',2)

for i = 1:length(I0vec)
plot(Reffvec(i), Ifirsti(i), '*', 'LineWidth', 4, 'color', colorsets2(i,:))
hold on
end
xlabel('R_0')
ylabel('Number of infections at first detected case')
set(gca,'FontSize',14,'LineWidth',1.5)
title('Number of infections when first case is detected')
ylim([0 max(Ifirsti)+1])

subplot(3,2,5)
plot(Reffveccont, tcloseci, 'k-', 'LineWidth', 2)
hold on
%plot(I0veccont, tcloseupi, 'k--', 'LineWidth',2)
%plot(I0veccont, tcloseloi, 'k--', 'LineWidth',2)

for i =1:length(Reffvec)
plot(Reffvec(i), tclosei(i), '*', 'LineWidth', 4, 'color', colorsets2(i,:))
hold on
end
xlabel('R_0')
ylabel('Time to close (days)')
set(gca,'FontSize',14,'LineWidth',1.5)
title('Time to close')
ylim([0 max(tclosei)+1])

subplot(3,2,6)
plot(Reffveccont,Icloseci, 'b-', 'LineWidth',2)
hold on
%plot(I0veccont, Icloseupi, 'b--', 'LineWidth',2)
%plot(I0veccont, Icloseloi, 'b--', 'LineWidth',2)
for i = 1:length(I0vec)
plot(Reffvec(i), Iclosei(i), '*', 'LineWidth', 4, 'color', colorsets2(i,:))
hold on
end
xlabel('R_0')
ylabel('Number of infections at time of close')
set(gca,'FontSize',14,'LineWidth',1.5)
title('Number of infections at time of close')
ylim([0 max(Icloseupi)+10])
%% Heatmaps of transmission vs initial prevalence colored by time to close
I0vec =linspace(0.1, 10,40);
Reffvec = linspace(1.1, 5,40);
tvec = 0:0.1:200;
[REFF,INIT] = meshgrid(Reffvec, I0vec); % big ol grid of parameters
REFFflat = reshape(REFF,1,[]);
INITflat = reshape(INIT,1, []);


for i = 1:length(REFFflat)
    Reffi = REFFflat(i);
    I0i = INITflat(i);
    [I_t,cumI_t, detI_t, detcumI_t, tfirst, Ifirst, tclose, Iclose] = sim_school(I0i,N,tvec, Reffi,pSEIR, psym, tseek,tdelay,sens, close_thresh); 
    tfirstj(i) = tfirst;
    if isnan(tfirst);
        tfirstj(i) = 180;
    end
    Ifirstj(i) = Ifirst;
    if isnan(Ifirst)
        ifirstj(i)=1;
    end
    tclosej(i) = tclose;
    if isnan(tclose)
        tclosej(i)=180;
    end
    Iclosej(i) = Iclose;
    if isnan(Iclose)
        Iclosej(i) = cumI_t(end);
    end
end


 TFIRST = reshape(tfirstj, size(REFF));
 IFIRST = reshape(Ifirstj, size(REFF));
 TCLOSE = reshape(tclosej, size(REFF));
 ICLOSE = reshape(Iclosej, size(REFF));
 
%% Plot the heatmaps
figure;
subplot(1,2,2)
minmax = @(x)([min(x) max(x)]);
imagesc(minmax(1*(Reffvec)),minmax(I0vec),TCLOSE);
V = linspace(0,100,11);
V2 = horzcat(linspace(0,15,4), linspace(20,100,9));
[C,h]=contourf(REFF,INIT,TCLOSE); clabel(C,h);
[C2,h2]=contourf(REFF,INIT,TCLOSE, V2); 
clabel(C2,h2);
[x,y,z] = C2xyz(C);
j=find(z==100);
R0crit=cell2mat(x(j));
I0crit =cell2mat(y(j));
%imagesc(minmax(1*(Reffvec)),minmax(I0vec),TCLOSE);
hold on
plot(x{j}, y{j}, 'w-', 'LineWidth', 5)
colorbar
colormap(flipud(jet)); 
caxis([7 100])
xlabel('R_0');
ylabel('Initial infected out of 1000');
title('Time to close (days)')
set(gca,'FontSize',20,'LineWidth',1.5)

subplot(1,2,1)
imagesc(minmax(1*(Reffvec)),minmax(I0vec),TFIRST);
%imagesc(minmax(1*(alphav)),minmax(tremv),PCTINF);
V = linspace(0, 100, 11);
[C,h]=contourf(Reffvec,I0vec,TFIRST, V2); clabel(C,h);
%imagesc(minmax(1*(Reffvec)),minmax(I0vec),TFIRST);
colorbar
colormap(flipud(jet)); 
caxis([7 100])
xlabel('R_0');
ylabel('Initial infected out of 1000');
title('Time to first detected case (days)')
set(gca,'FontSize',20,'LineWidth',1.5)

%%
figure;
subplot(1,2,1)
imagesc(minmax(1*(Reffvec)),minmax(I0vec),IFIRST);
%imagesc(minmax(1*(alphav)),minmax(tremv),PCTINF);
[C,h]=contourf(Reffvec,I0vec,IFIRST); clabel(C,h);
colorbar
colormap(jet); 
xlabel('School R_0');
ylabel('Initial infected out of 1000');
title('Number infected out of 1000 at first detected case')
set(gca,'FontSize',18,'LineWidth',1.5)

% Make heatmap of number of additional community cases


%
Casesvec = linspace(10,900, 17);
Rtvec = linspace(0.8, 1.3,17);
tvec = 0:1:100;
[CASES, RT] = meshgrid(Casesvec,Rtvec); % big ol grid of parameters
RTflat = reshape(RT,1,[]);
CASESflat = reshape(CASES,1, []);

Tg = 13;
Ncom = 1e7;
n_intervals = 100./Tg;

for i = 1:length(RTflat)
    RTi = RTflat(i);
    CASESi = CASESflat(i);
    addcases = [];
    for j = 1:floor(n_intervals)
    addcases(1) = CASESi.*RTi;
    addcases(j+1) = addcases(j).*RTi;
    end
    addcases(floor(n_intervals)+1) = addcases(end)*(n_intervals-floor(n_intervals)).*RTi;
    newcases = sum(addcases);
    
    %newcases = CASESi.* RTi.^(100./Tg);
    tvec = 0:0.01:100;
    [I_t,cumI_t, ~, ~, ~,~, ~, ~] = sim_school(CASESi,Ncom,tvec, RTi,pSEIR, psym, tseek,tdelay,sens, close_thresh); 
    ADDCASESSEIRi(i) = cumI_t(end);
    ADDCASESi(i)= newcases;
end

ADDCASES = reshape(ADDCASESi, size(RT));
ADDCASESSEIR = reshape(ADDCASESSEIRi, size(RT));








subplot(1,2,2)
minmax = @(x)([min(x) max(x)]);
imagesc(minmax(Casesvec),minmax(Rtvec),ADDCASESSEIR);
V = linspace(0,24000,25);
[C,h]=contourf(Rtvec,Casesvec, ADDCASESSEIR,V); 
clabel(C,h);
colorbar
colormap(jet); 
ylabel('Cases seeded by school');
xlabel('Community R_{t}');
title('Additional community cases')
set(gca,'FontSize',18,'LineWidth',1.5)
%%
figure;
minmax = @(x)([min(x) max(x)]);
imagesc(minmax(Casesvec),minmax(Rtvec),ADDCASES);
V = linspace(0,24000,25)
[C,h]=contourf(Casesvec,Rtvec,ADDCASES, V); clabel(C,h);
colorbar
colormap(jet); 
xlabel('Cases caused by school');
ylabel('Community R_{t}');
title('Additional community cases')
set(gca,'FontSize',14,'LineWidth',1.5)

%% Zoom in on safe reopening scenarios
%I0vec =linspace(0.1, 10,20);
%Reffvec = linspace(1.3, 5,20);
I0vec =linspace(0.1, 8,40);
Reffvec = linspace(1.3, 2,40);
tvec = 0:0.1:200;
[REFF,INIT] = meshgrid(Reffvec, I0vec); % big ol grid of parameters
REFFflat = reshape(REFF,1,[]);
INITflat = reshape(INIT,1, []);


for i = 1:length(REFFflat)
    Reffi = REFFflat(i);
    I0i = INITflat(i);
    [I_t,cumI_t, detI_t, detcumI_t, tfirst, Ifirst, tclose, Iclose] = sim_school(I0i,N,tvec, Reffi,pSEIR, psym, tseek,tdelay,sens, close_thresh); 
     tfirstj(i) = tfirst;
    if isnan(tfirst);
        tfirstj(i) = 180;
    end
    Ifirstj(i) = Ifirst;
    if isnan(Ifirst)
        ifirstj(i)=1;
    end
    tclosej(i) = tclose;
    if isnan(tclose)
        tclosej(i)=180;
    end
    Iclosej(i) = Iclose;
    if isnan(Iclose)
        Iclosej(i) = cumI_t(end);
    end
end
 TFIRST = reshape(tfirstj, size(REFF));
 IFIRST = reshape(Ifirstj, size(REFF));
 TCLOSE = reshape(tclosej, size(REFF));
 ICLOSE = reshape(Iclosej, size(REFF));
 
% Plot the heatmaps
figure;

minmax = @(x)([min(x) max(x)]);
imagesc(minmax(1*(Reffvec)),minmax(I0vec),TCLOSE);
%imagesc(minmax(1*(alphav)),minmax(tremv),PCTINF);
[C,h]=contourf(REFF,INIT,TCLOSE); clabel(C,h);
[x,y,z] = C2xyz(C);
j=find(z==100);
R0crit=cell2mat(x(j));
I0crit =cell2mat(y(j));
hold on
plot(x{j}, y{j}, 'k-', 'LineWidth', 3)
colorbar
colormap(flipud(jet)); 
caxis([0 180])
xlabel('R_0');
ylabel('Initial infected out of 1000');
title('Time to close (days)')
set(gca,'FontSize',18,'LineWidth',1.5)

%% Scenarios
% K-12 high (25) medium (5) low prevalence(0.5), low resources R0=3(2.5,3.5),

% K-12 high medium low prevalence, high testing R0 = 1.5(1.2, 1.8)

% University national prevalence, low resources
% University national prevalence, high resources

% K-12 Public school low prevalence
psym = 0.2;
tdelay = 4;
N=1000;
I0i= 25;
I0hi = 2*I0i;
I0lo = 0.6*I0i;
Reffi= 3;
Reffhi = 3.5;
Refflo = 2.5;
[~,~, ~, ~, tfirst, Ifirst, tclose, Iclose] = sim_school(I0i,N,tvec, Reffi,pSEIR, psym, tseek,tdelay,sens, close_thresh);
[~,~, ~, ~, tfirsthi, Ifirsthi, tclosehi, Iclosehi] = sim_school(I0hi,N,tvec, Reffhi,pSEIR, psym, tseek,tdelay,sens, close_thresh);
[~,~, ~, ~, tfirstlo, Ifirstlo, tcloselo, Icloselo] = sim_school(I0lo,N,tvec, Refflo,pSEIR, psym, tseek,tdelay,sens, close_thresh);

matrix = zeros(8, 18);

matrix(1,:) = [Reffi, Refflo, Reffhi, I0i, I0lo, I0hi, tfirst, tfirstlo, tfirsthi, Ifirst, Ifirstlo, Ifirsthi, tclose, tcloselo, tclosehi, Iclose, Icloselo, Iclosehi];

% Public school medium prevalence
N=1000;
I0i= 5;
I0hi = 2*I0i;
I0lo = 0.6*I0i;
Reffi= 3;
Reffhi = 3.5;
Refflo = 2.5;
[~,~, ~, ~, tfirst, Ifirst, tclose, Iclose] = sim_school(I0i,N,tvec, Reffi,pSEIR, psym, tseek,tdelay,sens, close_thresh);
[~,~, ~, ~, tfirsthi, Ifirsthi, tclosehi, Iclosehi] = sim_school(I0hi,N,tvec, Reffhi,pSEIR, psym, tseek,tdelay,sens, close_thresh);
[~,~, ~, ~, tfirstlo, Ifirstlo, tcloselo, Icloselo] = sim_school(I0lo,N,tvec, Refflo,pSEIR, psym, tseek,tdelay,sens, close_thresh);
matrix(2,:) = [Reffi, Refflo, Reffhi, I0i, I0lo, I0hi, tfirst, tfirstlo, tfirsthi, Ifirst, Ifirstlo, Ifirsthi, tclose, tcloselo, tclosehi, Iclose, Icloselo, Iclosehi];

% Public school low prevalence
N=1000;
I0i= 0.5;
I0hi = 2*I0i;
I0lo = 0.6*I0i;
Reffi= 3;
Reffhi = 3.5;
Refflo = 2.5;
[~,~, ~, ~, tfirst, Ifirst, tclose, Iclose] = sim_school(I0i,N,tvec, Reffi,pSEIR, psym, tseek,tdelay,sens, close_thresh);
[~,~, ~, ~, tfirsthi, Ifirsthi, tclosehi, Iclosehi] = sim_school(I0hi,N,tvec, Reffhi,pSEIR, psym, tseek,tdelay,sens, close_thresh);
[~,~, ~, ~, tfirstlo, Ifirstlo, tcloselo, Icloselo] = sim_school(I0lo,N,tvec, Refflo,pSEIR, psym, tseek,tdelay,sens, close_thresh);
matrix(3,:) = [Reffi, Refflo, Reffhi, I0i, I0lo, I0hi, tfirst, tfirstlo, tfirsthi, Ifirst, Ifirstlo, Ifirsthi, tclose, tcloselo, tclosehi, Iclose, Icloselo, Iclosehi];

%Private local school high prevalence
tdelay =2;
N=1000;
I0i= 25;
I0hi = 2*I0i;
I0lo = 0.6*I0i;
Reffi= 1.5;
Reffhi = 1.8;
Refflo = 1.2;
[~,~, ~, ~, tfirst, Ifirst, tclose, Iclose] = sim_school(I0i,N,tvec, Reffi,pSEIR, psym, tseek,tdelay,sens, close_thresh);
[~,~, ~, ~, tfirsthi, Ifirsthi, tclosehi, Iclosehi] = sim_school(I0hi,N,tvec, Reffhi,pSEIR, psym, tseek,tdelay,sens, close_thresh);
[~,~, ~, ~, tfirstlo, Ifirstlo, tcloselo, Icloselo] = sim_school(I0lo,N,tvec, Refflo,pSEIR, psym, tseek,tdelay,sens, close_thresh);
row = [Reffi, Refflo, Reffhi, I0i, I0lo, I0hi, tfirst, tfirstlo, tfirsthi, Ifirst, Ifirstlo, Ifirsthi, tclose, tcloselo, tclosehi, Iclose, Icloselo, Iclosehi];
matrix(4,:) = row;

%Private local school in NE (i.e. NH) with lots of testing resources
N=1000;
I0i= 5;
I0hi = 2*I0i;
I0lo = 0.6*I0i;
Reffi= 1.5;
Reffhi = 1.8;
Refflo = 1.2;
[~,~, ~, ~, tfirst, Ifirst, tclose, Iclose] = sim_school(I0i,N,tvec, Reffi,pSEIR, psym, tseek,tdelay,sens, close_thresh);
[~,~, ~, ~, tfirsthi, Ifirsthi, tclosehi, Iclosehi] = sim_school(I0hi,N,tvec, Reffhi,pSEIR, psym, tseek,tdelay,sens, close_thresh);
[~,~, ~, ~, tfirstlo, Ifirstlo, tcloselo, Icloselo] = sim_school(I0lo,N,tvec, Refflo,pSEIR, psym, tseek,tdelay,sens, close_thresh);
row = [Reffi, Refflo, Reffhi, I0i, I0lo, I0hi, tfirst, tfirstlo, tfirsthi, Ifirst, Ifirstlo, Ifirsthi, tclose, tcloselo, tclosehi, Iclose, Icloselo, Iclosehi];
matrix(5,:) = row;

% Private local school in South (i.e. MS)
N=1000;
I0i= 0.5;
I0hi = 2*I0i;
I0lo = 0.6*I0i;
Reffi= 1.5;
Reffhi = 1.8;
Refflo = 1.2;
[~,~, ~, ~, tfirst, Ifirst, tclose, Iclose] = sim_school(I0i,N,tvec, Reffi,pSEIR, psym, tseek,tdelay,sens, close_thresh);
[~,~, ~, ~, tfirsthi, Ifirsthi, tclosehi, Iclosehi] = sim_school(I0hi,N,tvec, Reffhi,pSEIR, psym, tseek,tdelay,sens, close_thresh);
[~,~, ~, ~, tfirstlo, Ifirstlo, tcloselo, Icloselo] = sim_school(I0lo,N,tvec, Refflo,pSEIR, psym, tseek,tdelay,sens, close_thresh);
matrix(6,:) = [Reffi, Refflo, Reffhi, I0i, I0lo, I0hi, tfirst, tfirstlo, tfirsthi, Ifirst, Ifirstlo, Ifirsthi, tclose, tcloselo, tclosehi, Iclose, Icloselo, Iclosehi];

% College with lots of resources for testing
% Assume that tdelay is lower and the psym is higher

N=20000;
I0i= 100;
I0hi = 2*I0i;
I0lo = 0.6*I0i;
Reffi= 1.5;
Reffhi = 1.8;
Refflo = 1.2;
tdelay = 2;
psym = (0.6.*0.6)+ (0.2.*0.4); % weighted average of 18 & 19 year olds, 20, 21, 22, and 23 y.os
[~,~, ~, ~, tfirst, Ifirst, tclose, Iclose] = sim_school(I0i,N,tvec, Reffi,pSEIR, psym, tseek,tdelay,sens, close_thresh);
[~,~, ~, ~, tfirsthi, Ifirsthi, tclosehi, Iclosehi] = sim_school(I0hi,N,tvec, Reffhi,pSEIR, psym, tseek,tdelay,sens, close_thresh);
[~,~, ~, ~, tfirstlo, Ifirstlo, tcloselo, Icloselo] = sim_school(I0lo,N,tvec, Refflo,pSEIR, psym, tseek,tdelay,sens, close_thresh);
matrix(7,:) = [Reffi, Refflo, Reffhi, I0i, I0lo, I0hi, tfirst, tfirstlo, tfirsthi, Ifirst, Ifirstlo, Ifirsthi, tclose, tcloselo, tclosehi, Iclose, Icloselo, Iclosehi];

% College with limited resources
N=20000;
I0i= 100;
I0hi = 2*I0i;
I0lo = 0.6*I0i;
Reffi= 3;
Reffhi = 3.5;
Refflo = 2.5;
[~,~, ~, ~, tfirst, Ifirst, tclose, Iclose] = sim_school(I0i,N,tvec, Reffi,pSEIR, psym, tseek,tdelay,sens, close_thresh);
[~,~, ~, ~, tfirsthi, Ifirsthi, tclosehi, Iclosehi] = sim_school(I0hi,N,tvec, Reffhi,pSEIR, psym, tseek,tdelay,sens, close_thresh);
[~,~, ~, ~, tfirstlo, Ifirstlo, tcloselo, Icloselo] = sim_school(I0lo,N,tvec, Refflo,pSEIR, psym, tseek,tdelay,sens, close_thresh);
matrix(8,:) = [Reffi, Refflo, Reffhi, I0i, I0lo, I0hi, tfirst, tfirstlo, tfirsthi, Ifirst, Ifirstlo, Ifirsthi, tclose, tcloselo, tclosehi, Iclose, Icloselo, Iclosehi];
%% Example of infections versus detected cases
N=1000;
I0i= 5; % 5% prevalence, no entry testing 
I0hi = 2*I0i;
I0lo = 0.6*I0i;
Reffi= 3;
Reffhi = 3.5;
Refflo = 2.5;
 
[I_t,cumI_t, detI_t, detcumI_t, tfirst, Ifirst, tclose, Iclose] = sim_school(I0i,N,tvec, Reffi,pSEIR, psym, tseek,tdelay,sens, close_thresh)
[~,~, ~, detcumI_thi, tfirsthi, Ifirsthi, tclosehi, Iclosehi] = sim_school(I0hi,N,tvec, Reffhi,pSEIR, psym, tseek,tdelay,sens, close_thresh);
[~,~, ~, detcumI_tlo, tfirstlo, Ifirstlo, tcloselo, Icloselo] = sim_school(I0lo,N,tvec, Refflo,pSEIR, psym, tseek,tdelay,sens, close_thresh);

figure;
hold on
plot(tvec(1:800), detcumI_t(1:800)*N/100, 'k-', 'LineWidth', 2)
plot(tvec(1:800), detcumI_thi(1:800)*N/100, 'k--', 'LineWidth', 2)
plot(tvec(1:800), detcumI_tlo(1:800)*N/100, 'k--', 'LineWidth', 2)
xlabel('time (days)')
ylabel('Detected cases')
title('UNC: first 8 days')
set(gca,'FontSize',14,'LineWidth',1.5)