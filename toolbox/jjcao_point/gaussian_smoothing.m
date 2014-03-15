% function nfunc = gaussian_smoothing(verts, func, neighDist, sigma2, kdtree)
% smoothing a scalar or vector function func defined on verts, using
% Gaussian with sigma^2 = sigma2, and find neighbor vertices within
% neighDist via kdtree.
%
% verts: n*m matrix, which are n m-dimentional points, such as n*3 in 3d space
% func: n*m1 matrix, which is a function defined on verts, you can set func=verts to smooth the point set
% neighDist: n*1 distance vector, neighDist(i) is used to collect neighbors of vertex i
% sigma2: n*1 vector, sigma2(i) is sigma^2 for the Gaussian filter of vertex i
%
% jjcao @ 2014
%