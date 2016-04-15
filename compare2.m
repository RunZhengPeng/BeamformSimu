%%%%%%%%%%%%%%%%%%%%%%%
%%% Author: Chao Li %%%
%%%%%%%%%%%%%%%%%%%%%%%
clc
clear all
close all
map_length = 160;%̽�����򳤶�
map_width = 40;%̽��������

%�˶�ģ������
R0_l = 1; %�����ʼ����
v0_l = 13; %�����ʼ�ٶ�
a0_l = 0; %������ٶ�

R0_w=38; %�����ʼ����
v0_w=-2.5; %�����ʼ�ٶ�
a0_w=0;  %������ٶ�
%T_b = 0.592;
allow_T = 0.2;
time_num = 37;



%���ܲ�������
[s_TRACK_L,s_TRACK_W,global_count,PREL,PREW, count_smallbeam] = smartbeam(time_num,map_length,map_width,R0_l,v0_l,a0_l,R0_w,v0_w,a0_w,allow_T);
%����ɨ�跽��
[b_Track_l, b_Track_w, count_bigscan] = bigscan(time_num,map_length,map_width,R0_l,v0_l,a0_l,R0_w,v0_w,a0_w);
% %������������
[bs_Track_l, bs_Track_w,T_b, count_bigsearch] = bigsearch(time_num,map_length,map_width,R0_l,v0_l,a0_l,R0_w,v0_w,a0_w,allow_T);
% 
% %����Ա�
figure;
set(gca,'FontName','Times New Roman','FontSize',12);
set(gcf,'Units','inches','Position',[0.5 0.5 8.0 6.0]);  
plot(PREL,PREW);%��������
hold on
plot(s_TRACK_L,s_TRACK_W,'r*');
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


t1 = text(10, 20, ['Horizontal length of detection area: ',num2str(map_length),'m']);
set(t1,'FontName','Times New Roman','FontSize',12);
t2=text(10, 18, ['Longitudinal length of detection area: ',num2str(map_width),'m']);
set(t2,'FontName','Times New Roman','FontSize',12);

t3=text(10, 16, ['Horizontal initial  distance: ',num2str(R0_l),'m']);
set(t3,'FontName','Times New Roman','FontSize',12);
t4=text(10, 14, ['Horizontal initial  velocity: ',num2str(v0_l),'m/s']);
set(t4,'FontName','Times New Roman','FontSize',12);
t5=text(10, 12, ['Horizontal  acceleration: ',num2str(a0_l),'m/s^2']);
set(t5,'FontName','Times New Roman','FontSize',12);

t6=text(10, 10, ['Longitudinal initial distance: ',num2str(R0_w),'m']);
set(t6,'FontName','Times New Roman','FontSize',12);
t7=text(10, 8, ['Longitudinal initial velocity: ',num2str(v0_w),'m/s']);
set(t7,'FontName','Times New Roman','FontSize',12);
t8=text(10, 6, ['Longitudinal acceleration: ',num2str(a0_w),'m/s^2']);
set(t8,'FontName','Times New Roman','FontSize',12);

t9 = text(10,4,['Tracking allowable time: ', num2str(allow_T),'s']);
set(t9,'FontName','Times New Roman','FontSize',12);

%plot the small section
h1=axes('position',[0.66 0.52 0.22 0.22]);  % set the size of the small figure  
set(h1,'FontName','Times New Roman');  
axis(h1);
plot(PREL,PREW);%��������
hold on
plot(s_TRACK_L,s_TRACK_W,'r*');
hold on
plot(bs_Track_l,bs_Track_w,'c+');
hold on
plot(b_Track_l,b_Track_w,'kV');
ylim([35.25 36.36]);
xlim([11 14.1]);