%%%%%%%%%%%%%%%%%%%%%%%
%%% Author: Chao Li %%%
%%%%%%%%%%%%%%%%%%%%%%%

function [map, RL_pre, RW_pre] = updatemap(map,R0l,RL_pre,R0w,RW_pre,v0_w)
%�ı������map��ӳ���λ��
[x,y]=size(map);
x_t=1:x;
y_t=1:y;
map(RL_pre,RW_pre)=-1;
RL=find(x_t<=R0l, 1, 'last' );
RW=find(y_t<=R0w, 1, 'last' );
map(RL,RW)=v0_w;
RL_pre=RL;
RW_pre=RW;
end