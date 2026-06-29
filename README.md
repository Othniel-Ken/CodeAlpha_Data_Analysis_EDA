# 🚢 Analyse Exploratoire et Visualisation des Données — Dataset Titanic

Ce dépôt contient les travaux réalisés dans le cadre du stage en **Data Analytics** chez **CodeAlpha**. L'objectif de ce projet est d'explorer, de nettoyer et de visualiser le célèbre jeu de données du Titanic afin d'en extraire des insights significatifs et de construire un récit de données (Data Storytelling) cohérent.

**Analyste :** Othniel Aguidi  
**Outils clés :** SQL (Google BigQuery), Python (Pandas, Matplotlib, Seaborn)

---

## 📂 Structure du Dépôt

* `titanic_preparation.sql` : Script SQL complet contenant l'analyse exploratoire, le nettoyage et la préparation des données sur BigQuery.
* `visualisation.ipynb` : Notebook Jupyter contenant le code Python utilisé pour charger les données nettoyées et générer les graphiques.
* `passengers_clean.csv` : Jeu de données propre exporté après les traitements SQL.
* `dashboard_titanic.png` : Tableau de bord final regroupant les visualisations clés.

---

## ✅ Tâche 2 : Analyse Exploratoire des Données (EDA) via SQL

L'analyse exploratoire a été menée sur **Google BigQuery** pour auditer la qualité des données brutes et structurer un ensemble de données propre prêt pour l'analyse.

### 1. Méthodologie et Nettoyage
* **Audit de la structure :** Identification de la volumétrie globale, des types de colonnes et détection des valeurs manquantes (principalement concentrées sur `Age`, `Cabin` et `Embarked`).
* **Gestion des valeurs manquantes :** * Imputation des âges manquants par la moyenne globale des passagers pour maintenir la distribution statistique.
  * Remplacement des ports d'embarquement manquants par le mode (la valeur la plus fréquente : 'S').
* **Déduplication :** Utilisation de la fonction analytique `ROW_NUMBER()` pour détecter et éliminer les doublons potentiels.
* **Standardisation textuelle :** Uniformisation de la casse (UPPER/LOWER) et suppression des espaces inutiles (`TRIM`) pour les variables catégorielles.
* **Feature Engineering (Ingénierie des caractéristiques) :**
  * Création de la variable numérique `FamilySize` (`SibSp` + `Parch` + 1) pour mesurer l'impact de l'entourage familial sur la survie.
  * Encodage binaire (Label Encoding) de la variable `Sex` (0 pour homme, 1 pour femme) pour anticiper les besoins de modélisation.

### 2. Insights Clés extraits du SQL
* **Le taux de survie global** de la catastrophe s'élève à environ **38.38%**.
* **Impact majeur du genre :** Le taux de survie est drastiquement plus élevé chez les femmes (74.20%) que chez les hommes (18.89%).
* **Disparité sociale :** Les passagers de la 1ère classe possèdent un taux de survie de 62.96%, contre seulement 24.24% pour la 3ème classe.

---

## 📊 Tâche 3 : Visualisation des Données via Python

Pour donner vie aux insights textuels extraits en SQL, un script Python utilisant les bibliothèques `Matplotlib` et `Seaborn` a été développé afin de concevoir un tableau de bord à 4 axes.

### Récit de données (Data Storytelling)
Le fichier `dashboard_titanic.png` met en évidence quatre angles visuels complémentaires :
1. **Taux de Survie par Sexe :** Confirmation visuelle immédiate de la règle empirique "les femmes et les enfants d'abord".
2. **Taux de Survie par Classe Sociale :** Traduction visuelle des chances de survie décroissantes à mesure que l'on descend dans les classes de billets.
3. **Distribution des Âges :** Visualisation de la structure démographique des passagers à bord, montrant une forte concentration de jeunes adultes (20-40 ans).
4. **Taux de Survie Croisé (Sexe et Classe) :** L'insight le plus puissant. Ce graphique démontre que les femmes de 1ère et 2ème classe étaient presque intégralement sauvées, tandis que la vulnérabilité était maximale pour les hommes de 3ème classe.

---

## 🚀 Comment reproduire ce projet ?

1. **Partie SQL :** Importez le fichier brut du Titanic sur Google BigQuery et exécutez le script `titanic_preparation.sql` pour générer la table `passengers_clean`.
2. **Exportation :** Téléchargez la table propre au format `passengers_clean.csv`.
3. **Partie Python :** Placez le fichier CSV dans le même répertoire que le notebook `visualisation.ipynb` et exécutez les cellules pour régénérer le tableau de bord visuel.