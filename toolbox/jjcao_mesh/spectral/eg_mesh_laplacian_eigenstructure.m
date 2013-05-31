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
M.filename = test_file{2};
[M.verts,M.faces] = read_mesh(M.filename);
M.nverts = size(M.verts,1);

figure('Name','Mesh'); set(gcf,'color','white');hold on;
h=trisurf(M.faces,M.verts(:,1),M.verts(:,2),M.verts(:,3), ...
    'FaceColor', 'cyan', 'edgecolor',[1,0,0], 'faceAlpha', 1.0); axis off; axis equal; mouse3d;

%% compute Laplacian matrix and its eigenstructure
options.use_c_implementation = 1;
tic
L = compute_mesh_laplacian(M.verts,M.faces,'conformal',options);%Manifold-harmonic,Mean_curvature, conformal, combinatorial
toc

k=50;
% vertArea;
% A = sparse(1:length(vertArea),1:length(vertArea), vertArea);
% [eigvec,eigv] = eigs(L,A,k,'sm');% compute the first k smallest eigenvalue
[eigvec,eigv] = eigs(L,k,'sm');
[eigv, index] = sort(eigv);%The increasing order
eigvec = eigvec(:, index);
lamda = diag(eigv);

%% display basis function
shading_type = 'interp';
for i = 1:ceil(length(lamda)/4):length(lamda)
%     subplot(2,2,i); 
    figure('Name', sprintf('eigen function: %d', i));
    h=trisurf(M.faces,M.verts(:,1),M.verts(:,2),M.verts(:,3), ...
        'FaceVertexCData', eigvec(:,i), 'FaceColor',shading_type); axis off; axis equal; set(h, 'edgecolor', 'none'); mouse3d;
end



