-------------------------------------------------- création --------------------------------------------------

-- utilisateur: ID, nom, prénom, adresse physique, mail & mot de passe
CREATE TABLE if not exists UTILISATEUR(
    idUtilisateur int(10) primary key,
    nom varchar(45)                            NOT NULL,
    prenom varchar(45)                         NOT NULL,
    adresse varchar(245)                       NOT NULL,
    email varchar(200) not null,
    mot_de_passe varchar(45)                   NOT NULL,
    derniere_modification DATE                  NOT NULL,
    enregistre_le date not null default sysdate,
    bool_actif boolean                          NOT NULL,

    -- à faire en trigger
    constraint Activite_utilisateur check ( ( bool_actif=1 and (derniere_modification > add_months(sysdate,-3) ))
            or 
            (bool_actif=0 and (derniere_modification <= add_months(sysdate,-3) ))
        )   
    
);
-- séquece qui auto-incrémentera l'ID utilisateur
create sequence seq_user start with 1 increment by 1;

-- agenda: ID, nom, priorité, superposabilité, état
CREATE TABLE if not exists agenda (
    idAgenda int(10) primary key,
    nomAgenda varchar(45)                      NOT NULL,
    priorite int(2)                          NOT NULL,
    mise_a_jour date not null default sysdate,
    bool_superpose boolean                      NOT NULL,
    bool_archive boolean                        NOT NULL,
    nbActivites integer not null default 0,
    constraint nb_activites_maximal check ((nbActivites<=50) || (extract(day from mise_a_jour)-add_days(sysdate,-7)>0))
);
-- séquence auto-incrémentant l'ID agenda
create sequence seq_agenda start with 1 increment by 1;

-- activité: ID, titre, description, lieu, indicateur de pause, priorité, état, catégorie
CREATE TABLE if not exists ACTIVITE (
    idActivite int(10) primary key,
    titre varchar(45)                          NOT NULL,
    descriptif varchar(45)                     NOT NULL,
    geographie varchar(45) default 'Twilight Zone',
    bool_pause boolean                          NOT NULL default false,
    priorite int(2)                          NOT NULL,
    bool_archive boolean                        NOT NULL,
    type_activite varchar(45)                  NOT NULL default 'non classé'
);
-- séquence auto-incrémentant l'ID activité
create sequence seq_activity start with 1 increment by 1;

-- liaison utilisateur-agenda: ID de l'utilisateur et de l'agenda, évaluation de l'agenda par l'utilisateur, indicateurs si l'utilisateur peut modifier l'agenda et s'il en est le créateur
CREATE TABLE if not exists UTILISATEUR_agenda(
    idUtilisateur int(10) not null references UTILISATEUR,
    idAgenda int(10) not null references agenda,
    evaluation int(1) default null,
    evalue_a timestamp default null,
    bool_modifier boolean                       NOT NULL,
    idcreateur int(10)                       NOT NULL,
    -- vérification si l'évaluation est entre 1 et 5
    constraint Etoiles_donnees check (evaluation between 1 and 5)
);

-- liaison agenda-activité
CREATE TABLE if not exists agenda_ACTIVITE(
    idAgenda int(10) not null references agenda,
    idActivite int(10) not null references ACTIVITE,
    nboccurrences int(10)                    NOT NULL DEFAULT 1,
    debut DATE                                  NOT NULL,
    fin DATE                                    NOT NULL,
    periodicite varchar(45)                    NOT NULL DEFAULT 'unique',
    -- vérifications si le nombre d'occurences est strictement positif, si la date de fin est après celle de début, et si la péiodicité est bien définie parmi ces 5 choix
    constraint Nombre_occurences check( nboccurrences >0),
    constraint Coherence_dates check( debut <= fin),
    constraint Existence_periodicite check (periodicite='unique' or periodicite='hebdomadaire' or periodicite='mensuel' or periodicite='semestriel' or periodicite='annuel')
);

--liaison utilisateur-activité
CREATE TABLE if not exists UTILISATEUR_ACTIVITE(
    idUtilisateur int(10) not null references UTILISATEUR,
    idActivite int(10) not null references ACTIVITE
);

