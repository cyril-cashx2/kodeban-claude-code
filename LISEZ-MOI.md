# Le paquet KodeBan pour Claude Code

Trois commandes pour piloter votre travail dans [KodeBan](https://kodeban.fr) depuis Claude Code :

| Commande | Ce qu'elle fait |
|---|---|
| `/kodeban:in` | je commence : choisir la tâche et ouvrir une session de travail |
| `/kodeban:out` | j'ai fini, ou je m'arrête : clôturer la session avec sa note |
| `/kodeban:todo` | je note une chose pour plus tard, sans quitter ce que je fais |

Rien ne se lance tout seul : seules ces trois commandes agissent, et seulement quand vous les tapez.

## Installer

Il vous faut une **clé d'accès** KodeBan : dans KodeBan, **Mon profil › Clés d'accès › Créer**.

Dans Claude Code (terminal ou extension VS Code) :

```
/plugin marketplace add cyril-cashx2/kodeban-claude-code
/plugin install kodeban@kodeban
```

Claude Code demande alors :
- **l'adresse du branchement** : `https://kodeban.fr/api/mcp` (proposée) ; en local, `http://127.0.0.1:8091/mcp` ;
- **votre clé** : masquée à la saisie, rangée dans le coffre du système, jamais dans un fichier.

En ligne de commande (`claude plugin install kodeban@kodeban`), rien n'est demandé : tapez ensuite
`/plugin configure kodeban` dans Claude Code.

Redémarrez Claude Code après l'installation.

Si vous aviez branché KodeBan à la main (`claude mcp add … kodeban2 …`), retirez ce branchement :
`claude mcp remove kodeban2`. Sinon, les outils seraient en double.

## Les commandes

**`/kodeban:in`** — trois façons :
- `/kodeban:in` : la page de choix s'ouvre dans votre navigateur, vous cliquez sur la tâche ;
- `/kodeban:in 57` : la tâche n° 57 ;
- `/kodeban:in charte graphique` : la tâche qui correspond à ces mots (s'il y en a plusieurs, elles vous sont proposées).

Une conversation = une session. Votre première demande après `/kodeban:in` devient la demande de
départ de la session. Ensuite, Claude tient la note de la session à jour au fil du travail.

**`/kodeban:out`** : Claude montre la note finale (ce qui a été fait, décisions, commits, reste à
faire, prochaine étape) et demande « terminée ou à reprendre ? ». `/kodeban:out pause` clôture
« à reprendre » sans poser la question.

**`/kodeban:todo vérifier les marges à l'impression`** : crée une tâche dans la première colonne du
tableau de la session, sans toucher à la session.

## Autorisations

Pendant le travail (par exemple après un commit), Claude Code demande une fois l'accord pour chaque
outil KodeBan. Répondez « toujours autoriser », ou ajoutez dans vos réglages
(`~/.claude/settings.json`) :

```json
{ "permissions": { "allow": ["mcp__plugin_kodeban_kodeban"] } }
```

## Mettre à jour

```
/plugin marketplace update kodeban
/plugin update kodeban@kodeban
```

puis redémarrez Claude Code. Pour recevoir les mises à jour automatiquement : `/plugin` › onglet
des catalogues › `kodeban` › activer la mise à jour automatique.

## Désinstaller

```
/plugin uninstall kodeban@kodeban
```

Votre clé reste valable dans KodeBan : révoquez-la dans **Mon profil › Clés d'accès** si vous n'en
avez plus besoin.

## En cas de souci

- **« Vérifiez l'adresse et la clé »** : `/plugin configure kodeban`, puis redémarrez Claude Code.
- **Clé refusée** : clé mal recopiée, révoquée, ou compte désactivé. Créez-en une autre.
- **La page de choix ne s'ouvre pas** : l'adresse est affichée, ouvrez-la vous-même.
- **Accès de votre organisation expiré** : voyez avec l'administrateur de votre organisation.
