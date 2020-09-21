function [y] = seir_model(tspan,y0, params)
    S0 = y0(1);
    E0 = y0(2); 
    I0 = y0(3);
    R0 = y0(4); 
    cumI0 = y0(5);
    [t,y] = ode23s(@seir_model_rhs,tspan,y0,[],params);
end