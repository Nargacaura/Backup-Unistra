#include "plateau.h"
#include "base.h"

Plateau::Plateau(unsigned int nbPlayer){
    this->nbPlayer = nbPlayer;
    Plateau::genererJoueurs();
}

void Plateau::setNbPlayer(unsigned int nbPlayer){
    if (this->nbPlayer == 0 )
        this->nbPlayer = nbPlayer;
}

unsigned int Plateau::getNbPlayer(){
    return this->nbPlayer;
}

unsigned int Plateau::getNbWiresATrouver(){
    return this->nbWiresATrouver;
}

/**
 * @brief Plateau::changeOwnerOfScissors
 * @param one
 * @param two
 * Rendre les ciseaux d'un joueur à l'autre
 */
void Plateau::changeOwnerOfScissors(unsigned int src, unsigned int dst){
    this->m_players[src].giveScissors();
    this->m_players[dst].takeScissors();
    this->playerWithScissors = dst;
}

int Plateau::whoHasScissors(){
    Player temp = Player();
    unsigned int effectif = this->getNbPlayer();

    for(unsigned int i = 0; i < effectif;i++) {
        if(m_players[i].hasScissors()) {
            return int(i);
        }
    }
    return -1;
}

/**
 * @brief Plateau::setNbTourReste
 * elle change le nombre de tour qui reste
 * par rapport au nombre de cables qui restent
 */
void Plateau::setNbCableACouper(){

    this->nbCableACouper = ((this->nbPlayer)-1)*(NBCARD);
}

/**
 * @brief Plateau::nextCable
 * Elle decremente le nombre de tour après une melange de carde
 */
void Plateau::nextCable(){

    this->nbCableACouper = this->nbCableACouper-1;

}

bool Plateau::shouldShuffle(){
    return !((((this->nbPlayer)-1)*(NBCARD))%(this->nbPlayer));
}

/**
 * @brief Plateau::shuffle
 * Fonction melange : elle melange les cartes qui restent
 */
void Plateau::shuffle() {
    //vérification
    unsigned int nbCardTemp = unsigned(this->m_cards.size());

    for (unsigned int i = 0;i < nbCardTemp;i++) {
        if (this->indexDeck[i] == -1)
               this->indexDeck.erase(indexDeck.begin()+i);
    }

    std::random_shuffle(this->indexDeck.begin(), this->indexDeck.end() -1);
}


void Plateau::distribuer() {
    //Nombre de cartes total
    //unsigned int nbCardTemp = int(this->m_cards.size());

    unsigned compteurIndexCard = 0;

    for ( unsigned int i = 0; i < this->nbPlayer ; i++) {
        for (unsigned int j = 0; j < NBCARD ; j++) {
            this->m_players[i].addCard(this->indexDeck[compteurIndexCard++]);
        }  
    }
}

// à revérifier
void Plateau::RemoveCard(unsigned int playerIndex, unsigned int cardIndex){
    this->m_players[playerIndex].removeCardByIndex(unsigned(this->m_players[playerIndex].getCardByIndex(cardIndex)));
    //this->indexDeck[cardIndex]= -1;
}

/**
 * @brief Plateau::endGame
 * @return bool
 */
bool Plateau::endGame(){
    return !nbWiresATrouver || bomb ||!nbCableACouper ;
}

/**
 * @brief Plateau::winner
 * @return TEAM
 */
TEAM Plateau::winner(){

    return (!nbWiresATrouver)?SHERLOCK_HOLMES : JAMES_MORIARTY;

}

void Plateau::printCards(unsigned playerIndex) {
   
    if (playerIndex < this->getNbPlayer()) {
        unsigned tempIndex =  0;
        for (unsigned int j = 0; j < NBCARD ; j++){
            tempIndex =  this->m_players[playerIndex].getCardByIndex(j);
            std::cout << tempIndex << " ";
        }
        std::cout<< " " << std::endl;
    } 
}

void Plateau::genererJoueurs(){
    this->m_players.resize(this->nbPlayer);
}


