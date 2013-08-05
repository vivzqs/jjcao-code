%% demo_mesh_saliency
%
%
% Copyright (c) 2013 Pingping Tao, Junjie Cao

clear;clc;close all;

DEBUG=true;

%MYTOOLBOXROOT='E:/jjcaolib/toolbox';
MYTOOLBOXROOT='../..';
addpath ([MYTOOLBOXROOT '/jjcao_mesh'])
addpath ([MYTOOLBOXROOT '/jjcao_mesh/feature'])
addpath ([MYTOOLBOXROOT '/jjcao_mesh/smoothing'])
addpath ([MYTOOLBOXROOT '/jjcao_io'])
addpath ([MYTOOLBOXROOT '/jjcao_plot'])
addpath ([MYTOOLBOXROOT '/jjcao_interact'])
addpath ([MYTOOLBOXROOT '/jjcao_common'])
addpath ([MYTOOLBOXROOT '/kdtree'])

%%
M.filename = 'E:\DGAL-0.1.0\data\animal\armadillo.off';
[M.verts,M.faces] = read_mesh(M.filename);
M.nverts = size(M.verts,1);
vmax=max(M.verts);
vmin=min(M.verts);
eps = 0.003*sqrt(sum((vmax-vmin).^2));%%%包围盒对角线的倍数
tree = kdtree_build(M.verts);
A = triangulation2adjacency(M.faces);

%%
tic
options.curvature_smoothing = 3; % defualt is 3
[Umin,Umax,Cmin,Cmax,Cmean,Cgauss,Normal] = compute_curvature(M.verts,M.faces,options);%%%计算曲率

if DEBUG
    figure('Name','abs mean curvature'); set(gcf,'color','white');hold off;
    h=trisurf(M.faces,M.verts(:,1),M.verts(:,2),M.verts(:,3), ...
       'FaceVertexCData', abs(Cmean) ); axis off; axis equal; mouse3d
    set(h, 'edgecolor', 'none'); % cancel display of edge.
    colormap jet(256);
end

%%
finalsalency = zeros(M.nverts,1);
saliency = zeros(M.nverts,5);
for i= 2:size(saliency,2)+1
    delta = i*eps;

    GaussWeighcurvature = compute_gaussian_weighted_curvature(M.verts,Cmean,delta,tree);%%%计算平均曲率高斯加权平均

    saliency(:,i-1) = GaussWeighcurvature(:,1) - GaussWeighcurvature(:,2);
    saliency(:,i-1) = abs(saliency(:,i-1)); %%%%显著性值
    Msalency = max(saliency(:,i-1));
    saliency(:,i-1) = saliency(:,i-1)./Msalency;%%%归一化

    Msalency = 1;
    localmaxsalency = local_max_average(saliency(:,i-1),Msalency,A);%%%局部最大值的平均

    if DEBUG
        figure('Name','i'); set(gcf,'color','white');hold off;
        h=trisurf(M.faces,M.verts(:,1),M.verts(:,2),M.verts(:,3), ...
        'FaceVertexCData', saliency(:,i-1)); axis off; axis equal; mouse3d
        set(h, 'edgecolor', 'none'); % cancel display of edge.
        colormap jet(256);
    end

    saliency(:,i-1) = saliency(:,i-1).*(Msalency-localmaxsalency)^2;
    finalsalency = finalsalency + saliency(:,i-1);

end
kdtree_delete(tree)


figure('Name','7'); set(gcf,'color','white');hold off;
h=trisurf(M.faces,M.verts(:,1),M.verts(:,2),M.verts(:,3), ...
    'FaceVertexCData', finalsalency); axis off; axis equal; mouse3d
set(h, 'edgecolor', 'none'); % cancel display of edge.
colormap jet(256); 

toc









