#include <string.h> 
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h> //ERRNO
#include <netinet/in.h> //INADDR_XXX
#define BUFLEN 512
#include <stdnoreturn.h>		// C norme 2011
#include <stdarg.h>


const char *prog ;			// nom du programme pour les erreurs

noreturn void raler (int syserr, const char *fmt, ...){
    va_list ap ;

    va_start (ap, fmt) ;
    fprintf (stderr, "%s: ", prog) ;
    vfprintf (stderr, fmt, ap) ;
    fprintf (stderr, "\n") ;
    va_end (ap) ;

    if (syserr)
	perror ("") ;

    exit (1) ;
} 

char* TestClientId(char*line_to_catch,char* ClientName){

    FILE* fichier=fopen("fichier.txt","r");
    char delimiter[]=":";
    char* ptr;
    char ligne[BUFLEN];
    while(fgets(ligne, BUFLEN, fichier) != NULL){
        strcpy(line_to_catch,ligne);
        ptr=strtok(ligne,delimiter);
        if(strcmp(ptr,ClientName)==0){
            return line_to_catch;
        }
        ptr=strtok(NULL,delimiter);   
    }
    return "NOT FOUND";
}

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




int main(){
    printf("start prog\n");
    struct sockaddr_in from,server;
    char login_client[BUFLEN];
    char passwd_client[BUFLEN];
    int s;
    printf("SENDING SOCKET!\n");
    if((s=socket(AF_INET/*2*/,SOCK_DGRAM/*2*/, 17/*IPPROTO_UDP*/))==-1){//error
        perror("socket\n");
        close(s);
        exit(1);
    }

//INITIALISATION DE L'ADRESSE LOCALE
    server.sin_family=AF_INET;
    server.sin_addr.s_addr=htonl(INADDR_ANY);
    server.sin_port=htons(2066); //au pif j'aime bien le nombre

    printf("BINDING SOCKET !\n");
    if(bind(s, (struct sockaddr *) &server,sizeof(server))==-1){//error
        perror("bind()\n");
        close(s);
        exit(1);
    }

    printf("EXPECTING REPLY!\n");
    socklen_t fromlen=sizeof(from);
    
    //reception de l'id du client
    if(recvfrom(s,login_client,BUFLEN,0,(struct sockaddr *) &from, &fromlen)==-1)
    {//error
        printf("recvfrom()");
        close(s);
        exit(1);
    }
    //reception du mot de passe du client
     if(recvfrom(s,passwd_client,BUFLEN,0,(struct sockaddr *) &from, &fromlen)==-1)
    {//error
        printf("recvfrom()");
        close(s);
        exit(1);
    }

    char line_to_catch[BUFLEN];

    if((strcmp(TestClientId(line_to_catch,login_client),"NOT FOUND")==0)){
         if(sendto(s ,"YOU SHALL NOT PASS !!!", strlen("YOU SHALL NOT PASS !!!")+1, 0, (struct sockaddr *) &from, fromlen)==-1){
            perror("sendto() server\n");
            close(s);
            exit(1);
        };
    }

    if(TestClientPasswd(line_to_catch,passwd_client)==0){
        if(sendto(s ,"OK", strlen("OK")+1, 0, (struct sockaddr *) &from, fromlen)==-1){//ERROR
            perror("sendto() server\n");
            close(s);
            exit(1);
        };
    }
    else {
          if(sendto(s ,"YOU SHALL NOT PASS !!!", strlen("YOU SHALL NOT PASS !!!")+1, 0, (struct sockaddr *) &from, fromlen)==-1){
            perror("sendto() server\n");
            close(s);
            exit(1);
        };
    }

    //tout est bon pour le client donc on entre dans la boucle
    while(1){
        //il attend la requette
        char request_client[BUFLEN];
        if(recvfrom(s,request_client,BUFLEN,0,(struct sockaddr *) &from, &fromlen)==-1)
        {//error
            printf("recvfrom()");
            close(s);
            exit(1);
        }





        //adieu du client
        if(strcmp(request_client,"bye")==0){
            printf("ending request accepted.\n");
            if(sendto(s ,"bye", strlen("bye")+1, 0, (struct sockaddr *) &from, fromlen)==-1){
                perror("sendto() bye\n");
                close(s);
                exit(1);
        };
        }

    }

    printf("answer send! \n");
    
    return 0;

}

