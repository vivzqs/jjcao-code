function parts = read_parts_obj(filename)

% read_parts_obj - load a .obj file composed of multi parts.
%
%   parts = read_parts_obj(filename);
%
%   parts[i] is a part, composed of:
%            verts  : 
%            faces  : 
%            name   :
%
%   Copyright (c) 2013 Junjie Cao

fid = fopen(filename);
if fid<0
    error(['Cannot open ' filename '.']);
end
%frewind(fid);

%%
parts = [];
nparts = 0;
while 1
    s = fgetl(fid);
    if ~ischar(s), 
        break;
    end
    if isempty(s) 
        continue;
    end
    k = strfind(s, '# Starting mesh');
    if ~isempty(k) % begin a part
        nparts = nparts + 1;
        parts(nparts).name = s(length('# Starting mesh')+2:end);
        verts = [];
        faces = [];
        while ischar(s)
            s = fgetl(fid);
            if isempty(s)
                continue;
            end
            if strcmp(s(1:2), 'v ') % vertex
                verts(end+1,:) = sscanf(s(3:end), '%f %f %f');
            elseif strcmp(s(1:2), 'f ') % face
                faces(end+1,:) = sscanf(s(3:end), '%d %d %d');
            end
        end        
    end
   
end
fclose(fid);

