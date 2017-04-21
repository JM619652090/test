function T=find_thresh1(I,N_min)
N_max=max(max(I));
% N_min=700;
total_no=length(find(I >= N_min & I <= N_max));
tmpg=-1;
g=-1;
T = 0;
for i = N_min:N_max
    % N_tmp=110;
    index0=find(I >= N_min & I < i);
    index1=find(I >= i & I <= N_max);
    N0=length(index0);
    if(N0 == 0) 
        continue; 
    end
    N1=length(index1);
%     total_no=N0 + N1;
    w0 = N0/total_no;
    w1 = 1-w0;
    u0=sum(I(index0))/N0;
    u1=sum(I(index1))/N1;
    g = w0*w1*(u0-u1)*(u0-u1);
    if (tmpg < g)
        tmpg = g;
        T = i;
    end
end
