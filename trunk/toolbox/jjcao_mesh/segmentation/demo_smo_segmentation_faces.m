% Copyright (c) 2012 Junjie Cao

clear;clc;close all;
%MYTOOLBOXROOT='E:/jjcaolib/toolbox';
MYTOOLBOXROOT='../..';
addpath ([MYTOOLBOXROOT '/jjcao_mesh'])
addpath ([MYTOOLBOXROOT '/jjcao_io'])
addpath ([MYTOOLBOXROOT '/jjcao_plot'])
addpath ([MYTOOLBOXROOT '/jjcao_interact'])
addpath ([MYTOOLBOXROOT '/jjcao_common'])
addpath ([MYTOOLBOXROOT '/jjcao_mesh/supervertex'])
addpath ('div_rank')

%% input
DEBUG=1;

M.filename = [MYTOOLBOXROOT '/data/cube_f300.off']; %cube_f1200,
[M.verts,M.faces] = read_mesh(M.filename);
nface = size(M.faces,1);
[normal M.fnormal] = compute_normal(M.verts,M.faces);
M.fnormal = M.fnormal';

if DEBUG
    figure('Name','Input'); set(gcf,'color','white'); 
    h = plot_mesh(M.verts, M.faces);    view3d rot;   hold on;
    verts = M.verts(M.faces(1,:),:);   
    h=scatter3(verts(:,1),verts(:,2),verts(:,3),40,'b','filled');
    delete(h);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% setting
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
M.nsegments = 19;
M.USE_CONCAVE_WEIGHT = 1;
M.constZ = 0.01 ;% The contant for ground conductance
M.thresDist = 0.01; % let adjaceny matrix more sparse
M.merge_option = 1; % 0: not merge; 1: merge segments by potential; 2: you have to set M.thresMerge
M.thresMerge = 0.1; % merge segments by reducing number of nsegments, thresMerge is threshold for difference of possibility of a face belong to different segments.

% Select a method to solve linear eq Ax=b.
% 0: incremental inverse. 
% 1: LU decomposition.
% Others: naive backslash. 
M.LIN_MODE = 0 ;

%% compute adjacency matrix by inner product of face features
A = compute_face_features(M.verts,M.faces,M.fnormal,M.USE_CONCAVE_WEIGHT);
% Distances less than ThresDist are set to 0. 
if DEBUG
    ind = find(A); tmp = full(A(ind));
    sprintf('distances less thresDist(%f): %d', M.thresDist, sum(tmp<M.thresDist))
end
A(A<M.thresDist) = 0 ;
% Set diagonal elements to zeros
A(eye(size(A))~=0)=0 ;

%% Run Diversity Ranking
% todo: better Z, 
% conductance to dummy ground
Z =  M.constZ*mean(A(A>0)) ;
% Each SP is weighted by its number of faces
massSP = ones(nface,1);

% (1) Lazy greedy
[rank_set rank_set_val] = run_div_rank_lazy_greedy(A, M.nsegments, M.LIN_MODE, Z*ones(nface,1),1:nface,massSP);
% [rank_set rank_set_val] = run_div_rank_lazy_greedy(locNet, K, LIN_MODE, Z_SP, EvalSet, massSP) 
% (2) naive greedy
% [rank_set rank_set_val] = run_div_rank_naive_greedy(A, M.nsegments, M.LIN_MODE, Z*ones(nface,1),1:nface,massSP);

%% determine acutal segmentation number
options.merge_option=M.merge_option;
options.nclusters=M.nsegments; 
options.thresMerge=M.thresMerge; 
[M.face_segments,cluster_info,probMat] = compute_actual_clusters(A,rank_set,rank_set_val,options);
M.nsegments = length(cluster_info);
sprintf('num of segments: %d', M.nsegments)
cluster_info'

%% show result
figure('Name','Segment by SMO'); set(gcf,'color','white');
options.face_vertex_color = M.face_segments;
h = plot_mesh(M.verts, M.faces, options);
colormap(jet(M.nsegments));view3d rot;
lighting none;

%% save result
[pathstr, name, ext] = fileparts(M.filename);
save(sprintf('%s_seg_%d_som.mat', ['result/' name], M.nsegments), 'M');
%% show process
% figure('Name','Segment process by SMO'); set(gcf,'color','white');
% for j=1:M.nsegments,      
%     tmp = zeros(size(M.face_segments));
%     tmp(M.face_segments==j)=j;
%     options.face_vertex_color = tmp;
%     h = plot_mesh(M.verts, M.faces, options);view3d rot;lighting none;colormap(jet(M.nsegments));
%     pause;
%     delete(h);
% end