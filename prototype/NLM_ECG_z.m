function [u] =  NLM_ECG_z(v, lambda, P , M)
%% Testing if $w(s,s) = \max_{t~=s,t\in N(s)) w(s,t)$ is giving better results
%% INIT
n = length(v);
L = 2*P+1;                          
h = 2*L*lambda^2;                   % denominator
u = zeros(n,1);
% Signal indexed with 1 to P+1 in estimation have the same values as
% denoised signal to simplify calculations
u(1:P) = v(1:P);
u(n-P+1:n) = v(n-P+1:n);
s1 = P+1; 
s2 = n-P;

%% CALCULATION
for s=s1:s2
    Mult = 0;
    Z = 0;
    for t=s-M:s+M
        w_max =0;
       if(t>P && t<n-P+1 && t~=s)
           dist = 0;
           for d=-P:P
               dist = dist + (v(s+d) - v(t+d))^2;
           end
           w = exp(-dist/h);
           w_max = max(w_max,w);
           Mult = Mult+w*v(t);
           Z = Z + w;
       end
    end
    Mult = Mult+w_max*v(s);
    Z = Z+w_max;
    u(s) = Mult/(Z+eps);
end
end