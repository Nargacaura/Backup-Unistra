#include "mainwindow.h"
#include "gamemode.h" //Uncomment it to add slots, then comment it again before building!
#include "ui_gamemode.h"

gamemode::gamemode(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::gamemode)
{
    ui->setupUi(this);

}
gamemode::gamemode(QWidget *parent,parameters * param) :
    QDialog(parent),
    ui(new Ui::gamemode),
    paramG(param)
{
    ui->setupUi(this);

}


gamemode::~gamemode()
{
    delete ui;
}

void gamemode::on_Return_to_menu_clicked()
{
    this->paramG->buttonSound(CLICK);
    hide();
}

void gamemode::on_radio_4_5_clicked()
{
    player_names* player_names_pointer=new player_names(this, 5,this->paramG);
    player_names_pointer->showFullScreen();
    this->paramG->buttonSound(CLICK);
}

void gamemode::on_radio_6_clicked()
{
    player_names* player_names_pointer=new player_names(this, 6,this->paramG);
    player_names_pointer->showFullScreen();
    this->paramG->buttonSound(CLICK);
}

void gamemode::on_radio_7_8_clicked()
{
    player_names* player_names_pointer=new player_names(this, 8,this->paramG);
    player_names_pointer->showFullScreen();
    this->paramG->buttonSound(CLICK);
}
