#ifndef GAMEOVER_HOLMES_H
#define GAMEOVER_HOLMES_H
#include "parameters.h"
#include <QDialog>
namespace Ui {
class gameOver_Holmes;
}

class gameOver_Holmes : public QDialog
{
    Q_OBJECT

    public:
        explicit gameOver_Holmes(QWidget *parent = nullptr,unsigned int nb_player=4);
        gameOver_Holmes(QWidget *parent = nullptr,unsigned int nb_player = 4, parameters * paramH = nullptr);
        ~gameOver_Holmes();
        unsigned int new_nb_player;
    private slots:
        void on_Return_to_menu_clicked();

        void on_Retry_clicked();

    private:
        Ui::gameOver_Holmes *ui;
        parameters * paramH;
};

#endif // GAMEOVER_HOLMES_H
