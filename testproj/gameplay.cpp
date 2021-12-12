#include "gameplay.h"
#include "ui_gameplay.h"
#include "mainwindow.h"

gameplay::gameplay(QWidget *parent, unsigned nbPlayers, Plateau* plate) :
    QDialog(parent),
    ui(new Ui::gameplay)
{
    ui->setupUi(this);
    this->game=plate;
    ui->actual_player_name->setText(this->game->getPlayerByIndex(unsigned(game->whoHasScissors())).getUsername().c_str());

    ui->card1->setVisible(0);
    ui->card2->setVisible(0);
    ui->card3->setVisible(0);
    ui->card4->setVisible(0);
    ui->card5->setVisible(0);
    ui->ExitGame->setVisible(0);

    ui->player1_role->setCheckable(true);
    ui->player2_role->setCheckable(true);
    ui->player3_role->setCheckable(true);
    ui->player4_role->setCheckable(true);
    ui->player5_role->setCheckable(true);
    ui->player6_role->setCheckable(true);
    ui->player7_role->setCheckable(true);
    ui->pause->setCheckable(true);

    unsigned int r = getAleatInt(0,int(nbPlayers)-1);
    game->m_players[r].takeScissors();
    this->picked=0;

    this->round=1;
    this->roundText="Round: ";
    this->roundText+= QString::number(this->round).toStdString();
    this->roundText+="/4";
    ui->rounds->setText(QString::fromUtf8(this->roundText.c_str()));

    this->defusers=0;
    this->defusedText= QString::number(this->defusers).toStdString();
    this->defusedText+="/";
    this->defusedText+= QString::number(this->game->getNbPlayer()).toStdString();
    ui->Defused->setText(QString::fromUtf8(this->defusedText.c_str()));

    this->withScissors=0;
    for(unsigned indice=0; indice<this->game->getNbPlayer(); indice++){
        if(game->whoHasScissors() == int(indice)){
            this->withScissors=indice;
        }
    }
    this->toSwitch=game->getPlayerByIndex(this->withScissors);

    List.push_back(this->toSwitch);
    unsigned indice;
    //initialisation
    for(indice=0; (indice<game->getNbPlayer()) && (game->whoHasScissors() != int(indice)); indice++){
            List.push_back(game->m_players[indice]);
    }

    for(indice=indice+1; indice<this->game->getNbPlayer(); indice++){
            List.push_back(this->game->m_players[indice]);
    }
    switch (this->game->getNbPlayer()) {
            case 6: {
                    ui->player1_role->setVisible(0);
                    ui->player1_name->setVisible(0);
                    ui->player7_role->setVisible(0);
                    ui->player7_name->setVisible(0);
                    switch (game->whoHasScissors()) {
                        case 5: {
                            ui->player2_name->setText(List[1].getUsername().c_str());
                            ui->player3_name->setText(List[2].getUsername().c_str());
                            ui->player4_name->setText(List[3].getUsername().c_str());
                            ui->player5_name->setText(List[4].getUsername().c_str());
                            ui->player6_name->setText(List[0].getUsername().c_str());
                        }
                        break;
                        case 1: {
                            ui->player2_name->setText(List[0].getUsername().c_str());
                            ui->player3_name->setText(List[2].getUsername().c_str());
                            ui->player4_name->setText(List[3].getUsername().c_str());
                            ui->player5_name->setText(List[4].getUsername().c_str());
                            ui->player6_name->setText(List[5].getUsername().c_str());
                        }
                        break;
                        case 2: {
                            ui->player2_name->setText(List[1].getUsername().c_str());
                            ui->player3_name->setText(List[0].getUsername().c_str());
                            ui->player4_name->setText(List[3].getUsername().c_str());
                            ui->player5_name->setText(List[4].getUsername().c_str());
                            ui->player6_name->setText(List[5].getUsername().c_str());
                        }
                        break;
                        case 3: {
                            ui->player2_name->setText(List[1].getUsername().c_str());
                            ui->player3_name->setText(List[2].getUsername().c_str());
                            ui->player4_name->setText(List[0].getUsername().c_str());
                            ui->player5_name->setText(List[4].getUsername().c_str());
                            ui->player6_name->setText(List[5].getUsername().c_str());
                        }
                        break;
                        case 4: {
                            ui->player2_name->setText(List[1].getUsername().c_str());
                            ui->player3_name->setText(List[2].getUsername().c_str());
                            ui->player4_name->setText(List[3].getUsername().c_str());
                            ui->player5_name->setText(List[0].getUsername().c_str());
                            ui->player6_name->setText(List[5].getUsername().c_str());
                        }
                        break;
                        default: {
                            ui->player2_name->setText(List[1].getUsername().c_str());
                            ui->player3_name->setText(List[2].getUsername().c_str());
                            ui->player4_name->setText(List[3].getUsername().c_str());
                            ui->player5_name->setText(List[4].getUsername().c_str());
                            ui->player6_name->setText(List[5].getUsername().c_str());
                        }
                    }
                }
                    break;
            case 5: {
                    ui->player1_role->setVisible(0);
                    ui->player1_name->setVisible(0);
                    ui->player4_role->setVisible(0);
                    ui->player4_name->setVisible(0);
                    ui->player7_role->setVisible(0);
                    ui->player7_name->setVisible(0);
                    switch (game->whoHasScissors()){
                        case 1: {
                            ui->player2_name->setText(List[0].getUsername().c_str());
                            ui->player3_name->setText(List[2].getUsername().c_str());
                            ui->player5_name->setText(List[3].getUsername().c_str());
                            ui->player6_name->setText(List[4].getUsername().c_str());
                        }
                        break;
                        case 2: {
                            ui->player2_name->setText(List[1].getUsername().c_str());
                            ui->player3_name->setText(List[0].getUsername().c_str());
                            ui->player5_name->setText(List[3].getUsername().c_str());
                            ui->player6_name->setText(List[4].getUsername().c_str());
                        }
                        break;
                        case 3: {
                            ui->player2_name->setText(List[1].getUsername().c_str());
                            ui->player3_name->setText(List[2].getUsername().c_str());
                            ui->player5_name->setText(List[0].getUsername().c_str());
                            ui->player6_name->setText(List[4].getUsername().c_str());
                        }
                        break;
                        case 4: {
                            ui->player2_name->setText(List[1].getUsername().c_str());
                            ui->player3_name->setText(List[2].getUsername().c_str());
                            ui->player5_name->setText(List[3].getUsername().c_str());
                            ui->player6_name->setText(List[0].getUsername().c_str());
                        }
                        break;
                        default: {
                            ui->player2_name->setText(List[1].getUsername().c_str());
                            ui->player3_name->setText(List[2].getUsername().c_str());
                            ui->player5_name->setText(List[3].getUsername().c_str());
                            ui->player6_name->setText(List[4].getUsername().c_str());
                        }
                    }
                }
                    break;

             case 4:{
                    ui->player1_role->setVisible(0);
                    ui->player1_name->setVisible(0);
                    ui->player2_role->setVisible(0);
                    ui->player2_name->setVisible(0);
                    ui->player6_role->setVisible(0);
                    ui->player6_name->setVisible(0);
                    ui->player7_role->setVisible(0);
                    ui->player7_name->setVisible(0);
                    switch (game->whoHasScissors()){
                        case 1: {
                            ui->player3_name->setText(List[0].getUsername().c_str());
                            ui->player4_name->setText(List[2].getUsername().c_str());
                            ui->player5_name->setText(List[3].getUsername().c_str());
                        }
                        break;
                        case 2: {
                            ui->player3_name->setText(List[1].getUsername().c_str());
                            ui->player4_name->setText(List[0].getUsername().c_str());
                            ui->player5_name->setText(List[3].getUsername().c_str());
                        }
                        break;
                        case 3: {
                            ui->player3_name->setText(List[1].getUsername().c_str());
                            ui->player4_name->setText(List[2].getUsername().c_str());
                            ui->player5_name->setText(List[0].getUsername().c_str());
                        }
                        break;
                        default: {
                            ui->player3_name->setText(List[1].getUsername().c_str());
                            ui->player4_name->setText(List[2].getUsername().c_str());
                            ui->player5_name->setText(List[3].getUsername().c_str());
                        }
                    }
                }
                    break;
             case 7:{
                    ui->player4_role->setVisible(0);
                    ui->player4_name->setVisible(0);
                    switch (game->whoHasScissors()) {
                        case 5: {
                            ui->player1_name->setText(List[1].getUsername().c_str());
                            ui->player2_name->setText(List[2].getUsername().c_str());
                            ui->player3_name->setText(List[3].getUsername().c_str());
                            ui->player5_name->setText(List[4].getUsername().c_str());
                            ui->player6_name->setText(List[0].getUsername().c_str());
                            ui->player7_name->setText(List[6].getUsername().c_str());
                        }
                        break;
                        case 1: {
                            ui->player1_name->setText(List[0].getUsername().c_str());
                            ui->player2_name->setText(List[2].getUsername().c_str());
                            ui->player3_name->setText(List[3].getUsername().c_str());
                            ui->player5_name->setText(List[4].getUsername().c_str());
                            ui->player6_name->setText(List[5].getUsername().c_str());
                            ui->player7_name->setText(List[6].getUsername().c_str());
                        }
                        break;
                        case 2: {
                            ui->player1_name->setText(List[1].getUsername().c_str());
                            ui->player2_name->setText(List[0].getUsername().c_str());
                            ui->player3_name->setText(List[3].getUsername().c_str());
                            ui->player5_name->setText(List[4].getUsername().c_str());
                            ui->player6_name->setText(List[5].getUsername().c_str());
                            ui->player7_name->setText(List[6].getUsername().c_str());
                        }
                        break;
                        case 3: {
                            ui->player1_name->setText(List[1].getUsername().c_str());
                            ui->player2_name->setText(List[2].getUsername().c_str());
                            ui->player3_name->setText(List[0].getUsername().c_str());
                            ui->player5_name->setText(List[4].getUsername().c_str());
                            ui->player6_name->setText(List[5].getUsername().c_str());ui->player7_name->setText(List[6].getUsername().c_str());
                            ui->player7_name->setText(List[6].getUsername().c_str());
                        }
                        break;
                        case 4: {
                            ui->player1_name->setText(List[1].getUsername().c_str());
                            ui->player2_name->setText(List[2].getUsername().c_str());
                            ui->player3_name->setText(List[3].getUsername().c_str());
                            ui->player5_name->setText(List[0].getUsername().c_str());
                            ui->player6_name->setText(List[5].getUsername().c_str());
                            ui->player7_name->setText(List[6].getUsername().c_str());
                        }
                        break;
                        case 6: {
                            ui->player1_name->setText(List[1].getUsername().c_str());
                            ui->player2_name->setText(List[2].getUsername().c_str());
                            ui->player3_name->setText(List[3].getUsername().c_str());
                            ui->player5_name->setText(List[4].getUsername().c_str());
                            ui->player6_name->setText(List[5].getUsername().c_str());
                            ui->player7_name->setText(List[0].getUsername().c_str());
                        }
                        break;
                        default: {
                            ui->player1_name->setText(List[1].getUsername().c_str());
                            ui->player2_name->setText(List[2].getUsername().c_str());
                            ui->player3_name->setText(List[3].getUsername().c_str());
                            ui->player5_name->setText(List[4].getUsername().c_str());
                            ui->player6_name->setText(List[5].getUsername().c_str());
                            ui->player7_name->setText(List[6].getUsername().c_str());
                        }
                    }
                }
                    break;

            default:switch (game->whoHasScissors()) {
            case 5: {
                ui->player1_name->setText(List[1].getUsername().c_str());
                ui->player2_name->setText(List[2].getUsername().c_str());
                ui->player3_name->setText(List[3].getUsername().c_str());
                ui->player4_name->setText(List[4].getUsername().c_str());
                ui->player5_name->setText(List[0].getUsername().c_str());
                ui->player6_name->setText(List[6].getUsername().c_str());
                ui->player7_name->setText(List[7].getUsername().c_str());
            }
            break;
            case 1: {
                ui->player1_name->setText(List[0].getUsername().c_str());
                ui->player2_name->setText(List[2].getUsername().c_str());
                ui->player3_name->setText(List[3].getUsername().c_str());
                ui->player4_name->setText(List[4].getUsername().c_str());
                ui->player5_name->setText(List[5].getUsername().c_str());
                ui->player6_name->setText(List[6].getUsername().c_str());
                ui->player7_name->setText(List[7].getUsername().c_str());
            }
            break;
            case 2: {
                ui->player1_name->setText(List[1].getUsername().c_str());
                ui->player2_name->setText(List[0].getUsername().c_str());
                ui->player3_name->setText(List[3].getUsername().c_str());
                ui->player4_name->setText(List[4].getUsername().c_str());
                ui->player5_name->setText(List[5].getUsername().c_str());
                ui->player6_name->setText(List[6].getUsername().c_str());
                ui->player7_name->setText(List[7].getUsername().c_str());
            }
            break;
            case 3: {
                ui->player1_name->setText(List[1].getUsername().c_str());
                ui->player2_name->setText(List[2].getUsername().c_str());
                ui->player3_name->setText(List[0].getUsername().c_str());
                ui->player4_name->setText(List[4].getUsername().c_str());
                ui->player5_name->setText(List[5].getUsername().c_str());
                ui->player6_name->setText(List[6].getUsername().c_str());
                ui->player7_name->setText(List[7].getUsername().c_str());
            }
            break;
            case 4: {
                ui->player1_name->setText(List[1].getUsername().c_str());
                ui->player2_name->setText(List[2].getUsername().c_str());
                ui->player3_name->setText(List[3].getUsername().c_str());
                ui->player4_name->setText(List[0].getUsername().c_str());
                ui->player5_name->setText(List[5].getUsername().c_str());
                ui->player6_name->setText(List[6].getUsername().c_str());
                ui->player7_name->setText(List[7].getUsername().c_str());
            }
            break;
            case 6: {
                ui->player1_name->setText(List[1].getUsername().c_str());
                ui->player2_name->setText(List[2].getUsername().c_str());
                ui->player3_name->setText(List[3].getUsername().c_str());
                ui->player4_name->setText(List[4].getUsername().c_str());
                ui->player5_name->setText(List[5].getUsername().c_str());
                ui->player6_name->setText(List[0].getUsername().c_str());
                ui->player7_name->setText(List[7].getUsername().c_str());
            }
            break;
            default: {
                ui->player1_name->setText(List[1].getUsername().c_str());
                ui->player2_name->setText(List[2].getUsername().c_str());
                ui->player3_name->setText(List[3].getUsername().c_str());
                ui->player4_name->setText(List[4].getUsername().c_str());
                ui->player5_name->setText(List[5].getUsername().c_str());
                ui->player6_name->setText(List[6].getUsername().c_str());
                ui->player7_name->setText(List[7].getUsername().c_str());
            }
        }
    }
}

