#include "plateau.h"
#include "base.h"

/**
 * @brief Plateau::Plateau
 * Constructeur du plateau avec le nombre de joueur
 * @param nbPlayer
 */
Plateau::Plateau(unsigned int nbPlayer){
    this->nbPlayer          = nbPlayer;
    this->nbWiresATrouver   = nbPlayer;
    Plateau::nbCardTotal    = this->getNbPlayer() * NBCARD;
    Plateau::genererJoueurs();
    this->m_cards.resize(this->getCardNumber());
    this->setNbCableACouper();
    this->bomb              = false;
    this->effectifCards     = this->getNbPlayer() * NBCARD;
}

void Plateau::setNbPlayer(unsigned int nbPlayer){
    if (this->nbPlayer == 0) {
        this->nbPlayer = nbPlayer;
        Plateau::nbCardTotal = this->getNbPlayer() * NBCARD;
        Plateau::genererJoueurs();                  //Allocation de joueurs
        this->m_cards.resize(this->getCardNumber());//Allocation de cartes
    }
}

unsigned int Plateau::getNbPlayer(){
    return this->nbPlayer;
}

unsigned int Plateau::getCardNumber() {
    return this->nbCardTotal;
}

unsigned int Plateau::getNbWiresATrouver(){
    return this->nbWiresATrouver;
}

