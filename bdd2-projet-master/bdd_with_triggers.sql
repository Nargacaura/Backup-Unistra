-- Projet BDD par Duran Mike & Ledda Damien

-- Pour le spool sur PL/SQL
set sqlblanklines on

----------------------------------------------- suppressions --------------------------------------------------

-- supression des triggers
drop trigger AGENDAS_ACTIVITE_NBRACTIVITE;
drop trigger ONLINE_USERS_date_modification;
drop trigger no_spam;
drop trigger no_superposition;
drop trigger check_if_corresponding;
drop trigger archivage_suppr_activite;
drop trigger archivage_suppr_agenda;
drop trigger maximum_activites;

-- suppression des procédures
drop procedure archive_agendas;
drop procedure infere_activite;
drop procedure fuse_agendas;
drop function convert_to_csv;

-- supression des tables
drop table arch_agendas;
drop table arch_activite;
drop table AGENDAS_ACTIVITE;
drop table ONLINE_USERS_AGENDAS;
drop table ONLINE_USERS_ACTIVITE;
drop table ACTIVITE;
drop table ONLINE_USERS;
drop table AGENDAS;

-- supression des sequences
drop sequence seq_ONLINE_USERS;
drop sequence seq_agenda;
drop sequence seq_activity;

------------------------------------------------- création ----------------------------------------------------

-- utilisateur: ID, nom, prénom, adresse physique, mail & mot de passe
CREATE table ONLINE_USERS(
    idONLINE_USERS          number(10)      primary key,
    nom                     varchar2(45)    NOT NULL,
    prenom                  varchar2(45)    NOT NULL,
    adresse                 varchar2(245)   NOT NULL,
    email                   varchar2(200)   not null,
    mot_de_passe            varchar2(45)    NOT NULL,
    derniere_modification   DATE            NOT NULL,
    bool_actif              number(1)       default 1,
    enregistre_le           date            default sysdate
);

-- vérification (et mise à jour) de l'activité de l'utilisateur
create or replace TRIGGER ONLINE_USERS_date_modification 
after UPDATE on ONLINE_USERS 
declare 
    cursor ONLINE_USERS_cur is select nom,IDONLINE_USERS ,DERNIERE_MODIFICATION ,BOOL_ACTIF from ONLINE_USERS;
    row_ONLINE_USERS ONLINE_USERS_cur%ROWTYPE;
begin 
    open ONLINE_USERS_cur;
    loop
        fetch ONLINE_USERS_cur into row_ONLINE_USERS;
        if(row_ONLINE_USERS.derniere_modification <= add_months(sysdate,-3))
        then
            UPDATE ONLINE_USERS SET bool_actif=0 where idONLINE_USERS=row_ONLINE_USERS.idONLINE_USERS;
            DBMS_OUTPUT.put_line(row_ONLINE_USERS.nom ||' devenu inactif' );
        elsif(row_ONLINE_USERS.derniere_modification > add_months(sysdate,-3))
        then 
            UPDATE ONLINE_USERS SET bool_actif=1 WHERE idONLINE_USERS=row_ONLINE_USERS.idONLINE_USERS;
            dbms_output.put_line(row_ONLINE_USERS.nom ||' devenu actif' );
        end if;
    end loop;
    close ONLINE_USERS_cur;
end;
/

-- agenda: ID, nom, priorité, superposabilité, état
CREATE TABLE  AGENDAS (
    idAgenda        number(10)      primary key,
    nomAgenda       varchar2(45)    NOT NULL,
    priorite        number(2)       NOT NULL,
    mise_a_jour     date            default sysdate,
    bool_superpose  number(1)       NOT NULL,
    bool_archive    number(1)       NOT NULL,
    nbActivite      number(2)       default 0,

    constraint AGENDAS_ACTIVITE_superpose   check ((bool_superpose=1) or (bool_superpose=0)),   
    constraint AGENDAS_ACTIVITE_archive     check ((bool_archive=1) or (bool_archive=0))
);