gameplay::gameplay(QWidget *parent, unsigned nbPlayers, Plateau* plate, parameters * paramGP) :
    QDialog(parent),
    paramGP(paramGP),
    ui(new Ui::gameplay)
{
    ui->setupUi(this);
    this->game=plate;
    ui->actual_player_name->setText(this->game->getPlayerByIndex(unsigned(game->whoHasScissors())).getUsername().c_str());

    ui->card1->setVisible(0);
    ui->card2->setVisible(0);
    ui->card3->setVisible(0);
    ui->card4->setVisible(0);
    ui->card5->setVisible(0);
    ui->ExitGame->setVisible(0);

    ui->player1_role->setCheckable(true);
    ui->player2_role->setCheckable(true);
    ui->player3_role->setCheckable(true);
    ui->player4_role->setCheckable(true);
    ui->player5_role->setCheckable(true);
    ui->player6_role->setCheckable(true);
    ui->player7_role->setCheckable(true);
    ui->pause->setCheckable(true);

    unsigned int r = getAleatInt(0,int(nbPlayers)-1);
    game->m_players[r].takeScissors();
    this->picked=0;

    this->round=1;
    this->roundText="Round: ";
    this->roundText+= QString::number(this->round).toStdString();
    this->roundText+="/4";
    ui->rounds->setText(QString::fromUtf8(this->roundText.c_str()));

    this->defusers=0;
    this->defusedText= QString::number(this->defusers).toStdString();
    this->defusedText+="/";
    this->defusedText+= QString::number(this->game->getNbPlayer()).toStdString();
    ui->Defused->setText(QString::fromUtf8(this->defusedText.c_str()));

    this->withScissors=0;
    for(unsigned indice=0; indice<this->game->getNbPlayer(); indice++){
        if(game->whoHasScissors() == int(indice)){
            this->withScissors=indice;
        }
    }
    this->toSwitch=game->getPlayerByIndex(this->withScissors);

    List.push_back(this->toSwitch);
    unsigned indice;
    //initialisation
    for(indice=0; (indice<game->getNbPlayer()) && (game->whoHasScissors() != int(indice)); indice++){
            List.push_back(game->m_players[indice]);
    }
    indice++;
    for(; indice<this->game->getNbPlayer(); indice++){
            List.push_back(this->game->m_players[indice]);
    }

    ui->actual_player_name->setText(List[0].getUsername().c_str());
    switch (this->game->getNbPlayer()) {
            case 6: {
                    ui->player1_role->setVisible(0);
                    ui->player1_name->setVisible(0);
                    ui->player7_role->setVisible(0);
                    ui->player7_name->setVisible(0);
                    switch (game->whoHasScissors()) {
                        case 5: {
                            ui->player2_name->setText(List[1].getUsername().c_str());
                            ui->player3_name->setText(List[2].getUsername().c_str());
                            ui->player4_name->setText(List[3].getUsername().c_str());
                            ui->player5_name->setText(List[4].getUsername().c_str());
                            ui->player6_name->setText(List[0].getUsername().c_str());
                        }
                        break;
                        case 1: {
                            ui->player2_name->setText(List[0].getUsername().c_str());
                            ui->player3_name->setText(List[2].getUsername().c_str());
                            ui->player4_name->setText(List[3].getUsername().c_str());
                            ui->player5_name->setText(List[4].getUsername().c_str());
                            ui->player6_name->setText(List[5].getUsername().c_str());
                        }
                        break;
                        case 2: {
                            ui->player2_name->setText(List[1].getUsername().c_str());
                            ui->player3_name->setText(List[0].getUsername().c_str());
                            ui->player4_name->setText(List[3].getUsername().c_str());
                            ui->player5_name->setText(List[4].getUsername().c_str());
                            ui->player6_name->setText(List[5].getUsername().c_str());
                        }
                        break;
                        case 3: {
                            ui->player2_name->setText(List[1].getUsername().c_str());
                            ui->player3_name->setText(List[2].getUsername().c_str());
                            ui->player4_name->setText(List[0].getUsername().c_str());
                            ui->player5_name->setText(List[4].getUsername().c_str());
                            ui->player6_name->setText(List[5].getUsername().c_str());
                        }
                        break;
                        case 4: {
                            ui->player2_name->setText(List[1].getUsername().c_str());
                            ui->player3_name->setText(List[2].getUsername().c_str());
                            ui->player4_name->setText(List[3].getUsername().c_str());
                            ui->player5_name->setText(List[0].getUsername().c_str());
                            ui->player6_name->setText(List[5].getUsername().c_str());
                        }
                        break;
                        default: {
                            ui->player2_name->setText(List[1].getUsername().c_str());
                            ui->player3_name->setText(List[2].getUsername().c_str());
                            ui->player4_name->setText(List[3].getUsername().c_str());
                            ui->player5_name->setText(List[4].getUsername().c_str());
                            ui->player6_name->setText(List[5].getUsername().c_str());
                        }
                    }
                }
                    break;
            case 5: {
                    ui->player1_role->setVisible(0);
                    ui->player1_name->setVisible(0);
                    ui->player4_role->setVisible(0);
                    ui->player4_name->setVisible(0);
                    ui->player7_role->setVisible(0);
                    ui->player7_name->setVisible(0);
                    switch (game->whoHasScissors()){
                        case 1: {
                            ui->player2_name->setText(List[0].getUsername().c_str());
                            ui->player3_name->setText(List[2].getUsername().c_str());
                            ui->player5_name->setText(List[3].getUsername().c_str());
                            ui->player6_name->setText(List[4].getUsername().c_str());
                        }
                        break;
                        case 2: {
                            ui->player2_name->setText(List[1].getUsername().c_str());
                            ui->player3_name->setText(List[0].getUsername().c_str());
                            ui->player5_name->setText(List[3].getUsername().c_str());
                            ui->player6_name->setText(List[4].getUsername().c_str());
                        }
                        break;
                        case 3: {
                            ui->player2_name->setText(List[1].getUsername().c_str());
                            ui->player3_name->setText(List[2].getUsername().c_str());
                            ui->player5_name->setText(List[0].getUsername().c_str());
                            ui->player6_name->setText(List[4].getUsername().c_str());
                        }
                        break;
                        case 4: {
                            ui->player2_name->setText(List[1].getUsername().c_str());
                            ui->player3_name->setText(List[2].getUsername().c_str());
                            ui->player5_name->setText(List[3].getUsername().c_str());
                            ui->player6_name->setText(List[0].getUsername().c_str());
                        }
                        break;
                        default: {
                            ui->player2_name->setText(List[1].getUsername().c_str());
                            ui->player3_name->setText(List[2].getUsername().c_str());
                            ui->player5_name->setText(List[3].getUsername().c_str());
                            ui->player6_name->setText(List[4].getUsername().c_str());
                        }
                    }
                }
                    break;

             case 4:{
                    ui->player1_role->setVisible(0);
                    ui->player1_name->setVisible(0);
                    ui->player2_role->setVisible(0);
                    ui->player2_name->setVisible(0);
                    ui->player6_role->setVisible(0);
                    ui->player6_name->setVisible(0);
                    ui->player7_role->setVisible(0);
                    ui->player7_name->setVisible(0);
                    switch (game->whoHasScissors()){
                        case 1: {
                            ui->player3_name->setText(List[1].getUsername().c_str());
                            ui->player4_name->setText(List[2].getUsername().c_str());
                            ui->player5_name->setText(List[3].getUsername().c_str());
                        }
                        break;
                        case 2: {
                            ui->player3_name->setText(List[1].getUsername().c_str());
                            ui->player4_name->setText(List[2].getUsername().c_str());
                            ui->player5_name->setText(List[3].getUsername().c_str());
                        }
                        break;
                        case 3: {
                            ui->player3_name->setText(List[1].getUsername().c_str());
                            ui->player4_name->setText(List[2].getUsername().c_str());
                            ui->player5_name->setText(List[3].getUsername().c_str());
                        }
                        break;
                        default: {
                            ui->player3_name->setText(List[1].getUsername().c_str());
                            ui->player4_name->setText(List[2].getUsername().c_str());
                            ui->player5_name->setText(List[3].getUsername().c_str());
                        }
                    }
                }
                    break;
             case 7:{
                    ui->player4_role->setVisible(0);
                    ui->player4_name->setVisible(0);
                    switch (game->whoHasScissors()) {
                        case 5: {
                            ui->player1_name->setText(List[1].getUsername().c_str());
                            ui->player2_name->setText(List[2].getUsername().c_str());
                            ui->player3_name->setText(List[3].getUsername().c_str());
                            ui->player5_name->setText(List[4].getUsername().c_str());
                            ui->player6_name->setText(List[0].getUsername().c_str());
                            ui->player7_name->setText(List[6].getUsername().c_str());
                        }
                        break;
                        case 1: {
                            ui->player1_name->setText(List[0].getUsername().c_str());
                            ui->player2_name->setText(List[2].getUsername().c_str());
                            ui->player3_name->setText(List[3].getUsername().c_str());
                            ui->player5_name->setText(List[4].getUsername().c_str());
                            ui->player6_name->setText(List[5].getUsername().c_str());
                            ui->player7_name->setText(List[6].getUsername().c_str());
                        }
                        break;
                        case 2: {
                            ui->player1_name->setText(List[1].getUsername().c_str());
                            ui->player2_name->setText(List[0].getUsername().c_str());
                            ui->player3_name->setText(List[3].getUsername().c_str());
                            ui->player5_name->setText(List[4].getUsername().c_str());
                            ui->player6_name->setText(List[5].getUsername().c_str());
                            ui->player7_name->setText(List[6].getUsername().c_str());
                        }
                        break;
                        case 3: {
                            ui->player1_name->setText(List[1].getUsername().c_str());
                            ui->player2_name->setText(List[2].getUsername().c_str());
                            ui->player3_name->setText(List[0].getUsername().c_str());
                            ui->player5_name->setText(List[4].getUsername().c_str());
                            ui->player6_name->setText(List[5].getUsername().c_str());
                            ui->player7_name->setText(List[6].getUsername().c_str());
                        }
                        break;
                        case 4: {
                            ui->player1_name->setText(List[1].getUsername().c_str());
                            ui->player2_name->setText(List[2].getUsername().c_str());
                            ui->player3_name->setText(List[3].getUsername().c_str());
                            ui->player5_name->setText(List[0].getUsername().c_str());
                            ui->player6_name->setText(List[5].getUsername().c_str());
                            ui->player7_name->setText(List[6].getUsername().c_str());
                        }
                        break;
                        case 6: {
                            ui->player1_name->setText(List[1].getUsername().c_str());
                            ui->player2_name->setText(List[2].getUsername().c_str());
                            ui->player3_name->setText(List[3].getUsername().c_str());
                            ui->player5_name->setText(List[4].getUsername().c_str());
                            ui->player6_name->setText(List[5].getUsername().c_str());
                            ui->player7_name->setText(List[0].getUsername().c_str());
                        }
                        break;
                        default: {
                            ui->player1_name->setText(List[1].getUsername().c_str());
                            ui->player2_name->setText(List[2].getUsername().c_str());
                            ui->player3_name->setText(List[3].getUsername().c_str());
                            ui->player5_name->setText(List[4].getUsername().c_str());
                            ui->player6_name->setText(List[5].getUsername().c_str());
                            ui->player7_name->setText(List[6].getUsername().c_str());
                        }
                    }
                }
                    break;

            default:switch (game->whoHasScissors()) {
            case 5: {
                ui->player1_name->setText(List[1].getUsername().c_str());
                ui->player2_name->setText(List[2].getUsername().c_str());
                ui->player3_name->setText(List[3].getUsername().c_str());
                ui->player4_name->setText(List[4].getUsername().c_str());
                ui->player5_name->setText(List[0].getUsername().c_str());
                ui->player6_name->setText(List[6].getUsername().c_str());
                ui->player7_name->setText(List[7].getUsername().c_str());
            }
            break;
            case 1: {
                ui->player1_name->setText(List[0].getUsername().c_str());
                ui->player2_name->setText(List[2].getUsername().c_str());
                ui->player3_name->setText(List[3].getUsername().c_str());
                ui->player4_name->setText(List[4].getUsername().c_str());
                ui->player5_name->setText(List[5].getUsername().c_str());
                ui->player6_name->setText(List[6].getUsername().c_str());
                ui->player7_name->setText(List[7].getUsername().c_str());
            }
            break;
            case 2: {
                ui->player1_name->setText(List[1].getUsername().c_str());
                ui->player2_name->setText(List[0].getUsername().c_str());
                ui->player3_name->setText(List[3].getUsername().c_str());
                ui->player4_name->setText(List[4].getUsername().c_str());
                ui->player5_name->setText(List[5].getUsername().c_str());
                ui->player6_name->setText(List[6].getUsername().c_str());
                ui->player7_name->setText(List[7].getUsername().c_str());
            }
            break;
            case 3: {
                ui->player1_name->setText(List[1].getUsername().c_str());
                ui->player2_name->setText(List[2].getUsername().c_str());
                ui->player3_name->setText(List[0].getUsername().c_str());
                ui->player4_name->setText(List[4].getUsername().c_str());
                ui->player5_name->setText(List[5].getUsername().c_str());
                ui->player6_name->setText(List[6].getUsername().c_str());
                ui->player7_name->setText(List[7].getUsername().c_str());
            }
            break;
            case 4: {
                ui->player1_name->setText(List[1].getUsername().c_str());
                ui->player2_name->setText(List[2].getUsername().c_str());
                ui->player3_name->setText(List[3].getUsername().c_str());
                ui->player4_name->setText(List[0].getUsername().c_str());
                ui->player5_name->setText(List[5].getUsername().c_str());
                ui->player6_name->setText(List[6].getUsername().c_str());
                ui->player7_name->setText(List[7].getUsername().c_str());
            }
            break;
            case 6: {
                ui->player1_name->setText(List[1].getUsername().c_str());
                ui->player2_name->setText(List[2].getUsername().c_str());
                ui->player3_name->setText(List[3].getUsername().c_str());
                ui->player4_name->setText(List[4].getUsername().c_str());
                ui->player5_name->setText(List[5].getUsername().c_str());
                ui->player6_name->setText(List[0].getUsername().c_str());
                ui->player7_name->setText(List[7].getUsername().c_str());
            }
            break;
            default: {
                ui->player1_name->setText(List[1].getUsername().c_str());
                ui->player2_name->setText(List[2].getUsername().c_str());
                ui->player3_name->setText(List[3].getUsername().c_str());
                ui->player4_name->setText(List[4].getUsername().c_str());
                ui->player5_name->setText(List[5].getUsername().c_str());
                ui->player6_name->setText(List[6].getUsername().c_str());
                ui->player7_name->setText(List[7].getUsername().c_str());
            }
        }
    }
}

