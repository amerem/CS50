#include <cs50.h>
#include <stdio.h>

int main(int argc, char* argv[])
{
    int n = 0;
    do
    {
        printf("Please enter number between 0 and 23: ");
        n = GetInt();
        
    }
    while(n < 0 || n > 23);
    
    
    if (n == 1)
    {
        printf("##\n");
    }
    else if ( n > 1)
    {
        int i;
        for (i = 0; i < n; i++)
        {
            int s;
            for(s = i; n > (s + 1); s++)
            {
                printf(" ");
            }
            
            int h;
            for(h = i; h + 2 > 0; h--)
            {
                printf("#");
            }
            printf("\n");
        }
    }
    return 0; 
}




