#!/bin/bash

#Êtes vous sur i3?
pgrep -l i3
if [ $? -eq 0 ]; then
    echo "On a détecté que vous êtes sur i3. Veuillez opter pour un autre WM tel que Xfce et relancer ce script."
    exit 3
fi

#Déplaçons-nous dans le dossier où se trouvent les fichiers
cd testproj

#Créons l'exécutable
if [ ! -z "./.qmake.stash" ]
then qmake
fi

make
cd ..
if [ $? -eq 0 ]; then
    echo "Compilation terminée."
    echo "Pour nettoyer, faites \"sh TBClean.sh\". Sinon, lancez \"sh timebomb.sh\" pour lancer le jeu."
else 
    echo "Erreur de compilation détectée. Arrêt."
    exit 2
fi
