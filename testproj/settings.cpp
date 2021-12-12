
#include "mainwindow.h"
#include "settings.h" //Uncomment it to add slots, then comment it again before building!
#include "ui_settings.h"


settings::settings(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::settings)
{
    ui->setupUi(this);

}

settings::settings(QWidget * parent, parameters * param) :
    QDialog(parent),
    ui(new Ui::settings),
    param(param)
{
    ui->setupUi(this);

    //Valeurs par défaut
    this->param->runSetting();

    ui->Brightness_s->setValue(this->param->getBrightness());
    ui->Sound_s->setValue(this->param->getSound());
    ui->SFX->setValue(this->param->getSoundEffect());
    ui->checkBox->setChecked(this->param->getSoundStat());
    if (this->param->getLanguage() == 1)
        ui->Language_c->setCurrentText("English");
    else if (this->param->getLanguage() == 2)
        ui->Language_c->setCurrentText("Français");

}



settings::~settings()
{
    delete ui;
}

void settings::on_Return_to_menu_clicked()
{
    this->param->buttonSound(CLICK);
    this->param->saveSetting();
    hide();
}

void settings::on_Reset_to_default_clicked()
{
    this->param->buttonSound(CLICK);
    this->param->setDefaultValue();
    ui->Brightness_s->setValue(this->param->getBrightness());
    ui->Sound_s->setValue(this->param->getSound());
    ui->SFX->setValue(this->param->getSoundEffect());
    ui->checkBox->setChecked(this->param->getSoundStat());
    if (this->param->getLanguage() == 1)
        ui->Language_c->setCurrentText("English");
    else if (this->param->getLanguage() == 2)
        ui->Language_c->setCurrentText("Français");
    //this->saveSetting();
}

void settings::on_Brightness_s_valueChanged(int value)
{
    this->param->setBrightness(value);
    //this->saveSetting();
}

void settings::on_Sound_s_valueChanged(int value)
{
    this->param->setSound(value);
    this->param->soundController->setVolume(value);
    //this->saveSetting();

}

void settings::on_Language_c_currentTextChanged(const QString &arg1)
{
    if (arg1 == "English")
        this->param->setLanguage(1);
    else if (arg1 == "Français")
        this->param->setLanguage(2);

    //this->saveSetting();
}

void settings::on_Sound_s_rangeChanged(int min, int max)
{
    //this->soundController->soundController->setVolume(this->getSound());
    (void) min;
    (void) max;
}

void settings::on_Sound_s_sliderReleased()
{
    //this->param->buttonSound(CLICK);
}

void settings::on_checkBox_released()
{
    //
}

void settings::on_SFX_valueChanged(int value)
{
    this->param->setSoundEffect(value);
    this->param->soundEffectController->setVolume(value);
}

void settings::on_checkBox_clicked(bool checked)
{
    this->param->soundController->setMuted(checked);
    this->param->soundEffectController->setMuted(checked);
    if (checked)
    {
        this->param->soundEffectController->pause();
        this->param->soundController->pause();
    }
    else {
        this->param->soundController->play();
        this->param->soundEffectController->play();
        //this->param->playSound(GENTIL);

    }
    this->param->setSoundStat(checked);

}

void settings::on_SFX_sliderReleased()
{
    this->param->buttonSound(CLICK);
}
