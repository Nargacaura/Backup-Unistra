#ifndef MAINWINDOW_H
#define MAINWINDOW_H
#include <QMainWindow>
//Include du reste du jeu, vu que tout est centré sur ce .h
#include "ui_mainwindow.h"
#include <QDebug> //pour tester les boutons avec des phrases
#include <QString>
#include <QDir>
#include <QMessageBox>
#include "rules.h"
#include "settings.h"
#include "gamemode.h"
#include "gameover_holmes.h"
#include "gameover_moriarty.h"
#include <stdnoreturn.h>


QT_BEGIN_NAMESPACE
namespace Ui { class MainWindow; }
QT_END_NAMESPACE

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr);
    MainWindow* MainWindowpointer;
    ~MainWindow();
    parameters * param;

private slots:
    void on_Rules_b_clicked();

    void on_Settings_b_clicked();

    void on_Exit_clicked();

    void on_Start_b_clicked();

private:
    Ui::MainWindow *ui;
    rules *rulepointer; //pointeur de rules
    settings *settingspointer; //pointeur de settings
    gamemode* gamepointer; //pointeur du mode de jeu
    gameOver_Holmes* Holmes;
    gameOver_Moriarty* Moriarty;
};
#endif // MAINWINDOW_H
