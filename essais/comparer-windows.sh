#!/usr/bin/env bash
# Sous Windows, depuis Git Bash : vérifie que les versions PowerShell (plugins/kodeban/windows/*.ps1)
# donnent la même sortie et le même code que les scripts Bash (bin/, hooks/).
#   bash essais/comparer-windows.sh
# Aucun réseau. Les noms de conversation sont écrits dans un dossier jetable, jamais dans ~/.claude.
set -u
racine="$(cd "$(dirname "$0")/.." && pwd)"
paquet="$racine/plugins/kodeban"
case "$(uname -s)" in MINGW*|MSYS*|CYGWIN*) ;; *) echo "À lancer sous Windows (Git Bash)." >&2; exit 2 ;; esac

jetable="$(mktemp -d)"
trap 'rm -rf "$jetable"' EXIT
export HOME="$jetable"
echecs=0

# Lance une version ; écrit « code=N » puis la sortie (erreurs comprises), fins de ligne Windows retirées.
lancer_bash() { local s="$1"; shift; local e="${ENTREE:-}"; { printf '%s' "$e" | "$paquet/$s" "$@" 2>&1; echo "code=$?"; } | tr -d '\r'; }
lancer_ps() { local n="$1"; shift; local e="${ENTREE:-}"; { printf '%s' "$e" | powershell.exe -NoLogo -NoProfile -NonInteractive -ExecutionPolicy Bypass -File "$(cygpath -w "$paquet/windows/$n.ps1")" "$@" 2>&1; echo "code=$?"; } | tr -d '\r'; }

comparer() { # libellé, script Bash (relatif au paquet), arguments…
  local libelle="$1" script="$2"; shift 2
  local n; n="$(basename "$script")"
  local a b
  a="$(lancer_bash "$script" "$@")"
  [ -n "${AVANT_PS:-}" ] && eval "$AVANT_PS"
  b="$(lancer_ps "$n" "$@")"
  if [ -n "${NORMALISER:-}" ]; then a="$(printf '%s' "$a" | eval "$NORMALISER")"; fi
  if [ "$a" = "$b" ]; then echo "ok      $libelle"
  else
    echo "ÉCHEC   $libelle"; echo "  bash       : $a" | head -5; echo "  powershell : $b" | head -5
    echecs=$((echecs + 1))
  fi
}

comparer "poste" bin/kodeban-poste
comparer "nommer sans argument" bin/kodeban-nommer
comparer "nommer sans nom" bin/kodeban-nommer abc
comparer "nommer ordinaire" bin/kodeban-nommer d8a0-b375 "#152 Un titre"
comparer "nommer accents et signes" bin/kodeban-nommer 'x/y z' '#7 « été » & | ; $HOME %PATH% ! ~' 'deux mots'
comparer "nommer guillemet et barre inverse retirés" bin/kodeban-nommer ref '#8 "dit" C:\dossier'
comparer "pause hors bornes" bin/kodeban-pause 0
comparer "ouvrir adresse refusée" bin/kodeban-ouvrir ftp://exemple
comparer "ouvrir sans adresse" bin/kodeban-ouvrir --essai
# Bash écrit le chemin du navigateur à la façon Unix (/c/Program Files/…) : on le remet à la façon Windows.
NORMALISER='awk '\''/^\/[a-z]\// { split($0, p, " --app="); cmd = "cygpath -w \"" p[1] "\""; cmd | getline w; close(cmd); print w " --app=" p[2]; next } { print }'\''' \
  comparer "ouvrir --essai" bin/kodeban-ouvrir --essai https://kodeban.fr/choisir/abc
KODEBAN_FENETRE=0 comparer "ouvrir --essai en onglet" bin/kodeban-ouvrir --essai https://kodeban.fr/choisir/abc

# Crochet : le nom préparé est rendu une fois, puis effacé.
mkdir -p "$HOME/.claude/kodeban/titres"
prep='printf "%s" "#152 « Titre » é" > "$HOME/.claude/kodeban/titres/essai-ref"'
eval "$prep"
ENTREE='{"session_id":"essai-ref","prompt":"x"}' AVANT_PS="$prep" comparer "crochet avec un nom préparé" hooks/titre-session
ENTREE='{"session_id":"essai-ref","prompt":"x"}' comparer "crochet sans nom préparé" hooks/titre-session
ENTREE='{"prompt":"x"}' comparer "crochet sans référence" hooks/titre-session

if [ "$echecs" -gt 0 ]; then echo "$echecs écart(s)."; exit 1; fi
echo "Les versions Bash et PowerShell donnent la même chose."
