-- =================================================================================
-- PROJET : Analyse Exploratoire des Données (EDA) - Dataset Titanic
-- CONTEXTE : Stage CodeAlpha - Tâche 2
-- ANALYSTE : Dotu Othniel Aguidi
-- OBJECTIF : Explorer, nettoyer, transformer et extraire des insights de la table
--            des passagers du Titanic à l'aide de Google BigQuery.
-- =================================================================================

-- ---------------------------------------------------------------------------------
-- ÉTAPE 1 : EXPLORATION INITIALE ET COMPRÉHENSION DE LA STRUCTURE
-- Objectif : Auditer les dimensions du dataset, le type des colonnes et vérifier
--            la bonne importation de la table.
-- ---------------------------------------------------------------------------------

-- 4. Vérifiez que la table a bien été créée dans le schéma d'information
SELECT table_name 
FROM `gen-lang-client-0468058423.titanic`.INFORMATION_SCHEMA.TABLES 
WHERE table_name = 'passengers';

-- 5. Affichez les 10 premières lignes pour un aperçu visuel des données brutes
SELECT *
FROM `gen-lang-client-0468058423.titanic.passengers`
LIMIT 10;

-- 6. Comptez le nombre total de lignes (observations) et de colonnes (variables)
-- Cela permet de valider la volumétrie globale du jeu de données.
SELECT COUNT(*) AS total_passengers
FROM `gen-lang-client-0468058423.titanic.passengers`;

SELECT COUNT(*) AS nb_colonnes
FROM `gen-lang-client-0468058423.titanic`.INFORMATION_SCHEMA.COLUMNS
WHERE table_name = 'passengers';

-- 7. Identifiez le type de données de chaque colonne (numérique, textuelle, etc.)
-- Essentiel pour anticiper les fonctions de traitement de texte ou de calculs numériques.
SELECT column_name, data_type 
FROM `gen-lang-client-0468058423.titanic`.INFORMATION_SCHEMA.COLUMNS
WHERE table_name = 'passengers';


-- ---------------------------------------------------------------------------------
-- ÉTAPE 2 : ANALYSE STATISTIQUE DE BASE ET DESCRIPTIVE
-- Objectif : Déterminer la distribution des variables numériques et la cardinalité
--            des variables catégorielles clés.
-- ---------------------------------------------------------------------------------

-- 8. Calculez les statistiques de base (minimum, maximum, moyenne) pour Age et Fare
-- Permet de détecter les ordres de grandeur et d'éventuelles valeurs aberrantes (ex: Fare = 0).
SELECT
  MIN(Age) AS age_min,
  MAX(Age) AS age_max,
  AVG(Age) AS age_moyen,
  MIN(Fare) AS Fare_min,
  MAX(Fare) AS Fare_max,
  AVG(Fare) AS Fare_moyen
FROM `gen-lang-client-0468058423.titanic.passengers`;

-- 9. Comptez le nombre de valeurs distinctes (cardinalité) pour Pclass, Sex et Embarked
-- Valide la cohérence des catégories (ex: vérifier qu'il n'y a que 2 genres distincts textuels).
SELECT
  COUNT(DISTINCT Pclass) AS nb_class,
  COUNT(DISTINCT Sex) AS nb_sex,
  COUNT(DISTINCT Embarked) AS nb_embarked
FROM `gen-lang-client-0468058423.titanic.passengers`;


-- ---------------------------------------------------------------------------------
-- ÉTAPE 3 : AUDIT DE LA QUALITÉ DES DONNÉES (DATA QUALITY REPORT)
-- Objectif : Localiser précisément les données manquantes (NULL) ou vides ('')
--            afin de définir une stratégie de nettoyage adaptée.
-- ---------------------------------------------------------------------------------

