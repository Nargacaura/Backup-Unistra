#include "plateau.h"

int main(int argc, char *argv[])
{
    srand(time(NULL));
    int nbJoueur = 0;
    std::cout<< "Taper le nombre de Joueur :";
    std::cin >> nbJoueur;
    std::cout<< "Il y a " << nbJoueur << std::endl;
    Plateau debut = Plateau(nbJoueur);
    debut.startGame();
     
    (void) argc;
    (void) argv;
    return 0;
}