gameplay::~gameplay()
{
    delete ui;
}

void gameplay::switchPlaces( unsigned actual_player , unsigned selected_player){
    Player temp,temp2;
    temp=this->game->m_players[actual_player];
    temp2=this->game->m_players[selected_player];

    //this->game->m_players[actual_player]=this->game->m_players[selected_player];
    //this->game->m_players[selected_player]=temp;


    //temp=this->game->getPlayerByIndex(game->whoHasScissors());
    this->game->changeOwnerOfScissors(actual_player, selected_player);

    switch (this->game->getNbPlayer()) {
        case 6: {
                ui->player1_role->setVisible(0);
                ui->player1_name->setVisible(0);
                ui->player7_role->setVisible(0);
                ui->player7_name->setVisible(0);
                switch(actual_player) {
                    case 5: {
                        ui->player2_name->setText(List[1].getUsername().c_str());
                        ui->player3_name->setText(List[2].getUsername().c_str());
                        ui->player4_name->setText(List[3].getUsername().c_str());
                        ui->player5_name->setText(List[4].getUsername().c_str());
                        ui->player6_name->setText(temp.getUsername().c_str());
                    }
                    break;
                    case 1: {
                        ui->player2_name->setText(temp.getUsername().c_str());
                        ui->player3_name->setText(List[2].getUsername().c_str());
                        ui->player4_name->setText(List[3].getUsername().c_str());
                        ui->player5_name->setText(List[4].getUsername().c_str());
                        ui->player6_name->setText(List[5].getUsername().c_str());
                    }
                    break;
                    case 2: {
                        ui->player2_name->setText(List[1].getUsername().c_str());
                        ui->player3_name->setText(temp.getUsername().c_str());
                        ui->player4_name->setText(List[3].getUsername().c_str());
                        ui->player5_name->setText(List[4].getUsername().c_str());
                        ui->player6_name->setText(List[5].getUsername().c_str());
                    }
                    break;
                    case 3: {
                        ui->player2_name->setText(List[1].getUsername().c_str());
                        ui->player3_name->setText(List[2].getUsername().c_str());
                        ui->player4_name->setText(temp.getUsername().c_str());
                        ui->player5_name->setText(List[4].getUsername().c_str());
                        ui->player6_name->setText(List[5].getUsername().c_str());
                    }
                    break;
                    case 4: {
                        ui->player2_name->setText(List[1].getUsername().c_str());
                        ui->player3_name->setText(List[2].getUsername().c_str());
                        ui->player4_name->setText(List[3].getUsername().c_str());
                        ui->player5_name->setText(temp.getUsername().c_str());
                        ui->player6_name->setText(List[5].getUsername().c_str());
                    }
                    break;
                    default: {
                        ui->player2_name->setText(List[1].getUsername().c_str());
                        ui->player3_name->setText(List[2].getUsername().c_str());
                        ui->player4_name->setText(List[3].getUsername().c_str());
                        ui->player5_name->setText(List[4].getUsername().c_str());
                        ui->player6_name->setText(List[5].getUsername().c_str());
                    }
                }
            }
                break;
        case 5: {
                ui->player1_role->setVisible(0);
                ui->player1_name->setVisible(0);
                ui->player4_role->setVisible(0);
                ui->player4_name->setVisible(0);
                ui->player7_role->setVisible(0);
                ui->player7_name->setVisible(0);
                switch(actual_player){
                    case 1: {
                        ui->player2_name->setText(temp.getUsername().c_str());
                        ui->player3_name->setText(List[2].getUsername().c_str());
                        ui->player5_name->setText(List[3].getUsername().c_str());
                        ui->player6_name->setText(List[4].getUsername().c_str());
                    }
                    break;
                    case 2: {
                        ui->player2_name->setText(List[1].getUsername().c_str());
                        ui->player3_name->setText(temp.getUsername().c_str());
                        ui->player5_name->setText(List[3].getUsername().c_str());
                        ui->player6_name->setText(List[4].getUsername().c_str());
                    }
                    break;
                    case 3: {
                        ui->player2_name->setText(List[1].getUsername().c_str());
                        ui->player3_name->setText(List[2].getUsername().c_str());
                        ui->player5_name->setText(temp.getUsername().c_str());
                        ui->player6_name->setText(List[4].getUsername().c_str());
                    }
                    break;
                    case 4: {
                        ui->player2_name->setText(List[1].getUsername().c_str());
                        ui->player3_name->setText(List[2].getUsername().c_str());
                        ui->player5_name->setText(List[3].getUsername().c_str());
                        ui->player6_name->setText(temp.getUsername().c_str());
                    }
                    break;
                    default: {
                        ui->player2_name->setText(List[1].getUsername().c_str());
                        ui->player3_name->setText(List[2].getUsername().c_str());
                        ui->player5_name->setText(List[3].getUsername().c_str());
                        ui->player6_name->setText(List[4].getUsername().c_str());
                    }
                }
            }
                break;

         case 4:{
                ui->player1_role->setVisible(0);
                ui->player1_name->setVisible(0);
                ui->player2_role->setVisible(0);
                ui->player2_name->setVisible(0);
                ui->player6_role->setVisible(0);
                ui->player6_name->setVisible(0);
                ui->player7_role->setVisible(0);
                ui->player7_name->setVisible(0);
                switch(actual_player){
                    case 1: {
                        ui->player3_name->setText(temp.getUsername().c_str());
                        ui->player4_name->setText(List[2].getUsername().c_str());
                        ui->player5_name->setText(List[3].getUsername().c_str());
                    }
                    break;
                    case 2: {
                        ui->player3_name->setText(List[1].getUsername().c_str());
                        ui->player4_name->setText(temp.getUsername().c_str());
                        ui->player5_name->setText(List[3].getUsername().c_str());
                    }
                    break;
                    case 3: {
                        ui->player3_name->setText(List[1].getUsername().c_str());
                        ui->player4_name->setText(List[2].getUsername().c_str());
                        ui->player5_name->setText(temp.getUsername().c_str());
                    }
                    break;
                    default: {
                        ui->player3_name->setText(List[1].getUsername().c_str());
                        ui->player4_name->setText(List[2].getUsername().c_str());
                        ui->player5_name->setText(List[3].getUsername().c_str());
                    }
                }
                }
                break;
         case 7:{
                ui->player4_role->setVisible(0);
                ui->player4_name->setVisible(0);
                switch(actual_player) {
                    case 5: {
                        ui->player1_name->setText(List[1].getUsername().c_str());
                        ui->player2_name->setText(List[2].getUsername().c_str());
                        ui->player3_name->setText(List[3].getUsername().c_str());
                        ui->player5_name->setText(List[4].getUsername().c_str());
                        ui->player6_name->setText(temp.getUsername().c_str());
                        ui->player7_name->setText(List[6].getUsername().c_str());
                    }
                    break;
                    case 1: {
                        ui->player1_name->setText(temp.getUsername().c_str());
                        ui->player2_name->setText(List[2].getUsername().c_str());
                        ui->player3_name->setText(List[3].getUsername().c_str());
                        ui->player5_name->setText(List[4].getUsername().c_str());
                        ui->player6_name->setText(List[5].getUsername().c_str());
                        ui->player7_name->setText(List[6].getUsername().c_str());
                    }
                    break;
                    case 2: {
                        ui->player1_name->setText(List[1].getUsername().c_str());
                        ui->player2_name->setText(temp.getUsername().c_str());
                        ui->player3_name->setText(List[3].getUsername().c_str());
                        ui->player5_name->setText(List[4].getUsername().c_str());
                        ui->player6_name->setText(List[5].getUsername().c_str());
                        ui->player7_name->setText(List[6].getUsername().c_str());
                    }
                    break;
                    case 3: {
                        ui->player1_name->setText(List[1].getUsername().c_str());
                        ui->player2_name->setText(List[2].getUsername().c_str());
                        ui->player3_name->setText(temp.getUsername().c_str());
                        ui->player5_name->setText(List[4].getUsername().c_str());
                        ui->player6_name->setText(List[5].getUsername().c_str());
                        ui->player7_name->setText(List[6].getUsername().c_str());
                    }
                    break;
                    case 4: {
                        ui->player1_name->setText(List[1].getUsername().c_str());
                        ui->player2_name->setText(List[2].getUsername().c_str());
                        ui->player3_name->setText(List[3].getUsername().c_str());
                        ui->player5_name->setText(temp.getUsername().c_str());
                        ui->player6_name->setText(List[5].getUsername().c_str());
                        ui->player7_name->setText(List[6].getUsername().c_str());
                    }
                    break;
                    case 6: {
                        ui->player1_name->setText(List[1].getUsername().c_str());
                        ui->player2_name->setText(List[2].getUsername().c_str());
                        ui->player3_name->setText(List[3].getUsername().c_str());
                        ui->player5_name->setText(List[4].getUsername().c_str());
                        ui->player6_name->setText(List[5].getUsername().c_str());
                        ui->player7_name->setText(temp.getUsername().c_str());
                    }
                    break;
                    default: {
                        ui->player1_name->setText(List[1].getUsername().c_str());
                        ui->player2_name->setText(List[2].getUsername().c_str());
                        ui->player3_name->setText(List[3].getUsername().c_str());
                        ui->player5_name->setText(List[4].getUsername().c_str());
                        ui->player6_name->setText(List[5].getUsername().c_str());
                        ui->player7_name->setText(List[6].getUsername().c_str());
                    }
                }
            }
                break;

        default:switch(selected_player) {
        case 5: {
            ui->player1_name->setText(List[1].getUsername().c_str());
            ui->player2_name->setText(List[2].getUsername().c_str());
            ui->player3_name->setText(List[3].getUsername().c_str());
            ui->player4_name->setText(List[4].getUsername().c_str());
            ui->player5_name->setText(temp.getUsername().c_str());
            ui->player6_name->setText(List[6].getUsername().c_str());
            ui->player7_name->setText(List[7].getUsername().c_str());
        }
        break;
        case 1: {
            ui->player1_name->setText(List[actual_player].getUsername().c_str());
            ui->player2_name->setText(List[2].getUsername().c_str());
            ui->player3_name->setText(List[3].getUsername().c_str());
            ui->player4_name->setText(List[4].getUsername().c_str());
            ui->player5_name->setText(List[5].getUsername().c_str());
            ui->player6_name->setText(List[6].getUsername().c_str());
            ui->player7_name->setText(List[7].getUsername().c_str());
        }
        break;
        case 2: {
            ui->player1_name->setText(List[1].getUsername().c_str());
            ui->player2_name->setText(List[actual_player].getUsername().c_str());
            ui->player3_name->setText(List[3].getUsername().c_str());
            ui->player4_name->setText(List[4].getUsername().c_str());
            ui->player5_name->setText(List[5].getUsername().c_str());
            ui->player6_name->setText(List[6].getUsername().c_str());
            ui->player7_name->setText(List[7].getUsername().c_str());
        }
        break;
        case 3: {
            ui->player1_name->setText(List[1].getUsername().c_str());
            ui->player2_name->setText(List[2].getUsername().c_str());
            ui->player3_name->setText(List[actual_player].getUsername().c_str());
            ui->player4_name->setText(List[4].getUsername().c_str());
            ui->player5_name->setText(List[5].getUsername().c_str());
            ui->player6_name->setText(List[6].getUsername().c_str());
            ui->player7_name->setText(List[7].getUsername().c_str());
        }
        break;
        case 4: {
            ui->player1_name->setText(List[1].getUsername().c_str());
            ui->player2_name->setText(List[2].getUsername().c_str());
            ui->player3_name->setText(List[3].getUsername().c_str());
            ui->player4_name->setText(List[actual_player].getUsername().c_str());
            ui->player5_name->setText(List[5].getUsername().c_str());
            ui->player6_name->setText(List[6].getUsername().c_str());
            ui->player7_name->setText(List[7].getUsername().c_str());
        }
        break;
        case 6: {
            ui->player1_name->setText(List[1].getUsername().c_str());
            ui->player2_name->setText(List[2].getUsername().c_str());
            ui->player3_name->setText(List[3].getUsername().c_str());
            ui->player4_name->setText(List[4].getUsername().c_str());
            ui->player5_name->setText(List[5].getUsername().c_str());
            ui->player6_name->setText(List[actual_player].getUsername().c_str());
            ui->player7_name->setText(List[7].getUsername().c_str());
        }
        break;
        default: {
        ui->player1_name->setText(List[1].getUsername().c_str());
        ui->player2_name->setText(List[2].getUsername().c_str());
        ui->player3_name->setText(List[3].getUsername().c_str());
        ui->player4_name->setText(List[4].getUsername().c_str());
        ui->player5_name->setText(List[5].getUsername().c_str());
        ui->player6_name->setText(List[6].getUsername().c_str());
        ui->player7_name->setText(List[7].getUsername().c_str());
        }
         }
    }

}

