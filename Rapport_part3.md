# Rapport du *Timebomb* d'**IHM**, partie 3: **Organisation & difficultés** <!-- omit in toc -->

[par the Cards of (a bit limited) Time]\
**Sommaire**

- [**Organisation**](#organisation)
  - [*Plan de travail réalisé*](#plan-de-travail-r%c3%a9alis%c3%a9)
  - [*Leçons tirées du projet*](#le%c3%a7ons-tir%c3%a9es-du-projet)
- [**Difficultés encontrées**](#difficult%c3%a9s-encontr%c3%a9es)
  - [*Problèmes techniques*](#probl%c3%a8mes-techniques)
  - [*Modules supprimés de la maquette initiale et/ou du développement*](#modules-supprim%c3%a9s-de-la-maquette-initiale-etou-du-d%c3%a9veloppement)

## **Organisation**

### *Plan de travail réalisé*

Pour faire ce projet (qui, honnêtement, est encore en alpha à ce point), on s'est réparti en 2 sous-groupes: l'un (composé de Mustafa et Duramana) s'occupant du noyau logiciel et du fonctionnement du jeu (en mode terminal), et l'autre (composé de Mike et Damien) s'occupant du côté graphique du jeu. À certains moments, on se regroupe pour lier l'UI et le fonctionnement du jeu afin d'intégrer la jouabilité en mode graphique.

### *Leçons tirées du projet*

Ce projet nous a permis de mieux travailler en équipe, entre autres, et de travailler sur un langage qu'on ne maîtrise pas (enfin, peu, vu qu'il y a quand même du C dans le C++ qui est intégré dans Qt). Mais avant tout, ça nous a appris qu'un jeu ne se fait pas en 2 temps 3 mouvements. Il faut au moins des mois pour en faire un qui soit "potable", un peu comme si on enregistrait un album studio qui ne se fait pas en prenant tout simplement des fichiers MIDI et en chantant dessus. (Pas étonnant que certains devs utilisent l'accès anticipé pour proposer une pré-alpha avec les retours des joueurs.)

## **Difficultés encontrées**

### *Problèmes techniques*

Ce projet ne s'est pas fait sans erreurs. On a eu entre autres des overrides de références (qui étaient des boucles de dépendances), des crashs, des temps de compilation énormes (juste ... woah, plusieurs minutes pour compiler!), n'en parlons pas des freezes sur certains PCs ayant 4 Go de RAM sans Swapfile ..., notamment dû au fait qu'on touche Qt et C++ pour la première fois de notre cursus (oui, on a passé à côté de la POO2, vu qu'on avait validé le S4 en automne dernier). Il y a aussi le fait que les cartes étaient mal attribuées lors du gameplay, mais correctes dans le "pop-up" demandant à chaque joueur de regarder leurs cartes individuellement (vu qu'on a pas d'idée comment on peut faire un filtre de sécurité *dans un jeu en local utilisant un seul poste*). Ah, et le switch ne se faisait qu'à moitié... ou correctement, dépendant du PC utilisé. Gênant pour un jeu de ce type, sachant qu'on ne sait pas si ça va se faire correctement sur les PCs de la fac.

### *Modules supprimés de la maquette initiale et/ou du développement*

Certaines choses ont été modifiées entre temps. L'ajout du "pop-up" d'observation des cartes a été rajouté bien après qu'on ait planifié comment faire le jeu pour mieux respecter les bases requises au jeu, certains backgrounds ne sont pas présents (et d'autres images ne sont pas comme initialement affichées dans la partie 1) notamment pour des raisons de taille et de temps de compilation (qui veut un jeu de 500 Mo qui se compile en, disons, 5 minutes?). On a aussi rajouté un slider pour les SFX et une checkbox pour rendre le jeu muet, vu que le slider pour les sons ne s'applique qu'à la musique. Lle slider de luminosité est aussi là, mais ne sert à rien. On avait prévu d'en régler la luminosité du PC, mais... pourquoi le faire ici alors qu'on peut le faire via les touches fn+f5/f6 (ça peut changer selon les ordis)?
