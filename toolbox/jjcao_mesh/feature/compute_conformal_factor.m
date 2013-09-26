function [phi, error] = compute_conformal_factor(vertices, faces, options)
%
%   Reffer to Characterizing Shape Using Conformal Factors_08_jjcao.pdf
%   and Conformal Flattening by Curvature Prescription and Metric
%   Scaling_08_jjcao.pdf
%
%   changed by jjcao @ 2012.10
%   Copyright (c) 2009 JJCAO
%%
options.null = 0;
if isfield(options, 'rings')
    areas_ring = compute_area_ring_faces(vertices, faces, options.rings);
else
    areas_ring = compute_area_ring_faces(vertices, faces);
end

if isfield(options, 'Cgauss')
    K_orig = options.Cgauss;
else
    K_orig = compute_gaussian_curvature(vertices, faces, options);%Gaussian curvature of original mesh
end

c_orig = sum(K_orig);
faces_area = compute_area_faces(vertices, faces);
total_area = sum(faces_area);%total area;
K_t = c_orig*areas_ring/(3*total_area); 

%% solve conformal factor phi (L*phi = K_t - K_orig)
type = 'Laplace-Beltrami'; % the other choice is 'combinatorial', 'distance', spring, 'Laplace-Beltrami', mvc, 
options.normalize = 0; options.symmetrize = 1;
L = compute_mesh_laplacian(vertices,faces, type,options);
b = K_t - K_orig;
%b = abs(K_t - K_orig); %有找对称轴的效果
%b = abs(abs(K_t) - abs(K_orig));%有找1/4部分的效果
phi = L\b;
%phi = L * phi;


%% compute error 
% compute metric scale, new metric and new curvature, and compare
% conformal factor => metric => new target curvature
if isfield(options, 'show_error')
    show_error = options.show_error;
else
    show_error = 0;
end
if ~show_error
    return;
end
%options.type = 'angle_defect';
options.conformal_factors = phi;
cs_computed = compute_gaussian_curvature(vertices, faces, options);

figure('Name','Difference of Gaussian curvature (target - computed)');%hold on;
error = abs(K_t - cs_computed);
error(error==Inf) = 0;
%minv = min(error); maxv = max(error);
%error = (error-minv)/(maxv-minv);

options.face_vertex_color = error;
h = plot_mesh(vertices, faces, options);
set(h, 'edgecolor', 'none');
colormap jet(256);