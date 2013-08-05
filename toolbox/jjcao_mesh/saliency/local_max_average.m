function  localmax = local_max_average(saliency,Msalency, A)

% A is adjacency matrix of faces
%
localmax = 0;
countindex = 0;

for i=1:length(saliency)
   neighbor = find(A(i,:)>0);
   count = 0;
   for j=1:size(neighbor,2)
       if saliency(i) > saliency(neighbor(j))
           count = count + 1;
       else
           break;
       end
   end

   if size(neighbor,2) == count && saliency(i) < Msalency
       localmax = localmax + saliency(i);
       countindex = countindex + 1;
   end
end

localmax = localmax/countindex;

