# Cours-SGBD-Projets
Projets réalisés dans le cadre du cours de Systèmes de Gestion de Bases de Données (SGBD) : applications Lazarus/MySQL (gestion des clients, auteurs, bibliothèques...).

**Prérequis pour exécuter les exercices** 

Pour pouvoir compiler et exécuter correctement les applications, les éléments suivants sont requis :

- **Lazarus IDE** 
  → environnement de développement pour compiler les projets en Free Pascal.

- **Base de données MySQL "bibliotest"**  
  → la base doit être importée depuis le fichier `bibliotest.sql` fourni dans le dépôt.  
  Elle contient les tables utilisées dans les différents exercices (ex. `auteurs`, `livres`, `emprunteurs`, etc.).  
  Vous pouvez l'importer via **phpMyAdmin**

- **Bibliothèques MySQL pour Lazarus**  
  → téléchargez et copiez un des fichiers suivants nécessaires aux exercices dans le **répertoire du projet Lazarus** :
  - `libmysql.dll` (version **5.6**) → `DLLVersion56` (pour les premiers exercices)
  - `libmysql.dll` (version **5.7**) → `DLLVersion57`

  Ces DLL permettent la communication entre Lazarus et le serveur MySQL.  
  Le programme détecte automatiquement la version utilisée par votre serveur.  

Une fois ces éléments en place, ouvrez le fichier `.lpi` correspondant dans Lazarus, configurez la connexion MySQL (DatabaseName : bibliotest, Hostname : localhost, UserName : root) et exécutez le projet (`F9`).





**Projet final**

A l’aide d’un script SQL que vous aurez défini, vous devez générer la base de données « LocationsBiens » sur le Serveur MySQL.
Les immeubles sont de 2 types : maison ou appartement.
Cette base de données sera composée obligatoirement de 4 tables permettant de modéliser les objets et relations intervenant dans le processus de locations d’immeubles : il s’agit des tables « Bien », « Locataire », « Propriétaire » et  « Location ».
A vous de déterminer les champs qui permettront de définir le nom et le type des enregistrements présents dans chacune des tables, ainsi que la clé primaire de chaque table et les liens éventuels entre les tables.
Vous devez cependant obligatoirement définir les champs « commune », « prix » et « superficie » pour la table Bien, et les champs « nom » et « domicile » pour la table Propriétaire.
Le nombre d’enregistrements contenus au sein de chaque table est fixé au minimum à 10.

Vous devez développer, à l’aide de l’EDI Lazarus, 2 interfaces similaires à celles présentées en annexe.

L’interface N°1 contiendra :
2 zones permettant pour la 1ère (celle du haut) de visualiser l’ensemble des données de la table « Propriétaire » et pour la 2ème (celle du bas) les champs « nom » et « domicile » de la table « Propriétaire » ainsi que les champs  « commune », « prix » et « superficie » de la table « Bien ».
Les zones d’édition situées à côté de la 1 ère zone permettant l’affichage de la table Propriétaire, devront permettre d’insérer ou de supprimer des enregistrements au sein de la table qui correspondent aux valeurs entrées dans ces zones d’édition. Et ce en fonction du fait que l’utilisateur appuiera sur le bouton « Ajout » ou sur le bouton « Suppression ».
ATTENTION : toute suppression d’un propriétaire devra entraîner de manière automatique la suppression (logique ou physique) de tous les enregistrements concernant ce propriétaire dans la table Bien et dans la table Location !
L’appui sur le bouton « Rechercher » de la 2ème zone permettra d’afficher au sein de cette même zone les enregistrements correspondant au(x) critère(s) de recherche qui seront saisis dans les zones d’édition sur le côté.
Les enregistrements devront être affichés quels que soient le nombre de critère(s) insérés dans les zones d’édition.
L’affichage ne doit donc pas être généré uniquement lorsque tous les critères seront spécifiés. Un seul ou une combinaison de ceux-ci devra suffire.
L’espace situé entre les 2 zones de visualisation des tables résultats contiendra :
- Une barre de navigation permettant de se déplacer au sein des enregistrements de la zone de visualisation du haut.
Les boutons présents au sein de cette barre de navigation permettant soit de modifier, de supprimer ou de rajouter un enregistrement devront également permettre d’implémenter ces actions directement au sein de la table stockée sur le serveur.
- Un bouton permettant de connecter l’interface au Serveur de bases de données et à la base de données « LocationBiens ».
Un appui sur ce bouton provoquera également une modification de l’étiquette située en haut à droite de l’interface : le texte « Connecté » devra remplacer le texte « Non-connecté ».

ATTENTION : encore une fois, toute suppression d’un propriétaire devra entraîner de manière automatique la suppression (logique ou physique) de tous les enregistrements concernant ce propriétaire au sein des tables « Bien » et « Location » !

L’interface N°2 contiendra :
1 composant permettant de visualiser l’ensemble des données de la table « Bien ».
Au-dessus de celui-ci, un composant de type barre de navigation permettant de se déplacer au sein des enregistrements de la table ainsi qu’une zone de liste déroulante.
Les modifications apportées aux données par le biais des différents boutons de cette barre de navigation devront être mises en œuvre directement au sein de la table stockée sur le serveur.
La liste déroulante permettra de sélectionner les enregistrements correspondant à la valeur de la « commune » sélectionnée dans cette zone de liste, et de les afficher dans la zone de visualisation de la table Bien.
ATTENTION : toutes les valeurs de la liste déroulante sont générées automatiquement sur base des différentes valeurs du champ « commune » présentes au sein de la table Bien. Tout ajout ou suppression d’une « commune » au sein de la table débouchera donc automatiquement sur la mise à jour des valeurs de la liste déroulante.
Un bouton permettant de connecter l’interface au Serveur de bases de données et à la base de données « LocationBiens».
Les zones d’édition situées à côté de la zone permettant l’affichage de la table « Bien » devront afficher les valeurs des champs correspondant à l’enregistrement sélectionné au sein de la zone de visualisation de la table suite à un appui sur le bouton « Afficher ».
Une zone située en dessous du composant permettant de visualiser les enregistrements de la table comportera un bouton et 4 zones d’édition.
Ces dernières serviront à choisir et afficher les informations suivantes :
- la clé primaire de l’enregistrement du bien à sélectionner ;
- un pourcentage d’augmentation du prix de ce bien ;
- un pourcentage de diminution du prix de ce bien ;
- le prix moyen de tous les biens contenus dans la table ;
L’appui sur le bouton servira à augmenter ou diminuer le prix du bien sélectionné et à recalculer le prix moyen de tous les biens apparaissant au sein de la zone d’édition dédiée.
L’adaptation du prix sera obligatoirement déclenchée par l’appel à une procédure stockée que vous aurez définie sur le serveur. Le prix modifié sera également visible automatiquement au sein du composant permettant de visualiser l’ensemble des données de la table « Bien ».
Enfin, un rapport « succinct » reprenant le schéma de la base de données (MCD) ainsi que l’expression en langage usuel des contraintes sur les données ainsi que la justification des choix effectués dans l’implémentation de la base de données doit être rédigé.


Bon travail.

<img width="755" height="606" alt="image" src="https://github.com/user-attachments/assets/d140c749-6361-416a-ac2d-74fb3d99e806" />



<img width="935" height="457" alt="image" src="https://github.com/user-attachments/assets/d5491d1a-b6ab-4db9-912a-b5d895ff0b68" />




