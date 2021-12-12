#!/bin/bash


if [ ! -z "./testproj/testproj" ]
then 
    echo "Exécutable non trouvé. Veuillez lancer \"sh TBCompile.sh\" pour compiler."
    exit 1
fi
#Lançons-le
cd testproj
./testproj
cd ..