function [center,U,obj_fcn,new_data]=fcm2window(I,BWedge_index,k2)

% [m,n] = size(I);
data=cal_neighborhood(I,BWedge_index,k2);
new_data=data(:,1);

options = [2;1000;1e-5;0]; cluster_n=2;

expo = options(1);		% Exponent for U
max_iter = options(2);		% Max. iteration
min_impro = options(3);		% Min. improvement
display = options(4);		% Display info or not;

obj_fcn = zeros(max_iter, 1); % Array for objective function

U = initfcm(cluster_n, size(data,1));			% Initial fuzzy partition

% Main loop
for i = 1:max_iter,
	[U, center, obj_fcn(i)] = mystepfcm1(data, U, cluster_n, expo,k2);
	if display, 
		fprintf('Iteration count = %d, obj. fcn = %f\n', i, obj_fcn(i));
	end
	% check termination condition
	if i > 1,
		if abs(obj_fcn(i) - obj_fcn(i-1)) < min_impro, break; end,
	end
end

iter_n = i;	% Actual number of iterations 
obj_fcn(iter_n+1:max_iter) = [];




end