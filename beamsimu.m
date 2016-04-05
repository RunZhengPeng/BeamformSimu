%%%%%%%%%%%%%%%%%%%%%%%
%%% Author: Chao Li %%%
%%%%%%%%%%%%%%%%%%%%%%%
%���ܲ�������
clc
clear all
%%
%����ģ������
map_length = 30;%̽�����򳤶�
map_width = 20;%̽��������
%%
%�趨����ϸ��
T1 = 0.37; %������פ��ʱ�䣬�����л�ʱ�䲻����
allow_T = 1.5; %����ɨ��ʱȫ�����̿հ�ʱ��
big_beam = 5; %�����������α߳�
small_beam = 0.3; %С���������α߳�
T_b = map_length * map_width / (big_beam * big_beam); %����ɨ������������Ҫ��ʱ��
t = 0:T1:25*T_b*T1;
num_l = map_length / big_beam; %��������ɨ�����
num_w = map_width / big_beam;%��������ɨ�����
%%
%���峡������
map_l = 0.01;%�˶�ģ�͵ķֱ���
map_w = 0.01;
map=ones(map_length/0.1, map_width/0.1)*(-1); %��ʼmap���飬��ʼ��Ϊ-1
%�˶�ģ������
R0_l = 70; %�����ʼ����
v0_l = -4; %�����ʼ�ٶ�
a0_l = -3; %������ٶ�

R0l = R0_l + v0_l .* t + 0.5 * a0_l .* t.^2; %ʵʱ������

R0_w=20; %�����ʼ����
v0_w=2; %�����ʼ�ٶ�
a0_w=1;  %������ٶ�
v = v0_w + a0_w.*t;

R0w = R0_w + v0_w .* t + 0.5 * a0_w .* t.^2;  %ʵʱ������

map(fix(R0_l/map_l), fix(R0_w/map_w)) = abs(v0_w); %�״����̽���������ٶ�
RL_pre = R0_l;%map����ʱ��Ӧ����һʱ�̵�ֵ
RW_pre = R0_w;
PREL = RL_pre;
PREW = RW_pre;
%%
%�������ٷ���
beamPos_w = 1;
beamPos_l = 1;%������λ��
Rl = [];
Rw = [];
V = [];
for i = 1: length(t)
    [map, RL_pre, RW_pre] = updatemap(map,R0l(i),RL_pre,R0w(i),RW_pre,v(i),map_l,map_w); %ʵʱ����map
    PREL = [PREL RL_pre];
    PREW = [PREW RW_pre];
    i
%     [hasObject, L, W, vv] = bigBeamFindObject(map_length, map_width, beamPos_w, beamPos_l,map,big_beam, map_l,map_w);
%     beamPos_l = beamPos_l + 1;
%     if(beamPos_l > num_l)
%         beamPos_w = beamPos_w + 1;
%     end
%     
%     if beamPos_w > num_w
%         beamPos_w = 1;
%         beamPos_l = 1;
%     end 
%     
%     if(hasObject)
%         i,L,W
%         Rl = [Rl L];
%         Rw = [Rw W];
%     end
end

%%
%����Ա�
% plot(R0l,R0w);
% figure;
% plot(Rl,Rw);
plot(PREL,PREW);
