clc;clear all;close all;
addpath(genpath('../../../'));
%% input
bSymmetrize=1;
bNormalize=0;

M.filename = 'Bimba_cvd_30K_R22.off';
M_reduced.filename = '85_v1089.off';
% 85_v1089.off, 85_v1814.off
% armadillo_v502.off, gargoyle_v502.off,dragon_v1257.off,v2.off
% sphere1.obj,cube_f1200.off,torus_v500.off
% Bimba_cvd_30K_R22_reduce1001.off
% [M.verts,M.faces] = read_mesh(M.filename); M.nverts = size(M.verts,1);
[M_reduced.verts,M_reduced.faces] = read_mesh(M_reduced.filename); M_reduced.nverts = size(M_reduced.verts,1);
M_reduced.verts = normalize(M_reduced.verts,1600);

%% compute W & L
A = triangulation2adjacency(M_reduced.faces);
ind = find(A>0);
[I, J] = ind2sub(size(A), ind);
dist2 = sum((M_reduced.verts(I,:) - M_reduced.verts(J,:)).^2, 2);
W = sparse(I,J, 1.0\(dist2+0.0000001) );


d = sum(W,2);
if bSymmetrize==1 && bNormalize==0
    L = diag(d) - W;
elseif bSymmetrize==1 && bNormalize==1    
    L = speye(M_reduced.nverts) - diag(d.^(-1/2)) * W * diag(d.^(-1/2));
elseif bSymmetrize==0 && bNormalize==1
    L = speye(M_reduced.nverts) - diag(d.^(-1)) * W;
else
    error('Does not work with bSymmetrize=0 and bNormalize=0');    
end
NW = diag(d.^(-1)) * W;

%% compute eigvector according to eigvalue in increasing order of magnitude, 
% [eigv,eigvalue] = eigs(L,M_reduced.nverts,'m'); %  matrix eigv whose columns are the corresponding eigenvectors
[eigv,eigvalue] = eig(full(L)); 
eigvalue = diag(eigvalue);
[Hf, index] = sort(eigvalue);
eigvalue = diag(Hf);
eigv = eigv(:, index);

sum( sum(L - eigv*eigvalue*eigv'))
sprintf('L is symmetric: %d, normalized: %d, vertices: %d, rank: %d', ...
    bSymmetrize, bNormalize, length(L), rank(full(L)))

Hf(1) = Hf(2); %%%%%%%%%%%%%%%% pay attention!!
Lf = log(abs(Hf));
%% display
figure(1); 
plot([1:length(Hf)], Hf, 'b-'); xlabel('Frequency index');ylabel('Laplaican');

figure(2);
% plot([1:length(Hf)-1], Lf(2:end), 'g-'); xlabel('Frequency index');ylabel('Log Laplaican');
plot([1:length(Hf)], Lf, 'g-'); xlabel('Frequency index');ylabel('Log Laplaican');

%% local averaging filter
n = 9;
figure(3);set(gcf,'color','white');shading_type = 'interp';
 axis equal; colormap jet(256);    
for i = 1:2 %现在每次都一样，等着改！
    Af = filter(ones(n,1),n,Lf); % Jn = ones(n,1)/n
    Rf = abs(Lf - Af);
    S = eigv*diag(exp(Rf))*eigv'*W;
    Sal = sum(S,2);

    h=trisurf(M_reduced.faces,M_reduced.verts(:,1),M_reduced.verts(:,2),M_reduced.verts(:,3), ...
    'FaceVertexCData', Sal, 'FaceColor',shading_type, 'faceAlpha', 0.9);
    set(h, 'edgecolor', 'none');axis off;colorbar;mouse3d; 
end