void gameplay::addDefused(){
    this->defusers++;
    if(this->defusers==this->game->getNbPlayer()){
        gameOver_Holmes* HWins=new gameOver_Holmes(this,4,this->paramGP);
        HWins->showFullScreen();
    }

    this->defusedText= QString::number(this->defusers).toStdString();
    this->defusedText+="/";
    this->defusedText+= QString::number(this->game->getNbPlayer()).toStdString();
    ui->Defused->setText(QString::fromUtf8(this->defusedText.c_str()));

}

void gameplay::setNewRound(){
    this->round++;
    this->roundText="Round: ";
    this->roundText+= QString::number(this->round).toStdString();
    this->roundText+="/4";
    ui->rounds->setText(QString::fromUtf8(this->roundText.c_str()));
}

void gameplay::roundEnded(){
    if(this->round==4){
        if(this->defusers<this->game->getNbPlayer()){
            gameOver_Moriarty* MWins = new gameOver_Moriarty(this,this->game->getNbPlayer(),this->paramGP);
            MWins->showFullScreen();
        } else {
            gameOver_Holmes* HWins=new gameOver_Holmes(this,this->game->getNbPlayer(),this->paramGP);
            HWins->showFullScreen();
        }
    }
    this->game->takeCards();
    this->game->shuffle();
    this->game->distribuer();
    this->setNewRound();
    this->picked=0;
    if((this->round!=5) && (this->defusers<this->game->getNbPlayer())){
        watch_cards* newRound=new watch_cards(this, this->game->getNbPlayer(), this->game,this->paramGP);
        newRound->showFullScreen();
    }

}

