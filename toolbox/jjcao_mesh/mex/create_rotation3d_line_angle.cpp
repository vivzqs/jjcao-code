/*=================================================================
* Create rotation around a line by an angle theta
* 
* according to David Legland's matlab toolbox: geom3d 
* 
* Junjie Cao, 2013, jjcao1231@gmail.com
*
=================================================================*/

#include <mex.h>
#include <vector>

void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray*prhs[])
{  
	if ( nrhs != 2)
		mexErrMsgTxt("2 arguments needed!");

	double *line;
	line = mxGetPr(prhs[0]);
    int sizeOfLine = mxGetN(prhs[0]);
	if ( sizeOfLine != 3 || sizeOfLine != 6)
		mexErrMsgTxt("line must be 1*3 or 1*6 matrix!");
	
	std::vector<double> center(0, 3), direction;
	if ( sizeOfLine == 3)
	{
		for ( int i = 0; i < sizeOfLine; ++i)
			direction.push_back(line[i]);
	}
	else	
	{
		center.clear();
		for ( int i = 0; i < 3; ++i)
			center.push_back(line[i]);
		for ( int i = 3; i < sizeOfLine; ++i)
			direction.push_back(line[i]);		
	}

	double *theta = mxGetPr(prhs[1]);
}

