//Includes
    #include <string.h> 
    #include <stdio.h>
    #include <stdlib.h>
    #include <sys/types.h>
    #include <sys/socket.h>
    #include <unistd.h>
    #include <fcntl.h>
    #include <errno.h>
    #include <netinet/in.h>
    #include <arpa/inet.h>
    #include <stdarg.h>
    #include <signal.h>

//Définitions
    //Taille du buffer
    #define BUFLEN 512
    //Sauvegarde et terminaison
    #define save_and_close(coords, fichier) { writing(coords, fichier); exit(0); }

    /**
     ** Coordonnées utilisateur/données
    *? Stocke temporairement les utilisateurs et UNE SEULE coordonnées
    *? extraites depuis un fichier passé en paramètre
    *
    ** Contenu:
    *  @param username liste les utilisateurs enregistrés
    *  @param data liste des données extraites depuis le fichier d'une donnée spécifique
    *  @param nbUsers nombre total d'utilisateurs enregistrés
    */
    typedef struct {
        char username[BUFLEN][BUFLEN];
        int data[BUFLEN];
        int nbUsers;
    } coordonneesdata;

//Fonctions
    /**
     ** Affectation des coordonnées
     *
     *? Remplit la structure de ses utilisateurs et de la donnée spécifiée
     *  @param userList structure listant les utilisateurs
     *  @param nomfichier fichier de données passé en paramètre
     */

void Coordonnees (coordonneesdata* userList, char* nomfichier){
    //Données utilisées dans cette fonction
    FILE* fichier;
    char delimiter[]=";";
    char* ptr;
    char ligne[BUFLEN];
    int indice;
    char line[BUFLEN];
    
    // Ouverture du fichier et extraction des données
        fichier=fopen(nomfichier,"r");
    
    //Copie de la ligne "template" par une valeur
    //qui pourrait exister mais que (honnêtement) personne n'utilise
        strcpy(line, "NULL;NULL");
    
    //Tant qu'il n'aura pas trouvé la fin du fichier...
        indice=0;

    while(fgets(ligne, BUFLEN, fichier) != NULL){
        strcpy(line,ligne);
        ptr=strtok(ligne,delimiter);
        
        printf("Reading data from %s...\n", ptr);
        strncpy(userList->username[indice], ptr, strlen(ptr)+1);
        ptr=strtok(NULL,delimiter);
        userList->data[indice]=atoi(ptr);
        indice++;
    }
    // En même temps, on a compté le nombre d'utilisateurs.
        userList->nbUsers=indice;

    //On ferme le fichier... jusqu'à réception du "bye".
        fclose(fichier);

}

 /**
     ** Écriture dans le fichier
     *
     *? Remplit le fichier spécifié des valeurs stockées dans la structure
     *  @param coords structure listant les utilisateurs
     *  @param nomfichier fichier de données passé en paramètre
     */

void writing(coordonneesdata* coords, char* nomfichier){
    //Données utilisées dans cette fonction
        FILE* fichier;
        char ligne[BUFLEN];
        int indice;
        char line[BUFLEN];
        char size[BUFLEN];
        char current_user[BUFLEN];

    // Ouverture du fichier pour écriture des données
        fichier=fopen(nomfichier,"w");
            
    //Création de la ligne "template"
        strcpy(line, "NULL;NULL");
            
    //Tant qu'on n'aura pas écrit tous les utilisateurs...
        indice=0;

    while(indice < coords->nbUsers){
    //... On concatène son username et sa donnée stockée..
        strcat(current_user, coords->username[indice]);
        strcat(current_user, ";");
        snprintf(size, sizeof(int), "%d", coords->data[indice]);
        strcat(current_user, size);

    //... et on l'écrit dans le fichier spécifié
        printf("Writing data to %s...\n", coords->username[indice]);
        strcpy(line,ligne);  
        fprintf(fichier, "%s\n", current_user);

    //Bien sûr, on n'oublie pas de remettre à 0 la chaîne concaténée.
        strcpy(current_user,"");
        indice++;
    }
    // Et on ferme le fichier!
        fclose(fichier);
}

 /**
     ** Écriture de la nouvelle valeur dans la structure
     *
     *? Remplit le fichier spécifié des valeurs stockées dans la structure
     *  @param coord structure listant les utilisateurs
     *  @param Client client à paramétrer
     *  @param size nouvelle valeur à insérer
     */

