/**
 * @file QuickSort.c
 * @author Mike Duran & Damien Ledda
 * @brief Tri rapide
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

/*PERMUTATION DE DEUX CELLULES
    Permute deux cellules d'un tableau.
    Paramètres: T: tableau d'entiers
                a, b: indices à permuter
    Retour: théoriquement, rien (void)
            en pratique, T: tableau aux cellules permutées
    Préconditions: T non vide de préférence
                   a!=b
*/
void permuter(int* T, int a, int b)
{
    int c=T[a];
    T[a]=T[b];
    T[b]=c;
}

/*SEGMENTATION D'UN TABLEAU
    Segmente un tableau afin de le trier.
    Paramètres: T: tableau d'entiers non trié
                inf: borne inférieure de ce tableau non trié
                sup: borne supérieure de ce tableau non trié
                pivot: pivot de segmentation
    Retour: indice
    Préconditions: T non vide de préférence
                   inf!=sup
*/
int Segmentation(int* T,int inf,int sup,int pivot)
{
    int i=inf+1;
    int j=sup;
    while(i<j)
    {
        while((i<=sup) && (T[i]<T[pivot])) i++;
        while((j>i) && (T[j]>T[pivot])) j--;
        if(i<j) permuter(T,i,j);
    }
    permuter(T,pivot,i-1);
    return i-1;
}

/*TRI RAPIDE
    Trie un tableau par segmentation.
    Paramètres: T: tableau d'entiers non trié
                inf: borne inférieure de ce tableau non trié
                sup: borne supérieure de ce tableau non trié
    Retour: théoriquement, rien (void)
            en pratique, T: tableau trié
    Préconditions: T non vide de préférence
                   inf!=sup
*/
void QuickSort(int* T,int inf,int sup)
{
    if(sup<=inf) return;
    int pivot=inf;
        pivot=Segmentation(T,inf,sup,pivot);
    QuickSort(T,inf,pivot-1);
    QuickSort(T,pivot+1,sup);
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

    QuickSort(aTrier, 0, nb-1);
    printf("\nTableau trié:\n");
    for(int i=0; i<nb; i++){
        printf("%d\t", aTrier[i]);
    }
    printf("\n");

    exit(0);
}

