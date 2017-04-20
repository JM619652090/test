function boundary=myedge1(BW)
[m,n]=size(BW);
boundary=zeros(m,n);
Region_x=[0,-1,0,1,1,1,0,-1,-1];
Region_y=[0,-1,-1,-1,0,1,1,1,0];
for i =1:m
    for j=1:n
        if BW(i,j)
            for k = 1:length(Region_x)
                if i+Region_x(k) > 0 && i+Region_x(k) <= m && j+Region_y(k) > 0 && j+Region_y(k) <= n && ~BW(i+Region_x(k),j+Region_y(k))
                    boundary(i,j)=1;
                end
            end
        end
    end
end

end