-- archives d'agendas | utile pour l'archivage
create table arch_agendas as (select * from agendas where bool_archive=1);

-- activité: ID, titre, description, lieu, indicateur de pause, priorité, état, catégorie
CREATE TABLE ACTIVITE (
    idActivite      number(10)      primary key,
    titre           varchar2(45)    NOT NULL,
    descriptif      varchar2(45)    NOT NULL,
    geographie      varchar2(45)    default 'Twilight Zone',
    bool_pause      number(1)       default 0,
    priorite        number(2)       NOT NULL,
    bool_archive    number(1)       NOT NULL,
    type_activite   varchar2(45)    default 'non classé',
    nboccurrences   number(10)      DEFAULT 1,
    debut           DATE            NOT NULL,
    fin             DATE            NOT NULL,
    periodicite     varchar2(45)    DEFAULT 'unique',

    -- vérifications si le nombre d'occurences est strictement positif, si la date de fin est après celle de début, et si la péiodicité est bien définie parmi ces 5 choix
    constraint Nombre_occurences        check (nboccurrences > 0),
    constraint Coherence_dates          check (debut <= fin),
    constraint Existence_periodicite    check (periodicite in ('unique', 'hebdomadaire', 'mensuel', 'semestriel', 'annuel'))
    );

-- archives d'activités | utile pour l'archivage
create table arch_activite as (select * from activite where bool_archive=1);

-- liaison ONLINE_USERS-agenda: ID de l'ONLINE_USERS et de l'agenda, évaluation de l'agenda par l'ONLINE_USERS, indicateurs si l'ONLINE_USERS peut modifier l'agenda et s'il en est le créateur
CREATE TABLE ONLINE_USERS_AGENDAS(
    idONLINE_USERS  number(10)  not null        references ONLINE_USERS,
    idAgenda        number(10)  not null        references AGENDAS,
    evaluation      number(1)   default null,
    evalue_a        timestamp   default null,
    bool_modifier   number(1)   NOT NULL,
    idcreateur      number(10)  NOT NULL,

    -- vérification des permissions de modifications
    constraint Peut_modifier    check (bool_modifier=1 or bool_modifier=0),

    -- vérification si l'évaluation est entre 1 et 5
    constraint Etoiles_donnees  check (evaluation between 1 and 5)
);

-- liaison agenda-activité
CREATE TABLE  AGENDAS_ACTIVITE(
    idAgenda    number(10) not null references AGENDAS,
    idActivite  number(10) not null references ACTIVITE
);

--liaison ONLINE_USERS-activité
CREATE TABLE ONLINE_USERS_ACTIVITE(
    idONLINE_USERS  number(10) not null references ONLINE_USERS,
    idActivite      number(10) not null references ACTIVITE
);

-- séquence qui auto-incrémentera l'ID ONLINE_USERS
create sequence seq_ONLINE_USERS start with 1 increment by 1;

-- séquence auto-incrémentant l'ID activité
create sequence seq_activity start with 1 increment by 1;

-- séquence auto-incrémentant l'ID agenda
create sequence seq_agenda start with 1 increment by 1;

---------- insertions | note: seq_table.nextval donne d'abord sa valeur actuelle avant d'incrémenter ----------
-- Note: ce ne sont que des exemples, ils peuvent être modifiés si la volonté est de changer certaines valeurs à insérer.

