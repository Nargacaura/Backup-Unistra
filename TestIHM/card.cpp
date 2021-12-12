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

int Card::getType() {
    return this->type;
}

void Card::setType(int type) {
    this->type = type;
}
