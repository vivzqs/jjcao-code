%
%  
%
% Copyright (c) 2013 Junjie Cao
clc;clear all;close all;
addpath(genpath('../../'));
DEBUG = 1;

%% input
[parts, vertices]= read_parts_obj('bed4.obj');
figure('Name','input'); set(gcf,'color','white');hold on;
for i=1:length(parts)
    h=trisurf(parts(i).faces,vertices(:,1),vertices(:,2),vertices(:,3), 'FaceVertexCData', vertices(:,3));     
end
set(h, 'edgecolor', 'none');colormap jet(256); axis off; axis equal; mouse3d;

%% display 14:end
center = [-0.0024349034754079669, 0.0011981667684872500, 0.41850917842184293];
normal = [0.99999988671599760, -0.00047026608887869612, 7.3605691682412054e-005];
plane = createPlane(center, normal);
drawPlane3d(plane);
