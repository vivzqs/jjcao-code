function [minimaIndex,maximaIndex] = extremumIndex(F,fun,percent)
%Find the extremum index of the scalar function on the mesh
%Hui Wang, Mar. 28, 2010, wanghui19841109@163.com

%%Input
%F---The facet of the mesh
%fun---The scalar function on the mesh
%percent---The parameter for the extremum


if nargin < 2
  error('Enough input!');
elseif nargin == 2
  [minimaSign,maximaSign] = minimaAndMaxima(F,fun,1);
else
  [minimaSign,maximaSign] = minimaAndMaxima(F,fun,percent);
end    
 
minimaIndex = find(minimaSign == 1);
maximaIndex = find(maximaSign == 1);

    