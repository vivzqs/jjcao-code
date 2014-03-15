clc;clear all;close all;
addpath(genpath('../../../'));
options.bSymmetrize=1;
options.bNormalize=0;
options.diagLength = 800;
options.n = 9;
epsilon = 0.002 * options.diagLength; % see the paper
t = (1:5)*epsilon^2; % see the paper
dist_const = 2.5; % see the paper

%% input
M.filename = 'Bimba_cvd_30K_R22.off';
M.filename = 'wolf2_v753.off';
% 85_v1089.off, 85_v1814.off, wolf2_v753.off
% armadillo_v502.off, gargoyle_v502.off,dragon_v1257.off,v2.off
% sphere1.obj,cube_f1200.off,torus_v500.off
% Bimba_cvd_30K_R22_reduce1001.off
[M.verts,M.faces] = read_mesh(M.filename); M.nverts = size(M.verts,1);
M.verts  = normalize_vertex3d(M.verts,options.diagLength);
tree = kdtree_build(M.verts);

%% compute k by eq 17, not understand it still!
A = triangulation2adjacency(M.faces); % adjacency matrix 
ind = find(A>0);
[I, J] = ind2sub(size(A), ind);
dist2 = sum((M.verts(I,:) - M.verts(J,:)).^2, 2);
c = mean(sqrt(dist2));% average distance of all edges
sumDistPerVert = sum( sparse(I,J, sqrt(dist2)), 2);
k = c*sum(A,2)./sumDistPerVert + 1;

% W = sparse(I,J, 1.0\(dist2+0.0000001) );
% d = sum(W,2);
%% local averaging filter
% figure(3);set(gcf,'color','white');shading_type = 'interp';
% axis equal; colormap jet(256);    
for i = t
    % Mt
    
    verts = gaussian_smoothing(M.verts, M.verts, dist_const*sqrt(i)*ones(length(k),1), i, tree);
    % SMt: saliency of Mt
    SMt = log_spectral_saliency(verts, M.faces, options);
    % Mkt
    verts = gaussian_filter(M.verts, dist_const*sqrt(i*k), i*k, tree);
    % SMkt: saliency of Mkt
    SMkt = log_spectral_saliency(verts, M.faces, options);
    % absolute difference of them
    S(:,i) = abs(SMkt - SMt);
    % map back to original mesh
    % ...    
end
kdtree_delete(tree);
Saliency = sum(S,2);
% smooth Saliency with Laplaican smoothing 10 times?
for i = 1:10
    Saliency = M.L * Saliency;
%     Saliency = M_orign.L * Saliency;
end
logSaliency = log(Saliency);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    subplot(5,4,4*(i-1)+1);
    
    Af = filter(ones(n,1),n,Lf); % Jn = ones(n,1)/n
    Rf = abs(Lf - Af);
    S = eigv*diag(exp(Rf))*eigv'*W;
    Sal = sum(S,2);

    h=trisurf(M.faces,M.verts(:,1),M.verts(:,2),M.verts(:,3), ...
    'FaceVertexCData', Sal, 'FaceColor',shading_type, 'faceAlpha', 0.9);
    set(h, 'edgecolor', 'none');axis off;colorbar;mouse3d; 
end

%%
if bSymmetrize==1 && bNormalize==0
    L = diag(d) - W;
elseif bSymmetrize==1 && bNormalize==1    
    L = speye(M.nverts) - diag(d.^(-1/2)) * W * diag(d.^(-1/2));
elseif bSymmetrize==0 && bNormalize==1
    L = speye(M.nverts) - diag(d.^(-1)) * W;
else
    error('Does not work with bSymmetrize=0 and bNormalize=0');    
end
NW = diag(d.^(-1)) * W;

%% compute eigvector according to eigvalue in increasing order of magnitude, 
% [eigv,eigvalue] = eigs(L,M.nverts,'m'); %  matrix eigv whose columns are the corresponding eigenvectors
[eigv,eigvalue] = eig(full(L)); 
eigvalue = diag(eigvalue);
[Hf, index] = sort(eigvalue);
eigvalue = diag(Hf);
eigv = eigv(:, index);

sum( sum(L - eigv*eigvalue*eigv'))
sprintf('L is symmetric: %d, normalized: %d, vertices: %d, rank: %d', ...
    bSymmetrize, bNormalize, length(L), rank(full(L)))

Hf(1) = 1; % Hf(2); %%%%%%%%%%%%%%%% pay attention!!
Lf = log(abs(Hf));
%% display
figure(1); 
plot([1:length(Hf)], Hf, 'b-'); xlabel('Frequency index');ylabel('Laplaican');

figure(2);
% plot([1:length(Hf)-1], Lf(2:end), 'g-'); xlabel('Frequency index');ylabel('Log Laplaican');
plot([1:length(Hf)], Lf, 'g-'); xlabel('Frequency index');ylabel('Log Laplaican');