-- 10. Identifiez de manière synthétique les colonnes contenant au moins une valeur manquante
WITH comptable AS (
  SELECT 'PassengerId' AS colonne, COUNTIF(PassengerId IS NULL) AS manquant FROM `gen-lang-client-0468058423.titanic.passengers` UNION ALL
  SELECT 'Survived', COUNTIF(Survived IS NULL) FROM `gen-lang-client-0468058423.titanic.passengers` UNION ALL
  SELECT 'Pclass', COUNTIF(Pclass IS NULL) FROM `gen-lang-client-0468058423.titanic.passengers` UNION ALL
  SELECT 'Name', COUNTIF(Name IS NULL) FROM `gen-lang-client-0468058423.titanic.passengers` UNION ALL
  SELECT 'Sex', COUNTIF(Sex IS NULL) FROM `gen-lang-client-0468058423.titanic.passengers` UNION ALL
  SELECT 'Age', COUNTIF(age IS NULL) FROM `gen-lang-client-0468058423.titanic.passengers` UNION ALL
  SELECT 'SibSp', COUNTIF(SibSp IS NULL) FROM `gen-lang-client-0468058423.titanic.passengers` UNION ALL
  SELECT 'Parch', COUNTIF(Parch IS NULL) FROM `gen-lang-client-0468058423.titanic.passengers` UNION ALL
  SELECT 'Ticket', COUNTIF(Ticket IS NULL) FROM `gen-lang-client-0468058423.titanic.passengers` UNION ALL
  SELECT 'Fare', COUNTIF(Fare IS NULL) FROM `gen-lang-client-0468058423.titanic.passengers` UNION ALL
  SELECT 'Cabin', COUNTIF(Cabin IS NULL) FROM `gen-lang-client-0468058423.titanic.passengers` UNION ALL
  SELECT 'Embarked', COUNTIF(embarked IS NULL) FROM `gen-lang-client-0468058423.titanic.passengers`
)
SELECT colonne, manquant
FROM comptable
WHERE manquant > 0;

-- 11. Générez un rapport de qualité détaillé comptabilisant les valeurs NULL et les chaînes vides
SELECT
  COUNTIF(PassengerId IS NULL) AS PassengerId_manquants,
  COUNTIF(Survived IS NULL) AS Survived_manquants,
  COUNTIF(Pclass IS NULL) AS Pclass_manquants,
  COUNTIF(Name IS NULL) AS Name_manquants,
  COUNTIF(Sex IS NULL) AS Sex_manquants,
  COUNTIF(Age IS NULL) AS Age_manquants,
  COUNTIF(SibSp IS NULL) AS SibSp_manquants,
  COUNTIF(Parch IS NULL) AS Parch_manquants,
  COUNTIF(Ticket IS NULL) AS Ticket_manquants,
  COUNTIF(Fare IS NULL) AS Fare_manquants,
  COUNTIF(Cabin IS NULL) AS Cabin_manquants,
  COUNTIF(Embarked IS NULL) AS Embarked_manquants
FROM `gen-lang-client-0468058423.titanic.passengers`;

SELECT
  COUNT(*) AS total_rows,
  SUM(CASE WHEN PassengerId IS NULL THEN 1 ELSE 0 END) +
  SUM(CASE WHEN Survived IS NULL THEN 1 ELSE 0 END) +
  SUM(CASE WHEN Pclass IS NULL THEN 1 ELSE 0 END) +
  SUM(CASE WHEN Age IS NULL THEN 1 ELSE 0 END) +
  SUM(CASE WHEN SibSp IS NULL THEN 1 ELSE 0 END) +
  SUM(CASE WHEN Parch IS NULL THEN 1 ELSE 0 END) +
  SUM(CASE WHEN Fare IS NULL THEN 1 ELSE 0 END) AS total_null_values,
  SUM(CASE WHEN Name = '' 
             OR Sex = '' 
             OR Ticket = '' 
             OR Cabin = '' 
             OR Embarked = '' THEN 1 ELSE 0 END) AS empty_strings
FROM `gen-lang-client-0468058423.titanic.passengers`;


