function  localmax = local_max_average(saliencyvalue,Msalency, A)

% A is adjacency matrix of faces
%

localmax = 0;

num =size(saliencyvalue,1);
countindex = 0;

for i=1:num
   neighbor = find(A(i,:)>0);
   count = 0;
   for j=1:size(neighbor,2)
       if saliencyvalue(i) > saliencyvalue(neighbor(j))
           count = count + 1;
       else
           break;
       end
   end

   if size(neighbor,2) == count && saliencyvalue(i) < Msalency
       localmax = localmax + saliencyvalue(i);
       countindex = countindex + 1;
   end
end

localmax = localmax/countindex;