void Plateau::InitialisationDeck(){

    /*---------------------------------------
                INITIALIATION DES CARTES
    ----------------------------------------*/
    //Nombre de cartes totales : 'nbCards'
    unsigned const int nbCards   = this->getNbPlayer() * NBCARD;
    unsigned int nbPlayer        = this->nbPlayer;
    this->m_cards.resize(nbCards);

    // O : c'est la bomb
    this->m_cards[0] = BOMB;

    //1 : les cartes utiles
    unsigned int i = 1;
    for ( ;i <= nbPlayer; i++) {
       this->m_cards[i] = DEFUSING;
    }

    //2 : cartes inutiles
    unsigned j = i;
    for (; j < nbCards ; j++) {
        this->m_cards[j + nbPlayer] = SECURE;
    }

    /*---------------------------------------
              INITIALIATION DES JOUEURS
    ----------------------------------------*/
    Plateau::genererJoueurs();
    for (unsigned int i = 0; i < nbPlayer ; i++) {
        this->m_players[i] = Player();
    }

    //BOMB VALUE
    this->bomb = false;

    //NOMBRE DE WIRES A TROUVER
    this->nbWiresATrouver = this->nbPlayer;

    //NOMBRES DE CABLES A COUPER
    this->nbCableACouper = nbCards-this->nbPlayer;

    //INITIALISATION DE INDEX DECK
    this->indexDeck.resize(nbCards);
    for (unsigned int i = 0; i < nbCards ;i++) {
        this->indexDeck[i] = int(i);
    }

    //MELANGE DES INDICES
    this->shuffle();
}
/*
 * initialisation les joueurs 
 * et donne à chaque joueur un rôle
 */
void Plateau::setRoles() {
    std::vector<TEAM> players;
    int nbMoriarty = 0;
    int nbSherlock = 0;
    switch (this->nbPlayer) {
        case 4:
        case 5:
        {
            nbMoriarty = 2;
            nbSherlock = 3;
            break;
        }
        case 6:
        {
            nbMoriarty = 2;
            nbSherlock = 4;
            break;
        }
        case 7:
        case 8:
        {
            nbMoriarty = 3;
            nbSherlock = 5;
            break;
        }
    }

    players.resize(unsigned(long(nbMoriarty + nbSherlock)));
    std::random_shuffle(players.begin(), players.end() -1);
    for (unsigned int i = 0;i < this->nbPlayer;i++) {
        this->m_players[i].setTeam(players[i]);
    }
}

void Plateau::startGame() {
    /*---------------------------------------
              Création de joueur
    ----------------------------------------*/
    this->genererJoueurs();

    /*---------------------------------------
              Initialisation de Plateau
    ----------------------------------------*/
    this->InitialisationDeck();
    for (unsigned i = 0;i < this->m_cards.size();i++) {
        std::cout << this->indexDeck[i] << " ";
    }
    std::cout<< "\nFin d'affichage des indices mélangés "<< std::endl;
    /*---------------------------------------
              Initialisation de Players
    ----------------------------------------*/
    this->setRoles();

    /*-------------------------------------------
      Choix du player à béduter avec les ciseaux
    --------------------------------------------*/
    unsigned int r = getAleatInt(0,int(this->nbPlayer-1));
    this->m_players[r].takeScissors();
    this->playerWithScissors    = r;
    unsigned int playerIndex    = 0; 
    unsigned int cardIndex      = 0;

    //Distribution de cartes
        this->distribuer();

    do {
        
        
        //GETTING PLAYER INDEX
        std::cout << "JOUEUR N ° " << playerWithScissors << std::endl;
        do {
            std::cout << "Choisir le Joueur :" << std::endl;
            std::cin >> playerIndex;
        }while(playerIndex == playerWithScissors || playerIndex > this->nbPlayer-1);
        this->m_players[playerIndex].printCards(playerIndex);
        //GETTING CARD INDEX
        do {
            std::cout << "Nombre de cartes:" << this->m_players[playerIndex].getNbCard() << std::endl;
            std::cout << "Choisir la carte :" << std::endl;
            std::cin >> cardIndex;
        }while(cardIndex > (this->m_players[playerIndex].getNbCard() - 1) );

        this->RemoveCard(playerIndex , cardIndex);
        this->changeOwnerOfScissors(this->playerWithScissors, playerIndex);

    }while(!this->endGame());


    if (winner() == SHERLOCK_HOLMES) {
        std::cout << "SHERLOCK WON" << std::endl;
    }else {
        std::cout << "MORIARTY WON" << std::endl;
    }
}
