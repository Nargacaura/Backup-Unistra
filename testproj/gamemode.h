#ifndef GAMEMODE_H
#define GAMEMODE_H

#include <QDialog>
#include "player_names.h" //pointer vers la page de nomination de joueurs.
#include "base.h"
#include "parameters.h"

namespace Ui {
class gamemode;
}

class gamemode : public QDialog
{
    Q_OBJECT

public:
    explicit gamemode(QWidget *parent = nullptr);
    ~gamemode();
    gamemode(QWidget *parent = nullptr, parameters * param = nullptr);

private slots:
    void on_Return_to_menu_clicked();

    void on_radio_4_5_clicked();

    void on_radio_6_clicked();

    void on_radio_7_8_clicked();

private:
    Ui::gamemode * ui;
    player_names* player_names_pointer; //pointeur vers le player_names.
    parameters * paramG;
};

#endif // GAMEMODE_H
