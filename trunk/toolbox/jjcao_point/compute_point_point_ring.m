function ring = compute_point_point_ring(points, k, index)
% ���ص�ring�����е��һ����ĸ������������
% �������ǰ�˳��洢��
% too slow, how to speedup?
% create-date: 2009-4-23
% update-date: 2009-8-27
% create-date: 2009-9-7
% by: deepfish @ DUT, JJCAO

%%
npts = size(points,1);
ring = cell(npts,1);

if nargin < 3
    atria = nn_prepare(points); % OpenTSTool,������k����
    index = nn_search(points, atria, points, k);    
end

% kdtree = kdtree_build(points);
% index = zeros(npts, k);
% for i = 1:npts
%     index(i,:)  = flipud( kdtree_k_nearest_neighbors(kdtree,points(i,:),k))';
% end
% parfor i = 1:npts  
parfor i = 1:npts  
    neighbor = points(index(i,:),:); % k����    
    coefs = princomp(neighbor);    
    x = neighbor * coefs(:, 1);
    y = neighbor * coefs(:, 2);
    TRI = delaunay(x,y);
    
    % �������ǰ�������Ϊ1�Ķ����һ������
    [row,col] = find(TRI == 1);
    temp = TRI(row,:);
    temp = sort(temp,2);
    temp = temp(:,2:end);
    
    % ��һ���ĵ�һ�����㣺����г���һ�εĶ��㣬��Ϊ��㣬������ȡһ��
    x=temp(:);
    x=sort(x);
    d=diff([x;max(x)+1]);
    count = diff(find([1;d])); % ÿ�����ֳ��ֵĴ���
    y =[x(find(d)) count];
    n_sorted_index = size(y,1);
    start = find(count==1);
    if ~isempty(start) % �����ֻ����һ�εĶ���
        want_to_find = y(start(1),1);
    else
        want_to_find = temp(1,1);
        n_sorted_index = n_sorted_index+1; % ��λ�Ƿ�յĻ�
    end
    
    j = 0;    
    sorted_index = zeros(1,n_sorted_index);
    while j < n_sorted_index
        j = j+1;
        sorted_index(j) = want_to_find;
        [row,col] = find(temp == want_to_find);
        if ~isempty(col)
            if col(1) == 1
                want_to_find = temp(row(1),2);
                temp(row(1),2) = -1;
            else
                want_to_find = temp(row(1),1);
                temp(row(1),1) = -1;
            end    
        end
    end
    
    neighbor_index = index(i,sorted_index);
    
    % ��λΪ�˵㣬����������Ƿ�յģ�����λ������ͬ������ͬ
    ring{i} = neighbor_index;
end
% kdtree_delete(kdtree);
