# Makefile (Pourquoi -e dans les echo? Certaines distributions comme Manjaro (ce qu'utilise l'un du binôme) n'acceptent pas l'affichage étendu sans -e par défaut... Si ça apparaît, vous pouvez les enlever. Sinon, ça passe.)

#Color code
Bold=\033[1m
Normal=\033[0m
Create=\033[1;32m
ErrOrDel=\033[1;31m
CC=cc
CFLAGS= -g -Wall -Wextra -Werror

#Tout compiler!
all: MergeSort QuickSort InsertSort RadixSort BucketSort

help:
	@echo -e "${Bold}Comment exécuter ce Makefile?${Normal}"
	@echo -e "make [options] (... simple comme tout!)\n"
	@echo -e "${Bold}OPTIONS${Normal}"
	@echo -e "${Create}all${Normal} ${Bold}[par défaut si aucune option]${Normal} compile tous les tris."
	@echo -e "${Create}MergeSort${Normal}, ${Create}QuickSort${Normal}, ${Create}InsertSort${Normal}, ${Create}RadixSort${Normal} & ${Create}BucketSort${Normal} compilent à chacun leur tri spécifié via leur nom anglophone."
	@echo -e "${Bold}help${Normal} affiche cette aide. Merci, Captain Obvious!"
	@echo -e "${ErrOrDel}clean${Normal} supprime les exécutables, ainsi que l'archive si elle existe."
	@echo -e "${Create}archive${Normal}... archive les fichiers C et le PDF dans un dossier tar. On ne peut rien vous cacher!\n"
	@echo -e "Maintenant... ${Bold}Amusez-vous à trier!${Normal}\n"

#Tri par fusion
MergeSort: MergeSort.c
	@echo -e "Compilation du ${Bold}tri par fusion${Normal}..."
	@if [ ! -f fichier ]; then gcc -Wall -Wextra -Werror fichier.c -o fichier; fi
	@$(CC) $(CFLAGS) $^ -o $@; if [ $$? -eq 0 ]; then echo -e "${Create}Tri par fusion compilé.${Normal} Veuillez utiliser ${Bold}./fichier ./${@}${Normal} pour le tester."; else echo -e "${ErrOrDel}Erreur de compilation détectée. Arrêt de la compilation.${Normal}\n"; fi

#Tri rapide
QuickSort: QuickSort.c
	@echo -e "Compilation du ${Bold}tri rapide${Normal}..."
	@if [ ! -f fichier ]; then gcc -Wall -Wextra -Werror fichier.c -o fichier; fi
	@$(CC) $(CFLAGS) $^ -o $@; if [ $$? -eq 0 ]; then echo -e "${Create}Tri rapide compilé.${Normal} Veuillez utiliser ${Bold}./fichier ./${@}${Normal} pour le tester."; else echo -e "${ErrOrDel}Erreur de compilation détectée. Arrêt de la compilation.${Normal}\n"; fi
	@# Jeux de test ici

#Tri par insertion
InsertSort: InsertSort.c
	@echo -e "Compilation du ${Bold}tri par insertion${Normal}..."
	@if [ ! -f fichier ]; then gcc -Wall -Wextra -Werror fichier.c -o fichier; fi
	@$(CC) $(CFLAGS) $^ -o $@; if [ $$? -eq 0 ]; then echo -e "${Create}Tri par insertion compilé.${Normal} Veuillez utiliser ${Bold}./fichier ./${@}${Normal} pour le tester."; else echo -e "${ErrOrDel}Erreur de compilation détectée. Arrêt de la compilation.${Normal}\n"; fi
	@# Jeux de test ici

#Tri par base
RadixSort: RadixSort.c
	@echo -e "Compilation du ${Bold}tri par base${Normal}..."
	@if [ ! -f fichier ]; then gcc -Wall -Wextra -Werror fichier.c -o fichier; fi
	@$(CC) $(CFLAGS) $^ -o $@; if [ $$? -eq 0 ]; then echo -e "${Create}Tri par base compilé.${Normal} Veuillez utiliser ${Bold}./fichier ./${@}${Normal} pour le tester."; else echo -e "${ErrOrDel}Erreur de compilation détectée. Arrêt de la compilation.${Normal}\n"; fi
	@# Jeux de test ici

#Tri par paquet
BucketSort: BucketSort.c
	@echo -e "Compilation du ${Bold}tri par paquets${Normal}..."
	@if [ ! -f fichier ]; then gcc -Wall -Wextra -Werror fichier.c -o fichier; fi
	@$(CC) $(CFLAGS) $^ -o $@; if [ $$? -eq 0 ]; then echo -e "${Create}Tri par paquets compilé.${Normal} Veuillez utiliser ${Bold}./fichier ./${@}${Normal} pour le tester."; else echo -e "${ErrOrDel}Erreur de compilation détectée. Arrêt de la compilation.${Normal}\n"; fi
	@# Jeux de test ici
	
#Suppression
clean:
	@echo -e "${Bold}Suppression des fichiers exécutables${Normal} (en plus de l'archive si elle existe)..."
	@rm -rf *Sort *.tar.gz fichier
	@echo -e "${ErrOrDel}Fichiers supprimés.${Normal}"

#Archivage
archive:
	@echo -e "${Bold}Archivage du projet...${Normal}"
	@tar -czf Duran_Ledda_Projet_SDA2.tar.gz 'rapport SDA.pdf' ImagesTests/ Makefile *.c
	@echo -e "${Create}Projet archivé.${Normal}"