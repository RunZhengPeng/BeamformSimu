%%%%%%%%%%%%%%%%%%%%%%%
%%% Author: Chao Li %%%
%%%%%%%%%%%%%%%%%%%%%%%
function [ Pos_l, Pos_w ] = getBigPosition( L,W,big_beam )
%GETBIGPOSITION Summary of this function goes here
%  ���������ʵ��λ���ж϶�Ӧ�Ĵ���������
Pos_l = ceil(L/big_beam);
Pos_w = ceil(W/big_beam);
end

