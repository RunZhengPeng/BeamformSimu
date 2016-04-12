%%%%%%%%%%%%%%%%%%%%%%%
%%% Author: Chao Li %%%
%%%%%%%%%%%%%%%%%%%%%%%
function [Track_l ,Track_w,T_b] = bigsearch(time_num,map_length,map_width,R0_l,v0_l,a0_l,R0_w,v0_w,a0_w,allow_T)
%%
%����ģ������
%map_length = 80;%̽�����򳤶�
%map_width = 50;%̽��������
%%
%�趨����ϸ��
T1 = 0.0037; %������פ��ʱ�䣬�����л�ʱ�䲻����
big_beam = 8; %�����������α߳�
small_beam = 2; %С���������α߳�
T_b = map_length * map_width / (big_beam * big_beam)*T1; %����ɨ������������Ҫ��ʱ��
%allow_T = 0.8*T_b; %����ɨ��ʱȫ�����̿հ�ʱ��
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
init_map = map;
RL_pre = R0_l/map_l;%map����ʱ��Ӧ����һʱ�̵�ֵ
RW_pre = R0_w/map_w;


[map_x map_y] = size(map);

max_big_pos_l=map_x/(big_beam/map_l);
max_big_pos_w = map_y/(big_beam/map_w);

RL_pre = R0_l/map_l;%map����ʱ��Ӧ����һʱ�̵�ֵ
RW_pre = R0_w/map_w;
beamPos_w = 1;
beamPos_l = 1;%������λ��

