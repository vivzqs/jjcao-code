% test_perform_mesh_weight
%
% 
% Copyright (c) 2013 Junjie Cao
%%
clear;clc;close all;
%MYTOOLBOXROOT='E:/jjcaolib/toolbox/';
MYTOOLBOXROOT='../';
addpath ([MYTOOLBOXROOT 'jjcao_common'])
addpath ([MYTOOLBOXROOT 'jjcao_interact'])
addpath ([MYTOOLBOXROOT 'jjcao_io'])
addpath ([MYTOOLBOXROOT 'jjcao_plot'])

mex -g -largeArrayDims -I"D:/eigen-3.1.3" mex/perform_mesh_weight.cpp
% mex -g -largeArrayDims -DNAN_EQUALS_ZERO -I"D:/eigen-3.1.3" mex/perform_mesh_weight.cpp

%%
[verts,faces] = read_mesh([MYTOOLBOXROOT 'data/cube_f300.off']);%regular_triangle % cube_f300
% L1 = perform_mesh_weight(verts',faces', 0);
% L10 = compute_mesh_weight(verts,faces,'combinatorial');
 
L4 = perform_mesh_weight(verts',faces', 4);
L40 = compute_mesh_weight(verts,faces,'Laplace-Beltrami');
