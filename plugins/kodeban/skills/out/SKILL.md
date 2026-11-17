---
description: Clôturer la session KodeBan de cette conversation (terminée ou à reprendre).
argument-hint: "[pause]"
disable-model-invocation: true
allowed-tools: Bash(kodeban-poste) Bash(kodeban-poste *) Bash(git log *) Bash(git branch *) Bash(git rev-parse *) mcp__plugin_kodeban_kodeban__mes_sessions_ouvertes mcp__plugin_kodeban_kodeban__lire_sessions mcp__plugin_kodeban_kodeban__noter_session mcp__plugin_kodeban_kodeban__ajouter_reference_session mcp__plugin_kodeban_kodeban__cloturer_session mcp__plugin_kodeban_kodeban__lire_tache
---

# /kodeban:out — j'ai fini, ou je m'arrête

Ce que l'utilisateur a écrit après la commande : « $ARGUMENTS »
Référence de cette conversation : `${CLAUDE_SESSION_ID}`

Parle en français courant, en phrases courtes, sans jargon et sans nom d'outil.

Si un outil KodeBan ne répond pas (clé absente ou refusée, site éteint) : dis-le en une phrase,
ajoute « Vérifiez l'adresse et la clé avec `/plugin configure kodeban`. », et arrête-toi.

## 1. La session de cette conversation

Lance `kodeban-poste`, puis `mes_sessions_ouvertes` avec ce poste et ce dossier. La session de
cette conversation est celle dont la référence (`sessionRef`) est celle de cette conversation, ou
celle que cette conversation a ouverte. S'il n'y en a pas : « Aucune session ouverte dans cette
conversation. » et rien d'autre.

## 2. La note finale

Rédige et montre la note finale, courte :
- ce qui a été fait ;
- les décisions, chacune avec sa raison ;
- les commits ;
- ce qu'il reste à faire ;
- la prochaine étape.

Sans mot de passe, sans clé, sans donnée d'un client. Jamais la conversation recopiée.

## 3. L'accord

- Sans `pause` : demande « Terminée, ou à reprendre ? » et l'accord sur la note. Attends la réponse.
- Avec `pause` : demande seulement l'accord sur la note ; la session sera clôturée « à reprendre ».
  Attends la réponse.

Corrige la note si l'utilisateur le demande, puis redemande l'accord.

## 4. Clôturer

Ajoute à la session les commits de cette conversation qui n'y sont pas encore
(`ajouter_reference_session`, avec la branche), puis `cloturer_session` (`done` = terminée,
`resume` = à reprendre) avec la note.

Si le site refuse (note incomplète) : complète ce qui manque — demande à l'utilisateur si tu ne le
sais pas — et recommence. Jamais de contournement.

## 5. Une ligne pour finir

Où se trouve maintenant la tâche (colonne, tableau), ou « À reprendre : la tâche n'a pas bougé. »