void changedata(coordonneesdata* coord, char* Client, char* size){
    //Donnée utilisée dans cette fonction
        int indice;
    //Tant qu'on n'a pas trouvé le client...
        indice=0;

    while(strcmp(coord->username[indice], Client)!=0){
        indice++;
    }
    //On convertit la chaîne en entier.
        coord->data[indice]=atoi(size);
}

/**
     ** Test de présence dans la base
     *
     *? Vérifie si l'utilisateur est bien présent dans la structure
     *  @param coord structure listant les utilisateurs
     *  @param Client client à tester
     */

char* TestId(coordonneesdata* coord, char* Client){
   //Donnée utilisée dans cette fonction
    int indice;
            
    //Tant qu'on ne l'a pas trouvé...
        indice=0;
        while(indice<coord->nbUsers){
            //Si, par hasard, il est dedans...
            if(strcmp(coord->username[indice], Client)==0){
                //il renvoie le client
                return Client;
            }
            indice++;
        }

    //sinon, il prévient qu'il ne l'a pas trouvé.
        return "NOT FOUND";

}

  /**
     ** Lecture de la donnée
     *
     *? Lit la donnée de l'utilisateur
     *  @param coord structure listant les utilisateurs
     *  @param Client client auquel lire la donnée
     */
int viewdata(coordonneesdata* coord, char* Client){
    //Donnée utilisée dans cette fonction
        int indice;
            
    //Tant que le client n'est pas trouvé...
        indice=0;
        while(strcmp(coord->username[indice], Client)!=0 && indice<coord->nbUsers){
            indice++;
        }

    //S'il l'a trouvé, il renvoie la taille
        if(indice<coord->nbUsers)
            return coord->data[indice];
    //Sinon, c'est -1 (considéré comme supprimé)
        else return -1;
        }



