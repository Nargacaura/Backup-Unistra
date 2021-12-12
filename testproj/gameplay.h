#ifndef GAMEPLAY_H
#define GAMEPLAY_H

#include <QDialog>
#include "plateau.h"
#include "baseui.h"
#include "watch_cards.h"

namespace Ui {
class gameplay;
}

class gameplay : public QDialog
{
    Q_OBJECT

public:
    explicit gameplay(QWidget *parent = nullptr, unsigned nbPlayer=0, Plateau* plate=nullptr);
    gameplay(QWidget *parent = nullptr, unsigned nbPlayer=0, Plateau* plate=nullptr, parameters * paramGP = nullptr);
    ~gameplay();
    Plateau* game;
    parameters * paramGP;
private slots:
    void showCards();
    void hideCards();
    void roundEnded();
    void cardStatus(unsigned index, unsigned chosenPlayer);

    void on_player1_role_clicked(bool checked);
    void on_player2_role_clicked(bool checked);
    void on_player3_role_clicked(bool checked);
    void on_player4_role_clicked(bool checked);
    void on_player5_role_clicked(bool checked);
    void on_player6_role_clicked(bool checked);
    void on_player7_role_clicked(bool checked);
    void on_pause_clicked(bool checked);
    void on_ExitGame_clicked();

    void on_card1_clicked();
    void on_card2_clicked();
    void on_card3_clicked();
    void on_card4_clicked();
    void on_card5_clicked();

    void setNewRound();
    void addDefused();
    void switchPlaces(unsigned actual_player,unsigned selected_player);

private:
    Ui::gameplay *ui;
    unsigned picked;
    unsigned defusers;
    unsigned chosenPlayer;
    unsigned round;
    std::string roundText;
    unsigned withScissors;
    std::string defusedText;
    Player toSwitch;
    std::vector<Player> List;
};

#endif
