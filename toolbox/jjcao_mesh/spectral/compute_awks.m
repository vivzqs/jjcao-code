function [awks,landmark,cellArea,faceIndex,Q]=compute_awks(verts,faces,nbr_landmarks,DEBUG)

%% compute voronoi mesh
nverts = size(verts,1);
options.W = ones(nverts,1); % the speed function, for now constant speed to perform uniform remeshing
landmark = perform_farthest_point_sampling_mesh(verts,faces,[],nbr_landmarks,options);% perform the sampling of the surface
[Q,DQ, voronoi_edges] = compute_voronoi_mesh(verts,faces, landmark); %  i-th �������� Q(i)-th landmark

%% display voronoi patch
if DEBUG
    options.voronoi_edges = voronoi_edges;
    options.start_points = landmark;
    figure('name','voronoi');
    plot_fast_marching_mesh(verts,faces, Q(:,1), [], options); 
    view3d zoom;
end

%% ����ÿ��face������һ��cell
%i-th face���� faceIndex(i)-th cell;��faceIndex(i)Ϊ0���������κ�һ��cell
faceIndex=zeros(size(faces,1),1);

%% ����2-3����������b_i��face���� cell_i
for i=1:nbr_landmarks           % cell_i
    vertIndex=find(Q(:,1)==i);  %����cell_i �Ķ���ı�ţ�������
    % indexTemp:  nfaces*3 ��index1(s,t)=1,�򶥵�faces(s,t)�� cell_i�У�����Ϊ0
    indexTemp=zeros(size(faces));  
    for j=1:length(vertIndex)   
        indexTemp=indexTemp+(faces==vertIndex(j));
    end
    %index_3p�� 3�����㶼��cell_i�е�face���,������
    index_3p=find(indexTemp(:,1).*indexTemp(:,2).*indexTemp(:,3)); 
    indexTemp(index_3p,:)=0;
    %index_2p: 2�����㶼��cell_i�е�face���,������
    index_2p=find(indexTemp(:,1).*indexTemp(:,2)+indexTemp(:,1).*indexTemp(:,3)+indexTemp(:,2).*indexTemp(:,3));
    faceIndex(index_3p)=i;
    faceIndex(index_2p)=i;
end

%% 3���������ڲ�ͬ��landmark b��face,����face�����ĵ�3�������Ӧ�Ĳ�����������face�����ĸ�cell
index_1p=find(faceIndex==0);    %3���������ڲ�ͬ��landmark b��face���
for i=1:size(index_1p)          %��index_1p(i)��face
    triIndex=faces(index_1p(i),:); %face��3�������� 3*1
    triVerts=verts(triIndex,:);   %face��3���������� 3*3
    faceCenter=sum(triVerts)/3;   %face����������
    distTriVerts=zeros(3,1);              %face��3�����㵽���ĵľ��� 3*1
    for j=1:3
    distTriVerts(j)=sum((triVerts(j,:)-faceCenter).^2);
    end
    dist=distTriVerts+DQ(triIndex,1);
    idx=find(dist==min(dist));    %face�����ĸ�����
    faceIndex(index_1p(i))=Q(triIndex(idx)); %face�����ĸ�cell
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
cellArea=zeros(nbr_landmarks,1);  %cell_i�����Ϊ cellArea(i)
for i=1:nbr_landmarks           % cell_i
    index2=find(faceIndex==i);  %cell_i ����ı�ţ�������
    cellFaces=faces(index2,:);  %cell_i ����
    A = cross(verts(cellFaces(:,2),:)- verts(cellFaces(:,1),:), verts(cellFaces(:,3),:)- verts(cellFaces(:,1),:)); %���
    cellArea(i) = sum(0.5 * sqrt(A(:,1).^2+A(:,2).^2+A(:,3).^2));  %���
end

%% compute awks(v)=sum��d(v,b_i)*area(b_i)��
D= compute_featureDist_wks(verts, faces, landmark);  %nverts*nbr_landmarks
awks=D*cellArea;  %awks(v)=��i��ͣ�d(v,b_i)*area(b_i)��
