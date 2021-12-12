#include "watch_cards.h"
#include "ui_watch_cards.h"

watch_cards::watch_cards(QWidget *parent, unsigned nbPlayers, Plateau* plate) :
    QDialog(parent),
    ui(new Ui::watch_cards)
{
    //variable utilisée dans On_confirmed_Player_Clicked
    role_variable_sherlock  = 0; // variable pour afficher les perso de Sherlock
    role_variable_Moriarty  = 0; //variable pour afficher les perso de Moriarty
    ui->setupUi(this);
    this->cartes_joueurs    = plate;
    this->MaxPlayers        = nbPlayers;
    this->current_player    = 1;
    ui->Card_role->setVisible(0);
    ui->Card1->setVisible(0);
    ui->Card2->setVisible(0);
    ui->Card3->setVisible(0);
    ui->Card4->setVisible(0);
    ui->Card5->setVisible(0);
    ui->Nextplayer->setVisible(0);
    ui->Placeholder->setText("Is "+ QString::fromUtf8(this->cartes_joueurs->getPlayerByIndex(this->current_player-1).getUsername().c_str())+" looking at the screen alone?");
    ui->StartGame->setVisible(0);
}
watch_cards::watch_cards(QWidget *parent, unsigned nbPlayers, Plateau* plate,parameters * paramWC) :
    QDialog(parent),
    paramWC(paramWC),
    ui(new Ui::watch_cards)

{
    //variable utilisée dans On_confirmed_Player_Clicked
    role_variable_sherlock  = 0; // variable pour afficher les perso de Sherlock
    role_variable_Moriarty  = 0; //variable pour afficher les perso de Moriarty
    ui->setupUi(this);
    this->cartes_joueurs    = plate;
    this->MaxPlayers        = nbPlayers;
    this->current_player=1;
    ui->Card_role->setVisible(0);
    ui->Card1->setVisible(0);
    ui->Card2->setVisible(0);
    ui->Card3->setVisible(0);
    ui->Card4->setVisible(0);
    ui->Card5->setVisible(0);
    ui->Nextplayer->setVisible(0);
    ui->Placeholder->setText("Is "+ QString::fromUtf8(this->cartes_joueurs->getPlayerByIndex(this->current_player-1).getUsername().c_str())+" looking at the screen alone?");
    ui->StartGame->setVisible(0);
}


watch_cards::~watch_cards()
{
    delete ui;
}


void watch_cards::blufftime(){
    ui->ConfirmPlayer->setVisible(0);
    ui->Nextplayer->setVisible(0);
    ui->Card1->setVisible(0);
    ui->Card2->setVisible(0);
    ui->Card3->setVisible(0);
    ui->Card4->setVisible(0);
    ui->Card5->setVisible(0);
    ui->Placeholder->setText("Time to bluff!");
    ui->StartGame->setVisible(1);
}

