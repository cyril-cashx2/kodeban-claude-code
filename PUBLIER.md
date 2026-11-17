# Publier une nouvelle version du paquet

Depuis le Mac comme depuis le PC : le dépôt GitHub `cyril-cashx2/kodeban-claude-code` fait foi.
Les utilisateurs installent le paquet depuis ce dépôt ; ils ne reçoivent une mise à jour que si le
**numéro de version** change.

```bash
git pull
# 1. Modifier le paquet (plugins/kodeban/...)
# 2. Changer le numéro dans plugins/kodeban/.claude-plugin/plugin.json (seul endroit où il est écrit)
#    0.1.0 → 0.1.1 (correction), 0.2.0 (nouveauté)
claude plugin validate --strict .
claude plugin validate --strict plugins/kodeban
git add -A && git commit -m "kodeban 0.1.1 : …"
claude plugin tag plugins/kodeban          # crée l'étiquette kodeban--v0.1.1
git push && git push --tags
```

Essai avant publication, sur le poste : `claude --plugin-dir plugins/kodeban` lance Claude Code
avec le paquet du dossier, sans l'installer.

Jamais dans le dépôt : une clé, une adresse privée, un nom de client.