void gameplay::showCards(){
    if(this->game->m_players[chosenPlayer].getCardByIndex(0)>-1)
        ui->card1->setVisible(1);
    if(this->game->m_players[chosenPlayer].getCardByIndex(1)>-1)
        ui->card2->setVisible(1);
    if(this->game->m_players[chosenPlayer].getCardByIndex(2)>-1)
        ui->card3->setVisible(1);
    if(this->game->m_players[chosenPlayer].getCardByIndex(3)>-1)
        ui->card4->setVisible(1);
    if(this->game->m_players[chosenPlayer].getCardByIndex(4)>-1)
        ui->card5->setVisible(1);
}

void gameplay::hideCards(){
    ui->card1->setVisible(0);
    ui->card2->setVisible(0);
    ui->card3->setVisible(0);
    ui->card4->setVisible(0);
    ui->card5->setVisible(0);
}

void gameplay::on_player1_role_clicked(bool checked)
{
    this->paramGP->soundEffectController->play();
    hideCards();
    switch(this->game->getNbPlayer()){
        case 7: this->chosenPlayer=1;
                break;
        case 8: this->chosenPlayer=1;
                break;
    }

    ui->player2_role->setChecked(false);
    ui->player3_role->setChecked(false);
    ui->player4_role->setChecked(false);
    ui->player5_role->setChecked(false);
    ui->player6_role->setChecked(false);
    ui->player7_role->setChecked(false);
    if(checked==true)
        showCards();
    else
        hideCards();
}

