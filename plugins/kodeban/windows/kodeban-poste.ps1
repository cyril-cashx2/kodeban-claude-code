# Version Windows (PowerShell) de bin/kodeban-poste, lancée par bin/kodeban-poste.cmd : même sortie.
# Affiche le poste (nom de la machine) et le dossier de travail (racine du dépôt Git, sinon dossier courant).
# Aucun réseau, aucun secret.
[Console]::OutputEncoding = New-Object System.Text.UTF8Encoding $false
$poste = $env:COMPUTERNAME
if (-not $poste) { $poste = [System.Net.Dns]::GetHostName() }
$dossier = $null
if (Get-Command git.exe -ErrorAction SilentlyContinue) {
  $dossier = & git.exe rev-parse --show-toplevel 2>$null
}
if (-not $dossier) { $dossier = (Get-Location).ProviderPath -replace '\\', '/' }
[Console]::Out.Write("poste: $poste`ndossier: $dossier`n")