s_track_time = -1;%���ó�ʼ������ʱ��Ϊ-1
track_flag = 0; %����Ϊ1ʱ����������ģʽ
map = init_map;
Objects = [];%�洢ȫ��ɨ��õ�������
horizental_trend = 0;%0��ʾδ֪��-1��ʾ����1��ʾ����
Global_count = 0;
search_count = 0;
for i = 1: length(t)
    if(R0l(i)<=map_length && R0w(i) <= map_width && R0l(i)>0 && R0w(i) >0 )
        [map, RL_pre, RW_pre] = updatemap(map,R0l(i),RL_pre,R0w(i),RW_pre,v(i),map_l,map_w); %ʵʱ����map
    else
        break;
    end
    if(~track_flag)
        %ȫ��ɨ��
        %Objects = [];
        [hasObject, L, W, vv,map_index_w] = bigBeamFindObject(beamPos_l,beamPos_w,map,big_beam, map_l,map_w);
        if(hasObject)
            fprintf('ȫ��ɨ�����(%d,%d)ɨ��ʱ����Ŀ��(%.4f, %.4f),�ٶ�Ϊ%.4f\n',beamPos_l ,beamPos_w, L,W,vv);
            %����Ŀ�꣬�������Ϣ����Object����,ÿ�зֱ��ʾ(������룬������룬�ٶȣ� ������λ�ã�������λ��)
            Objects = [Objects; L W vv beamPos_l beamPos_w];
        end
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
                [big_l,big_w,small_l,small_w ] = gettheorylocation( R0l(i),R0w(i),small_beam,big_beam,map,map_l,map_w );
                fprintf('��ǰ���������˶���λ(%.4f,%.4f)�����۲�����λ(%d,%d)\n',R0l(i),R0w(i),big_l, big_w);
                fprintf(2,'����ȫ��ɨ���������ǰʱ��%.4f\n',i*T1);
                track_flag = 1;
                s_track_time = i;
                %�������ٲ������
                first_track =1;
                big_beam_track_flag = 1;
                big_tracking_flag = 1;
                big_beam_track_object = 1;%��������Ŀ�����
                big_tracking_continue = 0;
                big_beam_track_window = 1;%��������ɨ�贰�Ķ�λ����
                object_num = size(Objects, 1);
                big_tracking_status = zeros(1,object_num);
                Big_Scan_Window_l = cell(1, object_num);
                Big_Scan_Window_w = cell(1, object_num);
                Big_Objects = cell(1, object_num);%�洢������ʱ����ʱ������
                if(Global_count == 0)
                    Result = cell(1, object_num);%���ڴ��ڹ����еõ�����Ϣ
                end
                Global_count = Global_count + 1;
                pre_l_window = Objects(big_beam_track_object,4);
                search_count=0;
                search_time = 2;
            end
        end
    else
        %ʹ�ô�������
        if((i-s_track_time)*T1 > allow_T)%ȷ������ʱ�䲻�����հ�����ʱ��
            fprintf('��ǰʱ��%.4f,��������ʱ�䣬�˳�����ģʽ�������ô�������ȫ��ɨ��\n',i*T1);
            disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
            track_flag = 0;
            first_track=0;
            big_tracking_flag = 0;
            big_beam_track_flag=0;
            beamPos_w = 1;
            beamPos_l = 1;%���³�ʼ��������λ��
            Objects = [];
            search_count=0;
        else
            if(big_beam_track_flag)
                %����Objects�����Ϣ�ֱ�ȷ����������ɨ�贰������������·�λ
                if big_tracking_flag
                    if(first_track)
                        fprintf(2,'���¿�������,��������%d\n',horizental_trend);
                        [scan_window_l ,scan_window_w] = getScanWindow(Objects(big_beam_track_object,4), Objects(big_beam_track_object,5),max_big_pos_l,max_big_pos_w,map_w,big_beam,Objects(big_beam_track_object,3),T1,0.5*T_b,horizental_trend);
                        first_track = 0;
                        big_tracking_flag = 0;
                    else
                        fprintf(2,'��������,��������%d\n',horizental_trend);
                        [scan_window_l ,scan_window_w] = getScanWindow(Objects(big_beam_track_object,4), Objects(big_beam_track_object,5),max_big_pos_l,max_big_pos_w,map_w,big_beam,Objects(big_beam_track_object,3),T1,0,horizental_trend);
                        big_tracking_flag = 0;
                    end
                end
                
                Big_Scan_Window_l{big_beam_track_object} = scan_window_l;
                Big_Scan_Window_w{big_beam_track_object} = scan_window_w;
                
                beamPos_l = Big_Scan_Window_l{big_beam_track_object}(big_beam_track_window);
                beamPos_w = Big_Scan_Window_w{big_beam_track_object}(big_beam_track_window);
                fprintf('���ڸ��ٵ�%d�����壬����ɨ�贰����Ϊ%d\nɨ�贰Ϊ��', big_beam_track_object,length(Big_Scan_Window_l{big_beam_track_object}));
                for p = 1: length(Big_Scan_Window_l{big_beam_track_object})
                    fprintf('(%d,%d)',Big_Scan_Window_l{big_beam_track_object}(p),Big_Scan_Window_w{big_beam_track_object}(p));
                end
                fprintf('\n');
                [big_l,big_w,small_l,small_w ] = gettheorylocation( R0l(i),R0w(i),small_beam,big_beam,map,map_l,map_w );
                fprintf('��ǰ���������˶���λ(%.4f,%.4f)�����۲�����λ(%d,%d)\n',R0l(i),R0w(i),big_l,big_w);
                fprintf('���������У����ڸ��ٵ�%d��Ŀ�꣬��ǰ����Ϊ(%d,%d)\n',big_beam_track_object,beamPos_l,beamPos_w);
                big_map_test = getBigMap(beamPos_l, beamPos_w, big_beam,map,map_l,map_w);
                [hasObject, L, W, V,map_index_w] = bigBeamFindObject(beamPos_l, beamPos_w,map,big_beam, map_l,map_w);
                
                if(hasObject)
                    temp_horizental_trend = beamPos_l - pre_l_window;
                    if(temp_horizental_trend > 0)
                        horizental_trend = 1;
                    else
                        if (temp_horizental_trend < 0)
                            horizental_trend = -1;
                        end
                    end
                    pre_l_window = beamPos_l;
                    big_tracking_status(big_beam_track_object)=1;
                    fprintf('����(%d,%d)����ʱ����Ŀ��(%.4f, %.4f),�ٶ�Ϊ%.4f\n',beamPos_l,beamPos_w, L,W,V);
                    Big_Objects{big_beam_track_object} = [L W V beamPos_l beamPos_w];
                    Result{big_beam_track_object} = [Result{big_beam_track_object};L W V  0 beamPos_l beamPos_w];%��4�б�ʾ��������Ǵ�����������С����������0Ϊ������1ΪС����
                    big_beam_track_object= big_beam_track_object + 1;
                    big_beam_track_window = 1;
                    big_tracking_flag = 1;
                else
                    big_beam_track_window = big_beam_track_window + 1;
                    if(big_beam_track_window > length(Big_Scan_Window_l{big_beam_track_object}))
                        
                        if(search_count < search_time-1)
                            big_beam_track_window = 1;
                            search_count = search_count + 1;
                            fprintf(2,'��%d��Ŀ�������ʼ�ڶ������....................................\n', big_beam_track_object);
                        else
                            big_beam_track_object = big_beam_track_object + 1;
                            big_beam_track_window = 1;
                            big_tracking_status(big_beam_track_object) = 2;
                            fprintf('��%d��Ŀ��������ٶ�ʧ\n', big_beam_track_object);
                        end
                    end
                end
                
                if( big_beam_track_object > object_num)
                    for p =1 : object_num
                        if(big_tracking_status(p) == 1)
                            big_tracking_continue = 1;
                        end
                    end
                    
                    if big_tracking_continue
                        big_beam_track_object = 1;
                        big_tracking_flag = 1;
                        big_beam_track_window = 1;
                        Objects = [];
                        for m= 1:object_num
                            Objects = [Objects ;Big_Objects{m}];
                        end
                        big_tracking_continue=0;
                        fprintf(2,'������һ�ָ���\n');
                    else
                        big_beam_track_flag = 0;
                        track_flag = 0;
                        Objects = [];
                        fprintf(2,'С����Ŀ��ȫ�����ٶ�ʧ�����½���ȫ��ɨ��\n');
                    end
                    
                end
            end
        end
    end
end
Track_l=Result{1}(:,1);
Track_w=Result{1}(:,2);
end