void gameplay::on_player2_role_clicked(bool checked)
{

    hideCards();
    switch(this->game->getNbPlayer()){
        case 5: this->chosenPlayer=1;
                break;
        case 6: this->chosenPlayer=1;
                break;
        case 7: this->chosenPlayer=2;
                break;
        case 8: this->chosenPlayer=2;
                break;
    }

    ui->player1_role->setChecked(false);
    ui->player3_role->setChecked(false);
    ui->player4_role->setChecked(false);
    ui->player5_role->setChecked(false);
    ui->player6_role->setChecked(false);
    ui->player7_role->setChecked(false);
    if(checked==true)
        showCards();
    else
        hideCards();
}

void gameplay::on_player3_role_clicked(bool checked)
{
    hideCards();
    switch(this->game->getNbPlayer()){
        case 4: this->chosenPlayer=1;
                break;
        case 5: this->chosenPlayer=2;
                break;
        case 6: this->chosenPlayer=2;
                break;
        case 7: this->chosenPlayer=3;
                break;
        case 8: this->chosenPlayer=3;
                break;
    }

    ui->player2_role->setChecked(false);
    ui->player1_role->setChecked(false);
    ui->player4_role->setChecked(false);
    ui->player5_role->setChecked(false);
    ui->player6_role->setChecked(false);
    ui->player7_role->setChecked(false);
    if(checked==true)
        showCards();
    else
        hideCards();
}

