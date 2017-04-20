function II=cal_neighborhood(I,BWedge_index,k)
% I=zeros(5,5);
% I(1,1)=1;
[m,n]=size(I);
% k=3;
II=zeros(m*n,k*k);

interval=-(k-1)/2:(k-1)/2;
int_x=ones(k,1)*interval;
int_y=interval'*ones(1,k);

for i = 1:m
    for j = 1:n
        if BWedge_index(i,j)
            for t = 1:k*k
                if i + int_x(t) > 0 && i + int_x(t) <= m && j + int_y(t) > 0 && j + int_y(t) <= n
                    II(i + int_x(t) + (j + int_y(t)-1)*m,t) = I(i + int_x(t),j + int_y(t));
%                     II(i + int_x(t)+ (j + int_y(t)-1)*n,t) = 1;
                end
            end
        end
    end
end
II(:,[1,ceil(k*k/2)])=II(:,[ceil(k*k/2),1]);
[edge_x,edge_y]=find(BWedge_index==1);
edge_number=edge_x+(edge_y-1)*m;
II=II(edge_number,:);

