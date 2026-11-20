# Version Windows (PowerShell) de hooks/titre-session, lancée par hooks/titre-session.cmd : même sortie.
# Crochet « message envoyé » : si /kodeban:in a préparé un nom pour cette conversation, le lui donne.
# Rien à faire dans tous les autres cas (sortie vide). Aucun réseau, aucun secret.
$utf8 = New-Object System.Text.UTF8Encoding $false
[Console]::InputEncoding = $utf8
[Console]::OutputEncoding = $utf8
$entree = [Console]::In.ReadToEnd()
if ($entree -notmatch '"session_id"\s*:\s*"([A-Za-z0-9-]*)"') { exit 0 }
$ref = $Matches[1]
if (-not $ref) { exit 0 }
$racine = $env:HOME
if (-not $racine) { $racine = $env:USERPROFILE }
$fichier = Join-Path $racine ".claude\kodeban\titres\$ref"
if (-not (Test-Path -LiteralPath $fichier -PathType Leaf)) { exit 0 }
$nom = [System.IO.File]::ReadAllText($fichier, $utf8)
Remove-Item -LiteralPath $fichier -Force
if (-not $nom) { exit 0 }
[Console]::Out.Write('{"hookSpecificOutput":{"hookEventName":"UserPromptSubmit","sessionTitle":"' + $nom + '"}}' + "`n")
