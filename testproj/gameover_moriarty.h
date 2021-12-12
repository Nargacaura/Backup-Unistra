#ifndef GAMEOVER_MORIARTY_H
#define GAMEOVER_MORIARTY_H

#include <QDialog>
#include "parameters.h"

namespace Ui {
class gameOver_Moriarty;
}

class gameOver_Moriarty : public QDialog
{
    Q_OBJECT

public:
    explicit gameOver_Moriarty(QWidget *parent = nullptr,unsigned int nb_player=4);
    gameOver_Moriarty(QWidget *parent = nullptr,unsigned int nb_player=4, parameters * paramG = nullptr);
    ~gameOver_Moriarty();
    int new_nb_player;
private slots:
    void on_Return_to_menu_clicked();

    void on_Retry_clicked();

private:
    Ui::gameOver_Moriarty *ui;
    parameters * paramG;
};

#endif // GAMEOVER_MORIARTY_H