-- utilisateurs
INSERT INTO ONLINE_USERS(idONLINE_USERS,nom ,prenom ,adresse ,email ,mot_de_passe ,derniere_modification) VALUES
(seq_ONLINE_USERS.nextval,'Duran','Mike','Schulstrasse 17c','mike.duran@hotmail.de','dragonball',TO_DATE('2019/10/07 ','yyyy/mm/dd'));
INSERT INTO ONLINE_USERS(idONLINE_USERS,nom ,prenom ,adresse ,email ,mot_de_passe ,derniere_modification ) VALUES
(seq_ONLINE_USERS.nextval,'GIGGA','DRILL','KAMINA CITY 13','giga.drill@hotmail.fr','jdjgcgcgt',TO_DATE('2019/06/07','yyyy/mm/dd'));
INSERT INTO ONLINE_USERS(idONLINE_USERS,nom ,prenom ,adresse ,email ,mot_de_passe ,derniere_modification) VALUES
(seq_ONLINE_USERS.nextval,'Matry','Laure','vinsonheim','laure.matry@hotmail.fr','madokamagicalgirl',TO_DATE('2019/05/07','yyyy/mm/dd'));
INSERT INTO ONLINE_USERS(idONLINE_USERS,nom ,prenom ,adresse ,email ,mot_de_passe ,derniere_modification) VALUES
(seq_ONLINE_USERS.nextval,'Babouri','Maeva','Maler becker 25','maeva.babouri@hotmail.fr','judas',TO_DATE('2019/04/07','yyyy/mm/dd'));
INSERT INTO ONLINE_USERS(idONLINE_USERS,nom ,prenom ,adresse ,email ,mot_de_passe ,derniere_modification) VALUES
(seq_ONLINE_USERS.nextval,'Stark','Tony','malibu seventeen 22','tony.stark@hotmail.am','iron man',TO_DATE('2019/09/07','yyyy/mm/dd'));
INSERT INTO ONLINE_USERS(idONLINE_USERS,nom ,prenom ,adresse ,email ,mot_de_passe ,derniere_modification) VALUES
(seq_ONLINE_USERS.nextval,'Parker','Peter','queens devil 1','peter.parker@hotmail.am','spiderman',TO_DATE('2019/08/07','yyyy/mm/dd'));
INSERT INTO ONLINE_USERS(idONLINE_USERS,nom ,prenom ,adresse ,email ,mot_de_passe ,derniere_modification) VALUES
(seq_ONLINE_USERS.nextval,'KALOUMVUATI','Duramana','qqpart a strasbourg','kaloumvuati.duramana@hotmail.fr','genie',TO_DATE('2019/07/23','yyyy/mm/dd'));
INSERT INTO ONLINE_USERS(idONLINE_USERS,nom ,prenom ,adresse ,email ,mot_de_passe ,derniere_modification ) VALUES
(seq_ONLINE_USERS.nextval,'Stephen','S. Knaus','2705 Patterson Fork Road','4hitesh2099i@emasqiuqiu.info','diiiiii',TO_DATE('2019/04/07','yyyy/mm/dd'));
INSERT INTO ONLINE_USERS(idONLINE_USERS,nom ,prenom ,adresse ,email ,mot_de_passe ,derniere_modification) VALUES
(seq_ONLINE_USERS.nextval,'Ray ','J. Goodale','miraie eeeeh 28','4h9i@emu.info','jds',TO_DATE('2019/04/07','yyyy/mm/dd'));

-- agendas
INSERT INTO AGENDAS(idagenda,nomagenda,priorite,bool_superpose,bool_archive) VALUES (seq_agenda.nextval ,'MARVEL' ,2 ,0 ,0 );
INSERT INTO AGENDAS(idagenda,nomagenda,priorite,bool_superpose,bool_archive) VALUES (seq_agenda.nextval ,'DC_COMICS' ,1 ,0 ,0 );
INSERT INTO AGENDAS(idagenda,nomagenda,priorite,bool_superpose,bool_archive) VALUES (seq_agenda.nextval ,'Universite' ,1 ,0 ,0 );
INSERT INTO AGENDAS(idagenda,nomagenda,priorite,bool_superpose,bool_archive) VALUES (seq_agenda.nextval ,'FIFA' ,2 ,0 ,0 );

