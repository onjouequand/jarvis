<# : JARVIS.cmd - fichier hybride batch + PowerShell. Ne pas modifier ce fichier.
@echo off
rem JARVIS-SHA256=daba66174fbe124ddf1dd346c0c4cc586e2f35dbc41b90ceba4030515315705b
setlocal
chcp 65001 >nul
set "JARVIS_SELF=%~f0"
set "JARVIS_ARGS=%*"
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "if ($ExecutionContext.SessionState.LanguageMode -ne 'FullLanguage') { Write-Host 'PowerShell est en mode restreint sur ce PC (Controle intelligent des applications ou strategie d entreprise) : JARVIS ne peut pas fonctionner ici.' -ForegroundColor Red; exit 4 }; $t = [IO.File]::ReadAllText($env:JARVIS_SELF, [Text.Encoding]::UTF8); $e = $t.IndexOf([string][char]10 + '#' + '>'); $b = $t.Substring($e + 3); $h = -join ([Security.Cryptography.SHA256]::Create().ComputeHash([Text.Encoding]::UTF8.GetBytes($b)) | ForEach-Object { $_.ToString('x2') }); if ($e -lt 0 -or $t -notmatch ('JARVIS-SHA256=' + $h)) { Write-Host 'JARVIS.cmd est modifie ou incomplet : telecharge-le a nouveau.' -ForegroundColor Red; exit 3 }; $sb = [ScriptBlock]::Create($t); Invoke-Expression ('& $sb ' + $env:JARVIS_ARGS)"
set "JARVIS_RC=%errorlevel%"
if "%JARVIS_RC%"=="3" pause
if "%JARVIS_RC%"=="4" pause
exit /b %JARVIS_RC%
#>
<#
    J.A.R.V.I.S. // Check-up système v3.12
    -----------------------------------------------------------------
    Modules :
      [01] Système        : version Windows, uptime, redémarrage en attente
      [02] Windows Update : mises à jour en attente, dernière installation
      [03] Applications   : mises à jour disponibles via winget
      [04] Pilotes        : Bluetooth, Wi-Fi, réseau, GPU + périphériques en erreur
      [05] Bluetooth      : service, adaptateur, économie d'énergie
      [06] Sécurité       : Defender, pare-feu, Secure Boot, TPM, point de restauration
      [07] Stockage       : espace libre, santé, température et usure des SSD
      [08] Ressources     : CPU, RAM, processus gourmands, programmes au démarrage
      [09] Réseau         : passerelle, latence Internet, DNS, vitesse de lien
      [10] Journaux       : arrêts brutaux, écrans bleus, erreurs matérielles (7 j)
      [11] Nettoyage      : taille des fichiers temporaires et de la corbeille
      [12] BIOS           : version et date du firmware
      [13] Intégrité      : DISM, SFC /scannow, CHKDSK  (mode complet uniquement)

    Le mode rapide ne modifie rien.
    Le mode complet lance SFC /scannow, qui répare lui-même les fichiers
    système corrompus qu'il trouve (comportement standard de SFC).
    Toute autre action (winget, nettoyage, DISM RestoreHealth) demande ta
    confirmation explicite en fin de scan.
    Un rapport texte est enregistré dans %LOCALAPPDATA%\JARVIS\Rapports
    (repli : %TEMP%\JARVIS).

    Distribution : un seul fichier, JARVIS.cmd (batch + PowerShell).
    Premier lancement : J.A.R.V.I.S. propose de s'installer lui-même dans
    C:\Program Files\JARVIS (validation administrateur demandée : seul un
    administrateur peut ensuite modifier le programme), crée un raccourci
    « JARVIS » dans le menu Démarrer (et sur le Bureau si souhaité), qui
    s'ouvre directement en administrateur. Un ancien JARVIS au même endroit
    est remplacé (mise à jour) ; les anciens emplacements (C:\Outils\JARVIS,
    %LOCALAPPDATA%\Programs\JARVIS) sont migrés puis nettoyés.
    Rapports et profil : %LOCALAPPDATA%\JARVIS (accès direct via le menu [R]).
    Mise à jour en ligne : au menu, J.A.R.V.I.S. demande à GitHub (3 s au plus,
    rien n'est affiché si le PC est hors ligne) s'il existe une version plus
    récente ; si oui, le menu [U] l'affiche, la télécharge, contrôle son
    empreinte et l'installe. Aussi : JARVIS.cmd -Update.
    Mise à jour manuelle : lancer le nouveau JARVIS.cmd. Il détecte la version installée
    (registre Windows), propose la mise à jour si la sienne est plus récente,
    refuse de remplacer une version plus récente, et ne remplace jamais un
    JARVIS en cours d'exécution.
    Désinstallation : menu [4], Paramètres Windows > Applications installées,
    ou JARVIS.cmd -Uninstall.
    Annuler une question : Échap ou Ctrl+C.
    Module winget (facultatif) : menu [M], visible si le module officiel
    Microsoft.WinGet.Client est absent. Réponses possibles : installer, pas
    maintenant, ou ne plus jamais proposer (choix mémorisé dans config.json).

    Options   : -Quick      mode rapide sans menu
                -Deep       mode complet sans menu
                -NoAnim     désactive les animations
                -NoWinget   saute la vérification winget
                -NoElevate  ne propose pas la relance en administrateur
                -Name "X"   prénom à utiliser pour cette session
                -ResetName  oublie le prénom enregistré et le redemande
                -ResetChoices  oublie les choix mémorisés (ex. « ne plus proposer
                            le module winget »)
                -Ascii      affichage sans caractères spéciaux (vieilles consoles)
                -SelfTest   auto-test : vérifie que chaque composant de JARVIS
                            fonctionne sur ce PC (aussi accessible via le menu [3])
                -Install    installe sans poser la question
                -InstallDir "C:\chemin"  dossier d'installation
                -Uninstall  désinstalle J.A.R.V.I.S.
                -Update     cherche et installe la dernière version publiée

    Compatibilité : Windows 10 et 11, PC fixe ou portable, Intel / AMD /
    NVIDIA / Realtek / MediaTek / Qualcomm, Defender ou antivirus tiers,
    compte admin ou standard (contrôles réduits sans droits admin).

    Prénom : au premier lancement, J.A.R.V.I.S. le détecte depuis le compte
    Windows (compte Microsoft ou nom complet du compte local) et demande
    confirmation. Il est ensuite enregistré dans %APPDATA%\JARVIS\config.json.
#>

param(
    [switch]$Quick,
    [switch]$Deep,
    [switch]$NoAnim,
    [switch]$NoWinget,
    [switch]$NoElevate,
    [switch]$ResetName,
    [switch]$ResetChoices,
    [switch]$Ascii,
    [switch]$SelfTest,
    [switch]$Install,
    [switch]$Uninstall,
    [switch]$Update,
    [string]$InstallDir = '',
    [string]$Name = ''
)

# ------------------------------------------------------------------
# Identité du programme et emplacement
# ------------------------------------------------------------------
$JarvisVersion = '3.12'
$JarvisSelf = $env:JARVIS_SELF                     # défini par JARVIS.cmd
if (-not $JarvisSelf) { $JarvisSelf = $PSCommandPath }  # lancement direct du .ps1
$JarvisHome = $null
if ($JarvisSelf) { $JarvisHome = Split-Path -Parent $JarvisSelf }
$JarvisInstalled = [bool]($JarvisHome -and (Test-Path -LiteralPath (Join-Path $JarvisHome '.jarvis-install')))
# L'utilisateur a déjà accepté l'avertissement « Éditeur inconnu » pour ce fichier : on retire la marque
# « téléchargé depuis Internet » afin que la relance en administrateur ne pose pas la question une 2e fois.
if ($JarvisSelf -like '*.cmd') { Unblock-File -LiteralPath $JarvisSelf -ErrorAction SilentlyContinue }
$pf = $env:ProgramW6432
if (-not $pf) { $pf = $env:ProgramFiles }
$DefaultInstallDir = Join-Path $pf 'JARVIS'
$ReportRoot = Join-Path $env:LOCALAPPDATA 'JARVIS\Rapports'
$JarvisRepo = 'onjouequand/jarvis'                 # dépôt GitHub des versions publiées
$JarvisReleasePage = 'https://github.com/' + $JarvisRepo + '/releases/latest'
$LegacyDirs = @('C:\Outils\JARVIS', (Join-Path $env:LOCALAPPDATA 'Programs\JARVIS'))
$CfgDir   = Join-Path $env:APPDATA 'JARVIS'
$CfgFile  = Join-Path $CfgDir 'config.json'
$RegKey   = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\JARVIS'
$StartLnk = Join-Path ([Environment]::GetFolderPath('Programs')) 'JARVIS.lnk'
$DeskLnk  = Join-Path ([Environment]::GetFolderPath('Desktop')) 'JARVIS.lnk'

$ErrorActionPreference = 'SilentlyContinue'
try { [Console]::OutputEncoding = [Text.Encoding]::UTF8 } catch {}
try { $Host.UI.RawUI.WindowTitle = 'J.A.R.V.I.S. // System Check-up' } catch {}

# ------------------------------------------------------------------
# Adaptation à la console
# ------------------------------------------------------------------
$InWT = [bool]$env:WT_SESSION
$UseAscii = [bool]$Ascii
if (-not $UseAscii -and -not $InWT) {
    # Console classique avec police bitmap : pas de caractères de bloc
    $face = (Get-ItemProperty 'HKCU:\Console' -Name FaceName).FaceName
    if ($face -match '^Terminal$') { $UseAscii = $true }
}
$script:GlyphMap = [ordered]@{
    '█' = '#'; '░' = '.'; '─' = '-'; '│' = '|'; '┌' = '+'; '┐' = '+'; '└' = '+'; '┘' = '+'
    '═' = '='; '║' = '|'; '╔' = '+'; '╗' = '+'; '╚' = '+'; '╝' = '+'; '…' = '...'; '°' = ' '
}
function Convert-Glyph([string]$Text) {
    $t = $Text
    foreach ($k in $script:GlyphMap.Keys) { $t = $t.Replace($k, $script:GlyphMap[$k]) }
    return $t
}
if ($UseAscii) {
    function Write-Host {
        param([Parameter(Position = 0)][object]$Object = '', [switch]$NoNewline, $ForegroundColor, $BackgroundColor)
        $PSBoundParameters['Object'] = Convert-Glyph ([string]$Object)
        Microsoft.PowerShell.Utility\Write-Host @PSBoundParameters
    }
}
if (-not $InWT) {
    try {
        $raw = $Host.UI.RawUI
        if ($raw.WindowSize.Width -lt 110) {
            $b = $raw.BufferSize
            if ($b.Width -lt 110) { $b.Width = 110; $raw.BufferSize = $b }
            $ws = $raw.WindowSize
            $ws.Width = [Math]::Min(110, $raw.MaxPhysicalWindowSize.Width)
            $raw.WindowSize = $ws
        }
    } catch {}
}

# ------------------------------------------------------------------
# Références pilotes relevées sur intel.com le 19/11/2026.
# À mettre à jour à la main si Intel publie une nouvelle version.
# ------------------------------------------------------------------
$Ref = @{
    'AX200' = @{
        BT      = '24.10.0.4'
        BTNote  = 'dernière version Intel pour AX200 (fin de support)'
        WiFiPkg = '24.20.1 (03/2026)'
    }
}

# ------------------------------------------------------------------
# État global
# ------------------------------------------------------------------
$script:Ok          = 0
$script:Warnings    = New-Object System.Collections.Generic.List[string]
$script:Alerts      = New-Object System.Collections.Generic.List[string]
$script:Report      = New-Object System.Collections.Generic.List[string]
$script:WUCount     = 0
$script:WUManual    = 0
$script:WGItems     = @()
$script:WGCount     = 0
$script:WGSkipIds   = @()      # applications que winget refuse de mettre à jour (exclues de la vérification)
$script:TempMB      = 0
$script:NeedRestore = $false
$script:ChkdskFix   = New-Object System.Collections.Generic.List[string]
$script:DeepMode    = $false

# ------------------------------------------------------------------
# Rendu terminal
# ------------------------------------------------------------------
function Pause-Ms([int]$ms) { if (-not $NoAnim) { Start-Sleep -Milliseconds $ms } }

function Type-Line {
    param([string]$Text, [ConsoleColor]$Color = 'Cyan', [int]$Delay = 6)
    if ($NoAnim) { Write-Host $Text -ForegroundColor $Color; return }
    foreach ($c in $Text.ToCharArray()) {
        Write-Host $c -NoNewline -ForegroundColor $Color
        [Threading.Thread]::Sleep($Delay)
    }
    Write-Host ''
}

function Show-Banner {
    if ($UseAscii) {
        Write-Host ''
        $plain = @(
            '        _   _   ___ __   _____ ___ ',
            '     _ | | /_\ | _ \ \ / /_ _/ __|',
            '    | || |/ _ \|   /\ V / | |\__ \',
            '     \__//_/ \_\_|_\ \_/ |___|___/'
        )
        foreach ($l in $plain) { Write-Host $l -ForegroundColor Cyan; Pause-Ms 70 }
        Write-Host ''
        Write-Host '      Just A Rather Very Intelligent System' -ForegroundColor DarkGray
        Write-Host '      module check-up v3.12' -ForegroundColor DarkGray
        Write-Host ''
        return
    }
    $art = @(
        '        ██╗ █████╗ ██████╗ ██╗   ██╗██╗███████╗',
        '        ██║██╔══██╗██╔══██╗██║   ██║██║██╔════╝',
        '        ██║███████║██████╔╝██║   ██║██║███████╗',
        '   ██   ██║██╔══██║██╔══██╗╚██╗ ██╔╝██║╚════██║',
        '   ╚█████╔╝██║  ██║██║  ██║ ╚████╔╝ ██║███████║',
        '    ╚════╝ ╚═╝  ╚═╝╚═╝  ╚═╝  ╚═══╝  ╚═╝╚══════╝'
    )
    $colors = 'DarkCyan', 'DarkCyan', 'Cyan', 'Cyan', 'White', 'White'
    Write-Host ''
    for ($i = 0; $i -lt $art.Count; $i++) {
        Write-Host $art[$i] -ForegroundColor $colors[$i]
        Pause-Ms 70
    }
    Write-Host ''
    Write-Host '      Just A Rather Very Intelligent System' -ForegroundColor DarkGray
    Write-Host '      module check-up v3.12' -ForegroundColor DarkGray
    Write-Host ''
}

function Show-HexRain {
    param([int]$Lines = 4)
    $rnd = New-Object Random
    for ($i = 0; $i -lt $Lines; $i++) {
        $s = -join (1..12 | ForEach-Object { '{0:X4} ' -f $rnd.Next(0, 65535) })
        Write-Host ('   ' + $s) -ForegroundColor DarkGreen
        Pause-Ms 45
    }
}

function Show-Bar {
    param([string]$Label, [int]$Steps = 28)
    Write-Host ('   {0,-30}' -f $Label) -NoNewline -ForegroundColor DarkGreen
    Write-Host '[' -NoNewline -ForegroundColor DarkGray
    for ($i = 0; $i -lt $Steps; $i++) {
        Write-Host '█' -NoNewline -ForegroundColor Green
        Pause-Ms 10
    }
    Write-Host '] OK' -ForegroundColor DarkGray
}

function Write-Section {
    param([string]$Num, [string]$Title)
    $w = 64
    Write-Host ''
    Write-Host ('  ┌' + ('─' * $w) + '┐') -ForegroundColor DarkCyan
    Write-Host '  │' -NoNewline -ForegroundColor DarkCyan
    Write-Host ((' [' + $Num + '] ' + $Title.ToUpper()).PadRight($w)) -NoNewline -ForegroundColor Cyan
    Write-Host '│' -ForegroundColor DarkCyan
    Write-Host ('  └' + ('─' * $w) + '┘') -ForegroundColor DarkCyan
    $script:Report.Add('')
    $script:Report.Add("== [$Num] $Title ==")
}

function Cut([string]$s, [int]$n) {
    if ($null -eq $s) { return '' }
    if ($s.Length -le $n) { return $s }
    return $s.Substring(0, $n - 1) + '…'
}

function Write-Status {
    param(
        [string]$Label,
        [string]$Value,
        [ValidateSet('OK', 'WARN', 'FAIL', 'INFO')][string]$State = 'INFO'
    )
    $tags   = @{ OK = '[ OK ]'; WARN = '[WARN]'; FAIL = '[FAIL]'; INFO = '[INFO]' }
    $colors = @{ OK = 'Green';  WARN = 'Yellow'; FAIL = 'Red';    INFO = 'DarkCyan' }
    $lbl = Cut $Label 32
    Write-Host '   ' -NoNewline
    Write-Host $tags[$State] -NoNewline -ForegroundColor $colors[$State]
    Write-Host (' {0,-33}' -f $lbl) -NoNewline -ForegroundColor Gray
    Write-Host $Value -ForegroundColor White
    $script:Report.Add(('{0} {1,-33} {2}' -f $tags[$State], $lbl, $Value))
    switch ($State) {
        'OK'   { $script:Ok++ }
        'WARN' { $script:Warnings.Add("$Label : $Value") }
        'FAIL' { $script:Alerts.Add("$Label : $Value") }
    }
}

function Write-Sub {
    param([string]$Text, [ConsoleColor]$Color = 'DarkGray')
    Write-Host ('          > ' + $Text) -ForegroundColor $Color
    $script:Report.Add('          > ' + $Text)
}

function Get-MiniBar([double]$Pct, [int]$Width = 20) {
    if ($Pct -lt 0) { $Pct = 0 }
    if ($Pct -gt 100) { $Pct = 100 }
    $n = [math]::Round($Pct / (100 / $Width))
    return ('█' * $n) + ('░' * ($Width - $n))
}

function Invoke-Spinner {
    param(
        [string]$Label,
        [scriptblock]$ScriptBlock,
        [int]$TimeoutSec = 300,
        [object[]]$ArgumentList
    )
    if ($ArgumentList) { $job = Start-Job -ScriptBlock $ScriptBlock -ArgumentList $ArgumentList }
    else { $job = Start-Job -ScriptBlock $ScriptBlock }
    $frames = @('|', '/', '-', '\')
    $sw = [Diagnostics.Stopwatch]::StartNew()
    $k = 0
    while ($job.State -eq 'Running' -and $sw.Elapsed.TotalSeconds -lt $TimeoutSec) {
        $f = $frames[$k % $frames.Count]; $k++
        $el = $sw.Elapsed
        Write-Host ("`r   [{0}] {1} ... {2:00}:{3:00}   " -f $f, $Label, [math]::Floor($el.TotalMinutes), $el.Seconds) -NoNewline -ForegroundColor DarkCyan
        Start-Sleep -Milliseconds 150
    }
    Write-Host ("`r" + (' ' * ($Label.Length + 30)) + "`r") -NoNewline
    if ($job.State -eq 'Running') {
        Stop-Job $job; Remove-Job $job -Force
        return $null
    }
    $res = Receive-Job $job | Select-Object -Last 1
    Remove-Job $job -Force
    return $res
}

function Invoke-ProcessSpinner {
    # Lance un exécutable attaché à la console (requis par SFC), sortie
    # redirigée vers un fichier, avec indicateur d'attente.
    param(
        [string]$Label,
        [string]$FilePath,
        [string]$Arguments,
        [int]$TimeoutSec = 3600,
        [string]$Encoding = 'Oem'
    )
    $out = Join-Path $env:TEMP ('jarvis_{0}.txt' -f [guid]::NewGuid().ToString('N'))
    $err = $out + '.err'
    $p = Start-Process -FilePath $FilePath -ArgumentList $Arguments -NoNewWindow -PassThru `
         -RedirectStandardOutput $out -RedirectStandardError $err
    if ($null -eq $p) { return $null }
    $null = $p.Handle
    $frames = @('|', '/', '-', '\')
    $sw = [Diagnostics.Stopwatch]::StartNew()
    $k = 0
    while (-not $p.HasExited -and $sw.Elapsed.TotalSeconds -lt $TimeoutSec) {
        $f = $frames[$k % $frames.Count]; $k++
        $el = $sw.Elapsed
        Write-Host ("`r   [{0}] {1} ... {2:00}:{3:00}   " -f $f, $Label, [math]::Floor($el.TotalMinutes), $el.Seconds) -NoNewline -ForegroundColor DarkCyan
        Start-Sleep -Milliseconds 150
    }
    Write-Host ("`r" + (' ' * ($Label.Length + 30)) + "`r") -NoNewline
    if (-not $p.HasExited) {
        try { $p.Kill() } catch {}
        Remove-Item $out, $err -Force
        return $null
    }
    $p.WaitForExit()
    $txt = ''
    if (Test-Path $out) {
        if ($Encoding -eq 'Auto') {
            # UTF-16 si au moins un quart des octets sont nuls, sinon page de code OEM
            $bytes = [IO.File]::ReadAllBytes($out)
            $zeros = @($bytes | Where-Object { $_ -eq 0 }).Count
            if ($bytes.Length -gt 0 -and $zeros -gt ($bytes.Length / 4)) {
                $txt = [Text.Encoding]::Unicode.GetString($bytes)
            } else {
                $oem = [Globalization.CultureInfo]::CurrentCulture.TextInfo.OEMCodePage
                $txt = [Text.Encoding]::GetEncoding($oem).GetString($bytes)
            }
        } else {
            $txt = Get-Content -Path $out -Encoding $Encoding -Raw
        }
    }
    Remove-Item $out, $err -Force
    return [pscustomobject]@{ Code = $p.ExitCode; Text = [string]$txt }
}

# ------------------------------------------------------------------
# Garde-fous
# ------------------------------------------------------------------
function Clear-KeyBuffer {
    # Touches tapées pendant un scan : elles ne doivent jamais répondre à une question
    try { while ([Console]::KeyAvailable) { [void][Console]::ReadKey($true) } } catch {}
}

function Read-Answer([string]$Prompt) {
    # Saisie maison : Échap ou Ctrl+C annulent la question (retour $null) au lieu de couper le programme
    Clear-KeyBuffer
    $interactive = $true
    try { $null = [Console]::KeyAvailable } catch { $interactive = $false }
    if (-not $interactive) { return (Microsoft.PowerShell.Utility\Read-Host -Prompt $Prompt) }
    Write-Host ($Prompt + ' : ') -NoNewline
    $sb = New-Object System.Text.StringBuilder
    while ($true) {
        $k = [Console]::ReadKey($true)
        if ($k.Key -eq [ConsoleKey]::Enter) { Write-Host ''; return $sb.ToString() }
        $ctrlC = ($k.Key -eq [ConsoleKey]::C -and ($k.Modifiers -band [ConsoleModifiers]::Control)) -or ([int]$k.KeyChar -eq 3)
        if ($k.Key -eq [ConsoleKey]::Escape -or $ctrlC) {
            Write-Host ' [annulé]' -ForegroundColor DarkGray
            return $null
        }
        if ($k.Key -eq [ConsoleKey]::Backspace) {
            if ($sb.Length -gt 0) { [void]$sb.Remove($sb.Length - 1, 1); Write-Host "`b `b" -NoNewline }
            continue
        }
        if ([int]$k.KeyChar -ge 32) { [void]$sb.Append($k.KeyChar); Write-Host ([string]$k.KeyChar) -NoNewline }
    }
}

function Test-No($Answer) {
    # Question à réponse par défaut OUI : annulation ou « n » valent NON
    return ($null -eq $Answer -or $Answer -match '^[nN]')
}

function Start-Elevated([string]$File, [string]$Arguments) {
    # Relance avec validation administrateur ; $false si l'utilisateur refuse
    if ($script:JarvisMutex) { try { $script:JarvisMutex.ReleaseMutex() } catch {} }
    try {
        $sp = @{ FilePath = $File; Verb = 'RunAs'; ErrorAction = 'Stop' }
        if ($Arguments) { $sp.ArgumentList = $Arguments }
        Start-Process @sp
        return $true
    } catch {
        Write-Host '   [!] Validation administrateur refusée ou annulée.' -ForegroundColor Yellow
        if ($script:JarvisMutex) { try { $null = $script:JarvisMutex.WaitOne(0) } catch {} }
        return $false
    }
}

function Get-SafeName([string]$Text) {
    # Lettres, espaces, tirets et apostrophes uniquement, 30 caractères maximum
    if ($null -eq $Text) { return $null }
    # Apostrophe typographique ajoutée par son code : PowerShell la traite comme un guillemet
    $pattern = "[^\p{L}\p{M} '\-" + [char]0x2019 + "]"
    $t = ($Text -replace $pattern, '').Trim()
    $t = $t -replace '\s{2,}', ' '
    if ($t.Length -gt 30) { $t = $t.Substring(0, 30).Trim() }
    if ($t.Length -eq 0) { return $null }
    return $t
}

function Test-SafeTempPath([string]$Path) {
    # N'accepte qu'un vrai dossier « Temp », jamais une racine ou un dossier système
    if ([string]::IsNullOrWhiteSpace($Path)) { return $false }
    try { $full = [IO.Path]::GetFullPath($Path).TrimEnd('\') } catch { return $false }
    if ($full -match '^[A-Za-z]:$') { return $false }
    if ((Split-Path -Leaf $full) -ne 'Temp') { return $false }
    $forbidden = @($env:SystemDrive, $env:SystemRoot, $env:USERPROFILE, $env:ProgramFiles, ${env:ProgramFiles(x86)},
                   $env:ProgramData, $env:LOCALAPPDATA, $env:APPDATA, $env:PUBLIC) |
                 Where-Object { $_ } | ForEach-Object { $_.TrimEnd('\') }
    if ($forbidden -contains $full) { return $false }
    $item = Get-Item -LiteralPath $full -Force
    if ($item -and ($item.Attributes -band [IO.FileAttributes]::ReparsePoint)) { return $false }
    return $true
}

function Get-FilesNoJunction([string]$Path, [switch]$WithDirs) {
    # Parcours récursif qui ne suit jamais les jonctions ni les liens symboliques
    if (-not (Test-Path -LiteralPath $Path)) { return }
    $stack = New-Object System.Collections.Stack
    $stack.Push($Path)
    while ($stack.Count -gt 0) {
        $cur = $stack.Pop()
        foreach ($it in @(Get-ChildItem -LiteralPath $cur -Force)) {
            if ($it.Attributes -band [IO.FileAttributes]::ReparsePoint) { continue }
            if ($it.PSIsContainer) {
                $stack.Push($it.FullName)
                if ($WithDirs) { $it }
            } else { $it }
        }
    }
}

function Clear-TempFolder([string]$Path, [int]$MinAgeHours = 24) {
    $res = [pscustomobject]@{ Ok = $false; FreedMB = 0; Reason = '' }
    if (-not (Test-SafeTempPath $Path)) { $res.Reason = 'nettoyage refusé, chemin anormal : ' + $Path; return $res }
    $limit = (Get-Date).AddHours(-$MinAgeHours)
    $freed = 0
    $dirs = @()
    foreach ($it in @(Get-FilesNoJunction $Path -WithDirs)) {
        if ($it.PSIsContainer) { $dirs += $it; continue }
        if ($it.LastWriteTime -ge $limit) { continue }      # fichier récent : peut-être en cours d'utilisation
        $len = $it.Length
        try { [IO.File]::Delete($it.FullName); $freed += $len } catch {}
    }
    # Dossiers anciens devenus vides, du plus profond au moins profond, jamais de suppression récursive
    foreach ($d in ($dirs | Where-Object { $_.CreationTime -lt $limit } | Sort-Object { $_.FullName.Length } -Descending)) {
        try { [IO.Directory]::Delete($d.FullName, $false) } catch {}
    }
    $res.Ok = $true
    $res.FreedMB = [math]::Round($freed / 1MB)
    return $res
}

function Resolve-InstallDir([string]$Dir) {
    $r = [pscustomobject]@{ Ok = $false; Path = $null; Reason = '' }
    $d = ("$Dir").Trim().Trim('"').Trim()
    if ($d -notmatch '^[A-Za-z]:\\') { $r.Reason = 'chemin complet requis, par exemple C:\Program Files\JARVIS'; return $r }
    if ($d.Substring(2) -match '[<>:"|?*]') { $r.Reason = 'caractères interdits dans le chemin'; return $r }
    try { $d = [IO.Path]::GetFullPath($d).TrimEnd('\') } catch { $r.Reason = 'chemin invalide'; return $r }
    if ($d -match '^[A-Za-z]:$' -or (Split-Path -Leaf $d) -ne 'JARVIS') { $d = Join-Path $d 'JARVIS' }
    $drv = $null
    try { $drv = New-Object IO.DriveInfo ($d.Substring(0, 1)) } catch {}
    if (-not $drv -or -not $drv.IsReady -or [string]$drv.DriveType -ne 'Fixed') { $r.Reason = 'disque local requis (pas de clé USB ni de lecteur réseau)'; return $r }
    $blocked = @(
        @{ P = $env:SystemRoot; N = 'dossier Windows' },
        @{ P = $env:ProgramData; N = 'ProgramData' },
        @{ P = [Environment]::GetFolderPath('Desktop'); N = 'Bureau' },
        @{ P = [Environment]::GetFolderPath('MyDocuments'); N = 'Documents' },
        @{ P = (Join-Path $env:USERPROFILE 'Downloads'); N = 'Téléchargements' },
        @{ P = $env:OneDrive; N = 'OneDrive' },
        @{ P = $env:OneDriveConsumer; N = 'OneDrive' },
        @{ P = $env:OneDriveCommercial; N = 'OneDrive' },
        @{ P = $env:TEMP; N = 'dossier temporaire' }
    )
    foreach ($b in $blocked) {
        if (-not $b.P) { continue }
        $bp = ([string]$b.P).TrimEnd('\')
        if ($d -eq $bp -or $d.StartsWith($bp + '\', [StringComparison]::OrdinalIgnoreCase)) {
            $r.Reason = 'emplacement déconseillé (' + $b.N + ')'; return $r
        }
    }
    if (Test-Path -LiteralPath $d) {
        $allowed = @('JARVIS.cmd', '.jarvis-install', 'jarvis-checkup.ps1', 'Rapports', '.jarvis-update.cmd')
        $other = @(Get-ChildItem -LiteralPath $d -Force | Where-Object { $allowed -notcontains $_.Name })
        if ($other.Count -gt 0) { $r.Reason = 'le dossier existe déjà et contient d''autres fichiers'; return $r }
    }
    $r.Ok = $true
    $r.Path = $d
    return $r
}

function Get-WeakWriters([string[]]$Paths) {
    # Comptes non administrateurs ayant le droit de modifier ces chemins
    $weak = @('S-1-5-32-545', 'S-1-5-11', 'S-1-1-0', ([Security.Principal.WindowsIdentity]::GetCurrent().User.Value))
    $writeMask = 0x2 -bor 0x4 -bor 0x10000 -bor 0x40000 -bor 0x80000 -bor 0x10000000 -bor 0x40000000
    $bad = @()
    foreach ($t in $Paths) {
        if (-not (Test-Path -LiteralPath $t)) { continue }
        foreach ($ace in (Get-Acl -LiteralPath $t).Access) {
            if ([string]$ace.AccessControlType -ne 'Allow') { continue }
            $sid = $null
            try { $sid = $ace.IdentityReference.Translate([Security.Principal.SecurityIdentifier]).Value } catch {}
            if ($sid -in $weak -and (([int64]$ace.FileSystemRights) -band $writeMask)) { $bad += $ace.IdentityReference.Value }
        }
    }
    return @($bad | Select-Object -Unique)
}

function Set-NoSleep([bool]$On) {
    # Empêche la mise en veille tant que J.A.R.V.I.S. travaille (l'écran peut s'éteindre)
    try {
        if (-not ('JarvisNative.Power' -as [type])) {
            Add-Type -Namespace JarvisNative -Name Power -MemberDefinition '[System.Runtime.InteropServices.DllImport("kernel32.dll")] public static extern uint SetThreadExecutionState(uint esFlags);'
        }
        $flags = [uint32]2147483648                 # ES_CONTINUOUS
        if ($On) { $flags = [uint32]2147483649 }    # ES_CONTINUOUS | ES_SYSTEM_REQUIRED
        return ([JarvisNative.Power]::SetThreadExecutionState($flags) -ne 0)
    } catch { return $false }
}

function Get-Sha256Hex([byte[]]$Bytes) {
    $sha = [Security.Cryptography.SHA256]::Create()
    return (-join ($sha.ComputeHash($Bytes) | ForEach-Object { $_.ToString('x2') }))
}

function Get-JarvisCmdState([string]$Text) {
    # Contenu d'un JARVIS.cmd : l'empreinte SHA-256 du code correspond-elle à celle de l'en-tête ?
    # 'OK', 'MODIFIED' (modifié ou tronqué) ou 'NOHASH' (pas d'empreinte)
    if ($Text -notmatch 'JARVIS-SHA256=([0-9a-f]{64})') { return 'NOHASH' }
    $expected = $Matches[1]
    $e = $Text.IndexOf([string][char]10 + '#' + '>')
    if ($e -lt 0) { return 'MODIFIED' }
    $h = Get-Sha256Hex ([Text.Encoding]::UTF8.GetBytes($Text.Substring($e + 3)))
    if ($h -eq $expected) { return 'OK' }
    return 'MODIFIED'
}

function Test-JarvisIntegrity {
    # Compare l'empreinte SHA-256 du code avec celle inscrite dans l'en-tête de JARVIS.cmd
    if ($JarvisSelf -notlike '*.cmd') { return 'NOHASH' }
    return (Get-JarvisCmdState ([IO.File]::ReadAllText($JarvisSelf, [Text.Encoding]::UTF8)))
}

function Confirm-DeepScan {
    # Conditions sûres pour SFC / DISM / CHKDSK
    $bat = Get-CimInstance Win32_Battery | Select-Object -First 1
    while ($bat -and $bat.BatteryStatus -in @(1, 4, 5)) {
        Write-Host '   [!] PC sur batterie : une coupure pendant SFC ou DISM peut interrompre une réparation de Windows.' -ForegroundColor Yellow
        $a = Read-Answer '   >> Branche le chargeur puis appuie sur Entrée, ou tape R pour un scan rapide'
        if ($null -eq $a -or $a -match '^[rR]') { return $false }
        $bat = Get-CimInstance Win32_Battery | Select-Object -First 1
    }
    $reasons = @()
    if ((Test-Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending') -or
        (Test-Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired')) {
        $reasons += 'un redémarrage est en attente'
    }
    if (Get-Process TiWorker) { $reasons += 'Windows Update installe des composants en ce moment' }
    if ($reasons.Count -gt 0) {
        Write-Host ('   [!] ' + ($reasons -join ' et ') + '.') -ForegroundColor Yellow
        Write-Host '       SFC et DISM risquent d''échouer ou de donner un résultat faux. Redémarrer d''abord est conseillé.' -ForegroundColor Yellow
        $a = Read-Answer '   >> Continuer quand même le scan complet ? [o/N]'
        if ($a -notmatch '^[oOyY]') { return $false }
    }
    Write-Host ''
    Write-Host ('  ╔' + ('═' * 64) + '╗') -ForegroundColor Yellow
    foreach ($l in @('  NE FERME PAS CETTE FENÊTRE pendant DISM, SFC et CHKDSK',
                     '  Durée : 20 à 60 minutes selon le PC',
                     '  Mise en veille bloquée pendant ces étapes')) {
        Write-Host '  ║' -NoNewline -ForegroundColor Yellow
        Write-Host ($l.PadRight(64)) -NoNewline -ForegroundColor White
        Write-Host '║' -ForegroundColor Yellow
    }
    Write-Host ('  ╚' + ('═' * 64) + '╝') -ForegroundColor Yellow
    $a = Read-Answer '   >> Lancer le scan complet ? [O/n]'
    if (Test-No $a) { return $false }
    return $true
}

# ------------------------------------------------------------------
# Préférences mémorisées (%APPDATA%\JARVIS\config.json)
# ------------------------------------------------------------------
function Get-JarvisConfig {
    $h = @{}
    if (Test-Path -LiteralPath $CfgFile) {
        try {
            $o = Get-Content -LiteralPath $CfgFile -Raw -Encoding UTF8 | ConvertFrom-Json
            foreach ($pr in $o.PSObject.Properties) { $h[$pr.Name] = $pr.Value }
        } catch {}
    }
    return $h
}

function Set-JarvisConfigValue([string]$Key, $Value) {
    # Modifie une seule clé en conservant les autres ; $null supprime la clé
    try {
        $h = Get-JarvisConfig
        if ($null -eq $Value) { $h.Remove($Key) } else { $h[$Key] = $Value }
        if (-not (Test-Path -LiteralPath $CfgDir)) { New-Item -ItemType Directory -Path $CfgDir -Force -ErrorAction Stop | Out-Null }
        ([pscustomobject]$h) | ConvertTo-Json | Set-Content -LiteralPath $CfgFile -Encoding UTF8 -ErrorAction Stop
        return $true
    } catch { return $false }
}

# ------------------------------------------------------------------
# Module winget (facultatif)
# ------------------------------------------------------------------
function Test-WingetModule { return [bool](Get-Module -ListAvailable -Name Microsoft.WinGet.Client) }

function Test-ShowWingetOffer {
    if (-not $isAdmin) { return $false }
    if (Test-WingetModule) { return $false }
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) { return $false }
    $c = Get-JarvisConfig
    return ([string]$c['WingetModule'] -ne 'never')
}

function Install-WingetModule {
    $res = Invoke-Spinner 'Installation du module winget (1 à 3 min)' {
        try {
            # Le dépôt PowerShell Gallery exige TLS 1.2 (absent par défaut sur d'anciens Windows 10)
            [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
            $prov = Get-PackageProvider -ListAvailable -Name NuGet -ErrorAction SilentlyContinue |
                    Where-Object { $_.Version -ge [version]'2.8.5.201' }
            if (-not $prov) { Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -Scope AllUsers -ErrorAction Stop | Out-Null }
            # -Force : installe depuis PSGallery sans modifier durablement la confiance accordée au dépôt
            Install-Module -Name Microsoft.WinGet.Client -Repository PSGallery -Scope AllUsers -Force -ErrorAction Stop
            Import-Module Microsoft.WinGet.Client -ErrorAction Stop
            $null = Get-Command Get-WinGetPackage -ErrorAction Stop
            [pscustomobject]@{ Ok = $true; Version = [string](Get-Module Microsoft.WinGet.Client).Version; Error = $null }
        } catch {
            [pscustomobject]@{ Ok = $false; Version = $null; Error = $_.Exception.Message }
        }
    } 300
    if ($null -eq $res) {
        Write-Host '   [!] Installation trop longue, interrompue. JARVIS continue en lecture texte de winget.' -ForegroundColor Yellow
        return $false
    }
    if ($res.Ok) {
        Write-Host ("   >> Module installé (v{0}). Les prochains scans afficheront les versions détaillées." -f $res.Version) -ForegroundColor Green
        return $true
    }
    Write-Host ('   [!] Installation impossible : ' + (Cut $res.Error 90)) -ForegroundColor Yellow
    Write-Host '       Rien n''est cassé : JARVIS continue en lecture texte de winget.' -ForegroundColor Yellow
    if ($res.Error -match 'proxy|réseau|network|connect|résoudre|resolve|TLS|SSL') {
        Write-Host '       Cause probable : connexion Internet ou proxy.' -ForegroundColor DarkGray
    }
    return $false
}

function Invoke-WingetModuleOffer {
    Write-Host ''
    Write-Host '   MODULE WINGET (facultatif)' -ForegroundColor Cyan
    Write-Host '   Module officiel Microsoft : noms et versions complets (winget coupe parfois les colonnes),' -ForegroundColor Gray
    Write-Host '   et noms des applications dont winget ne connaît pas la version.' -ForegroundColor Gray
    Write-Host '   Sans lui, JARVIS fonctionne normalement.' -ForegroundColor Gray
    Write-Host '   [O] Installer maintenant (Internet requis)' -ForegroundColor Gray
    Write-Host '   [N] Non, pas maintenant' -ForegroundColor Gray
    Write-Host '   [J] Non, et ne plus jamais me le proposer' -ForegroundColor Gray
    $a = Read-Answer '   >> Choix [O/N/J]'
    if ($a -match '^[jJ]') {
        if (Set-JarvisConfigValue 'WingetModule' 'never') {
            Write-Host '   >> Compris, cette proposition ne réapparaîtra plus.' -ForegroundColor DarkGray
            Write-Host '      Pour changer d''avis : JARVIS.cmd -ResetChoices' -ForegroundColor DarkGray
        } else {
            Write-Host '   [!] Choix non enregistré (profil inaccessible en écriture).' -ForegroundColor Yellow
        }
    } elseif ($a -match '^[oOyY]') {
        $null = Install-WingetModule
    } else {
        Write-Host '   >> Pas de souci, l''option reste disponible dans le menu.' -ForegroundColor DarkGray
    }
    Write-Host ''
}

# ------------------------------------------------------------------
# Windows Update : installation par J.A.R.V.I.S. (API officielle Windows Update Agent)
# ------------------------------------------------------------------
function Test-SkipWuUpdate {
    # Raison d'exclure une mise à jour, ou $null si elle peut être installée sans surveillance
    param($Update)
    foreach ($c in @($Update.Categories)) {
        if ([string]$c.CategoryID -eq '3689bdc8-b205-4af4-8d4b-a63924c5e9d5') { return 'mise à niveau de version de Windows' }
    }
    if ([string]$Update.Title -match 'Feature update|Mise à jour de fonctionnalit') { return 'mise à niveau de version de Windows' }
    if ($Update.BrowseOnly) { return 'facultative' }
    if ($Update.InstallationBehavior.CanRequestUserInput) { return 'demande une intervention à l''écran' }
    return $null
}

function Wait-ACPower([string]$Reason) {
    $bat = Get-CimInstance Win32_Battery | Select-Object -First 1
    while ($bat -and $bat.BatteryStatus -in @(1, 4, 5)) {
        Write-Host ('   [!] PC sur batterie : ' + $Reason) -ForegroundColor Yellow
        $a = Read-Answer '   >> Branche le chargeur puis appuie sur Entrée (Échap pour annuler)'
        if ($null -eq $a) { return $false }
        $bat = Get-CimInstance Win32_Battery | Select-Object -First 1
    }
    return $true
}

function Install-WindowsUpdates {
    if (-not (Wait-ACPower 'une coupure pendant l''installation des mises à jour peut endommager Windows.')) {
        Write-Host '   >> Installation annulée.' -ForegroundColor DarkGray
        return
    }
    Write-Host ''
    Write-Host '   NE FERME PAS CETTE FENÊTRE pendant l''installation (5 à 60 min selon les mises à jour).' -ForegroundColor Yellow
    Write-Host '   Les mises à niveau de version de Windows (ex. 24H2 vers 25H2) ne sont pas installées ici.' -ForegroundColor DarkGray
    Write-Host ''
    $filter = ${function:Test-SkipWuUpdate}.ToString()

    # Étape 1 : recherche + téléchargement
    $dl = Invoke-Spinner 'Téléchargement des mises à jour' {
        param($FilterText)
        try {
            $skipFn = [scriptblock]::Create($FilterText)
            $s = New-Object -ComObject Microsoft.Update.Session
            $s.ClientApplicationID = 'JARVIS'
            $r = $s.CreateUpdateSearcher().Search('IsInstalled=0 and IsHidden=0')
            $coll = New-Object -ComObject Microsoft.Update.UpdateColl
            $skipped = @()
            foreach ($u in $r.Updates) {
                $why = & $skipFn $u
                if ($why) { $skipped += ('{0} : {1}' -f $why, [string]$u.Title); continue }
                if (-not $u.EulaAccepted) { $u.AcceptEula() }
                [void]$coll.Add($u)
            }
            $code = 2
            if ($coll.Count -gt 0) {
                $d = $s.CreateUpdateDownloader()
                $d.Updates = $coll
                $code = [int]$d.Download().ResultCode
            }
            [pscustomobject]@{ Ok = $true; Count = $coll.Count; Skipped = $skipped; Code = $code; Error = $null }
        } catch {
            [pscustomobject]@{ Ok = $false; Count = 0; Skipped = @(); Code = 0; Error = $_.Exception.Message }
        }
    } 3600 -ArgumentList $filter

    if ($null -eq $dl) { Write-Status 'Téléchargement' 'délai dépassé (60 min)' 'WARN'; return }
    if (-not $dl.Ok) { Write-Status 'Téléchargement' ('échec : ' + (Cut $dl.Error 60)) 'WARN'; Open-WindowsUpdateGuided; return }
    foreach ($sk in @($dl.Skipped)) { Write-Sub ('Exclue, ' + (Cut $sk 90)) 'DarkGray' }
    if ($dl.Count -eq 0) {
        Write-Host '   >> Aucune mise à jour installable automatiquement : celles qui restent sont facultatives' -ForegroundColor Yellow
        Write-Host '      ou demandent une action à l''écran.' -ForegroundColor Yellow
        $a = Read-Answer '   >> Ouvrir Windows Update pour les traiter toi-même ? [o/N]'
        if ($a -match '^[oOyY]') { Open-WindowsUpdateGuided }
        return
    }
    Write-Status 'Téléchargement' ("{0} mise(s) à jour prête(s)" -f $dl.Count) 'OK'

    # Étape 2 : installation de ce qui est téléchargé
    $ins = Invoke-Spinner 'Installation des mises à jour' {
        param($FilterText)
        try {
            $skipFn = [scriptblock]::Create($FilterText)
            $s = New-Object -ComObject Microsoft.Update.Session
            $s.ClientApplicationID = 'JARVIS'
            $r = $s.CreateUpdateSearcher().Search('IsInstalled=0 and IsHidden=0')
            $coll = New-Object -ComObject Microsoft.Update.UpdateColl
            foreach ($u in $r.Updates) { if (-not (& $skipFn $u) -and $u.IsDownloaded) { [void]$coll.Add($u) } }
            if ($coll.Count -eq 0) { return [pscustomobject]@{ Ok = $true; Results = @(); Reboot = $false; Error = $null } }
            $i = $s.CreateUpdateInstaller()
            if ($i.IsBusy) { throw 'Windows Update installe déjà autre chose : réessaie plus tard' }
            $i.Updates = $coll
            $ir = $i.Install()
            $res = @()
            for ($k = 0; $k -lt $coll.Count; $k++) {
                $res += [pscustomobject]@{ Title = [string]$coll.Item($k).Title; Code = [int]$ir.GetUpdateResult($k).ResultCode }
            }
            [pscustomobject]@{ Ok = $true; Results = $res; Reboot = [bool]$ir.RebootRequired; Error = $null }
        } catch {
            [pscustomobject]@{ Ok = $false; Results = @(); Reboot = $false; Error = $_.Exception.Message }
        }
    } 3600 -ArgumentList $filter

    if ($null -eq $ins) { Write-Status 'Installation' 'délai dépassé (60 min)' 'WARN'; return }
    if (-not $ins.Ok) { Write-Status 'Installation' ('échec : ' + (Cut $ins.Error 60)) 'WARN'; Open-WindowsUpdateGuided; return }
    $okN = 0; $failN = 0
    foreach ($x in @($ins.Results)) {
        if ($x.Code -in @(2, 3)) { $okN++; Write-Sub ('Installée : ' + (Cut $x.Title 80)) 'Green' }
        else { $failN++; Write-Sub ('Échec    : ' + (Cut $x.Title 80)) 'Red' }
    }
    if ($failN -eq 0) { Write-Status 'Installation' ("{0} mise(s) à jour installée(s)" -f $okN) 'OK' }
    else {
        Write-Status 'Installation' ("{0} réussie(s), {1} échec(s)" -f $okN, $failN) 'WARN'
        Write-Sub 'Les échecs se règlent souvent après un redémarrage puis un nouveau passage dans Windows Update'
    }
    if ($ins.Reboot) {
        Write-Host ''
        Write-Host '   [!] Un redémarrage est nécessaire pour terminer l''installation.' -ForegroundColor Yellow
        $a = Read-Answer '   >> Redémarrer dans 1 minute ? (enregistre ton travail) [o/N]'
        if ($a -match '^[oOyY]') {
            & (Join-Path $env:windir 'System32\shutdown.exe') /r /t 60 /c 'J.A.R.V.I.S. : redémarrage pour terminer les mises à jour Windows.'
            Write-Host '   >> Redémarrage dans 60 s. Pour l''annuler : Windows + R, puis « shutdown /a ».' -ForegroundColor Cyan
        } else {
            Write-Host '   >> Pense à redémarrer aujourd''hui : les mises à jour ne sont actives qu''après.' -ForegroundColor DarkGray
        }
    }
}

function Open-WindowsUpdateGuided {
    # Lance la recherche en arrière-plan (sans effet si indisponible), puis ouvre la page avec un mode d'emploi.
    # ms-settings:windowsupdate-action n'est pas utilisé : sans effet sur Windows 11, et il peut redémarrer
    # immédiatement le PC si un redémarrage est en attente.
    $uso = Join-Path $env:windir 'System32\UsoClient.exe'
    if (Test-Path -LiteralPath $uso) { Start-Process -FilePath $uso -ArgumentList 'StartInteractiveScan' -WindowStyle Hidden }
    Start-Process 'ms-settings:windowsupdate'
    Write-Host ''
    Write-Host '   DANS LA FENÊTRE WINDOWS UPDATE QUI VIENT DE S''OUVRIR :' -ForegroundColor Cyan
    Write-Host '   1. Clique sur « Rechercher des mises à jour » (bouton en haut à droite).' -ForegroundColor Gray
    Write-Host '      Si la recherche est déjà en cours, attends simplement.' -ForegroundColor DarkGray
    Write-Host '   2. Clique ensuite sur « Télécharger et installer tout » s''il apparaît.' -ForegroundColor Gray
    Write-Host '   3. Attends la fin, puis clique sur « Redémarrer maintenant » si Windows le demande.' -ForegroundColor Gray
    Write-Host ''
}

function Get-ReportDir {
    # Premier emplacement réellement inscriptible : profil local, puis dossier
    # temporaire. Évite Documents (souvent dans OneDrive ou protégé par
    # l'Accès contrôlé aux dossiers) et le dossier du programme (lecture seule).
    $candidates = @()
    $candidates += $ReportRoot
    $candidates += (Join-Path $env:TEMP 'JARVIS')
    foreach ($d in $candidates) {
        try {
            if (-not (Test-Path $d)) { New-Item -ItemType Directory -Path $d -Force -ErrorAction Stop | Out-Null }
            $f = Join-Path $d '.jarvis_write_test'
            Set-Content -Path $f -Value 'ok' -ErrorAction Stop
            $back = Get-Content -Path $f -Raw -ErrorAction Stop
            Remove-Item $f -Force -ErrorAction Stop
            if ($back -match 'ok') { return $d }
        } catch {}
    }
    return $null
}

function Save-Report([string]$Prefix, [string[]]$Lines) {
    $dir = Get-ReportDir
    if (-not $dir) {
        Write-Host '   [!] Rapport non enregistré : aucun dossier accessible en écriture.' -ForegroundColor Yellow
        return $null
    }
    try {
        $file = Join-Path $dir ('{0}_{1}.txt' -f $Prefix, (Get-Date -Format 'yyyyMMdd_HHmm'))
        $Lines | Set-Content -Path $file -Encoding UTF8 -ErrorAction Stop
        if (-not (Test-Path $file)) { throw 'fichier absent après écriture' }
        # Rotation : 30 rapports conservés par type
        Get-ChildItem -LiteralPath $dir -File -Filter ($Prefix + '_*.txt') | Sort-Object LastWriteTime -Descending |
            Select-Object -Skip 30 | Remove-Item -Force
        Write-Host ("   >> Rapport enregistré : {0}" -f $file) -ForegroundColor DarkGray
        return $file
    } catch {
        Write-Host ("   [!] Rapport non enregistré : {0}" -f $_.Exception.Message) -ForegroundColor Yellow
        return $null
    }
}

# ------------------------------------------------------------------
# Installation / désinstallation
# ------------------------------------------------------------------
function New-JarvisShortcut([string]$Path, [string]$Target, [string]$WorkDir) {
    $ws = New-Object -ComObject WScript.Shell
    $sc = $ws.CreateShortcut($Path)
    $sc.TargetPath = $Target
    $sc.WorkingDirectory = $WorkDir
    $sc.IconLocation = (Join-Path $env:windir 'System32\shell32.dll') + ',15'
    $sc.Description = 'J.A.R.V.I.S. // Check-up système'
    $sc.Save()
    if (-not (Test-Path -LiteralPath $Path)) { throw 'raccourci non créé' }
    # Drapeau « Exécuter en tant qu'administrateur » : octet 0x15, bit 0x20
    $bytes = [IO.File]::ReadAllBytes($Path)
    $bytes[0x15] = $bytes[0x15] -bor 0x20
    [IO.File]::WriteAllBytes($Path, $bytes)
}

function Invoke-LegacyCleanup([string]$NewCmd) {
    # Anciennes installations (avant v3.1) : rapports déplacés, fichiers JARVIS supprimés
    $newDir = Split-Path -Parent $NewCmd
    foreach ($old in $LegacyDirs) {
        if (-not (Test-Path -LiteralPath $old)) { continue }
        if ((Resolve-Path -LiteralPath $old).Path -eq (Resolve-Path -LiteralPath $newDir).Path) { continue }
        $files = @('JARVIS.cmd', 'jarvis-checkup.ps1', '.jarvis-install') | Where-Object { Test-Path -LiteralPath (Join-Path $old $_) }
        if ($files.Count -eq 0) { continue }
        $a = Read-Answer ("   >> Ancienne installation trouvée dans {0}. La nettoyer (rapports conservés) ? [O/n]" -f $old)
        if (Test-No $a) { continue }
        $oldRep = Join-Path $old 'Rapports'
        if (Test-Path -LiteralPath $oldRep) {
            New-Item -ItemType Directory -Path $ReportRoot -Force | Out-Null
            Get-ChildItem -LiteralPath $oldRep -File | Where-Object { $_.Name -match '^(checkup|selftest)_\d{8}_\d{4}\.txt$' } |
                Move-Item -Destination $ReportRoot -Force
            if (-not (Get-ChildItem -LiteralPath $oldRep -Force)) { Remove-Item -LiteralPath $oldRep -Force }
        }
        $running = $null
        if ($JarvisSelf) { try { $running = (Resolve-Path -LiteralPath $JarvisSelf).Path } catch {} }
        $delayed = @()
        foreach ($f in $files) {
            $fp = (Resolve-Path -LiteralPath (Join-Path $old $f)).Path
            if ($fp -eq $running) { $delayed += $fp } else { Remove-Item -LiteralPath $fp -Force }
        }
        if ($delayed.Count -gt 0) {
            # Fichier en cours d'exécution : suppression 3 s après la fermeture
            $cmdLine = '/c timeout /t 3 /nobreak >nul & del /f /q "{0}" & rmdir "{1}"' -f $delayed[0], $old
            Start-Process -FilePath 'cmd.exe' -ArgumentList $cmdLine -WindowStyle Hidden
        } elseif (-not (Get-ChildItem -LiteralPath $old -Force)) {
            Remove-Item -LiteralPath $old -Force
        }
        Show-Bar ('Nettoyage ' + (Cut $old 20))
    }
}

function Get-InstalledJarvis {
    # Installation existante : registre Windows d'abord, dossier par défaut ensuite
    $k = Get-ItemProperty -LiteralPath $RegKey
    if ($k -and $k.InstallLocation -and (Test-Path -LiteralPath (Join-Path $k.InstallLocation 'JARVIS.cmd'))) {
        return [pscustomobject]@{ Dir = [string]$k.InstallLocation; Version = [string]$k.DisplayVersion; Cmd = (Join-Path $k.InstallLocation 'JARVIS.cmd') }
    }
    $m = Join-Path $DefaultInstallDir '.jarvis-install'
    if ((Test-Path -LiteralPath $m) -and (Test-Path -LiteralPath (Join-Path $DefaultInstallDir 'JARVIS.cmd'))) {
        $v = (Get-Content -LiteralPath $m | Where-Object { $_ -like 'version=*' }) -replace '^version=', ''
        return [pscustomobject]@{ Dir = $DefaultInstallDir; Version = [string]$v; Cmd = (Join-Path $DefaultInstallDir 'JARVIS.cmd') }
    }
    return $null
}

function Compare-JarvisVersion([string]$A, [string]$B) {
    try { return ([version]$A).CompareTo([version]$B) } catch { return 0 }
}

function Register-Jarvis([string]$Dir, [string]$Cmd, [string]$Version = $JarvisVersion) {
    # Inscription dans « Applications installées » de Windows (désinstallation possible depuis Paramètres)
    New-Item -Path $RegKey -Force -ErrorAction Stop | Out-Null
    $str = [ordered]@{
        DisplayName     = 'J.A.R.V.I.S. (check-up système)'
        DisplayVersion  = $Version
        Publisher       = 'J.A.R.V.I.S.'
        InstallLocation = $Dir
        DisplayIcon     = (Join-Path $env:windir 'System32\shell32.dll') + ',15'
        UninstallString = ('"{0}" /c ""{1}" -Uninstall"' -f (Join-Path $env:windir 'System32\cmd.exe'), $Cmd)
        InstallDate     = (Get-Date -Format 'yyyyMMdd')
    }
    foreach ($n in $str.Keys) { New-ItemProperty -LiteralPath $RegKey -Name $n -Value $str[$n] -PropertyType String -Force -ErrorAction Stop | Out-Null }
    $kb = [int]([math]::Ceiling((Get-Item -LiteralPath $Cmd).Length / 1KB))
    foreach ($d in @(@('NoModify', 1), @('NoRepair', 1), @('EstimatedSize', $kb))) {
        New-ItemProperty -LiteralPath $RegKey -Name $d[0] -Value $d[1] -PropertyType DWord -Force -ErrorAction Stop | Out-Null
    }
}

function Install-Jarvis {
    # Par défaut installe cette copie ; la mise à jour en ligne passe le fichier téléchargé
    # (-Source), sa version (-Version) et -Quiet (aucune question, raccourcis existants conservés)
    param([string]$TargetDir, [string]$Source = $JarvisSelf, [string]$Version = $JarvisVersion, [switch]$Quiet)
    if ($Source -notlike '*.cmd') {
        Write-Host '   [!] Installation possible uniquement depuis JARVIS.cmd.' -ForegroundColor Yellow
        return $null
    }
    $dir = $null
    if ($TargetDir) {
        $rv = Resolve-InstallDir $TargetDir
        if ($rv.Ok) { $dir = $rv.Path } else { Write-Host ("   [!] Dossier refusé : {0}" -f $rv.Reason) -ForegroundColor Yellow }
    }
    if (-not $dir -and $InstallDir) {
        $rv = Resolve-InstallDir $InstallDir
        if ($rv.Ok) { $dir = $rv.Path } else { Write-Host ("   [!] Dossier refusé : {0}" -f $rv.Reason) -ForegroundColor Yellow }
    }
    while (-not $dir) {
        Write-Host ("   Dossier d'installation proposé : {0}" -f $DefaultInstallDir) -ForegroundColor Gray
        $ans = Read-Answer '   >> Entrée pour accepter, ou tape un autre chemin (Échap pour annuler)'
        if ($null -eq $ans) { Write-Host '   >> Installation annulée.' -ForegroundColor DarkGray; return $null }
        if ([string]::IsNullOrWhiteSpace($ans)) { $ans = $DefaultInstallDir }
        $rv = Resolve-InstallDir $ans
        if ($rv.Ok) { $dir = $rv.Path } else { Write-Host ("   [!] Dossier refusé : {0}" -f $rv.Reason) -ForegroundColor Yellow }
    }
    $marker = Join-Path $dir '.jarvis-install'
    if (Test-Path -LiteralPath $marker) {
        $old = (Get-Content -LiteralPath $marker | Where-Object { $_ -like 'version=*' }) -replace '^version=', ''
        Write-Host ("   >> Version {0} trouvée : mise à jour vers {1}." -f $old, $Version) -ForegroundColor Cyan
    }
    $dest = Join-Path $dir 'JARVIS.cmd'
    try {
        New-Item -ItemType Directory -Path $dir -Force -ErrorAction Stop | Out-Null
        Show-Bar 'Dossier d''installation'
        $same = $false
        try { $same = ((Resolve-Path -LiteralPath $Source).Path -eq (Join-Path (Resolve-Path -LiteralPath $dir).Path 'JARVIS.cmd')) } catch {}
        if (-not $same) {
            # Copie dans un fichier temporaire, vérification, puis remplacement : jamais de fichier à moitié écrit.
            # Remplacer le JARVIS.cmd en cours d'exécution est sans risque : l'en-tête batch, que cmd.exe relit
            # après la fin de PowerShell, a toujours la même longueur (seule l'empreinte change).
            $tmp = $dest + '.new'
            Copy-Item -LiteralPath $Source -Destination $tmp -Force -ErrorAction Stop
            $h1 = (Get-FileHash -LiteralPath $Source -Algorithm SHA256).Hash
            $h2 = (Get-FileHash -LiteralPath $tmp -Algorithm SHA256).Hash
            if ($h1 -ne $h2) { Remove-Item -LiteralPath $tmp -Force; throw 'copie corrompue' }
            Move-Item -LiteralPath $tmp -Destination $dest -Force -ErrorAction Stop
        }
        Unblock-File -LiteralPath $dest
        Set-Content -LiteralPath $marker -Value @("version=$Version", ("date={0}" -f (Get-Date -Format 'yyyy-MM-dd HH:mm'))) -ErrorAction Stop
        if (-not (Test-Path -LiteralPath $dest)) { throw 'copie absente après installation' }
        Show-Bar 'Copie de J.A.R.V.I.S.'
        Register-Jarvis $dir $dest $Version
        Show-Bar 'Inscription dans Windows'
        $weakW = @(Get-WeakWriters @($dir, $dest))
        if ($weakW.Count -gt 0) {
            Write-Host ("   [!] Ce dossier est modifiable sans droits admin ({0})." -f ($weakW -join ', ')) -ForegroundColor Yellow
            Write-Host ("       Un programme malveillant pourrait modifier JARVIS. Emplacement conseillé : {0}" -f $DefaultInstallDir) -ForegroundColor Yellow
        }
    } catch {
        Write-Host ("   [!] Installation impossible : {0}" -f $_.Exception.Message) -ForegroundColor Red
        return $null
    }
    try {
        New-JarvisShortcut $StartLnk $dest $dir
        Show-Bar 'Raccourci menu Démarrer'
    } catch {
        Write-Host ("   [!] Raccourci menu Démarrer non créé : {0}" -f $_.Exception.Message) -ForegroundColor Yellow
    }
    $wantDesk = $false
    if ($Quiet) { $wantDesk = (Test-Path -LiteralPath $DeskLnk) }
    else { $wantDesk = -not (Test-No (Read-Answer '   >> Ajouter aussi un raccourci sur le Bureau ? [O/n]')) }
    if ($wantDesk) {
        try {
            New-JarvisShortcut $DeskLnk $dest $dir
            Show-Bar 'Raccourci Bureau'
        } catch {
            Write-Host '   [!] Raccourci Bureau refusé (Accès contrôlé aux dossiers ?). Le menu Démarrer suffit.' -ForegroundColor Yellow
        }
    }
    if (-not $Quiet) {
        Invoke-LegacyCleanup $dest
        Write-Host ''
        Type-Line ("   >> Installation terminée : {0}" -f $dir) 'Green'
        Type-Line '   >> Pour le relancer : menu Démarrer, tape « JARVIS ».' 'Cyan'
    }
    return $dest
}

function Uninstall-Jarvis {
    if (-not $JarvisInstalled) {
        # Copie non installée : on délègue à la copie installée si elle existe
        $inst = Get-InstalledJarvis
        if ($inst) {
            if (Start-Elevated $inst.Cmd '-Uninstall') { exit }
            return
        }
    }
    if ($JarvisInstalled -and -not $isAdmin) {
        Write-Host '   >> Validation administrateur requise pour désinstaller.' -ForegroundColor Cyan
        if (Start-Elevated $JarvisSelf '-Uninstall') { exit }
        return
    }
    if (-not $JarvisInstalled) {
        Write-Host '   [!] Ce JARVIS n''est pas une copie installée : rien à désinstaller ici.' -ForegroundColor Yellow
        return
    }
    if ($JarvisHome -match '^[A-Za-z]:\\?$') {
        Write-Host '   [!] Dossier d''installation invalide, désinstallation annulée.' -ForegroundColor Red
        return
    }
    Write-Host '   Éléments qui seront supprimés :' -ForegroundColor Cyan
    Write-Host ("     - {0}\JARVIS.cmd" -f $JarvisHome) -ForegroundColor Gray
    Write-Host '     - raccourcis JARVIS du menu Démarrer et du Bureau' -ForegroundColor Gray
    Write-Host '     - profil et choix mémorisés (%APPDATA%\JARVIS), rapports (%LOCALAPPDATA%\JARVIS)' -ForegroundColor Gray
    if (Test-WingetModule) { Write-Host '     (le module winget de Microsoft est conservé : d''autres outils peuvent s''en servir)' -ForegroundColor DarkGray }
    Write-Host '   Pour annuler : appuie sur Entrée ou Échap.' -ForegroundColor DarkGray
    $a = Read-Answer '   >> Pour confirmer, tape DESINSTALLER'
    if (("$a").Trim().ToUpper() -ne 'DESINSTALLER') { Write-Host '   >> Désinstallation annulée.' -ForegroundColor DarkGray; return }

    foreach ($l in @($StartLnk, $DeskLnk)) { if (Test-Path -LiteralPath $l) { Remove-Item -LiteralPath $l -Force } }
    foreach ($d in @((Join-Path $env:APPDATA 'JARVIS'), (Join-Path $env:LOCALAPPDATA 'JARVIS'))) {
        if (Test-Path -LiteralPath $d) { Remove-Item -LiteralPath $d -Recurse -Force }
    }
    # Uniquement les fichiers créés par JARVIS : un dossier partagé avec d'autres fichiers est conservé
    $rep = Join-Path $JarvisHome 'Rapports'
    Get-ChildItem -LiteralPath $rep -File | Where-Object { $_.Name -match '^(checkup|selftest)_\d{8}_\d{4}\.txt$' } | Remove-Item -Force
    if (Test-Path -LiteralPath $rep) { if (-not (Get-ChildItem -LiteralPath $rep -Force)) { Remove-Item -LiteralPath $rep -Force } }
    Remove-Item -LiteralPath (Join-Path $JarvisHome '.jarvis-install') -Force
    if (Test-Path -LiteralPath $RegKey) { Remove-Item -LiteralPath $RegKey -Recurse -Force }
    # JARVIS.cmd est en cours d'exécution : suppression différée de 3 s, puis du dossier s'il est vide
    $cmdLine = '/c timeout /t 3 /nobreak >nul & del /f /q "{0}" & rmdir "{1}"' -f (Join-Path $JarvisHome 'JARVIS.cmd'), $JarvisHome
    Start-Process -FilePath 'cmd.exe' -ArgumentList $cmdLine -WindowStyle Hidden
    Write-Host ''
    Type-Line '   >> J.A.R.V.I.S. a été désinstallé. Fin de transmission.' 'Cyan'
    Start-Sleep -Seconds 2
    exit
}

# ------------------------------------------------------------------
# Mise à jour en ligne (versions publiées sur GitHub)
# ------------------------------------------------------------------
function Get-JarvisReleaseInfo([string]$Json, [string]$Repo) {
    # Lecture de la réponse de l'API GitHub (releases/latest) : version, adresse et empreinte de JARVIS.cmd
    $r = [pscustomobject]@{ Ok = $false; Version = $null; Url = $null; Sha256 = $null; Size = [int64]0; Notes = ''; Reason = '' }
    $o = $null
    try { $o = $Json | ConvertFrom-Json -ErrorAction Stop } catch {}
    if ($null -eq $o -or $o -is [string]) { $r.Reason = 'réponse de GitHub illisible'; return $r }
    if ($o.draft -or $o.prerelease) { $r.Reason = 'version de test, ignorée'; return $r }
    $tag = [string]$o.tag_name
    if ($tag -notmatch '^[vV]?(\d{1,4}\.\d{1,4}(\.\d{1,4})?)$') { $r.Reason = 'numéro de version publié invalide : ' + (Cut $tag 20); return $r }
    $r.Version = $Matches[1]
    $asset = @($o.assets) | Where-Object { $_ -and [string]$_.name -eq 'JARVIS.cmd' } | Select-Object -First 1
    if (-not $asset) { $r.Reason = 'fichier JARVIS.cmd absent de la version publiée'; return $r }
    $url = [string]$asset.browser_download_url
    $prefix = 'https://github.com/' + $Repo + '/releases/download/'
    if (-not $url.StartsWith($prefix, [StringComparison]::OrdinalIgnoreCase) -or $url -match '\s|\.\.') {
        $r.Reason = 'adresse de téléchargement inattendue'; return $r
    }
    $d = [string]$asset.digest
    if ($d) {
        if ($d -notmatch '^sha256:([0-9a-fA-F]{64})$') { $r.Reason = 'empreinte publiée illisible'; return $r }
        $r.Sha256 = $Matches[1].ToLower()
    }
    $r.Size = [int64]$asset.size
    $r.Notes = [string]$o.body
    $r.Url = $url
    $r.Ok = $true
    return $r
}

function Test-JarvisPackage([byte[]]$Bytes, $Info, [string]$CurrentVersion) {
    # Contrôle d'un JARVIS.cmd téléchargé avant installation : $null si tout est bon, sinon la raison du refus
    if ($null -eq $Bytes -or $Bytes.Length -lt 1000) { return 'fichier vide ou incomplet' }
    if ($Bytes.Length -gt 5MB) { return 'fichier anormalement gros' }
    if ($Info.Size -gt 0 -and $Bytes.Length -ne $Info.Size) { return 'taille différente de celle annoncée par GitHub' }
    if ($Info.Sha256 -and (Get-Sha256Hex $Bytes) -ne $Info.Sha256) { return 'empreinte différente de celle publiée sur GitHub' }
    $t = [Text.Encoding]::UTF8.GetString($Bytes)
    if (-not $t.StartsWith('<# : JARVIS.cmd')) { return 'ce n''est pas un fichier JARVIS' }
    if ((Get-JarvisCmdState $t) -ne 'OK') { return 'fichier modifié ou incomplet (empreinte interne fausse)' }
    if ($t -notmatch '\$JarvisVersion = ''([0-9.]+)''') { return 'version introuvable dans le fichier' }
    $v = $Matches[1]
    if ($v -ne $Info.Version) { return ('version du fichier (v{0}) différente de la version publiée (v{1})' -f $v, $Info.Version) }
    if ((Compare-JarvisVersion $v $CurrentVersion) -le 0) { return ('v{0} n''est pas plus récente que v{1}' -f $v, $CurrentVersion) }
    return $null
}

function Get-ReleaseNotesLines([string]$Body, [int]$Max = 6) {
    # Nouveautés affichables : caractères de contrôle retirés (aucune séquence d'échappement console), lignes coupées
    $out = @()
    foreach ($l in ("$Body" -split "`n")) {
        $t = ($l -replace '[\x00-\x1F\x7F-\x9F]', '').Trim()
        $t = ($t -replace '^[#*>\-\s]+', '').Trim()
        if (-not $t) { continue }
        $out += (Cut $t 88)
        if ($out.Count -ge $Max) { break }
    }
    return $out
}

function Get-JarvisHttpClient {
    if ($script:JarvisHttp) { return $script:JarvisHttp }
    Add-Type -AssemblyName System.Net.Http -ErrorAction Stop
    # TLS 1.2 exigé par GitHub : ajouté seulement si Windows n'a pas déjà la main sur le choix du protocole
    $sp = [Net.ServicePointManager]::SecurityProtocol
    if ([int]$sp -ne 0 -and -not ($sp -band [Net.SecurityProtocolType]::Tls12)) {
        [Net.ServicePointManager]::SecurityProtocol = $sp -bor [Net.SecurityProtocolType]::Tls12
    }
    $c = New-Object System.Net.Http.HttpClient
    $c.Timeout = [TimeSpan]::FromSeconds(90)
    $c.DefaultRequestHeaders.UserAgent.ParseAdd('JARVIS-checkup/' + $JarvisVersion)
    $script:JarvisHttp = $c
    return $c
}

function Start-JarvisUpdateCheck {
    # Lance la question à GitHub en arrière-plan : le résultat est lu plus tard, au menu
    $s = [pscustomobject]@{ Task = $null; Clock = [Diagnostics.Stopwatch]::StartNew() }
    try { $s.Task = (Get-JarvisHttpClient).GetAsync('https://api.github.com/repos/' + $JarvisRepo + '/releases/latest') } catch {}
    return $s
}

function Get-JarvisUpdateResult($Check, [int]$MaxMs) {
    # Status : NEW (plus récente), UPTODATE, NONE (rien de publié), OFFLINE, ERROR
    $r = [pscustomobject]@{ Status = 'ERROR'; Info = $null; Detail = '' }
    if ($null -eq $Check -or $null -eq $Check.Task) { $r.Detail = 'vérification impossible sur ce PC'; return $r }
    $left = $MaxMs - [int]$Check.Clock.ElapsedMilliseconds
    if ($left -lt 0) { $left = 0 }
    $done = $false
    try { $done = $Check.Task.Wait($left) } catch { $done = $true }
    if (-not $done) { $r.Status = 'OFFLINE'; $r.Detail = 'pas de réponse de GitHub'; return $r }
    if ([string]$Check.Task.Status -ne 'RanToCompletion') { $r.Status = 'OFFLINE'; $r.Detail = 'GitHub injoignable (connexion Internet ?)'; return $r }
    $resp = $Check.Task.Result
    $code = [int]$resp.StatusCode
    if ($code -eq 404) { $r.Status = 'NONE'; $r.Detail = 'aucune version publiée'; return $r }
    if ($code -ne 200) { $r.Detail = 'réponse de GitHub : code ' + $code; return $r }
    $json = $null
    try { $json = $resp.Content.ReadAsStringAsync().Result } catch {}
    $info = Get-JarvisReleaseInfo $json $JarvisRepo
    if (-not $info.Ok) { $r.Detail = $info.Reason; return $r }
    $r.Info = $info
    if ((Compare-JarvisVersion $info.Version $JarvisVersion) -gt 0) { $r.Status = 'NEW' } else { $r.Status = 'UPTODATE' }
    return $r
}

function Get-JarvisDownload([string]$Url, [int]$TimeoutSec = 90) {
    # Téléchargement en mémoire avec indicateur d'attente ; $null en cas d'échec
    $task = $null
    try { $task = (Get-JarvisHttpClient).GetByteArrayAsync($Url) } catch { return $null }
    $frames = @('|', '/', '-', '\')
    $sw = [Diagnostics.Stopwatch]::StartNew()
    $k = 0
    $label = 'Téléchargement de la nouvelle version'
    while (-not $task.IsCompleted -and $sw.Elapsed.TotalSeconds -lt $TimeoutSec) {
        Write-Host ("`r   [{0}] {1} ... {2:00}s   " -f $frames[$k % 4], $label, [math]::Floor($sw.Elapsed.TotalSeconds)) -NoNewline -ForegroundColor DarkCyan
        $k++
        Start-Sleep -Milliseconds 150
    }
    Write-Host ("`r" + (' ' * ($label.Length + 30)) + "`r") -NoNewline
    if ([string]$task.Status -ne 'RanToCompletion') { return $null }
    return ,$task.Result
}

function Invoke-JarvisSelfUpdate($Info) {
    Write-Host ''
    Write-Host '   MISE À JOUR DE J.A.R.V.I.S.' -ForegroundColor Cyan
    Write-Host ("   Version installée : v{0}   //   version disponible : v{1}" -f $JarvisVersion, $Info.Version) -ForegroundColor Gray
    $notes = @(Get-ReleaseNotesLines $Info.Notes 6)
    if ($notes.Count -gt 0) {
        Write-Host '   Nouveautés :' -ForegroundColor Gray
        foreach ($n in $notes) { Write-Host ('     - ' + $n) -ForegroundColor DarkGray }
    }
    if (-not $JarvisInstalled) {
        Write-Host '   [!] Cette copie n''est pas installée : télécharge la nouvelle version ici :' -ForegroundColor Yellow
        Write-Host ('       ' + $JarvisReleasePage) -ForegroundColor Yellow
        return
    }
    if (-not $isAdmin) {
        Write-Host '   >> Validation administrateur requise pour remplacer le programme installé.' -ForegroundColor Cyan
        if (Start-Elevated $JarvisSelf '-Update') { exit }
        return
    }
    $a = Read-Answer ("   >> Installer la v{0} maintenant ? [O/n]" -f $Info.Version)
    if (Test-No $a) { Write-Host '   >> Mise à jour reportée. Elle reste proposée au menu.' -ForegroundColor DarkGray; return }

    $bytes = Get-JarvisDownload $Info.Url
    if ($null -eq $bytes) {
        Write-Host '   [!] Téléchargement impossible (connexion coupée ou trop lente). Rien n''a été modifié.' -ForegroundColor Yellow
        return
    }
    $why = Test-JarvisPackage $bytes $Info $JarvisVersion
    if ($why) {
        Write-Host ('   [!] Mise à jour refusée : ' + $why + '.') -ForegroundColor Red
        Write-Host ('       Rien n''a été modifié. Si cela se reproduit, préviens la personne qui t''a donné JARVIS.') -ForegroundColor Yellow
        return
    }
    $hash = Get-Sha256Hex $bytes
    $src = 'empreinte interne'
    if ($Info.Sha256) { $src = 'empreinte publiée sur GitHub et empreinte interne' }
    Write-Host ('   [ OK ] Fichier contrôlé : ' + $src + ' conformes.') -ForegroundColor Green

    # Fichier posé dans le dossier d'installation (modifiable par les seuls administrateurs), revérifié, puis installé
    $stage = Join-Path $JarvisHome '.jarvis-update.cmd'
    $dest = $null
    try {
        [IO.File]::WriteAllBytes($stage, $bytes)
        if ((Get-FileHash -LiteralPath $stage -Algorithm SHA256).Hash.ToLower() -ne $hash) { throw 'fichier altéré après écriture' }
        $dest = Install-Jarvis -TargetDir $JarvisHome -Source $stage -Version $Info.Version -Quiet
    } catch {
        Write-Host ('   [!] Mise à jour impossible : ' + $_.Exception.Message) -ForegroundColor Red
    } finally {
        if (Test-Path -LiteralPath $stage) { Remove-Item -LiteralPath $stage -Force }
    }
    if (-not $dest) {
        Write-Host ("   >> La v{0} reste en place, elle fonctionne normalement." -f $JarvisVersion) -ForegroundColor Yellow
        return
    }
    # Vérification finale : le fichier installé est bien celui qui a été contrôlé
    $okFile = ((Get-FileHash -LiteralPath $dest -Algorithm SHA256).Hash.ToLower() -eq $hash)
    $okReg = ([string](Get-ItemProperty -LiteralPath $RegKey).DisplayVersion -eq $Info.Version)
    if (-not ($okFile -and $okReg)) {
        Write-Host '   [!] Installation incomplète : relance la mise à jour depuis le menu [U].' -ForegroundColor Red
        return
    }
    Write-Host ''
    Type-Line ("   >> Mise à jour terminée : v{0} installée et vérifiée." -f $Info.Version) 'Green'
    $a = Read-Answer '   >> Entrée pour lancer la nouvelle version (Échap pour fermer)'
    if ($null -ne $a) { $null = Start-Elevated $dest '' }
    exit
}

# ------------------------------------------------------------------
# Analyseurs de résultats (testés par l'auto-test)
# ------------------------------------------------------------------
function Get-SfcVerdict([string]$Text) {
    $t = ($Text -replace "`0", '') -replace '\s+', ' '
    if ($t -match 'did not find any integrity violations|aucune violation') { return 'CLEAN' }
    if ($t -match 'could not perform|pas pu effectuer') { return 'NORUN' }
    if ($t -match 'unable to fix|pas pu en r') { return 'UNFIXED' }
    if ($t -match 'successfully repaired|les a r.par') { return 'REPAIRED' }
    return 'UNKNOWN'
}

function Get-DismVerdict([string]$Text, $Code) {
    if ($Text -match 'No component store corruption|Aucune alt') { return 'CLEAN' }
    if ($Text -match 'cannot be repaired|ne peut pas .tre r') { return 'UNREPAIRABLE' }
    if ($Text -match 'repairable|r.parable|peut .tre r.par') { return 'REPAIRABLE' }
    if ($null -ne $Code -and [int]$Code -ne 0) { return 'ERROR' }
    return 'CLEAN'
}

function Get-ChkdskVerdict($Code) {
    switch ([int]$Code) {
        0 { return 'CLEAN' }
        1 { return 'FIXED' }
        2 { return 'MINOR' }
        default { return 'ERRORS' }
    }
}

function ConvertFrom-WingetText {
    param([string]$Raw)
    # Fin de ligne Windows retirée d'abord, puis seul le texte après le dernier retour chariot est gardé
    # (animation de progression). Sans le TrimEnd, chaque ligne CRLF devenait vide : liste toujours vide.
    $lines = $Raw -split "`n" | ForEach-Object { ($_.TrimEnd("`r") -split "`r")[-1].TrimEnd() }
    $start = -1
    for ($i = 0; $i -lt $lines.Count; $i++) { if ($lines[$i] -match '^\s*-{10,}\s*$') { $start = $i; break } }
    if ($start -lt 1) { return }
    # Colonnes repérées sur la ligne d'en-tête (Nom/Name, ID, Version, Disponible/Available, Source)
    $header = $lines[$start - 1]
    $cols = @(0)
    for ($c = 1; $c -lt $header.Length; $c++) { if ($header[$c] -ne ' ' -and $header[$c - 1] -eq ' ') { $cols += $c } }
    for ($j = $start + 1; $j -lt $lines.Count; $j++) {
        $l = $lines[$j]
        if ([string]::IsNullOrWhiteSpace($l) -or $l -match '^\d+\s') { break }
        $o = [pscustomobject]@{ Name = $l.Trim(); Id = ''; Installed = ''; Available = '' }
        if ($cols.Count -ge 4 -and $l.Length -gt $cols[3]) {
            $cut = { param($a, $b) if ($a -ge $l.Length) { '' } elseif ($b -gt $l.Length -or $b -lt 0) { $l.Substring($a).Trim() } else { $l.Substring($a, $b - $a).Trim() } }
            $endAvail = -1
            if ($cols.Count -ge 5) { $endAvail = $cols[4] }
            $o.Name      = & $cut 0 $cols[1]
            $o.Id        = & $cut $cols[1] $cols[2]
            $o.Installed = & $cut $cols[2] $cols[3]
            $o.Available = & $cut $cols[3] $endAvail
        }
        $o
    }
}

function Get-WingetUnknownCount {
    # Applications dont winget ne connaît pas la version installée (exclues de « winget upgrade »,
    # qui refuse de les mettre à jour sans --include-unknown) : nombre lu dans la dernière ligne
    param([string]$Raw)
    if ($Raw -match '(?m)^\s*(\d+)\s+package\(s\)[^\r\n]*--include-unknown') { return [int]$Matches[1] }
    return 0
}

function Test-WingetNoUpgrade([string]$Raw) {
    # Message explicite de winget : aucune mise à jour (français ou anglais), ou seulement des
    # applications de version inconnue (winget n'affiche alors ni tableau ni « aucune mise à niveau »)
    if ($Raw -match 'Aucune mise . niveau disponible|No available upgrade found|Aucun package install. ne correspond|No installed package found') { return $true }
    return ($Raw -notmatch '(?m)^\s*-{10,}\s*$' -and (Get-WingetUnknownCount $Raw) -gt 0)
}

function Get-AvState($ProductState) {
    $hex = '{0:X6}' -f [int]$ProductState
    return [pscustomobject]@{
        On       = ($hex.Substring(2, 2) -in @('10', '11'))
        UpToDate = ($hex.Substring(4, 2) -eq '00')
    }
}

function Convert-NvidiaVersion([string]$Version) {
    if ($Version -notmatch '^\d+\.\d+\.(\d+)\.(\d+)$') { return $null }
    $digits = $Matches[1] + $Matches[2].PadLeft(4, '0')
    if ($digits.Length -lt 5) { return $null }
    $digits = $digits.Substring($digits.Length - 5)
    return ('{0}.{1}' -f $digits.Substring(0, 3), $digits.Substring(3, 2))
}

function Compare-DriverVersion([string]$A, [string]$B) {
    try { return ([version]$A).CompareTo([version]$B) } catch { return $null }
}

function Get-FirstNameFromFull([string]$Full) {
    if ([string]::IsNullOrWhiteSpace($Full)) { return $null }
    $first = ($Full.Trim() -split '\s+')[0]
    return (Get-Culture).TextInfo.ToTitleCase($first.ToLower())
}

function Get-SfcPath {
    # sfc.exe est un binaire 64 bits : passage par Sysnative si la console est en 32 bits
    $p = Join-Path $env:windir 'System32\sfc.exe'
    if (-not [Environment]::Is64BitProcess -and (Test-Path (Join-Path $env:windir 'Sysnative\sfc.exe'))) {
        $p = Join-Path $env:windir 'Sysnative\sfc.exe'
    }
    return $p
}

# ------------------------------------------------------------------
# Auto-test
# ------------------------------------------------------------------
function Invoke-SelfTest {
    $results = New-Object System.Collections.Generic.List[object]
    $log = New-Object System.Collections.Generic.List[string]

    function Add-Result([string]$Name, [string]$State, [string]$Detail, [double]$Ms) {
        $results.Add([pscustomobject]@{ Name = $Name; State = $State; Detail = $Detail })
        $col = @{ PASS = 'Green'; FAIL = 'Red'; SKIP = 'DarkGray' }[$State]
        Write-Host '   ' -NoNewline
        Write-Host ('[{0}]' -f $State) -NoNewline -ForegroundColor $col
        Write-Host (' {0,-42}' -f (Cut $Name 42)) -NoNewline -ForegroundColor Gray
        Write-Host ('{0,7:N0} ms  ' -f $Ms) -NoNewline -ForegroundColor DarkGray
        Write-Host $Detail -ForegroundColor White
        $log.Add(('[{0}] {1,-42} {2,7:N0} ms  {3}' -f $State, $Name, $Ms, $Detail))
    }
    function Assert-True([bool]$Cond, [string]$Msg) { if (-not $Cond) { throw $Msg } }
    function Test-Case([string]$Name, [scriptblock]$Body, [switch]$NeedAdmin) {
        if ($NeedAdmin -and -not $isAdmin) { Add-Result $Name 'SKIP' 'droits admin requis' 0; return }
        $sw = [Diagnostics.Stopwatch]::StartNew()
        try {
            $r = & $Body | Select-Object -Last 1
            $sw.Stop()
            if ($r -is [string] -and $r.StartsWith('SKIP:')) { Add-Result $Name 'SKIP' $r.Substring(5) $sw.Elapsed.TotalMilliseconds }
            else { Add-Result $Name 'PASS' ([string]$r) $sw.Elapsed.TotalMilliseconds }
        } catch {
            $sw.Stop()
            Add-Result $Name 'FAIL' (Cut $_.Exception.Message 80) $sw.Elapsed.TotalMilliseconds
        }
    }

    Write-Host ''
    Type-Line '   >> Protocole d''auto-diagnostic engagé.' 'Cyan'

    # ---------------- T1 : analyseurs (cas connus, aucune dépendance au PC)
    Write-Section 'T1' 'Analyseurs de résultats (cas de référence)'

    $sfcCases = @(
        @('Windows Resource Protection did not find any integrity violations.', 'CLEAN'),
        @("La protection des ressources Windows n'a trouvé aucune violation d'intégrité.", 'CLEAN'),
        @('Windows Resource Protection found corrupt files and successfully repaired them.', 'REPAIRED'),
        @('La protection des ressources Windows a trouvé des fichiers endommagés et les a réparés.', 'REPAIRED'),
        @('Windows Resource Protection found corrupt files but was unable to fix some of them.', 'UNFIXED'),
        @("La protection des ressources Windows a trouvé des fichiers endommagés, mais n'a pas pu en réparer certains.", 'UNFIXED'),
        @('Windows Resource Protection could not perform the requested operation.', 'NORUN'),
        @("La protection des ressources Windows n'a pas pu effectuer l'opération demandée.", 'NORUN'),
        @('texte inattendu', 'UNKNOWN')
    )
    Test-Case 'SFC : messages EN/FR' {
        foreach ($c in $sfcCases) {
            $got = Get-SfcVerdict $c[0]
            Assert-True ($got -eq $c[1]) ("« {0} » -> {1}, attendu {2}" -f (Cut $c[0] 30), $got, $c[1])
        }
        '{0}/{0} cas' -f $sfcCases.Count
    }
    Test-Case 'SFC : sortie UTF-16 brute' {
        $raw = (('did not find any integrity violations').ToCharArray() | ForEach-Object { [string]$_ + [char]0 }) -join ''
        $got = Get-SfcVerdict $raw
        Assert-True ($got -eq 'CLEAN') "obtenu $got"
        'octets nuls ignorés'
    }

    $dismCases = @(
        @('No component store corruption detected.', 0, 'CLEAN'),
        @("Aucune altération du magasin des composants n'a été détectée.", 0, 'CLEAN'),
        @('The component store is repairable.', 0, 'REPAIRABLE'),
        @('Le magasin des composants est réparable.', 0, 'REPAIRABLE'),
        @('The component store cannot be repaired.', 0, 'UNREPAIRABLE'),
        @('Error: 87 The parameter is incorrect.', 87, 'ERROR'),
        @('The operation completed successfully.', 0, 'CLEAN')
    )
    Test-Case 'DISM : messages et codes' {
        foreach ($c in $dismCases) {
            $got = Get-DismVerdict $c[0] $c[1]
            Assert-True ($got -eq $c[2]) ("« {0} » -> {1}, attendu {2}" -f (Cut $c[0] 30), $got, $c[2])
        }
        '{0}/{0} cas' -f $dismCases.Count
    }

    Test-Case 'CHKDSK : codes de sortie 0-3' {
        $exp = @{ 0 = 'CLEAN'; 1 = 'FIXED'; 2 = 'MINOR'; 3 = 'ERRORS' }
        foreach ($k in $exp.Keys) {
            $got = Get-ChkdskVerdict $k
            Assert-True ($got -eq $exp[$k]) "code $k -> $got, attendu $($exp[$k])"
        }
        '4/4 cas'
    }

    Test-Case 'winget : tableau FR + bruit de progression' {
        $fmt = '{0,-16}{1,-22}{2,-19}{3,-19}{4}'
        $raw = "   - `r   \ `r" + ($fmt -f 'Nom', 'ID', 'Version', 'Disponible', 'Source') + "`n" +
               ('-' * 82) + "`n" +
               ($fmt -f 'Hytale Launcher', 'HypixelStudios.Hytale', '2026.05.14-26cebac', '2026.11.16-1726018', 'winget') + "`n" +
               ($fmt -f '7-Zip', '7zip.7zip', '23.01', '24.08', 'winget') + "`n" +
               "2 mises à niveau disponibles.`n"
        $r = @(ConvertFrom-WingetText $raw)
        Assert-True ($r.Count -eq 2) ("{0} paquet(s), attendu 2" -f $r.Count)
        Assert-True ($r[0].Id -eq 'HypixelStudios.Hytale') ('identifiant lu : ' + $r[0].Id)
        Assert-True ($r[0].Installed -eq '2026.05.14-26cebac' -and $r[0].Available -eq '2026.11.16-1726018') 'versions mal lues'
        Assert-True ($r[1].Name -eq '7-Zip' -and $r[1].Id -eq '7zip.7zip') 'deuxième ligne mal lue'
        '2 paquets, identifiants et versions lus'
    }
    Test-Case 'winget : sortie réelle avec fins de ligne Windows' {
        # Sortie capturée le 19/11/2026 (winget 1.29, français) : lignes terminées par CRLF
        $fmt = '{0,-16}{1,-22}{2,-19}{3,-19}{4}'
        $raw = "   - `r   \ `r`r`n" + ($fmt -f 'Nom', 'ID', 'Version', 'Disponible', 'Source') + "`r`n" + ('-' * 82) + "`r`n" +
               ($fmt -f 'Hytale Launcher', 'HypixelStudios.Hytale', '2026.05.14-26cebac', '2026.11.16-1726018', 'winget') + "`r`n" +
               "1 mises à niveau disponibles.`r`n" +
               "1 package(s) a(ont) des numéros de version qui ne peuvent pas être déterminés. Utilisez --include-unknown pour afficher tous les résultats.`r`n"
        $r = @(ConvertFrom-WingetText $raw)
        Assert-True ($r.Count -eq 1) ("{0} paquet(s), attendu 1" -f $r.Count)
        Assert-True ($r[0].Id -eq 'HypixelStudios.Hytale' -and $r[0].Available -eq '2026.11.16-1726018') ('ligne mal lue : ' + $r[0].Id)
        Assert-True ((Get-WingetUnknownCount $raw) -eq 1) 'version inconnue non comptée'
        Assert-True (-not (Test-WingetNoUpgrade $raw)) 'conclu « à jour » alors qu''une mise à jour existe'
        '1 paquet + 1 version inconnue'
    }
    Test-Case 'winget : détection « aucune mise à jour »' {
        Assert-True (Test-WingetNoUpgrade 'Aucune mise à niveau disponible.') 'message FR non reconnu'
        Assert-True (Test-WingetNoUpgrade 'No available upgrade found.') 'message EN non reconnu'
        Assert-True (-not (Test-WingetNoUpgrade 'texte illisible')) 'faux positif'
        # Seule une application de version inconnue reste (cas Epson Scan 2 en v3.10) : rien à mettre à jour
        $unkFr = '1 package(s) a(ont) des numéros de version qui ne peuvent pas être déterminés. Utilisez --include-unknown pour afficher tous les résultats.'
        Assert-True (Test-WingetNoUpgrade $unkFr) 'version inconnue seule non reconnue (FR)'
        $withTable = "Nom ID Version Disponible Source`n" + ('-' * 40) + "`nGit Git.Git 2.40 2.47 winget`n" + $unkFr
        Assert-True (-not (Test-WingetNoUpgrade $withTable)) 'tableau présent mais conclu « à jour »'
        '5/5 cas'
    }
    Test-Case 'winget : applications de version inconnue' {
        $en = '2 package(s) have version numbers that cannot be determined. Use --include-unknown to see all results.'
        $fr = "1 mises à niveau disponibles.`r`n1 package(s) a(ont) des numéros de version qui ne peuvent pas être déterminés. Utilisez --include-unknown pour afficher tous les résultats.`r`n"
        Assert-True ((Get-WingetUnknownCount $en) -eq 2) 'message EN mal lu'
        Assert-True ((Get-WingetUnknownCount $fr) -eq 1) 'message FR mal lu'
        Assert-True ((Get-WingetUnknownCount 'Aucune mise à niveau disponible.') -eq 0) 'faux positif'
        '3/3 cas'
    }
    Test-Case 'winget : aucune mise à jour' {
        $n = @(ConvertFrom-WingetText "Aucune mise à niveau disponible.`n").Count
        Assert-True ($n -eq 0) "$n paquet(s), attendu 0"
        '0 paquet'
    }
    Test-Case 'winget : second tableau ignoré (EN)' {
        $raw = "Name Id Version Available Source`n----------------------------------`n" +
               "Git  Git.Git 2.40 2.47 winget`n1 upgrades available.`n`n" +
               "The following packages have an upgrade available, but require explicit targeting:`n" +
               "Name Id Version`n----------------------------------`nFoo Foo.Foo 1 2 winget`n"
        $n = @(ConvertFrom-WingetText $raw).Count
        Assert-True ($n -eq 1) "$n paquet(s), attendu 1"
        '1 paquet lu'
    }

    Test-Case 'Antivirus : décodage productState' {
        $a = Get-AvState 266240; Assert-True ($a.On -and $a.UpToDate) '266240 : attendu actif + à jour'
        $b = Get-AvState 262144; Assert-True (-not $b.On) '262144 : attendu inactif'
        $c = Get-AvState 397584; Assert-True ($c.On -and -not $c.UpToDate) '397584 : attendu actif + obsolète'
        '3/3 cas'
    }
    Test-Case 'NVIDIA : conversion de version' {
        $cases = @{ '32.0.15.6094' = '560.94'; '31.0.15.5222' = '552.22'; '27.21.14.5671' = '456.71' }
        foreach ($k in $cases.Keys) {
            $got = Convert-NvidiaVersion $k
            Assert-True ($got -eq $cases[$k]) "$k -> $got, attendu $($cases[$k])"
        }
        Assert-True ($null -eq (Convert-NvidiaVersion 'abc')) 'entrée invalide non rejetée'
        '4/4 cas'
    }
    Test-Case 'Comparaison de versions pilotes' {
        Assert-True ((Compare-DriverVersion '24.10.0.4' '24.10.0.4') -eq 0) 'égalité'
        Assert-True ((Compare-DriverVersion '24.80.0.2' '24.10.0.4') -gt 0) 'supérieure'
        Assert-True ((Compare-DriverVersion '23.60.1.2' '24.10.0.4') -lt 0) 'inférieure'
        Assert-True ($null -eq (Compare-DriverVersion 'n/a' '1.0')) 'entrée invalide'
        '4/4 cas'
    }
    Test-Case 'Prénom : extraction' {
        Assert-True ((Get-FirstNameFromFull 'jean DUPONT') -eq 'Jean') 'jean DUPONT'
        Assert-True ((Get-FirstNameFromFull 'JEAN-PIERRE Martin') -eq 'Jean-Pierre') 'JEAN-PIERRE Martin'
        Assert-True ($null -eq (Get-FirstNameFromFull '  ')) 'vide'
        '3/3 cas'
    }
    Test-Case 'Mise à jour : lecture de la version publiée' {
        $base = 'https://github.com/' + $JarvisRepo + '/releases/download/v9.1/JARVIS.cmd'
        $mk = {
            param($Tag, $Name, $Url, $Digest)
            $a = @{ name = $Name; browser_download_url = $Url; size = 1234 }
            if ($Digest) { $a.digest = $Digest }
            (@{ tag_name = $Tag; draft = $false; prerelease = $false; body = 'notes'; assets = @($a) } | ConvertTo-Json -Depth 4)
        }
        $ok = Get-JarvisReleaseInfo (& $mk 'v9.1' 'JARVIS.cmd' $base ('sha256:' + ('AB' * 32))) $JarvisRepo
        Assert-True ($ok.Ok -and $ok.Version -eq '9.1' -and $ok.Sha256 -eq ('ab' * 32) -and $ok.Size -eq 1234) ('version valide refusée : ' + $ok.Reason)
        Assert-True ((Get-JarvisReleaseInfo (& $mk '9.1' 'JARVIS.cmd' $base $null) $JarvisRepo).Ok) 'numéro sans « v » ou sans empreinte refusé'
        Assert-True (-not (Get-JarvisReleaseInfo (& $mk 'latest' 'JARVIS.cmd' $base $null) $JarvisRepo).Ok) 'numéro invalide accepté'
        Assert-True (-not (Get-JarvisReleaseInfo (& $mk 'v9.1' 'autre.exe' $base $null) $JarvisRepo).Ok) 'fichier absent accepté'
        Assert-True (-not (Get-JarvisReleaseInfo (& $mk 'v9.1' 'JARVIS.cmd' 'https://exemple.com/JARVIS.cmd' $null) $JarvisRepo).Ok) 'adresse étrangère acceptée'
        Assert-True (-not (Get-JarvisReleaseInfo (& $mk 'v9.1' 'JARVIS.cmd' $base 'md5:1234') $JarvisRepo).Ok) 'empreinte illisible acceptée'
        Assert-True (-not (Get-JarvisReleaseInfo 'pas du JSON' $JarvisRepo).Ok) 'réponse illisible acceptée'
        '7/7 cas'
    }
    Test-Case 'Mise à jour : contrôle du fichier téléchargé' {
        # Faux JARVIS.cmd fabriqué comme build.py : en-tête avec empreinte du code qui suit la ligne de fermeture
        $mkPkg = {
            param($Ver, [switch]$Tamper)
            $body = "`r`n" + '$JarvisVersion = ''' + $Ver + "'`r`n" + ('# remplissage' * 120) + "`r`n"
            $h = Get-Sha256Hex ([Text.Encoding]::UTF8.GetBytes($body))
            $txt = '<# : JARVIS.cmd test' + "`r`nrem JARVIS-SHA256=" + $h + "`r`n" + '#' + '>' + $body
            if ($Tamper) { $txt = $txt.Replace('remplissage', 'remplissagE') }
            ,([Text.Encoding]::UTF8.GetBytes($txt))
        }
        $b = & $mkPkg '9.1'
        $info = [pscustomobject]@{ Version = '9.1'; Size = [int64]$b.Length; Sha256 = (Get-Sha256Hex $b) }
        $why = Test-JarvisPackage $b $info '3.11'
        Assert-True ($null -eq $why) ('fichier valide refusé : ' + $why)
        Assert-True ((Get-JarvisCmdState ([Text.Encoding]::UTF8.GetString($b))) -eq 'OK') 'empreinte interne mal calculée'
        $t = & $mkPkg '9.1' -Tamper
        $infoT = [pscustomobject]@{ Version = '9.1'; Size = [int64]$t.Length; Sha256 = $null }
        Assert-True ($null -ne (Test-JarvisPackage $t $infoT '3.11')) 'fichier modifié accepté'
        $infoBad = [pscustomobject]@{ Version = '9.1'; Size = [int64]$b.Length; Sha256 = ('0' * 64) }
        Assert-True ($null -ne (Test-JarvisPackage $b $infoBad '3.11')) 'empreinte publiée différente acceptée'
        $infoV = [pscustomobject]@{ Version = '9.2'; Size = [int64]$b.Length; Sha256 = $null }
        Assert-True ($null -ne (Test-JarvisPackage $b $infoV '3.11')) 'version différente de la version publiée acceptée'
        Assert-True ($null -ne (Test-JarvisPackage $b $info '9.1')) 'version identique acceptée'
        Assert-True ($null -ne (Test-JarvisPackage $b $info '10.0')) 'rétrogradation acceptée'
        $short = [byte[]]$b[0..($b.Length - 50)]
        Assert-True ($null -ne (Test-JarvisPackage $short ([pscustomobject]@{ Version = '9.1'; Size = 0; Sha256 = $null }) '3.11')) 'fichier tronqué accepté'
        '8/8 cas'
    }
    Test-Case 'Mise à jour : nouveautés affichées sans danger' {
        $esc = [string][char]27
        $l = @(Get-ReleaseNotesLines ("## Nouveautés`r`n- winget corrigé " + $esc + "[31mrouge`r`n`r`n* " + ('x' * 200) + "`n1`n2`n3`n4`n5") 6)
        Assert-True ($l.Count -eq 6) ("{0} lignes, attendu 6" -f $l.Count)
        Assert-True ($l[0] -eq 'Nouveautés') ('titre mal nettoyé : ' + $l[0])
        Assert-True (-not ($l -join '').Contains($esc)) 'séquence d''échappement console conservée'
        Assert-True ($l[2].Length -le 88) 'ligne trop longue non coupée'
        '4/4 cas'
    }
    Test-Case 'Mode ASCII : conversion des glyphes' {
        $got = Convert-Glyph '█░┌─┐…'
        Assert-True ($got -eq '#.+-+...') "obtenu $got"
        'OK'
    }

    # ---------------- T2 : moteurs d'exécution
    Write-Section 'T2' 'Moteurs d''exécution'

    Test-Case 'Job en arrière-plan (aller-retour)' {
        $r = Invoke-Spinner 'job de test' { [pscustomobject]@{ V = 42 } } 60
        Assert-True ($null -ne $r -and $r.V -eq 42) 'résultat absent ou invalide'
        'valeur reçue'
    }
    Test-Case 'Processus console + capture' {
        $r = Invoke-ProcessSpinner -Label 'cmd de test' -FilePath (Join-Path $env:windir 'System32\cmd.exe') `
             -Arguments '/c echo JARVIS_OK' -TimeoutSec 30 -Encoding 'Oem'
        Assert-True ($null -ne $r) 'pas de retour'
        Assert-True ($r.Code -eq 0) "code $($r.Code)"
        Assert-True ($r.Text -match 'JARVIS_OK') 'sortie non capturée'
        'code 0, sortie lue'
    }
    Test-Case 'Délai dépassé : arrêt du processus' {
        $r = Invoke-ProcessSpinner -Label 'arrêt forcé' -FilePath (Join-Path $env:windir 'System32\PING.EXE') `
             -Arguments '-n 30 127.0.0.1' -TimeoutSec 2 -Encoding 'Oem'
        Assert-True ($null -eq $r) 'le délai n''a pas interrompu le processus'
        Start-Sleep -Milliseconds 300
        'interrompu à 2 s'
    }
    Test-Case 'SFC : lancement et décodage de la sortie' {
        $sfcExe = Get-SfcPath
        Assert-True (Test-Path $sfcExe) "introuvable : $sfcExe"
        $r = Invoke-ProcessSpinner -Label 'sfc /?' -FilePath $sfcExe -Arguments '/?' -TimeoutSec 60 -Encoding 'Auto'
        Assert-True ($null -ne $r) 'pas de retour'
        $t = $r.Text -replace "`0", ''
        Assert-True ($t -match 'SCANNOW') 'aide illisible : décodage de la sortie incorrect'
        'aide lue correctement'
    } -NeedAdmin
    Test-Case 'DISM : /CheckHealth (rapide)' {
        $r = Invoke-ProcessSpinner -Label 'DISM /CheckHealth' -FilePath (Join-Path $env:windir 'System32\dism.exe') `
             -Arguments '/Online /Cleanup-Image /CheckHealth' -TimeoutSec 300 -Encoding 'Oem'
        Assert-True ($null -ne $r) 'délai dépassé'
        Assert-True ($r.Code -eq 0) "code de sortie $($r.Code)"
        'verdict : ' + (Get-DismVerdict $r.Text $r.Code)
    } -NeedAdmin
    Test-Case 'CHKDSK : lancement' {
        $r = Invoke-ProcessSpinner -Label 'chkdsk /?' -FilePath (Join-Path $env:windir 'System32\chkdsk.exe') `
             -Arguments '/?' -TimeoutSec 60 -Encoding 'Oem'
        Assert-True ($null -ne $r) 'pas de retour'
        Assert-True ($r.Text -match '/scan') 'option /scan absente de l''aide'
        'option /scan disponible'
    }

    # ---------------- T3 : sources de données du PC
    Write-Section 'T3' 'Sources de données'

    Test-Case 'PowerShell 5.1 ou plus' {
        Assert-True ($PSVersionTable.PSVersion -ge [version]'5.1') "version $($PSVersionTable.PSVersion)"
        'v' + $PSVersionTable.PSVersion
    }
    Test-Case 'CIM / WMI' {
        $o = Get-CimInstance Win32_OperatingSystem -ErrorAction Stop
        Assert-True ([bool]$o.Caption) 'réponse vide'
        $o.Caption
    }
    Test-Case 'Registre Windows' {
        $cv2 = Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' -ErrorAction Stop
        Assert-True ([bool]$cv2.CurrentBuild) 'build illisible'
        'build ' + $cv2.CurrentBuild
    }
    Test-Case 'Windows Update (COM)' {
        $null = New-Object -ComObject Microsoft.Update.Session -ErrorAction Stop
        $null = New-Object -ComObject Microsoft.Update.AutoUpdate -ErrorAction Stop
        'agents accessibles'
    }
    Test-Case 'winget' {
        if (-not (Get-Command winget -ErrorAction SilentlyContinue)) { return 'SKIP:non installé' }
        $v = (& winget --version 2>$null) | Select-Object -First 1
        Assert-True ([string]$v -match '\d+\.\d+') "réponse inattendue : $v"
        [string]$v
    }
    Test-Case 'Module Microsoft.WinGet.Client' {
        if (Test-WingetModule) { return 'présent (versions détaillées)' }
        if ([string](Get-JarvisConfig)['WingetModule'] -eq 'never') { return 'SKIP:absent, proposition désactivée à ta demande' }
        'SKIP:absent, lecture texte de winget utilisée (installable via le menu [M])'
    }
    Test-Case 'Préférences : mémorisation des choix' {
        $before = Get-JarvisConfig
        Assert-True (Set-JarvisConfigValue '__autotest' 'ok') 'écriture impossible'
        $mid = Get-JarvisConfig
        Assert-True ([string]$mid['__autotest'] -eq 'ok') 'valeur non relue'
        foreach ($k in $before.Keys) { Assert-True ([string]$mid[$k] -eq [string]$before[$k]) ("choix « $k » écrasé") }
        Assert-True (Set-JarvisConfigValue '__autotest' $null) 'suppression impossible'
        $after = Get-JarvisConfig
        Assert-True (-not $after.ContainsKey('__autotest')) 'valeur de test non supprimée'
        foreach ($k in $before.Keys) { Assert-True ([string]$after[$k] -eq [string]$before[$k]) ("choix « $k » perdu") }
        ('{0} choix conservés' -f $before.Count)
    }
    Test-Case 'Pilotes et périphériques' {
        $n1 = @(Get-CimInstance Win32_PnPSignedDriver -ErrorAction Stop).Count
        $n2 = @(Get-PnpDevice -PresentOnly -ErrorAction Stop).Count
        Assert-True ($n1 -gt 0 -and $n2 -gt 0) 'liste vide'
        "$n1 pilotes, $n2 périphériques"
    }
    Test-Case 'Cartes réseau' {
        $n = @(Get-NetAdapter -Physical -ErrorAction Stop).Count
        Assert-True ($n -gt 0) 'aucune carte physique'
        "$n carte(s) physique(s)"
    }
    Test-Case 'Volumes et disques' {
        $v = @(Get-Volume -ErrorAction Stop | Where-Object { $_.DriveLetter }).Count
        $d = @(Get-PhysicalDisk -ErrorAction Stop).Count
        Assert-True ($v -gt 0 -and $d -gt 0) 'aucun volume ou disque'
        "$v volume(s), $d disque(s)"
    }
    Test-Case 'Compteurs de fiabilité SSD' {
        $rc = Get-PhysicalDisk | Select-Object -First 1 | Get-StorageReliabilityCounter
        if ($null -eq $rc) { return 'SKIP:non exposés par ce disque' }
        'lisibles'
    } -NeedAdmin
    Test-Case 'Journal Système' {
        $e = Get-WinEvent -LogName System -MaxEvents 1 -ErrorAction Stop
        Assert-True ($null -ne $e) 'journal vide'
        'lisible'
    }
    Test-Case 'Antivirus (Defender / Centre de sécurité)' {
        $mp2 = Get-MpComputerStatus
        $av2 = @(Get-CimInstance -Namespace root/SecurityCenter2 -ClassName AntiVirusProduct)
        Assert-True ($null -ne $mp2 -or $av2.Count -gt 0) 'aucune source lisible'
        "Defender : $([bool]$mp2)  //  Centre de sécurité : $($av2.Count) produit(s)"
    }
    Test-Case 'Pare-feu' {
        $n = @(Get-NetFirewallProfile -ErrorAction Stop).Count
        Assert-True ($n -ge 1) 'aucun profil'
        "$n profil(s)"
    }
    Test-Case 'Réseau : ping 1.1.1.1' {
        if (-not (Test-Connection -ComputerName 1.1.1.1 -Count 1 -Quiet)) { return 'SKIP:pas de réponse (hors ligne ou ICMP filtré)' }
        'réponse reçue'
    }
    Test-Case 'Réseau : résolution DNS' {
        $null = Resolve-DnsName 'www.microsoft.com' -DnsOnly -QuickTimeout -ErrorAction Stop
        'résolu'
    }
    Test-Case 'Mise à jour en ligne (GitHub)' {
        $u = Get-JarvisUpdateResult (Start-JarvisUpdateCheck) 15000
        switch ($u.Status) {
            'NEW'      { 'v' + $u.Info.Version + ' disponible (installée : v' + $JarvisVersion + ')' }
            'UPTODATE' { 'à jour (dernière publiée : v' + $u.Info.Version + ')' }
            'NONE'     { 'SKIP:aucune version publiée sur GitHub' }
            'OFFLINE'  { 'SKIP:' + $u.Detail }
            default    { throw $u.Detail }
        }
    }

    # ---------------- T4 : écriture et affichage
    Write-Section 'T4' 'Écriture et affichage'

    Test-Case 'Dossier des rapports' {
        $d = Get-ReportDir
        Assert-True ($null -ne $d) 'aucun emplacement accessible en écriture'
        $d
    }
    Test-Case 'Accès contrôlé aux dossiers (Defender)' {
        $pref = Get-MpPreference
        if ($null -eq $pref) { return 'SKIP:état illisible' }
        $docs = [Environment]::GetFolderPath('MyDocuments')
        $od = ''
        if ($docs -match 'OneDrive') { $od = '  //  Documents dans OneDrive' }
        switch ([int]$pref.EnableControlledFolderAccess) {
            1 { 'actif, Documents et Bureau protégés' + $od }
            2 { 'mode audit' + $od }
            default { 'inactif' + $od }
        }
    }
    Test-Case 'Installation' {
        if (-not $JarvisInstalled) { return 'SKIP:lancé sans installation (' + $JarvisHome + ')' }
        Assert-True (Test-Path -LiteralPath $StartLnk) 'raccourci du menu Démarrer absent'
        $b = [IO.File]::ReadAllBytes($StartLnk)
        Assert-True (($b[0x15] -band 0x20) -ne 0) 'raccourci sans « Exécuter en tant qu''administrateur »'
        'v' + $JarvisVersion + ' dans ' + $JarvisHome
    }
    Test-Case 'Inscription dans Windows (Applications)' {
        if (-not $JarvisInstalled) { return 'SKIP:lancé sans installation' }
        $k = Get-ItemProperty -LiteralPath $RegKey
        Assert-True ($null -ne $k) 'absent des applications installées'
        Assert-True ([string]$k.DisplayVersion -eq $JarvisVersion) ('version inscrite ' + $k.DisplayVersion + ', attendue ' + $JarvisVersion)
        Assert-True (([string]$k.InstallLocation).TrimEnd('\') -eq $JarvisHome.TrimEnd('\')) 'emplacement inscrit incorrect'
        'v' + $k.DisplayVersion + ', désinstallable depuis Paramètres'
    }
    Test-Case 'Installation protégée en écriture' {
        if (-not $JarvisInstalled) { return 'SKIP:lancé sans installation' }
        $bad = @(Get-WeakWriters @($JarvisHome, (Join-Path $JarvisHome 'JARVIS.cmd')))
        Assert-True ($bad.Count -eq 0) ('modifiable sans droits admin par : ' + ($bad -join ', '))
        'modification réservée aux administrateurs'
    }
    Test-Case 'Profil utilisateur (%APPDATA%\JARVIS)' {
        $d = Join-Path $env:APPDATA 'JARVIS'
        if (-not (Test-Path $d)) { New-Item -ItemType Directory -Path $d -ErrorAction Stop | Out-Null }
        $f = Join-Path $d '.jarvis_write_test'
        Set-Content -Path $f -Value 'ok' -ErrorAction Stop
        Remove-Item $f -Force
        'écriture OK'
    }
    Test-Case 'Rendu console' {
        $mode = 'Unicode'
        if ($UseAscii) { $mode = 'ASCII' }
        $term = 'console classique'
        if ($InWT) { $term = 'Windows Terminal' }
        "{0}  //  {1}  //  sortie {2}" -f $term, $mode, [Console]::OutputEncoding.WebName
    }

    # ---------------- T5 : garde-fous
    Write-Section 'T5' 'Garde-fous'

    Test-Case 'Intégrité de JARVIS.cmd' {
        $st = Test-JarvisIntegrity
        if ($st -eq 'NOHASH') { return 'SKIP:lancé hors de JARVIS.cmd' }
        Assert-True ($st -eq 'OK') 'fichier modifié ou incomplet'
        'empreinte SHA-256 conforme'
    }
    Test-Case 'Temp : chemins dangereux refusés' {
        foreach ($p in @("$env:SystemDrive\", $env:USERPROFILE, $env:SystemRoot, $env:ProgramFiles, $env:LOCALAPPDATA, '')) {
            Assert-True (-not (Test-SafeTempPath $p)) ('accepté à tort : ' + $p)
        }
        Assert-True (Test-SafeTempPath (Join-Path $env:SystemRoot 'Temp')) 'Windows\Temp refusé à tort'
        '6 refus, 1 acceptation'
    }
    Test-Case 'Temp : nettoyage en bac à sable' {
        $root = Join-Path $env:TEMP ('jarvis_garde_' + [guid]::NewGuid().ToString('N').Substring(0, 8))
        $sand = Join-Path $root 'Temp'
        $outside = Join-Path $root 'Protege'
        New-Item -ItemType Directory -Path $sand -Force -ErrorAction Stop | Out-Null
        New-Item -ItemType Directory -Path $outside -Force -ErrorAction Stop | Out-Null
        $old  = Join-Path $sand 'ancien.tmp'
        $new  = Join-Path $sand 'recent.tmp'
        $keep = Join-Path $outside 'precieux.txt'
        Set-Content -Path $old -Value 'x'; Set-Content -Path $new -Value 'x'; Set-Content -Path $keep -Value 'x'
        (Get-Item -LiteralPath $old).LastWriteTime = (Get-Date).AddDays(-3)
        $j = Join-Path $sand 'lien'
        cmd /c ('mklink /J "{0}" "{1}"' -f $j, $outside) | Out-Null
        try {
            Assert-True (Test-Path -LiteralPath $j) 'jonction de test non créée'
            $r = Clear-TempFolder $sand 24
            Assert-True $r.Ok 'nettoyage refusé'
            Assert-True (-not (Test-Path -LiteralPath $old)) 'fichier ancien non supprimé'
            Assert-True (Test-Path -LiteralPath $new) 'fichier récent supprimé à tort'
            Assert-True (Test-Path -LiteralPath $keep) 'jonction suivie : fichier extérieur supprimé'
        } finally {
            if (Test-Path -LiteralPath $j) { [IO.Directory]::Delete($j, $false) }
            if (-not (Test-Path -LiteralPath $j)) { Remove-Item -LiteralPath $root -Recurse -Force }
        }
        'ancien supprimé, récent et jonction préservés'
    }
    Test-Case 'Installation : chemins interdits refusés' {
        $badPaths = @($env:SystemRoot, [Environment]::GetFolderPath('Desktop'), (Join-Path $env:USERPROFILE 'Downloads'),
                      'dossier\relatif', 'C:\Program Files\JA?RVIS')
        foreach ($p in $badPaths) {
            $r = Resolve-InstallDir $p
            Assert-True (-not $r.Ok) ('accepté à tort : ' + $p)
        }
        $ok = Resolve-InstallDir (Split-Path -Parent $DefaultInstallDir)
        Assert-True ($ok.Ok -and $ok.Path -eq $DefaultInstallDir) ('Program Files mal traité : ' + $ok.Path + ' ' + $ok.Reason)
        '5 refus, \JARVIS ajouté automatiquement'
    }
    Test-Case 'Prénom : caractères dangereux filtrés' {
        $n = Get-SafeName 'Bob"; calc $(whoami) `x'
        Assert-True ($n -notmatch '[";$`()]') ('non filtré : ' + $n)
        Assert-True ((Get-SafeName "D'Artagnan") -eq "D'Artagnan") 'apostrophe perdue'
        Assert-True ((Get-SafeName 'Jean-Pierre') -eq 'Jean-Pierre') 'tiret perdu'
        Assert-True ($null -eq (Get-SafeName '$();')) 'saisie vide non rejetée'
        '4/4 cas'
    }
    Test-Case 'Mises à jour : comparaison de versions' {
        Assert-True ((Compare-JarvisVersion '3.3' '3.2') -gt 0) '3.3 > 3.2'
        Assert-True ((Compare-JarvisVersion '3.10' '3.9') -gt 0) '3.10 > 3.9 (pas un tri alphabétique)'
        Assert-True ((Compare-JarvisVersion '3.2' '3.3') -lt 0) '3.2 < 3.3'
        Assert-True ((Compare-JarvisVersion '3.3' '3.3') -eq 0) 'égalité'
        '4/4 cas'
    }
    Test-Case 'Réponses annulées = non' {
        Assert-True (Test-No $null) 'annulation acceptée comme oui'
        Assert-True (Test-No 'n') '« n » accepté comme oui'
        Assert-True (-not (Test-No '')) 'Entrée refusée pour une question à réponse oui par défaut'
        Assert-True (-not (Test-No 'o')) '« o » refusé'
        '4/4 cas'
    }
    Test-Case 'Windows Update : mises à jour exclues' {
        $mk = { param($t, $cat, $ui) [pscustomobject]@{ Title = $t; Categories = @($cat | ForEach-Object { [pscustomobject]@{ CategoryID = $_ } }); InstallationBehavior = [pscustomobject]@{ CanRequestUserInput = $ui } } }
        Assert-True ([bool](Test-SkipWuUpdate (& $mk 'Windows 11, version 25H2' @('3689bdc8-b205-4af4-8d4b-a63924c5e9d5') $false))) 'mise à niveau (catégorie) non exclue'
        Assert-True ([bool](Test-SkipWuUpdate (& $mk 'Mise à jour de fonctionnalité vers Windows 11' @() $false))) 'mise à niveau (titre) non exclue'
        Assert-True ([bool](Test-SkipWuUpdate (& $mk 'Pilote interactif' @() $true))) 'mise à jour interactive non exclue'
        Assert-True ($null -eq (Test-SkipWuUpdate (& $mk '2026-11 Mise à jour cumulative' @('0fa1201d-4330-4fa8-8ae9-b877473b6441') $false))) 'mise à jour normale exclue à tort'
        $opt = & $mk 'Pilote facultatif' @() $false
        $opt | Add-Member -NotePropertyName BrowseOnly -NotePropertyValue $true
        Assert-True ((Test-SkipWuUpdate $opt) -eq 'facultative') 'mise à jour facultative non exclue'
        '5/5 cas'
    }
    Test-Case 'Windows Update : installateur accessible' {
        $wus = New-Object -ComObject Microsoft.Update.Session -ErrorAction Stop
        $inst = $wus.CreateUpdateInstaller()
        Assert-True ($null -ne $inst) 'installateur non créé'
        if ($inst.IsBusy) { 'accessible (occupé en ce moment)' } else { 'accessible et libre' }
    } -NeedAdmin
    Test-Case 'Instance unique (verrou)' {
        if ($null -eq $script:JarvisMutex) { return 'SKIP:verrou non initialisé' }
        $r = Invoke-Spinner 'seconde instance simulée' {
            try { $m = [System.Threading.Mutex]::new($false, 'Local\JARVIS_CheckUp'); $m.WaitOne(0) } catch { $false }
        } 30
        Assert-True ($r -eq $false) 'une seconde instance a obtenu le verrou'
        'seconde instance bloquée'
    }
    Test-Case 'Blocage de la mise en veille' {
        Assert-True (Set-NoSleep $true) 'appel système refusé'
        'actif pendant la session'
    }
    Test-Case 'Touches parasites ignorées' {
        $avail = $null
        try { Clear-KeyBuffer; $avail = [Console]::KeyAvailable } catch { return 'SKIP:console non interactive' }
        Assert-True (-not $avail) 'touches encore en attente après vidage'
        'mémoire clavier vidée avant chaque question'
    }

    # ---------------- Bilan
    $pass = @($results | Where-Object { $_.State -eq 'PASS' }).Count
    $fail = @($results | Where-Object { $_.State -eq 'FAIL' }).Count
    $skip = @($results | Where-Object { $_.State -eq 'SKIP' }).Count

    Write-Host ''
    Write-Host ('  ╔' + ('═' * 64) + '╗') -ForegroundColor Cyan
    Write-Host '  ║' -NoNewline -ForegroundColor Cyan
    Write-Host ('  BILAN DE L''AUTO-TEST'.PadRight(64)) -NoNewline -ForegroundColor White
    Write-Host '║' -ForegroundColor Cyan
    Write-Host ('  ╚' + ('═' * 64) + '╝') -ForegroundColor Cyan
    $col = 'Green'
    if ($fail -gt 0) { $col = 'Red' }
    Write-Host ("   Réussis : {0}   //   Échecs : {1}   //   Ignorés : {2}" -f $pass, $fail, $skip) -ForegroundColor $col
    if ($fail -gt 0) {
        foreach ($r in ($results | Where-Object { $_.State -eq 'FAIL' })) {
            Write-Host ('   ! {0} : {1}' -f $r.Name, $r.Detail) -ForegroundColor Red
        }
        Type-Line '   >> Certains composants ne sont pas fiables sur ce PC. Les sections concernées peuvent donner des résultats faux ou incomplets.' 'Red'
    } elseif ($skip -gt 0) {
        Type-Line '   >> Tous les composants testés fonctionnent. Les tests ignorés dépendent des droits ou de l''équipement.' 'Green'
    } else {
        Type-Line '   >> Tous les composants de J.A.R.V.I.S. sont opérationnels sur ce PC.' 'Green'
    }

    $head = @('J.A.R.V.I.S. // Auto-test', ('Date : {0}   Hôte : {1}   Admin : {2}' -f (Get-Date -Format 'yyyy-MM-dd HH:mm'), $env:COMPUTERNAME, $isAdmin), '')
    $null = Save-Report 'selftest' ([string[]]($head + $log + @('', ("Réussis {0} / Échecs {1} / Ignorés {2}" -f $pass, $fail, $skip))))

    return $fail
}

function Get-CMErrorText([int]$code) {
    switch ($code) {
        1  { 'configuration incorrecte' }
        3  { 'pilote corrompu ou mémoire insuffisante' }
        10 { 'le périphérique ne peut pas démarrer' }
        12 { 'ressources insuffisantes' }
        18 { 'pilotes à réinstaller' }
        19 { 'registre corrompu' }
        28 { 'pilote non installé' }
        31 { 'pilote ne se charge pas' }
        39 { 'pilote corrompu ou absent' }
        43 { 'le périphérique a signalé un problème' }
        45 { 'non connecté' }
        52 { 'signature du pilote non vérifiée' }
        default { 'voir le Gestionnaire de périphériques' }
    }
}

function Format-Date($d) {
    if ($null -eq $d) { return 'inconnue' }
    try { return ([datetime]$d).ToString('yyyy-MM-dd') } catch { return 'inconnue' }
}

function Get-FolderSizeMB([string]$Path) {
    if (-not (Test-Path -LiteralPath $Path)) { return 0 }
    $sum = (@(Get-FilesNoJunction $Path) | Measure-Object -Property Length -Sum).Sum
    if ($null -eq $sum) { return 0 }
    return [math]::Round($sum / 1MB)
}

# ------------------------------------------------------------------
# Droits administrateur
# ------------------------------------------------------------------
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator)

try {
Clear-Host
Show-Banner
if ($Name) { $Name = [string](Get-SafeName $Name) }
if ($ResetChoices) {
    if (Set-JarvisConfigValue 'WingetModule' $null) {
        Write-Host '   >> Choix mémorisés effacés : les propositions facultatives réapparaîtront.' -ForegroundColor DarkGray
    }
}

try { [Console]::TreatControlCAsInput = $true } catch {}   # Ctrl+C = annuler la question, jamais couper brutalement

# Instance unique : une seule fenêtre J.A.R.V.I.S. à la fois
$gotLock = $false
try {
    $script:JarvisMutex = [System.Threading.Mutex]::new($false, 'Local\JARVIS_CheckUp')
    try { $gotLock = $script:JarvisMutex.WaitOne(3000) } catch [System.Threading.AbandonedMutexException] { $gotLock = $true }
} catch { $gotLock = $false }
if (-not $gotLock) {
    Write-Host '   [!] J.A.R.V.I.S. est déjà en cours d''exécution dans une autre fenêtre.' -ForegroundColor Yellow
    Write-Host '       Termine ou ferme l''autre fenêtre (installation et mise à jour comprises) avant d''en lancer une nouvelle.' -ForegroundColor Yellow
    Read-Answer '   [Entrée pour fermer]' | Out-Null
    exit 2
}
$null = Set-NoSleep $true

if ($Uninstall) {
    Uninstall-Jarvis
    Read-Answer '   [Entrée pour fermer]' | Out-Null
    exit
}

if ($Update) {
    Write-Host '   >> Recherche d''une nouvelle version sur GitHub...' -ForegroundColor DarkCyan
    $upd = Get-JarvisUpdateResult (Start-JarvisUpdateCheck) 15000
    switch ($upd.Status) {
        'NEW'      { Invoke-JarvisSelfUpdate $upd.Info }
        'UPTODATE' { Write-Host ("   [ OK ] J.A.R.V.I.S. est à jour (v{0})." -f $JarvisVersion) -ForegroundColor Green }
        'NONE'     { Write-Host '   [INFO] Aucune version publiée en ligne pour l''instant.' -ForegroundColor Cyan }
        default    {
            Write-Host ('   [!] Vérification impossible : ' + $upd.Detail + '.') -ForegroundColor Yellow
            Write-Host '       Vérifie la connexion Internet, puis relance.' -ForegroundColor DarkGray
        }
    }
    Read-Answer '   [Entrée pour fermer]' | Out-Null
    exit
}

# Recherche d'une nouvelle version en arrière-plan, lue au menu (3 s au plus, silencieuse si hors ligne)
$script:UpdateCheck = $null
if (-not ($Quick -or $Deep -or $SelfTest)) { $script:UpdateCheck = Start-JarvisUpdateCheck }

if (-not $JarvisInstalled -and $JarvisSelf -like '*.cmd') {
    $inst = Get-InstalledJarvis
    $choice = 'install'
    if (-not $Install) {
        if ($inst) {
            $cmpV = Compare-JarvisVersion $JarvisVersion $inst.Version
            if ($cmpV -gt 0) {
                Write-Host ("   MISE À JOUR DISPONIBLE : v{0} installée, cette copie est la v{1}." -f $inst.Version, $JarvisVersion) -ForegroundColor Cyan
                Write-Host '   [1] Mettre à jour (recommandé)   prénom, rapports et raccourcis conservés' -ForegroundColor Gray
                Write-Host ("   [2] Lancer la version installée (v{0})" -f $inst.Version) -ForegroundColor Gray
                Write-Host '   [3] Lancer cette copie sans installer' -ForegroundColor Gray
                Write-Host '   [Échap] Quitter' -ForegroundColor DarkGray
                $c = Read-Answer '   >> Choix [1/2/3]'
                if ($null -eq $c) { $choice = 'quit' } elseif ($c -eq '2') { $choice = 'launch' } elseif ($c -eq '3') { $choice = 'run' } else { $choice = 'install' }
            } elseif ($cmpV -eq 0) {
                Write-Host ("   Cette version (v{0}) est déjà installée dans {1}." -f $JarvisVersion, $inst.Dir) -ForegroundColor Cyan
                Write-Host '   [1] Lancer la version installée (recommandé)' -ForegroundColor Gray
                Write-Host '   [2] Réinstaller (répare l''installation et les raccourcis)' -ForegroundColor Gray
                Write-Host '   [3] Lancer cette copie sans installer' -ForegroundColor Gray
                Write-Host '   [Échap] Quitter' -ForegroundColor DarkGray
                $c = Read-Answer '   >> Choix [1/2/3]'
                if ($null -eq $c) { $choice = 'quit' } elseif ($c -eq '2') { $choice = 'install' } elseif ($c -eq '3') { $choice = 'run' } else { $choice = 'launch' }
            } else {
                Write-Host ("   [!] Cette copie (v{0}) est PLUS ANCIENNE que la version installée (v{1})." -f $JarvisVersion, $inst.Version) -ForegroundColor Yellow
                Write-Host '       Elle ne remplacera pas la version installée.' -ForegroundColor Yellow
                Write-Host ("   [1] Lancer la version installée v{0} (recommandé)" -f $inst.Version) -ForegroundColor Gray
                Write-Host '   [2] Lancer quand même cette ancienne copie, sans installer' -ForegroundColor Gray
                Write-Host '   [Échap] Quitter' -ForegroundColor DarkGray
                $c = Read-Answer '   >> Choix [1/2]'
                if ($null -eq $c) { $choice = 'quit' } elseif ($c -eq '2') { $choice = 'run' } else { $choice = 'launch' }
            }
        } else {
            Write-Host '   J.A.R.V.I.S. n''est pas encore installé sur ce PC.' -ForegroundColor Cyan
            Write-Host '   [1] Installer (recommandé)   C:\Program Files\JARVIS + raccourci menu Démarrer' -ForegroundColor Gray
            Write-Host '   [2] Lancer sans installer' -ForegroundColor Gray
            Write-Host '   [Échap] Quitter' -ForegroundColor DarkGray
            $c = Read-Answer '   >> Choix [1/2]'
            if ($null -eq $c) { $choice = 'quit' } elseif ($c -eq '2') { $choice = 'run' } else { $choice = 'install' }
        }
    } elseif ($inst -and (Compare-JarvisVersion $JarvisVersion $inst.Version) -lt 0) {
        Write-Host ("   [!] Installation refusée : la version installée (v{0}) est plus récente que cette copie (v{1})." -f $inst.Version, $JarvisVersion) -ForegroundColor Yellow
        $choice = 'launch'
    }

    if ($choice -eq 'quit') { exit }
    if ($choice -eq 'launch') {
        if (Start-Elevated $inst.Cmd '') { exit }
        Write-Host '   >> Poursuite avec cette copie.' -ForegroundColor DarkGray
        $choice = 'run'
    }
    if ($choice -eq 'install' -and -not $isAdmin) {
        # Program Files exige les droits administrateur : relance élevée en mode installation
        $ia = '-Install'
        if ($InstallDir) { $ia += " -InstallDir `"$InstallDir`"" }
        Write-Host '   >> Validation administrateur requise pour installer dans Program Files.' -ForegroundColor Cyan
        if (Start-Elevated $JarvisSelf $ia) { exit }
        Write-Host '   >> Installation annulée. Lancement sans installation.' -ForegroundColor DarkGray
        $choice = 'run'
    }
    if ($choice -eq 'install') {
        Write-Host ''
        $target = $null
        if ($inst) { $target = $inst.Dir }
        $dest = Install-Jarvis $target
        if ($dest) {
            Write-Host ''
            $a = Read-Answer '   >> Lancer J.A.R.V.I.S. maintenant ? [O/n]'
            if (-not (Test-No $a)) {
                if (-not (Start-Elevated $dest '')) {
                    Write-Host '   >> Lance J.A.R.V.I.S. plus tard depuis le menu Démarrer.' -ForegroundColor DarkGray
                    Start-Sleep -Seconds 3
                }
            }
            exit
        }
        Write-Host '   >> Poursuite sans installation.' -ForegroundColor DarkGray
    }
    Write-Host ''
}

if (-not $isAdmin -and -not $NoElevate) {
    Write-Host '   [!] Droits administrateur absents : contrôles partiels, mode complet indisponible.' -ForegroundColor Yellow
    $a = Read-Answer '   >> Relancer en mode administrateur ? [O/n]'
    if (-not (Test-No $a)) {
        $argList = ''
        if ($Name)      { $argList += " -Name `"$Name`"" }
        if ($ResetName) { $argList += ' -ResetName' }
        if ($ResetChoices) { $argList += ' -ResetChoices' }
        if ($SelfTest)  { $argList += ' -SelfTest' }
        if ($Ascii)     { $argList += ' -Ascii' }
        if ($NoAnim)   { $argList += ' -NoAnim' }
        if ($NoWinget) { $argList += ' -NoWinget' }
        if ($Quick)    { $argList += ' -Quick' }
        if ($Deep)     { $argList += ' -Deep' }
        $okUac = $false
        if ($JarvisSelf -like '*.cmd') { $okUac = Start-Elevated $JarvisSelf $argList.Trim() }
        else { $okUac = Start-Elevated 'powershell.exe' ("-NoProfile -ExecutionPolicy Bypass -File `"$JarvisSelf`"" + $argList) }
        if ($okUac) { exit }
        Write-Host '   >> Poursuite sans droits administrateur : contrôles réduits, scan complet indisponible.' -ForegroundColor DarkGray
    }
}

# ------------------------------------------------------------------
# Choix du mode
# ------------------------------------------------------------------

$script:RunSelfTest = $false
if ($SelfTest) {
    $script:RunSelfTest = $true
} elseif ($Deep) {
    $script:DeepMode = $true
} elseif (-not $Quick) {
    Write-Host '   SÉLECTION DU PROTOCOLE' -ForegroundColor Cyan
    Write-Host '   [1] Scan rapide    ~2-5 min    état, mises à jour, pilotes, sécurité, journaux' -ForegroundColor Gray
    Write-Host '   [2] Scan complet   ~20-60 min  tout le scan rapide + DISM, SFC /scannow, CHKDSK' -ForegroundColor Gray
    Write-Host '   [3] Auto-test      ~1-2 min    vérifie que JARVIS fonctionne correctement sur ce PC' -ForegroundColor Gray
    $upd = Get-JarvisUpdateResult $script:UpdateCheck 3000
    $showU = ($upd.Status -eq 'NEW')
    if ($showU) {
        Write-Host ("   [U] Mise à jour    ~1 min      v{0} disponible : nouveautés et installation" -f $upd.Info.Version) -ForegroundColor Green
    }
    $showM = Test-ShowWingetOffer
    if ($showM) { Write-Host '   [M] Module winget  ~1-3 min    facultatif : versions détaillées des mises à jour d''applications' -ForegroundColor Gray }
    if ($JarvisInstalled) { Write-Host '   [4] Désinstaller J.A.R.V.I.S.' -ForegroundColor DarkGray }
    Write-Host '   [R] Ouvrir le dossier des rapports' -ForegroundColor DarkGray
    Write-Host '   [Échap] Quitter' -ForegroundColor DarkGray
    $buildKeys = {
        $k = @('1', '2', '3')
        if ($showU) { $k += 'U' }
        if ($showM) { $k += 'M' }
        if ($JarvisInstalled) { $k += '4' }
        $k += 'R'
        '   >> Protocole [' + ($k -join '/') + ']'
    }
    $prompt = & $buildKeys
    $m = Read-Answer $prompt
    if ($null -eq $m) { exit }
    while ($m -match '^[rR]$' -or ($showM -and $m -match '^[mM]$') -or ($showU -and $m -match '^[uU]$')) {
        if ($m -match '^[rR]$') {
            $rd = Get-ReportDir
            if ($rd) { Start-Process -FilePath 'explorer.exe' -ArgumentList ('"{0}"' -f $rd) }
            else { Write-Host '   [!] Aucun dossier de rapports accessible.' -ForegroundColor Yellow }
        } elseif ($m -match '^[uU]$') {
            Invoke-JarvisSelfUpdate $upd.Info      # ne revient ici qu'en cas d'annulation ou d'échec
            Write-Host ''
        } else {
            Invoke-WingetModuleOffer
            $showM = Test-ShowWingetOffer
            $prompt = & $buildKeys
        }
        $m = Read-Answer $prompt
        if ($null -eq $m) { exit }
    }
    if ($m -eq '2') { $script:DeepMode = $true }
    if ($m -eq '3') { $script:RunSelfTest = $true }
    if ($m -eq '4' -and $JarvisInstalled) {
        Uninstall-Jarvis
        Read-Answer '   [Entrée pour fermer]' | Out-Null
        exit
    }
}
if ($script:RunSelfTest) {
    $fails = Invoke-SelfTest | Select-Object -Last 1
    Write-Host ''
    Read-Answer '   [Entrée pour fermer]' | Out-Null
    exit ([int]([int]$fails -gt 0))
}
if ($script:DeepMode -and -not $isAdmin) {
    Write-Host '   [!] Le scan complet exige les droits administrateur. Bascule en scan rapide.' -ForegroundColor Yellow
    $script:DeepMode = $false
}
if ($script:DeepMode) {
    if (-not (Confirm-DeepScan)) {
        Write-Host '   >> Bascule en scan rapide.' -ForegroundColor DarkGray
        $script:DeepMode = $false
    }
}

# ------------------------------------------------------------------
# Identification de l'utilisateur
# ------------------------------------------------------------------
function Get-DetectedFirstName {
    $full = $null
    try {
        Add-Type -AssemblyName System.DirectoryServices.AccountManagement -ErrorAction Stop
        $up = [System.DirectoryServices.AccountManagement.UserPrincipal]::Current
        if ($up.GivenName) { return [string]$up.GivenName }
        if ($up.DisplayName) { $full = [string]$up.DisplayName }
    } catch {}
    if (-not $full) {
        $acc = Get-CimInstance Win32_UserAccount -Filter ("Name='{0}' AND LocalAccount=True" -f $env:USERNAME)
        if ($acc.FullName) { $full = [string]$acc.FullName }
    }
    if ($full) {
        return (Get-FirstNameFromFull $full)
    }
    return $null
}

$cfg = Get-JarvisConfig
if (-not $Name) {
    $cfgName = $null
    if (-not $ResetName -and $cfg.ContainsKey('Name')) { $cfgName = Get-SafeName ([string]$cfg['Name']) }
    if ($cfgName) {
        $Name = $cfgName
    } else {
        $guess = Get-SafeName (Get-DetectedFirstName)
        Write-Host ''
        Write-Host '   PREMIÈRE INITIALISATION' -ForegroundColor Cyan
        if ($guess) {
            $ans = Read-Answer ("   >> Identité détectée : {0}. Entrée pour confirmer, ou tape le prénom à utiliser" -f $guess)
            $Name = $guess
            if (-not [string]::IsNullOrWhiteSpace($ans)) {
                $n2 = Get-SafeName $ans
                if ($n2) { $Name = $n2 } else { Write-Host '   [!] Prénom invalide, prénom détecté conservé.' -ForegroundColor Yellow }
            }
        } else {
            $ans = Read-Answer '   >> Comment dois-je t''appeler ?'
            $Name = Get-SafeName $ans
            if (-not $Name) { $Name = 'opérateur' }
        }
        if (Set-JarvisConfigValue 'Name' $Name) {
            Write-Host '   >> Profil enregistré. Pour le changer : JARVIS.cmd -ResetName' -ForegroundColor DarkGray
        }
    }
}

# ------------------------------------------------------------------
# Séquence de démarrage
# ------------------------------------------------------------------
$h = (Get-Date).Hour
$greet = "Bonsoir, $Name. Démarrage du diagnostic."
if ($h -lt 6)      { $greet = "Il est tard, $Name. Je lance quand même le diagnostic." }
elseif ($h -lt 12) { $greet = "Bonjour, $Name. Démarrage du diagnostic." }
elseif ($h -lt 18) { $greet = "Bon après-midi, $Name. Démarrage du diagnostic." }

Write-Host ''
Show-HexRain 4
Write-Host ''
Show-Bar 'Noyau d''analyse'
Show-Bar 'Interfaces WMI / CIM'
Show-Bar 'Agent Windows Update'
Show-Bar 'Registre des pilotes'
if ($script:DeepMode) { Show-Bar 'Moteurs DISM / SFC / CHKDSK' }
Write-Host ''
Type-Line ("   >> " + $greet) 'Cyan'
$modeTxt = 'rapide'
if ($script:DeepMode) { $modeTxt = 'complet' }
$adminTxt = 'non'
if ($isAdmin) { $adminTxt = 'oui' }
Type-Line ("   >> Hôte : {0}  //  Session : {1}  //  Admin : {2}  //  Protocole : {3}" -f $env:COMPUTERNAME, $env:USERNAME, $adminTxt, $modeTxt) 'DarkCyan' 2

$script:Report.Add('J.A.R.V.I.S. // Rapport de check-up')
$script:Report.Add(('Date : {0}   Hôte : {1}   Admin : {2}   Protocole : {3}' -f (Get-Date -Format 'yyyy-MM-dd HH:mm'), $env:COMPUTERNAME, $adminTxt, $modeTxt))

# ==================================================================
# [01] SYSTÈME
# ==================================================================
Write-Section '01' 'Système'

$os = Get-CimInstance Win32_OperatingSystem
$cv = Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion'
Write-Status 'Système' ('{0} {1}' -f $os.Caption, $cv.DisplayVersion) 'INFO'
Write-Status 'Build' ('{0}.{1}' -f $cv.CurrentBuild, $cv.UBR) 'INFO'
if ([int]$cv.CurrentBuild -lt 22000) {
    Write-Status 'Support Windows 10' 'terminé le 14/10/2025 (sauf abonnement ESU)' 'WARN'
    Write-Sub 'Passage à Windows 11 conseillé si le matériel est compatible'
}
$isLaptop = [bool](Get-CimInstance Win32_Battery)
$typeTxt = 'PC fixe'
if ($isLaptop) { $typeTxt = 'PC portable' }
$cs = Get-CimInstance Win32_ComputerSystem
Write-Status 'Machine' ('{0}  //  {1} {2}' -f $typeTxt, $cs.Manufacturer, $cs.Model) 'INFO'

$up = (Get-Date) - $os.LastBootUpTime
$upTxt = '{0} j {1} h {2} min' -f $up.Days, $up.Hours, $up.Minutes
if ($up.TotalDays -gt 7) { Write-Status 'Uptime' "$upTxt (redémarrage conseillé)" 'WARN' }
else { Write-Status 'Uptime' $upTxt 'OK' }

$pending = @()
if (Test-Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending') { $pending += 'composants Windows' }
if (Test-Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired') { $pending += 'Windows Update' }
if ($pending.Count -gt 0) { Write-Status 'Redémarrage en attente' ($pending -join ', ') 'WARN' }
else { Write-Status 'Redémarrage en attente' 'aucun' 'OK' }

# ==================================================================
# [02] WINDOWS UPDATE
# ==================================================================
Write-Section '02' 'Windows Update'

try {
    $au = New-Object -ComObject Microsoft.Update.AutoUpdate
    $last = $au.Results.LastInstallationSuccessDate
    if ($last) {
        $age = ((Get-Date) - [datetime]$last).Days
        $txt = "{0} (il y a {1} j)" -f (Format-Date $last), $age
        if ($age -gt 30) { Write-Status 'Dernière installation' $txt 'WARN' }
        else { Write-Status 'Dernière installation' $txt 'OK' }
    }
} catch {}

$wu = Invoke-Spinner 'Interrogation des serveurs Microsoft' {
    try {
        $s = New-Object -ComObject Microsoft.Update.Session
        $r = $s.CreateUpdateSearcher().Search('IsInstalled=0 and IsHidden=0')
        $list = @()
        foreach ($u in $r.Updates) {
            $list += [pscustomobject]@{
                Title  = [string]$u.Title
                Driver = ($u.Type -eq 2)
                Optional = [bool]$u.BrowseOnly
                Interactive = [bool]$u.InstallationBehavior.CanRequestUserInput
            }
        }
        [pscustomobject]@{ Ok = $true; Updates = $list; Error = $null }
    } catch {
        [pscustomobject]@{ Ok = $false; Updates = @(); Error = $_.Exception.Message }
    }
} 240

if ($null -eq $wu) {
    Write-Status 'Recherche de mises à jour' 'délai dépassé (4 min)' 'WARN'
} elseif (-not $wu.Ok) {
    Write-Status 'Recherche de mises à jour' ('échec : ' + (Cut $wu.Error 50)) 'WARN'
} else {
    $all = @($wu.Updates)
    $important = @($all | Where-Object { -not $_.Optional -and -not $_.Interactive })
    $manual    = @($all | Where-Object { -not $_.Optional -and $_.Interactive })
    $optional  = @($all | Where-Object { $_.Optional })
    $script:WUCount = $important.Count
    $script:WUManual = $manual.Count
    if ($important.Count -eq 0) {
        Write-Status 'Mises à jour importantes' 'aucune, Windows est à jour' 'OK'
    } else {
        $nDrv = @($important | Where-Object { $_.Driver }).Count
        Write-Status 'Mises à jour importantes' ("{0} en attente (dont {1} pilote(s))" -f $important.Count, $nDrv) 'WARN'
        foreach ($u in $important) {
            $kind = 'SYS'
            if ($u.Driver) { $kind = 'PILOTE' }
            Write-Sub ("[{0}] {1}" -f $kind, (Cut $u.Title 70)) 'Yellow'
        }
    }
    if ($manual.Count -gt 0) {
        Write-Status 'À faire dans Windows Update' ("{0}, demandent une action à l'écran" -f $manual.Count) 'INFO'
        foreach ($u in $manual) { Write-Sub (Cut $u.Title 80) }
    }
    if ($optional.Count -gt 0) {
        Write-Status 'Mises à jour facultatives' ("{0}, non nécessaires" -f $optional.Count) 'INFO'
        foreach ($u in $optional) { Write-Sub (Cut $u.Title 80) }
        Write-Sub 'Utiles seulement si un appareil fonctionne mal : Windows Update > Options avancées > Mises à jour facultatives'
    }
}

# ==================================================================
# [03] APPLICATIONS (winget)
# ==================================================================
Write-Section '03' 'Applications (winget)'

if ($NoWinget) {
    Write-Status 'winget' 'vérification sautée (-NoWinget)' 'INFO'
} else {
    $wgParser = ${function:ConvertFrom-WingetText}.ToString()
    $wgUnknown = ${function:Get-WingetUnknownCount}.ToString()
    $wg = Invoke-Spinner 'Analyse des paquets installés' {
        param($ParserText, $UnknownText)
        # Liste de départ : « winget upgrade ». Le module (s'il est là) complète noms, identifiants et
        # versions tronqués, et écarte ce que winget refusera d'installer (IsUpdateAvailable faux).
        # Constaté le 19/11/2026 : Epson Scan 2 (version « Unknown ») et Hytale Launcher (installé pour
        # tous les utilisateurs, winget ne propose qu'une installation par utilisateur) étaient proposés
        # puis refusés par winget ; le module, lui, savait que Hytale n'était pas applicable.
        $out = [pscustomobject]@{ Mode = 'text'; Items = @(); Unknown = 0; UnknownNames = @(); NotApplicable = @(); Error = $null }
        if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
            $out.Error = 'NOWINGET'
            return $out
        }
        try { [Console]::OutputEncoding = [Text.Encoding]::UTF8 } catch {}
        $raw = & winget upgrade --accept-source-agreements --disable-interactivity 2>&1 | Out-String
        $out.Items = @(& ([scriptblock]::Create($ParserText)) $raw)
        $out.Unknown = [int](& ([scriptblock]::Create($UnknownText)) $raw)
        try {
            if (Get-Module -ListAvailable -Name Microsoft.WinGet.Client) {
                Import-Module Microsoft.WinGet.Client -ErrorAction Stop
                $all = @(Get-WinGetPackage)
                $out.Mode = 'text+module'
                $ell = [string][char]0x2026
                $keep = @()
                foreach ($it in $out.Items) {
                    $p = $null
                    $cliId = [string]$it.Id
                    if ($it.Id.EndsWith($ell)) {
                        $pre = $it.Id.TrimEnd([char]0x2026)
                        $p = $all | Where-Object { ([string]$_.Id).StartsWith($pre, [StringComparison]::OrdinalIgnoreCase) } | Select-Object -First 1
                    } elseif ($it.Id) {
                        $p = $all | Where-Object { [string]$_.Id -eq $it.Id } | Select-Object -First 1
                    }
                    if ($p) {
                        $it.Id = [string]$p.Id
                        $it.Name = [string]$p.Name
                        $it.Installed = [string]$p.InstalledVersion
                        $av = [string]($p.AvailableVersions | Select-Object -First 1)
                        if ($av) { $it.Available = $av }
                        if (-not $p.IsUpdateAvailable) {
                            $out.NotApplicable += [pscustomobject]@{ Name = $it.Name; Ids = @($it.Id, $cliId) }
                            continue
                        }
                    }
                    $keep += $it
                }
                $out.Items = $keep
                $out.UnknownNames = @($all | Where-Object { $_.IsUpdateAvailable -and [string]$_.InstalledVersion -eq 'Unknown' } |
                                      ForEach-Object { [string]$_.Name })
            }
        } catch {}
        return $out
    } 300 -ArgumentList $wgParser, $wgUnknown

    if ($null -eq $wg) {
        Write-Status 'winget' 'délai dépassé (5 min)' 'WARN'
    } elseif ($wg.Error -eq 'NOWINGET') {
        Write-Status 'winget' 'non installé' 'INFO'
        Write-Sub 'Installer « Programme d''installation d''application » depuis le Microsoft Store'
    } elseif ($wg.Error) {
        Write-Status 'winget' $wg.Error 'WARN'
    } else {
        $items = @($wg.Items)
        $script:WGCount = $items.Count
        $script:WGItems = $items
        if ($items.Count -eq 0) {
            Write-Status 'Applications à mettre à jour' 'aucune' 'OK'
        } else {
            Write-Status 'Applications à mettre à jour' ([string]$items.Count) 'WARN'
            if ($wg.Mode -eq 'text' -and (Test-ShowWingetOffer)) {
                Write-Sub 'Versions détaillées possibles avec le module winget : menu [M]'
            }
            foreach ($it in $items) {
                if ($it.Available) {
                    Write-Sub ("{0,-34} {1} -> {2}" -f (Cut $it.Name 34), $it.Installed, $it.Available) 'Yellow'
                } else {
                    Write-Sub (Cut $it.Name 90) 'Yellow'
                }
            }
        }
        if ($wg.Unknown -gt 0) {
            # winget ne connaît pas leur version installée : il refuse de les mettre à jour, inutile de les proposer
            $names = ''
            if (@($wg.UnknownNames).Count -gt 0) { $names = ' : ' + (Cut (@($wg.UnknownNames) -join ', ') 60) }
            Write-Status 'Version non détectable par winget' ([string]$wg.Unknown + $names) 'INFO'
            Write-Sub 'winget ne peut pas les mettre à jour : passe par l''application elle-même ou le site de l''éditeur si besoin'
        }
        $script:WGSkipIds = @(@($wg.NotApplicable) | ForEach-Object { $_.Ids } | Where-Object { $_ })
        if (@($wg.NotApplicable).Count -gt 0) {
            # Nouvelle version existante mais pas pour ce type d'installation : winget la refuserait
            Write-Status 'Non mises à jour par winget' (Cut ((@($wg.NotApplicable) | ForEach-Object { $_.Name }) -join ', ') 60) 'INFO'
            Write-Sub 'Leur nouvelle version ne convient pas à leur installation : mets-les à jour depuis l''application elle-même'
        }
    }
}

# ==================================================================
# [04] PILOTES
# ==================================================================
Write-Section '04' 'Pilotes'

$drv = @(Get-CimInstance Win32_PnPSignedDriver | Where-Object { $_.DeviceName })

# Wi-Fi
$phys = @(Get-NetAdapter -Physical)
$wifiNa = $phys | Where-Object { $_.PhysicalMediaType -match '802\.11' } | Select-Object -First 1
$wifi = $null
if ($wifiNa) { $wifi = $drv | Where-Object { $_.DeviceName -eq $wifiNa.InterfaceDescription } | Select-Object -First 1 }
if (-not $wifi) {
    $wifi = $drv | Where-Object { $_.DeviceClass -eq 'NET' -and $_.DeviceName -match 'Wi-?Fi|Wireless|WLAN|802\.11' -and $_.DeviceName -notmatch 'Bluetooth|Virtual|Direct' } | Select-Object -First 1
}
$wifiModel = $null
if ($wifi) {
    if ($wifi.DeviceName -match '(AX\d{3}|BE\d{3})') { $wifiModel = $Matches[1] }
    Write-Status (Cut $wifi.DeviceName 32) ("v{0}  ({1})" -f $wifi.DriverVersion, (Format-Date $wifi.DriverDate)) 'INFO'
    if ($wifiModel -and $Ref.ContainsKey($wifiModel)) {
        Write-Sub ("Référence Intel {0} : paquet Wi-Fi {1}" -f $wifiModel, $Ref[$wifiModel].WiFiPkg)
    }
}

# Bluetooth
$bt = $drv | Where-Object { $_.DeviceClass -eq 'BLUETOOTH' -and ($_.DeviceID -like 'USB\*' -or $_.DeviceID -like 'PCI\*') } | Select-Object -First 1
if ($bt) {
    $btVal = "v{0}  ({1})" -f $bt.DriverVersion, (Format-Date $bt.DriverDate)
    if ($wifiModel -and $Ref.ContainsKey($wifiModel) -and $bt.Manufacturer -match 'Intel') {
        $refBT = $Ref[$wifiModel].BT
        $cmp = 0
        $c2 = Compare-DriverVersion $bt.DriverVersion $refBT
        if ($null -ne $c2) { $cmp = $c2 }
        if ($cmp -ge 0) {
            Write-Status (Cut $bt.DeviceName 32) $btVal 'OK'
            Write-Sub $Ref[$wifiModel].BTNote
        } else {
            Write-Status (Cut $bt.DeviceName 32) ("$btVal  -> $refBT disponible") 'WARN'
        }
    } else {
        Write-Status (Cut $bt.DeviceName 32) $btVal 'INFO'
    }
}

# Ethernet
$ethNa = @($phys | Where-Object { $_.PhysicalMediaType -match '802\.3' })
foreach ($e in $ethNa) {
    $ed = $drv | Where-Object { $_.DeviceName -eq $e.InterfaceDescription } | Select-Object -First 1
    if ($ed) { Write-Status (Cut $ed.DeviceName 32) ("v{0}  ({1})" -f $ed.DriverVersion, (Format-Date $ed.DriverDate)) 'INFO' }
    else { Write-Status (Cut $e.InterfaceDescription 32) ("v{0}" -f $e.DriverVersion) 'INFO' }
}

# GPU
$gpus = @($drv | Where-Object { $_.DeviceClass -eq 'DISPLAY' })
foreach ($g in $gpus) {
    $v = "v{0}  ({1})" -f $g.DriverVersion, (Format-Date $g.DriverDate)
    if ($g.Manufacturer -match 'NVIDIA') {
        $nv = Convert-NvidiaVersion $g.DriverVersion
        if ($nv) { $v += ('  = GeForce ' + $nv) }
    }
    if ($g.DeviceName -match 'Basic Display|Microsoft Basic Render|Carte vid.o de base') {
        Write-Status (Cut $g.DeviceName 32) 'pilote générique Microsoft, pilote constructeur absent' 'FAIL'
        continue
    }
    if ($g.Manufacturer -match 'AMD|Advanced Micro') { $v += '  (version Adrenalin : logiciel AMD)' }
    $gAge = 0
    try { $gAge = ((Get-Date) - [datetime]$g.DriverDate).Days } catch {}
    if ($gAge -gt 180) { Write-Status (Cut $g.DeviceName 32) ("$v  (> 6 mois)") 'WARN' }
    else { Write-Status (Cut $g.DeviceName 32) $v 'OK' }
}

# Périphériques en erreur
$bad = @(Get-CimInstance Win32_PnPEntity | Where-Object { $null -ne $_.ConfigManagerErrorCode -and $_.ConfigManagerErrorCode -ne 0 })
$realBad = 0
foreach ($d in $bad) {
    $n = $d.DeviceID
    if ($d.Name) { $n = $d.Name }
    $code = [int]$d.ConfigManagerErrorCode
    if ($code -eq 22) {
        Write-Status (Cut $n 32) 'désactivé' 'INFO'
    } elseif ($d.DeviceID -like 'BTHENUM*' -or $d.DeviceID -like 'BTHLEDEVICE*') {
        Write-Status (Cut $n 32) 'service Bluetooth du téléphone sans pilote (normal)' 'INFO'
    } else {
        $realBad++
        Write-Status (Cut $n 32) ("code {0} : {1}" -f $code, (Get-CMErrorText $code)) 'WARN'
    }
}
if ($realBad -eq 0) { Write-Status 'Périphériques en erreur' 'aucun' 'OK' }

# ==================================================================
# [05] BLUETOOTH
# ==================================================================
Write-Section '05' 'Bluetooth'

$svc = Get-Service bthserv
$hasBtRadio = [bool](Get-PnpDevice -Class Bluetooth -PresentOnly | Where-Object { $_.InstanceId -like 'USB\*' -or $_.InstanceId -like 'PCI\*' })
if ($svc -and $svc.Status -eq 'Running') { Write-Status 'Service Bluetooth (bthserv)' 'en cours' 'OK' }
elseif ($svc -and $hasBtRadio) { Write-Status 'Service Bluetooth (bthserv)' ([string]$svc.Status) 'FAIL' }
elseif ($svc) { Write-Status 'Service Bluetooth (bthserv)' ([string]$svc.Status) 'INFO' }
else { Write-Status 'Service Bluetooth (bthserv)' 'introuvable' 'INFO' }

$radio = Get-PnpDevice -Class Bluetooth -PresentOnly | Where-Object { $_.InstanceId -like 'USB\*' -or $_.InstanceId -like 'PCI\*' } | Select-Object -First 1
if ($radio) {
    if ($radio.Status -eq 'OK') { Write-Status 'Adaptateur' $radio.FriendlyName 'OK' }
    else { Write-Status 'Adaptateur' ("{0} : {1}" -f $radio.FriendlyName, $radio.Status) 'FAIL' }

    $pm = Get-CimInstance -Namespace root\wmi -ClassName MSPower_DeviceEnable |
          Where-Object { $_.InstanceName -like ($radio.InstanceId + '*') } | Select-Object -First 1
    if ($null -eq $pm) {
        $why = 'illisible sans droits admin'
        if ($isAdmin) { $why = 'non disponible' }
        Write-Status 'Économie d''énergie adaptateur' $why 'INFO'
    } elseif ($pm.Enable) {
        Write-Status 'Économie d''énergie adaptateur' 'activée (peut gêner la reconnexion)' 'WARN'
        Write-Sub 'Gestionnaire de périphériques > adaptateur > Gestion de l''alimentation'
    } else {
        Write-Status 'Économie d''énergie adaptateur' 'désactivée' 'OK'
    }
} else {
    Write-Status 'Adaptateur' 'aucun adaptateur Bluetooth sur cette machine' 'INFO'
}

if ($radio) {
    $pl = Get-Process PhoneExperienceHost
    if ($pl) { Write-Status 'Mobile connecté' 'actif' 'INFO' }
    else { Write-Status 'Mobile connecté' 'non lancé' 'INFO' }
}

# ==================================================================
# [06] SÉCURITÉ
# ==================================================================
Write-Section '06' 'Sécurité'

# Antivirus déclarés au Centre de sécurité Windows (Defender ou tiers)
$avOther = @()
$avs = @(Get-CimInstance -Namespace root/SecurityCenter2 -ClassName AntiVirusProduct)
foreach ($av in $avs) {
    if ($av.displayName -match 'Defender') { continue }
    $st  = Get-AvState $av.productState
    $on  = $st.On
    $upd = $st.UpToDate
    if ($on) { $avOther += $av.displayName }
    if (-not $on) { Write-Status ('Antivirus ' + $av.displayName) 'installé mais inactif' 'WARN' }
    elseif ($upd) { Write-Status ('Antivirus ' + $av.displayName) 'actif, à jour' 'OK' }
    else { Write-Status ('Antivirus ' + $av.displayName) 'actif, signatures obsolètes' 'FAIL' }
}

$mp = Get-MpComputerStatus
if ($mp -and -not $mp.RealTimeProtectionEnabled -and $avOther.Count -gt 0) {
    Write-Status 'Microsoft Defender' ('en retrait, remplacé par ' + ($avOther -join ', ')) 'INFO'
} elseif ($mp) {
    if ($mp.RealTimeProtectionEnabled) { Write-Status 'Defender temps réel' 'actif' 'OK' }
    else { Write-Status 'Defender temps réel' 'inactif' 'FAIL' }
    $sig = [int]$mp.AntivirusSignatureAge
    $sigTxt = "v{0}  (âge {1} j)" -f $mp.AntivirusSignatureVersion, $sig
    if ($sig -gt 7) { Write-Status 'Signatures antivirus' $sigTxt 'FAIL' }
    elseif ($sig -gt 1) { Write-Status 'Signatures antivirus' $sigTxt 'WARN' }
    else { Write-Status 'Signatures antivirus' $sigTxt 'OK' }
    if ($null -ne $mp.QuickScanAge -and $mp.QuickScanAge -lt 4294967295) {
        $qs = [int]$mp.QuickScanAge
        if ($qs -gt 14) { Write-Status 'Dernière analyse rapide' "il y a $qs j" 'WARN' }
        else { Write-Status 'Dernière analyse rapide' "il y a $qs j" 'OK' }
    }
} else {
    if ($avOther.Count -eq 0 -and $avs.Count -eq 0) {
        Write-Status 'Antivirus' 'aucun antivirus détecté' 'FAIL'
    } else {
        Write-Status 'Microsoft Defender' 'statut indisponible' 'INFO'
    }
}

$fw = @(Get-NetFirewallProfile)
if ($fw.Count -gt 0) {
    $off = @($fw | Where-Object { -not $_.Enabled } | ForEach-Object { $_.Name })
    if ($off.Count -eq 0) { Write-Status 'Pare-feu' 'actif sur tous les profils' 'OK' }
    else { Write-Status 'Pare-feu' ('désactivé : ' + ($off -join ', ')) 'FAIL' }
}

if ($isAdmin) {
    try {
        $sb = Confirm-SecureBootUEFI -ErrorAction Stop
        if ($sb) { Write-Status 'Secure Boot' 'actif' 'OK' }
        else { Write-Status 'Secure Boot' 'désactivé' 'WARN' }
    } catch { Write-Status 'Secure Boot' 'non vérifiable (BIOS legacy ?)' 'INFO' }

    $tpm = Get-Tpm
    if ($tpm) {
        if ($tpm.TpmPresent -and $tpm.TpmReady) { Write-Status 'TPM' 'présent et prêt' 'OK' }
        elseif ($tpm.TpmPresent) { Write-Status 'TPM' 'présent mais non prêt' 'WARN' }
        else { Write-Status 'TPM' 'absent ou désactivé dans le BIOS' 'WARN' }
    }

    $rp = Get-ComputerRestorePoint | Sort-Object SequenceNumber -Descending | Select-Object -First 1
    if ($rp) {
        $rpDate = $null
        try { $rpDate = [Management.ManagementDateTimeConverter]::ToDateTime($rp.CreationTime) } catch {}
        $rpAge = 0
        if ($rpDate) { $rpAge = ((Get-Date) - $rpDate).Days }
        $rpTxt = "{0} (il y a {1} j)" -f (Format-Date $rpDate), $rpAge
        if ($rpAge -gt 30) { Write-Status 'Dernier point de restauration' $rpTxt 'WARN' }
        else { Write-Status 'Dernier point de restauration' $rpTxt 'OK' }
    } else {
        Write-Status 'Point de restauration' 'aucun' 'INFO'
        Write-Sub 'Protection système désactivée ou jamais utilisée (sysdm.cpl > Protection du système)'
    }
} else {
    Write-Status 'Secure Boot / TPM / restauration' 'nécessite les droits admin' 'INFO'
}

# ==================================================================
# [07] STOCKAGE
# ==================================================================
Write-Section '07' 'Stockage'

$vols = @(Get-Volume | Where-Object { $_.DriveLetter -and $_.DriveType -eq 'Fixed' -and $_.Size -gt 0 } | Sort-Object DriveLetter)
foreach ($v in $vols) {
    $pct = [math]::Round(($v.SizeRemaining / $v.Size) * 100, 0)
    $txt = "{0}  {1,3}% libre  ({2:N0} / {3:N0} Go)" -f (Get-MiniBar (100 - $pct)), $pct, ($v.SizeRemaining / 1GB), ($v.Size / 1GB)
    $label = "Volume {0}: {1}" -f $v.DriveLetter, $v.FileSystemLabel
    if ($pct -lt 10) { Write-Status $label $txt 'FAIL' }
    elseif ($pct -lt 20) { Write-Status $label $txt 'WARN' }
    else { Write-Status $label $txt 'OK' }
}

$disks = @(Get-PhysicalDisk)
foreach ($d in $disks) {
    $txt = "{0}  {1:N0} Go  santé : {2}" -f $d.MediaType, ($d.Size / 1GB), $d.HealthStatus
    $state = 'FAIL'
    if ($d.HealthStatus -eq 'Healthy') { $state = 'OK' }
    elseif ($d.HealthStatus -eq 'Warning') { $state = 'WARN' }

    $rc = $null
    if ($isAdmin) { $rc = $d | Get-StorageReliabilityCounter }
    $extra = @()
    if ($rc) {
        if ($rc.Temperature -gt 0) {
            $extra += ('{0} °C' -f $rc.Temperature)
            if ($rc.Temperature -ge 65 -and $state -eq 'OK') { $state = 'WARN' }
        }
        if ($null -ne $rc.Wear) {
            $extra += ('usure {0}%' -f $rc.Wear)
            if ($rc.Wear -ge 80 -and $state -eq 'OK') { $state = 'WARN' }
        }
        if ($rc.PowerOnHours -gt 0) { $extra += ('{0:N0} h allumé' -f $rc.PowerOnHours) }
        if ($rc.ReadErrorsUncorrected -gt 0) {
            $extra += ('{0} erreurs de lecture' -f $rc.ReadErrorsUncorrected)
            $state = 'FAIL'
        }
    }
    Write-Status (Cut $d.FriendlyName 32) $txt $state
    if ($extra.Count -gt 0) { Write-Sub ($extra -join '  //  ') }
}

if ($isAdmin -and (Get-Command Get-BitLockerVolume -ErrorAction SilentlyContinue)) {
    $bl = Get-BitLockerVolume -MountPoint $env:SystemDrive
    if ($bl) {
        $blTxt = 'non chiffré'
        if ([string]$bl.ProtectionStatus -eq 'On') { $blTxt = 'chiffré et protégé' }
        elseif ([string]$bl.VolumeStatus -ne 'FullyDecrypted') { $blTxt = ('chiffré, protection suspendue ({0})' -f $bl.VolumeStatus) }
        Write-Status ('BitLocker ' + $env:SystemDrive) $blTxt 'INFO'
    }
}

# ==================================================================
# [08] RESSOURCES
# ==================================================================
Write-Section '08' 'Ressources'

$cpus = @(Get-CimInstance Win32_Processor)
if ($cpus.Count -gt 0) {
    Write-Status 'Processeur' (Cut ($cpus[0].Name.Trim()) 45) 'INFO'
    $load = [math]::Round(($cpus | Measure-Object -Property LoadPercentage -Average).Average)
    $txt = "{0}  {1}%" -f (Get-MiniBar $load), $load
    if ($load -gt 85) { Write-Status 'Charge CPU' $txt 'WARN' } else { Write-Status 'Charge CPU' $txt 'OK' }
}

$os = Get-CimInstance Win32_OperatingSystem
$totGB = $os.TotalVisibleMemorySize / 1MB
$freeGB = $os.FreePhysicalMemory / 1MB
$usedPct = [math]::Round((1 - ($freeGB / $totGB)) * 100)
$txt = "{0}  {1}%  ({2:N1} / {3:N1} Go)" -f (Get-MiniBar $usedPct), $usedPct, ($totGB - $freeGB), $totGB
if ($usedPct -gt 90) { Write-Status 'Mémoire vive' $txt 'WARN' } else { Write-Status 'Mémoire vive' $txt 'OK' }

$top = Get-Process | Group-Object ProcessName | ForEach-Object {
    [pscustomobject]@{ Name = $_.Name; MB = [math]::Round((($_.Group | Measure-Object WorkingSet64 -Sum).Sum) / 1MB) }
} | Sort-Object MB -Descending | Select-Object -First 5
foreach ($p in $top) { Write-Sub ("{0,-30} {1,7:N0} Mo" -f (Cut $p.Name 30), $p.MB) }

$plan = (powercfg /getactivescheme) -join ' '
if ($plan -match '\(([^)]+)\)') { Write-Status 'Mode d''alimentation' $Matches[1] 'INFO' }

if ($isLaptop) {
    $bat = Get-CimInstance Win32_Battery | Select-Object -First 1
    $src = 'sur batterie'
    if ($bat.BatteryStatus -eq 2) { $src = 'sur secteur' }
    Write-Status 'Batterie' ('{0}%  //  {1}' -f $bat.EstimatedChargeRemaining, $src) 'INFO'
    $full   = (Get-CimInstance -Namespace root\wmi -ClassName BatteryFullChargedCapacity | Select-Object -First 1).FullChargedCapacity
    $design = (Get-CimInstance -Namespace root\wmi -ClassName BatteryStaticData | Select-Object -First 1).DesignedCapacity
    if ($full -and $design) {
        $health = [math]::Round(($full / $design) * 100)
        if ($health -gt 100) { $health = 100 }
        $txt = '{0}  {1}% de la capacité d''origine' -f (Get-MiniBar $health), $health
        if ($health -lt 60) { Write-Status 'Santé batterie' $txt 'FAIL' }
        elseif ($health -lt 80) { Write-Status 'Santé batterie' $txt 'WARN' }
        else { Write-Status 'Santé batterie' $txt 'OK' }
        Write-Sub ('{0:N0} mWh / {1:N0} mWh d''origine' -f $full, $design)
    } elseif (-not $isAdmin) {
        Write-Status 'Santé batterie' 'nécessite les droits admin' 'INFO'
    }
}

$startup = @(Get-CimInstance Win32_StartupCommand)
if ($startup.Count -gt 15) { Write-Status 'Programmes au démarrage' ("{0} (beaucoup)" -f $startup.Count) 'WARN' }
else { Write-Status 'Programmes au démarrage' ([string]$startup.Count) 'OK' }

# ==================================================================
# [09] RÉSEAU
# ==================================================================
Write-Section '09' 'Réseau'

$ups = @(Get-NetAdapter | Where-Object { $_.Status -eq 'Up' -and -not $_.Virtual })
foreach ($n in $ups) { Write-Status (Cut $n.Name 32) ("{0}  //  {1}" -f $n.LinkSpeed, (Cut $n.InterfaceDescription 34)) 'INFO' }

$gw = (Get-NetRoute -DestinationPrefix '0.0.0.0/0' | Sort-Object RouteMetric | Select-Object -First 1).NextHop
if ($gw) {
    if (Test-Connection -ComputerName $gw -Count 2 -Quiet) { Write-Status 'Passerelle' "$gw joignable" 'OK' }
    else { Write-Status 'Passerelle' "$gw injoignable" 'FAIL' }
}

$ping = @(Test-Connection -ComputerName 1.1.1.1 -Count 4)
if ($ping.Count -gt 0) {
    $prop = 'ResponseTime'
    if (-not $ping[0].PSObject.Properties['ResponseTime']) { $prop = 'Latency' }
    $avg = [math]::Round(($ping | Measure-Object -Property $prop -Average).Average)
    $loss = 100 - [math]::Round(($ping.Count / 4) * 100)
    $txt = "{0} ms en moyenne  //  perte {1}%" -f $avg, $loss
    if ($avg -gt 80 -or $loss -gt 0) { Write-Status 'Latence Internet (1.1.1.1)' $txt 'WARN' }
    else { Write-Status 'Latence Internet (1.1.1.1)' $txt 'OK' }
} else {
    Write-Status 'Accès Internet (1.1.1.1)' 'aucune réponse' 'FAIL'
}

$dnsOk = $false
$dnsMs = (Measure-Command { $dnsOk = [bool](Resolve-DnsName 'www.microsoft.com' -DnsOnly -QuickTimeout) }).TotalMilliseconds
if ($dnsOk) { Write-Status 'Résolution DNS' ("{0:N0} ms" -f $dnsMs) 'OK' }
else { Write-Status 'Résolution DNS' 'échec' 'FAIL' }

# ==================================================================
# [10] JOURNAUX D'ÉVÉNEMENTS (7 jours)
# ==================================================================
Write-Section '10' 'Journaux d''événements (7 jours)'

$since = (Get-Date).AddDays(-7)
$sysErr = @(Get-WinEvent -FilterHashtable @{ LogName = 'System'; Level = 1, 2; StartTime = $since })

$kp = @($sysErr | Where-Object { $_.ProviderName -eq 'Microsoft-Windows-Kernel-Power' -and $_.Id -eq 41 }).Count
if ($kp -gt 0) { Write-Status 'Arrêts brutaux (Kernel-Power 41)' ([string]$kp) 'WARN' }
else { Write-Status 'Arrêts brutaux (Kernel-Power 41)' '0' 'OK' }

$bsod = @(Get-WinEvent -FilterHashtable @{ LogName = 'System'; ProviderName = 'Microsoft-Windows-WER-SystemErrorReporting'; Id = 1001; StartTime = $since }).Count
if ($bsod -gt 0) { Write-Status 'Écrans bleus (BugCheck)' ([string]$bsod) 'FAIL' }
else { Write-Status 'Écrans bleus (BugCheck)' '0' 'OK' }

$whea = @(Get-WinEvent -FilterHashtable @{ LogName = 'System'; ProviderName = 'Microsoft-Windows-WHEA-Logger'; StartTime = $since }).Count
if ($whea -gt 0) { Write-Status 'Erreurs matérielles (WHEA)' ([string]$whea) 'WARN' }
else { Write-Status 'Erreurs matérielles (WHEA)' '0' 'OK' }

$diskErr = @($sysErr | Where-Object { $_.ProviderName -in 'disk', 'Ntfs', 'stornvme', 'storahci', 'Microsoft-Windows-Ntfs' }).Count
if ($diskErr -gt 0) { Write-Status 'Erreurs disque / NTFS' ([string]$diskErr) 'WARN' }
else { Write-Status 'Erreurs disque / NTFS' '0' 'OK' }

Write-Status 'Erreurs système (total)' ([string]$sysErr.Count) 'INFO'
$topErr = $sysErr | Group-Object ProviderName | Sort-Object Count -Descending | Select-Object -First 3
foreach ($t in $topErr) { Write-Sub ("{0,-40} {1,4}" -f (Cut $t.Name 40), $t.Count) }

# ==================================================================
# [11] NETTOYAGE
# ==================================================================
Write-Section '11' 'Nettoyage'

$tUser = Get-FolderSizeMB $env:TEMP
if (-not (Test-SafeTempPath $env:TEMP)) {
    Write-Status 'Variable %TEMP% anormale' (Cut $env:TEMP 40) 'WARN'
    Write-Sub 'Nettoyage désactivé pour ce dossier par sécurité'
    $tUser = 0
}
$tWin  = Get-FolderSizeMB (Join-Path $env:windir 'Temp')
$tWU   = Get-FolderSizeMB (Join-Path $env:windir 'SoftwareDistribution\Download')
$rbMB  = 0
try {
    $shell = New-Object -ComObject Shell.Application
    $rbSum = ($shell.Namespace(10).Items() | Measure-Object -Property Size -Sum).Sum
    if ($rbSum) { $rbMB = [math]::Round($rbSum / 1MB) }
} catch {}

Write-Status 'Temp utilisateur (%TEMP%)' ("{0:N0} Mo" -f $tUser) 'INFO'
Write-Status 'Temp Windows' ("{0:N0} Mo" -f $tWin) 'INFO'
Write-Status 'Cache Windows Update' ("{0:N0} Mo" -f $tWU) 'INFO'
Write-Status 'Corbeille' ("{0:N0} Mo" -f $rbMB) 'INFO'
$script:TempMB = $tUser + $tWin
$all = $tUser + $tWin + $tWU + $rbMB
if ($all -gt 5120) { Write-Status 'Espace récupérable' ("{0:N1} Go" -f ($all / 1024)) 'WARN' }
else { Write-Status 'Espace récupérable' ("{0:N1} Go" -f ($all / 1024)) 'OK' }

# ==================================================================
# [12] BIOS
# ==================================================================
Write-Section '12' 'BIOS / carte mère'

$board = Get-CimInstance Win32_BaseBoard
$bios  = Get-CimInstance Win32_BIOS
Write-Status 'Carte mère' ("{0} {1}" -f $board.Manufacturer, $board.Product) 'INFO'
$bAge = 0
try { $bAge = ((Get-Date) - $bios.ReleaseDate).Days } catch {}
$bTxt = "{0}  ({1})" -f $bios.SMBIOSBIOSVersion, (Format-Date $bios.ReleaseDate)
if ($bAge -gt 365) { Write-Status 'Version BIOS' "$bTxt  (> 1 an)" 'WARN' }
else { Write-Status 'Version BIOS' $bTxt 'OK' }
Write-Sub ("Dernière version : site du fabricant > Support > {0}" -f $board.Product)

# ==================================================================
# [13] INTÉGRITÉ WINDOWS (mode complet)
# ==================================================================
if ($script:DeepMode) {
    Write-Section '13' 'Intégrité Windows (DISM / SFC / CHKDSK)'
    Write-Host '   Ces analyses sont longues. Ne ferme pas la fenêtre.' -ForegroundColor DarkGray

    # --- DISM : état du magasin de composants
    $dism = Invoke-ProcessSpinner -Label 'DISM /ScanHealth (5-20 min)' `
            -FilePath (Join-Path $env:windir 'System32\dism.exe') `
            -Arguments '/Online /Cleanup-Image /ScanHealth' -TimeoutSec 2400 -Encoding 'Oem'

    $dv = $null
    if ($dism) { $dv = Get-DismVerdict $dism.Text $dism.Code }
    if ($null -eq $dism) {
        Write-Status 'DISM ScanHealth' 'délai dépassé (40 min)' 'WARN'
    } elseif ($dv -eq 'CLEAN') {
        Write-Status 'DISM ScanHealth' 'magasin de composants sain' 'OK'
    } elseif ($dv -eq 'UNREPAIRABLE') {
        Write-Status 'DISM ScanHealth' 'corruption NON réparable' 'FAIL'
        Write-Sub 'Réparation de Windows conseillée (réinstallation sur place)'
    } elseif ($dv -eq 'REPAIRABLE') {
        Write-Status 'DISM ScanHealth' 'corruption réparable détectée' 'WARN'
        $script:NeedRestore = $true
    } elseif ($dv -eq 'ERROR') {
        Write-Status 'DISM ScanHealth' ("code de sortie {0}" -f $dism.Code) 'WARN'
        Write-Sub 'Détails : C:\Windows\Logs\DISM\dism.log'
    } else {
        Write-Status 'DISM ScanHealth' 'terminé sans anomalie' 'OK'
    }

    # --- SFC /scannow
    $sfcExe = Get-SfcPath
    $sfc = Invoke-ProcessSpinner -Label 'SFC /scannow (5-20 min)' -FilePath $sfcExe `
           -Arguments '/scannow' -TimeoutSec 3600 -Encoding 'Auto'

    if ($null -eq $sfc) {
        Write-Status 'SFC /scannow' 'délai dépassé (60 min)' 'WARN'
    } else {
        $sv = Get-SfcVerdict $sfc.Text
        if ($sv -eq 'CLEAN') {
            Write-Status 'SFC /scannow' 'aucune violation d''intégrité' 'OK'
        } elseif ($sv -eq 'NORUN') {
            Write-Status 'SFC /scannow' 'n''a pas pu s''exécuter' 'WARN'
            Write-Sub 'Relancer après redémarrage, ou en mode sans échec'
        } elseif ($sv -eq 'UNFIXED') {
            Write-Status 'SFC /scannow' 'fichiers corrompus NON réparés' 'FAIL'
            $script:NeedRestore = $true
        } elseif ($sv -eq 'REPAIRED') {
            Write-Status 'SFC /scannow' 'fichiers corrompus trouvés et réparés' 'WARN'
            Write-Sub 'Redémarrage conseillé'
        } else {
            Write-Status 'SFC /scannow' 'résultat non reconnu' 'INFO'
            Write-Sub 'Détails : C:\Windows\Logs\CBS\CBS.log'
        }
    }

    # --- CHKDSK /scan (analyse en ligne, sans démontage)
    $ntfs = @(Get-Volume | Where-Object { $_.DriveLetter -and $_.DriveType -eq 'Fixed' -and $_.FileSystem -eq 'NTFS' } | Sort-Object DriveLetter)
    foreach ($v in $ntfs) {
        $L = [string]$v.DriveLetter
        $ck = Invoke-ProcessSpinner -Label ("CHKDSK {0}: /scan" -f $L) `
              -FilePath (Join-Path $env:windir 'System32\chkdsk.exe') `
              -Arguments ("{0}: /scan" -f $L) -TimeoutSec 3600 -Encoding 'Oem'
        $code = $null
        if ($ck) { $code = $ck.Code }

        $lbl = "CHKDSK {0}:" -f $L
        if ($null -eq $code) { Write-Status $lbl 'délai dépassé' 'WARN' }
        elseif ((Get-ChkdskVerdict $code) -eq 'CLEAN') { Write-Status $lbl 'aucune erreur' 'OK' }
        elseif ((Get-ChkdskVerdict $code) -eq 'FIXED') { Write-Status $lbl 'erreurs trouvées et corrigées' 'WARN' }
        elseif ((Get-ChkdskVerdict $code) -eq 'MINOR') { Write-Status $lbl 'nettoyage mineur nécessaire' 'INFO' }
        else {
            Write-Status $lbl 'erreurs détectées, correction nécessaire' 'FAIL'
            $script:ChkdskFix.Add($L)
        }
    }
}

# ==================================================================
# SYNTHÈSE
# ==================================================================
$total = $script:Ok + $script:Warnings.Count + $script:Alerts.Count
$score = 0
if ($total -gt 0) { $score = [math]::Round(($script:Ok / $total) * 100) }
$scoreColor = 'Green'
if ($script:Alerts.Count -gt 0) { $scoreColor = 'Red' }
elseif ($score -lt 80) { $scoreColor = 'Yellow' }

Write-Host ''
Write-Host ('  ╔' + ('═' * 64) + '╗') -ForegroundColor Cyan
Write-Host '  ║' -NoNewline -ForegroundColor Cyan
Write-Host ('  SYNTHÈSE DU DIAGNOSTIC'.PadRight(64)) -NoNewline -ForegroundColor White
Write-Host '║' -ForegroundColor Cyan
Write-Host ('  ╚' + ('═' * 64) + '╝') -ForegroundColor Cyan

Write-Host '   Intégrité système  [' -NoNewline -ForegroundColor Gray
$filled = [math]::Round($score / 2.5)
Write-Host ('█' * $filled) -NoNewline -ForegroundColor $scoreColor
Write-Host ('░' * (40 - $filled)) -NoNewline -ForegroundColor DarkGray
Write-Host ("] {0}%" -f $score) -ForegroundColor $scoreColor
Write-Host ("   Contrôles OK : {0}   //   Avertissements : {1}   //   Alertes : {2}" -f $script:Ok, $script:Warnings.Count, $script:Alerts.Count) -ForegroundColor Gray

$script:Report.Add('')
$script:Report.Add('== SYNTHÈSE ==')
$script:Report.Add(("Score {0}% - OK {1} / WARN {2} / FAIL {3}" -f $score, $script:Ok, $script:Warnings.Count, $script:Alerts.Count))

if ($script:Alerts.Count -gt 0) {
    Write-Host ''
    Write-Host '   ALERTES' -ForegroundColor Red
    foreach ($x in $script:Alerts) { Write-Host ('   ! ' + $x) -ForegroundColor Red; $script:Report.Add('! ' + $x) }
}
if ($script:Warnings.Count -gt 0) {
    Write-Host ''
    Write-Host '   POINTS D''ATTENTION' -ForegroundColor Yellow
    foreach ($x in $script:Warnings) { Write-Host ('   - ' + $x) -ForegroundColor Yellow; $script:Report.Add('- ' + $x) }
}

Write-Host ''
if ($script:Alerts.Count -eq 0 -and $script:Warnings.Count -eq 0) {
    Type-Line "   >> Tous les systèmes sont nominaux, $Name." 'Green'
} elseif ($script:Alerts.Count -eq 0) {
    Type-Line "   >> Systèmes opérationnels. Quelques points méritent ton attention, $Name." 'Yellow'
} else {
    Type-Line "   >> Des anomalies demandent une intervention, $Name." 'Red'
}

$repFile = Save-Report 'checkup' ([string[]]$script:Report)

# ------------------------------------------------------------------
# Actions proposées (rien n'est lancé sans réponse "o")
# ------------------------------------------------------------------
Write-Host ''
if ($script:NeedRestore -and $isAdmin) {
    $online = Test-Connection -ComputerName 1.1.1.1 -Count 1 -Quiet
    if (-not $online) { $online = [bool](Resolve-DnsName 'www.microsoft.com' -DnsOnly -QuickTimeout) }
    if (-not $online) {
        Write-Host '   [!] Réparation DISM impossible sans Internet : elle télécharge les fichiers sains depuis Windows Update.' -ForegroundColor Yellow
        Write-Host '       Connecte le PC puis relance le scan complet.' -ForegroundColor Yellow
    } else {
        $a = Read-Answer '   >> Réparer l''image Windows (DISM /RestoreHealth puis SFC, 15-45 min) ? [o/N]'
        if ($a -match '^[oOyY]') {
            Write-Host '   NE FERME PAS CETTE FENÊTRE pendant la réparation.' -ForegroundColor Yellow
            Write-Host ''
                    DISM /Online /Cleanup-Image /RestoreHealth
            sfc /scannow
                }
    }
}
foreach ($L in $script:ChkdskFix) {
    Write-Host ("   >> Volume {0}: correction conseillée : chkdsk {0}: /spotfix" -f $L) -ForegroundColor Yellow
    Write-Host '      (pour le disque système, la correction a lieu au prochain redémarrage)' -ForegroundColor DarkGray
}
if ($script:WGCount -gt 0) {
    Write-Host '   [i] winget peut fermer les applications concernées (navigateur, jeux, messageries) pendant leur mise à jour.' -ForegroundColor DarkGray
    Write-Host '       Enregistre ton travail avant de valider.' -ForegroundColor DarkGray
    $a = Read-Answer ("   >> Mettre à jour les {0} application(s) avec winget ? [o/N]" -f $script:WGCount)
    if ($a -match '^[oOyY]') {
        Write-Host ''
        $okList = @(); $koList = @(); $naList = @()
        $skip = @($script:WGSkipIds)
        $targets = @($script:WGItems | Where-Object { $_.Id })
        if ($targets.Count -eq 0) {
            # Identifiants illisibles : repli sur la mise à jour globale
            winget upgrade --all --accept-source-agreements --accept-package-agreements
        } else {
            foreach ($it in $targets) {
                Write-Host ''
                Write-Host ('   >> Mise à jour de ' + $it.Name) -ForegroundColor Cyan
                & winget upgrade --id $it.Id --exact --accept-source-agreements --accept-package-agreements --disable-interactivity
                $rc = $LASTEXITCODE
                if ($rc -eq 0) { $okList += $it.Name }
                elseif (('{0:X8}' -f $rc) -eq '8A15002B') {
                    # « Aucune mise à niveau applicable » : la nouvelle version ne convient pas à cette installation.
                    # Ce n'est pas une panne : l'application doit se mettre à jour par elle-même.
                    $naList += $it.Name
                    $skip += $it.Id
                } else {
                    $koList += ('{0} : code 0x{1:X8}' -f $it.Name, $rc)
                }
            }
        }
        Write-Host ''
        Write-Host '   >> Vérification du résultat...' -ForegroundColor DarkCyan
        $raw2 = (& winget upgrade --accept-source-agreements --disable-interactivity 2>&1) | Out-String
        $leftAll = @(ConvertFrom-WingetText $raw2)
        $left = @($leftAll | Where-Object { $skip -notcontains $_.Id })
        foreach ($n in $okList) { Write-Host ('   [ OK ] ' + $n) -ForegroundColor Green }
        foreach ($n in $koList) { Write-Host ('   [FAIL] ' + $n) -ForegroundColor Red }
        foreach ($n in $naList) {
            Write-Host ('   [INFO] ' + $n + ' : winget n''a pas de version adaptée à cette installation.') -ForegroundColor Cyan
            Write-Host '          Mets-la à jour depuis l''application elle-même (souvent automatique à son ouverture).' -ForegroundColor DarkGray
        }
        if ($left.Count -gt 0) {
            Write-Host ("   [!] {0} application(s) toujours en retard :" -f $left.Count) -ForegroundColor Yellow
            foreach ($l in $left) { Write-Host ('       - ' + (Cut $l.Name 60) + '  ' + $l.Installed + ' -> ' + $l.Available) -ForegroundColor Yellow }
            Write-Host '       Cause fréquente : l''application était ouverte pendant la mise à jour.' -ForegroundColor DarkGray
            Write-Host '       Ferme-la puis relance JARVIS, ou mets-la à jour depuis l''application.' -ForegroundColor DarkGray
        } elseif ($leftAll.Count -gt 0) {
            # Seules restent des applications que winget refuse de mettre à jour (signalées ci-dessus)
            Write-Host '   >> Vérifié : tout ce que winget peut mettre à jour est à jour.' -ForegroundColor Green
        } elseif (Test-WingetNoUpgrade $raw2) {
            Write-Host '   >> Vérifié : toutes les applications sont à jour.' -ForegroundColor Green
        } else {
            # Ni liste lisible, ni message « aucune mise à jour » : on ne conclut pas
            Write-Host '   [!] Vérification impossible : la réponse de winget n''a pas pu être lue.' -ForegroundColor Yellow
            Write-Host '       Relance un scan pour contrôler.' -ForegroundColor DarkGray
        }
    }
}
if ($script:WUCount -eq 0 -and $script:WUManual -gt 0) {
    Write-Host ''
    Write-Host ("   {0} mise(s) à jour Windows demandent une action à l'écran (souvent des pilotes de périphériques)." -f $script:WUManual) -ForegroundColor Cyan
    $a = Read-Answer '   >> Ouvrir Windows Update avec le mode d''emploi ? [o/N]'
    if ($a -match '^[oOyY]') { Open-WindowsUpdateGuided }
}
if ($script:WUCount -gt 0) {
    Write-Host ''
    Write-Host ("   MISES À JOUR WINDOWS : {0} en attente" -f $script:WUCount) -ForegroundColor Cyan
    $wkeys = @()
    if ($isAdmin) {
        Write-Host '   [1] Les installer maintenant avec J.A.R.V.I.S. (recommandé, tout est automatique)' -ForegroundColor Gray
        $wkeys += '1'
    }
    Write-Host '   [2] Ouvrir Windows Update, avec le mode d''emploi' -ForegroundColor Gray
    Write-Host '   [N] Plus tard' -ForegroundColor Gray
    $wkeys += '2'; $wkeys += 'N'
    $a = Read-Answer ('   >> Choix [' + ($wkeys -join '/') + ']')
    if ($a -eq '1' -and $isAdmin) { Install-WindowsUpdates }
    elseif ($a -eq '2') { Open-WindowsUpdateGuided }
}
if ($script:TempMB -gt 500) {
    $a = Read-Answer ("   >> Nettoyer les fichiers temporaires de plus de 24 h ({0:N0} Mo au total) ? [o/N]" -f $script:TempMB)
    if ($a -match '^[oOyY]') {
        $tot = 0
        foreach ($p in @($env:TEMP, (Join-Path $env:windir 'Temp'))) {
            $r = Clear-TempFolder $p 24
            if ($r.Ok) { $tot += $r.FreedMB } else { Write-Host ('   [!] ' + $r.Reason) -ForegroundColor Yellow }
        }
        Write-Host ("   >> {0:N0} Mo libérés (fichiers récents ou verrouillés conservés)." -f $tot) -ForegroundColor Green
    }
}

if ($repFile) {
    $a = Read-Answer '   >> Ouvrir le rapport ? [o/N]'
    if ($a -match '^[oOyY]') { Start-Process -FilePath 'notepad.exe' -ArgumentList ('"{0}"' -f $repFile) }
}

$null = Set-NoSleep $false
Write-Host ''
Type-Line '   >> Fin de session. J.A.R.V.I.S. se met en veille.' 'DarkCyan'
Read-Answer '   [Entrée pour fermer]' | Out-Null
} finally {
    try { [Console]::TreatControlCAsInput = $false } catch {}
    $null = Set-NoSleep $false
    if ($script:JarvisMutex) { try { $script:JarvisMutex.ReleaseMutex() } catch {} }
}
