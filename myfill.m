function BW1=myfill(BW,count_no)
% clear;
% BW=[0 0 0 0 0 0 0;
%     0 0 0 0 0 0 0;
%     0 0 1 1 1 0 0;
%     0 0 1 0 1 0 0;
%     0 0 1 1 1 0 0;
%     0 0 0 0 0 0 0;
%     0 0 0 0 0 0 0]
[m,n]=size(BW);
BW1=BW;
% [x,y]=find(BW==0,1);
% x=4;y=4;
% tmp=ones(m,n);
% queue_head=1;       %����ͷ
% queue_tail=1;       %����β
neighbour=[-1 -1;-1 0;-1 1;0 -1;0 1;1 -1;1 0;1 1];  %�͵�ǰ����������ӵõ��˸���������
%neighbour=[-1 0;1 0;0 1;0 -1];     %�������õ�
% q(queue_tail,:)=[x y];
% queue_tail=queue_tail+1;
% [ser1 ser2]=size(neighbour);

% while queue_head~=queue_tail
%     pix=q(queue_head,:);
[x,y]=find(~BW);

for k = 1:length(x)
    x_tmp=x(k); y_tmp=y(k);
    count=0;
    for i=1:size(neighbour,1) % ����
        %     pix1=[x,y]+neighbour(i,:);
        pix1=x_tmp+neighbour(i,1); pix2=y_tmp+neighbour(i,2);
        if pix1>=1 && pix2>=1 &&pix1<=m && pix2<=n % �жϷ�Χ
            if BW(pix1,pix2)==1 %��1
                count=count+1;
            end
        end
    end
    if count >= count_no % �ж��Ƿ���Ҫ���1
        BW1(x_tmp,y_tmp)=1;
        %         q(queue_tail,:)=[pix1(1) pix1(2)];
        %         queue_tail=queue_tail+1;
    end
end

%     queue_head=queue_head+1;
% end

end