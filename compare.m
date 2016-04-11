clc
clear all
close all
%�˶�ģ������
R0_l = 1; %�����ʼ����
v0_l = 6; %�����ʼ�ٶ�
a0_l = 0; %������ٶ�

R0_w=45; %�����ʼ����
v0_w=0; %�����ʼ�ٶ�
a0_w=-4;  %������ٶ�
T_b = 0.592;
allow_T = 0.4*T_b;
%���ܲ�������
[s_TRACK_L,s_TRACK_W] = smartbeam(R0_l,v0_l,a0_l,R0_w,v0_w,a0_w,allow_T);
%����ɨ�跽��
 [b_Track_l, b_Track_w] = bigscan(R0_l,v0_l,a0_l,R0_w,v0_w,a0_w);
% %������������
 [bs_Track_l, bs_Track_w] = bigsearch(R0_l,v0_l,a0_l,R0_w,v0_w,a0_w,allow_T);
% 
% %����Ա�
plot(bs_Track_l,bs_Track_w,'c+');
hold on
plot(b_Track_l,b_Track_w,'kV');
%  %xlabel('̽�������������/m');
% % ylabel('̽��������������/m');
% % legend('���������˶��켣','��������','���ܲ���ɨ��','����ɨ��','Location','northwest');
xlabel('landscape orientation distance/m');
ylabel('vertical orientation distance/m');
legend('object theory track','Smart beam tracking scanning','Wide beam tracking scanning','Wide beam scanning the whole area in sequence','Location','northeast');
