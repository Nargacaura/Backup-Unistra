#include "player_names.h"



player_names::player_names(QWidget *parent, unsigned Max) :
    QDialog(parent),
    ui(new Ui::player_names)
{
    ui->setupUi(this);
    this->MaxPlayers = Max;
    switch (Max) {
            case 6: ui->p7->setVisible(0);
                    ui->p8pseudo->setVisible(0);
                    ui->p8->setVisible(0);
                    ui->p7pseudo->setVisible(0);
                    ui->p5pseudo->setPlaceholderText("(Mandatory)");
                    break;
            case 5: ui->p6->setVisible(0);
                    ui->p7->setVisible(0);
                    ui->p8->setVisible(0);
                    ui->p6pseudo->setVisible(0);
                    ui->p7pseudo->setVisible(0);
                    ui->p8pseudo->setVisible(0);
                    break;
            default: ui->p5pseudo->setPlaceholderText("(Mandatory)");
        }
}

player_names::player_names(QWidget *parent, unsigned Max, parameters * paramP ) :
    QDialog(parent),
    ui(new Ui::player_names),
    paramPN(paramP)
{
    ui->setupUi(this);
    this->MaxPlayers = Max;
    switch (Max) {
            case 6: ui->p7->setVisible(0);
                    ui->p8pseudo->setVisible(0);
                    ui->p8->setVisible(0);
                    ui->p7pseudo->setVisible(0);
                    ui->p5pseudo->setPlaceholderText("(Mandatory)");
                    break;
            case 5: ui->p6->setVisible(0);
                    ui->p7->setVisible(0);
                    ui->p8->setVisible(0);
                    ui->p6pseudo->setVisible(0);
                    ui->p7pseudo->setVisible(0);
                    ui->p8pseudo->setVisible(0);
                    break;
            default: ui->p5pseudo->setPlaceholderText("(Mandatory)");
        }
}


player_names::~player_names()
{
    delete ui;
}

void player_names::on_previous_clicked()
{
    this->paramPN->buttonSound(CLICK);
    hide();
}

void player_names::on_cut_wires_button_clicked()
{
     this->paramPN->buttonSound(CLICK);



    unsigned n=0;
    if(!ui->p1pseudo->text().isEmpty()){

        n++;
    }
    if(!ui->p2pseudo->text().isEmpty()){

        n++;
    }

    if(!ui->p3pseudo->text().isEmpty()){

        n++;
    }
    if(!ui->p4pseudo->text().isEmpty()){

        n++;
    }
    if(!ui->p5pseudo->text().isEmpty()){

        n++;
    }
    if(!ui->p6pseudo->text().isEmpty()){

        n++;
    }
    if(!ui->p7pseudo->text().isEmpty()){

        n++;
    }
    if(!ui->p8pseudo->text().isEmpty()){

        n++;
    }
    if(n<this->MaxPlayers-1 || (this->MaxPlayers==6 && n<this->MaxPlayers)){
        ui->Warning->setText("All required players haven't registered yet...");
        this->paramPN->buttonSound(WHAT);

    } else {
        this->paramPN->buttonSound(CLICK);
        Plateau* plateau_pointer= new Plateau(n);
        //plateau_pointer->setNbPlayer(n);
        plateau_pointer->InitialisationDeck();
        plateau_pointer->setRoles();

        plateau_pointer->m_players[0].setUsername(ui->p1pseudo->text().toStdString());
        plateau_pointer->m_players[1].setUsername(ui->p2pseudo->text().toStdString());
        plateau_pointer->m_players[2].setUsername(ui->p3pseudo->text().toStdString());
        plateau_pointer->m_players[3].setUsername(ui->p4pseudo->text().toStdString());


        switch(n){
            case 8: plateau_pointer->m_players[7].setUsername(ui->p8pseudo->text().toStdString());
                    [[clang::fallthrough]];
            case 7: plateau_pointer->m_players[6].setUsername(ui->p7pseudo->text().toStdString());
                    [[clang::fallthrough]];
            case 6: plateau_pointer->m_players[5].setUsername(ui->p6pseudo->text().toStdString());
                    [[clang::fallthrough]];
            case 5: plateau_pointer->m_players[4].setUsername(ui->p5pseudo->text().toStdString());
                    [[clang::fallthrough]];
            default:;
        }


        if(plateau_pointer->shouldShuffle()) {
            plateau_pointer->takeCards();
            plateau_pointer->shuffle();
            plateau_pointer->distribuer();
            //actualisation de l'écran
        }

            gameplay* game = new gameplay(this, n, plateau_pointer,this->paramPN);
            game->showFullScreen();
            watch_cards* debug_pointer= new watch_cards(this, n, plateau_pointer,this->paramPN);
            debug_pointer->showFullScreen();

    }

}
