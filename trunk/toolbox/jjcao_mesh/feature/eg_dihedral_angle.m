% compute signed dihedral angle
% 
% Copyright (c) 2013 Junjie Cao

clc;clear all;close all;
addpath(genpath('../../'));

verts = [0,0,0;1,0,0;1,1,0; 1, 0, -1];
faces = [1,2,3;1,4,2];
% faces = [1,3,2;1,4,2];
[normal,normalf] = compute_normal(verts,faces,0);
normalf = normalf';

figure; set(gcf,'color','white');hold on;
shading_type = 'flat';
h=trisurf(faces,verts(:,1),verts(:,2),verts(:,3), ...
    'FaceVertexCData', [0,1,0;0,0,1], 'FaceColor',shading_type); axis off;axis equal; mouse3d;
drawAxis3d(1, 0.02);%Ox vector is red, Oy vector is green, and Oz vector is blue.
text('Position',verts(1,:),'String','v1')
text('Position',verts(2,:),'String','v2')
text('Position',verts(3,:),'String','v3')
text('Position',verts(4,:),'String','v4')

pos = [mean(verts(faces(1,:),:));mean(verts(faces(2,:),:))];
h = quiver3(pos(1, 1), pos(1, 2), pos(1, 3), ...
    normalf(1, 1), normalf(1, 2), normalf(1, 3), 0.5,'g');
h = quiver3(pos(2, 1), pos(2, 2), pos(2, 3), ...
    normalf(2, 1), normalf(2, 2), normalf(2, 3), 0.5,'b');

%%
p0 = verts(3,:); p1 = verts(4,:);
n0 = normalf(1,:); n1 = normalf(2,:);
dist01 = dot(n0,p0)-dot(n0,p1);
dist10 = dot(n1,p1)-dot(n1,p0);
if abs(dist01) > abs(dist10)
    sign = dist01;
else
    sign = dist10;
end
alpha = acos(dot(n0,n1));
if alpha > pi
    alpha = pi - alpha;
end
alpha = sign*alpha