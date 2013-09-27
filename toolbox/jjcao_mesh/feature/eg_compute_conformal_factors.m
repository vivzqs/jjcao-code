function eg_compute_conformal_factors(file,type)
% eg_compute_conformal_factors - example for computing conformal factors on a mesh
%
%   [] = eg_compute_conformal_factors(file);
%
%   file is the mesh name
%
%
%   Example 1: eg_compute_conformal_factors armadillo_v502.off
%   Example 2: eg_compute_conformal_factors armadillo_v502.off 'normal cycle'
%   Copyright (c) 2009 JJCAO
clear options;

if nargin < 1
    clear;clc;close all;
    addpath(genpath('../../'));
    file = 'armadillo_v4326.off';
    file = 'wolf0.off';
%     file = 'catHead_v131.off';
end

[verts,faces]=read_mesh(file);
Mhe = to_halfedge(verts, faces);
boundary = Mhe.boundary_vertices;
if iscell(boundary)
    boundary=cell2mat(boundary)';
end
%% ////////////////////////////////////////////////////////////////////////
% compute original Gaussian curvature and target Gaussian curvature
if nargin<2
%     type = 'angle_defect';
    type = 'normal cycle';
end
options.type = type;
options.rings = compute_vertex_face_ring(faces);
options.boundary = boundary;
options.show_error = 0;
phi = compute_conformal_factor(verts, faces, options);
csvwrite('cf.txt', phi);
%% find local minimal extrema
[maxIdx, minIdx] = extrema(faces, phi, 1, 1.0);
minv = min(phi); maxv = max(phi);

ext = minIdx;
ev = phi(ext);
% threshold = min(ev) + (max(ev)-min(ev))*0.5;
% ext = ext(find(ev<threshold));

% ext = maxIdx;
% ev = phi(ext);
% threshold = min(ev) + (max(ev)-min(ev))*0.5;
% ext = ext(find(ev>threshold));

ev = (ev-minv)/(maxv-minv);
sprintf('num of extrema: %d\n',length(ext))

%% display 
figure('Name','Conformal Factor');%hold on;
col = (phi-minv)/(maxv-minv);
%col(col==Inf) = 0;
options.face_vertex_color = col;
%options.edge_color = [1 1 1]*0;% for black
h = plot_mesh(verts, faces, options);
set(h, 'edgecolor', 'none');
colormap jet(256);
hold on;

% display contour
options.values = 0:0.05:1;
options.lineWidth = 2;
plot_contours( faces, verts, col, options);
view3d ROT;

% display minimal extrema
verts = verts';ext = ext';
h = plot3(verts(1,ext),verts(2,ext), verts(3,ext), 'r.');
set(h, 'MarkerSize', 25);
verts = verts';ext = ext';
hold off;