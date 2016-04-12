clc
clear all
close all
map_length = 160;%̽�����򳤶�
map_width = 40;%̽��������

%�˶�ģ������
R0_l = 50; %�����ʼ����
v0_l = 3; %�����ʼ�ٶ�
a0_l = 0; %������ٶ�

R0_w=40; %�����ʼ����
v0_w=-2; %�����ʼ�ٶ�
a0_w=-5;  %������ٶ�
%T_b = 0.592;
allow_T = 1.5;
time_num = 15;
%���ܲ�������
[s_TRACK_L,s_TRACK_W,global_count] = smartbeam(time_num,map_length,map_width,R0_l,v0_l,a0_l,R0_w,v0_w,a0_w,allow_T);
%����ɨ�跽��
[b_Track_l, b_Track_w] = bigscan(time_num,map_length,map_width,R0_l,v0_l,a0_l,R0_w,v0_w,a0_w);
% %������������
[bs_Track_l, bs_Track_w,T_b] = bigsearch(time_num,map_length,map_width,R0_l,v0_l,a0_l,R0_w,v0_w,a0_w,allow_T);
% 
% %����Ա�
hold on
plot(bs_Track_l,bs_Track_w,'c+');
hold on
plot(b_Track_l,b_Track_w,'kV');
%  %xlabel('̽�������������/m');
% % ylabel('̽��������������/m');
% % legend('���������˶��켣','��������','���ܲ���ɨ��','����ɨ��','Location','northwest');
xlabel('Horizontal distance/m');
ylabel('Vertical distance/m');
legend('Object theory track','Smart beam tracking scheme','Wide beam tracking scheme','Wide beam scanning scheme','Location','northeast');
axis([0 map_length 0 map_width]);
text(80, 80, ['Horizontal length of detection area: ',num2str(map_length),'m']);
text(80, 18, ['Longitudinal length of detection area: ',num2str(map_width),'m']);

text(80, 16, ['Horizontal initial  distance: ',num2str(R0_l),'m']);
text(80, 14, ['Horizontal initial  velocity: ',num2str(v0_l),'m/s']);
text(80, 12, ['Horizontal  acceleration: ',num2str(a0_l),'m/s2']);

text(80, 10, ['Longitudinal initial distance: ',num2str(R0_w),'m']);
text(80, 08, ['Longitudinal initial velocity: ',num2str(v0_w),'m/s']);
text(80, 6, ['Longitudinal acceleration: ',num2str(a0_w),'m/s2']);
