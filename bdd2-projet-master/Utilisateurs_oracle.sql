CREATE TABLE "UTILISATEUR" (
  "idutilisateur" VARCHAR(42),
  "nom" VARCHAR(42),
  "prenom" VARCHAR(42),
  "adresse" VARCHAR(42),
  "email" VARCHAR(42),
  "password" VARCHAR(42),
  "derniere_activite" VARCHAR(42),
  "bool_actif" VARCHAR(42),
  "enregistre_le" VARCHAR(42),
  PRIMARY KEY ("idutilisateur")
);

CREATE TABLE "INTERAGIT_AVEC" (
  "idutilisateur" VARCHAR(42),
  "idagenda" VARCHAR(42),
  "note" VARCHAR(42),
  "date_evaluation" VARCHAR(42),
  "peut_modifier" VARCHAR(42),
  "createur" VARCHAR(42),
  PRIMARY KEY ("idutilisateur", "idagenda")
);

CREATE TABLE "AGENDA" (
  "idagenda" VARCHAR(42),
  "nomagenda" VARCHAR(42),
  "priorite" VARCHAR(42),
  "maj" VARCHAR(42),
  "superposabilite" VARCHAR(42),
  "archive" VARCHAR(42),
  "nombre_activites" VARCHAR(42),
  PRIMARY KEY ("idagenda")
);

CREATE TABLE "EST_INSCRIT_DANS" (
  "idutilisateur" VARCHAR(42),
  "idactivite" VARCHAR(42),
  PRIMARY KEY ("idutilisateur", "idactivite")
);

CREATE TABLE "ACTIVITE" (
  "idactivite" VARCHAR(42),
  "titre" VARCHAR(42),
  "descriptif" VARCHAR(42),
  "lieu" VARCHAR(42),
  "pause" VARCHAR(42),
  "priorite" VARCHAR(42),
  "archive" VARCHAR(42),
  "type" VARCHAR(42),
  "nombre_occurences" VARCHAR(42),
  "debut" VARCHAR(42),
  "fin" VARCHAR(42),
  "periodicite" VARCHAR(42),
  PRIMARY KEY ("idactivite")
);

CREATE TABLE "INCLUT" (
  "idagenda" VARCHAR(42),
  "idactivite" VARCHAR(42),
  PRIMARY KEY ("idagenda", "idactivite")
);

ALTER TABLE "INTERAGIT_AVEC" ADD FOREIGN KEY ("idagenda") REFERENCES "AGENDA" ("idagenda");
ALTER TABLE "INTERAGIT_AVEC" ADD FOREIGN KEY ("idutilisateur") REFERENCES "UTILISATEUR" ("idutilisateur");
ALTER TABLE "EST_INSCRIT_DANS" ADD FOREIGN KEY ("idactivite") REFERENCES "ACTIVITE" ("idactivite");
ALTER TABLE "EST_INSCRIT_DANS" ADD FOREIGN KEY ("idutilisateur") REFERENCES "UTILISATEUR" ("idutilisateur");
ALTER TABLE "INCLUT" ADD FOREIGN KEY ("idactivite") REFERENCES "ACTIVITE" ("idactivite");
ALTER TABLE "INCLUT" ADD FOREIGN KEY ("idagenda") REFERENCES "AGENDA" ("idagenda");