------------------------------------------------- insertions -------------------------------------------------
INSERT INTO UTILISATEUR VALUES 
(seq_user.nextval,'Duran','Mike','Schulstrasse 17c','mike.duran@hotmail.de','dragonball',"2019-10-07",1),/*1*/
(seq_user.nextval,'GIGGA','DRILL','KAMINA CITY 13','giga.drill@hotmail.fr','jdjgcgcgt',"2019-06-07",0),/*2*/
(seq_user.nextval,'Matry','Laure','vinsonheim','laure.matry@hotmail.fr','madokamagicalgirl',"2019-05-07",0),/*3*/
(seq_user.nextval,'Babouri','Maeva','Maler becker 25','maeva.babouri@hotmail.fr','judas',"2019-04-07",0),/*4*/
(seq_user.nextval,'Stark','Tony','malibu seventeen 22','tony.stark@hotmail.am','iron man',"2019-09-07",1),/*5*/
(seq_user.nextval,'Parker','Peter','queens devil 1','peter.parker@hotmail.am','spiderman',"2019-08-07",1),/*6*/
(seq_user.nextval,'KALOUMVUATI','Duramana','qqpart a strasbourg','kaloumvuati.duramana@hotmail.fr','genie',"2019-07-23",1);/*7*/
(seq_user.nextval,'Stephen','S. Knaus','2705 Patterson Fork Road','4hitesh2099i@emasqiuqiu.info','diiiiii',"2019-04-07",0);/*8*/
(seq_user.nextval,'Ray ','J. Goodale','miraie eeeeh 28','4h9i@emu.info','jds',"2019-04-07",0);/*9*/


INSERT INTO agenda VALUES 
(seq_agenda.nextval,"MARVEL",2,0,0,1), /*1*/
(seq_agenda.nextval,"DC_COMICS",1,0,0,2),/*2*/
(seq_agenda.nextval,"Universite",1,0,0, 3),/*3*/
(seq_agenda.nextval,"FIFA",2,0,0, 4);/*4*/
update agenda set nbActivites=4;

INSERT INTO ACTIVITE VALUES
(seq_activity.nextval,"Infinity war","la guerre de l'infini",true,1,1,0,'comic'),/*1*/
(seq_activity.nextval,"ENDGAME","la fin du game",true,1,2,0,'comic'),/*2*/
(seq_activity.nextval,"SUPERMAN VS BATMAN","la guerre des heros",true,1,3,0,"comic"),/*3*/ 
(seq_activity.nextval,"far from home","on part en vacance",true,1,1,0,'film'),/*4*/
(seq_activity.nextval,"HACKTAFAC","ecire une idée révolutionaire pour l'université",false,1,4,0,"compétition"),/*5*/
(seq_activity.nextval,"Match de foot","<EVIDENT>",false,1,1,0,"sport"),/*6*/
(seq_activity.nextval,"Match de Tennis","<EVIDENT>",false,1,0,0,"sport"),/*7*/
(seq_activity.nextval,"Match de Handball","<EVIDENT>",false,1,3,0,"sport");/*8*/

INSERT INTO UTILISATEUR_ACTIVITE VALUES
(5,1),
(5,2),
(6,1),
(6,2),
(6,4),
(1,5),
(7,6);

INSERT INTO agenda_ACTIVITE VALUES
(1,1,1,'2006-12-30','2009-12-30','hebdomadaire'),
(1,2,1,'2010-12-30','2012-12-30','mensuelle'),
(2,3,1,'2013-12-30','2014-12-30','hebdomadaire'),
(1,4,1,'2015-01-30','2015-06-30','mensuelle'),
(2,4,1,'2015-07-30','2015-12-30','hebdomadaire');

INSERT INTO UTILISATEUR_agenda VALUES
(1,3,5,1,1),
(3,3,3,0,1),
(7,3,1,0,1),
(5,1,5,1,5),
(6,1,5,0,5),
(7,4,5,1,7),
(5,3,5,1,1),
(6,3,4,0,1);

-------------------------------------------------- requêtes --------------------------------------------------
-- nombre d'activités des agendas par catégorie & par utilisateur
SELECT U.nom , A.type_activite, COUNT(UA.idActivite)
FROM Utilisateur U 
INNER JOIN UTILISATEUR_ACTIVITE UA 
ON U.idUtilisateur=UA.idUtilisateur
INNER JOIN ACTIVITE A 
ON A.idActivite=UA.idActivite
GROUP BY A.type_activite, U.idUtilisateur;

-- nombre d'évaluations totales pour les utilisateurs actifs
select u.idUtilisateur, COUNT(DISTINCT u.evaluation) 
from UTILISATEUR_agenda u 
where u.idUtilisateur in (select i.idUtilisateur FROM UTILISATEUR i where i.bool_actif=1) 
group by u.idUtilisateur ;

-- agendas avec au moins 5 évaluations moyennant à moins de 3/5
SELECT A.nomagenda
FROM UTILISATEUR_agenda UA 
INNER JOIN ACTIVITE A 
ON A.idActivite= UA.idActivite
GROUP BY UA.idAgenda
HAVING count(UA.evaluation)>=5 AND AVG(UA.evaluation) >=3;

-- agenda au plus grand nombre d'activités par semaine
select my_select.nomagenda -- myselect? 
from (
    SELECT a.nomAgenda, COUNT(AA.idActivite) as nbr
    FROM Agenda A 
    INNER JOIN AGENDA_ACTIVITE AA 
    ON A.idAgenda=AA.idAgenda
    INNER JOIN OCCURRENCE O 
    ON AA.idActivite=O.idActivite
    WHERE lower(O.periodicite) like 'h%'
    group by A.idActivite
)my_select
HAVING MAX(nbr);

