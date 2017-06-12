#include <stdio.h>
#include <stdlib.h>

unsigned int setbits(unsigned int u, int b, int l, int n)
{
  unsigned int c = (1<<l)-1;
  unsigned int m = n & c;
  
  m = m<<b;
  c = c<<b;

  u = u & (~c);
  u = u | m;

  return u;

}

int main()
{

  for(int i=0; i<2048; ++i){
    unsigned int u = setbits(0,18,8,i);
    printf("0x%09X\n",u);
  }

}