void gameplay::on_player4_role_clicked(bool checked)
{
    hideCards();
    switch(this->game->getNbPlayer()){
        case 4: this->chosenPlayer=2;
                break;
        case 6: this->chosenPlayer=3;
                break;
        case 8: this->chosenPlayer=4;
                break;
    }

    ui->player2_role->setChecked(false);
    ui->player3_role->setChecked(false);
    ui->player1_role->setChecked(false);
    ui->player5_role->setChecked(false);
    ui->player6_role->setChecked(false);
    ui->player7_role->setChecked(false);
    if(checked==true)
        showCards();
    else
        hideCards();
}

void gameplay::on_player5_role_clicked(bool checked)
{
    hideCards();
    switch(this->game->getNbPlayer()){
        case 4: this->chosenPlayer=3;
                break;
        case 5: this->chosenPlayer=3;
                break;
        case 6: this->chosenPlayer=4;
                break;
        case 7: this->chosenPlayer=4;
                break;
        case 8: this->chosenPlayer=5;
                break;
    }

    ui->player2_role->setChecked(false);
    ui->player3_role->setChecked(false);
    ui->player4_role->setChecked(false);
    ui->player1_role->setChecked(false);
    ui->player6_role->setChecked(false);
    ui->player7_role->setChecked(false);
    if(checked==true)
        showCards();
    else
        hideCards();
}

