clear;
% close all;
tic
Img=dicomread(dicominfo(strcat('.\Wang\',num2str(67),'.dcm'))); % num2str(50)
% Img=dicomread(dicominfo(strcat('.\Wang\',num2str(50),'.dcm'))); 

I=double(Img); % 输入为pixel值
% figure(3);imshow(I,[]);    title('初始图像');
% RescaleIntercept=-1024;
% RescaleSlope=1;
% I=I*RescaleSlope+RescaleIntercept; % 像素值转CT值
I1=My_foo3(I); % valley-emphasized image 用来求解更好的初始边界
% I1=I;
% [m,n] = size(I1);
% figure(4);imshow(I1,[]); title('valley-emphasized image');
thresh1=120+1024;
% N_min=700;
% thresh1=find_thresh1(I1,N_min);
% thresh1=1100;
% I1=imcrop(I1,[]);
% thresh1=max(max(I1))*graythresh(I1/max(max(I1)))+1024;
BW2=(I1>thresh1); % 二值化
% figure(5);imshow(BW2,[]); title('二值化图像');

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
% 区域填充
% BW2 = imfill(BW2,'holes'); % 区域填充
% BWedge = edge(BW2,'sobel'); % 边缘提取 初始的边界
BWedge=myedge1(double(BW3)); % 寻找初始边缘像素
% figure(9);imshow(BW1,[]);  title('二值化图像');
% figure(6);imshow(BW2,[]); title('区域填充结果');
% figure(6);imshow(BWedge); title('初始边界');
k=0; % 判断是否收敛
iter=0; % 查看迭代次数
k1=7; % 边界选点范围 k1为奇数
k2=3; % fcm边界选点范围 k2为奇数
opts = [2;1000;1e-5;0]; cluster_n=2; % FCM默认参数
while ~k
    [edge_x,edge_y]=find(BWedge); % 先找边界点
    BWedge_new=BWedge;
    for i =1:length(edge_x) % 对每个边界点的窗口W进行FCM和贝叶斯分类
        x_tmp=edge_x(i); y_tmp=edge_y(i);
        BWedge_index=more_points(I,x_tmp,y_tmp,k1); % 取boundary以及其领域位置（需要重新分类的点）
        
        [center,U,obj_fcn,new_data] = fcm2window(I,BWedge_index,k2); % 用新的fcm 对边界点进行分类
        %     [center,U,obj_fcn] = myfcm3(I,cluster_n,opts,k2);
        %     [center,U,obj_fcn] = fcm(new_data,cluster_n,opts); % 用传统的fcm
        %     new_data=I(:);
        [t_u,t_indx]=max(U); % 判断前景和背景
        indx_1=find(t_indx==1);
        t_sum_u1=sum(new_data(indx_1))/size(indx_1,2);
        indx_2=find(t_indx==2);
        t_sum_u2=sum(new_data(indx_2))/size(indx_2,2);
        if t_sum_u2<t_sum_u1
            u1=U(1,:)*new_data./sum(U(1,:)); % 求待估参数
            u2=U(2,:)*new_data./sum(U(2,:));
            v1=U(1,:)*((new_data-u1).^2)./sum(U(1,:));
            v2=U(2,:)*((new_data-u2).^2)./sum(U(2,:));
        else
            u2=U(1,:)*new_data./sum(U(1,:)); % 求待估参数
            u1=U(2,:)*new_data./sum(U(2,:));
            v2=U(1,:)*((new_data-u1).^2)./sum(U(1,:));
            v1=U(2,:)*((new_data-u2).^2)./sum(U(2,:));
        end
        
        %         BWedge_new=zeros(m,n);
        %         for i = 1:m % 贝叶斯分类器
        %             for j = 1:n
        %                 if BWedge_more(i,j)
        a_tmp=0:0.01:1;
        u_tmp=a_tmp*u1+(1-a_tmp)*u2;
        v_tmp=sqrt(a_tmp*v1+(1-a_tmp)*v2);
        p_tmp=exp(-(I(x_tmp,y_tmp)-u_tmp).^2./(2*v_tmp.^2))/sqrt(2*pi)./v_tmp;
        index=find(p_tmp==max(p_tmp));
        if a_tmp(index) <= 0.5
            %                         BWedge_new(i,j)=1; % 新的边界点
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
%     figure(7);imshow(BW3.*I,[]); title('新');
    BWedge_tmp=myedge1(double(BW3));
    if BWedge_tmp == BWedge
        figure(8);imshow(BWedge_tmp.*I,[]); title('收敛边界');
        k = 1; % 收敛,停止迭代
    else
        iter=iter+1
%         BWedge_tmp1=BWedge_tmp-BWedge;
%         BWedge_tmp2=double(BWedge_tmp1 > 0);
%         sum(sum(BWedge_tmp2))
        BWedge=BWedge_tmp;
        figure(9);imshow(BWedge); title('下次迭代的边界');
    end
%     if BWedge_new == BWedge
%         k = 1; % 收敛,停止迭代
%         %         figure(9);imshow(BWedge_new.*I,[]); title('收敛图片');
%         figure(9);imshow(BWedge_new,[]); title('收敛边界');
%     else
%         iter=iter+1
%         index1=find((BWedge-BWedge_new)>0);
%         %       I(index1)=min(min(I));
%         BW3(index1)=0;
%         BW3=imfill(BW3,'holes');
%         figure(3);imshow(BW3,[]); title('新');
%         figure(7);imshow(BW3.*I,[]); title('新');
%         %       figure(7);imshow(I,[]); title('修改后的图像');
%         %             BW3=myfill(BW3,6);
%         BWedge_tmp=myedge1(double(BW3)); % 寻找初始边缘像素
%         BWedge_tmp1=BWedge_tmp-BWedge;
%         BWedge_tmp2=double(BWedge_tmp1 > 0);
%         BWedge=BWedge_tmp2;
%         figure(8);imshow(BWedge_tmp2); title('下次迭代的边界');
%     end
end
toc
