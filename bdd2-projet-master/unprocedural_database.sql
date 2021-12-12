/*drop*/


/*supression des tabless dans l'ordre repsectif*/
drop table archive_activite;
drop table archive_agendas;
drop table AGENDAS_ACTIVITE;
drop table ONLINE_USERS_AGENDAS;
drop table ONLINE_USERS_ACTIVITE;
drop table ACTIVITE;
drop table ONLINE_USERS;
drop table AGENDAS;
/*supression des sequences*/
drop sequence seq_ONLINE_USERS;
drop sequence seq_agenda;
drop sequence seq_activity;

------------------------------------------------- création ----------------------------------------------------

-- ONLINE_USERS: ID, nom, prénom, adresse physique, mail & mot de passe
CREATE table ONLINE_USERS(
    idONLINE_USERS number(10) primary key,
    nom varchar2(45)                            NOT NULL,
    prenom varchar2(45)                         NOT NULL,
    adresse varchar2(245)                       NOT NULL,
    email varchar2(200) not null,
    mot_de_passe varchar2(45)                   NOT NULL,
    derniere_modification DATE                  NOT NULL,
    bool_actif number(1)   default 1, /*car quand un nouveau ONLINE_USERS est inséré il est actif par défaut*/
    enregistre_le date default sysdate
);

-- agenda: ID, nom, priorité, superposabilité, état
CREATE TABLE  AGENDAS (
    idAgenda number(10) primary key,
    nomAgenda varchar2(45)                      NOT NULL,
    priorite number(2)                              NOT NULL,
    mise_a_jour date default sysdate,
    bool_superpose number(1)                      NOT NULL,
    bool_archive number(1)                        NOT NULL,
    nbActivite number(2)                     default 0,

    constraint AGENDAS_ACTIVITE_superpose check ( (bool_superpose=1) or (bool_superpose=0)),   
    constraint AGENDAS_ACTIVITE_archive check ( (bool_archive=1) or (bool_archive=0))
);


create table archive_agendas as (
    select * from agendas where bool_archive=1
);
create table archive_activite as (
    select * from activite where bool_archive=1
);
-- activité: ID, titre, description, lieu, indicateur de pause, priorité, état, catégorie
CREATE TABLE ACTIVITE (
    idActivite number(10) primary key,
    titre varchar2(45)                          NOT NULL,
    descriptif varchar2(45)                     NOT NULL,
    geographie varchar2(45) default 'Twilight Zone',
    bool_pause number(1)                        default 0,
    priorite number(2)                          NOT NULL,
    bool_archive number(1)                      NOT NULL,
    type_activite varchar2(45)                  default 'non classé',
    nboccurrences number(10)                    DEFAULT 1,
    debut DATE                                  NOT NULL,
    fin DATE                                    NOT NULL,
    periodicite varchar2(45)                    DEFAULT 'unique',
    -- vérifications si le nombre d'occurences est strictement positif, si la date de fin est après celle de début, et si la péiodicité est bien définie parmi ces 5 choix
    constraint Nombre_occurences check( nboccurrences >0),
    constraint Coherence_dates check( debut <= fin),
    constraint Existence_periodicite check (periodicite='unique' or periodicite='hebdomadaire' or periodicite='mensuel' or periodicite='semestriel' or periodicite='annuel')

    
    );

-- liaison ONLINE_USERS-agenda: ID de l'ONLINE_USERS et de l'agenda, évaluation de l'agenda par l'ONLINE_USERS, indicateurs si l'ONLINE_USERS peut modifier l'agenda et s'il en est le créateur
CREATE TABLE ONLINE_USERS_AGENDAS(
    idONLINE_USERS number(10) not null references ONLINE_USERS,
    idAgenda number(10) not null references AGENDAS,
    evaluation number(1) default null,
    evalue_a timestamp default null,
    bool_modifier number(1)                      NOT NULL,
    idcreateur number(10)                       NOT NULL,
    -- vérification si l'évaluation est entre 1 et 5
    constraint Peut_modifier check (bool_modifier=1 or bool_modifier=0),
    constraint Etoiles_donnees check (evaluation between 1 and 5)
);
-- liaison agenda-activité
CREATE TABLE  AGENDAS_ACTIVITE(
    idAgenda number(10) not null references AGENDAS,
    idActivite number(10) not null references ACTIVITE
);
--liaison ONLINE_USERS-activité
CREATE TABLE ONLINE_USERS_ACTIVITE(
    idONLINE_USERS number(10) not null references ONLINE_USERS,
    idActivite number(10) not null references ACTIVITE
);

