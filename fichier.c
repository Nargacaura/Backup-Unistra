#include <sys/wait.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#define MALLOC(t) ((t*)malloc(sizeof(t)))   //  C EST UN MACRO !!!!!!! -----> Ca aide a simplifier l'ecriture du malloc dans notre code 
#define FREE(t) free(t) // un macro pour le free 
#include <limits.h>
#include <time.h>
#define GetCurrentDir getcwd
void fichier_ajout_valeur(const char* nom_fichier, double valeur)
{
char* file=MALLOC(char);
snprintf(file, 4096, "%s.ods", nom_fichier);
FILE* fichier=fopen(file,"a");
fprintf(fichier,"%lf\n",valeur);
fclose(fichier);
FREE(file);
}
int main(int argc, char ** argv)
{
  if(argc!=2){
      exit(EXIT_FAILURE);
  }
unsigned int n;
time_t t;
char* Sort=malloc(100);
for(int i=2; argv[1][i]!='\0'; i++){
    Sort[i-2]=argv[1][i];
}
int* T;
char BUFFER[4096];
char* prog=realpath(Sort, BUFFER+1);
        

srand((unsigned) time(&t)); // Initializes random number generator
           
for(n=10;n<81920;n*=2)
   {
       T=malloc(n*sizeof(int));
       printf(" RANDOM TABLE %d \n", n);
       double time=0.0; 
      for(int j=0;j<10;j++)
       {
        for (unsigned i=0;i<n;i++) T[i] = rand() % INT_MAX;    
        clock_t start_t, end_t; 
        start_t= clock();
        char taille[10];
        sprintf(taille, "%d", n);
        pid_t pid;
        int waiter;
        switch(pid=fork())
        {
            case -1: exit(EXIT_FAILURE); 
            case 0 :  execl(prog, prog, taille, NULL);
                    break;
            default: wait(&waiter);
        }
        end_t=clock();
        double total_t = ((double)(end_t - start_t)) / (double)CLOCKS_PER_SEC;
        time+=total_t;
       }
       
       time/=10.0;

    printf("\nTotal time taken by CPU: %lf ", time  );
    fichier_ajout_valeur(argv[1],time);
   }

  printf("\nExiting program...\n");

return 0;
}