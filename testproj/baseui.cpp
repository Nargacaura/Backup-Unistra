#include "baseui.h"

Baseui::Baseui(){
    this->soundController = new QMediaPlayer;
    this->soundEffectController = new QMediaPlayer;
    //this->path = QDir::currentPath().toStdString();
    this->tempRoot = ROOT;
    this->tempRoot += "/";
    this->tempRoot += DIRSOUND;

}

void Baseui::playSound(std::string  soundPath) {
    std::string path = this->tempRoot + soundPath;
    this->soundController->setMedia(QUrl::fromLocalFile(QString::fromStdString(path)));
    if(!this->soundController->isMuted())
    {
       this->soundController->play();
    }
    else {
        this->soundController->play();
        this->soundController->pause();
    }
}

std::string Baseui::getPath() {
    return this->tempRoot;
}

 void Baseui::buttonSound(std::string soundPath) {

     if(!this->soundEffectController->isMuted())
     {
         std::string path = this->tempRoot + soundPath;
         this->soundEffectController->setMedia(QUrl::fromLocalFile(QString::fromStdString(path)));
         this->soundEffectController->play();
     }
 }

 void Baseui::initSoundController(int volume, bool mute)
 {
     this->soundController->setVolume(volume);
     this->soundController->setMuted(mute);
 }

 void Baseui::initSoundEffectController(int volume, bool mute)
 {
     this->soundEffectController->setVolume(volume);
     this->soundEffectController->setMuted(mute);
 }