-- ---------------------------------------------------------------------------------
-- ÉTAPE 4 : NETTOYAGE ET INGÉNIERIE DES CARACTÉRISTIQUES (FEATURE ENGINEERING)
-- Objectif : Traiter les valeurs manquantes, supprimer les doublons, standardiser
--            les formats et enrichir le dataset avec de nouvelles métriques.
-- ---------------------------------------------------------------------------------

-- 12. Stratégie d'imputation pour la colonne 'Age'
-- Remplacement des valeurs NULL par la moyenne globale d'âge pour maintenir la distribution.
SELECT
  IFNULL(Age, (SELECT AVG(Age) FROM `gen-lang-client-0468058423.titanic.passengers`)) AS Age
FROM `gen-lang-client-0468058423.titanic.passengers`;

-- 13. Stratégie d'imputation pour la colonne 'Embarked'
-- Remplacement des valeurs NULL par le "Mode" (le port le plus fréquent : 'S').
SELECT
  IFNULL(Embarked, (SELECT Embarked
     FROM `gen-lang-client-0468058423.titanic.passengers`
     WHERE Embarked IS NOT NULL
     GROUP BY Embarked
     ORDER BY COUNT(*) DESC
     LIMIT 1)) AS Embarked_mode
FROM `gen-lang-client-0468058423.titanic.passengers`;

-- 14. Détection et déduplication des données
-- Utilisation de ROW_NUMBER() indexé sur l'identifiant unique pour écarter les doublons.
WITH ranked AS (
  SELECT *, ROW_NUMBER()
  OVER (PARTITION BY PassengerId ORDER BY PassengerId)
  AS row_num
  FROM `gen-lang-client-0468058423.titanic.passengers`
)
SELECT *
FROM ranked
WHERE row_num = 1;

-- 15. Standardisation textuelle des variables catégorielles
-- Nettoyage des espaces superflus (TRIM) et application d'une casse uniforme (UPPER/LOWER).
SELECT
  UPPER(Name) AS Name_standard,
  TRIM(LOWER(Sex)) AS Sex_standard,
  TRIM(UPPER(Ticket)) AS Ticket_standard,
  TRIM(UPPER(Cabin)) AS Cabin_standard,
  TRIM(UPPER(Embarked)) AS Embarked_standard
FROM `gen-lang-client-0468058423.titanic.passengers`;

-- 16. Encodage numérique (Label Encoding) de la colonne 'Sex'
-- Conversion du texte en format numérique binaire (0/1) indispensable pour les modèles d'IA.
SELECT
  CASE
    WHEN Sex ='male' THEN 0
    WHEN Sex ='female' THEN 1
    ELSE NULL
  END AS Sex_encode
FROM `gen-lang-client-0468058423.titanic.passengers`;

-- 17. Feature Engineering : Création de la variable 'FamilySize'
-- Regroupement des membres de la famille (Fratrie/Conjoint + Parents/Enfants + le passager lui-même)
-- pour évaluer si voyager seul ou accompagné modifiait les chances de survie.
SELECT *,(SibSp + Parch + 1) AS FamilySize
FROM `gen-lang-client-0468058423.titanic.passengers`;

-- 18 & 19. Sélection des variables et Persistance dans la table 'passengers_clean'
-- Application consolidée de toutes les étapes de nettoyage et d'ingénierie précédentes.
-- Les colonnes à forte cardinalité ou trop incomplètes (Name, Ticket, Cabin) sont écartées.
CREATE OR REPLACE TABLE `gen-lang-client-0468058423.titanic.passengers_clean` AS
WITH ranked_data AS (
  SELECT *, 
         ROW_NUMBER() OVER (PARTITION BY PassengerId ORDER BY PassengerId) AS row_num 
  FROM `gen-lang-client-0468058423.titanic.passengers`
)
SELECT 
  * EXCEPT(Name, Ticket, Cabin, Sex, Age, Embarked, row_num), 
  IFNULL(Age, (SELECT AVG(Age) FROM ranked_data)) AS Age,
  IFNULL(Embarked, (
    SELECT Embarked FROM ranked_data 
    WHERE Embarked IS NOT NULL 
    GROUP BY Embarked ORDER BY COUNT(*) DESC LIMIT 1
  )) AS Embarked,
  TRIM(LOWER(Sex)) AS Sex_standard,
  CASE 
    WHEN Sex = 'male' THEN 0 
    WHEN Sex = 'female' THEN 1 
    ELSE NULL 
  END AS Sex_encode,
  (SibSp + Parch + 1) AS FamilySize
