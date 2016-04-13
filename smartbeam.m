%%%%%%%%%%%%%%%%%%%%%%%
%%% Author: Chao Li %%%
%%%%%%%%%%%%%%%%%%%%%%%
%����ɨ�跽��
function [TRACK_L,TRACK_W,Global_count,PREL,PREW] = smartbeam(time_num,map_length,map_width,R0_l,v0_l,a0_l,R0_w,v0_w,a0_w,allow_T)
%%
%����ģ������
%map_length = 160;%̽�����򳤶�
%map_width = 80;%̽��������
%%
%�趨����ϸ��
T1 = 0.0037; %������פ��ʱ�䣬�����л�ʱ�䲻����

big_beam = 8; %�����������α߳�
small_beam = 1; %С���������α߳�
big_has_small_num = ceil(big_beam/small_beam); %�����ڰ�����С��������
T_b = map_length * map_width / (big_beam * big_beam)*T1; %����ɨ������������Ҫ��ʱ��
%allow_T = 0.4*T_b; %����ɨ��ʱȫ�����̿հ�ʱ��

t = 0:T1:time_num*T_b;
num_l = map_length / big_beam; %��������ɨ�����
num_w = map_width / big_beam;%��������ɨ�����
%%
%���峡������
map_l = 0.05;%�˶�ģ�͵ķֱ���
map_w = 0.01;
map=zeros(map_length/map_l, map_width/map_w); %��ʼmap���飬��ʼ��Ϊ0
%�˶�ģ������
% R0_l = 1; %�����ʼ����
% v0_l = 3; %�����ʼ�ٶ�
% a0_l = 0; %������ٶ�

R0l = R0_l + v0_l .* t + 0.5 * a0_l .* t.^2; %ʵʱ������

% R0_w=45; %�����ʼ����
% v0_w=0; %�����ʼ�ٶ�
% a0_w=-9;  %������ٶ�
v = v0_w + a0_w.*t;

R0w = R0_w + v0_w .* t + 0.5 * a0_w .* t.^2;  %ʵʱ������

