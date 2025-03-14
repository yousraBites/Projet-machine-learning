---
editor_options: 
  markdown: 
    wrap: 72
---

## 1. Jeu de données

### 1.1. Charger le jeu de données

Quel est le format du jeu de données ?

*Réponse :* Le jeu de données est disponible sous format **CSV**

Charger le jeu de données

```{r}
data = read.csv("loan_data.csv")
head(data)
```

### 1.2. Caractéristiques du jeu de données

Donner le nombre de lignes et le nombre de colonnes du data frame

*Réponse :*

```{r}
dim(data)
library(stringr)
max(data$person_age)
min(data$person_age)
data_rect <- data[data$person_age != 123, ]
data_rectF <- data_rect[data_rect$person_age != 144, ]

nrow(data) #nombre de ligne
ncol(data) #nombre de colonne
summary(data)
sum(data$person_age == 123, na.rm = TRUE)
View(data_rectF)
```

```{r}
max(data_rectF$person_age)
boxplot(data_rectF$person_age)
```

### 1.3 Variables\*

Lister le nom de chaque variable

*Réponse :*

```{r}
names(data)
```

Donner une description courte de chacune des variables

*Réponse :* \*\* person_age : Âge de la personne (emprunteur).
person_gender : Genre de la personne (ex. : homme, femme).
person_education : Niveau d’éducation atteint (ex. : secondaire,
universitaire). person_income : Revenu annuel de la personne.
person_emp_exp : Expérience professionnelle en années.
person_home_ownership : Statut de propriété du logement (ex. :
propriétaire, locataire). loan_amnt : Montant du prêt demandé.
loan_intent : Objet ou but du prêt (ex. : achat auto, consolidation de
dettes). loan_int_rate : Taux d’intérêt du prêt. loan_percent_income :
Pourcentage du revenu utilisé pour rembourser le prêt.
cb_person_cred_hist_length : Longueur de l’historique de crédit de la
personne (en années). credit_score : Score de crédit de la personne
(mesure de la solvabilité). previous_loan_defaults_on_file : Indique si
la personne a déjà fait défaut sur un prêt (oui/non). loan_status :
Statut final du prêt (ex. : approuvé, rejeté, en défaut).

\*\*

Indiquer lesquelles devraient être qualitatives et lesquelles devraient
être quantitatives

*Réponse :* Variables quantitatives (numériques) :

person_age — Âge person_income — Revenu annuel person_emp_exp —
Expérience professionnelle (années) loan_amnt — Montant du prêt
loan_int_rate — Taux d’intérêt loan_percent_income — Pourcentage de
revenu alloué au prêt cb_person_cred_hist_length — Longueur de
l’historique de crédit credit_score — Score de crédit

Variables qualitatives (catégorielles) :

person_gender — Genre person_education — Niveau d’éducation
person_home_ownership — Type de logement (propriétaire, locataire, etc.)
loan_intent — But du prêt previous_loan_defaults_on_file — Historique de
défauts de paiement (Oui/Non) loan_status — Statut du prêt (1 =
approuvé, 0 = rejeté ou en défaut)

### 1.4 Target

Indiquer quelle variable sera notre target (i.e., variable réponse à
prédire).

*Réponse :* loan_status

Quel est le data type de cette variable ?

*Réponse :* Integer

Stocker cette variable dans une nouvelle variable nommée `target` et
avec le bon data type

```{r}
target = factor(data$loan_status, labels=c("rejeté", "approuvé") )
summary(target)
class(target)
```

### 1.5 Variables peu pertinentes

-   person_gender : pour éviter d’introduire un risque de discrimination

-   person_education : peut introduire des biais (pour des questions
    éthiques)

-   person_income et loan_amnt : elles sont corrélées avec
    loan_percent_income, qui est un ratio dérivé de ces deux variables 

### 1.6 Transformation des variables

Quelle(s) transformation(s) de variable(s) pourrait-on éventuellement
effectuer, et sur quelles variables ?

*Réponse :* - catégoriser les quantitaves telles que Age ou Fare, SibSp
ou Parch. Cela permettrait d'attenuer l'effet de potentielles valeurs
extrêmes. - Agreger SibSp et Parch et calculer leur somme pour obtenir
une nouvelle variable donnant le nombre de membres de la famille à
bord. - On pourrait aussi discrétiser cette variable (celle agrégée)
afin d'obtenir une variable binaire indiquant si le passager était avec
la famille. Mais cela pourrait entraîner une perte d'information. - On
pourrait catégoriser la variable Cabin pour créer une variable
catégorielle dont les catégories regroupant les passagers avec les
numéros de cabine qui commencent par la même lettre

À quoi faut-il faire attention ?

*Réponse :* au données manquantes

Effectuer ces transformations en justifiant éventuellement vos options

*Indication :* lire la documentation de `substr`, `cut`, `min`, `max`

*Réponse :*

```{r, results = "hide"} data$Fam = data$SibSp+data$Parch data$withFam=1*(data$Fam>0) data$withFam=as.factor(data$withFam) data$Deck = substr(data$Cabin,1,1) data$Deck = as.factor(data$Deck) summary(data)}
```

Pour la catégorisation d'une variables telle que `Age`, il faut choisir
les catégories. Nous avons plusieurs possibilités ; lesquelles ? Coder
l'option choisie

*Réponse :* - Catégorisation en groupes classiques (Enfants, Adultes,
Séniors) - Découpage en quantiles (distribution équilibrée) -
Catégorisation binaire (Jeune vs Âgé)

`{r} data$Age_cat = cut(data$Age, breaks = c(0,13,18,60,max(data$Age,na.rm=TRUE)),labels=c("enfant", "jeune","adulte","vieux")) data$Age_cat}`

Que remarque-t-on ?

*Réponse :* il y a des valeurs manquantes

Remarque : D'autres transformations seront peut être à faire, en
fonction de la méthode de classification supervisée utilisée
(standardisation, codage binaire, etc.). On les implementera lors du
prochain TP

## 1.7 Variables prédictives

Créer un data frame nommé `quantitative_vars` contenant les variables
quantitatives que l'on souhaite éventuellement utiliser pour la
prédiction, et un nommé `qualitative_vars` contenant les variables
qualitatives que l'on souhaite éventuellement utiliser pour la
prédiction. Si nécessaire, modifier le data type des variables

Si on le souhaite, on peut installer les packages `dplyr` et
`tidyverse`, et lire la la documentation de la commande `select`, pour
créer facilement ces deux data frames

```{r, results = "hide", message = FALSE} library(dplyr) library(tidyverse)}
```

*Réponse :* On modifie le data type des variables suivantes

```{r, results = "hide"}
data$Sex = as.factor(data$Sex) 
data$Pclass = as.factor(data$Pclass)
data$Embarked = as.factor(data$Embarked)
```

`{r} qualitative_vars = data %>% select(Age_cat,Pclass,Sex,Embarked,Deck,withFam) quantitative_vars = data %>% select(Age, SibSp, Parch, Fam, Fare) #ou #qual_vars = data.frame(Age_cat=data$Age_cat, Pclass = data$Pclass, Sex = data$Sex,  Embarked = data$Embarked, Deck = data$Deck, withFam = datawithFam) #quant_vars = data.frame(Age = data$Age, SibSp = data$SibSp, Parch = data$Parch, Fam = data$Fam, Fare = data$Fare)}`

Avez-vous inclus toutes les variables autres que la target ?

*Réponse :* Non, car les autres ne semblent pas utile, ou difficles à
utiliser.

Les variables quantitatives, il y a 5 variables

-age de la personne,
