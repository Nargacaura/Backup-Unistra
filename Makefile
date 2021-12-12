.PHONY: all clean archive doc
# Makefile (Pourquoi -e dans les echo? Certaines distributions comme Manjaro (ce qu'utilise l'un du binôme) n'acceptent pas l'affichage étendu sans -e par défaut... Si ça apparaît, vous pouvez les enlever. Sinon, ça passe.)

#Color code
Bold=\033[1m
Normal=\033[0m
Create=\033[1;32m
ErrOrDel=\033[1;31m
CC=cc
CFLAGS= -g -Wall -Wextra -Werror

all: serveurUDP clientUDP serveurData

serveurUDP: serveurUDP.c
	@echo -e "Compilation du ${Bold}serveur d'accès${Normal}..."
	@$(CC) $(CFLAGS) $^ -o $@
	@$(CC) $(CFLAGS) $^ -o $@; if [ $$? -eq 0 ]; then echo -e "${Create}Serveur d'accès compilé.${Normal} Veuillez utiliser ${Bold}./${@}${Normal} pour le tester."; else echo -e "${ErrOrDel}Erreur de compilation détectée. Arrêt de la compilation.${Normal}\n"; fi

clientUDP: clientUDP.c
	@echo -e "Compilation du ${Bold}client${Normal}..."
	@$(CC) $(CFLAGS) $^ -o $@
	@$(CC) $(CFLAGS) $^ -o $@; if [ $$? -eq 0 ]; then echo -e "${Create}Client compilé.${Normal} Veuillez utiliser ${Bold}./${@} '0.0.0.0' 2066${Normal} pour le tester."; else echo -e "${ErrOrDel}Erreur de compilation détectée. Arrêt de la compilation.${Normal}\n"; fi

serveurData: serveurData.c
	@echo -e "Compilation du ${Bold}serveur de données${Normal}..."
	@$(CC) $(CFLAGS) $^ -o $@
	@$(CC) $(CFLAGS) $^ -o $@; if [ $$? -eq 0 ]; then echo -e "${Create}Serveur de données compilé.${Normal} Veuillez utiliser ${Bold}./${@} taille.txt 2067${Normal} ou ${Bold}./${@} age.txt 2069${Normal} pour le tester."; else echo -e "${ErrOrDel}Erreur de compilation détectée. Arrêt de la compilation.${Normal}\n"; fi

clean:
	@echo -e "${Bold}Suppression des fichiers exécutables${Normal} (en plus de l'archive si elle existe)..."
	@rm -rf serveurUDP clientUDP serveurData *.o *.tar.gz
	@echo -e "${ErrOrDel}Fichiers supprimés.${Normal}"

archive :
	@echo -e "${Bold}Archivage du projet...${Normal}"
	tar -vcz *.c *.pdf -f Duran_Ledda.tar.gz
	@echo -e "${Create}Projet archivé.${Normal}"	
doc :
	@echo "Création de la doc..."
	doxygen -u Doxyfile; doxygen Doxyfile
	@echo "Doc créée."