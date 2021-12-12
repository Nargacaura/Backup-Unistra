#include "card.h"

Card::Card():
    status(false),
    type(0)
{};

Card::Card(int type) {
    this->type = type;
    this->status = false;
}
bool Card::getStatus() {
    return this->status;
}

void Card::setStatus(bool status) {
    this->status = status;
}

unsigned Card::getCardType() {
    return this->type;
}
void Card::setCardType(unsigned type) {
    this->type = type;
}

