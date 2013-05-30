% test_read_mesh
ov = [0 0 0; ...
    2 0 0; ...
    1 1.7321 0];
of = [1 2 3];

[v, f] = read_mesh('regular_triangle.off');

assert(sum(sum(ov-v))==0);
assert(sum(sum(of-f))==0);

disp('test_read_mesh passed.');