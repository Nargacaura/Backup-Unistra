#ifndef SETTINGS_H
#define SETTINGS_H
#include <QDialog>
#include "parameters.h"

namespace Ui {
    class settings;
}

class settings : public QDialog
{
    Q_OBJECT

public:

    //Constructors
    explicit settings(QWidget *parent = nullptr);
    ~settings();
    settings(QWidget *parent = nullptr, parameters * param = nullptr);

private slots:

    void on_Return_to_menu_clicked();

    void on_Reset_to_default_clicked();

    void on_Brightness_s_valueChanged(int value);

    void on_Sound_s_valueChanged(int value);

    void on_Language_c_currentTextChanged(const QString &arg1);

    void on_Sound_s_rangeChanged(int min, int max);

    void on_Sound_s_sliderReleased();

    void on_checkBox_released();

    void on_SFX_valueChanged(int value);

    void on_checkBox_clicked(bool checked);

    void on_SFX_sliderReleased();

private:
    Ui::settings *ui;
    parameters * param;
};

#endif // SETTINGS_H
