# J.A.R.V.I.S.

**Check-up et mise à jour de Windows en un seul fichier**, avec une interface en mode terminal : logo ASCII, barres de progression, statuts `[ OK ]` `[WARN]` `[FAIL]` `[INFO]`.

JARVIS contrôle l'état du PC (mises à jour, pilotes, sécurité, disques, journaux d'erreurs…), explique ce qu'il trouve en français et propose les corrections. **Rien n'est modifié sans ta confirmation.**

> Tu veux juste l'installer sans lire la suite ? Le mode d'emploi pas à pas est dans **[GUIDE.md](GUIDE.md)**.

## Télécharger

**[⬇ Télécharger JARVIS.cmd (dernière version)](https://github.com/onjouequand/jarvis/releases/latest/download/JARVIS.cmd)**

Lien permanent, il donne toujours la dernière version publiée. Toutes les versions et leurs nouveautés : [page des versions](https://github.com/onjouequand/jarvis/releases).

## Ce que fait le scan

| N° | Section | Ce qui est vérifié |
|---|---|---|
| 01 | Système | version de Windows, date de fin de ses correctifs de sécurité (Windows 10 et chaque version de Windows 11), durée depuis le dernier démarrage, redémarrage en attente, heure du PC comparée à celle d'Internet |
| 02 | Windows Update | mises à jour importantes, à faire à l'écran, facultatives ; échecs d'installation des 30 derniers jours |
| 03 | Applications | mises à jour disponibles via winget et le Microsoft Store |
| 04 | Pilotes | Wi-Fi, Ethernet, Bluetooth, carte graphique, périphériques en erreur |
| 05 | Bluetooth | service, adaptateur, économie d'énergie |
| 06 | Sécurité | antivirus, Defender et ses protections (dont le blocage des applications indésirables), pare-feu, Secure Boot et ses certificats de 2023, TPM, obstacles au passage à Windows 11 (PC sous Windows 10), point de restauration, réglages de sécurité de Windows (contrôle de compte, SmartScreen, Bureau à distance, ancien partage SMBv1, comptes, fichier hosts, proxy, activation) |
| 07 | Stockage | espace libre, santé des disques, température et usure des SSD, optimisation automatique des disques, BitLocker |
| 08 | Ressources | processeur, mémoire, programmes gourmands, démarrage, batterie |
| 09 | Réseau | box (passerelle), accès et temps de réponse Internet, DNS |
| 10 | Journaux (7 jours) | arrêts brutaux, écrans bleus, erreurs matérielles et disque |
| 11 | Nettoyage | fichiers temporaires, corbeille, caches de Windows Update et de l'optimisation de livraison, vidages mémoire de plus de 30 jours, anciens composants de Windows (scan complet, seulement si le nettoyage automatique de Windows ne passe plus), dossier Windows.old (mesuré seulement), Assistant de stockage de Windows (actif ou non) |
| 12 | BIOS | carte mère, version et date, page de support du fabricant (JARVIS n'installe pas de BIOS) |
| 13 | Restes de programmes | liens vers un programme absent laissés par une désinstallation (démarrage, menu Démarrer, tâches planifiées, services, liste des applications), gros dossiers de Program Files sans programme (montrés seulement, jamais supprimés) |
| 14 | Intégrité (scan complet) | DISM, SFC /scannow, CHKDSK |

Trois modes au menu : **scan rapide** (2 à 5 min, ne modifie rien), **scan complet** (20 à 60 min, ajoute la vérification des fichiers système de Windows) et **auto-test** (vérifie que JARVIS fonctionne correctement sur ce PC).

La synthèse donne un état général (**en bon état**, **à surveiller** ou **à traiter**), la liste des points à régler (sous chaque avertissement ou alerte du scan, JARVIS écrit quoi faire) et ce qui n'a pas pu être vérifié (lecture impossible, droits administrateur manquants).

En fin de scan, JARVIS propose l'**entretien recommandé** en une seule question : analyse antivirus rapide (si Microsoft Defender est ton antivirus), mise à jour des applications (winget et Microsoft Store, chaque résultat vérifié), installation des mises à jour Windows (en administrateur), suppression des fichiers temporaires de plus de 24 h, retrait des liens morts trouvés en section 13 (démarrage, raccourcis du menu Démarrer, tâches planifiées : chacun est revérifié juste avant et sauvegardé dans `%LOCALAPPDATA%\JARVIS\Sauvegardes`, avec un mode d'emploi pour le remettre). Tu choisis de tout faire, de décider élément par élément ou de ne rien faire (réponse par défaut) ; une fois accepté, tout s'enchaîne à la suite et un bilan dit ce qui est fait et ce qui reste à reprendre. Restent posées à part, une par une et réponse par défaut non : la réparation de l'image Windows (demandée avant l'entretien et faite en premier) et les suppressions définitives (corbeille, caches de mises à jour, vidages mémoire, anciens composants de Windows ; l'espace libéré est mesuré après coup). Si Windows demande un redémarrage, il est proposé tout à la fin. Le dossier Windows.old n'est jamais supprimé par JARVIS : il permet de revenir à la version précédente de Windows, JARVIS indique seulement où le retirer. Un rapport texte est enregistré dans `%LOCALAPPDATA%\JARVIS\Rapports`.

## Installation et mises à jour

- Au premier lancement, JARVIS propose de s'installer dans `C:\Program Files\JARVIS`, avec un raccourci dans le menu Démarrer (et sur le Bureau si tu veux). Il apparaît ensuite dans **Paramètres > Applications installées**, d'où on peut le désinstaller.
- **Mises à jour automatiques** : à chaque ouverture, JARVIS regarde ici s'il existe une version plus récente (3 secondes au plus, rien ne s'affiche si le PC est hors ligne). Si oui, la touche **[U]** apparaît au menu : JARVIS télécharge la nouvelle version, vérifie son empreinte, puis l'installe.
- Il refuse d'installer une version plus ancienne que celle déjà en place.

## Configuration requise

Windows 10 ou 11, PC fixe ou portable, Windows PowerShell 5.1 (déjà présent dans Windows). Les droits administrateur sont demandés pour l'analyse complète, l'installation et les mises à jour. Sans eux, JARVIS fonctionne avec des contrôles réduits.

## Sécurité et confidentialité

- **Aucune donnée personnelle n'est envoyée.** Les seules connexions sont celles des outils de Windows (Windows Update, winget, Microsoft Store), un test de latence vers `1.1.1.1`, une résolution DNS de `www.microsoft.com`, une lecture de l'heure sur `www.msftconnecttest.com` (adresse que Windows interroge lui-même pour tester la connexion), et la question à GitHub sur la dernière version publiée (GitHub voit alors l'adresse IP, comme pour toute visite).
- **Fichier abîmé ou incomplet détecté** : `JARVIS.cmd` contient l'empreinte SHA-256 de son propre code. S'il a été abîmé ou tronqué (téléchargement interrompu, par exemple), il refuse de démarrer. Ce contrôle détecte un accident, il ne protège pas contre une modification volontaire du fichier.
- **Installation réservée aux administrateurs** : JARVIS refuse de s'installer dans un dossier que n'importe quel programme peut modifier. Le dossier proposé, `C:\Program Files\JARVIS`, convient toujours.
- **Mises à jour contrôlées** : un fichier téléchargé n'est installé que si sa taille, l'empreinte publiée par GitHub, son empreinte interne et son numéro de version sont tous conformes. Si l'installation échoue en cours de route, l'ancienne version est remise en place.
- **Pas de « OK » sans preuve** : un contrôle n'est affiché en vert que si la donnée a vraiment été lue. Quand une lecture échoue, JARVIS écrit « lecture impossible » au lieu de conclure.
- Le fichier n'est pas signé numériquement : Windows affiche donc « Éditeur inconnu » au premier lancement. C'est normal pour un outil distribué par un particulier ; le code complet est lisible ici.

## Pour les curieux et les développeurs

```
src/jarvis-checkup.ps1   le code source (le seul fichier à modifier)
build.py                 fabrique JARVIS.cmd à partir de la source
JARVIS.cmd               le fichier distribué (généré, ne pas modifier à la main)
```

`JARVIS.cmd` est un fichier hybride : un court en-tête batch lance PowerShell, qui vérifie l'empreinte du fichier puis exécute le code qui suit. Pour le fabriquer :

```
python build.py
```

`build.py` vérifie la structure du script, refuse les caractères qui posent problème à PowerShell 5.1 (guillemets typographiques), calcule l'empreinte et écrit `JARVIS.cmd` en UTF-8 sans BOM avec des fins de ligne Windows. L'auto-test (menu `[3]` ou `JARVIS.cmd -SelfTest`) vérifie chaque composant sur le PC où il tourne.

Options en ligne de commande : `-Quick`, `-Deep`, `-SelfTest`, `-Update`, `-Uninstall`, `-NoAnim`, `-NoWinget`, `-Ascii`, `-Name "Prénom"`. La liste complète est en tête de `src/jarvis-checkup.ps1`.
