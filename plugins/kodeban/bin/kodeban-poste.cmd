@echo off
rem Lanceur Windows. PowerShell et cmd prennent ce fichier avant le script Bash du meme nom (sans
rem extension), qu'ils ne savent pas executer. Il lance la version PowerShell du dossier windows\
rem du paquet : ni Git ni Bash ne sont necessaires. Depuis Bash, c'est le script Bash qui tourne.
"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoLogo -NoProfile -NonInteractive -ExecutionPolicy Bypass -File "%~dp0..\windows\%~n0.ps1" %*
exit /b %errorlevel%