-- activités
INSERT INTO ACTIVITE VALUES (seq_activity.nextval,'Infinity war','la guerre de l"infini',NULL,1,1,0,'comic',1,TO_DATE('2006/12/30','yyyy/mm/dd'),TO_DATE('2009/12/30','yyyy/mm/dd'),'hebdomadaire');
INSERT INTO ACTIVITE VALUES (seq_activity.nextval,'ENDGAME','la fin du game',NULL,1,2,0,'comic',1,TO_DATE('2010/12/30','yyyy/mm/dd'),TO_DATE('2012/12/30','yyyy/mm/dd'),'mensuel');
INSERT INTO ACTIVITE VALUES (seq_activity.nextval,'SUPERMAN VS BATMAN','la guerre des heros',NULL,1,3,0,'comic',1,TO_DATE('2013/12/30','yyyy/mm/dd'),TO_DATE('2014/12/30','yyyy/mm/dd'),'hebdomadaire');
INSERT INTO ACTIVITE VALUES (seq_activity.nextval,'far from home','on part en vacance',NULL,1,1,0,'film',1,TO_DATE('2015/01/30','yyyy/mm/dd'),TO_DATE('2015/06/30','yyyy/mm/dd'),'mensuel');
INSERT INTO ACTIVITE VALUES (seq_activity.nextval,'HACKTAFAC','ecire une idée pour l"université',NULL,1,4,0,'compétition',1,TO_DATE('2015/07/30','yyyy/mm/dd'),TO_DATE('2015/12/30','yyyy/mm/dd'),'hebdomadaire');
INSERT INTO ACTIVITE VALUES (seq_activity.nextval,'Match de foot','<EVIDENT>',NULL,1,1,0,'sport',1,TO_DATE('2016/01/30','yyyy/mm/dd'),TO_DATE('2016/12/30','yyyy/mm/dd'),'mensuel');
INSERT INTO ACTIVITE VALUES (seq_activity.nextval,'Match de Tennis','<EVIDENT>',NULL,1,0,0,'sport',1,TO_DATE('2017/03/30','yyyy/mm/dd'),TO_DATE('2017/08/30','yyyy/mm/dd'),'hebdomadaire');
INSERT INTO ACTIVITE VALUES (seq_activity.nextval,'Match de Handball','<EVIDENT>',NULL,1,3,0,'sport',1,TO_DATE('2018/04/30','yyyy/mm/dd'),TO_DATE('2018/12/30','yyyy/mm/dd'),'mensuel');

-- liaison utilisateurs-activités
INSERT INTO ONLINE_USERS_ACTIVITE VALUES (5,1);
INSERT INTO ONLINE_USERS_ACTIVITE VALUES (5,2);
INSERT INTO ONLINE_USERS_ACTIVITE VALUES (6,1);
INSERT INTO ONLINE_USERS_ACTIVITE VALUES (6,2);
INSERT INTO ONLINE_USERS_ACTIVITE VALUES (6,4);
INSERT INTO ONLINE_USERS_ACTIVITE VALUES (1,5);
INSERT INTO ONLINE_USERS_ACTIVITE VALUES (7,6);

-- mise à jour du nombre d'activités dans un agenda
create or replace trigger Agendas_activite_nbrActivite
AFTER INSERT on AGENDAS_ACTIVITE
for each row
begin  
    UPDATE AGENDAS 
    SET nbACTIVITE=nbactivite + 1
    where idAGenda=:new.idAgenda;

end;
/

-- liaison agendas-activités
INSERT INTO AGENDAS_ACTIVITE VALUES (1,1);
INSERT INTO AGENDAS_ACTIVITE VALUES (1,2);
INSERT INTO AGENDAS_ACTIVITE VALUES (2,3);
INSERT INTO AGENDAS_ACTIVITE VALUES (1,4);
INSERT INTO AGENDAS_ACTIVITE VALUES (2,4);

