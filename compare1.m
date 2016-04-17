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
v0_l = 2; %�����ʼ�ٶ�
a0_l =0; %������ٶ�

R0_w=40; %�����ʼ����
v0_w=0; %�����ʼ�ٶ�
a0_w=-9.8;  %������ٶ�
%T_b = 0.592;
allow_T = 1.5;
time_num = 8;



%���ܲ�������
[s_TRACK_L,s_TRACK_W,global_count,PREL,PREW, count_smart] = smartbeam(time_num,map_length,map_width,R0_l,v0_l,a0_l,R0_w,v0_w,a0_w,allow_T);
%����ɨ�跽��
[b_Track_l, b_Track_w, count_big_scan] = bigscan(time_num,map_length,map_width,R0_l,v0_l,a0_l,R0_w,v0_w,a0_w);
% %������������
[bs_Track_l, bs_Track_w,T_b,count_big_search] = bigsearch(time_num,map_length,map_width,R0_l,v0_l,a0_l,R0_w,v0_w,a0_w,allow_T);
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


t1 = text(75, 28, ['Horizontal length of detection area: ',num2str(map_length),'m']);
set(t1,'FontName','Times New Roman','FontSize',12);
t2=text(75, 26, ['Longitudinal length of detection area: ',num2str(map_width),'m']);
set(t2,'FontName','Times New Roman','FontSize',12);

t10 = text(75,24,'Wide beam width: 8m, Small beam width: 1m');
set(t10,'FontName','Times New Roman','FontSize',12);

t3=text(75, 22, ['Horizontal initial  distance: ',num2str(R0_l),'m']);
set(t3,'FontName','Times New Roman','FontSize',12);
t4=text(75, 20, ['Horizontal initial  velocity: ',num2str(v0_l),'m/s']);
set(t4,'FontName','Times New Roman','FontSize',12);
t5=text(75, 18, ['Horizontal  acceleration: ',num2str(a0_l),'m/s^2']);
set(t5,'FontName','Times New Roman','FontSize',12);

t6=text(75, 16, ['Longitudinal initial distance: ',num2str(R0_w),'m']);
set(t6,'FontName','Times New Roman','FontSize',12);
t7=text(75, 14, ['Longitudinal initial velocity: ',num2str(v0_w),'m/s']);
set(t7,'FontName','Times New Roman','FontSize',12);
t8=text(75, 12, ['Longitudinal acceleration: ',num2str(a0_w),'m/s^2']);
set(t8,'FontName','Times New Roman','FontSize',12);

t9 = text(75,10,['Tracking allowable time: ', num2str(allow_T),'s']);
set(t9,'FontName','Times New Roman','FontSize',12);


%plot the small section
h1=axes('position',[0.2 0.25 0.25 0.25]);  % set the size of the small figure  
axis(h1);
plot(PREL,PREW);%��������
hold on
plot(s_TRACK_L,s_TRACK_W,'r*');
hold on
plot(bs_Track_l,bs_Track_w,'c+');
hold on
plot(b_Track_l,b_Track_w,'kV');
xlim([3 7.5]);
ylim([0 8]);