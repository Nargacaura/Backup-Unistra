#ifndef CARD_H
#define CARD_H

#include "base.h"

class Card
{
   public:
    Card();
    Card(int type);
    void setStatus(bool status);
    bool getStatus();
    unsigned getCardType();
    void setCardType(unsigned type);
    private:
        bool status;
        unsigned type;

};

#endif // CARD_H
