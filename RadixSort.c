/**
 * @file trie_par_base_mike.c
 * @author Mike Duran & Damien Ledda
 * @brief Tri par base Mike version 
 * @version 0.1
 * 
 * @copyright ... copyleft?
 * 
 */
#include <stdlib.h>
#include <stdio.h>
#define MALLOC(type) malloc(sizeof(type))
#define MALLOCN(n,type) malloc(n*sizeof(type))

/*USAGE
    S'active en cas de mauvaise utilisation du programme.
    Quitte celui-ci avec un code non nul d'erreur.
    Paramètre: prog: nom du programme
*/
void usage(const char* prog){
    fprintf(stderr, "Usage: %s suite de nombres\n", prog);
    exit(1);
}

/*IÈME PUISSANCE DE 10
    Récupère 10^i.
    Paramètres: number: sujet de test
                index: indice à récupérer
                base: base à utiliser (2, 8, 10, 16, ...)
    Retour: théoriquement, rien (void)
            en pratique, T: tableau trié
    Préconditions: T non vide de préférence
                   inf!=sup
*/
int ieme_chiffre(int number,int index, int base)
{   int number_length=0;
    int test_n=number;
    while(test_n !=0)
    {
        number_length++;
        test_n/=base;
    }

    int chiffre[number_length];
    
    for(int i=number_length;i>=0;i--)
    {
        chiffre[i]= number % base;
        number/=base;
    }
    return chiffre[index];
}

/*MAXIMUM
    Recherche le maximum.
    Paramètres: T: tableau d'entiers
                n: taille du tableau
    Retour: max: le maximum du tableau
    Préconditions: T non vide de préférence
*/
int plus_grand(int* T,int n)
{
    int max=0;
    for(int i=0;i<n;i++)
    {
        if(max<=T[i]) 
            max=T[i];
    }
    return max;
}

/*TRI PAR BASE
    Trie un tableau par comparaison des bases.
    Paramètres: T: tableau d'entiers non trié
                taille: taille du tableau
    Retour: théoriquement, rien (void)
            en pratique, T: tableau trié
    Préconditions: T non vide de préférence
*/
void trie_par_base(int* T/*,int b*/,int taille)
{
    int n=taille; 
    int Tres[n];
    int plus=plus_grand(T,n); // avec ca on saura q quelle quantité de chiffre on es.
    int puiss=1;
//on travaille en base 10 on le remplace par b
//on augmente a chaque fois la puissance affin d'avoir chiffre par chiffre
    while( ( plus/puiss ) >0)
    {
        int Taux[10]={ 0 };
        
        for(int j = 0; j < n; j++)
        {
            Taux[ ( T[j] / puiss ) % 10]+=1;
        }
       
        for(int j = 1;j <= 10-1; j++)
        {
            Taux[j]+=Taux[j-1];
        }

        for(int j =n-1;j>=0;j--)
        {
            Tres[ -- Taux[ ( T[j] / puiss) % 10 ] ]=T[j]; //erreur de seg
        }
        
        for(int j=0;j<n;j++)
        {
            T[j]=Tres[j];
        }
        puiss*=10;
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

    trie_par_base(aTrier, nb);
    printf("\nTableau trié:\n");
    for(int i=0; i<nb; i++){
        printf("%d\t", aTrier[i]);
    }
    printf("\n");

    exit(0);
}