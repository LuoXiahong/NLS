function [u, iter] =  NLM_ECG(v, lambda, P , M)
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
iter = 0;
%% CALCULATION
for s=s1:s2
    Mult = 0;
    Z = 0;
    for t=s-M:s+M
       if(t>P && t<n-P+1)
           dist = 0;
           for d=-P:P
               dist = dist + (v(s+d) - v(t+d))^2;
               iter = iter+1;
           end
           w = exp(-dist/h);
           Mult = Mult+w*v(t);
           Z = Z + w;
       end
    end
    u(s) = Mult/(Z+eps);
end
end