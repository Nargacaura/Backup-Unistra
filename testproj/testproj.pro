QT       += core gui
QT       += multimedia

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

CONFIG += c++11

# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
    gamemode.cpp \
    gameover_holmes.cpp \
    gameover_moriarty.cpp \
    main.cpp \
    mainwindow.cpp \
    card.cpp \
    player_names.cpp \
    rules.cpp \
    settings.cpp \
    player.cpp \
    plateau.cpp \
    base.cpp \
    gameplay.cpp \
    watch_cards.cpp \
    baseui.cpp \
    parameters.cpp

HEADERS += \
    gamemode.h \
    gameover_holmes.h \
    gameover_moriarty.h \
    mainwindow.h \
    base.h \
    card.h \
    plateau.h \
    player_names.h \
    rules.h \
    player.h \
    settings.h \
    gameplay.h \
    watch_cards.h \
    baseui.h \
    parameters.h

FORMS += \
    gamemode.ui \
    gameover_holmes.ui \
    gameover_moriarty.ui \
    mainwindow.ui \
    player_names.ui \
    rules.ui \
    settings.ui \
    gameplay.ui \
    watch_cards.ui

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

RESOURCES += \
    Buttons.qrc \
    Cards.qrc \
    GameOver.qrc \
    Misc.qrc

DISTFILES += \
    ../images/1845 Jan 4 005.png
