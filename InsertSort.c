/**
 * @file InsertSort.c
 * @author Mike Duran & Damien Ledda
 * @brief Tri par insertion
 * @version 0.1
 * 
 * @copyright ... copyleft?
 * 
 */
#include <stdlib.h>
#include <stdio.h>
#define MALLOC(type) malloc(sizeof(type))

/*USAGE
    S'active en cas de mauvaise utilisation du programme.
    Quitte celui-ci avec un code non nul d'erreur.
    Paramètre: prog: nom du programme
*/
void usage(const char* prog){
    fprintf(stderr, "Usage: %s suite de nombres\n", prog);
    exit(1);
}

/*TRI PAR INSERTION
    Trie un tableau par insertion successive d'éléments.
    Paramètres: T: tableau d'entiers non trié
                n: taille de ce tableau non trié
    Retour: théoriquement, rien (void)
            en pratique, T: tableau trié
    Préconditions: T non vide de préférence
                   n strictement positif de préférence
*/
void InsertSort(int* T,int n)
{   int i;
    for(i=1;i<n;i++)
    {
        int a_inserer=T[i];
        int j=i-1;
        while( (j>=0) && (T[j]>a_inserer))
        {
            //decaler vers la droite
            T[j+1]=T[j];
            j--;
        }
        T[j+1]=a_inserer;
    }
}

int main(int argc, char* argv[])
{
    if(argc!=2) usage(argv[0]);
    int nb=atoi(argv[1]);
    int aTrier[nb];
    for(int taille=0; taille<nb; taille++)
        aTrier[taille]=rand();
    
    printf("Tableau non trié:\n");
    for(int i=0; i<nb; i++){
        printf("%d\t", aTrier[i]);
    }

    InsertSort(aTrier, nb);

    printf("\nTableau trié:\n");
    for(int i=0; i<nb; i++){
        printf("%d\t", aTrier[i]);
    }
    printf("\n");
    return 0;
}

