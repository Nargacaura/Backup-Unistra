#include "mainwindow.h"
//#include "gameover_moriarty.h"
#include "plateau.h"
#include "ui_gameover_moriarty.h"

gameOver_Moriarty::gameOver_Moriarty(QWidget *parent,unsigned int nb_player) :
    QDialog(parent),
    ui(new Ui::gameOver_Moriarty)
{
    ui->setupUi(this);
    std::cout <<"le nombre de player à replay: "<< nb_player;
    this->new_nb_player = int(nb_player);

}

gameOver_Moriarty::gameOver_Moriarty(QWidget *parent,unsigned int nb_player, parameters * paramGM) :
    QDialog(parent),
    ui(new Ui::gameOver_Moriarty),
    paramG(paramGM)
{
    ui->setupUi(this);
    std::cout <<"le nombre de player à replay: "<< nb_player;
    this->new_nb_player = int(nb_player);

}

gameOver_Moriarty::~gameOver_Moriarty()
{
    delete ui;
}

void gameOver_Moriarty::on_Return_to_menu_clicked()
{
    this->paramG->buttonSound(CLICK);
    MainWindow* mainpointer=new MainWindow(this);
    mainpointer->showFullScreen();
    this->close();
}

void gameOver_Moriarty::on_Retry_clicked()
{
     player_names* player_names_pointer;
    //à faire
    if(new_nb_player<6){
        player_names_pointer=new player_names(this,5,this->paramG);
    }
    else if(new_nb_player == 6){
        player_names_pointer=new player_names(this,6,this->paramG);
    }
    else{
        player_names_pointer=new player_names(this,8,this->paramG);
    }


    player_names_pointer->showFullScreen();
    this->paramG->buttonSound(CLICK);

    this->close();

}
