%%%%%%%%%%%%%%%%%%%%%%%
%%% Author: Chao Li %%%
%%%%%%%%%%%%%%%%%%%%%%%
%���ܲ�������
clc
clear all
close all
%%
%����ģ������
map_length = 50;%̽�����򳤶�
map_width = 40;%̽��������
%%
%�趨����ϸ��
T1 = 0.0037; %������פ��ʱ�䣬�����л�ʱ�䲻����
allow_T = 1.5; %����ɨ��ʱȫ�����̿հ�ʱ��
big_beam = 5; %�����������α߳�
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
v0_l = 4; %�����ʼ�ٶ�
a0_l = 0; %������ٶ�

R0l = R0_l + v0_l .* t + 0.5 * a0_l .* t.^2; %ʵʱ������

R0_w=5; %�����ʼ����
v0_w=10; %�����ʼ�ٶ�
a0_w=0;  %������ٶ�
v = v0_w + a0_w.*t;

R0w = R0_w + v0_w .* t + 0.5 * a0_w .* t.^2;  %ʵʱ������

map(fix(R0_l/map_l), fix(R0_w/map_w)) = abs(v0_w); %�״����̽���������ٶ�
RL_pre = R0_l/map_l;%map����ʱ��Ӧ����һʱ�̵�ֵ
RW_pre = R0_w/map_w;
PREL = [];
PREW = [];
%%
%����ɨ�跽��
% beamPos_w = 1;
% beamPos_l = 1;%������λ��
% Rl = [];
% Rw = [];
% V = [];
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %����˳��ɨ��
% for i = 1: length(t)
%     [map, RL_pre, RW_pre] = updatemap(map,R0l(i),RL_pre,R0w(i),RW_pre,v(i),map_l,map_w); %ʵʱ����map
%     PREL = [PREL (RL_pre+0.5)*map_l];
%     PREW = [PREW (RW_pre+0.5)*map_w];
%
%     %�ڵ��������ڲ�����û������
%     [hasObject, L, W, vv] = bigBeamFindObject(map_length, map_width, beamPos_w, beamPos_l,map,big_beam, map_l,map_w);
%
%     beamPos_l = beamPos_l + 1;
%     if(beamPos_l > num_l)
%         beamPos_w = beamPos_w + 1;
%         beamPos_l = 1;
%     end
%
%     if beamPos_w > num_w
%         beamPos_w = 1;
%         beamPos_l = 1;
%     end
%
%     if(hasObject)
%         i
%         Rl = [Rl L];
%         Rw = [Rw W];
%         V = [V vv];
%     end
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%�������ٷ���
RL_pre = R0_l/map_l;%map����ʱ��Ӧ����һʱ�̵�ֵ
RW_pre = R0_w/map_w;
beamPos_w = 1;
beamPos_l = 1;%������λ��
Trl = [];
Trw = [];
Trv = [];
s_track_time = -1;%���ó�ʼ������ʱ��Ϊ-1
track_flag = 0; %����Ϊ1ʱ����������ģʽ
track_ing_flag = 0;%�Ƿ���Ҫ�������ٻ������������ο���������Ϊ0Ϊ�����ο���
for i = 1: length(t)
    [map, RL_pre, RW_pre] = updatemap(map,R0l(i),RL_pre,R0w(i),RW_pre,v(i),map_l,map_w); %ʵʱ����map
    PREL = [PREL (RL_pre+0.5)*map_l];
    PREW = [PREW (RW_pre+0.5)*map_w];
    if(~track_flag)
        %�ڵ��������ڲ�����û������
        [hasObject, L, W, vv] = bigBeamFindObject(map_length, map_width, beamPos_w, beamPos_l,map,big_beam, map_l,map_w);
        if(hasObject)
            fprintf('����ɨ��ʱ����Ŀ��(%.4f, %.4f),�ٶ�Ϊ%.4f\n', L,W,vv);
            %����У��ڴ����ڶ�λ�������С�������������õ���Ϣ�Ǿ�����Ϣ
            [small_l, small_w ,small_v,smallBeamPos_l,smallBeamPos_w] = findFromBigBeam(beamPos_l, beamPos_w, W, small_beam, big_beam,map_l,map_w,map);
            fprintf('�ڴ�����С�������嶨λ���壬���Ϊ��Ŀ��(%.4f, %.4f),�ٶ�Ϊ%.4f\n', small_l,small_w,small_v);
            Trl = [Trl small_l];
            Trw = [Trw small_w];
            Trv = [Trv small_v];
            %obj_num = length(small_l);%һ���������������Ŀ
            %���ò������ٷ���
            fprintf('���ò������ٷ���,��ǰʱ��Ϊ%.4f\n', i*T1);
            s_track_time = i; %��ʼ���ٵ�ʱ�����
            track_flag = 1;
        else
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
    else
        %ʹ��С��������
        if((i-s_track_time)*T1 > allow_T)%ȷ������ʱ�䲻�����հ�����ʱ��
            fprintf('��ǰʱ��%.4f,��������ʱ�䣬�˳�����ģʽ�������ô�������ȫ��ɨ��\n',i*T1);
            disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
            track_flag = 0;
            beamPos_w = 1;
            beamPos_l = 1;%���³�ʼ��������λ��
        else
            if(~track_ing_flag)
                %��ȡ����ɨ�贰
                fprintf('��ȡ����ɨ�贰');
                [scan_window_l scan_window_w] = getScanWindow(smallBeamPos_l, smallBeamPos_w,map_w,small_v,T1);
                k=1; %ɨ�贰�Ķ�λ����
                track_ing_flag=1;
                window_num = length(scan_window_l);%ɨ�贰��Ŀ
                fprintf(' ����ɨ�贰����Ϊ%d\n', window_num);
                fprintf('С����������\n');
            end
            
            
            
            [hasObject, L, W, V] = smallBeamFindObject(scan_window_l(k), scan_window_w(k), map, small_beam, map_l, map_w);
            if(hasObject)
                Trl = [Trl L];
                Trw = [Trw W];
                Trv = [Trv V];
                smallBeamPos_l = scan_window_l(k);
                smallBeamPos_w = scan_window_w(k);
                track_ing_flag=0;
                fprintf('С����(%d,%d)����Ŀ��(%.4f,%.4f)���ٶ�Ϊ%.4f�����¿�ʼ��������\n',scan_window_l(k),scan_window_w(k),L,W,V);
            else
                k=k+1;
                if(k>window_num)
                    k=1;
                end
            end
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%
%����Ա�
figure;
plot(PREL,PREW);%��������
hold on;
plot(Trl,Trw,'r');
