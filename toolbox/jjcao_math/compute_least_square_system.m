function fid = compute_least_square_system(A, b, constraint_id, constraint_value,options)
% solve Ax=b in least square way, with Dirichlet boundary conditions (constraints)
% 
% Copyright (c) 2013 Junjie Cao

method = getoptions(options, 'method', 'hard'); % 'hard', 'soft'
solver = getoptions(options, 'solver', 1); % 1: simplest way;
switch lower(method) 
    case 'hard'
        fid = compute_lss_hard(A, b, constraint_id, constraint_value,solver);
    case {'soft'}
        error('to be supported!');
        %fid = compute_lss_soft(vertices,faces,constraint_id,delta_coords,s_weights,c_weights,options);
    otherwise
        error('Unknown method.');
end

function fid = compute_lss_hard(A, b, constraint_id, constraint_value,solver)
% jjcao
% build system ///////////////////////////////////////////////////////////////////
b(constraint_id,:) = constraint_value;
A(constraint_id,:) = 0;
n = size(A,1);
A = A + sparse(constraint_id, constraint_id, 1, n, n);

% solve ///////////////////////////////////////////////////////////////////
fid = A\b;