map(fix(R0_l/map_l), fix(R0_w/map_w)) = v0_w; %�״����̽���������ٶ�
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
horizental_trend = 0;%0��ʾδ֪��-1��ʾ����1��ʾ����
small_track_ing_flag = 0;%�Ƿ���Ҫ�������ٻ������������ο���������Ϊ0Ϊ�����ο���
Objects = [];%�洢ȫ��ɨ��õ�������
Global_count = 0;
Result = {};
for i = 1:length(t)
    if(R0l(i)<=map_length && R0w(i) <= map_width && R0l(i)>0 && R0w(i) >0 )
        [map, RL_pre, RW_pre] = updatemap(map,R0l(i),RL_pre,R0w(i),RW_pre,v(i),map_l,map_w); %ʵʱ����map
    else
        break;
    end
    if(RL_pre && RW_pre && RL_pre<= (map_length/map_l) && RW_pre <= (map_width/map_w) && RL_pre>0 && RW_pre >0 )
        PREL = [PREL (RL_pre+0.5)*map_l];
        PREW = [PREW (RW_pre+0.5)*map_w];
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
                big_beam_track_flag = 1;
                big_beam_track_object = 1;%��������Ŀ�����
                big_beam_track_window = 1;%��������ɨ�贰�Ķ�λ����
                object_num = size(Objects, 1);
                Big_Scan_Window_l = cell(1, object_num);
                Big_Scan_Window_w = cell(1, object_num);
                Big_Objects = cell(1, object_num);%�洢������ʱ����ʱ������
                if(Global_count == 0)
                    Result = cell(1, object_num);%���ڴ��ڹ����еõ�����Ϣ
                end
                Global_count = Global_count + 1;
            end
        end
        
    else
        %��ʼ����
        if((i-s_track_time)*T1 > allow_T)%ȷ������ʱ�䲻�����հ�����ʱ��
            fprintf(2,'��ǰʱ��%.4f,��������ʱ�䣬�˳�����ģʽ�������ô�������ȫ��ɨ��\n',i*T1);
            disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
            track_flag = 0;
            beamPos_w = 1;
            beamPos_l = 1;%���³�ʼ��������λ��
            big_beam_track_flag = 0;
            find_from_big_beam_flag = 0;
            small_beam_track_flag = 0;
            Objects = [];
            search_time = 2;%Ĭ��ÿ��ɨ�贰��Χ�����ظ�ɨ��Ĵ���
            search_count = 0;
        else
            if(big_beam_track_flag)
                %����Objects�����Ϣ�ֱ�ȷ����������ɨ�贰������������·�λ
                for k = 1: object_num
                    fprintf(2,'��ȡ��������ɨ�贰,�����˶�����Ϊ%d\n',horizental_trend);
                    [scan_window_l ,scan_window_w] = getScanWindow(Objects(k,4), Objects(k,5),max_big_pos_l,max_big_pos_w,map_w,big_beam,Objects(k,3),T1,0.5*T_b,horizental_trend);
                    Big_Scan_Window_l{k} = scan_window_l;
                    Big_Scan_Window_w{k} = scan_window_w;
                end
                
                
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
                    fprintf('����(%d,%d)����ʱ����Ŀ��(%.4f, %.4f),�ٶ�Ϊ%.4f\n',beamPos_l,beamPos_w, L,W,V);
                    Big_Objects{big_beam_track_object} = [L W V beamPos_l beamPos_w map_index_w];
                   % Result{big_beam_track_object} = [Result{big_beam_track_object};L W V  0 beamPos_l beamPos_w];%��4�б�ʾ��������Ǵ�����������С����������0Ϊ������1ΪС����
                    big_beam_track_object= big_beam_track_object + 1;
                    big_beam_track_window = 1;
                else
                    big_beam_track_window = big_beam_track_window + 1;
                    if(big_beam_track_window > length(Big_Scan_Window_l{big_beam_track_object}))
                        fprintf('��%d��Ŀ��������ٶ�ʧ\n', big_beam_track_object);
                        if(search_count < search_time-1)
                            big_beam_track_window = 1;
                            search_count = search_count + 1;
                            fprintf(2,'��%d��Ŀ�������ʼ�ڶ������....................................\n', big_beam_track_object);
                        else
                            big_beam_track_object = big_beam_track_object + 1;
                            big_beam_track_window = 1;
                        end
                    end
                end
                
                if( big_beam_track_object > object_num)
                    find_from_big_beam_flag = 1;%�������ٽ׶���ɣ���ÿ��Ŀ�궨λ��С������ȥ
                    big_beam_track_flag = 0;
                    %������λС����������ʼ��
                    big_find_small_object = 1;%������λС�����������
                    if(Big_Objects{big_find_small_object}(3) > 0)
                        big_find_small_window = 1;%������λС�����������
                        update_unit = 1;
                    else
                        big_find_small_window = big_has_small_num;
                        update_unit = -1;
                    end
                    Small_Objects = cell(1, object_num);%�洢�Ӵ����л�ȡ��С����������
                end
            else
                if(find_from_big_beam_flag)
                    %�ھ���Ĵ����ڶ�λ���������ڵ�С��
                    found_object =0;
                    if ~isempty(Big_Objects{big_find_small_object})
                        smallBeamPos_l = (Big_Objects{big_find_small_object}(4)-1) * big_has_small_num + big_find_small_window;
                        smallBeamPos_w = ceil(Big_Objects{big_find_small_object}(6)/(small_beam/map_w));
                        
                        [big_l,big_w,small_l,small_w ] = gettheorylocation( R0l(i),R0w(i),small_beam,big_beam,map,map_l,map_w );
                        fprintf('��ǰ���������˶���λ(%.4f,%.4f)�����۴�����λ(%d,%d)������С������λ(%d,%d)\n',R0l(i),R0w(i),big_l,big_w,small_l,small_w);
                        fprintf('����(%d,%d)��С����(%d,%d)�ж�λ����\n',Big_Objects{big_find_small_object}(4),Big_Objects{big_find_small_object}(5),smallBeamPos_l,smallBeamPos_w);
                        [hasObject, L, W, V] = smallBeamFindObject(smallBeamPos_l, smallBeamPos_w, map, small_beam, map_l, map_w);
                        if hasObject
                            found_object = 1;
                            Small_Objects{big_find_small_object} = [L W V smallBeamPos_l smallBeamPos_w];
                            Result{big_find_small_object} = [Result{big_find_small_object}; L W V 1 smallBeamPos_l smallBeamPos_w];
                            fprintf('������%d,%d)��λ��С����(%d,%d)������Ŀ��(%.4f, %.4f),�ٶ�Ϊ%.4f\n', Big_Objects{big_find_small_object}(4),Big_Objects{big_find_small_object}(5),smallBeamPos_l,smallBeamPos_w,L,W,V);
                            big_find_small_object = big_find_small_object + 1;
                        else
                            big_find_small_window = big_find_small_window+update_unit;
                            if big_find_small_window > big_has_small_num  || big_find_small_window < 1
                                if ~found_object
                                    fprintf('��%d��Ŀ�궨λ��С������λ��ʧ\n', big_find_small_object);
                                end
                                big_find_small_object = big_find_small_object + 1;
                            end
                        end
                    else
                        big_find_small_object = big_find_small_object+ 1;
                        fprintf(2,'��%d��Ŀ�������λ��ʧ\n', big_find_small_object);
                    end
                    
                    if(found_object)
                        if(big_find_small_object < object_num )
                            if(Big_Objects{big_find_small_object}(3) > 0)
                                big_find_small_window = 1;%������λС�����������
                                update_unit = 1;
                            else
                                big_find_small_window = big_has_small_num;
                                update_unit = -1;
                            end
                        end
                    end
                    
                    if(big_find_small_object > object_num)
                        if(~cellfun(@isempty,Small_Objects))
                            fprintf(2,'������λ��С�������\n');
                            find_from_big_beam_flag = 0;
                            small_beam_track_flag = 1;
                            fprintf('��ʼС����������,��ǰʱ��%.4f\n',i*T1);
                            %С����������ز���
                            small_track_ing_flag = 1;%ȷ���Ƿ���Ҫ�����趨ɨ�贰
                            small_track_object = 1;%������������
                            small_track_window = 1;%���ٴ�����
                            Small_Scan_Window_l = cell(1,object_num);
                            Small_Scan_Window_w = cell(1,object_num);
                            Tracking_Objects = cell(1, object_num);
                            small_tracking_status = zeros(1, object_num);%0��ʾû����Ŀ�꣬1��ʾ�ɹ����٣�2��ʾ������
                            small_tracking_continue = 0;
                            
                            if ~isempty(Small_Objects{small_track_object})
                                pre_l_window = Small_Objects{small_track_object}(4);
                            else
                                pre_l_window = 0;
                            end
                            search_time = 2;%Ĭ��ÿ��ɨ�贰��Χ�����ظ�ɨ��Ĵ���
                            search_count = 0;
                        else
                            fprintf(2,'����������������......................................................\n');
                            find_from_big_beam_flag = 0;
                            %�������ٲ������
                            big_beam_track_flag = 1;
                            big_beam_track_object = 1;%��������Ŀ�����
                            big_beam_track_window = 1;%��������ɨ�贰�Ķ�λ����
                        end
                    end
                else
                    if(small_beam_track_flag)
                        if ~isempty(Small_Objects{small_track_object})
                            if(small_track_ing_flag)
                                fprintf(2,'��ȡС��������ɨ�贰,�����˶�����Ϊ%d\n',horizental_trend);
                                [scan_window_l ,scan_window_w] = getScanWindow(Small_Objects{small_track_object}(4), Small_Objects{small_track_object}(5),max_small_pos_l,max_small_pos_w,map_w,small_beam,Small_Objects{small_track_object}(3),T1,0,horizental_trend);
                                Small_Scan_Window_l{small_track_object} = scan_window_l;
                                Small_Scan_Window_w{small_track_object} = scan_window_w;
                                small_track_ing_flag = 0;
                                t_window_num = length( Small_Scan_Window_l{small_track_object});
                                fprintf(' ���ڸ��ٵ�%d�����壬����ɨ�贰����Ϊ%d\nɨ�贰Ϊ��', small_track_object,t_window_num);
                                for p = 1: t_window_num
                                    fprintf('(%d,%d)',scan_window_l(p),scan_window_w(p));
                                end
                                fprintf('\n');
                            end
                            
                            %test_small_map = getSmallMap(Small_Scan_Window_l{small_track_object}(small_track_window),Small_Scan_Window_w{small_track_object}(small_track_window),small_beam,map,map_l,map_w);
                            
                            [big_l,big_w,small_l,small_w ] = gettheorylocation( R0l(i),R0w(i),small_beam,big_beam,map,map_l,map_w );
                            fprintf('С����(%d,%d)ɨ����...��ǰʱ��%.4f\n',Small_Scan_Window_l{small_track_object}(small_track_window),Small_Scan_Window_w{small_track_object}(small_track_window),i*T1);
                            fprintf('��ǰ���������˶���λ(%.4f,%.4f)������С������λ(%d,%d)\n',R0l(i),R0w(i),small_l, small_w);
                            [hasObject, L, W, V] = smallBeamFindObject(Small_Scan_Window_l{small_track_object}(small_track_window), Small_Scan_Window_w{small_track_object}(small_track_window), map, small_beam, map_l, map_w);
                            if(hasObject)
                                small_tracking_status(small_track_object) = 1;
                                search_count = 0;
                                temp_horizental_trend = Small_Scan_Window_l{small_track_object}(small_track_window) - pre_l_window;
                                if(temp_horizental_trend > 0)
                                    horizental_trend = 1;
                                else
                                    if (temp_horizental_trend < 0)
                                        horizental_trend = -1;
                                    end
                                end
                                pre_l_window = Small_Scan_Window_l{small_track_object}(small_track_window);
                                fprintf('С����(%d,%d)����Ŀ��(%.4f, %.4f),�ٶ�Ϊ%.4f...��ǰʱ��%.4f\n',Small_Scan_Window_l{small_track_object}(small_track_window),Small_Scan_Window_w{small_track_object}(small_track_window),L,W,V,i*T1);
                                Tracking_Objects{small_track_object} = [L W V Small_Scan_Window_l{small_track_object}(small_track_window) Small_Scan_Window_w{small_track_object}(small_track_window)];
                                Result{small_track_object} = [Result{small_track_object}; L W V 1 Small_Scan_Window_l{small_track_object}(small_track_window) Small_Scan_Window_w{small_track_object}(small_track_window)];
                                small_track_object = small_track_object + 1;
                            else
                                small_track_window = small_track_window + 1;
                                if(small_track_window > t_window_num)
                                    if(search_count < search_time-1)
                                        small_track_window = 1;
                                        search_count =search_count + 1;
                                        fprintf(2,'С����Ŀ����ٶ�ʧ����������һ��.......................................................................\n');
                                    else
                                        small_track_window = 1;
                                        small_tracking_status(small_track_object) = 2;
                                        fprintf(2,'С����Ŀ����ٶ�ʧ��������һ��Ŀ��\n');
                                        small_track_object = small_track_object + 1;
                                    end
                                end
                            end
                        else
                            small_track_object=small_track_object+1;
                        end
                        
                        
                        if(small_track_object > object_num)
                            for p =1 : object_num
                                if(small_tracking_status(p) == 1)
                                    small_tracking_continue = 1;
                                end
                            end
                            
                            if (small_tracking_continue)
                                small_track_object=1;
                                small_track_ing_flag = 1;
                                small_track_window = 1;
                                Small_Objects = Tracking_Objects;
                                small_tracking_continue = 0;
                                fprintf(2,'������һ�ָ���\n');
                            else
                                small_beam_track_flag = 0;
                                track_flag = 0;
                                Objects = [];
                                fprintf(2,'С����Ŀ��ȫ�����ٶ�ʧ�����½���ȫ��ɨ��\n');
                            end
                        end
                    end
                    
                end
            end
        end
    end
end
TRACK_L = Result{1}(:,1);
TRACK_W = Result{1}(:,2);