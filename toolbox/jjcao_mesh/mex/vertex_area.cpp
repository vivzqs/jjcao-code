/*=================================================================
*
* compute "voronoi" area of each vertex
* reference: Discrete Differential-Geometry Operators_for triangulated 2-manifolds_02
* usage: 
		va = vertex_area(verts, faces);
* inputs:
		verts: 3*nverts
		faces: 3*faces
*
* output:
*		va: nverts*1
*          
*
* JJCAO, 2013
*
*=================================================================*/

#include <mex.h>
#include <string>
#include <sstream>
#include <vector>
#include <algorithm> 
#include <iostream>

using namespace std;

void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray*prhs[])
{
	///////////// Error Check
	if ( nrhs != 2) 
		mexErrMsgTxt("Number of input should be 2!");

	///////////// input & output arguments	
	// input 0: verts: 3*nverts
	int row = mxGetM(prhs[0]);
	int nverts = mxGetN(prhs[0]);
	if(row != 3)
		mexErrMsgTxt("The mesh must be triangle mesh! it is excepted to be 3*n");

	double *verts = mxGetPr(prhs[0]);

	// input 1: faces: 3*nfaces
	row = mxGetM(prhs[1]);
	int nfaces = mxGetN(prhs[1]);
	if(row != 3)
		mexErrMsgTxt("The mesh must be triangle mesh! it is excepted to be 3*n");

	double* faces = mxGetPr(prhs[1]);	
	

	///////////////////////////////////////////////
	// output 0
	plhs[0] = mxCreateDoubleMatrix( nverts, mxREAL);   
	double *va = mxGetPr(plhs[0]);

	///////////////////////////////////////////////	
	// process
	for(int i = 0; i < nfaces*3; ++i)
		--faces[i];
}