-- liaisons agendas-utilisateurs
INSERT INTO ONLINE_USERS_AGENDAS (idONLINE_USERS,idAgenda,evaluation,bool_modifier,idcreateur) VALUES (1,3,5,1,1);
INSERT INTO ONLINE_USERS_AGENDAS (idONLINE_USERS,idAgenda,evaluation,bool_modifier,idcreateur) VALUES (3,3,3,0,1);
INSERT INTO ONLINE_USERS_AGENDAS (idONLINE_USERS,idAgenda,evaluation,bool_modifier,idcreateur) VALUES (7,3,1,0,1);
INSERT INTO ONLINE_USERS_AGENDAS (idONLINE_USERS,idAgenda,evaluation,bool_modifier,idcreateur) VALUES (5,1,5,1,5);
INSERT INTO ONLINE_USERS_AGENDAS (idONLINE_USERS,idAgenda,evaluation,bool_modifier,idcreateur) VALUES (6,1,5,0,5);
INSERT INTO ONLINE_USERS_AGENDAS (idONLINE_USERS,idAgenda,evaluation,bool_modifier,idcreateur) VALUES (7,4,5,1,7);
INSERT INTO ONLINE_USERS_AGENDAS (idONLINE_USERS,idAgenda,evaluation,bool_modifier,idcreateur) VALUES (5,3,5,1,1);
INSERT INTO ONLINE_USERS_AGENDAS (idONLINE_USERS,idAgenda,evaluation,bool_modifier,idcreateur) VALUES (6,3,4,0,1);

--------------------------------------------------- requêtes --------------------------------------------------
-- nombre d'activités des agendas par catégorie & par utilisateur
SELECT idONLINE_USERS as utilisateur ,A.type_activite as categorie, COUNT(OA.idActivite) as nbr_activite
FROM ONLINE_USERS_ACTIVITE OA, activite A
where OA.idactivite=A.idActivite
GROUP BY idONLINE_USERS, A.type_activite;

-- nombre d'évaluations totales pour les utilisateurs actifs
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
   

-- login, nom, prénom, adresse, nombre d'agendas, nombre d'activités et nombre d'évaluations de chaque utilisateur
SELECT UA.idONLINE_USERS as login,u.nom,u.prenom,u.adresse,u.email,count(UA.idAgenda) as nbr_agendas, count(UA.evaluation) as nbr_evaluation
from ONLINE_USERS_AGENDAS UA RIGHT JOIN ONLINE_USERS u 
ON UA.idONLINE_USERS=u.idONLINE_USERS
GROUP by u.idONLINE_USERS, UA.idONLINE_USERS, u.nom, u.prenom, u.adresse, u.email; 

--------------------------------------------------- procédures ------------------------------------------------
-- conversion d'une activité au format CSV
create or replace function convert_to_csv (activity ACTIVITE.idActivite%TYPE) 
return varchar2
is
act_rec ACTIVITE%ROWTYPE;
v_return varchar2(4096);    
    begin
        select /*csv*/ IDACTIVITE ,TITRE ,DESCRIPTIF ,GEOGRAPHIE ,BOOL_PAUSE ,PRIORITE ,BOOL_ARCHIVE ,TYPE_ACTIVITE ,NBOCCURRENCES ,DEBUT ,FIN ,PERIODICITE  
        into act_rec
        from activite where idActivite=activity;
       v_return := act_rec.IDACTIVITE  ||','|| act_rec.TITRE ||','|| act_rec.DESCRIPTIF ||','|| act_rec.GEOGRAPHIE 
       ||','|| act_rec.BOOL_PAUSE ||','|| act_rec.PRIORITE ||','|| act_rec.BOOL_ARCHIVE ||','|| act_rec.TYPE_ACTIVITE 
       ||','|| act_rec.NBOCCURRENCES ||','|| act_rec.DEBUT ||','|| act_rec.FIN ||','|| act_rec.PERIODICITE  ;
       return v_return;
    end;