-- login, nom, prénom, adresse, nombre d'agendas, nombre d'activités et nombre d'évaluations de chaque utilisateur
SELECT UA.idUtilisateur,u.nom,u.prenom,u.adresse,u.email,count(UA.idAgenda) as nbr_agendas, count(UA.evaluation) as nbr_evaluation
from UTILISATEUR_agenda UA RIGHT JOIN UTILISATEUR u 
ON UA.idUtilisateur=u.idUtilisateur
GROUP by u.idUtilisateur; 

/*le petit + utile: 
https://stackoverflow.com/questions/3804279/base64-encoding-and-decoding-in-oracle
select utl_raw.cast_to_varchar2(utl_encode.base64_encode(utl_raw.cast_to_raw(password))) from dual;*/

------------------------------------------------- procédures -------------------------------------------------
-- conversion d'une activité au format CSV
-- TO VERIFY
create or replace function convert (activity ACTIVITE.idActivite%TYPE) return varchar2(4096) is
    cursor activity_cur is
        select * from ACTIVITE where idActivite=activity;
    declare
        to_convert activity_cur%ROWTYPE;
    begin
        open activity_cur;
        SET LINESIZE 1024 TRIMSPOOL ON PAGESIZE 0 FEEDBACK OFF

        SPOOL ./test.csv
        loop
            fetch activity_cur into to_convert;
        end loop
        select idActivite || ',' || titre || ',' || descriptif || ',' || geographie || ',' || bool_pause || ',' || priorite || ',' || bool_archive || ',' || type_activite from to_convert order by idActivite;
        SPOOL OFF

        SET PAGESIZE 10
        close activity_cur;
    end
/

-- fusion de plusieurs agendas
-- TODO
create or replace procedure fuse_agendas (n integer) is
    begin
        
    end
/

-- création d'une activité inférée à partir d'agendas existants
-- TO VERIFY
create or replace procedure infere_activite (activity ACTIVITE.idActivite%TYPE, agenda_inf agenda.idAgenda%TYPE, report_d date, report_f date) is
    begin
        insert into agenda_ACTIVITE values (idAgenda, idActivite, 1, report_d, report_f, 'unique');
    end
/

-- TO FINISH
create or replace procedure archive_agendas (currentDate date) is
    cursor past_cur is
        select * from where -sysdate<0;
    declare
        past_agendas past_cur%ROWTYPE;
    begin
        open past_cur;
        loop
            fetch past_cur into past_agendas;
            update agenda set bool_archive=true where idAgenda = past_agendas.idAgenda;
        end loop;
        close past_cur;
    end
/

-------------------------------------------------- triggers --------------------------------------------------
-- 50 activités max par agenda
/**
 *! DÉPLACÉE DANS LA TABLE agenda - STATICITÉ POSSIBLE
 */
/*create or replace trigger maximum_activites before insert of idAgenda on agenda_ACTIVITE
    for each row
    declare
        compte integer;
        maj integer;
    begin
        select into compte a.nbActivites from agenda a join AGENDA_ACTIVITE aa on a.idAgenda=aa.idAgenda;
        if((compte>50) && (maj-add_days(sysdate,-7)<0)) then
            raise_application_error(-20466, "Erreur: trop d'activités pour cet agenda");
        end if
    end
/*/

--archivage
-- TODO
create or replace trigger archivage_avant_suppression before delete on agenda_ACTIVITE
    for each row
    begin

    end
/

--correspondance entre le nombre d'activités présentes dans l'agenda et la périodicité indiquée pour l'activité
-- TO COMPLETE
create or replace trigger check_if_corresponding before update on AGENDA_ACTIVITE
    begin
        select a.nbActivites from agenda a join AGENDA_ACTIVITE aa on a.idAgenda=aa.idAgenda;
        if(/*condition d'incohérernce*/) then
            raise_application_error(-20876, "La périodicité et le nombre d'activités présentes dans cet agenda ne correspondent pas.");
        end if
    end
/

--interdiction de la superposition de 2 activités quand l'agenda n'est pas superposable
-- TO COMPLETE - staticité possible?
create or replace trigger no_superposition before update on AGENDA_ACTIVITE
    begin
        raise_application_error(-20467, "Non superposable!");
    end
/

--anti-spam
-- TO VERIFY
create or replace trigger no_spam before update of evaluation on UTILISATEUR_agenda
    declare
        enregistrement date;
    begin
        if((extract(minutes from current_timestamp)-extract(minutes from evalue_a)<5) and (enregistrement-add_days(sysdate,-7)<0)) then
            raise_application_error(-20466, "WOW! ne spammez pas!");
        end if
    end
/