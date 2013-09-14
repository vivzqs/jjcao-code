%
%  
%
% Copyright (c) 2013 Junjie Cao
clc;clear all;close all;
addpath(genpath('../../'));
DEBUG = 1;

%% input
v1 = [0.237177, 0.192375, 0.512662
0.236715, 0.193593, 0.529592
0.236246, 0.195137, 0.546493
0.235821, 0.196803, 0.563384
0.235499, 0.198536, 0.580271
0.2353, 0.200306, 0.597155
0.23519, 0.202081, 0.614041
0.235121, 0.20385, 0.630928
0.235074, 0.205606, 0.647815
0.235048, 0.207346, 0.664704
0.235041, 0.209065, 0.681596
0.235035, 0.210761, 0.698489
0.235034, 0.212436, 0.715386
0.235042, 0.214084, 0.732284
0.235048, 0.215718, 0.749184
0.235048, 0.217355, 0.766083
0.235045, 0.219002, 0.782982
0.235042, 0.220672, 0.799878
0.235048, 0.222379, 0.81677
0.23509, 0.224157, 0.833656
0.235161, 0.225986, 0.850536
0.235233, 0.227832, 0.867413
0.235299, 0.229682, 0.884291
0.235353, 0.231523, 0.901169
0.235397, 0.233334, 0.91805
0.235424, 0.235104, 0.934938
0.235439, 0.236857, 0.951827
0.235452, 0.238609, 0.968715
0.235464, 0.24036, 0.985603
0.235476, 0.242114, 1.00249
0.235488, 0.243871, 1.01938
0.235507, 0.245639, 1.03626
0.23555, 0.24741, 1.05315
0.235608, 0.249179, 1.07003
0.23572, 0.250929, 1.08692
0.235925, 0.252854, 1.10379
0.23614, 0.254803, 1.12066];

v2 = [-0.229895, 0.194241, 0.51736
-0.229454, 0.195681, 0.534269
-0.229211, 0.197126, 0.551183
-0.229009, 0.198557, 0.568099
-0.228834, 0.200013, 0.585013
-0.228684, 0.20148, 0.601926
-0.228552, 0.202958, 0.618837
-0.228456, 0.204471, 0.635746
-0.228404, 0.20604, 0.65265
-0.228405, 0.207657, 0.669551
-0.228448, 0.209311, 0.686446
-0.228522, 0.211007, 0.703338
-0.228616, 0.212761, 0.720224
-0.228709, 0.214544, 0.737107
-0.228787, 0.21633, 0.75399
-0.228836, 0.218104, 0.770874
-0.228851, 0.219846, 0.78776
-0.228854, 0.221549, 0.804652
-0.228869, 0.223206, 0.821548
-0.228909, 0.224802, 0.83845
-0.22895, 0.226376, 0.855354
-0.228986, 0.227963, 0.872257
-0.229009, 0.229574, 0.889157
-0.229014, 0.231217, 0.906053
-0.228996, 0.232891, 0.922948
-0.228961, 0.234602, 0.939839
-0.228923, 0.236352, 0.956726
-0.228893, 0.238126, 0.973609
-0.228878, 0.239913, 0.990491
-0.228883, 0.241695, 1.00738
-0.228933, 0.243476, 1.02426
-0.229081, 0.245298, 1.04114
-0.229386, 0.247212, 1.058
-0.229772, 0.249187, 1.07486
-0.23022, 0.251223, 1.09171
-0.230766, 0.253349, 1.10854
-0.231348, 0.255594, 1.12536];
c1 = mean(v1);
c2 = mean(v2);
c = 0.5*(c1+c2);
figure('Name','input'); set(gcf,'color','white');hold on;
scatter3(v1(:,1),v1(:,2), v1(:,3),50,'g','filled');
scatter3(c1(:,1),c1(:,2), c1(:,3),100,'g','filled');
scatter3(v2(:,1),v2(:,2), v2(:,3),50,'b','filled');
scatter3(c2(:,1),c2(:,2), c2(:,3),100,'b','filled');
scatter3(c(:,1),c(:,2), c(:,3),100,'r','filled');
axis off; axis equal; mouse3d;

%% rotate verts2 around center Axis 
center = [0.00318914,0.223123,0.819125];
direction =[-0.0020372,0.10127,0.994856];
angle = 3.14159;

figure('Name','c++'); set(gcf,'color','white');hold on;
scatter3(v1(:,1),v1(:,2), v1(:,3),50,'g','filled');
scatter3(c1(:,1),c1(:,2), c1(:,3),100,'g','filled');
scatter3(v2(:,1),v2(:,2), v2(:,3),50,'b','filled');
scatter3(c2(:,1),c2(:,2), c2(:,3),100,'b','filled');
scatter3(center(:,1),center(:,2), center(:,3),100,'r','filled');
axis off; axis equal; mouse3d;

%%
line = [center direction];
rot = createRotation3dLineAngle(line, angle);
[axisR angle2] = rotation3dAxisAndAngle(rot);
angle2

newvertices = transformPoint3d(v2,rot);
distance_between(v1, newvertices)

scatter3(newvertices(:,1),newvertices(:,2), newvertices(:,3),50,'r','filled');