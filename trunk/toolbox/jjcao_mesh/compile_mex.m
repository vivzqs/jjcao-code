mex mex/adjacency_matrix.cpp
mex -largeArrayDims -I"../../include/eigen-3.1.3" mex/perform_mesh_weight.cpp

%% geodesic
% there are three implementations as follows:
% geodesic 1: the speed is much faster than perform_front_propagation_mesh (geodesic 3), since it is shortest path distance rather than continuous
% geodesic distance
mex geodesic/mex/perform_dijkstra_propagation.cpp geodesic/mex/fheap/fib.cpp 
movefile('perform_dijkstra_propagation.mexw32', 'geodesic/');

% geodesic 2: 
mex geodesic/mex/dijkstra.cpp 
% eval(['!rename', dijkstra.mexw32 name2]);
if exist('dijkstra.mexw32', 'file'); movefile('dijkstra.mexw32', 'geodesic/perform_dijkstra_fast.mexw32'); end
if exist('dijkstra.mexw64', 'file'); movefile('dijkstra.mexw64', 'geodesic/perform_dijkstra_fast.mexw64'); end
if exist('dijkstra.mexglx', 'file'); movefile('dijkstra.mexglx', 'geodesic/perform_dijkstra_fast.mexglx'); end
if exist('dijkstra.mexmaci', 'file'); movefile('dijkstra.mexmaci', 'geodesic/perform_dijkstra_fast.mexmaci'); end

%% geodesic 3:
mex geodesic/mex/perform_front_propagation_2d.cpp geodesic/mex/perform_front_propagation_2d_mex.cpp geodesic/mex/fheap/fib.cpp 
mex geodesic/mex/perform_front_propagation_3d.cpp geodesic/mex/perform_front_propagation_3d_mex.cpp geodesic/mex/fheap/fib.cpp 
movefile('perform_front_propagation_2d.mexw32', 'geodesic/');
movefile('perform_front_propagation_3d.mexw32', 'geodesic/');
%%
basep = 'geodesic/mex/';
disp('Compiling perform_front_propagation_mesh, might time some time.');
files =  { ...
    'perform_front_propagation_mesh.cpp', ...
    'gw/gw_core/GW_Config.cpp',           ...
    'gw/gw_core/GW_FaceIterator.cpp',     ...
    'gw/gw_core/GW_SmartCounter.cpp',     ...
    'gw/gw_core/GW_VertexIterator.cpp',   ...
    'gw/gw_core/GW_Face.cpp',             ...
    'gw/gw_core/GW_Mesh.cpp',             ...
    'gw/gw_core/GW_Vertex.cpp',           ...
    'gw/gw_geodesic/GW_GeodesicFace.cpp', ...                                              
    'gw/gw_geodesic/GW_GeodesicMesh.cpp',     ...                                 
    'gw/gw_geodesic/GW_GeodesicPath.cpp',         ...                       
    'gw/gw_geodesic/GW_GeodesicPoint.cpp',            ...           
    'gw/gw_geodesic/GW_TriangularInterpolation_Cubic.cpp', ...      
    'gw/gw_geodesic/GW_GeodesicVertex.cpp',                    ...  
    'gw/gw_geodesic/GW_TriangularInterpolation_Linear.cpp',      ...
    'gw/gw_geodesic/GW_TriangularInterpolation_Quadratic.cpp',  ...
};
str = 'mex '; % -v
for i=1:length(files)
    str = [str basep files{i} ' '];
end
eval(str);
movefile('perform_front_propagation_mesh.mexw32', 'geodesic/');

%% geodesic 4: a newer version than geodesic 3 from the same author's svn. 
% But I've not time to test it.
basep = 'geodesic/mex/';
disp('Compiling EikonalSolverMesh, might time some time.');
files =  { ...
    'AnisoEikonalSolverMesh.cpp', ...
    'gw/gw_core/GW_Config.cpp',           ...
    'gw/gw_core/GW_FaceIterator.cpp',     ...
    'gw/gw_core/GW_SmartCounter.cpp',     ...
    'gw/gw_core/GW_VertexIterator.cpp',   ...
    'gw/gw_core/GW_Face.cpp',             ...
    'gw/gw_core/GW_Mesh.cpp',             ...
    'gw/gw_core/GW_Vertex.cpp',           ...
    'gw/gw_geodesic/GW_GeodesicFace.cpp', ...                                              
    'gw/gw_geodesic/GW_GeodesicMesh.cpp',     ...                                 
    'gw/gw_geodesic/GW_GeodesicPath.cpp',         ...                       
    'gw/gw_geodesic/GW_GeodesicPoint.cpp',            ...           
    'gw/gw_geodesic/GW_TriangularInterpolation_Cubic.cpp', ...      
    'gw/gw_geodesic/GW_GeodesicVertex.cpp',                    ...  
    'gw/gw_geodesic/GW_TriangularInterpolation_Linear.cpp',      ...
    'gw/gw_geodesic/GW_TriangularInterpolation_Quadratic.cpp',  ...
};
str = 'mex '; % -v
for i=1:length(files)
    str = [str basep files{i} ' '];
end
eval(str);
movefile('AnisoEikonalSolverMesh.mexw32', 'geodesic/');

% Connectivity matlab
basep = 'geodesic/mex/';
disp('Compiling ComputeMeshConnectivity, might time some time.');
files =  { ...
    'ComputeMeshConnectivity.cpp', ...
    'gw/gw_core/GW_Config.cpp',           ...
    'gw/gw_core/GW_FaceIterator.cpp',     ...
    'gw/gw_core/GW_SmartCounter.cpp',     ...
    'gw/gw_core/GW_VertexIterator.cpp',   ...
    'gw/gw_core/GW_Face.cpp',             ...
    'gw/gw_core/GW_Mesh.cpp',             ...
    'gw/gw_core/GW_Vertex.cpp',           ...
    'gw/gw_geodesic/GW_GeodesicFace.cpp', ...                                              
    'gw/gw_geodesic/GW_GeodesicMesh.cpp',     ...                                 
    'gw/gw_geodesic/GW_GeodesicPath.cpp',         ...                       
    'gw/gw_geodesic/GW_GeodesicPoint.cpp',            ...           
    'gw/gw_geodesic/GW_TriangularInterpolation_Cubic.cpp', ...      
    'gw/gw_geodesic/GW_GeodesicVertex.cpp',                    ...  
    'gw/gw_geodesic/GW_TriangularInterpolation_Linear.cpp',      ...
    'gw/gw_geodesic/GW_TriangularInterpolation_Quadratic.cpp',  ...
};
str = 'mex -v ';
for i=1:length(files)
    str = [str basep files{i} ' '];
end
eval(str)
movefile('ComputeMeshConnectivity.mexw32', 'geodesic/');

% Code on mesh grid with matlab connectivity
basep = 'geodesic/mex/';
disp('Compiling AnisoEikonalSolverMatlabMesh, might take no time :-P.');
files =  { ...
    'AnisoEikonalSolverMatlabMesh.cpp'

};
str = 'mex '; % -v
for i=1:length(files)
    str = [str basep files{i} ' '];
end
eval(str);
movefile('AnisoEikonalSolverMatlabMesh.mexw32', 'geodesic/');