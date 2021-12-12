#ifndef RULES_H
#define RULES_H
#include "parameters.h"

#include <QDialog>

namespace Ui {
class rules;
}

class rules : public QDialog
{
    Q_OBJECT

public:
    explicit rules(QWidget *parent = nullptr);
    ~rules();
    rules(QWidget *parent = nullptr,parameters * param = nullptr);

private slots:
    void on_Return_to_menu_clicked();

private:
    Ui::rules *ui;
    parameters * paramR;
};

#endif // RULES_H
