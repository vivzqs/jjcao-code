#include <iostream>
#include <stdio.h>

void GetMemory(char *p, int num)
{
 p = (char*)malloc(sizeof(char) * num);
}
void testIncalidPointer()
{
	char *str = NULL;

    GetMemory(str, 100);
    strcpy_s(str, 5, "hello");
}
void print(int *a, int len)
{	
	for (int i = 0; i < len; ++i)
	{
		std::cout << a[i] << " ";
	}
	std::cout << std::endl;
}
void testConnect2array()
{
	int *a, *b;
	a = new int[2];
	b = new int[2];
	a[0] =  0; a[1] = 1;
	b[0] = 2; b[1] = 3;
	std::cout << "a: "; print(a,2);
	std::cout << "b: "; print(b,2);

	//////////
	std::cout << "address of a, before appending: " << a << std::endl;
	void* ret = realloc(a, 4*sizeof(int));
	
	if (ret!=NULL)
	{    
		a = (int*) ret;
		ret = memmove(a+2, b, 2*sizeof(int));//memmove, memcpy	
	}
	std::cout << "address of a, after appending: " << a << std::endl;
	print(a,4);
}

int main()
{
	testConnect2array();

	//testIncalidPointer();

	int i;
	std::cin >> i;
    return 0;
}


//#include <iostream>
//#include <algorithm>
//
//using namespace std;
//int *myFunc(){
//	int phantom = 4;
//	cout << "address of phantom: " << &phantom << endl;
//	return &phantom;
//}
//
//int main()
//{
//	int *ptr(0);
//	//cout << "uninitialized pointer ptr: " << ptr << endl;
//	ptr = myFunc();
//	cout << "after assigning an invalid address to ptr: " << ptr << endl;
//	cout << "is the address saved the phantom 4? " << *ptr << endl;
//
//	//ptr = new int(5);
//	delete ptr;
//	//delete ptr; // do not delete a pointer more than once! runtime error!
//	cout << "is the address saved the phantom 4? " << *ptr << endl;
//	return 0;
//}
//
////typedef char* Char;
////void setString(Char& strPtr){
////strPtr="negatrive";
////}
////void setString(Char* strPtr){
////*strPtr="negatrive";
////}
////int main(){
////Char str;
////setString(&str);
////cout << str << endl;
////return 0;
////}
