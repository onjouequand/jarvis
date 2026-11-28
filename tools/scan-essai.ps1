<#
Scan rapide réel de J.A.R.V.I.S., sans clavier (v3.25, audit du 23/11/2026, constat T1). Les tests T1 ne vérifient que
des fonctions ; ce script fait tourner le programme principal (sections 01 à 13, synthèse, rapport, questions de fin de
scan) et refuse le résultat à la moindre erreur PowerShell. Lancé par GitHub à chaque envoi (.github/workflows/check.yml).

  powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\scan-essai.ps1 [-Mode cmd|source] [-OutDir dossier]

-Mode cmd    : GitHub seulement. Lance le JARVIS.cmd du dépôt comme un double-clic (en-tête, empreinte, options lues
               dans JARVIS_ARGS). Réponse envoyée : « 2 » au menu d'installation (« Lancer sans installer »), puis fin
               de l'entrée : chaque question suivante reçoit une annulation, qui vaut « non » (règle 4). Refusé hors de
               GitHub : sur un PC où J.A.R.V.I.S. est installé, le premier menu est un autre et « 2 » y veut dire
               « Réinstaller ».
-Mode source : tout PC. Copie de la source (ou de -Source) avec un autre nom de verrou (règle 25), lancée par -File,
               dans sa propre fenêtre cachée, sans aucune réponse ; rapports et préférences dans le dossier d'essai
               (LOCALAPPDATA et APPDATA redirigés), jamais dans ceux du compte. Ne montre pas les erreurs propres au
               lancement par JARVIS.cmd (règle 29).
Entrée redirigée : le programme n'avale plus ses propres erreurs (v3.25, $ErrorActionPreference = 'Continue'), qui
arrivent sur la sortie d'erreur et font échouer l'essai.
Aucune action n'est lancée : toutes les questions de fin de scan ont « non » pour réponse par défaut ou reçoivent une
annulation, et le script vérifie qu'aucune n'a tourné. Code de sortie : 0 si tout est conforme, 1 sinon.
#>
param(
    [ValidateSet('cmd', 'source')] [string]$Mode = 'source',
    [string]$OutDir,
    [string]$Source,
    [int]$TimeoutMin = 25
)

$ErrorActionPreference = 'Stop'
try { [Console]::OutputEncoding = [Text.Encoding]::UTF8 } catch { $null = $_ }
$Root = Split-Path -Parent $PSScriptRoot
if (-not $OutDir) { $OutDir = Join-Path ([IO.Path]::GetTempPath()) ('jarvis-scan-essai-' + (Get-Date -Format 'yyyyMMdd_HHmmss')) }
New-Item -ItemType Directory -Path $OutDir -Force | Out-Null
$System = [Environment]::GetFolderPath('System')
$Fails = New-Object System.Collections.Generic.List[string]
function Add-Fail([string]$Message) { $Fails.Add($Message); Write-Host ('  [FAIL] ' + $Message) -ForegroundColor Red }
function Add-Pass([string]$Message) { Write-Host ('  [ OK ] ' + $Message) -ForegroundColor Green }

