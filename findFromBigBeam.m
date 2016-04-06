 %%%%%%%%%%%%%%%%%%%%%%%
%%% Author: Chao Li %%%
%%%%%%%%%%%%%%%%%%%%%%%

function  [small_l, small_w, small_v] = findFromBigBeam(beamPos_l, beamPos_w, W, small_beam, big_beam, map_l, map_w, map)
%�ڴ����ж�λС�����ľ���λ��
[x,y] = size(map);
y_t = 1:y;
RW = find(y_t <= W/map_w, 1, 'last');
num = big_beam / small_beam; %�����ڰ�����С��������
for i = 1: num
   index_l =  (beamPos_l - 1)*big_beam/map_l + i;
   index_w = RW;
   smallBeamPos_l = beamPos_l * num + i;
   smallBeamPos_w = fix(RW/small)+1;
   if(map(index_l, index_w) > -1)
       [hasObject, L, W, v] = smallBeamFindObject(smallBeamPos_l, smallBeamPos_w, map, small_beam, map_l, map_w);
   end
end
end