//Programme principal
int main(int argc, char** argv){
    if(argc!=3){
        fprintf(stderr, "Un seul fichier et un port requis\n");
        exit(EXIT_FAILURE);
    }
// Création de la socket serveur
    struct sockaddr_in from,server;
    char login_client[BUFLEN];
    int s;
    printf("--ACCESS SERVER data--\n");
    if((s=socket(AF_INET/*2*/,SOCK_DGRAM/*2*/, 17/*IPPROTO_UDP*/))==-1){//error
        perror("socket\n");
        close(s);
        exit(EXIT_FAILURE);
    }

    char* datafile=argv[1];
    char* port=argv[2];

//INITIALISATION DE L'ADRESSE LOCALE
    server.sin_family=AF_INET;
    server.sin_addr.s_addr=htonl(INADDR_ANY);//le port sur lequel le serveur accès va envoyer les infos.
    server.sin_port=htons(atoi(port));

    printf("Binding access server socket...\n");
    if(bind(s, (struct sockaddr *) &server,sizeof(server))==-1){//error
        perror("bind()\n");
        close(s);
        exit(EXIT_FAILURE);
    }

//? Est-ce qu'il y a une réponse de la part du client?
    printf("Waiting for a request from a client...\n");
    socklen_t fromlen=sizeof(from);
    
    //reception de l'id du client
    char received_request[BUFLEN];
    char* data_recus=malloc(sizeof(char));
    coordonneesdata* coords=malloc(sizeof(coordonneesdata));
    Coordonnees(coords, datafile);    
    while(1){
        printf("j'attend....\n");

        if(recvfrom(s,received_request,BUFLEN,0,(struct sockaddr *) &from, &fromlen)==-1){//error
            perror("recvfrom received_request");        
            close(s);
            exit(EXIT_FAILURE);
        }
        printf("request received : %s\n",received_request);
        if(strncmp(received_request,"lire",strlen("lire")-1)==0){
            printf("lecture initiated\n");

            if(recvfrom(s,login_client,BUFLEN,0,(struct sockaddr *) &from, &fromlen)==-1){//error
                perror("recvfrom");        
                close(s);
                exit(EXIT_FAILURE);
            }
            printf("login received\n");
            printf("login: %s\n",login_client);
            if(strncmp(TestId(coords,login_client),"NOT FOUND",strlen("NOT FOUND"))==0){//error
                printf("testclientid()\n");
                exit(EXIT_FAILURE);
            }//
            char valeur_a_renvoyer[BUFLEN];
            int dataRecue;
            dataRecue=viewdata(coords, login_client);
            printf("%d\n", dataRecue);
            snprintf(valeur_a_renvoyer, sizeof(int), "%d", dataRecue);

            //envoyer vers le serveur d'accès.
            server.sin_port=2066; //le serveur d'accès
            if(inet_pton(AF_INET,"0.0.0.0" /*atoi[3]*/,&server.sin_addr.s_addr)==-1){
                perror("Ouch, on n'a pas pu convertir cette chaîne de caractères en adresse IP");
                close(s);
                exit(EXIT_FAILURE);
            }// remplace ifaddr_any // 0.0.0.0
        
            printf("valeur de %s est : %s\n",login_client,valeur_a_renvoyer);
            if(sendto(s ,valeur_a_renvoyer, strlen(valeur_a_renvoyer), 0, (struct sockaddr *) &from, fromlen)==-1){
                perror("sendto() client\n");
                close(s);
                exit(EXIT_FAILURE);
            };
            printf("data sended\n");
            memset(received_request, 0,strlen(received_request));
            memset(login_client, 0,strlen(login_client));

        }
        if(strncmp(received_request,"ecrire",strlen("ecrire"))==0){
            printf("ecrire initiated\n");
            printf("envoi de la confirmation d'écriture\n");
            
            memset(login_client,0,strlen(login_client));
            memset(data_recus,0,strlen(data_recus));
            if(recvfrom(s,login_client,BUFLEN,0,(struct sockaddr *) &from, &fromlen)==-1){//error
            }
            if(recvfrom(s,data_recus,BUFLEN,0,(struct sockaddr *) &from, &fromlen)==-1){//error
                perror("recvfrom data_recus");        
                close(s);
                exit(EXIT_FAILURE);
            }
            printf("la data ressus: %s\n",data_recus);
            printf("login: %s\n",login_client);
            changedata(coords, login_client,data_recus);
            if(sendto(s ,"ecriture modifié", strlen("ecriture modifié")+1, 0, (struct sockaddr *) &from, fromlen)==-1){
                perror("sendto()  ecriture modifié\n");
                close(s);
                exit(EXIT_FAILURE);
            };
            
            printf("done writing values in DATABASE\n");
            memset(data_recus,0,strlen(data_recus));
        }
        if(strncmp(received_request,"supprimer",strlen("supprimer"))==0){
            printf("supprimer initiated\n");
            
            memset(login_client,0,strlen(login_client));
            memset(data_recus,0,strlen(data_recus));
            if(recvfrom(s,login_client,BUFLEN,0,(struct sockaddr *) &from, &fromlen)==-1){//error
            }
            changedata(coords, login_client,"-1");
            printf("envoi de la confirmation de suppression\n");
            if(sendto(s ,"Valeur supprimée.", strlen("Valeur supprimée.")+1, 0, (struct sockaddr *) &from, fromlen)==-1){
                perror("sendto()  Valeur supprimée.\n");
                close(s);
                exit(EXIT_FAILURE);
            };
            printf("done writing values in DATABASE\n");
            memset(data_recus,0,strlen(data_recus));
        }
        if(strncmp(received_request,"bye",strlen("bye"))==0){
            printf("bye initiated\n");            
            memset(login_client,0,strlen(login_client));
            save_and_close(coords,datafile);
        }
        memset(received_request, 0,strlen(received_request));
    }
    exit(EXIT_SUCCESS);
    //* Fin..?

}

