function [awks,landmark,cellArea,faceIndex,Q]=compute_awks(verts,faces,nbr_landmarks,DEBUG)

%% compute voronoi mesh
nverts = size(verts,1);
options.W = ones(nverts,1); % the speed function, for now constant speed to perform uniform remeshing
landmark = perform_farthest_point_sampling_mesh(verts,faces,[],nbr_landmarks,options);% perform the sampling of the surface
[Q,DQ, voronoi_edges] = compute_voronoi_mesh(verts,faces, landmark); %  i-th 顶点属于 Q(i)-th landmark

%% display voronoi patch
if DEBUG
    options.voronoi_edges = voronoi_edges;
    options.start_points = landmark;
    figure('name','voronoi');
    plot_fast_marching_mesh(verts,faces, Q(:,1), [], options); 
    view3d zoom;
end

%% 计算每个face属于哪一个cell
%i-th face属于 faceIndex(i)-th cell;若faceIndex(i)为0，则不属于任何一个cell
faceIndex=zeros(size(faces,1),1);

%% 将有2-3个顶点属于b_i的face归入 cell_i
for i=1:nbr_landmarks           % cell_i
    vertIndex=find(Q(:,1)==i);  %属于cell_i 的顶点的编号，列向量
    % indexTemp:  nfaces*3 ，index1(s,t)=1,则顶点faces(s,t)在 cell_i中，否则为0
    indexTemp=zeros(size(faces));  
    for j=1:length(vertIndex)   
        indexTemp=indexTemp+(faces==vertIndex(j));
    end
    %index_3p： 3个顶点都在cell_i中的face编号,列向量
    index_3p=find(indexTemp(:,1).*indexTemp(:,2).*indexTemp(:,3)); 
    indexTemp(index_3p,:)=0;
    %index_2p: 2个顶点都在cell_i中的face编号,列向量
    index_2p=find(indexTemp(:,1).*indexTemp(:,2)+indexTemp(:,1).*indexTemp(:,3)+indexTemp(:,2).*indexTemp(:,3));
    faceIndex(index_3p)=i;
    faceIndex(index_2p)=i;
end

%% 3个顶点属于不同的landmark b的face,根据face的重心到3个顶点对应的采样点距离决定face属于哪个cell
index_1p=find(faceIndex==0);    %3个顶点属于不同的landmark b的face编号
for i=1:size(index_1p)          %第index_1p(i)个face
    triIndex=faces(index_1p(i),:); %face的3个顶点编号 3*1
    triVerts=verts(triIndex,:);   %face的3个顶点坐标 3*3
    faceCenter=sum(triVerts)/3;   %face的重心坐标
    distTriVerts=zeros(3,1);              %face的3个顶点到重心的距离 3*1
    for j=1:3
    distTriVerts(j)=sum((triVerts(j,:)-faceCenter).^2);
    end
    dist=distTriVerts+DQ(triIndex,1);
    idx=find(dist==min(dist));    %face属于哪个顶点
    faceIndex(index_1p(i))=Q(triIndex(idx)); %face属于哪个cell
end   

%% display cell
if DEBUG
    figure('Name','cell'); set(gcf,'color','white'); 
    options.face_vertex_color =faceIndex;
    h = plot_mesh(verts, faces, options);
%     set(h, 'edgecolor', 'none');
    colormap(jet(nbr_landmarks)); 
    view3d rot; lighting none;
    hold on;
%  display landmarks
    ms=25;
   for i=1:nbr_landmarks
       cellCenter= verts(landmark(i),:);
       h = plot3( cellCenter(1),cellCenter(2), cellCenter(3), 'r.');
       set(h, 'MarkerSize', ms);    
   end
end

%% compute area(b_i)
cellArea=zeros(nbr_landmarks,1);  %cell_i的面积为 cellArea(i)
for i=1:nbr_landmarks           % cell_i
    index2=find(faceIndex==i);  %cell_i 中面的编号，列向量
    cellFaces=faces(index2,:);  %cell_i 中面
    A = cross(verts(cellFaces(:,2),:)- verts(cellFaces(:,1),:), verts(cellFaces(:,3),:)- verts(cellFaces(:,1),:)); %外积
    cellArea(i) = sum(0.5 * sqrt(A(:,1).^2+A(:,2).^2+A(:,3).^2));  %面积
end

%% compute awks(v)=sum｛d(v,b_i)*area(b_i)｝
D= compute_featureDist_wks(verts, faces, landmark);  %nverts*nbr_landmarks
awks=D*cellArea;  %awks(v)=对i求和｛d(v,b_i)*area(b_i)｝
