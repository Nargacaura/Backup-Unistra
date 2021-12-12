#ifndef PARAMETERS_H
#define PARAMETERS_H
#include "baseui.h"


class parameters: public Baseui
{
    public:

        parameters();
        parameters(int sound, int soundEffect,int brightness, int language, bool stat);
        //Setters
        void setSound(int sound);
        void setBrightness(int brightness);
        void setLanguage(int language);
        void setSoundStat(bool stat);
        void setSoundEffect(int soundEffect);

        //Baseui * soundController;

        //Getters
        int getSound();
        int getBrightness();
        int getLanguage();
        bool getSoundStat();
        int getSoundEffect();

        void saveSetting();
        void runSetting();
        void setDefaultValue();

    private :
        int sound;
        int soundEffects;
        int brightness;
        int language;
        bool soundStat;
};

#endif // PARAMETERS_H