/*CREATION DES SEQUENCES*/
-- séquece qui auto-incrémentera l'ID ONLINE_USERS
create sequence seq_ONLINE_USERS start with 1 increment by 1;
-- séquence auto-incrémentant l'ID activité
create sequence seq_activity start with 1 increment by 1;
-- séquence auto-incrémentant l'ID agenda
create sequence seq_agenda start with 1 increment by 1;

---------- insertions | note: seq_table.nextval donne d'abord sa valeur actuelle avant d'incrémenter ----------
INSERT INTO ONLINE_USERS(idONLINE_USERS,nom ,prenom ,adresse ,email ,mot_de_passe ,derniere_modification) VALUES
(seq_ONLINE_USERS.nextval,'Duran','Mike','Schulstrasse 17c','mike.duran@hotmail.de','dragonball',TO_DATE('2019/10/07 ','yyyy/mm/dd'));/*1*/
INSERT INTO ONLINE_USERS(idONLINE_USERS,nom ,prenom ,adresse ,email ,mot_de_passe ,derniere_modification ) VALUES
(seq_ONLINE_USERS.nextval,'GIGGA','DRILL','KAMINA CITY 13','giga.drill@hotmail.fr','jdjgcgcgt',TO_DATE('2019/06/07','yyyy/mm/dd'));/*2*/
INSERT INTO ONLINE_USERS(idONLINE_USERS,nom ,prenom ,adresse ,email ,mot_de_passe ,derniere_modification) VALUES
(seq_ONLINE_USERS.nextval,'Matry','Laure','vinsonheim','laure.matry@hotmail.fr','madokamagicalgirl',TO_DATE('2019/05/07','yyyy/mm/dd'));/*3*/
INSERT INTO ONLINE_USERS(idONLINE_USERS,nom ,prenom ,adresse ,email ,mot_de_passe ,derniere_modification) VALUES
(seq_ONLINE_USERS.nextval,'Babouri','Maeva','Maler becker 25','maeva.babouri@hotmail.fr','judas',TO_DATE('2019/04/07','yyyy/mm/dd'));/*4*/
INSERT INTO ONLINE_USERS(idONLINE_USERS,nom ,prenom ,adresse ,email ,mot_de_passe ,derniere_modification) VALUES
(seq_ONLINE_USERS.nextval,'Stark','Tony','malibu seventeen 22','tony.stark@hotmail.am','iron man',TO_DATE('2019/09/07','yyyy/mm/dd'));/*5*/
INSERT INTO ONLINE_USERS(idONLINE_USERS,nom ,prenom ,adresse ,email ,mot_de_passe ,derniere_modification) VALUES
(seq_ONLINE_USERS.nextval,'Parker','Peter','queens devil 1','peter.parker@hotmail.am','spiderman',TO_DATE('2019/08/07','yyyy/mm/dd'));/*6*/
INSERT INTO ONLINE_USERS(idONLINE_USERS,nom ,prenom ,adresse ,email ,mot_de_passe ,derniere_modification) VALUES
(seq_ONLINE_USERS.nextval,'KALOUMVUATI','Duramana','qqpart a strasbourg','kaloumvuati.duramana@hotmail.fr','genie',TO_DATE('2019/07/23','yyyy/mm/dd'));/*7*/
INSERT INTO ONLINE_USERS(idONLINE_USERS,nom ,prenom ,adresse ,email ,mot_de_passe ,derniere_modification ) VALUES
(seq_ONLINE_USERS.nextval,'Stephen','S. Knaus','2705 Patterson Fork Road','4hitesh2099i@emasqiuqiu.info','diiiiii',TO_DATE('2019/04/07','yyyy/mm/dd'));/*8*/
INSERT INTO ONLINE_USERS(idONLINE_USERS,nom ,prenom ,adresse ,email ,mot_de_passe ,derniere_modification) VALUES
(seq_ONLINE_USERS.nextval,'Ray ','J. Goodale','miraie eeeeh 28','4h9i@emu.info','jds',TO_DATE('2019/04/07','yyyy/mm/dd'));/*9*/