$regKey = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\JARVIS'
# Get-InstalledJarvis reconnaît une installation par la clé de registre ou par ce marqueur
$marker = Join-Path ([Environment]::GetFolderPath('ProgramFiles')) 'JARVIS\.jarvis-install'
$envOver = @{}
if ($Mode -eq 'cmd') {
    if ($env:GITHUB_ACTIONS -ne 'true') {
        Write-Host 'Mode cmd réservé à GitHub : sur ce PC, utilise -Mode source.' -ForegroundColor Red
        exit 1
    }
    if ((Test-Path -LiteralPath $regKey) -or (Test-Path -LiteralPath $marker)) {
        Write-Host 'J.A.R.V.I.S. est installé sur cette machine : la réponse « 2 » y voudrait dire autre chose que « Lancer sans installer ».' -ForegroundColor Red
        exit 1
    }
    $file = Join-Path $System 'cmd.exe'
    $target = Join-Path $Root 'JARVIS.cmd'
    $arguments = '/d /c ""{0}" -Quick -NoAnim -NoElevate -Name Essai"' -f $target
    $stdin = "2`r`n"
    $reportDirs = @((Join-Path $env:LOCALAPPDATA 'JARVIS\Rapports'), (Join-Path $env:TEMP 'JARVIS'))
} else {
    # Copie avec un autre verrou : une fenêtre J.A.R.V.I.S. ouverte sur ce PC ne bloque pas l'essai, et inversement
    if (-not $Source) { $Source = Join-Path $Root 'src\jarvis-checkup.ps1' }
    $src = [IO.File]::ReadAllText($Source)
    $n = ([regex]::Matches($src, [regex]::Escape("'Local\JARVIS_CheckUp'"))).Count
    if ($n -lt 1) { Write-Host 'Nom du verrou introuvable dans la source.' -ForegroundColor Red; exit 1 }
    $copy = Join-Path $OutDir 'jarvis-essai.ps1'
    [IO.File]::WriteAllText($copy, $src.Replace("'Local\JARVIS_CheckUp'", "'Local\JARVIS_CheckUp_Essai'"), (New-Object Text.UTF8Encoding $true))
    $file = Join-Path $System 'WindowsPowerShell\v1.0\powershell.exe'
    $arguments = '-NoProfile -ExecutionPolicy Bypass -File "{0}" -Quick -NoAnim -NoElevate -Name Essai' -f $copy
    $stdin = ''
    $local = Join-Path $OutDir 'Local'
    $roaming = Join-Path $OutDir 'Roaming'
    New-Item -ItemType Directory -Path $local, $roaming -Force | Out-Null
    $envOver = @{ LOCALAPPDATA = $local; APPDATA = $roaming }
    $reportDirs = @((Join-Path $local 'JARVIS\Rapports'), (Join-Path $env:TEMP 'JARVIS'))
}

Write-Host ('Scan rapide sans clavier (mode {0}) : {1} {2}' -f $Mode, $file, $arguments) -ForegroundColor White
$start = Get-Date
$psi = New-Object Diagnostics.ProcessStartInfo
$psi.FileName = $file
$psi.Arguments = $arguments
$psi.WorkingDirectory = $Root
$psi.UseShellExecute = $false
$psi.RedirectStandardInput = $true
$psi.RedirectStandardOutput = $true
$psi.RedirectStandardError = $true
$psi.StandardOutputEncoding = New-Object Text.UTF8Encoding $false
$psi.StandardErrorEncoding = New-Object Text.UTF8Encoding $false
foreach ($k in $envOver.Keys) { $psi.EnvironmentVariables[$k] = $envOver[$k] }
# Variables d'un éventuel J.A.R.V.I.S. parent : en mode source, JARVIS_SELF ferait croire à un lancement par JARVIS.cmd
foreach ($k in @('JARVIS_SELF', 'JARVIS_ARGS', 'JARVIS_RC')) { $psi.EnvironmentVariables.Remove($k) }
# Mode source : fenêtre à part, pour que Clear-Host et l'agrandissement de la console ne touchent pas celle de l'appelant
if ($Mode -eq 'source') { $psi.CreateNoWindow = $true }
# v3.29 : l'entrée du programme est écrite dans l'encodage d'entrée de cette console. En UTF-8 avec marque (lancement
# depuis une console PowerShell en UTF-8, relevé le 27/11/2026), .NET écrit la marque BOM dès le lancement : la
# première question recevait ces trois octets au lieu de la fin de l'entrée. Depuis Git Bash (ibm850) et sur GitHub, pas de marque.
# Encodage changé seulement s'il porte une marque (même page de code, UTF-8), puis remis juste après le lancement :
# la console de l'appelant garde son réglage.
$inEnc = $null
try {
    if ([Console]::InputEncoding.GetPreamble().Length -gt 0) {
        $inEnc = [Console]::InputEncoding
        [Console]::InputEncoding = New-Object Text.UTF8Encoding $false
    }
} catch { $null = $_ }
$p = [Diagnostics.Process]::Start($psi)
if ($inEnc) { try { [Console]::InputEncoding = $inEnc } catch { $null = $_ } }
$outTask = $p.StandardOutput.ReadToEndAsync()
$errTask = $p.StandardError.ReadToEndAsync()
if ($stdin) { $p.StandardInput.Write($stdin) }
$p.StandardInput.Close()
$timedOut = -not $p.WaitForExit($TimeoutMin * 60000)
if ($timedOut) {
    & (Join-Path $System 'taskkill.exe') /T /F /PID $p.Id | Out-Null
    $null = $p.WaitForExit(30000)
}
# Un programme lancé par le scan peut garder la sortie ouverte après la fin de J.A.R.V.I.S. : attente bornée
$flowsDone = $outTask.Wait(60000) -and $errTask.Wait(60000)
$out = ''; $err = ''
if ($outTask.IsCompleted) { $out = $outTask.Result }
if ($errTask.IsCompleted) { $err = $errTask.Result }
$code = $null
if (-not $timedOut) { $code = $p.ExitCode }
$elapsed = (Get-Date) - $start
[IO.File]::WriteAllText((Join-Path $OutDir 'scan-sortie.txt'), $out, (New-Object Text.UTF8Encoding $false))
[IO.File]::WriteAllText((Join-Path $OutDir 'scan-erreurs.txt'), $err, (New-Object Text.UTF8Encoding $false))