unsigned Plateau::getEffectifCard() {
    return this->effectifCards;
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

void Plateau::printCards(unsigned playerIndex) {

    if (playerIndex < this->getNbPlayer()) {
        int tempIndex =  0;
        for (unsigned int j = 0; j < NBCARD ; j++){
            tempIndex =  this->m_players[playerIndex].getCardByIndex(j);
            std::cout << tempIndex << " ";
        }
        std::cout<< " " << std::endl;
    }
}


/**
 * @brief Plateau::whoHasScissors
 * Elle vérifie parmi les joueurs, lequel possède les ciseaux
 * @return
 */
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
 * Elle décremente le nombre de tour après un melange de carde
 */
void Plateau::nextCable(){
    this->nbCableACouper = this->nbCableACouper-1;
}

/**
 * @brief Plateau::shouldShuffle
 * Elle vérifie si on peut melanger
 * @return
 */
bool Plateau::shouldShuffle(){
    return !((this->nbCableACouper)%(this->nbPlayer));
}

/**
 * @brief Plateau::shuffle
 * Elle melange les cartes qui restent
 */
void Plateau::shuffle() {
    std::cout << this->indexDeck.size() << std::endl;
    //vérification
    //Melange des indices de cartes
    std::random_shuffle(this->indexDeck.begin(), this->indexDeck.end() -1);
}

void Plateau::distribuer() {
    //Nombre de cartes totales actuelles
    int nbCardTemp = int(this->indexDeck.size());
    
    std::cout << "NbTotal de cartes à Distribuer : " << nbCardTemp <<std::endl;
    unsigned compteurIndexCard = 0;
    for ( unsigned int i = 0; i <this->getNbPlayer()   ; i++) {
        for (unsigned int j = 0; j < nbCardTemp / this->nbPlayer ; j++)
        {
            this->m_players[i].addCard(this->indexDeck[compteurIndexCard++]);
        }  
    }
}

/**
 * @brief Plateau::getPlayerByIndex
 * Vérifie que l'indice € [0,nbPlayer[
 * @param playerIndex
 * @return
 */
Player Plateau::getPlayerByIndex(unsigned playerIndex) {
    Player temp;
    if (playerIndex < this->nbPlayer) {
        temp = this->m_players[playerIndex];
    }
    return temp;
}

/**
 * @brief Plateau::RemoveCard
 * Reçoit en paramère l'indice de carte du joueur(PlayerIndex)
 * @param playerIndex : indice de la carte choisie dans le tableau de joueur
 * @param index
 */
void Plateau::RemoveCard(unsigned int playerIndex, unsigned int cardIndex){
    Player p = this->m_players[playerIndex];
    WIRE card = p.getCardByIndex(cardIndex);
    if(card == BOMB)
        this->bomb = true;
    else if(card == DEFUSING)
        this->nbWiresATrouver--;
    
    this->m_players[playerIndex].removeCardByIndex(cardIndex);
    this->nbCableACouper--;
    this->effectifCards--;
    //this->indexDeck[cardIndex]=-1;
}

/**
 * @brief Plateau::endGame
 * @return bool
 */
bool Plateau::endGame(){

    return !nbWiresATrouver || bomb ||!nbCableACouper ;
}
void Plateau::takeCards(){
    unsigned nbP = this->nbPlayer;   
    
    //Reallocation de indexCard
    this->indexDeck.resize(this->getEffectifCard());

    //Parcourir chaque joueur et recuperer leurs cartes != -1
    unsigned compteurGeneral = 0;
    for (unsigned i = 0; i < nbP; i++) {
        Player pActuel = this->getPlayerByIndex(i);
        for (unsigned j = 0; j < pActuel.getNbCard(); j++) {
            if (pActuel.getCardByIndex(j) != -1 )
                this->indexDeck[compteurGeneral++] = pActuel.getCardByIndex(j);
        }
    }

    //Reinitialisation de cartes de chaque joueur par -1
    for (unsigned i=0; i<nbP; i++) {
        this->m_players[i].initCard();
    }
}
/**
 * @brief Plateau::winner
 * @return TEAM
 */
TEAM Plateau::winner(){
    return (!nbWiresATrouver)?SHERLOCK_HOLMES : JAMES_MORIARTY;
}

/**
 * @brief Plateau::genererJoueurs
 * Elle fait l'allocation de nombre de joueurs
 */
void Plateau::genererJoueurs(){
    this->m_players.resize(this->nbPlayer);
}

void Plateau::InitialisationDeck(){

    /*---------------------------------------
                INITIALIATION DES CARTES
    ----------------------------------------*/
    //Nombre de cartes totales : 'nbCards'
    unsigned const int nbCards   = this->getCardNumber();
    unsigned int nbPlayer        = this->nbPlayer;
    //this->m_cards.resize(nbCards);

    // O : c'est la bomb
    this->m_cards[0].setType(BOMB);

    //1 : les cartes utiles
    unsigned int i = 1;
    for ( ;i <= nbPlayer; i++) {
       this->m_cards[i].setType(DEFUSING);
    }

    //2 : cartes inutiles
    unsigned j = i;
    for (; j < nbCards ; j++) {
        this->m_cards[j + nbPlayer].setType(SECURE) ;
    }

    /*---------------------------------------
              INITIALIATION DES JOUEURS
    ----------------------------------------*/
    for (unsigned int i = 0; i < nbPlayer ; i++) {
        this->m_players[i] = Player();
    }

    //NOMBRE DE WIRES A TROUVER
    this->nbWiresATrouver = this->nbPlayer;

    //NOMBRES DE CABLES A COUPER
    this->nbCableACouper = nbCards - this->nbPlayer;

    //INITIALISATION DE INDEX DECK
    this->indexDeck.resize(nbCards);
    for (unsigned int i = 0; i < nbCards ;i++) {
        this->indexDeck[i] = int(i);
        std::cout << "Valeurs : " << this->indexDeck[i] << std::endl;
    }
    //MELANGE DES INDICES
    this->shuffle();
}

/**
 * @brief Fonction qui attribut
 * le rôle à chaque joueur
 */
void Plateau::setRoles() {
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
    
    std::vector<int> players;
    players.resize(unsigned(long(nbMoriarty + nbSherlock)));
    unsigned int i = 0;
    for (; i < unsigned(nbMoriarty); i++){
        players[i] = JAMES_MORIARTY;
    }
    
    for ( ; i < unsigned(nbMoriarty + nbSherlock); i++){
        players[i] = SHERLOCK_HOLMES;
    }

    //Attribution de rôle aux joueurs
    std::random_shuffle(players.begin(), players.end() -1);
    for (unsigned int i = 0;i < this->nbPlayer;i++) {
        this->m_players[i].setTeam(players[i]);
    }
}

void Plateau::startGame() {

    /*---------------------------------------
              Initialisation de Plateau
    ----------------------------------------*/

    this->InitialisationDeck();

    /*---------------------------------------
              Initialisation de Players
    ----------------------------------------*/
    this->setRoles();

    /*-------------------------------------------
      Choix du player à débuter avec les ciseaux
    --------------------------------------------*/
   
    unsigned int r = getAleatInt(0,int(this->nbPlayer-1));
    this->m_players[r].takeScissors();
    this->playerWithScissors    = r;
    unsigned int playerIndex    = 0; 
    unsigned int cardIndex      = 0;

    /*-------------------------------------------
                  Distribution de cartes
    --------------------------------------------*/
    
    this->distribuer();

    do {
        std::cout << this->nbCableACouper << std::endl;
        std::cout << "nbPlayer:";
        std::cout << this->nbPlayer << std::endl;
        std::cout <<"Nombre de cartes restantes : " << this->getEffectifCard() << std::endl;
        if(this->shouldShuffle()) {
            std::cout <<"SHUFFLING..." << std::endl;
        std::cout <<"Nombre de cartes restantes : " << this->getEffectifCard() << std::endl;
            this->takeCards();
            this->shuffle();
            this->distribuer();

             for (unsigned i = 0;i < this->nbPlayer;i++) {
                std::cout << "Player n° : " << i << " Rôle : " << this->getPlayerByIndex(i).getTeam()<< "->";
                this->printCards(i);
            }
        }
        //GETTING PLAYER INDEX
        std::cout << "JOUEUR ACTUEL N ° : " << playerWithScissors << std::endl;
        do {
            std::cout << "Choisir un Joueur à fin de couper une des ses cartes : ";
            std::cin >> playerIndex;
        }while(playerIndex == playerWithScissors || playerIndex > this->nbPlayer-1 || !this->m_players[playerIndex].canHePlay());

        //GETTING CARD INDEX
        do {
            std::cout << "Nombre de cartes : " << this->m_players[playerIndex].getNbCard() << std::endl;
            std::cout << "Choisir la carte parmis ses cartes : ";
            this->printCards(playerIndex);
            std::cin >> cardIndex;

        }while(cardIndex > (NBCARD - 1) || this->m_players[playerIndex].getCardByIndex(cardIndex) == -1 );

        this->RemoveCard(playerIndex , cardIndex);
        this->printCards(playerIndex);
        this->changeOwnerOfScissors(this->playerWithScissors, playerIndex);

    }while(!this->endGame());


    if (winner() == SHERLOCK_HOLMES) {
        std::cout << "SHERLOCK WON" << std::endl;
    }else {
        std::cout << "MORIARTY WON" << std::endl;
    }
}
