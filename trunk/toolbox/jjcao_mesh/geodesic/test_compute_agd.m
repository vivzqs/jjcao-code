% test_compute_agd
% compile_mex
%
%
% Copyright (c) 2013 Shuhua Li, Junjie Cao

clear;clc;close all;

MYTOOLBOXROOT='../..';   %MYTOOLBOXROOT='E:/jjcaolib/toolbox';
addpath ([MYTOOLBOXROOT '/jjcao_mesh'])
addpath ([MYTOOLBOXROOT '/jjcao_io'])
addpath ([MYTOOLBOXROOT '/jjcao_plot'])
addpath ([MYTOOLBOXROOT '/jjcao_mesh/geodesic'])
addpath ([MYTOOLBOXROOT '/jjcao_interact'])
addpath ([MYTOOLBOXROOT '/jjcao_common'])
%% compute agd
[verts,faces] = read_mesh([MYTOOLBOXROOT '/data/wolf0.off']);
nbr_landmarks = 100; % the number of landmarks 
DEBUG=1;     % 1,view the voronoi cells and agd cells; 0,otherwise;
normalize=1; %1£¬normalize agd to 0-1£»0,otherwise
[agd,landmark,cellArea,faceIndex,Q]=compute_agd(verts,faces,nbr_landmarks,normalize,DEBUG);
%% display agd
figure('Name','agd'); set(gcf,'color','white'); 
    options.face_vertex_color =agd;
    h = plot_mesh(verts, faces, options);
%     set(h, 'edgecolor', 'none');
    colormap(jet(nbr_landmarks)); 
    view3d rot; lighting none;