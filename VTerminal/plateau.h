#ifndef PLATEAU_H
#define PLATEAU_H

//INCLUDES CLASS
#include "base.h"
#include "card.h"
#include "player.h"

class Plateau
{
    /**
     * @brief
     * Pour calculer les cartes en fonction de  nbJoueurs, il faut faire :
     * Cartes  nbJoueurs * 5 - nbJoueuer
     */
    public:
        //Constructeur
        Plateau(unsigned int nbPlayer);

        //Méthodes
        void setNbPlayer(unsigned int nbPlayer);
        unsigned int getNbPlayer();
        unsigned int getCardNumber();
        void distribuer();
        void shuffle();
        bool shouldShuffle();// verification de melange
        unsigned int getNbWiresATrouver();
        void actualiser();
        int whoHasScissors();
        void setNbCableACouper();
        void nextCable();
        void changeOwnerOfScissors(unsigned int src, unsigned int dst);
        void RemoveCard(unsigned int playerIndex, unsigned int index);
        void InitialisationDeck();
        void setRoles();
        void takeCards();
        void startGame();
        //Pour le test e,n mode console
        void printCards(unsigned playerIndex);
        Player getPlayerByIndex(unsigned playerIndex);

    private:
        void genererJoueurs(); //CrÃ©ation de joueurs par rapport nombre de
                                                    //joueurs passÃ©s en paramÃ¨tre.Utile pour la
                                                    // mÃ©thode setNbPlayer et Plateau(nbPlayer)
        TEAM winner();
        bool endGame();
        std::vector<Card> m_cards; // les cartes
        std::vector<Player> m_players;              //Tableau des joueurs
        std::vector<int> indexDeck;
        unsigned int nbPlayer;
        unsigned int nbCableACouper;                //Nombre de tour qui reste Ã  jouer
        unsigned int nbWiresATrouver;               //Cartes utiles à trouver
        bool bomb;
        unsigned int playerWithScissors; 
        unsigned int nbCardTotal;
};

#endif