FROM 
  ranked_data
WHERE 
  row_num = 1;


-- ---------------------------------------------------------------------------------
-- ÉTAPE 5 : ANALYSE DES TENDANCES ET EXTRACTION D'INSIGHTS MÉTIERS
-- Objectif : Répondre aux hypothèses de survie selon les caractéristiques démographiques.
-- ---------------------------------------------------------------------------------

-- 20. Calculez le taux de survie global de la catastrophe
SELECT
  COUNT(*) AS total,
  SUM(Survived) AS survivants,
  ROUND(AVG(Survived) * 100, 2) AS taux_survie_pct
FROM `gen-lang-client-0468058423.titanic.passengers_clean`;

-- 21. Calculez le taux de survie selon des critères isolés (Sexe d'un côté, Classe de l'autre)
-- Taux de survie par Sexe
SELECT Sex_standard,
  COUNT(*) AS total,
  SUM(Survived) AS survivants,
  ROUND(AVG(Survived) * 100, 2) AS taux_survie_pct
FROM `gen-lang-client-0468058423.titanic.passengers_clean`
GROUP BY Sex_standard;

-- Taux de survie par Classe (Pclass)
SELECT Pclass,
  COUNT(*) AS total,
  SUM(Survived) AS survivants,
  ROUND(AVG(Survived) * 100, 2) AS taux_survie_pct
FROM `gen-lang-client-0468058423.titanic.passengers_clean`
GROUP BY Pclass
ORDER BY Pclass;

-- 22. Analyse croisée multivariable (Taux de survie par Sexe ET par Classe)
-- Révèle des disparités profondes (ex: priorité accordée aux femmes de première classe).
SELECT Sex_standard, Pclass,
  COUNT(*) AS total,
  SUM(Survived) AS survivants,
  ROUND(AVG(Survived) * 100, 2) AS taux_survie_pct
FROM `gen-lang-client-0468058423.titanic.passengers_clean`
GROUP BY Sex_standard, Pclass
ORDER BY Sex_standard, Pclass;

-- 23. Identifiez les 10 passagers ayant payé le tarif (Fare) le plus élevé
-- Permet de brosser le profil des clients "Ultra High Net Worth" à bord.
SELECT *
FROM `gen-lang-client-0468058423.titanic.passengers_clean`
ORDER BY Fare DESC
LIMIT 10;


-- ---------------------------------------------------------------------------------
-- ÉTAPE 6 : PRÉPARATION À LA MODÉLISATION (DATA SPLITTING)
-- Objectif : Segmenter le dataset propre de manière déterministe pour l'entraînement (80%)
--            et la validation (20%) des algorithmes prédictifs.
-- ---------------------------------------------------------------------------------

-- 24. Division de la table passengers_clean
-- Utilisation du hachage FARM_FINGERPRINT pour garantir un découpage reproductible.

-- Jeu d'entraînement (~80 %)
SELECT *
FROM `gen-lang-client-0468058423.titanic.passengers_clean`
WHERE ABS(MOD(FARM_FINGERPRINT(CAST(PassengerId AS STRING)), 10)) < 8;

-- Jeu de test (~20 %)
SELECT *
FROM `gen-lang-client-0468058423.titanic.passengers_clean`
WHERE ABS(MOD(FARM_FINGERPRINT(CAST(PassengerId AS STRING)), 10)) >= 8;