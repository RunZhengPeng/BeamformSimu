%%%%%%%%%%%%%%%%%%%%%%%
%%% Author: Chao Li %%%
%%%%%%%%%%%%%%%%%%%%%%%
%����ɨ�跽��
clc
clear all
close all
%%
%����ģ������
map_length = 80;%̽�����򳤶�
map_width = 50;%̽��������
%%
%�趨����ϸ��
T1 = 0.0037; %������פ��ʱ�䣬�����л�ʱ�䲻����
allow_T = 0.5; %����ɨ��ʱȫ�����̿հ�ʱ��
big_beam = 5; %�����������α߳�
small_beam = 1; %С���������α߳�
big_has_small_num = ceil(big_beam/small_beam); %�����ڰ�����С��������
T_b = map_length * map_width / (big_beam * big_beam)*T1; %����ɨ������������Ҫ��ʱ��
t = 0:T1:8*T_b;
num_l = map_length / big_beam; %��������ɨ�����
num_w = map_width / big_beam;%��������ɨ�����
%%
%���峡������
map_l = 0.05;%�˶�ģ�͵ķֱ���
map_w = 0.01;
map=ones(map_length/map_l, map_width/map_w)*(-1); %��ʼmap���飬��ʼ��Ϊ-1
%�˶�ģ������
R0_l = 1; %�����ʼ����
v0_l = 3; %�����ʼ�ٶ�
a0_l = 0; %������ٶ�

R0l = R0_l + v0_l .* t + 0.5 * a0_l .* t.^2; %ʵʱ������

R0_w=45; %�����ʼ����
v0_w=0; %�����ʼ�ٶ�
a0_w=-9.8;  %������ٶ�
v = v0_w + a0_w.*t;

R0w = R0_w + v0_w .* t + 0.5 * a0_w .* t.^2;  %ʵʱ������

map(fix(R0_l/map_l), fix(R0_w/map_w)) = abs(v0_w); %�״����̽���������ٶ�
init_map = map;
RL_pre = R0_l/map_l;%map����ʱ��Ӧ����һʱ�̵�ֵ
RW_pre = R0_w/map_w;
PREL = [];
PREW = [];

[map_x map_y] = size(map);
max_small_pos_l = map_x/(small_beam/map_l);
max_small_pos_w = map_y/(small_beam/map_w);
max_big_pos_l=map_x/(big_beam/map_l);
max_big_pos_w = map_y/(big_beam/map_w);

%%
%���ܲ�������
beamPos_w = 1;
beamPos_l = 1;%������λ��
Trl = [];
Trw = [];
Trv = [];
big_beam_track_flag = 0; %��������ģʽ
find_from_big_beam_flag = 0;
small_beam_track_flag = 0;%С��������ģʽ
track_flag = 0;%�������ģʽ

