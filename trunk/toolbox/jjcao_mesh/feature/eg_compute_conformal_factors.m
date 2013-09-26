%function eg_compute_conformal_factors(file,type)
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
    file = 'armadillo_v4326.off';
end
file = '161.off';%camel,pig1,dancer_v4000_f8000.off

[vertices,faces]=read_mesh(file);
Mhe = to_halfedge(vertices, faces);
boundary = Mhe.boundary_vertices;
if iscell(boundary)
    boundary=cell2mat(boundary)';
end
%% ////////////////////////////////////////////////////////////////////////
% compute original Gaussian curvature and target Gaussian curvature
if nargin<2
    type = 'angle_defect';
end
options.type = type;
options.rings = compute_vertex_face_ring(faces);
options.boundary = boundary;
options.show_error = 0;
phi = compute_conformal_factor(vertices, faces, options);
csvwrite('cf.txt', phi);
%% find local minimal extrema
[extrema, minv, maxv] = compute_local_extrema(phi, Mhe.vertex_neighbors());
ev = phi(extrema);
threshold = min(ev) + (max(ev)-min(ev))*0.5;
extrema = extrema(find(ev<threshold));
ev = (ev-minv)/(maxv-minv);
sprintf('num of extrema: %d\n',length(extrema))

%% display 
figure('Name','Conformal Factor');%hold on;
col = (phi-minv)/(maxv-minv);
%col(col==Inf) = 0;
options.face_vertex_color = col;
%options.edge_color = [1 1 1]*0;% for black
h = plot_mesh(vertices, faces, options);
set(h, 'edgecolor', 'none');
colormap jet(256);
hold on;

% display contour
options.values = 0:0.05:1;
options.lineWidth = 2;
plot_contours( faces, vertices, col, options);
view3d ROT;

% display minimal extrema
vertices = vertices';extrema = extrema';
h = plot3(vertices(1,extrema),vertices(2,extrema), vertices(3,extrema), 'r.');
set(h, 'MarkerSize', 25);
vertices = vertices';extrema = extrema';
hold off;