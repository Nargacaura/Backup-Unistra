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
#define BUFLEN 512

/**
 * @brief 
 * 
 * @param argc 
 * @param argv 
 * @return int 
 */




int main(int argc, char* argv[]){
    if(argc!=3) printf("3 args");
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
    if(inet_pton(AF_INET,argv[1],&server.sin_addr.s_addr)==-1){//error
    }// remplace ifaddr_any // 0.0.0.0

    socklen_t length;
    length=sizeof(struct sockaddr_in);
    

    //demande de connection en envoyant son login
    char login[BUFLEN];
    char pwd[BUFLEN];

    printf("Login: ");
    scanf("%s",login);
    printf("Password: ");
    scanf("%s",pwd);
    
    //envoi de l'id
    if(sendto(s ,login, strlen(login), 0, (struct sockaddr *) &server, length)==-1){
        perror("sendto() client\n");
        close(s);
        exit(EXIT_FAILURE);
    };
    //envoi du mot de passe
    if(sendto(s ,pwd, strlen(pwd)+1, 0, (struct sockaddr *) &server, length)==-1){
        perror("sendto() client\n");
        close(s);
        exit(EXIT_FAILURE);
    };

    socklen_t fromlen;
    fromlen=sizeof(struct sockaddr_in);    
    char server_answer[BUFLEN];

    //reception de la confirmation ou le fail de la connection
    if(recvfrom(s,server_answer,BUFLEN,0,(struct sockaddr *) &from, &fromlen)==-1)
    {//error
        printf("recvfrom()");
        close(s);
        exit(EXIT_FAILURE);
    }
    

    //affichage de la reponse du serveur.
   // printf("%s\n",server_answer);
    
    // Si la réponse du serveur est correcte, alors on passe dans 
    //un mode permanent_connecté qui fait que on peut lui posser ce qu'on veut jusqu'a envoyer le signal "bye"
    
    if(strcmp(server_answer,"OK")==0 ){
        printf("%s\n",server_answer);
        while(1){

            printf("demande d'access: ");
            char request[BUFLEN];
            scanf("%s",request);
            
            if(sendto(s ,request, strlen(request)+1, 0, (struct sockaddr *) &server, length)==-1){
                perror("sendto() request\n");
                close(s);
                exit(EXIT_FAILURE);
            };    

            if(recvfrom(s,server_answer,BUFLEN,0,(struct sockaddr *) &from, &fromlen)==-1)
            {//error
                printf("recvfrom()");
                close(s);
                exit(EXIT_FAILURE);
            }
            
            if(strcmp(server_answer,"bye")==0){
                printf("%s\n",server_answer);
                exit(EXIT_SUCCESS);
            }

        }
    }
    else{//erreur
        printf("%s\n",server_answer);
        close(s);
        exit(EXIT_FAILURE);
    }
    close(s);
    return 0;
}

