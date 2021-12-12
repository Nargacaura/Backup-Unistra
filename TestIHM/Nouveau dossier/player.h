#ifndef PLAYER_H
#define PLAYER_H

#include "base.h"

class Player
{
    public:
        Player();
        Player(char * username, WIRE team);

        std::string getUsername();//ok
        TEAM getTeam();//ok

        void addCard(int card) ;//pas finie
        void removeCardByIndex(unsigned int card_index);

        bool hasScissors();
        void giveScissors();
        void takeScissors();
        void setUsername(std::string username);
        void setTeam(TEAM team);
        int getCardByIndex(unsigned int index);
        unsigned int getNbCard();
        void initCard();
    private:
        std::string username;
        TEAM role;

        int cards[NBCARD];
        int effectif = 0;
        bool scissors;
        unsigned int nbCard;
}; 

#endif 
