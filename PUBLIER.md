# Publier une nouvelle version du paquet

Depuis le Mac comme depuis le PC : le dépôt GitHub `kodeban/claude-code` fait foi.
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

## Windows

Chaque commande de `bin/` et le crochet de `hooks/` ont une version PowerShell dans
`plugins/kodeban/windows/`, lancée par le `.cmd` du même nom : PowerShell et cmd le prennent avant
le script Bash, et rien n'exige Git ni Bash. Toute modification d'un script Bash se reporte dans sa
version PowerShell ; avant de publier, sur un PC : `bash essais/comparer-windows.sh`.
