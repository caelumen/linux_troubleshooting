#include<stdio.h>
#include<stdlib.h>
int main()
{
   char *p = malloc(sizeof(char)*100);
   p = "Hello world"; 
   *(p+1) = 'l'; 
   printf("%s", p);
   free(p); 
   return 0;
}