/

--Exemple d'exécution
spool "test.csv";
select convert_to_csv(1) from dual;
spool off;

-- fusion de plusieurs agendas, on va prendre les n premiers agendas et on les fusionne en un nouvel agenda
create or replace procedure fuse_agendas (n int) is 
    priori INT;
    nbr_ag INT;
    var_cur AGENDAS_ACTIVITE%ROWtype;
    temp_id_agenda AGENDAS_ACTIVITE.idagenda%type;
    id_new_agenda AGENDAS_ACTIVITE.idagenda%type;
    i int;
    new_ag_name varchar2(200);
    counter_double int;
    begin
    --test si le nombre d'agenda est inferieur ou egale à n
    Select count(distinct idagenda) into nbr_ag
    from agendas_activite;
    
    if n > nbr_ag 
    then 
        raise_application_error(-20333, ' ERR: n est trop élevé.');
    end if;
     
        
    --INITIALISATION DE LA NOUVELLE TABLE;
    select MAX(priorite) into priori from agendas;
    id_new_agenda:=  seq_agenda.nextval;
    new_ag_name := 'new_agenda_' || to_char(id_new_agenda) ;
    INSERT INTO AGENDAS values (id_new_agenda,new_ag_name,priori+1,sysdate,0,0,0);
    
    --lancement du parcours
    i:=0;
    for var_cur in (select * from agendas_activite order by idagenda,idactivite)
    LOOP
        if i<=n then
        --si l'identifant de l'agenda est différent du précédent alors c'est un nouveau agenda.
            if temp_id_agenda != var_cur.idagenda then
                temp_id_agenda:= var_cur.idagenda;   
                i:=i+1;
            end if;
        --on attrape chaque ligne qui appartient a temp_id_agenda
        select COUNT(*) into counter_double 
        from agendas_activite 
        where idagenda=id_new_agenda and idactivite=var_cur.idactivite;
        if counter_double=0 then
            INSERT INTO AGENDAS_ACTIVITE values (id_new_agenda , var_cur.idactivite);
        end if;
        end if;
    END LOOP;
    end;
/

--Exemple d'exécution
exec fuse_agendas(2);

select * from agendas;
select IDAGENDA ,
IDACTIVITE 
from agendaS_activite order by idagenda,idactivite;




-- création d'une activité inférée à partir d'agendas existants
-- TODO
create or replace procedure infere_activite (activity ACTIVITE.idActivite%TYPE) is
    begin
       -- insert into ACTIVITE values (seq_activity.nextval, , , , , , false, );
       
    end;
/

-- archivage des agendas
create or replace procedure archive_agendas is
begin
UPDATE AGENDAs
set bool_archive =1
where idagenda in (
select MLD.idagenda from (
                            select temp_table.* 
                            from (
                                     select A.idAgenda, count( ac.idactivite) as fins
                                     from AGENDAS_ACTIVITE AA, Agendas a , activite ac
                                     where aa.idagenda=a.idagenda and aa.idactivite=AC.idactivite
                                     group by a.idagenda
                                    )temp_table, agendas a       
                            where A.idagenda=temp_table.idagenda and a.nbactivite=temp_table.fins
                           )MLD);
    end;
/

-- Exemple d'exécution
execute archive_agendas;
select * from agendas;

--------------------------------------------------- triggers --------------------------------------------------
-- 50 activités max par agenda
create or replace trigger maximum_activites 
before insert on AGENDAS_ACTIVITE
    for each row
    declare
        compte AGENDAS.nbactivite%TYPE;       
    begin
        select nbactivite into compte from AGENDAS where idagenda=:new.idagenda;
        if(compte>50)
           then raise_application_error(-20466, 'ERR:trop dact pour agenda');
        end if;
    end;
/

--archivage
create or replace trigger archivage_suppr_activite before delete on ACTIVITE
    for each row
    begin
