//Includes
    #include <stdio.h>
    #include <stdlib.h>
    #include <sys/types.h>
    #include <string.h>
    #include <sys/socket.h>
    #include <unistd.h>
    #include <fcntl.h>
    #include <errno.h> //ERRNO
    #include <netinet/in.h> //INADDR_XXX
    #include <arpa/inet.h>
//Définition
    #define BUFLEN 512
//Programme principal
    int main(int argc, char* argv[]){
        //! Pas assez d'argument? Ou trop d'arguments? Ou juste une façon de voir quels arguments il faut?
        if(argc!=3) {
            fprintf(stdout, "On a juste besoin d'une IP et d'un port, please.");
            exit(EXIT_FAILURE);
        }
       //*Création de la socket du client
        struct sockaddr_in server, from;
        int s;
        if((s=socket(AF_INET /*2*/,SOCK_DGRAM /*2*/, 17/*IPPROTO_UDP*/))==-1){
            perror("socket() client\n");
            close(s);
            exit(EXIT_FAILURE);
        }
       //INITIALISATION DE L'ADRESSE LOCALE
        server.sin_family=AF_INET;
        server.sin_port=htons(atoi(argv[2])); // dans ce cas 2066
        if(inet_pton(AF_INET,argv[1],&server.sin_addr.s_addr)==-1){
            perror("Ouch, on n'a pas pu convertir cette chaîne de caractères en adresse IP");
            close(s);
            exit(1);
        }// remplace ifaddr_any // 0.0.0.0

        socklen_t length;
        length=sizeof(struct sockaddr_in);
       //demande de connection en envoyant son login
        
        char* login=malloc(sizeof(char));
        char* pwd=malloc(sizeof(char));

       printf("Login: ");
        fgets(login, BUFLEN, stdin);
        
        printf("Password: ");
        fgets(pwd, BUFLEN, stdin);

               //printf("%s / %s", login, pwd);
        
        //envoi de l'id
        if(sendto(s ,login, strlen(login)-1, 0, (struct sockaddr *) &server, length)==-1){
            perror("sendto() client\n");
            close(s);
            exit(EXIT_FAILURE);
        };
        //envoi du mot de passe
        if(sendto(s ,pwd, strlen(pwd), 0, (struct sockaddr *) &server, length)==-1){
            perror("sendto() client\n");
            close(s);
            exit(EXIT_FAILURE);
        };
       socklen_t fromlen;
        fromlen=sizeof(struct sockaddr_in);    
        char* server_answer=malloc(sizeof(char));

       //reception de la confirmation ou le fail de la connection
        if(recvfrom(s,server_answer,BUFLEN,0,(struct sockaddr *) &from, &fromlen)==-1)
        {//error
            printf("recvfrom()");
            close(s);
            exit(EXIT_FAILURE);
        }
        
        // Si la réponse du serveur est correcte, alors on passe dans 
        //un mode permanent_connecté qui fait que on peut lui posser ce qu'on veut jusqu'a envoyer le signal "bye"
        printf("%s\n", server_answer);
        if(strcmp(server_answer,"Logged in.")==0 ){
            printf("--WELCOME TO THE DATABANK--\n");
            char* request=malloc(sizeof(char));
            while(strcmp(server_answer,"Deconnecting from server.")!=0){
                
                printf("Your request is... ");
                //memset(request,0,strlen(request));
                fgets(request, BUFLEN, stdin);
                
                if(sendto(s ,request, strlen(request)+1, 0, (struct sockaddr *) &server, length)==-1){
                    perror("sendto() request\n");
                    close(s);
                    exit(EXIT_FAILURE);
             };    

                while(strncmp(server_answer,"done",strlen("done"))!=0){
                    memset(server_answer,0,strlen(server_answer));
                    if(recvfrom(s,server_answer,BUFLEN,0,(struct sockaddr *) &from, &fromlen)==-1){//error
                        printf("recvfrom()");
                        close(s);
                        exit(EXIT_FAILURE);
                    }else{//erreur
                        if(strncmp(server_answer,"done",strlen("done"))!=0)
                            printf("%s\n",server_answer);
                    }
                }
                //procédure à prendre dans le cas d'un bye
                if((strncmp(request,"bye",strlen("bye"))==0) && (strncmp(server_answer,"done",strlen("done"))==0) ){
                    memset(server_answer,0,strlen(server_answer));   
                    if(recvfrom(s,server_answer,BUFLEN,0,(struct sockaddr *) &from, &fromlen)==-1){//error
                        printf("recvfrom() bye");
                        close(s);
                        exit(EXIT_FAILURE);
                    }
                    printf("%s\n",server_answer);
                    memset(server_answer,0,strlen(server_answer));   
                    if(recvfrom(s,server_answer,BUFLEN,0,(struct sockaddr *) &from, &fromlen)==-1){//error
                        printf("recvfrom() bye");
                        close(s);
                        exit(EXIT_FAILURE);
                    }
                    printf("%s\n",server_answer);
                }else
                    {memset(server_answer,0,strlen(server_answer));}
                memset(request, 0,strlen(request));
                printf("request execution finished\n");
            }
       }
        printf("Session ended. Thank you for your journey through this collection.\n");
        close(s);
        exit(EXIT_SUCCESS);
        //*Fin..?
    }


