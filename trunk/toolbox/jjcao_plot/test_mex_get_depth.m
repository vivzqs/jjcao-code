% test_mex_get_depth
% mex mex_get_depth.cpp -lOpenGL32


clear;clc;close all;
%MYTOOLBOXROOT='E:/jjcaolib/toolbox';
MYTOOLBOXROOT='../';
addpath ([MYTOOLBOXROOT 'jjcao_interact'])

peaks;axis off; axis equal; 
figure(1);
mouse3d;
depthData=mex_get_depth;
figure
imshow(depthData);