void watch_cards::on_ConfirmPlayer_clicked(){

    this->paramWC->buttonSound(CLICK);

    ui->ConfirmPlayer->setVisible(0);
    ui->Nextplayer->setVisible(1);

    if(cartes_joueurs->m_players[this->current_player-1].getTeam()==SHERLOCK_HOLMES){
        switch(role_variable_sherlock){
        case 0:// sherlock
             ui->Card_role->setText("<html><head/><body><p><img src=\":/resources/Cards/Sherlock.png\" width=196/></p></body></html>");

            break;
        case 1:// Watson
               ui->Card_role->setText("<html><head/><body><p><img src=\":/resources/Cards/Watson.png\" width=196/></p></body></html>");
            break;
        case 2:// Lestrade
               ui->Card_role->setText("<html><head/><body><p><img src=\":/resources/Cards/Lestrade.png\" width=196/></p></body></html>");
            break;
        case 3:// Mary
               ui->Card_role->setText("<html><head/><body><p><img src=\":/resources/Cards/Mrs._Watson.png\" width=196/></p></body></html>");

            break;
        case 4:// Hutson
                    ui->Card_role->setText("<html><head/><body><p><img src=\":/resources/Cards/Mrs._Hudson.png\" width=196/></p></body></html>");

            break;
        }
        role_variable_sherlock++;
    }
    if(cartes_joueurs->m_players[this->current_player-1].getTeam()==JAMES_MORIARTY){

        switch(role_variable_Moriarty){
        case 0:// Moriarty
               ui->Card_role->setText("<html><head/><body><p><img src=\":/resources/Cards/Moriarty.png\" width=196/></p></body></html>");
               break;
        case 1:// Sbir
               ui->Card_role->setText("<html><head/><body><p><img src=\":/resources/Cards/Sbir.png\" width=196/></p></body></html>");
               break;
        case 2:// Adler
            ui->Card_role->setText("<html><head/><body><p><img src=\":/resources/Cards/Adler.png\" width=196/></p></body></html>");
               break;
        }
    role_variable_Moriarty=role_variable_Moriarty+1;//on augmente à chaque perso de moriarty
    }

    for(unsigned i=0; i<cartes_joueurs->m_players[this->current_player-1].getNbCard(); i++){
       if(cartes_joueurs->m_cards[cartes_joueurs->m_players[this->current_player-1].getCardByIndex(i)].getType()==0){
            switch(i){
                case 0:ui->Card1->setText("<html><head/><body><p><img src=\":/resources/Cards/Bomb.png\" width=196/></p></body></html>"); break;
                case 1:ui->Card2->setText("<html><head/><body><p><img src=\":/resources/Cards/Bomb.png\" width=196/></p></body></html>"); break;
                case 2:ui->Card3->setText("<html><head/><body><p><img src=\":/resources/Cards/Bomb.png\" width=196/></p></body></html>"); break;
                case 3:ui->Card4->setText("<html><head/><body><p><img src=\":/resources/Cards/Bomb.png\" width=196/></p></body></html>"); break;
                default:ui->Card5->setText("<html><head/><body><p><img src=\":/resources/Cards/Bomb.png\" width=196/></p></body></html>");
            }
        } else if(cartes_joueurs->m_cards[cartes_joueurs->m_players[this->current_player-1].getCardByIndex(i)].getType()==1){
            switch(i){
                case 0:ui->Card1->setText("<html><head/><body><p><img src=\":/resources/Cards/DefusingWire.png\" width=196/></p></body></html>"); break;
                case 1:ui->Card2->setText("<html><head/><body><p><img src=\":/resources/Cards/DefusingWire.png\" width=196/></p></body></html>"); break;
                case 2:ui->Card3->setText("<html><head/><body><p><img src=\":/resources/Cards/DefusingWire.png\" width=196/></p></body></html>"); break;
                case 3:ui->Card4->setText("<html><head/><body><p><img src=\":/resources/Cards/DefusingWire.png\" width=196/></p></body></html>"); break;
                default:ui->Card5->setText("<html><head/><body><p><img src=\":/resources/Cards/DefusingWire.png\" width=196/></p></body></html>");
            }
        } else {
            switch(i){
                case 0:ui->Card1->setText("<html><head/><body><p><img src=\":/resources/Cards/SafeWire.png\" width=196/></p></body></html>"); break;
                case 1:ui->Card2->setText("<html><head/><body><p><img src=\":/resources/Cards/SafeWire.png\" width=196/></p></body></html>"); break;
                case 2:ui->Card3->setText("<html><head/><body><p><img src=\":/resources/Cards/SafeWire.png\" width=196/></p></body></html>"); break;
                case 3:ui->Card4->setText("<html><head/><body><p><img src=\":/resources/Cards/SafeWire.png\" width=196/></p></body></html>"); break;
                default:ui->Card5->setText("<html><head/><body><p><img src=\":/resources/Cards/SafeWire.png\" width=196/></p></body></html>");
            }
        }
    }
            ui->Card_role->setVisible(1);
            if(cartes_joueurs->m_players[this->current_player-1].getCardByIndex(0)!=-1)
                ui->Card1->setVisible(1);
            if(cartes_joueurs->m_players[this->current_player-1].getCardByIndex(1)!=-1)
                ui->Card2->setVisible(1);
            if(cartes_joueurs->m_players[this->current_player-1].getCardByIndex(2)!=-1)
                ui->Card3->setVisible(1);
            if(cartes_joueurs->m_players[this->current_player-1].getCardByIndex(3)!=-1)
                ui->Card4->setVisible(1);
            if(cartes_joueurs->m_players[this->current_player-1].getCardByIndex(4)!=-1)
                ui->Card5->setVisible(1);
            ui->Placeholder->setText("Here're your cards, "+ QString::fromUtf8(cartes_joueurs->getPlayerByIndex(this->current_player-1).getUsername().c_str()) +"!");
}

void watch_cards::on_Nextplayer_clicked(){

    this->paramWC->buttonSound(CLICK);

    ui->ConfirmPlayer->setVisible(1);
    ui->Nextplayer->setVisible(0);
    ui->Card1->setVisible(0);
    ui->Card2->setVisible(0);
    ui->Card3->setVisible(0);
    ui->Card4->setVisible(0);
    ui->Card5->setVisible(0);
    ui->Card_role->setVisible(0);
    if(this->current_player<this->MaxPlayers){
        this->current_player++;
        ui->Placeholder->setText("Is "+ QString::fromUtf8(this->cartes_joueurs->getPlayerByIndex(this->current_player-1).getUsername().c_str())+" looking at the screen alone?");
    }
    else blufftime();

}

void watch_cards::on_StartGame_clicked(){
    this->paramWC->buttonSound(CLICK);
    hide();
}
