function BW3=My_foo3(BW1)
% Construction of valley-emphasized image

% BW1=double(BW1);
% SE=strel('square',3);
SE=strel('disk',5);
BW2=imdilate(BW1,SE);
BW2=imerode(BW2,SE);
%t_tmp=BW2-BW1;
%figure(1);imshow(t_tmp);
BW3=2*BW1-BW2;

% BW4=imdilate(BW3,SE);
% BW5=imerode(BW4,SE);
% BW6=2*BW3-BW5;
% if min(min(BW6)) > 0
%         BW3=My_foo3(BW3);
% end

end