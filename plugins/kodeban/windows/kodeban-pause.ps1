# Version Windows (PowerShell) de bin/kodeban-pause, lancée par bin/kodeban-pause.cmd.
# Attend quelques secondes (3 par défaut, de 1 à 15).
$s = 3
if ($args.Count -ge 1 -and "$($args[0])" -match '^[0-9]+$') { $s = [long]"$($args[0])" }
if ($s -lt 1) { $s = 1 }
if ($s -gt 15) { $s = 15 }
Start-Sleep -Seconds $s
