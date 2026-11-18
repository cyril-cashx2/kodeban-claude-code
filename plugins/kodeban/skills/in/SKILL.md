---
description: Commencer une tâche KodeBan dans cette conversation (ouvre une session de travail).
argument-hint: "[numéro de tâche | quelques mots]"
disable-model-invocation: true
allowed-tools: Bash(kodeban-poste) Bash(kodeban-poste *) Bash(kodeban-ouvrir *) Bash(kodeban-pause *) mcp__plugin_kodeban_kodeban__mes_sessions_ouvertes mcp__plugin_kodeban_kodeban__chercher_tache mcp__plugin_kodeban_kodeban__lire_tache mcp__plugin_kodeban_kodeban__lire_sessions mcp__plugin_kodeban_kodeban__ouvrir_session mcp__plugin_kodeban_kodeban__noter_session mcp__plugin_kodeban_kodeban__cloturer_session mcp__plugin_kodeban_kodeban__demander_choix_tache mcp__plugin_kodeban_kodeban__lire_choix_tache
---

# /kodeban:in — je commence

Ce que l'utilisateur a écrit après la commande : « $ARGUMENTS »
Référence de cette conversation : `${CLAUDE_SESSION_ID}`

Parle en français courant, en phrases courtes, sans jargon et sans nom d'outil.

Si un outil KodeBan ne répond pas (pas encore autorisé, accès révoqué, site éteint) : dis-le en une
phrase, ajoute « Branchez KodeBan : tapez `/mcp`, choisissez kodeban, puis authentifiez-vous. », et
arrête-toi.

## 1. Où suis-je

Lance `kodeban-poste` : il donne le poste et le dossier (ils servent à ouvrir la session). Puis
`mes_sessions_ouvertes` **sans aucun argument** : ne filtre ni par poste ni par dossier, car le
dossier courant change dès qu'une commande se déplace et la session de cette conversation ne
serait plus retrouvée. Fie-toi au site, pas à ta mémoire de la conversation.

## 2. Une session déjà ouverte

- Une session ouverte dont la référence (`sessionRef`) est celle de cette conversation, ou que cette
  conversation a elle-même ouverte : refuse. « Une conversation, une session. Clôturez avec
  `/kodeban:out`, puis ouvrez une nouvelle conversation. » Arrête-toi.
- Une session d'un autre poste (`workstation`), ou d'un dossier (`workdir`) sans rapport avec le
  tien (ni le même, ni un dossier qui contient l'autre) : c'est un autre travail. N'en parle pas et
  n'y touche pas.
- Une autre session ouverte pour ce poste et ce dossier (restée ouverte) : montre-la (numéro et
  titre de la tâche, date, dernière note) et propose : la clôturer « à reprendre » avec sa dernière
  note, puis continuer ; ou tout annuler. Attends la réponse. Jamais de clôture sans réponse. Si la
  note n'a pas de « reste à faire », demande-le avant de clôturer (le site refuserait).

## 3. Trouver la tâche

- **Rien après la commande** : `demander_choix_tache` (assistant `claude_code`, ton modèle, poste,
  dossier, `sessionRef` = la référence de cette conversation). Ouvre l'adresse avec
  `kodeban-ouvrir <adresse>` ; si ça échoue, affiche l'adresse. Puis `lire_choix_tache`, avec
  `kodeban-pause 3` entre deux questions pendant la première minute, `kodeban-pause 10` ensuite,
  jusqu'à « chosen » ou « expired ». Expirée : dis-le et arrête-toi. Choisie : la session est déjà
  ouverte par le site.
- **Un numéro** : `lire_tache`. Introuvable : dis-le, n'ouvre rien.
- **Des mots** : `chercher_tache`. Une seule tâche : c'est elle. Plusieurs : propose-les (numéro,
  titre, tableau, projet) et attends le choix. Aucune : dis-le et propose `/kodeban:in` sans rien
  pour ouvrir la page de choix.

Avec un numéro ou des mots : `lire_sessions` sur la tâche. Si une session est encore ouverte
sur cette tâche ailleurs (autre poste, autre dossier, autre personne), signale-le en une ligne et
demande avant d'ouvrir. Puis `ouvrir_session` (assistant `claude_code`, ton modèle, poste, dossier,
`sessionRef` = la référence de cette conversation, `objective` = « à préciser »).

## 4. Montrer le choix

Lis la carte avec `lire_tache`, quelle que soit la façon dont la tâche a été trouvée (page de choix
comprise), et lis-la vraiment : c'est le point de départ du travail.

Une ligne : numéro, titre, tableau, projet, client (« projet interne » s'il n'y en a pas).
Puis le contenu de la carte : la description en entier (sans la résumer ni la couper), la priorité
et l'échéance s'il y en a, les commentaires (auteur, date, texte), et le nom des pièces jointes.
Ne répète pas le résumé s'il redit la description. Rien d'autre sur la carte : dis-le en une ligne.
Si la tâche a déjà eu une session : deux lignes sur là où le travail s'était arrêté (résumé,
reste à faire, prochaine étape de la dernière session). Les heures du site sont en temps
universel : convertis-les en heure locale, ou ne donne que la date.

Termine par : « Qu'est-ce qu'on fait ? »

## 5. Demande de départ

La première demande de travail que l'utilisateur fait ensuite est la demande de départ : range-la
avec `noter_session` (`objective`), en quelques lignes, avant de commencer le travail.

## Règles jusqu'à la clôture de la session

Elles valent pour toute la suite de cette conversation, jusqu'à `/kodeban:out`.

- Tiens la note de la session à jour (`noter_session` : ce qui a été fait, les décisions avec leur
  raison, ce qu'il reste à faire, la prochaine étape) après chaque étape importante, et au moins
  après chaque commit. Après un commit, ajoute aussi le commit et la branche à la session
  (`ajouter_reference_session`).
- Une question sans modification de code : réponds, ne note rien.
- Une demande de code hors du sujet de la tâche : arrête-toi et demande « Je la mets de côté, ou on
  la traite ici ? ».
  - « De côté » : crée une tâche dans la première colonne du tableau de la session (`creer_tache`),
    dis-le en une ligne, puis reprends le travail.
  - « Ici » : crée la tâche, fais le travail, commente cette tâche (ce qui a été fait, le commit),
    et ajoute une ligne dans la note de la session.
- Demande confirmation avant toute suppression dans KodeBan.
- Jamais de mot de passe, de clé ni de donnée d'un client dans une note ou un commentaire.
- Ne devine jamais le projet ni la tâche : demande.
- Ne clôture jamais la session de toi-même : c'est `/kodeban:out`.
