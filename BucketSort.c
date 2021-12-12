/**
 * @file BucketSort.c
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

/***********************************LISTES********************************/
//Création des éléments
typedef struct Element Element;
struct Element
{
    double valeur;
    struct Element *suivant;
};
//Pointeur sur un élément=liste
typedef Element* llist;

/*EFFACEMENT D'UNE LISTE
    Efface une liste donnée.
    Paramètres: liste: liste inutilisée plus tard dans le code
    Retour: rien (void)
    Précondition: liste non libérée et inutilisée
*/
void effacerListe(llist liste)
{
    if(liste != NULL)
    {
        effacerListe(liste->suivant);
        free(liste);
    }
}

/************************************afficherListe*****************************/
/*AFFICHAGE D'UNE LISTE
    Affiche une liste donnée.
    Paramètres: liste: liste à afficher
    Retour: rien (void)
    Précondition: liste allouée et non vide
*/
void afficherListe(llist liste)
{
    llist courant = liste;
    while(courant != NULL)
    {
        printf("%f ", courant->valeur);
        courant = courant->suivant;
    }
    //N'oublions pas de libérer de la mémoire ;)
    effacerListe(courant);
}

/************************************Ajout d'un élément*******************************/
/*AJOUT D'UN ÉLÉMENT DANS UNE LISTE
    Ajoute un élément dans une liste donnée.
    Paramètres: liste: liste où l'élément sera ajouté
                valeur: valeur à affecter dans cet élément
    Retour: liste avec le nouvel élément
*/
//en tête
llist ajouterEnTete(llist liste, double valeur)
{
    //Le problème des fuites proviennent d'ici, faudra qu'on voie comment fixer
    Element* nouvelElement=malloc(sizeof(Element));
    nouvelElement->valeur = valeur;
    nouvelElement->suivant = liste;
    return nouvelElement;
}

//ou en fin
llist ajouterEnFin(llist liste, double valeur)
{
    /* On crée un nouvel élément */
    Element* nouvelElement = malloc(sizeof(Element));

    /* On assigne la valeur au nouvel élément */
    nouvelElement->valeur = valeur;

    /* On ajoute en fin, donc aucun élément ne va suivre */
    nouvelElement->suivant = NULL;

    if(liste == NULL)
    {
        /* Si la liste est vide il suffit de renvoyer l'élément créé */
        return nouvelElement;
    } else {
        /* Sinon, on parcourt la liste à l'aide d'un pointeur temporaire et on
        indique que le dernier élément de la liste est relié au nouvel élément */
        Element* temp=liste;

        while(temp->suivant != NULL)
        {
            temp = temp->suivant;
        }
        temp->suivant = nouvelElement;

        //Et on efface la mémoire qu'on n'utilisera plus après.
        effacerListe(temp);

        return liste;
    }
}

//dans le tri d'une liste
llist ajout_tri_list(llist liste,double valeur)
{
    Element* a_inserer = malloc(sizeof(Element));
    a_inserer->valeur = valeur;
    
    if(liste==NULL)
    {
        a_inserer->suivant = NULL;
        return a_inserer;
    }

    if(a_inserer->valeur<=liste->valeur)
    {
        a_inserer->suivant=liste;
        return a_inserer;
    }
    
    llist courant=liste;
   
    if(courant->valeur<a_inserer->valeur)
    {
        courant->suivant=ajout_tri_list(courant->suivant,valeur);
    }

    free(a_inserer);
    return liste;
}

/*TRI D'UNE LISTE
    Trie la liste.
    Paramètres: L: liste à trier
    Retour: liste_triee: une liste triée
*/
llist trie_liste(llist L)
{
    llist liste_triee=NULL;
    if(L==NULL)
    {
        return NULL;
    }
    
    while(L!=NULL)
    {
        liste_triee=ajout_tri_list(liste_triee,L->valeur);
        L=L->suivant;
    }
    return liste_triee;
}

/************************************concatenation*****************************/
/*CONCATÉNATION DE 2 LISTES
    Concatène 2 listes.
    Paramètres: liste1/2: listes à concaténer
    Retour: L3: liste concaténée
*/
llist concatenation(llist liste1,llist liste2)
{
    if( (liste1==NULL)&&(liste2==NULL))
    {
        return NULL;
    }
    
    if(liste1==NULL)
    {
        if(liste2!=NULL)
        {
        return liste2;
        }
    }
    
    if(liste2==NULL)
    {   
        if(liste1!=NULL)
        {
        return liste1;
        }
    }
    
    llist L3=NULL;

    llist courant=liste1;
    while(courant->suivant)
    {
        L3=ajouterEnTete(L3,courant->valeur);
        courant=courant->suivant;
    }
        L3=ajouterEnTete(L3,courant->valeur);
    
    
    llist courant2=liste2;
    while(courant2->suivant)
    {
        L3=ajouterEnTete(L3,courant2->valeur);
        courant2=courant2->suivant;
    }
        L3=ajouterEnTete(L3,courant2->valeur);

    return L3;
}

/**********************************trie_par_paquet*****************************/
/*TRI PAR PAQUETS
    Trie un tableau par découpage en paquets.
    Paramètres: T: tableau de flottants
                n: taille du tableau
    Retour: en théorie, rien (void)
            en pratique, T: tableau trié
    Préconditions: T non vide
                   n > 0
*/
void trie_par_paquet(double* T,int n)
{
    llist* Taux=malloc(n*sizeof(llist));
    for(int i=0;i<n;i++)
    {
        Taux[i]=NULL;
        Taux[n*(int)T[i]]=ajouterEnTete(Taux[n*(int)T[i]], T[i] );
    }
    
    for(int i=0;i<n;i++)
    {
        Taux[i]=trie_liste(Taux[i]);
    }

    llist Tconcat=NULL; // la concaténation de toute les listes
    
    for(int i=0;i<n;i++)
    {
        Tconcat=concatenation(Tconcat,Taux[i]);
    }
    
    for(int i=0;i<n;i++)
    {
       T[i]=Tconcat->valeur;
       Tconcat=Tconcat->suivant; 
    }
    for(int i=0;i<n;i++)
    {
        effacerListe(Taux[i]);
    }
    effacerListe(Tconcat);
    free(Taux);
}

/**************************************main************************************/
int main(int argc, char* argv[])
{
    if(argc!=2) usage(argv[0]);
    int nb=atoi(argv[1]);
    double aTrier[nb];
    for(int taille=0; taille<nb; taille++)
        aTrier[taille]=rand()/(double)RAND_MAX;
    
    printf("Tableau non trié:\n");
    for(int i=0; i<nb; i++){
        printf("%lf\t", aTrier[i]);
    }

    trie_par_paquet(aTrier, nb);

    printf("\nTableau trié:\n");
    for(int i=0; i<nb; i++){
        printf("%lf\t", aTrier[i]);
    }
    printf("\n");
    return 0;
}