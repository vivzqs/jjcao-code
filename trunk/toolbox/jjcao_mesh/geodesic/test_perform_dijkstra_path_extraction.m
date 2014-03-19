% test perform_dijkstra_path_extraction
%
%
% Copyright (c) 2012 Junjie Cao

clear;clc;close all;
addpath(genpath('../../'));

[verts,faces] = read_mesh('/data/catHead_v131.off');
nverts = size(verts,1);
A = triangulation2adjacency(faces,verts);% this is a distance matrix

start_points = 1;
options.end_points = round(0.8 * nverts);
options.nb_iter_max = Inf;
[D,S] = perform_dijkstra(A, start_points, options);
% options.end_points = round(0.8 * nverts);
path = perform_dijkstra_path_extraction(A,D,options.end_points); 

figure('Name','shortest path by Dijkstra'); set(gcf,'color','white');
h=trisurf(faces,verts(:,1),verts(:,2),verts(:,3), ...
    'FaceVertexCData', D, 'edgecolor','none');
axis off;    axis equal;   set(gcf,'Renderer','OpenGL'); shading interp;
camorbit(0,0,'camera'); axis vis3d; view(-90, 0); mouse3d; colorbar;hold on;

scatter3(verts(path,1), verts(path,2),verts(path,3),40,'b','filled');
