#include "parameters.h"

parameters::parameters():
    Baseui ()
{
    //runSetting();

}

parameters::parameters(int sound, int soundEffect,int brightness, int language, bool stat):
    Baseui ()
{
    this->sound = sound;
    this->soundEffects  = soundEffect;
    this->brightness    = brightness;
    this->language      = language;
    this->soundStat     = stat;
}


void parameters::setSound(int sound) {
    this->sound = sound;
}

void parameters::setSoundEffect(int soundEffect) {
    this->soundEffects = soundEffect;
}

void parameters::setSoundStat(bool stat) {
    this->soundStat = stat;
}

void parameters::setBrightness(int brightness) {
    this->brightness = brightness;
}

void parameters::setLanguage(int language) {
    this->language = language;
}

int parameters::getSound() {
    return this->sound;
}

bool parameters::getSoundStat() {
    return  this->soundStat;
}

int parameters::getSoundEffect() {
    return this->soundEffects;
}

int parameters::getBrightness() {
    return  this->brightness;
}

int parameters::getLanguage() {
    return this->language;
}

void parameters::setDefaultValue() {

    this->sound         = SOUND;
    this->soundEffects  = 50;
    this->soundStat     = false;
    this->brightness    = BRIGHTNESS;
    this->language      = LANGUAGE;

    this->soundController->setMuted(false);
    this->soundEffectController->setMuted(false);

    if (!this->soundController->isMuted())
         this->soundController->play();

    if (!this->soundEffectController->isMuted())
         this->soundEffectController->play();

    this->saveSetting();
}

void parameters::saveSetting() {

    FILE * file = nullptr;
    if ((file = fopen("setting","w+")) == nullptr) {
        perror("Erreur d'ouverture de fichier");
        exit(EXIT_FAILURE);
    }
    char sett[PATH];

    int status = (this->soundController->isMuted() || this->getSoundStat())?1:0;
    snprintf(sett,PATH,"%d:%d:%d:%d:%d",this->getSound(),this->getSoundEffect(),status,this->getBrightness(),this->getLanguage());
    fprintf(file,"%s\n",sett);

    if (fclose(file) == -1) {
        perror("Erreur lors de fermeture du fichier");
        exit(EXIT_FAILURE);
    }
}

void parameters::runSetting() {

    FILE * file = nullptr;
    if ((file = fopen("setting","r")) == nullptr) {
        if (errno == 2) {
            this->setDefaultValue();
            this->saveSetting();
            if ((file = fopen("setting","r")) == nullptr) {
                perror("Erreur lors d'ouverture du fichier");
                exit(EXIT_FAILURE);
            }
        }else {
            perror("Erreur lors d'ouverture du fichier");
            exit(EXIT_FAILURE);
        }
    }
    int status = 0;
    fscanf(file,"%d:%d:%d:%d:%d\n",&this->sound,&this->soundEffects,&status,&this->brightness,&this->language);
    //true = muted and false : not muted
    this->soundStat = (status == 1)?true:false;

    if (fclose(file) == -1) {
        perror("Erreur lors de fermeture du fichier");
        exit(EXIT_FAILURE);
    }

    if (!this->getSoundStat() && !this->soundController->isMuted())
        this->soundController->play();

}