INSERT INTO AGENDAS(idagenda,nomagenda,priorite,bool_superpose,bool_archive) VALUES (seq_agenda.nextval ,'MARVEL' ,2 ,0 ,0 ); /*1*/
INSERT INTO AGENDAS(idagenda,nomagenda,priorite,bool_superpose,bool_archive) VALUES (seq_agenda.nextval ,'DC_COMICS' ,1 ,0 ,0 );/*2*/
INSERT INTO AGENDAS(idagenda,nomagenda,priorite,bool_superpose,bool_archive) VALUES (seq_agenda.nextval ,'Universite' ,1 ,0 ,0 );/*3*/
INSERT INTO AGENDAS(idagenda,nomagenda,priorite,bool_superpose,bool_archive) VALUES (seq_agenda.nextval ,'FIFA' ,2 ,0 ,0 );/*4*/

INSERT INTO ACTIVITE VALUES (seq_activity.nextval,'Infinity war','la guerre de l"infini',NULL,1,1,0,'comic',1,TO_DATE('2006/12/30','yyyy/mm/dd'),TO_DATE('2009/12/30','yyyy/mm/dd'),'hebdomadaire');/*1*/
INSERT INTO ACTIVITE VALUES (seq_activity.nextval,'ENDGAME','la fin du game',NULL,1,2,0,'comic',1,TO_DATE('2010/12/30','yyyy/mm/dd'),TO_DATE('2012/12/30','yyyy/mm/dd'),'mensuel');/*2*/
INSERT INTO ACTIVITE VALUES (seq_activity.nextval,'SUPERMAN VS BATMAN','la guerre des heros',NULL,1,3,0,'comic',1,TO_DATE('2013/12/30','yyyy/mm/dd'),TO_DATE('2014/12/30','yyyy/mm/dd'),'hebdomadaire');/*3*/ 
INSERT INTO ACTIVITE VALUES (seq_activity.nextval,'far from home','on part en vacance',NULL,1,1,0,'film',1,TO_DATE('2015/01/30','yyyy/mm/dd'),TO_DATE('2015/06/30','yyyy/mm/dd'),'mensuel');/*4*/
INSERT INTO ACTIVITE VALUES (seq_activity.nextval,'HACKTAFAC','ecire une idée pour l"université',NULL,1,4,0,'compétition',1,TO_DATE('2015/07/30','yyyy/mm/dd'),TO_DATE('2015/12/30','yyyy/mm/dd'),'hebdomadaire');/*5*/
INSERT INTO ACTIVITE VALUES (seq_activity.nextval,'Match de foot','<EVIDENT>',NULL,1,1,0,'sport',1,TO_DATE('2016/01/30','yyyy/mm/dd'),TO_DATE('2016/12/30','yyyy/mm/dd'),'mensuel');/*6*/
INSERT INTO ACTIVITE VALUES (seq_activity.nextval,'Match de Tennis','<EVIDENT>',NULL,1,0,0,'sport',1,TO_DATE('2017/03/30','yyyy/mm/dd'),TO_DATE('2017/08/30','yyyy/mm/dd'),'hebdomadaire');/*7*/
INSERT INTO ACTIVITE VALUES (seq_activity.nextval,'Match de Handball','<EVIDENT>',NULL,1,3,0,'sport',1,TO_DATE('2018/04/30','yyyy/mm/dd'),TO_DATE('2018/12/30','yyyy/mm/dd'),'mensuel');/*8*/


INSERT INTO ONLINE_USERS_ACTIVITE VALUES (5,1);
INSERT INTO ONLINE_USERS_ACTIVITE VALUES (5,2);
INSERT INTO ONLINE_USERS_ACTIVITE VALUES (6,1);
INSERT INTO ONLINE_USERS_ACTIVITE VALUES (6,2);
INSERT INTO ONLINE_USERS_ACTIVITE VALUES (6,4);
INSERT INTO ONLINE_USERS_ACTIVITE VALUES (1,5);
INSERT INTO ONLINE_USERS_ACTIVITE VALUES (7,6);



