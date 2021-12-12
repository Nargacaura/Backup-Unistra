#include "mainwindow.h"

#include <QApplication>

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    a.setOverrideCursor(QCursor(QPixmap(":/resources/Cards/WireCutter.png")));
    MainWindow w;

    w.showFullScreen();

    return a.exec();
}
