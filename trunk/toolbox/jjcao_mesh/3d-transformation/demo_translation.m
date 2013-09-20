% demo_translation
%  
%
% Copyright (c) 2013 Junjie Cao
clc;clear all;close all;
addpath(genpath('../../'));
DEBUG = 1;

%% input
[parts, vertices]= read_parts_obj('CR1b.obj');
if DEBUG
    figure('Name','input'); set(gcf,'color','white');hold on;
    for i=1:length(parts)
        h=trisurf(parts(i).faces,vertices(:,1),vertices(:,2),vertices(:,3), 'FaceVertexCData', vertices(:,3));     
    end
    set(h, 'edgecolor', 'none');colormap jet(256); axis off; axis equal; mouse3d;
end
%% display pair
pair = [2, 3];
faces1 = parts(pair(1)).faces;
faces2 = parts(pair(2)).faces;
verts1 = vertices(min(faces1):max(faces1),:);
verts2 = vertices(min(faces2):max(faces2),:);
figure('Name','parts'); set(gcf,'color','white');hold on;axis off; axis equal; mouse3d;
h=trisurf(parts(pair(1)).faces,vertices(:,1),vertices(:,2),vertices(:,3),'faceAlpha', 0.5);
set(h, 'FaceColor', 'g');
h=trisurf(parts(pair(2)).faces,vertices(:,1),vertices(:,2),vertices(:,3),'faceAlpha', 0.5);
set(h, 'FaceColor', 'b');
scatter3(verts1(:,1),verts1(:,2), verts1(:,3),50,'g','filled');
scatter3(verts2(:,1),verts2(:,2), verts2(:,3),50,'b','filled');

%%
transVec = [-0.460808, 0.00356283, -0.0153173];
verts2new = verts2 + repmat(transVec, size(verts2,1), 1);
scatter3(verts2new(:,1),verts2new(:,2), verts2new(:,3),100,'r','filled');