Write-Host ''
Write-Host ('Résultat ({0:N0} s)' -f $elapsed.TotalSeconds) -ForegroundColor White
if (-not $flowsDone) { Add-Fail 'sorties du scan encore ouvertes 60 s après sa fin (programme lancé resté ouvert ?)' }
if ($timedOut) { Add-Fail ("scan arrêté au bout de {0} min" -f $TimeoutMin) }
elseif ($code -ne 0) { Add-Fail ('code de sortie ' + $code) }
else { Add-Pass 'code de sortie 0' }

# Erreurs de PowerShell : sur la sortie d'erreur, ou affichées comme un enregistrement d'erreur (règle 29)
if ($err.Trim()) {
    Add-Fail 'sortie d''erreur non vide (les 15 premières lignes suivent)'
    ($err -split "`r?`n" | Where-Object { $_.Trim() } | Select-Object -First 15) | ForEach-Object { Write-Host ('         ' + $_) -ForegroundColor Red }
} else { Add-Pass 'aucune erreur sur la sortie d''erreur' }
$errMarks = @($out -split "`r?`n" | Where-Object { $_ -match 'FullyQualifiedErrorId|CategoryInfo|ParserError|Au caract.re \S+:\d|At line:\d' })
if ($errMarks.Count -gt 0) {
    Add-Fail ('{0} ligne(s) d''erreur PowerShell dans l''affichage, dont : {1}' -f $errMarks.Count, $errMarks[0].Trim())
} else { Add-Pass 'aucune erreur PowerShell dans l''affichage' }

if ($Mode -eq 'cmd') {
    if ($out -match 'pas encore install' -and $out -match 'Lancer sans installer') { Add-Pass 'menu d''installation vu, réponse « Lancer sans installer »' }
    else { Add-Fail 'menu « J.A.R.V.I.S. n''est pas encore installé » absent : la réponse « 2 » a pu aller à une autre question' }
}
if ($out -match 'SYNTH' -and $out -match 'Fin de session') { Add-Pass 'scan mené jusqu''à la synthèse et à la fin de session' }
else { Add-Fail 'synthèse ou fin de session absente de l''affichage' }
# Questions posées sans réponse (Read-Answer les écrit depuis la v3.25) : la dernière est « [Entrée pour fermer] »
$asked = @($out -split "`r?`n" | Where-Object { $_ -match 'annul., fin de l.entr.e\]' })
Write-Host ('  [INFO] {0} question(s) restée(s) sans réponse, donc annulée(s) :' -f $asked.Count) -ForegroundColor Cyan
foreach ($q in $asked) { Write-Host ('         ' + $q.Trim()) -ForegroundColor DarkGray }

