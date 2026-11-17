---
description: Noter une chose à faire plus tard dans le tableau de la session KodeBan en cours.
argument-hint: "<texte>"
disable-model-invocation: true
allowed-tools: Bash(kodeban-poste) Bash(kodeban-poste *) mcp__plugin_kodeban_kodeban__mes_sessions_ouvertes mcp__plugin_kodeban_kodeban__lire_tableau mcp__plugin_kodeban_kodeban__creer_tache
---

# /kodeban:todo — je note une chose pour plus tard

Texte à noter : « $ARGUMENTS »
Référence de cette conversation : `${CLAUDE_SESSION_ID}`

Parle en français courant, en phrases courtes, sans jargon et sans nom d'outil.

Si un outil KodeBan ne répond pas (pas encore autorisé, accès révoqué, site éteint) : dis-le en une
phrase, ajoute « Branchez KodeBan : tapez `/mcp`, choisissez kodeban, puis authentifiez-vous. », et
arrête-toi.

1. Appelle `mes_sessions_ouvertes` **sans aucun argument** (ni poste ni dossier : le dossier
   courant a pu changer depuis l'ouverture). La session de cette conversation est celle dont la
   référence (`sessionRef`) est celle de cette conversation, ou celle que cette conversation a
   ouverte, quels que soient son poste et son dossier. S'il n'y en a pas : « Faites d'abord `/kodeban:in`. »
   et rien d'autre.
2. Sans texte : demande le texte et attends.
3. Crée la tâche dans la première colonne du tableau de la session (`creer_tache` ; si la première
   colonne n'est pas donnée par la session, lis le tableau). Titre = le texte, coupé à 200
   caractères ; s'il est plus long, le texte entier va dans la description. Ne touche pas à la
   session, ne change pas de sujet.
4. Une seule ligne : « Noté : tâche #57 « … », dans À faire. » (numéro, titre et colonne réels),
   puis reprends là où on en était.