void gameplay::on_player6_role_clicked(bool checked)
{
    hideCards();
    switch(this->game->getNbPlayer()){
        case 5: this->chosenPlayer=4;
                break;
        case 6: this->chosenPlayer=5;
                break;
        case 7: this->chosenPlayer=5;
                break;
        case 8: this->chosenPlayer=6;
                break;
    }

    ui->player2_role->setChecked(false);
    ui->player3_role->setChecked(false);
    ui->player4_role->setChecked(false);
    ui->player5_role->setChecked(false);
    ui->player1_role->setChecked(false);
    ui->player7_role->setChecked(false);
    if(checked==true)
        showCards();
    else
        hideCards();
}

void gameplay::on_player7_role_clicked(bool checked)
{
    hideCards();
    switch(this->game->getNbPlayer()){
        case 7: this->chosenPlayer=6;
                break;
        case 8: this->chosenPlayer=7;
                break;
    }
    ui->player2_role->setChecked(false);
    ui->player3_role->setChecked(false);
    ui->player4_role->setChecked(false);
    ui->player5_role->setChecked(false);
    ui->player6_role->setChecked(false);
    ui->player1_role->setChecked(false);
    if(checked==true)
        showCards();
    else
        hideCards();
}

void gameplay::on_pause_clicked(bool checked)
{
    hideCards();
    if(checked==true){
        ui->player1_role->setCheckable(false);
        ui->player2_role->setCheckable(false);
        ui->player3_role->setCheckable(false);
        ui->player4_role->setCheckable(false);
        ui->player5_role->setCheckable(false);
        ui->player6_role->setCheckable(false);
        ui->player7_role->setCheckable(false);
        ui->ExitGame->setVisible(1);
    } else {
        ui->player1_role->setCheckable(true);
        ui->player2_role->setCheckable(true);
        ui->player3_role->setCheckable(true);
        ui->player4_role->setCheckable(true);
        ui->player5_role->setCheckable(true);
        ui->player6_role->setCheckable(true);
        ui->player7_role->setCheckable(true);
        ui->ExitGame->setVisible(0);
    }

}

void gameplay::on_ExitGame_clicked(){

    hide();
}

void gameplay::cardStatus(unsigned index, unsigned chosenPlayer){
    std::cout << "CARD SELECTED: " << List[chosenPlayer].getCardByIndex(index) << std::endl;
    if(List[chosenPlayer].getCardByIndex(index)!=-1){
        hideCards();
        this->picked++;
        if(game->m_cards[unsigned(this->game->getPlayerByIndex(chosenPlayer).getCardByIndex(index))].getType()== 0) {
            gameOver_Moriarty* MWins=new gameOver_Moriarty(this,this->game->getNbPlayer(),this->paramGP);
            MWins->showFullScreen();
        } else if (game->m_cards[unsigned(List[chosenPlayer].getCardByIndex(index))].getType()==1){
            this->addDefused();
        }
        if(chosenPlayer==game->getNbPlayer()-1){
            ui->actual_player_name->setText(this->game->getPlayerByIndex(chosenPlayer).getUsername().c_str());

        } else {
            ui->actual_player_name->setText(this->game->getPlayerByIndex(chosenPlayer-1).getUsername().c_str());
        }

        this->game->RemoveCard(chosenPlayer, unsigned(index));
        if(this->picked==this->game->getNbPlayer()){
            this->roundEnded();
        }
        this->switchPlaces(chosenPlayer,this->withScissors);
    }
}

void gameplay::on_card1_clicked()
{
    this->cardStatus(0, chosenPlayer);
}

void gameplay::on_card2_clicked()
{
    this->cardStatus(1, chosenPlayer);
}

void gameplay::on_card3_clicked()
{
    this->cardStatus(2, chosenPlayer);
}

void gameplay::on_card4_clicked()
{
    this->cardStatus(3, chosenPlayer);
}

void gameplay::on_card5_clicked()
{
    this->cardStatus(4, chosenPlayer);
}
