function [U_new, center, obj_fcn] = mystepfcm1(data, U, cluster_n, expo,k)
%STEPFCM One step in fuzzy c-mean clustering.

mf = U.^expo;       % MF matrix after exponential modification

% center = mf*data./((ones(size(data, 2), 1)*sum(mf'))'); % new center % vi
% k=5; 
a=0.85; 
N=k^2;
center_1 = mf*data(:,1) + sum(mf*data(:,2:end)*a/N,2);         % new center % vi(cl)
center_2 = (1+a)*(ones(size(data(:,1), 2), 1)*sum(mf'))'; 
center=center_1./center_2;

dist = distfcm(center,data(:,1));       % fill the distance matrix 计算距离矩阵 
dist_others=zeros(size(dist));
for i = 2:N
    dist_tmp = distfcm(center,data(:,i));
    dist_others = dist_others + dist_tmp.*dist_tmp;
end

% obj_fcn = sum(sum((dist.^2).*mf));  % objective function 目标函数
obj_fcn = sum(sum(dist.*dist.*mf))+sum(sum(dist_others.*mf))*a/N;  % objective function 目标函数

% tmp = dist.^(-2/(expo-1));      % calculate new U, suppose expo != 1 % ui
% U_new = tmp./(ones(cluster_n, 1)*sum(tmp));
U_tmp1 = (dist.*dist + dist_others*a/N).^(-1/(expo-1));      % calculate new U, suppose expo != 1 % ui
U_tmp2 = (ones(cluster_n, 1)*sum(U_tmp1));
U_new = U_tmp1./U_tmp2;

end
