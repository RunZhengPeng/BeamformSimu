clc
clear all
close all
map_length = 160;%̽�����򳤶�
map_width = 80;%̽��������

%�˶�ģ������
R0_l = 10; %�����ʼ����
v0_l = 4; %�����ʼ�ٶ�
a0_l = 1; %������ٶ�

R0_w=75; %�����ʼ����
v0_w=0; %�����ʼ�ٶ�
a0_w=-2;  %������ٶ�
%T_b = 0.592;
allow_T = 1.5;
%���ܲ�������
[s_TRACK_L,s_TRACK_W,global_count] = smartbeam(map_length,map_width,R0_l,v0_l,a0_l,R0_w,v0_w,a0_w,allow_T);
%����ɨ�跽��
[b_Track_l, b_Track_w] = bigscan(map_length,map_width,R0_l,v0_l,a0_l,R0_w,v0_w,a0_w);
% %������������
[bs_Track_l, bs_Track_w] = bigsearch(map_length,map_width,R0_l,v0_l,a0_l,R0_w,v0_w,a0_w,allow_T);
% 
% %����Ա�
hold on
plot(bs_Track_l,bs_Track_w,'c+');
hold on
plot(b_Track_l,b_Track_w,'kV');
%  %xlabel('̽�������������/m');
% % ylabel('̽��������������/m');
% % legend('���������˶��켣','��������','���ܲ���ɨ��','����ɨ��','Location','northwest');
xlabel('landscape orientation distance/m');
ylabel('vertical orientation distance/m');
legend('object theory track','Smart beam tracking scanning','Wide beam tracking scanning','Wide beam scanning the whole area in sequence','Location','northeast');