INSERT INTO AGENDAS_ACTIVITE VALUES (1,1);
INSERT INTO AGENDAS_ACTIVITE VALUES (1,2);
INSERT INTO AGENDAS_ACTIVITE VALUES (2,3);
INSERT INTO AGENDAS_ACTIVITE VALUES (1,4);
INSERT INTO AGENDAS_ACTIVITE VALUES (2,4);


INSERT INTO ONLINE_USERS_AGENDAS (idONLINE_USERS,idAgenda,evaluation,bool_modifier,idcreateur) VALUES (1,3,5,1,1);
INSERT INTO ONLINE_USERS_AGENDAS (idONLINE_USERS,idAgenda,evaluation,bool_modifier,idcreateur) VALUES (3,3,3,0,1);
INSERT INTO ONLINE_USERS_AGENDAS (idONLINE_USERS,idAgenda,evaluation,bool_modifier,idcreateur) VALUES (7,3,1,0,1);
INSERT INTO ONLINE_USERS_AGENDAS (idONLINE_USERS,idAgenda,evaluation,bool_modifier,idcreateur) VALUES (5,1,5,1,5);
INSERT INTO ONLINE_USERS_AGENDAS (idONLINE_USERS,idAgenda,evaluation,bool_modifier,idcreateur) VALUES (6,1,5,0,5);
INSERT INTO ONLINE_USERS_AGENDAS (idONLINE_USERS,idAgenda,evaluation,bool_modifier,idcreateur) VALUES (7,4,5,1,7);
INSERT INTO ONLINE_USERS_AGENDAS (idONLINE_USERS,idAgenda,evaluation,bool_modifier,idcreateur) VALUES (5,3,5,1,1);
INSERT INTO ONLINE_USERS_AGENDAS (idONLINE_USERS,idAgenda,evaluation,bool_modifier,idcreateur) VALUES (6,3,4,0,1);

--------------------------------------------------- requêtes --------------------------------------------------
-- nombre d'activités des agendas par catégorie & par ONLINE_USERS
SELECT idONLINE_USERS as utilisateur ,A.type_activite as cathegorie, COUNT(OA.idActivite) as nbr_activite
FROM ONLINE_USERS_ACTIVITE OA, activite A
where OA.idactivite=A.idActivite
GROUP BY idONLINE_USERS, A.type_activite;

-- nombre d'évaluations totales pour les ONLINE_USERSs actifs
select u.idONLINE_USERS as utilisateur, COUNT(DISTINCT u.evaluation) as evaluations_total
from ONLINE_USERS_AGENDAS u 
where u.idONLINE_USERS in (select i.idONLINE_USERS FROM ONLINE_USERS i where i.bool_actif=1) 
group by u.idONLINE_USERS ;

-- agendas avec au moins 5 évaluations moyennant à moins de 3/5
SELECT A.nomAgenda, UA.idAgenda
FROM ONLINE_USERS_AGENDAS UA 
INNER JOIN AGENDAS A 
ON A.idAgenda= UA.idAgenda
GROUP BY UA.idAgenda, A.nomAgenda
HAVING count(UA.evaluation)>=5 AND AVG(UA.evaluation) <3;

-- agenda au plus grand nombre d'activités par semaine
SELECT AA.idAgenda , A.nomagenda, A.nbactivite
FROM Agendas A , AGENDAS_ACTIVITE AA, activite AC
WHERE lower(AC.periodicite) like 'h%' and A.idAgenda=AA.idAgenda and  AA.idActivite=AC.idActivite
and A.nbactivite=(SELECT MAX(A.nbactivite)
                  FROM Agendas A , activite AC, AGENDAS_ACTIVITE AA
                  WHERE lower(AC.periodicite) like 'h%' and A.idAgenda=AA.idAgenda and  AA.idActivite=AC.idActivite);
   

-- login, nom, prénom, adresse, nombre d'agendas, nombre d'activités et nombre d'évaluations de chaque ONLINE_USERS
SELECT UA.idONLINE_USERS as login,u.nom,u.prenom,u.adresse,u.email,count(UA.idAgenda) as nbr_agendas, count(UA.evaluation) as nbr_evaluation
from ONLINE_USERS_AGENDAS UA RIGHT JOIN ONLINE_USERS u 
ON UA.idONLINE_USERS=u.idONLINE_USERS
GROUP by u.idONLINE_USERS, UA.idONLINE_USERS, u.nom, u.prenom, u.adresse, u.email; 
