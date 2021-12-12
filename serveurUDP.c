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
    #include <ctype.h>
    #include <stdarg.h>

//Définition
    #define BUFLEN 512

//Fonctions
    /**
     ** Test de l'ID du client
    *? Arguments:
    * @param line_to_catch ligne à prendre pour en extraire la chaîne correspondante
    * @param ClientName nom du client qui veut se logger
    */

    char* TestClientId(char*line_to_catch,char* ClientName){
        //* Ouverture du fichier et extraction de la chaîne de caractères
        FILE* fichier=fopen("fichier.txt","r");
        char delimiter[]=":";
        char* ptr;
        char ligne[BUFLEN];

        //? Tant qu'on n'a pas trouvé le nom, on cherche, on cherche...
        while(fgets(ligne, BUFLEN, fichier) != NULL){
            strcpy(line_to_catch,ligne);
            ptr=strtok(ligne,delimiter);
            if(strcmp(ptr,ClientName)==0){
                //* Soit il l'a trouvé...
                return line_to_catch;
            }
            ptr=strtok(NULL,delimiter);   
        }
        //! ... soit pas du tout.
        return "NOT FOUND";
    }
    char* getligne(char* ClientName){
        //* Ouverture du fichier et extraction de la chaîne de caractères
        FILE* fichier=fopen("fichier.txt","r");
        char* ligne=malloc(sizeof(char));
        //? Tant qu'on n'a pas trouvé le nom, on cherche, on cherche...
        while(fgets(ligne, BUFLEN, fichier) != NULL){
            if(strstr(ligne,ClientName)!=NULL)
            return ligne;
            memset(ligne,0,strlen(ligne));
        }
        //! ... soit pas du tout.
        return "NOT FOUND";
    }

    //* C'est pareil pour le mot de passe.
    int TestClientPasswd(char* ligne,char* pwd){
        char* ptr;
        ptr=strtok(ligne,":");
        int result=1;
        int i=0;
        while( ptr != NULL){
            if((i==1)&& (strncmp(ptr,pwd,strlen(ptr)-1)==0) ){            
                    result=0;
            }
            i++;        
            ptr=strtok(NULL,":");
        }
    return result;
    }

    void champ(char* champs,char**tab){
        printf("entrée dans fonction");
        char* ptr=strtok(champs,":");
        strncpy(tab[0],ptr,strlen(ptr));
        ptr=strtok(NULL,":");
        strncpy(tab[1],ptr,strlen(ptr));
        memset(champs,0,strlen(champs));
    }

    int digits_only(const char *str){
        while (*str++)
        {
        if ((*str >= 'a') && (*str <= 'z'))
            return 0;
        }
    return 1;
    }

    void CHECK(int s,char* msg_erreur){
        if(s==-1)
        {
            perror(msg_erreur);
            close(s);
            exit(EXIT_FAILURE);
        }
    }

