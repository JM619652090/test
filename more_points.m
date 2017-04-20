function Z=more_points(X,x_tmp,y_tmp,k)
[m,n]=size(X);
Z=zeros(m,n);
% Y=X;
% k=3;
interval=-(k-1)/2:(k-1)/2;
int_x=ones(k,1)*interval;  int_x=[int_x(1:floor(k*k/2)),int_x(ceil(k*k/2):end)];
int_y=interval'*ones(1,k); int_y=[int_y(1:floor(k*k/2)),int_y(ceil(k*k/2):end)];
% Y=zeros(m,n);
% Region_x=[0,-1,0,1,1,1,0,-1,-1];
% Region_y=[0,-1,-1,-1,0,1,1,1,0];
% Region_x=[0,0,0,-1,1];
% Region_y=[0,1,-1,0,0];
% for i = 1:m
%     for j = 1:n
%         if X(i,j)
% for s = 1:length(int_x)
for count = 1:k*k
    if x_tmp + int_x(count) > 0 && x_tmp + int_x(count) <= m && y_tmp + int_y(count) > 0 && y_tmp + int_y(count) <= n
        %         for j = 1:k
        %             if
%         Y(x_tmp + int_x(count),y_tmp + int_y(count)) = X(x_tmp + int_x(count),y_tmp + int_y(count));
        Z(x_tmp + int_x(count),y_tmp + int_y(count)) = 1;
        %             end
        %         end
    end
end
% end
%         end
%     end
% end


end