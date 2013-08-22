function fid = compute_mesh_harmonic_field(verts, faces, constraint_id, constraint_value, type)
% 
% Copyright (c) 2013 Junjie Cao

options.use_c_implementation = 1;
L = compute_mesh_laplacian(verts,faces,type,options);

options.method = 'hard';% 'hard', 'soft'
b = zeros(size(L,1),1);
fid = compute_least_square_system(L, b, constraint_id, constraint_value,options);