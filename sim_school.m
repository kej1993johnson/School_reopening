function [I_t, cumI_t, detI_t, detcumI_t, tfirst, Ifirst, tclose, Iclose] = sim_school(I0,N,tvec, Reff,pSEIR, psym, tseek,tdelay,sens, close_thresh)

 % assume individuals are infectious for 7 days
alpha = pSEIR(1);
gamma = pSEIR(2);
beta = Reff*gamma;
params = [alpha,beta,gamma];
y0 = [N-I0 0 I0 0 0]; % corresponding to S0, E0, I0, R0

[y] = seir_model(tvec,y0, params);
I_t = y(:,3);
cumI_t = y(:,5);

detI_t = zeros(length(tvec),1);
detcumI_t = zeros(length(tvec),1);
dts = diff(tvec);
dt = dts(1);
tseek = tseek./dt;
tdelay = tdelay./dt;

for i = tseek+tdelay+1:length(tvec)
    detcumI_t(i) = psym*cumI_t(i-tseek-tdelay)*sens; % detected infections are those symptomatic, found X days later,
    % where X is the time to seek a test and then the delay in test results
    detI_t(i) = psym*I_t(i-tseek-tdelay)*sens; 
end

ifirst = find(detcumI_t>1,1);
tfirst = tvec(ifirst);
Ifirst = cumI_t(ifirst);

indclose = find((100*detcumI_t./N)>close_thresh,1);
tclose = tvec(indclose);
Iclose = cumI_t(indclose);


if isempty(Ifirst)
    Ifirst = NaN;
end
if isempty(tfirst)
    tfirst = NaN;
end

if isempty(Iclose)
    Iclose = NaN;
end
if isempty(tclose)
    tclose = NaN;
end















end