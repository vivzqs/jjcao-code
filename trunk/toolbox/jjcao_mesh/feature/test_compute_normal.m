% function test_compute_normal
%
% 
% Copyright (c) 2012 Junjie Cao
%%
clear;clc;close all;
%MYTOOLBOXROOT='E:/jjcaolib/toolbox/';
MYTOOLBOXROOT='../';
addpath ([MYTOOLBOXROOT 'jjcao_common'])
addpath ([MYTOOLBOXROOT 'jjcao_interact'])
addpath ([MYTOOLBOXROOT 'jjcao_io'])
addpath ([MYTOOLBOXROOT 'jjcao_plot'])

%%
[vertices,faces] = read_mesh([MYTOOLBOXROOT 'data/cube_602.off']);
[normal, fnromal] = compute_normal(vertices, faces);

%% display 
figure;set(gcf,'color','white');hold on;
plot_mesh(vertices, faces);

options.subsample_normal = 0.8;
options.normal_scaling = 0.2;
% h = plot_face_normal(vertices, faces, normals, options);
h = plot_face_normal(vertices, faces, -normals, options);
