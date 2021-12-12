#ifndef BASEUI_H
#define BASEUI_H

#include <QMediaPlayer>
#include <dirent.h>
#include <fstream>
#include <iostream>
#include <unistd.h>
#include <string.h>
#include <QDir>

#define ROOT QDir::currentPath().toStdString();
#define DIRSOUND "../testproj/resources/Misc/sounds/"
#define CLICK "Click.wav"
#define SHIT "shit.wav"
#define BGSOUND1 "bgsoung1.wav"
#define BGSOUND "bgsoung_intro.wav"
#define BYE "maybe-next-time-huh.wav"
#define WHAT_YOU_ARE_DOING "what-are-you-doing.wav"
#define GENTIL "gentle-thoughts-1.mp3"
#define WHAT "what-1.wav"
#define YES "yes-1.wav"
#define NICEWORK "nice-work.wav"
#define SOUND 50
#define BRIGHTNESS 50
#define LANGUAGE 1
#define PATH 1024
class Baseui
{
    public:
        Baseui();
        void playSound(std::string soundPath);
        QMediaPlayer * soundController;
        QMediaPlayer * soundEffectController;
        void initSoundController(int volume, bool mute);
        void initSoundEffectController(int volume, bool mute);
        std::string getPath();
        void buttonSound(std::string tempRoot);
    private:
        std::string tempRoot = {0};
};

#endif // BASEUI_H
