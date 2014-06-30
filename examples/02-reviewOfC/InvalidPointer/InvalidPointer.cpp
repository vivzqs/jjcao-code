#include <iostream>

void GetMemory(char *p, int num)
{
 p = (char*)malloc(sizeof(char) * num);
}

int main()
{
    char *str = NULL;
	delete str;

    GetMemory(str, 100);
    strcpy(str, "hello");
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
