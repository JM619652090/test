clear;
% close all;
tic
Img=dicomread(dicominfo(strcat('.\Wang\',num2str(67),'.dcm'))); % num2str(50)
% Img=dicomread(dicominfo(strcat('.\Wang\',num2str(50),'.dcm'))); 

I=double(Img); % ����Ϊpixelֵ
% figure(3);imshow(I,[]);    title('��ʼͼ��');
% RescaleIntercept=-1024;
% RescaleSlope=1;
% I=I*RescaleSlope+RescaleIntercept; % ����ֵתCTֵ
I1=My_foo3(I); % valley-emphasized image ���������õĳ�ʼ�߽�
% I1=I;
% [m,n] = size(I1);
% figure(4);imshow(I1,[]); title('valley-emphasized image');
thresh1=120+1024;
% N_min=700;
% thresh1=find_thresh1(I1,N_min);
% thresh1=1100;
% I1=imcrop(I1,[]);
% thresh1=max(max(I1))*graythresh(I1/max(max(I1)))+1024;
BW2=(I1>thresh1); % ��ֵ��
% figure(5);imshow(BW2,[]); title('��ֵ��ͼ��');

% SE=strel('disk',1);

% BW3=imclose(BW2,SE);
% BW3=myfill(BW3,1);
% BW3=myfill(BW3,1);
% BW3=myfill(BW3,1);
% BW3=myfill(BW2,2);
BW3=imfill(BW2,'holes');
BW3=imopen(BW3,strel('disk',1));
BW3=imclose(BW3,strel('disk',1));
% BW3=myfill(BW3,4);
% figure(1);imshow(BW3,[]); title('3');
% BW3=imcrop(BW3);
% I=I(201:326,302:418);
% BW3=BW3(201:326,302:418);
[m,n] = size(BW3);
figure(1);imshow(I,[]); title('I');
figure(2);imshow(BW3,[]); title('3');
% BW4=imclose(BW3,SE);
% figure(2);imshow(BW4,[]); title('4');
% �������
% BW2 = imfill(BW2,'holes'); % �������
% BWedge = edge(BW2,'sobel'); % ��Ե��ȡ ��ʼ�ı߽�
BWedge=myedge1(double(BW3)); % Ѱ�ҳ�ʼ��Ե����
% figure(9);imshow(BW1,[]);  title('��ֵ��ͼ��');
% figure(6);imshow(BW2,[]); title('���������');
% figure(6);imshow(BWedge); title('��ʼ�߽�');
k=0; % �ж��Ƿ�����
iter=0; % �鿴��������
k1=7; % �߽�ѡ�㷶Χ k1Ϊ����
k2=3; % fcm�߽�ѡ�㷶Χ k2Ϊ����
opts = [2;1000;1e-5;0]; cluster_n=2; % FCMĬ�ϲ���
while ~k
    [edge_x,edge_y]=find(BWedge); % ���ұ߽��
    BWedge_new=BWedge;
    for i =1:length(edge_x) % ��ÿ���߽��Ĵ���W����FCM�ͱ�Ҷ˹����
        x_tmp=edge_x(i); y_tmp=edge_y(i);
        BWedge_index=more_points(I,x_tmp,y_tmp,k1); % ȡboundary�Լ�������λ�ã���Ҫ���·���ĵ㣩
        
        [center,U,obj_fcn,new_data] = fcm2window(I,BWedge_index,k2); % ���µ�fcm �Ա߽����з���
        %     [center,U,obj_fcn] = myfcm3(I,cluster_n,opts,k2);
        %     [center,U,obj_fcn] = fcm(new_data,cluster_n,opts); % �ô�ͳ��fcm
        %     new_data=I(:);
        [t_u,t_indx]=max(U); % �ж�ǰ���ͱ���
        indx_1=find(t_indx==1);
        t_sum_u1=sum(new_data(indx_1))/size(indx_1,2);
        indx_2=find(t_indx==2);
        t_sum_u2=sum(new_data(indx_2))/size(indx_2,2);
        if t_sum_u2<t_sum_u1
            u1=U(1,:)*new_data./sum(U(1,:)); % ���������
            u2=U(2,:)*new_data./sum(U(2,:));
            v1=U(1,:)*((new_data-u1).^2)./sum(U(1,:));
            v2=U(2,:)*((new_data-u2).^2)./sum(U(2,:));
        else
            u2=U(1,:)*new_data./sum(U(1,:)); % ���������
            u1=U(2,:)*new_data./sum(U(2,:));
            v2=U(1,:)*((new_data-u1).^2)./sum(U(1,:));
            v1=U(2,:)*((new_data-u2).^2)./sum(U(2,:));
        end
        
        %         BWedge_new=zeros(m,n);
        %         for i = 1:m % ��Ҷ˹������
        %             for j = 1:n
        %                 if BWedge_more(i,j)
        a_tmp=0:0.01:1;
        u_tmp=a_tmp*u1+(1-a_tmp)*u2;
        v_tmp=sqrt(a_tmp*v1+(1-a_tmp)*v2);
        p_tmp=exp(-(I(x_tmp,y_tmp)-u_tmp).^2./(2*v_tmp.^2))/sqrt(2*pi)./v_tmp;
        index=find(p_tmp==max(p_tmp));
        if a_tmp(index) <= 0.5
            %                         BWedge_new(i,j)=1; % �µı߽��
            BWedge_new(x_tmp,y_tmp)=0;
        end
        %                 end
        %             end
        %         end
    end
    index1=find((BWedge-BWedge_new)>0);
    BW3(index1)=0;
    BW3=imfill(BW3,'holes');
%     BW3=imclose(BW3,strel('disk',3));
%     figure(7);imshow(BW3.*I,[]); title('��');
    BWedge_tmp=myedge1(double(BW3));
    if BWedge_tmp == BWedge
        figure(8);imshow(BWedge_tmp.*I,[]); title('�����߽�');
        k = 1; % ����,ֹͣ����
    else
        iter=iter+1
%         BWedge_tmp1=BWedge_tmp-BWedge;
%         BWedge_tmp2=double(BWedge_tmp1 > 0);
%         sum(sum(BWedge_tmp2))
        BWedge=BWedge_tmp;
        figure(9);imshow(BWedge); title('�´ε����ı߽�');
    end
%     if BWedge_new == BWedge
%         k = 1; % ����,ֹͣ����
%         %         figure(9);imshow(BWedge_new.*I,[]); title('����ͼƬ');
%         figure(9);imshow(BWedge_new,[]); title('�����߽�');
%     else
%         iter=iter+1
%         index1=find((BWedge-BWedge_new)>0);
%         %       I(index1)=min(min(I));
%         BW3(index1)=0;
%         BW3=imfill(BW3,'holes');
%         figure(3);imshow(BW3,[]); title('��');
%         figure(7);imshow(BW3.*I,[]); title('��');
%         %       figure(7);imshow(I,[]); title('�޸ĺ��ͼ��');
%         %             BW3=myfill(BW3,6);
%         BWedge_tmp=myedge1(double(BW3)); % Ѱ�ҳ�ʼ��Ե����
%         BWedge_tmp1=BWedge_tmp-BWedge;
%         BWedge_tmp2=double(BWedge_tmp1 > 0);
%         BWedge=BWedge_tmp2;
%         figure(8);imshow(BWedge_tmp2); title('�´ε����ı߽�');
%     end
end
toc
