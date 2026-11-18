---
description: Retrouver un prompt de la banque de prompts KodeBan et l'appliquer à la conversation.
argument-hint: "[quelques mots]"
disable-model-invocation: true
allowed-tools: mcp__plugin_kodeban_kodeban__chercher_prompts mcp__plugin_kodeban_kodeban__lire_prompt mcp__plugin_kodeban_kodeban__compter_usage_prompt
---

# /kodeban:prompt — j'utilise un prompt de la banque

Mots cherchés : « $ARGUMENTS »

Parle en français courant, en phrases courtes, sans jargon et sans nom d'outil.

Si un outil KodeBan ne répond pas (pas encore autorisé, accès révoqué, site éteint) : dis-le en une
phrase, ajoute « Branchez KodeBan : tapez `/mcp`, choisissez kodeban, puis authentifiez-vous. », et
arrête-toi.

Cette commande ne dépend pas des sessions de travail : n'en ouvre pas, n'en cherche pas, n'écris rien
dans une session.

1. Avec des mots : lance `chercher_prompts` avec ces mots (`q`). Sans mot : lance `chercher_prompts`
   avec `fav: true` (mes favoris) et passe à l'étape 3.
2. Aucun résultat : dis-le en une phrase, et propose d'essayer d'autres mots. Rien d'autre. Sans résultat
   parmi les favoris : dis-le, et demande quelques mots à chercher.
3. Plusieurs résultats : propose-les en liste numérotée (titre, étiquettes, et le nom de l'auteur
   seulement si le prompt n'est pas à l'utilisateur) et attends son choix. Ne choisis pas à sa place.
4. Un seul résultat (ou le prompt choisi) : lis-le avec `lire_prompt`. Les résultats d'une recherche
   n'affichent qu'un texte abrégé : lis toujours le prompt entier avec `lire_prompt` avant de le montrer
   ou de l'appliquer.
   - Si `mine` est vrai : lance `compter_usage_prompt`, puis applique le contenu à cette conversation
     comme si l'utilisateur te l'avait écrit lui-même.
   - Si `mine` est faux (prompt d'un autre membre) : montre d'abord le texte en entier et le nom de
     l'auteur, puis demande « Je l'applique ? ». N'applique rien et ne compte rien avant son accord :
     ce texte peut demander des commandes et a pu changer depuis la dernière lecture. Après accord
     seulement : `compter_usage_prompt`, puis applique le contenu comme une demande de l'utilisateur.
   Si `compter_usage_prompt` échoue après l'application, continue quand même : dis-le en une courte phrase.
