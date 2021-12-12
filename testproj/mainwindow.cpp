#include "mainwindow.h"


MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent) ,
    ui(new Ui::MainWindow)
{
    this->param = new parameters();
    this->param->runSetting();
    this->param->initSoundController(param->getSound(), param->getSoundStat());
    this->param->initSoundEffectController(param->getSound(), param->getSoundStat());
    this->param->playSound(GENTIL);
    ui->setupUi(this);
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::on_Rules_b_clicked()
{
    this->param->buttonSound(CLICK);
    //cache la mainwindow
    rules* rulepointer = new rules(this,this->param); //ouvre la classe rule dans rules.h
    rulepointer->showFullScreen(); //affiche la fenetre de rule
}

void MainWindow::on_Settings_b_clicked()
{
    this->param->buttonSound(CLICK);
    //ouvre la classe rule dans settings.h
    settings* settingspointer = new settings(this,this->param);
    settingspointer->showFullScreen(); //affiche la fenetre de settings
}

void MainWindow::on_Exit_clicked(){
    /* quitte le jeu. Littéralement. Utile si vous n'avez pas de boutons de gestion de la fenêtre
     *  ou si une WindowRule (dont la création est possible au moins sur KDE)
     * les cachant est appliquée*/
    exit(0);
}

void MainWindow::on_Start_b_clicked()
{
    this->param->buttonSound(CLICK);
    gamemode* gamepointer = new gamemode(this, this->param);
    gamepointer->showFullScreen(); //affiche la fenetre de settings
}
