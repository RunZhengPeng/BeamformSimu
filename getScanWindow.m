%%%%%%%%%%%%%%%%%%%%%%%
%%% Author: Chao Li %%%
%%%%%%%%%%%%%%%%%%%%%%%

function [scan_window_l scan_window_w] = getScanWindow(smallBeamPos_l, smallBeamPos_w, map_w, small_v, T1)
%ȷ������ɨ���ɨ�贰�����η���ֻ���ǵ�Ŀ�����
scan_window_l = smallBeamPos_l;
scan_window_w = smallBeamPos_w;
scan_radius = ceil(small_v * T1/map_w); %ɨ�贰�İ뾶
if (small_v > 0)
    %�����������˶�������Ѱ
    for i = 1: scan_radius
        if i == 1
            scan_window_l = [scan_window_l smallBeamPos_l:smallBeamPos_l+1 ones(1, 2)*(smallBeamPos_l+1) smallBeamPos_l:-1:smallBeamPos_l-1  ones(1, 2)*(smallBeamPos_l-1)];
            scan_window_w = [scan_window_w  ones(1, 2)*(smallBeamPos_w+1) smallBeamPos_w:-1:smallBeamPos_w-1 ones(1, 2)*(smallBeamPos_w-1) smallBeamPos_w:smallBeamPos_w+1];
        else
            scan_window_l = [scan_window_l smallBeamPos_l smallBeamPos_l+1:smallBeamPos_l+i ones(1, 2*i)*(smallBeamPos_l+i) smallBeamPos_l+i-1:-1:smallBeamPos_l-i ones(1, 2*i)*(smallBeamPos_l-i) smallBeamPos_l-i+1:smallBeamPos_l-1];
            scan_window_w = [scan_window_w smallBeamPos_w+i ones(1, i)*(smallBeamPos_w+i) smallBeamPos_w+i-1:-1:smallBeamPos_w-i ones(1, 2*i)*(smallBeamPos_w-i) smallBeamPos_w-i+1:smallBeamPos_w+i ones(1, i-1)*(smallBeamPos_w+i)];
        end
    end
end

end

