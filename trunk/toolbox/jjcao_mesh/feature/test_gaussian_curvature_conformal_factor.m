% test_compute_angle_defect
%
% Copyright (c) 2012 JJCAO
%% initialize & read mesh
setup;
tau = 1.2;% options for display
test_file = {[MYTOOLBOXROOT 'data/cube_602.off'],[MYTOOLBOXROOT 'data/fandisk.off'],[MYTOOLBOXROOT 'data/100.off'],'E:\jjcao_data\MeshsegBenchmark-1.0\data\off\99.off'};
filename = test_file{4};
[verts,faces] = read_mesh(filename);
%% curvature by angle defect & corresponding conformal factor
Cgauss = compute_angel_defect(verts, faces);
options.figname='Cgauss by angle defect';options.position='northwest';
plot_mesh_scalar(verts, faces, Cgauss, options);

options.Cgauss = Cgauss;
cf = compute_conformal_factor(verts, faces, options);  
options.figname='Conformal factor by angle defect';options.position='north';
plot_mesh_scalar(verts, faces, cf, options);

%% curvature by normal cycle & corresponding conformal factor
options.curvature_smoothing = 3; % defualt is 3
[Umin,Umax,Cmin,Cmax,Cmean,Cgauss1,Normal] = compute_curvature(verts,faces,options);
options.figname='Cgauss by normal cycle';options.position='northeast';
plot_mesh_scalar(verts, faces, Cgauss1, options);

options.Cgauss = Cgauss1;
cf1 = compute_conformal_factor(verts, faces, options);  
options.figname='Conformal factor by normal cycle';options.position='southwest';
plot_mesh_scalar(verts, faces, cf1, options);

