%%%%%%%%%%%%%%%%%%%%%%%
%%% Author: Chao Li %%%
%%%%%%%%%%%%%%%%%%%%%%%
function [Track_l ,Track_w, scan_count] = bigscan(time_num,map_length,map_width,R0_l,v0_l,a0_l,R0_w,v0_w,a0_w)
%%
%����ģ������
%map_length = 80;%̽�����򳤶�
%map_width = 50;%̽��������
%%
%�趨����ϸ��
T1 = 0.0037; %������פ��ʱ�䣬�����л�ʱ�䲻����

big_beam = 8; %�����������α߳�
T_b = map_length * map_width / (big_beam * big_beam)*T1; %����ɨ������������Ҫ��ʱ��

t = 0:T1:time_num*T_b;
num_l = map_length / big_beam; %��������ɨ�����
num_w = map_width / big_beam;%��������ɨ�����
%%
%���峡������
map_l = 0.05;%�˶�ģ�͵ķֱ���
map_w = 0.01;
map=zeros(map_length/map_l, map_width/map_w); %��ʼmap���飬��ʼ��Ϊ-1
%�˶�ģ������
% R0_l = 1; %�����ʼ����
% v0_l = 3; %�����ʼ�ٶ�
% a0_l = 0; %������ٶ�

R0l = R0_l + v0_l .* t + 0.5 * a0_l .* t.^2; %ʵʱ������

% R0_w=45; %�����ʼ����
% v0_w=0; %�����ʼ�ٶ�
% a0_w=-9.8;  %������ٶ�

v = v0_w + a0_w.*t;

R0w = R0_w + v0_w .* t + 0.5 * a0_w .* t.^2;  %ʵʱ������

map(fix(R0_l/map_l), fix(R0_w/map_w)) = abs(v0_w); %�״����̽���������ٶ�

RL_pre = R0_l/map_l;%map����ʱ��Ӧ����һʱ�̵�ֵ
RW_pre = R0_w/map_w;
PREL = [];
PREW = [];

[map_x map_y] = size(map);

%%
%����ɨ�跽��
beamPos_w = 1;
beamPos_l = 1;%������λ��
Rl = [];
Rw = [];
V = [];
scan_count = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%����˳��ɨ��
for i = 1: length(t)
    %fprintf('��ǰʱ��(big-scan)��%.4f\n',i*T1);
    if(R0l(i)<=map_length && R0w(i) <= map_width && R0l(i)>0 && R0w(i) >0 )
        [map, RL_pre, RW_pre] = updatemap(map,R0l(i),RL_pre,R0w(i),RW_pre,v(i),map_l,map_w); %ʵʱ����map
    end
    
    if(RL_pre && RW_pre && RL_pre<= (map_length/map_l) && RW_pre <= (map_width/map_w) && RL_pre>0 && RW_pre >0 )
        PREL = [PREL (RL_pre+0.5)*map_l];
        PREW = [PREW (RW_pre+0.5)*map_w];
    end
    
    
    %�ڵ��������ڲ�����û������
    [hasObject, L, W, vv,map_index_w] = bigBeamFindObject(beamPos_l,beamPos_w ,map,big_beam, map_l,map_w);
    if(hasObject)
        scan_count = scan_count + 1;
        fprintf('����(%d,%d)ɨ��ʱ����Ŀ��(%.4f, %.4f),�ٶ�Ϊ%.4f\n',beamPos_l ,beamPos_w,L,W,vv);
        Rl = [Rl L];
        Rw = [Rw W];
        V = [V vv];
    end
    beamPos_l = beamPos_l + 1;
    if(beamPos_l > num_l)
        beamPos_w = beamPos_w + 1;
        beamPos_l = 1;
    end
    
    if beamPos_w > num_w
        beamPos_w = 1;
        beamPos_l = 1;
    end   
    
end
Track_l = Rl;
Track_w = Rw;
end