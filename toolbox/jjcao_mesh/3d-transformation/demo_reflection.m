% demo_reflection
%  
%
% Copyright (c) 2013 Junjie Cao
clc;clear all;close all;
addpath(genpath('../../'));
DEBUG = 1;

%% input
[parts, vertices]= read_parts_obj('cr1b.obj');
if DEBUG
    figure('Name','input'); set(gcf,'color','white');hold on;
    for i=1:length(parts)
        h=trisurf(parts(i).faces,vertices(:,1),vertices(:,2),vertices(:,3), 'FaceVertexCData', vertices(:,3));     
    end
    set(h, 'edgecolor', 'none');colormap jet(256); axis off; axis equal; mouse3d;
end
%% display pair
pair = [4, 5];
[parts( pair(1)).name, '-', parts( pair(2)).name]

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

c1 = mean(verts1);
c2 = mean(verts2);
c = 0.5*(c1+c2);
line0 = createLine3d(c1, c2);
drawLine3d(line0, 'b');
scatter3(c(:,1),c(:,2), c(:,3),100,'r','filled');
%%
center = [0.0011368, -0.00506687, 0.641914];
normal = [0.999773, 0.021283, -3.70945e-05];
v1 = [-0.0031464717185976042,0.0031905399499505566,-0.99998996003487550];
v2 = [0.00015592593412902699,0.0032152731115763209,-0.99999481883953822];

plane0 = createPlane(center, normal);
drawPlane3d(plane0, 'g');

n2 = size(verts2,1);
normalMat = repmat(normal,n2,1);
centerMat = repmat(center,n2,1);
len = 2*sum(normalMat.*(centerMat-verts2),2);
verts2new = verts2 + repmat(len,1,3).*normalMat;
scatter3(verts2new(:,1),verts2new(:,2), verts2new(:,3),100,'r','filled');

%% distance 
[dist1, dist2] = dist_between_parts(verts1, verts2new);
(dist1+dist2)*0.5

p1 = min(verts1);
p2 = max(verts1);
sqrt( sum( (p1-p2).^2))

p1 = min(verts2);
p2 = max(verts2);
sqrt( sum( (p1-p2).^2))