#include "rules.h" //Uncomment it to add slots, then comment it again before building!
#include "ui_rules.h"
//ici les fonctionsdes

rules::rules(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::rules)
{
    ui->setupUi(this);
}

rules::rules(QWidget *parent,parameters * param) :
    QDialog(parent),
    ui(new Ui::rules),
    paramR(param)
{
    ui->setupUi(this);
}

rules::~rules()
{
    delete ui;
}

void rules::on_Return_to_menu_clicked()
{
    this->paramR->buttonSound(CLICK);
    hide();
}


