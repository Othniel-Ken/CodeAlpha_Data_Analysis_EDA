# 🚢 Analyse Exploratoire des Données (EDA) - Titanic Dataset

[cite_start]Ce projet a été réalisé dans le cadre du stage en Data Analytics chez **CodeAlpha** (Tâche 2). [cite_start]L'objectif est d'explorer, nettoyer et analyser le célèbre jeu de données du Titanic pour en extraire des tendances significatives  à l'aide de requêtes SQL sur Google BigQuery.

## 🎯 Objectifs de l'analyse
[cite_start]Avant d'entamer l'analyse, plusieurs questions ont guidé notre exploration[cite: 32]:
1. [cite_start]Quelle est la structure globale du jeu de données et présente-t-il des anomalies (valeurs manquantes, doublons)[cite: 33, 36]?
2. [cite_start]Quels facteurs (sexe, classe du billet, taille de la famille) ont le plus influencé le taux de survie des passagers[cite: 34, 35]?

## 🛠️ Outils utilisés
* **Langage :** SQL (Standard SQL)
* **Environnement :** Google Cloud BigQuery
* **Données :** Dataset Titanic (`passengers`)

## 🧹 Méthodologie et Nettoyage des Données
[cite_start]Pour préparer les données à une analyse approfondie, les étapes suivantes ont été réalisées :
* [cite_start]**Détection des anomalies :** Identification des valeurs manquantes, principalement concentrées dans les colonnes `Age`, `Cabin` et `Embarked`.
* **Imputation :** * Remplacement des âges manquants par l'âge moyen des passagers.
  * Remplacement des ports d'embarquement manquants par le mode (la valeur la plus fréquente).
* **Standardisation :** Uniformisation de la casse et suppression des espaces pour les variables catégorielles (`Sex`, `Ticket`, `Cabin`, `Embarked`).
* **Feature Engineering :** Création d'une nouvelle variable `FamilySize` (SibSp + Parch + 1) pour évaluer l'impact de l'accompagnement familial sur la survie.
* **Encodage :** Transformation de la variable `Sex` en format binaire (0 pour homme, 1 pour femme).

## 💡 Insights et Tendances Clés
[cite_start]L'exploration des données nettoyées (`passengers_clean`) a permis de valider plusieurs hypothèses[cite: 34, 35]:
1. **Impact du sexe :** Le taux de survie est drastiquement plus élevé chez les femmes que chez les hommes, confirmant la règle du "les femmes et les enfants d'abord".
2. **Impact de la classe sociale :** Les passagers de la 1ère classe (`Pclass = 1`) ont un taux de survie nettement supérieur à ceux de la 3ème classe.
3. **Analyse croisée :** L'analyse combinée (Sexe + Classe) démontre que les femmes de 1ère classe avaient les plus grandes chances de survie, tandis que les hommes de 3ème classe étaient les plus vulnérables.

## 🚀 Comment lire ce projet
Le fichier `aguidi_othniel.sql` contient l'intégralité des requêtes utilisées, de la vérification initiale de la structure à la création de la table finale propre prête pour la modélisation et la visualisation.