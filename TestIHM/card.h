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
    int getType();
    void setType(int type);
    private:
        bool status;
        int type;

};

#endif // CARD_H