-- il faut effacer l'agenda partout où il peut etre lié
    delete from agendaS_activite where idActivite=:old.idActivite;
    delete from Online_Users_activite where idActivite=:old.idActivite;
--on l'insere dans l'archive respective
    insert into arch_activite values(:old.idactivite,:old.titre,:old.descriptif ,:old.geographie,:old.bool_pause,:old.priorite,:old.bool_archive,:old.type_activite,:old.nboccurrences,:old.debut,:old.fin,:old.periodicite);
    end;
/

-- Exemple d'exécution
select * from activite;
delete from activite where idactivite=1;
select * from arch_activite;

create or replace trigger archivage_suppr_agenda 
before delete ON AGENDAS 
for each row begin 
-- il faut effacer l'agenda partout où il peut etre lié
    delete from online_users_agendas where idagenda=:old.idagenda; 
    delete from agendaS_activite where idagenda=:old.idagenda;
--on l'insere dans l'archive respective
    insert into arch_agendas values(:old.idAgenda,:old.nomAgenda,:old.priorite ,:old.mise_a_jour,:old.bool_superpose ,1,:old.nbActivite); 
end;
/

-- Exemple d'exécution
select * from agendas;
delete from agendas where idagenda=1;
select * from arch_agendas;


--interdiction de la superposition de 2 activités quand l'agenda n'est pas superposable
-- TO COMPLETE
create or replace trigger no_superposition before update on AGENDAS_ACTIVITE
    for each row
    declare
    activite_rec ACTIVITE%ROWTYPE;
    test_superpose int;
    var_debut ACTIVITE.debut%type;
    var_fin ACTIVITE.fin%type;
    begin        
        select bool_superpose into test_superpose
        from AGENDAS 
        where idagenda=:new.idagenda;
        
        select debut, fin into var_debut,var_fin
        from activite
        where idactivite=:new.idactivite;
        
        if test_superpose = 1 then 
            for activite_rec in (select debut,fin 
                                 from activite A inner join AGENDAS_ACTIVITE AA ON A.idactivite=AA.idactivite
                                 where AA.idagenda=:new.idagenda)
            LOOP
                if (activite_rec.debut <=var_debut and  var_fin <= activite_rec.fin) or (var_debut <= activite_rec.debut and  var_fin <= activite_rec.fin) 
                    or (activite_rec.debut <= var_debut and  activite_rec.fin  <= var_fin) or (var_debut <= activite_rec.debut and  activite_rec.fin  <= var_fin)  then  
                    raise_application_error(-20467, 'Agenda non superposable!');
                end if;
            END LOOP;
        end if;
    end;
/

select * from activite A inner join AGENDAS_ACTIVITE  AA ON  A.idactivite=AA.idactivite;

--correspondance entre le nombre d'activités présentes dans l'agenda et la périodicité indiquée pour l'activité
-- TO COMPLETE
create or replace trigger check_if_corresponding before update on AGENDAS_ACTIVITE
    begin
        raise_application_error(-20876, 'La périodicité et le nombre d"activités présentes dans cet agenda ne correspondent pas.');
    end;
/

--anti-spam
-- TO VERIFY
create or replace trigger no_spam before update of evaluation on ONLINE_USERS_AGENDAS
    declare
        enregistrement date;
        time_elapsed timestamp;
    begin
        select extract(minutes from evalue_a) into time_elapsed from online_users_agendas where idAgenda=:new.idAgenda;
        select extract(day from ou.enregistre_le) into enregistrement from ONLINE_USERS ou where ou.idONLINE_USERS=:new.idONLINE_USERS;
        if((extract(minutes from current_timestamp)-extract(minutes from time_elapsed)>-5) and (enregistrement-add_days(sysdate,-7)<0))
         then raise_application_error(-20466, 'WOW! ne spammez pas!');
        end if;
    end;
/