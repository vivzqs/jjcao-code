% test_gaussian_smoothing
%
% jjcao @ 2014
%
clc;clear all;close all;
addpath(genpath('../../'));
diagLength = 100;
epsilon = 0.002 * diagLength; 
t = (2:5)*epsilon^2; 
% t = (0.02* diagLength)^2;
dist_const = 2.5;
% dist_const = 5;

M.filename = 'wolf2_v753.off';
[M.verts,M.faces] = read_mesh(M.filename); M.nverts = size(M.verts,1);
M.verts  = normalize_vertex3d(M.verts,diagLength);
nverts = size(M.verts, 1);

%% prepare for adaptive gaussian smoothing filter
A = triangulation2adjacency(M.faces); % adjacency matrix 
ind = find(A>0);
[I, J] = ind2sub(size(A), ind);
dist2 = sum((M.verts(I,:) - M.verts(J,:)).^2, 2);
c = mean(sqrt(dist2));% average distance of all edges
sumDistPerVert = sum( sparse(I,J, sqrt(dist2)), 2);
k = c*sum(A,2)./sumDistPerVert + 1;

%% uniform & adaptive gaussian smoothing filter (see eq 17 of tog14_Mesh Saliency via Spectral Processing)
tree = kdtree_build(M.verts);
figure(1);set(gcf,'color','white'); movegui(1, 'northeast');
figure(2);set(gcf,'color','white'); movegui(2, 'southeast');
for i = t
    verts1 = gaussian_smoothing(M.verts, M.verts, dist_const*sqrt(i)*ones(nverts,1), i*ones(nverts,1), tree);
    figure(1);
    h=trisurf(M.faces,verts1(:,1),verts1(:,2),verts1(:,3), ...
     'FaceColor', 'interp',  'edgecolor','r'); axis equal;axis off;mouse3d; %light('Position',[1 0 0],'Style','infinite');lighting phong;
 
    verts2 = gaussian_smoothing(M.verts, M.verts,dist_const*sqrt(i*k), i*k, tree);
    figure(2);
    h=trisurf(M.faces,verts2(:,1),verts2(:,2),verts2(:,3), ...
     'FaceColor', 'interp',  'edgecolor','r'); axis equal;axis off;mouse3d; %light('Position',[1 0 0],'Style','infinite');lighting phong;   
 
    v = verts1 - verts2;
    sprintf('mean diff: %f', mean( sqrt(sum(v.^2,2)) ) )
end

kdtree_delete(tree);