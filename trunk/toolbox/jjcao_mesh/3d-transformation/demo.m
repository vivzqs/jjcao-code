%
%  
%
% Copyright (c) 2013 Junjie Cao
clc;clear all;close all;
addpath(genpath('../../'));
DEBUG = 1;

%% input
[M.verts,M.faces] = read_mesh('SimpleChair1.obj');
nvertex = size(M.verts,1);
figure('Name','localsalency'); set(gcf,'color','white');hold off;
h=trisurf(M.faces,M.verts(:,1),M.verts(:,2),M.verts(:,3), 'FaceVertexCData', M.verts(:,3)); axis off; axis equal; mouse3d
set(h, 'edgecolor', 'none'); % cancel display of edge.
colormap jet(256); 