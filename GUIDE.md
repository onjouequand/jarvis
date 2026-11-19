# JARVIS : mode d'emploi en 5 minutes

Ce guide est fait pour toi même si tu n'es pas à l'aise avec l'informatique. Suis les étapes dans l'ordre. **JARVIS ne modifie rien sans te demander ton accord.**

## 1. Télécharger

1. Clique sur ce lien : **[Télécharger JARVIS.cmd](https://github.com/onjouequand/jarvis/releases/latest/download/JARVIS.cmd)**
2. Le fichier `JARVIS.cmd` arrive dans ton dossier **Téléchargements**.
3. Si ton navigateur affiche « ce fichier n'est pas couramment téléchargé » ou « peut endommager ton appareil » : clique sur les **trois petits points** (ou la petite flèche) à côté du message, puis sur **Conserver** (Edge) ou **Télécharger quand même** (Chrome).

## 2. Lancer

1. Ouvre ton dossier **Téléchargements** et **double-clique** sur `JARVIS.cmd`.
2. Si une fenêtre bleue « **Windows a protégé votre ordinateur** » s'affiche : clique sur **Informations complémentaires**, puis sur **Exécuter quand même**.
3. Si une fenêtre « **Éditeur inconnu** » s'affiche : clique sur **Exécuter**.
4. Une fenêtre noire s'ouvre avec le logo JARVIS.

Ces avertissements sont normaux : ils apparaissent pour tout programme qui ne vient pas d'une grande entreprise.

## 3. Installer (une seule fois)

1. JARVIS écrit « J.A.R.V.I.S. n'est pas encore installé sur ce PC ». Appuie sur la touche **1**, puis sur **Entrée**.
2. Windows demande « Voulez-vous autoriser cette application à apporter des modifications ? » : clique sur **Oui**.
3. Au dossier proposé, appuie simplement sur **Entrée**.
4. À la question du raccourci sur le Bureau, appuie sur **Entrée** pour l'ajouter (ou tape **n** puis **Entrée** si tu n'en veux pas).
5. À « Lancer J.A.R.V.I.S. maintenant ? », appuie sur **Entrée**.

C'est fait. La prochaine fois, ouvre JARVIS depuis le **menu Démarrer** (tape « JARVIS ») ou le raccourci du Bureau. Tu peux supprimer le fichier de ton dossier Téléchargements.

## 4. Faire un check-up

1. Au menu, appuie sur **1** puis **Entrée** : c'est le **scan rapide** (2 à 5 minutes, il ne modifie rien).
2. La première fois, JARVIS affiche « Identité détectée » avec ton prénom : appuie sur **Entrée** s'il est juste, sinon tape ton prénom puis **Entrée**.
3. Laisse-le travailler. Ne tape rien pendant le scan.
4. À la fin, JARVIS te pose des questions, une par une (lancer une analyse antivirus, installer les mises à jour, faire le ménage…). Lis la question, puis :
   - tape **o** puis **Entrée** pour accepter ;
   - appuie sur **Échap** pour refuser (Échap veut toujours dire « non ») ;
   - si tu tapes autre chose, JARVIS ne devine pas : il repose la question.
5. Le ménage supprime pour de bon : une corbeille vidée ne se récupère pas. Si tu n'es pas sûr de ce qu'elle contient, refuse cette question-là.
6. En cas de doute, refuse : rien n'est grave si tu ne fais rien.

Le **scan complet** (touche **2**) dure 20 à 60 minutes : lance-le quand tu n'as pas besoin du PC, avec le chargeur branché si c'est un portable.

## 5. Mettre à jour JARVIS

Quand une nouvelle version existe, la ligne **[U] Mise à jour** apparaît en vert au menu. Appuie sur **U** puis **Entrée**, puis sur **Entrée** pour confirmer. JARVIS se met à jour tout seul et se relance.

## Si quelque chose ne va pas

| Ce que tu vois | Ce qu'il faut faire |
|---|---|
| « JARVIS.cmd est modifié ou incomplet » | Le fichier est abîmé : retélécharge-le avec le lien de l'étape 1. |
| « PowerShell est en mode restreint » | Ton PC bloque ce genre d'outil (souvent un PC d'entreprise ou le « Contrôle intelligent des applications ») : JARVIS ne peut pas fonctionner dessus. |
| « J.A.R.V.I.S. est déjà en cours d'exécution » | Une autre fenêtre JARVIS est ouverte : ferme-la d'abord. |
| Une question à laquelle tu ne sais pas répondre | Appuie sur **Échap** : c'est toujours « non ». |
| « plus longtemps que prévu » pendant l'installation des mises à jour Windows | Appuie sur **Entrée** : JARVIS attend encore 30 minutes. L'arrêter en cours de route peut abîmer Windows. |
| Une application du Microsoft Store « pas installée, l'application tournait encore » | Ferme-la complètement (y compris son icône près de l'horloge), puis relance JARVIS ou ouvre **Microsoft Store > Bibliothèque > Obtenir les mises à jour**. |
| « Choix non reconnu » ou « Réponse non comprise » | Tape une des touches affichées entre crochets, puis **Entrée**. |
| « Dossier refusé : dossier modifiable sans droits administrateur » | Appuie sur **Entrée** pour accepter le dossier proposé (`C:\Program Files\JARVIS`). |
| La mise à jour **[U]** est refusée à cause du dossier d'installation | Ton JARVIS est installé hors de `Program Files`. Retélécharge-le avec le lien de l'étape 1, lance-le, choisis **1** (Mettre à jour), puis appuie sur **Entrée** au dossier proposé : il se réinstalle au bon endroit, sans rien perdre. |
| Le navigateur refuse le téléchargement | Appuie sur les touches **Windows + R**, colle la ligne ci-dessous, puis **Entrée**. Elle télécharge JARVIS dans tes Téléchargements et le lance. |

```
powershell -NoProfile -Command "iwr https://github.com/onjouequand/jarvis/releases/latest/download/JARVIS.cmd -OutFile $HOME\Downloads\JARVIS.cmd -UseBasicParsing; start $HOME\Downloads\JARVIS.cmd"
```

## Désinstaller

**Paramètres > Applications > Applications installées**, cherche « J.A.R.V.I.S. », puis **Désinstaller**. Tu peux aussi choisir **[4]** au menu de JARVIS. Pour confirmer, il faut taper `DESINSTALLER` : impossible de le faire par erreur.
