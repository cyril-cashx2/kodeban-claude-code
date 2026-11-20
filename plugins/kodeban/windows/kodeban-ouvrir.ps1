# Version Windows (PowerShell) de bin/kodeban-ouvrir, lancée par bin/kodeban-ouvrir.cmd : même comportement.
# Ouvre une adresse http(s) dans le navigateur. Code d'erreur si rien ne s'ouvre.
#   kodeban-ouvrir <adresse>            ouvre
#   kodeban-ouvrir --essai <adresse>    dit seulement ce qui serait lancé
#
# Si le navigateur par défaut est Chrome ou Edge : fenêtre à part, sans onglets ni barre d'adresse
# (mode « application »), avec le profil habituel, donc la connexion à KodeBan déjà faite.
# Sinon (Firefox…) : un onglet ordinaire. KODEBAN_FENETRE=0 force toujours l'onglet.
[Console]::OutputEncoding = New-Object System.Text.UTF8Encoding $false
$liste = @($args | ForEach-Object { "$_" })
$essai = $false
if ($liste.Count -ge 1 -and $liste[0] -eq '--essai') {
  $essai = $true
  $liste = @($liste | Select-Object -Skip 1)
}
$adresse = ''
if ($liste.Count -ge 1) { $adresse = $liste[0] }
if ($adresse -notmatch '^https?://') {
  [Console]::Error.Write("Adresse refusée (http:// ou https:// attendu).`n")
  exit 2
}

# Navigateur par défaut, quand c'est Chrome ou Edge : « chrome », « edge », sinon rien.
function Get-NavigateurParDefaut {
  $cle = 'HKCU:\Software\Microsoft\Windows\Shell\Associations\UrlAssociations\https\UserChoice'
  $progid = (Get-ItemProperty -Path $cle -Name ProgId -ErrorAction SilentlyContinue).ProgId
  if ($progid -like 'ChromeHTML*') { return 'chrome' }
  if ($progid -like 'MSEdgeHTM*') { return 'edge' }
  return ''
}

# Programme du navigateur ; vide s'il est introuvable.
function Get-Programme([string]$nav) {
  if ($nav -eq 'chrome') { $rel = 'Google\Chrome\Application\chrome.exe' } else { $rel = 'Microsoft\Edge\Application\msedge.exe' }
  foreach ($base in @($env:ProgramFiles, ${env:ProgramFiles(x86)}, $env:LOCALAPPDATA)) {
    if (-not $base) { continue }
    $chemin = Join-Path $base $rel
    if (Test-Path -LiteralPath $chemin -PathType Leaf) { return $chemin }
  }
  return ''
}

$exe = ''
if ($env:KODEBAN_FENETRE -ne '0') {
  $nav = Get-NavigateurParDefaut
  if ($nav) { $exe = Get-Programme $nav }
}

if ($exe) {
  if ($essai) { [Console]::Out.Write("$exe --app=$adresse`n"); exit 0 }
  try {
    Start-Process -FilePath $exe -ArgumentList "--app=$adresse" -ErrorAction Stop | Out-Null
    exit 0
  } catch {
    [Console]::Error.Write("Le navigateur ne s'est pas ouvert.`n")
    exit 1
  }
}
if ($essai) { [Console]::Out.Write("rundll32.exe url.dll,FileProtocolHandler $adresse`n"); exit 0 }
try {
  Start-Process -FilePath 'rundll32.exe' -ArgumentList 'url.dll,FileProtocolHandler', $adresse -ErrorAction Stop | Out-Null
  exit 0
} catch {
  [Console]::Error.Write("Le navigateur ne s'est pas ouvert.`n")
  exit 1
}