# Rapport écrit pendant cet essai
$rep = $null
foreach ($d in $reportDirs) {
    if (-not (Test-Path -LiteralPath $d)) { continue }
    $rep = Get-ChildItem -LiteralPath $d -File -Filter 'checkup_*.txt' | Where-Object { $_.LastWriteTime -ge $start.AddSeconds(-5) } |
        Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if ($rep) { break }
}
if (-not $rep) {
    Add-Fail ('aucun rapport écrit pendant l''essai (cherché dans : ' + ($reportDirs -join ', ') + ')')
} else {
    Copy-Item -LiteralPath $rep.FullName -Destination (Join-Path $OutDir $rep.Name) -Force
    $lines = @(Get-Content -LiteralPath $rep.FullName -Encoding UTF8)
    Add-Pass ('rapport écrit : ' + $rep.FullName)
    # Chaque section du scan rapide (01 à 13) présente, avec au moins une ligne d'état ; la 14 (scan complet) absente
    $missing = @(); $empty = @()
    for ($s = 1; $s -le 13; $s++) {
        $num = '{0:D2}' -f $s
        $i = -1
        for ($j = 0; $j -lt $lines.Count; $j++) { if ($lines[$j].StartsWith("== [$num] ")) { $i = $j; break } }
        if ($i -lt 0) { $missing += $num; continue }
        $has = $false
        for ($j = $i + 1; $j -lt $lines.Count -and -not $lines[$j].StartsWith('== '); $j++) {
            if ($lines[$j] -match '^\[( OK |WARN|FAIL|INFO)\] ') { $has = $true; break }
        }
        if (-not $has) { $empty += $num }
    }
    if ($missing.Count -gt 0) { Add-Fail ('sections absentes du rapport : ' + ($missing -join ', ')) }
    elseif ($empty.Count -gt 0) { Add-Fail ('sections sans aucune ligne d''état : ' + ($empty -join ', ')) }
    else { Add-Pass 'sections 01 à 13 présentes, chacune avec au moins une ligne d''état' }
    if (@($lines | Where-Object { $_.StartsWith('== [14] ') }).Count -gt 0) { Add-Fail 'section 14 (scan complet) lancée en scan rapide' }
    $syn = [array]::IndexOf($lines, '== SYNTHÈSE ==')
    if ($syn -lt 0 -or -not ($lines | Where-Object { $_ -like 'État général : *' })) { Add-Fail 'synthèse absente du rapport' }
    else {
        Add-Pass 'synthèse présente dans le rapport'
        Write-Host ''
        foreach ($l in ($lines[$syn..([Math]::Min($lines.Count - 1, $syn + 40))])) { Write-Host ('         ' + $l) -ForegroundColor Gray }
        Write-Host ''
    }
    if ($lines -contains '== ACTIONS LANCÉES APRÈS LE SCAN ==') { Add-Fail 'une action a été lancée après le scan alors qu''aucune réponse « oui » n''a été donnée' }
    else { Add-Pass 'aucune action lancée après le scan' }
    $adm = @($lines | Where-Object { $_ -match '^Date : .*Admin : (\S+)' } | Select-Object -First 1)
    if ($adm.Count -gt 0 -and $adm[0] -match 'Admin : (\S+)') { Write-Host ('  [INFO] droits administrateur pendant l''essai : ' + $Matches[1]) -ForegroundColor Cyan }
}
if ($Mode -eq 'cmd') {
    if ((Test-Path -LiteralPath $regKey) -or (Test-Path -LiteralPath $marker)) { Add-Fail 'J.A.R.V.I.S. a été installé pendant l''essai' }
    else { Add-Pass 'rien d''installé' }
}

Write-Host ''
Write-Host ('Sortie complète : ' + (Join-Path $OutDir 'scan-sortie.txt')) -ForegroundColor DarkGray
if ($Fails.Count -gt 0) {
    Write-Host ''
    Write-Host 'Fin de l''affichage du scan (40 dernières lignes) :' -ForegroundColor DarkGray
    ($out -split "`r?`n" | Select-Object -Last 40) | ForEach-Object { Write-Host ('   ' + $_) }
    Write-Host ("SCAN D'ESSAI REFUSÉ : {0} problème(s)." -f $Fails.Count) -ForegroundColor Red
    exit 1
}
Write-Host "SCAN D'ESSAI RÉUSSI." -ForegroundColor Green
exit 0
