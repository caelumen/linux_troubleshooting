#include <stdio.h> 
#include <memory.h>

void Abnormal()
{
    int n = 1024;
    char *p = (char *)malloc(sizeof(char) * 1);

    free(p);
    free(p);                /* double free */
    printf(p);
    void (*fp)();
    fp = p;
    fp();
}

void AbnormalContainer()
{
    Abnormal();
}

void Normal()
{
    printf("normal function.\n");
}

int main(int argc, char **argv)
{
    AbnormalContainer();
    Normal();
    return 0;
}
