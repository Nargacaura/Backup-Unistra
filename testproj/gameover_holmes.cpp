#include "mainwindow.h"
#include "gameover_holmes.h" //debug
#include "ui_gameover_holmes.h"
#include "gamemode.h"

gameOver_Holmes::gameOver_Holmes(QWidget *parent,unsigned int nb_player) :
    QDialog(parent),
    ui(new Ui::gameOver_Holmes)
{
    ui->setupUi(this);
    std::cout <<"le nombre de player à replay: "<< nb_player;
    this->new_nb_player=nb_player;
}

gameOver_Holmes::gameOver_Holmes(QWidget *parent,unsigned int nb_player, parameters * paramH) :
    QDialog(parent),
    ui(new Ui::gameOver_Holmes),
    paramH(paramH)
{
    ui->setupUi(this);
    std::cout <<"le nombre de player à replay: "<< nb_player;
    this->new_nb_player=nb_player;
}


gameOver_Holmes::~gameOver_Holmes()
{
    delete ui;
}

void gameOver_Holmes::on_Return_to_menu_clicked()
{
    this->paramH->buttonSound(CLICK);
    hide();
    MainWindow* mainpointer=new MainWindow(this);
    mainpointer->showFullScreen();
}

void gameOver_Holmes::on_Retry_clicked()
{

    player_names * player_names_pointer;
   //à faire
   if(new_nb_player<6){
       player_names_pointer=new player_names(this,5,this->paramH);
   }
   else if(new_nb_player == 6){
       player_names_pointer=new player_names(this,6,this->paramH);
   }
   else{
       player_names_pointer=new player_names(this,8,this->paramH);
   }


   player_names_pointer->showFullScreen();
   this->paramH->soundEffectController->play();

   this->close();
}
