#ifndef PLAYER_NAMES_H
#define PLAYER_NAMES_H
#include <QDialog>
#include "ui_player_names.h"
#include "watch_cards.h"
#include "gameplay.h"
#include "parameters.h"

namespace Ui {
class player_names;
}

class player_names : public QDialog
{
    Q_OBJECT

    public:
        explicit player_names(QWidget *parent = nullptr, unsigned MaxPlayers=0);
        player_names(QWidget *parent = nullptr, unsigned MaxPlayers=0, parameters * paramP = nullptr);
        ~player_names();
        unsigned MaxPlayers;

    private slots:
        void on_previous_clicked();


        void on_cut_wires_button_clicked();

    private:
        Ui::player_names *ui;
        parameters * paramPN;

};

#endif // PLAYER_NAMES_H
