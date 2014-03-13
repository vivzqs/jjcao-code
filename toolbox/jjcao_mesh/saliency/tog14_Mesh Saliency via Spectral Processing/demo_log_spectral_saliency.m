clc;clear all;close all;
addpath(genpath('../../../'));
%% input
symmetrize=1 ;
normalize=1;

M.filename = 'Bimba_cvd_30K_R22.off';
M_reduced.filename = 'Bimba_cvd_30K_R22_reduce1001.off';
% [M.verts,M.faces] = read_mesh(M.filename); M.nverts = size(M.verts,1);
[M_reduced.verts,M_reduced.faces] = read_mesh(M_reduced.filename); M_reduced.nverts = size(M_reduced.verts,1);

%% compute W & L
A = triangulation2adjacency(M_reduced.faces);
ind = find(A>0);
[I, J] = ind2sub(size(A), ind);
dist2 = sum((M_reduced.verts(I,:) - M_reduced.verts(J,:)).^2, 2);
W = sparse(I,J, 1.0\(dist2+0.0000001) );


d = sum(W,2);
if symmetrize==1 && normalize==0
    L = diag(d) - W;
elseif symmetrize==1 && normalize==1    
    L = speye(M_reduced.nverts) - diag(d.^(-1/2)) * W * diag(d.^(-1/2));
elseif symmetrize==0 && normalize==1
    L = speye(M_reduced.nverts) - diag(d.^(-1)) * W;
else
    error('Does not work with symmetrize=0 and normalize=0');    
end
NW = diag(d.^(-1)) * W;

%% compute eigvector according to eigvalue in increasing order of magnitude, 
% [eigv,eigvalue] = eigs(L,M_reduced.nverts,'m'); %  matrix eigv whose columns are the corresponding eigenvectors
[eigv,eigvalue] = eig(full(L)); 
eigvalue = diag(eigvalue);
[lamda, index] = sort(eigvalue);
eigvalue = diag(lamda);
eigv = eigv(:, index);

sum( sum(L - eigv*eigvalue*eigv'))

rank(full(L))
