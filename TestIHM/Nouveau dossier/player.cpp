#include "player.h"

Player::Player():
    nbCard(0)

{
    initCard();
};


void Player::setTeam(TEAM team) {
    this->role = team;
}

void Player::setUsername(std::string username) {

    this->username = username;
}
std::string Player::getUsername() {
    return this->username;
}

TEAM Player::getTeam() {
    return  this->role;
}

bool Player::hasScissors() {
    return this->scissors;
}

void Player::giveScissors() {
    this->scissors = false;
}
void Player::takeScissors() {
    this->scissors = true;
}

/**
 * @brief Player::initCard
 * @param value
 */
void Player::initCard() {
    for (unsigned int i = 0 ;i < NBCARD; i++)
        this->cards[i]= -1;

    this->effectif = 0;
}

/**
 * @brief Player::addCard
 * Elle rajoute l'indice d'une carte dans un table des indeces de cartes
 * @param value
 */
void Player::addCard(int value) {

    this->cards[this->effectif++]= value;
}

/**
 * @brief Player::removeCardByIndex
 * elle supprime l'indice d'une carte donnée
 * @param card_index
 */
void Player::removeCardByIndex(unsigned int card_index) {
    if (card_index < NBCARD)
        this->cards[card_index] = -1;
}

/**
 * @brief Player::getCardByIndex
 * @param index
 * @return
 */
int Player::getCardByIndex(unsigned int index) {
    if (index < NBCARD)
        return this->cards[index];
    return -1;
}

unsigned int Player::getNbCard() {
    unsigned int compteur = 0;
    for (unsigned int i = 0; i < NBCARD; i++)
    {
        if (this->cards[i] != -1)
            compteur++;
    }
    return compteur;
}


    // tirer ou tak*/
