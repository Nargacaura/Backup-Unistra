/**
 * @file MergeSort.c
 * @author Mike Duran & Damien Ledda
 * @brief Tri fusion
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

/*FUSION DE TABLEAUX
    Fusionne des tableaux après découpage de T.
    Paramètres: T: tableau d'entiers
                inf: borne inférieure de ce tableau
                sup: borne supérieure de ce tableau
    Retour: théoriquement, rien (void)
            en pratique, T: tableau trié
    Préconditions: T non vide de préférence
                   inf!=sup
*/
void Fusion(int* T, int inf, int sup)
{
    int* T_aux=MALLOC(int);
    int i=inf, j=((inf+sup)/2)+1;
    int courant=0;
    
    while((i <= ((inf+sup)/2) ) && (j<=sup))
    {
        if(T[i] <= T[j])
        {
            T_aux[courant]=T[i];
            i++;
        }
        else
        {
            T_aux[courant]=T[j];
            j++;
        }
        courant++;
    }
//on a fait tout le tableau gauche
    if(i==(inf+sup)/2+1){
        for(int k=courant; k<=sup-inf && j<=sup; k++, j++){
            T_aux[k]=T[j];
        }
    } else {
        for(int k=courant; k<=sup-inf && i<=(inf+sup)/2; k++, i++){
            T_aux[k]=T[i];
        }
    }
    for(int final=inf; final<=sup; final++){
        T[final]=T_aux[final-inf];
    }
}

/*TRI FUSION
    Trie un tableau par fusion de sous-tableaux.
    Paramètres: T: tableau d'entiers non trié
                inf: borne inférieure de ce tableau non trié
                sup: borne supérieure de ce tableau non trié
    Retour: théoriquement, rien (void)
            en pratique, T: tableau trié
    Préconditions: T non vide de préférence
                   inf!=sup
*/
void MergeSort(int* T,int inf,int sup)
{   
    if(sup <= inf) return;
    MergeSort(T, inf, (sup+inf)/2);
    MergeSort(T, (sup+inf)/2 +1, sup);
    Fusion(T,inf,sup);
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

    MergeSort(aTrier, 0, nb-1);

    printf("\nTableau trié:\n");
    for(int i=0; i<nb; i++){
        printf("%d\t", aTrier[i]);
    }
    printf("\n");
    return 0;
}

