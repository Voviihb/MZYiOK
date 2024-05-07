#include <iostream>
// прототип подпрограммы на ассемблере:
extern void sum(int x,int y,int *p);

int main()
{
int d,b,c;
std::cin >> d >> b;
sum(d,b,&c);
std::cout << c << std::endl;
return 0;
}
