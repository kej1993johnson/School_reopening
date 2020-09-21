function [f] = seir_model_rhs(t, y, params)

S = y(1);
E = y(2);
I = y(3);
R = y(4);
cumI = y(5);


f = zeros(5,1); % need to return a column vector
alpha = params(1);
beta = params(2); 
gamma = params(3);
N = S+E+I+R;

f(1) = -beta*S*I./N;
f(2) = beta*S*I./N - alpha*E;
f(3) = alpha*E - gamma*I;
f(4) = gamma*I;
f(5) = alpha*E; % cumulative infections 
end

