%%%%%%%%%%%%%%%%%%%%%%%
%%% Author: Chao Li %%%
%%%%%%%%%%%%%%%%%%%%%%%
%���ܲ�������
clc
clear all
close all
%%
%����ģ������
map_length = 100;%̽�����򳤶�
map_width = 40;%̽��������
%%
%�趨����ϸ��
T1 = 0.0037; %������פ��ʱ�䣬�����л�ʱ�䲻����
allow_T = 1.5; %����ɨ��ʱȫ�����̿հ�ʱ��
big_beam = 3; %�����������α߳�
small_beam = 0.3; %С���������α߳�
T_b = map_length * map_width / (big_beam * big_beam)*T1; %����ɨ������������Ҫ��ʱ��
t = 0:T1:7*T_b;
num_l = map_length / big_beam; %��������ɨ�����
num_w = map_width / big_beam;%��������ɨ�����
%%
%���峡������
map_l = 0.05;%�˶�ģ�͵ķֱ���
map_w = 0.01;
map=ones(map_length/map_l, map_width/map_w)*(-1); %��ʼmap���飬��ʼ��Ϊ-1
%�˶�ģ������
R0_l = 10; %�����ʼ����
v0_l = 3; %�����ʼ�ٶ�
a0_l = 0; %������ٶ�

R0l = R0_l + v0_l .* t + 0.5 * a0_l .* t.^2; %ʵʱ������

R0_w=5; %�����ʼ����
v0_w=2; %�����ʼ�ٶ�
a0_w=0;  %������ٶ�
v = v0_w + a0_w.*t;

R0w = R0_w + v0_w .* t + 0.5 * a0_w .* t.^2;  %ʵʱ������

map(fix(R0_l/map_l), fix(R0_w/map_w)) = abs(v0_w); %�״����̽���������ٶ�
RL_pre = R0_l/map_l;%map����ʱ��Ӧ����һʱ�̵�ֵ
RW_pre = R0_w/map_w;
PREL = [];
PREW = [];
%%
%�������ٷ���
beamPos_w = 1;
beamPos_l = 1;%������λ��
Rl = [];
Rw = [];
V = [];
for i = 1: length(t)
    [map, RL_pre, RW_pre] = updatemap(map,R0l(i),RL_pre,R0w(i),RW_pre,v(i),map_l,map_w); %ʵʱ����map
    PREL = [PREL (RL_pre+0.5)*map_l];
    PREW = [PREW (RW_pre+0.5)*map_w];
    
     [hasObject, L, W, vv] = bigBeamFindObject(map_length, map_width, beamPos_w, beamPos_l,map,big_beam, map_l,map_w);
     beamPos_l = beamPos_l + 1;
     if(beamPos_l > num_l)
        beamPos_w = beamPos_w + 1;
        beamPos_l = 1;
    end
    
    if beamPos_w > num_w
        beamPos_w = 1;
        beamPos_l = 1;
    end 
    
    if(hasObject)
        i
        Rl = [Rl L];
        Rw = [Rw W];
    end
end

%%
%����Ա�
figure;
plot(PREL,PREW);%��������
hold on;
plot(Rl,Rw,'r');

