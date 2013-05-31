%
% Copyright (c) 2013 Junjie Cao

clear;clc;close all;
%MYTOOLBOXROOT='E:/jjcaolib/toolbox';
MYTOOLBOXROOT='../../';
addpath ([MYTOOLBOXROOT '/jjcao_mesh'])
addpath ([MYTOOLBOXROOT '/jjcao_io'])
addpath ([MYTOOLBOXROOT '/jjcao_plot'])
addpath ([MYTOOLBOXROOT '/jjcao_interact'])
addpath ([MYTOOLBOXROOT '/jjcao_common'])

%% load a mesh
test_file = {[MYTOOLBOXROOT '/data/fandisk.off'],[MYTOOLBOXROOT '/data/wolf0.off'],[MYTOOLBOXROOT '/data/catHead_v131.off']};
M.filename = test_file{3};
[M.verts,M.faces] = read_mesh(M.filename);
M.nverts = size(M.verts,1);

figure('Name','Mesh'); set(gcf,'color','white');hold on;
h=trisurf(M.faces,M.verts(:,1),M.verts(:,2),M.verts(:,3), ...
    'FaceColor', 'cyan', 'edgecolor',[1,0,0], 'faceAlpha', 1.0); axis off; axis equal; view3d rot;

%% compute Laplacian matrix
options.use_c_implementation = 1;
tic
L = compute_mesh_laplacian(verts,faces,'conformal',options);%Manifold-harmonic,Mean_curvature, conformal, combinatorial
toc

%% display mesh

% shading_type = 'interp';
% h=trisurf(M.faces,M.verts(:,1),M.verts(:,2),M.verts(:,3), ...
%     'FaceVertexCData', M.verts(:,1), 'FaceColor',shading_type, 'faceAlpha', 0.9); axis off; axis equal; view3d rot;


