# Version Windows (PowerShell) de bin/kodeban-nommer, lancée par bin/kodeban-nommer.cmd : même sortie.
# Prépare le nom de la conversation : kodeban-nommer <référence de la conversation> <nom>
# Le crochet « titre-session » le donne à la conversation au message suivant, puis l'efface.
# Aucun réseau, aucun secret.
[Console]::OutputEncoding = New-Object System.Text.UTF8Encoding $false
$ref = ''
if ($args.Count -ge 1) { $ref = "$($args[0])" -replace '[^A-Za-z0-9-]', '' }
$reste = @()
if ($args.Count -ge 2) { $reste = $args[1..($args.Count - 1)] }
# Ni guillemet, ni barre oblique inversée, ni caractère de contrôle : le nom est recopié tel quel en JSON.
$nom = ($reste -join ' ') -replace '[\\"\x00-\x1F]', ''
if (-not $ref -or -not $nom) {
  [Console]::Error.Write("usage: kodeban-nommer <référence> <nom>`n")
  exit 2
}
$racine = $env:HOME
if (-not $racine) { $racine = $env:USERPROFILE }
$dossier = Join-Path $racine '.claude\kodeban\titres'
New-Item -ItemType Directory -Force -Path $dossier | Out-Null
[System.IO.File]::WriteAllText((Join-Path $dossier $ref), $nom, (New-Object System.Text.UTF8Encoding $false))
[Console]::Out.Write("nom préparé : $nom`n")
