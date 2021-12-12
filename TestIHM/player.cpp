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
    if (card_index < NBCARD) {
        std::cout << "indice à supp : " << card_index << "Vaut : "<< this->cards[card_index] <<std::endl;
        this->cards[card_index] = -1;
        std::cout << "Voici la carte changée : "<< this->cards[card_index] <<std::endl;
        this->effectif--;
    }
}

/**
 * @brief Player::getCardByIndex
 * Cette fonction reçoit un indice de cartes du joueur actuel
 * puis return indice de la carte qui se trouve sur le plateau
 * @param index
 * @return index
 */
int Player::getCardByIndex(unsigned int index) {
    if (index < NBCARD)
        return this->cards[index];
    return -1;
}

/**
 * @brief Player::getNbCard que le joueur possède actuellement
 * Elle retourne le nombre de cartes non coupées
 * @return
 */
unsigned int Player::getNbCard() {
    unsigned int compteur = 0;
    for (unsigned int i = 0; i < NBCARD; i++)
    {
        if (this->cards[i] != -1)
            compteur++;
    }
    return compteur;
}

/**
 * @brief Elle vérifie si toutes les cartes 
 * du joueur ont été coupées pour determiner s'il peut
 * jouer ou pas
 * @return true 
 * @return false 
 */
bool Player::canHePlay() {
    for (unsigned int i = 0; i < NBCARD; i++)
        if (this->getCardByIndex(i) != -1)     
            return true;
    std::cout << "Ah!!! Je n'ai plus des cartes à couper, choisissez un autre joueur ;-)"<< std::endl;
    return false;
}

    // tirer ou tak*/
