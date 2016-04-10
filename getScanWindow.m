%%%%%%%%%%%%%%%%%%%%%%%
%%% Author: Chao Li %%%
%%%%%%%%%%%%%%%%%%%%%%%

function [scan_window_l scan_window_w] = getScanWindow(BeamPos_l, BeamPos_w,max_pos_l,max_pos_w,map_w, beam_radius,v, T1)
%ȷ������ɨ���ɨ�贰�����η���ֻ���ǵ�Ŀ�����
scan_window_l = BeamPos_l;
scan_window_w = BeamPos_w;
scan_radius = fix((v * T1/map_w)/beam_radius); %ɨ�贰�İ뾶


%�����������˶�������Ѱ
for i = 1: scan_radius
    if (v > 0)
        if i == 1
            scan_window_l = [scan_window_l BeamPos_l:BeamPos_l+1 ones(1, 2)*(BeamPos_l+1) BeamPos_l:-1:BeamPos_l-1  ones(1, 2)*(BeamPos_l-1)];
            scan_window_w = [scan_window_w  ones(1, 2)*(BeamPos_w+1) BeamPos_w:-1:BeamPos_w-1 ones(1, 2)*(BeamPos_w-1) BeamPos_w:BeamPos_w+1];
        else
            scan_window_l = [scan_window_l BeamPos_l BeamPos_l+1:BeamPos_l+i ones(1, 2*i)*(BeamPos_l+i) BeamPos_l+i-1:-1:BeamPos_l-i ones(1, 2*i)*(BeamPos_l-i) BeamPos_l-i+1:BeamPos_l-1];
            scan_window_w = [scan_window_w BeamPos_w+i ones(1, i)*(BeamPos_w+i) BeamPos_w+i-1:-1:BeamPos_w-i ones(1, 2*i)*(BeamPos_w-i) BeamPos_w-i+1:BeamPos_w+i ones(1, i-1)*(BeamPos_w+i)];
        end
    else
        if i == 1
            scan_window_l = [scan_window_l BeamPos_l:BeamPos_l+1 ones(1, 2)*(BeamPos_l+1) BeamPos_l:-1:BeamPos_l-1  ones(1, 2)*(BeamPos_l-1)];
            scan_window_w = [scan_window_w  ones(1, 2)*(BeamPos_w-1) BeamPos_w:BeamPos_w+1 ones(1, 2)*(BeamPos_w+1) BeamPos_w:-1:BeamPos_w-1];
        else
            scan_window_l = [scan_window_l BeamPos_l BeamPos_l+1:BeamPos_l+i ones(1, 2*i)*(BeamPos_l+i) BeamPos_l+i-1:-1:BeamPos_l-i ones(1, 2*i)*(BeamPos_l-i) BeamPos_l-i+1:BeamPos_l-1];
            scan_window_w = [scan_window_w BeamPos_w-i ones(1, i)*(BeamPos_w-i) BeamPos_w-i+1:BeamPos_w+i ones(1, 2*i)*(BeamPos_w+i) BeamPos_w+i-1:-1:BeamPos_w-i ones(1, i-1)*(BeamPos_w-i)];
        end
    end
end
[scan_window_l,scan_window_w] = passfilterWindow(scan_window_l, 1, max_pos_l, scan_window_w, 1,max_pos_w );
end

