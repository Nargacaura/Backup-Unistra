#ifndef WATCH_CARDS_H
#define WATCH_CARDS_H

#include <QDialog>
#include "plateau.h"
#include "baseui.h"
#include "parameters.h"

namespace Ui {
class watch_cards;
}

class watch_cards : public QDialog
{
    Q_OBJECT

public:
    explicit watch_cards(QWidget *parent = nullptr, unsigned nbPlayer=0, Plateau* plate=nullptr);
    watch_cards(QWidget *parent = nullptr, unsigned nbPlayer=0, Plateau* plate=nullptr, parameters * paramWC = nullptr);
    ~watch_cards();
    unsigned MaxPlayers;
    unsigned current_player;
    Plateau* cartes_joueurs;
    int role_variable_sherlock; // variable pour afficher les perso de Sherlock
    int role_variable_Moriarty; //variable pour afficher les perso de Moriarty
    parameters * paramWC;
private slots:
    void on_ConfirmPlayer_clicked();
    void on_Nextplayer_clicked();
    void blufftime();
    void on_StartGame_clicked();

private:
    Ui::watch_cards *ui;
};

#endif // WATCH_CARDS_H