int main(){
    //* Création de la socket serveur
    struct sockaddr_in from,server;
    char* login_client=malloc(sizeof(char));
    char* passwd_client=malloc(sizeof(char));
    int s;
    printf("--ACCESS SERVER--\n");
    CHECK((s=socket(AF_INET/*2*/,SOCK_DGRAM/*2*/, 17/*IPPROTO_UDP*/)),"socket_creation_1\n");

//INITIALISATION DE L'ADRESSE LOCALE
    server.sin_family=AF_INET;
    server.sin_addr.s_addr=htonl(INADDR_ANY);
    server.sin_port=htons(2066); //au pif j'aime bien le nombre

    printf("Binding access server socket...\n");
    CHECK(bind(s, (struct sockaddr *) &server,sizeof(server)),"bind socket_creation_1\n");

    //? Est-ce qu'il y a une réponse de la part du client?
    printf("Waiting for a request from a client...\n");
    socklen_t fromlen=sizeof(from);
    
    //reception de l'id du client
    CHECK(recvfrom(s,login_client,BUFLEN,0,(struct sockaddr *) &from, &fromlen),"recvfrom login_client\n");
   
    //reception du mot de passe du client
    CHECK(recvfrom(s,passwd_client,BUFLEN,0,(struct sockaddr *) &from, &fromlen),"recvfrom passwd_client\n");
 
    //? Est-ce que ce client est déjà enregistré dans ce systèecme?
    char* line_to_catch=malloc(sizeof(char));;
    //! Soit il n'est pas dessus (ah, ces systèmes restrictifs...), ...
    if((strcmp(TestClientId(line_to_catch,login_client),"NOT FOUND")==0)){
         CHECK(sendto(s ,"YOU SHALL NOT PASS !!!", strlen("YOU SHALL NOT PASS !!!")+1, 0, (struct sockaddr *) &from, fromlen),"sendto() testclient login\n");
    }

    //* ... soit tout est bon, ...
    if(TestClientPasswd(line_to_catch,passwd_client)==0){
        CHECK(sendto(s ,"Logged in.", strlen("Logged in.")+1, 0, (struct sockaddr *) &from, fromlen),"sendto() logged in\n");
    }

    //! ... soit il s'est trompé de mot de passe (une faute de frappe arrive à tout le monde.)
    else {
        CHECK(sendto(s ,"YOU SHALL NOT PASS !!!", strlen("YOU SHALL NOT PASS !!!")+1, 0, (struct sockaddr *) &from, fromlen),"sendto passwd fail\n");
    }
    char* request_client=malloc(sizeof(char));
    //tout est bon pour le client donc on entre dans la boucle
    int port_client=from.sin_port;
    while(1<2){
        socklen_t length;
        length=sizeof(struct sockaddr_in);
        //il attend la requette
        printf("j'attend....\n ");
        CHECK(recvfrom(s,request_client,BUFLEN,0,(struct sockaddr *) &from, &fromlen),"recvfrom() request_client\n");
        printf("request: %s\n", request_client);
        //adieu du client
        if(strncmp(request_client,"bye",strlen("bye"))==0){
            printf("ending request received.\n");
            //envoi du bye vers taille.
            server.sin_port=htons(2067); // dans ce cas 2067
            CHECK(inet_pton(AF_INET,"0.0.0.0",&server.sin_addr.s_addr),"Ouch, on n'a pas pu convertir cette chaîne de caractères en adresse IP\n");// remplace ifaddr_any // 0.0.0.0
            CHECK(sendto(s ,"bye", strlen("bye")+1, 0, (struct sockaddr *) &server, length),"sendto() done bye\n"); 
            
           //envoi du bye vers age
           server.sin_port=htons(2069); // dans ce cas 2069
            CHECK(inet_pton(AF_INET,"0.0.0.0",&server.sin_addr.s_addr),"Ouch, on n'a pas pu convertir cette chaîne de caractères en adresse IP\n");// remplace ifaddr_any // 0.0.0.0
            CHECK(sendto(s ,"bye", strlen("bye")+1, 0, (struct sockaddr *) &server, length),"sendto() done supprimer\n"); 
            
           //le jeu est fini
            CHECK(sendto(s ,"done", strlen("done"), 0, (struct sockaddr *) &from, fromlen),"sendto() bye done\n");
            CHECK(sendto(s ,"Ending your session...", strlen("Ending your session...")+1, 0, (struct sockaddr *) &from, fromlen),"sendto() bye\n");
            if(sendto(s ,"Deconnecting from server.", strlen("Deconnecting from server.")+1, 0, (struct sockaddr *) &from, fromlen)==-1){
                perror("sendto() bye\n");
                close(s);
                exit(1);
                exit(EXIT_SUCCESS); //pour l'instant il sort si le client ssort.
            } 
            printf("End of session.\n");
            //! Plutôt par là, le succès.
            exit(EXIT_SUCCESS);
            //* Fin..?
        }else if(strncmp(request_client,"lire",strlen("lire"))==0){
            printf("Request \"lire\" received.\n");
            char* ptr_lire_champ; // le pointeur de strtok qu'on utilise lors des requetes pour avoir toutes les demandes
            ptr_lire_champ=strtok(request_client," ");//lire
            ptr_lire_champ=strtok(NULL," "); //pour passer directeemnt sur les requetes lues
            while(ptr_lire_champ != NULL){
                printf("ptr_lire_champ value : %s\n",ptr_lire_champ);
                printf("ligne: %s \n",getligne(login_client));
                char testeur[BUFLEN];
                snprintf(testeur,strlen(ptr_lire_champ)+1,":%s",ptr_lire_champ);
                if( strstr( getligne(login_client) , testeur) != NULL){
                    printf("ptr_lire : %s_\n",ptr_lire_champ);
                if((strncmp(ptr_lire_champ,"taille",strlen("taille"))==0 ) || (strncmp(ptr_lire_champ,"age",strlen("age"))==0)){ 
                        //on installe tout pour aller vers le serveur TAILLE
                        char* taille_recus=malloc(sizeof(char));
                        if(strncmp(ptr_lire_champ,"taille",strlen("taille"))==0) 
                            server.sin_port=htons(2067); // dans ce cas 2067
                        else{
                            server.sin_port=htons(2069); // dans ce cas 2069    
                        }
                        CHECK(inet_pton(AF_INET,"0.0.0.0",&server.sin_addr.s_addr),"Ouch, on n'a pas pu convertir cette chaîne de caractères en adresse IP\n");
                        // remplace ifaddr_any // 0.0.0.0

                        //printf("%s\n", login_client);
                        //on envoi au serveurTAILLE la requete lecture 
                        CHECK(sendto(s ,"lire", strlen("lire")+1, 0, (struct sockaddr *) &server, length),"sendto() lire vers taille\n"); 
                        // on lui envoi le login du client.
                        printf("lire envoyé\n");
                        CHECK(sendto(s ,login_client, strlen(login_client), 0, (struct sockaddr *) &server, length),"sendto() login_client\n");
                        printf("login envoyé\n");
                        
                        CHECK(recvfrom(s,taille_recus,BUFLEN,0,(struct sockaddr *) &server, &length),"recvfrom() taille");
                        printf("taille recus\n");
                        
                        printf("Port: %d, valeur: %s\n", server.sin_port, taille_recus);
                        
                        //envoi vers client
                        server.sin_port=port_client;
                        server.sin_addr.s_addr=htonl(INADDR_ANY);
                        CHECK(sendto(s ,taille_recus, strlen(taille_recus)+1, 0, (struct sockaddr *) &server, length),"sendto() taille_recus\n");
                        printf("taille envoyée\n");
                        //on libère la mémoire de taille_recus
                        memset(taille_recus, 0,strlen(taille_recus));
                    } 
                }  
                else{ //le login_client n'a pas accès à ce ptr_lire_champ
                    //on aloue ce ptr_lire_champ
                    printf("ptr_lire_champ invalide %s\n",ptr_lire_champ);  
                    CHECK(sendto(s ,ptr_lire_champ, strlen(ptr_lire_champ), 0, (struct sockaddr *) &from, fromlen),"sendto() mauvais_chap client\n");
                }                            
                ptr_lire_champ=strtok(NULL," "); 
            }
            
            CHECK(sendto(s ,"done", strlen("done"), 0, (struct sockaddr *) &from, fromlen),"sendto() done\n");  
            printf("Done proceeding request \"lire\".\n");
            memset(request_client, 0,strlen(request_client));
        }else if(strncmp(request_client,"ecrire",strlen("ecrire"))==0){
            printf("Request \"ecrire\" received.\n");
            char* ptr_ecrire_champ;
            ptr_ecrire_champ=strtok_r(request_client," :",&request_client);
            while((ptr_ecrire_champ=strtok_r(request_client," :",&request_client))){
                printf("ptr champ: %s\n",ptr_ecrire_champ);
                if((strncmp(ptr_ecrire_champ,"taille",strlen("taille"))==0 ) || strncmp(ptr_ecrire_champ,"age",strlen("age"))==0){ 
                    printf("ptr valeur: %s\n",ptr_ecrire_champ);
                    if(strncmp(ptr_ecrire_champ,"taille",strlen("taille"))==0) 
                        server.sin_port=htons(2067); // dans ce cas 2067
                    else
                    {
                        server.sin_port=htons(2069); // dans ce cas 2069    
                    }
                    //préparation du lancement de la requete
                    ptr_ecrire_champ=strtok_r(request_client," :",&request_client);
                    if(digits_only(ptr_ecrire_champ)==1){ //test si la valeur est un chiffre !
                        printf("envoi du message d'écriture\n");
                        
                        //préparer la communication avec le serveurTaille
                      
                        CHECK(inet_pton(AF_INET,"0.0.0.0",&server.sin_addr.s_addr),"Ouch, on n'a pas pu convertir cette chaîne de caractères en adresse IP\n");
                        // remplace ifaddr_any // 0.0.0.0
                
                        //envoi de la requete.
                        CHECK(sendto(s ,"ecrire", strlen("ecrire"), 0, (struct sockaddr *) &server, length),"sendto() ecrire vers taille\n"); 
                        printf("envoi de la taille: %s\n",ptr_ecrire_champ);
                        CHECK(sendto(s ,login_client, strlen(login_client), 0, (struct sockaddr *) &server, length),"sendto() ecrire vers taille login_client\n"); 
                        CHECK(sendto(s ,ptr_ecrire_champ, strlen(ptr_ecrire_champ), 0, (struct sockaddr *) &server, length),"sendto() ecrire vers taille newsize\n"); 
                        
                        //recevoir confirmation. du serveur taile 
                        char confirmation[BUFLEN];
                        CHECK(recvfrom(s,confirmation,BUFLEN,0,(struct sockaddr *) &from, &fromlen),"recvfrom() confirmation");
                        
                        //préparation d'envoi vers le client.
                        server.sin_port=port_client;
                        server.sin_addr.s_addr=htonl(INADDR_ANY);
                        
                        //envoi au client
                        CHECK(sendto(s ,confirmation, strlen(confirmation), 0, (struct sockaddr *) &server, length),"sendto() ecrire taille serveur valid\n"); 
                    }
                    else{ 
                        server.sin_port=port_client;
                        server.sin_addr.s_addr=htonl(INADDR_ANY);
                        printf("la valeur du champ taille doit etre un nombre !");
                        CHECK(sendto(s ,"la valeur du champ taille doit etre un nombre !\n", strlen("la valeur du champ taille doit etre un nombre !\n"), 0, (struct sockaddr *) &server, length),"sendto() ecrire taille serveur valid\n"); 
                    }
                    printf("sortie de taille\n");
                }else{
                    printf("aucun accès au champ %s\n",ptr_ecrire_champ);
                    CHECK(sendto(s ,ptr_ecrire_champ, strlen(ptr_ecrire_champ), 0, (struct sockaddr *) &server, length),"sendto() ecrire taille serveur valid\n"); 
                }
                printf("valeur suivante: %s\n",ptr_ecrire_champ);
            }
                    
            printf("Done proceeding request \"ecrire\".\n");
            CHECK(sendto(s ,"done", strlen("done"), 0, (struct sockaddr *) &server, length),"sendto() done ecrire\n"); 
            printf("done sended\n");
            memset(request_client, 0,strlen(request_client));      
        }else if (strncmp(request_client,"supprimer",strlen("supprimer"))==0){
            printf("Request \"supprimer\" received.\n");                 
            
            char confirmation_1[BUFLEN];
            //vers le serveur taille
            server.sin_port=htons(2067); // dans ce cas 2067
            CHECK(inet_pton(AF_INET,"0.0.0.0",&server.sin_addr.s_addr),"Ouch, on n'a pas pu convertir cette chaîne de caractères en adresse IP\n");// remplace ifaddr_any // 0.0.0.0
            CHECK(sendto(s ,"supprimer", strlen("supprimer")+1, 0, (struct sockaddr *) &server, length),"sendto() done supprimer\n"); 
            CHECK(sendto(s ,login_client, strlen(login_client)+1, 0, (struct sockaddr *) &server, length),"sendto() done supprimer\n"); 
            printf("envoi de vers taille\n");
            CHECK(recvfrom(s,confirmation_1,BUFLEN,0,(struct sockaddr *) &server, &length),"recvfrom() suppr ligne 330");
            printf("confirmation: %s\n",confirmation_1);
            memset(confirmation_1,0,strlen(confirmation_1));
            
            //vers le serveur age
            printf("envoi de vers age\n");
            server.sin_port=htons(2069); // dans ce cas 2067
            CHECK(inet_pton(AF_INET,"0.0.0.0",&server.sin_addr.s_addr),"Ouch, on n'a pas pu convertir cette chaîne de caractères en adresse IP\n");// remplace ifaddr_any // 0.0.0.0
            CHECK(sendto(s ,"supprimer", strlen("supprimer")+1, 0, (struct sockaddr *) &server, length),"sendto() done supprimer\n"); 
            CHECK(sendto(s ,login_client, strlen(login_client)+1, 0, (struct sockaddr *) &server, length),"sendto() done supprimer\n"); 
            
            CHECK(recvfrom(s,confirmation_1,BUFLEN,0,(struct sockaddr *) &from, &fromlen),"recvfrom() suppr ligne 330");
            printf("confirmation: %s\n",confirmation_1);
            
            printf("envoi confirmation vers client\n");
            server.sin_port=port_client; // dans ce cas 2066
            server.sin_addr.s_addr=htonl(INADDR_ANY);
            CHECK(sendto(s ,"done", strlen("done"), 0, (struct sockaddr *) &server, length),"sendto() done supprimer\n"); 
            printf("done sended\n");
            memset(request_client, 0,strlen(request_client));
            memset(confirmation_1,0,strlen(confirmation_1));
            printf("Done proceeding request \"supprimer\".\n");
        } else if(strncmp(request_client,"help",strlen("help"))==0){
         
            printf("Request \"help\" received.\n");
            CHECK(sendto(s ,
                "5 commandes: \"lire\", \"ecrire\", \"help\", \"supprimer\" et \"bye\".\
                \n(Vous venez d'utiliser l'une d'entre elles, obviously.)", 
                strlen("5 commandes: \"lire\", \"ecrire\", \"help\", \"supprimer\" et \"bye\".\
                \n(Vous venez d'utiliser l'une d'entre elles, obviously.)")+1,
                0, (struct sockaddr *) &from, fromlen),"sendto() usage help\n");
            printf("Done proceeding request \"help\".\n");
            CHECK(sendto(s ,"done", strlen("done"), 0, (struct sockaddr *) &from, fromlen),"sendto() done supprimer\n"); 
            printf("done sended\n");
            memset(request_client, 0,strlen(request_client));
             /*
                    tout les fonctionnalités pour lire. 
            */     
        }else{
            printf("Unknown command \"%s\". ", request_client);
            CHECK(sendto(s ,"usage: lire (<champ1>)+|ecrire (<champ1>:<valeur>)+|supprimer"
            , strlen("usage: lire (<champ1>)+|ecrire (<champ1>:<valeur>)+|supprimer")+1,
             0, (struct sockaddr *) &from, fromlen),"sendto unknown command\n");
            CHECK(sendto(s ,"done", strlen("done"), 0, (struct sockaddr *) &from, fromlen),"sendto() done supprimer\n"); 
            printf("error message sent.\n");
           //il faut libérer la place de request_cient
            memset(request_client, 0,strlen(request_client));
        }
                
    }//fin de while(1)
    
    printf("ending request accepted.\n");
    CHECK(sendto(s ,"Ending your session...", strlen("Ending your session...")+1, 0, (struct sockaddr *) &from, fromlen),"sendto() bye\n");
    printf("End of session.\n");
    //! Plutôt par là, le succès.
    exit(EXIT_SUCCESS);
    //* Fin..?

}