track_ing_flag = 0;%�Ƿ���Ҫ�������ٻ������������ο���������Ϊ0Ϊ�����ο���
Objects = [];%�洢ȫ��ɨ��õ�������
Big_Objects = [];%�洢������ʱ����ʱ������
Small_Objects = [];%�洢�Ӵ����л�ȡ��С����������
for i = 1:length(t)
    if(R0l(i)<=map_length && R0w(i) <= map_width && R0l(i)>0 && R0w(i) >0 )
        [map, RL_pre, RW_pre] = updatemap(map,R0l(i),RL_pre,R0w(i),RW_pre,v(i),map_l,map_w); %ʵʱ����map
    end
    PREL = [PREL (RL_pre+0.5)*map_l];
    PREW = [PREW (RW_pre+0.5)*map_w];
    if(~track_flag)
        %ȫ��ɨ��
        [hasObject, L, W, vv,map_index_w] = bigBeamFindObject(beamPos_w, beamPos_l,map,big_beam, map_l,map_w);
        if(hasObject)
            fprintf('����(%d,%d)ɨ��ʱ����Ŀ��(%.4f, %.4f),�ٶ�Ϊ%.4f\n',beamPos_l ,beamPos_w, L,W,vv);
            %����Ŀ�꣬�������Ϣ����Object����,ÿ�зֱ��ʾ(������룬������룬�ٶȣ� ������λ�ã�������λ��)
            Objects = [Objects; L W vv beamPos_l beamPos_w];
        else
            beamPos_l = beamPos_l + 1;
            if(beamPos_l > num_l)
                beamPos_w = beamPos_w + 1;
                beamPos_l = 1;
            end
            
            if beamPos_w > num_w
                %ȫ��ɨ�����
                beamPos_w = 1;
                beamPos_l = 1;
                if ~isempty(Objects)
                    track_flag = 1;
                    big_beam_track_flag = 1;
                    s_track_time = i;
                end
            end
        end
    else
        %��ʼ����
        if((i-s_track_time)*T1 > allow_T)%ȷ������ʱ�䲻�����հ�����ʱ��
            fprintf('��ǰʱ��%.4f,��������ʱ�䣬�˳�����ģʽ�������ô�������ȫ��ɨ��\n',i*T1);
            disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
            track_flag = 0;
            %track_ing_flag = 0;
            beamPos_w = 1;
            beamPos_l = 1;%���³�ʼ��������λ��
        else
            if(big_beam_track_flag)
                %����Objects�����Ϣ�ֱ�ȷ����������ɨ�贰������������·�λ
                object_num = size(Objects, 1);
                Big_Scan_Window_l = cell(1, object_num);
                Big_Scan_Window_w = cell(1, object_num);
                for k = 1: object_num
                    [scan_window_l ,scan_window_w] = getScanWindow(Objects(i,4), Objects(i,5),max_big_pos_l,max_big_pos_w,map_w,big_beam,Objects(i,3),T1);
                    Big_Scan_Window_l{k} = scan_window_l;
                    Big_Scan_Window_w{k} = scan_window_w;
                end
                s = 1; %��������Ŀ�����
                s_window = 1;%ɨ�贰�Ķ�λ����
                beamPos_l = Big_Scan_Window_l{s}(s_window);
                beamPos_w = Big_Scan_Window_w{s}(s_window);
                [hasObject, L, W, V,map_index_w] = bigBeamFindObject(beamPos_l, beamPos_w,map,big_beam, map_l,map_w);
                fprintf('���ڸ��ٵ�%d��Ŀ��\n', s);
                if(hasObject)
                    fprintf('��������ʱ����Ŀ��(%.4f, %.4f),�ٶ�Ϊ%.4f\n', L,W,V);
                    Big_Objects = [Big_Objects; L W V beamPos_l beamPos_w map_index_w];
                    s = s + 1;
                    s_window = 1;
                    if( s > object_num)
                        find_from_big_beam_flag = 1;%�������ٽ׶���ɣ���ÿ��Ŀ�궨λ��С������ȥ
                        big_beam_track_flag = 0;
                    end
                else
                    s_window = s_window + 1;
                    if(s_window > length(Big_Scan_Window_l{s}))
                        fprintf('��%d��Ŀ����ٶ�ʧ\n', s);
                        s = s + 1;
                    end
                    
                end
            end
            
            if(find_from_big_beam_flag)
                %�ھ���Ĵ����ڶ�λ���������ڵ�С����
                for k = 1: object_num
                    found_object =0;
                    for j = 1: big_has_small_num
                        smallBeamPos_l = (Big_Objects(k, 4)-1) * num + j;
                        smallBeamPos_w = ceil(Big_Objects(k, 6)/(small_beam/map_w));
                        [hasObject, L, W, V] = smallBeamFindObject(smallBeamPos_l, smallBeamPos_w, map, small_beam, map_l, map_w);
                        i=i+1;
                        if hasObject
                            found_object = 1;
                            Small_Objects = [Small_Objects; L W V smallBeamPos_l smallBeamPos_w];
                            fprintf('������%d,%d)��λ��С����(%d,%d)������Ŀ��(%.4f, %.4f),�ٶ�Ϊ%.4f\n', Big_Objects(k, 4),Big_Objects(k, 5),smallBeamPos_l,smallBeamPos_w,L,W,V);
                            break;
                        end
                    end
                    if(~found_object)
                        fprintf('��%d��Ŀ�궨λ��С�������ٶ�ʧ\n', k);
                    end
                end
                fprintf('������λ��С�������\n');
                find_from_big_beam_flag = 0;
                small_beam_track_flag = 1;
            end
            
            
            
            
            fprintf('����(%d,%d)������...\n',scan_window_l(k),scan_window_w(k));
        end
    end
end
