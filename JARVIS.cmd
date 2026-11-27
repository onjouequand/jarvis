<# : JARVIS.cmd. Ne pas modifier ce texte
@echo off
rem JARVIS-SHA256=8a101a46f511594bc163ab79bcc3ef417f3fa659cbdb7700f3d698a1c0a4b829
setlocal
"%SystemRoot%\System32\chcp.com" 65001 >nul
set "JARVIS_SELF=%~f0"
set "JARVIS_ARGS=%*"
"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -ExecutionPolicy Bypass -Command "if ($ExecutionContext.SessionState.LanguageMode -ne 'FullLanguage') { Write-Host 'PowerShell est en mode restreint sur ce PC (Controle intelligent des applications ou strategie d entreprise) : JARVIS ne peut pas fonctionner ici.' -ForegroundColor Red; exit 4 }; $t = [IO.File]::ReadAllText($env:JARVIS_SELF); $e = $t.IndexOf([string][char]10 + '#' + '>'); $b = $t.Substring($e + 3); $h = -join ([Security.Cryptography.SHA256]::Create().ComputeHash([Text.Encoding]::UTF8.GetBytes($b)) | %% { $_.ToString('x2') }); if ($e -lt 0 -or $t -notmatch ('JARVIS-SHA256=' + $h)) { Write-Host 'JARVIS.cmd est modifie ou incomplet : telecharge-le a nouveau.' -ForegroundColor Red; exit 3 }; $sb = [ScriptBlock]::Create($t); & $sb # options lues par JARVIS, sans execution"
set "JARVIS_RC=%errorlevel%"
if "%JARVIS_RC%"=="3" pause
if "%JARVIS_RC%"=="4" pause
exit /b %JARVIS_RC%
#>
<#
    J.A.R.V.I.S. // Check-up système v3.28
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
      [11] Nettoyage      : temporaires, corbeille, caches de Windows Update, vidages
                            mémoire, composants Windows (mode complet), Windows.old
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
    [string]$Name = '',
    # Interne : place et taille de la fenêtre d'avant une relance de cette même version (Format-WinRect)
    [string]$WinRect = ''
)

# ------------------------------------------------------------------
# Démarrage sûr (v3.24, audit du 23/11/2026, constats S1 et S2)
# Ce bloc passe avant toute commande qui charge un module : seulement du .NET et le langage.
# ------------------------------------------------------------------
# Noms des options du bloc param ci-dessus : tools\check.ps1 vérifie que les deux listes sont identiques
$JarvisSwitchArgs = @('Quick', 'Deep', 'NoAnim', 'NoWinget', 'NoElevate', 'ResetName', 'ResetChoices', 'Ascii',
                      'SelfTest', 'Install', 'Uninstall', 'Update')
$JarvisStringArgs = @('InstallDir', 'Name', 'WinRect')

function Get-ProgramFilesDir {
    # « Program Files » 64 bits, demandé à Windows (jamais $env:ProgramW6432, qu'un programme du compte peut redéfinir,
    # constat S3) ; console 32 bits : lu dans le registre en vue 64 bits. Seulement du .NET : appelée avant
    # la réduction des dossiers de modules.
    $p = $null
    if ([Environment]::Is64BitProcess -or -not [Environment]::Is64BitOperatingSystem) { $p = [Environment]::GetFolderPath('ProgramFiles') }
    else {
        try {
            $hk = [Microsoft.Win32.RegistryKey]::OpenBaseKey([Microsoft.Win32.RegistryHive]::LocalMachine, [Microsoft.Win32.RegistryView]::Registry64)
            $p = [string]$hk.OpenSubKey('SOFTWARE\Microsoft\Windows\CurrentVersion').GetValue('ProgramFilesDir')
        } catch { $p = $null }
    }
    if (-not $p) { $p = $env:ProgramW6432 }
    if (-not $p) { $p = $env:ProgramFiles }
    return $p
}

function Get-SafeModulePath([string]$WinDir, [string[]]$ProgramFiles) {
    # Dossiers de modules PowerShell gardés : seulement ceux installés avec Windows PowerShell, que seul un
    # administrateur peut modifier : <Program Files>\WindowsPowerShell\Modules (64 et 32 bits) et
    # <Windows>\System32\WindowsPowerShell\v1.0\Modules. Tout le reste est retiré : le dossier Documents, ajouté d'office
    # par PowerShell, où un programme du compte pouvait poser un module du même nom qu'un module de Windows (même
    # Microsoft.PowerShell.Utility, qui fournit New-Object : vérifié le 23/11/2026), et tout autre dossier, car le compte
    # peut redéfinir PSModulePath (HKCU\Environment) et certains dossiers sous Windows lui sont ouverts en écriture
    # (C:\Windows\tracing, vérifié le 23/11/2026). Seulement du langage, aucune commande de module. Fonction pure, T1.
    $keep = [System.Collections.Generic.List[string]]::new()
    foreach ($d in @($ProgramFiles)) {
        if (-not $d) { continue }
        $m = ([string]$d).TrimEnd('\') + '\WindowsPowerShell\Modules'
        if (-not ($keep -contains $m)) { $keep.Add($m) }
    }
    if ($WinDir) { $keep.Add(([string]$WinDir).TrimEnd('\') + '\System32\WindowsPowerShell\v1.0\Modules') }
    return ($keep.ToArray() -join ';')
}

function ConvertFrom-JarvisArgLine {
    # Options de JARVIS.cmd lues dans le texte brut transmis par l'en-tête (variable JARVIS_ARGS), sans jamais
    # l'exécuter. Jusqu'à la v3.23, l'en-tête le passait à Invoke-Expression : « -InstallDir "C:\x$(commande)" »,
    # retransmis entre guillemets à la relance en administrateur, y faisait exécuter la commande (constat S1).
    # Mots séparés par des espaces ; "..." ou '...' gardent les espaces, le texte est pris tel quel. -Nom : nom exact,
    # ou début sans ambiguïté comme PowerShell. Ok : tout est compris ; Values : nom -> valeur ; Bad : premier mot
    # refusé (les options sont alors toutes ignorées). Fonction pure, T1.
    param([string]$Line, [string[]]$Switches, [string[]]$Strings)
    $r = [pscustomobject]@{ Ok = $false; Values = @{}; Bad = '' }
    $words = [System.Collections.Generic.List[object]]::new()
    $s = [string]$Line
    $i = 0
    while ($i -lt $s.Length) {
        $c = [string]$s[$i]
        if ($c -eq ' ' -or $c -eq "`t") { $i++; continue }
        if ($c -eq '"' -or $c -eq "'") {
            $end = $s.IndexOf($c, $i + 1)
            if ($end -lt 0) { $r.Bad = $s.Substring($i); return $r }
            $words.Add([pscustomobject]@{ Text = $s.Substring($i + 1, $end - $i - 1); Quoted = $true })
            $i = $end + 1
            if ($i -lt $s.Length -and [string]$s[$i] -ne ' ' -and [string]$s[$i] -ne "`t") { $r.Bad = $s.Substring($i); return $r }
            continue
        }
        $end = $i
        while ($end -lt $s.Length -and [string]$s[$end] -ne ' ' -and [string]$s[$end] -ne "`t") { $end++ }
        $w = $s.Substring($i, $end - $i)
        if ($w.IndexOf('"') -ge 0 -or $w.IndexOf("'") -ge 0) { $r.Bad = $w; return $r }
        $words.Add([pscustomobject]@{ Text = $w; Quoted = $false })
        $i = $end
    }
    $all = @($Switches) + @($Strings)
    $k = 0
    while ($k -lt $words.Count) {
        $w = $words[$k]
        if ($w.Quoted -or $w.Text -notmatch '^-[A-Za-z]+$') { $r.Bad = $w.Text; return $r }
        $p = $w.Text.Substring(1)
        $hit = @($all | Where-Object { $_ -eq $p })
        if ($hit.Count -eq 0) { $hit = @($all | Where-Object { $_.StartsWith($p, [StringComparison]::OrdinalIgnoreCase) }) }
        if ($hit.Count -ne 1 -or $r.Values.ContainsKey($hit[0])) { $r.Bad = $w.Text; return $r }
        $n = $hit[0]
        if ($Switches -contains $n) { $r.Values[$n] = $true; $k++; continue }
        if ($k + 1 -ge $words.Count) { $r.Bad = $w.Text; return $r }
        $v = $words[$k + 1]
        if (-not $v.Quoted -and $v.Text -match '^-[A-Za-z]+$') { $r.Bad = $w.Text; return $r }
        $r.Values[$n] = $v.Text
        $k += 2
    }
    $r.Ok = $true
    return $r
}

# Dossiers de modules réduits (constat S2), ici et dans chaque job (Invoke-Spinner) : PowerShell remet le dossier
# Documents au démarrage de tout nouveau processus, job compris (vérifié le 23/11/2026). tools\check.ps1 refuse toute
# commande d'un module avant cette ligne (elle chargerait ce module depuis l'ancienne liste).
$SafeModulePath = [string](Get-SafeModulePath ([Environment]::GetFolderPath('Windows')) @((Get-ProgramFilesDir), [Environment]::GetFolderPath('ProgramFilesX86')))
$env:PSModulePath = $SafeModulePath
$script:JobInit = [ScriptBlock]::Create('$env:PSModulePath = ''' + $SafeModulePath.Replace("'", "''") + '''')

# Lancé par JARVIS.cmd (ScriptBlock, $PSCommandPath vide) : l'en-tête ne transmet plus d'arguments, ils sont lus ici
$script:ArgRefused = ''
if (-not $PSCommandPath -and $env:JARVIS_SELF -and $env:JARVIS_ARGS) {
    $ja = ConvertFrom-JarvisArgLine $env:JARVIS_ARGS $JarvisSwitchArgs $JarvisStringArgs
    if ($ja.Ok) {
        foreach ($an in $ja.Values.Keys) { $ExecutionContext.SessionState.PSVariable.Set($an, $ja.Values[$an]) }
    } else {
        $script:ArgRefused = $ja.Bad
    }
}

# ------------------------------------------------------------------
# Identité du programme et emplacement
# ------------------------------------------------------------------
$JarvisVersion = '3.28'
$JarvisSelf = $env:JARVIS_SELF                     # défini par JARVIS.cmd
if (-not $JarvisSelf) { $JarvisSelf = $PSCommandPath }  # lancement direct du .ps1
$JarvisHome = $null
if ($JarvisSelf) { $JarvisHome = Split-Path -Parent $JarvisSelf }
$JarvisInstalled = [bool]($JarvisHome -and (Test-Path -LiteralPath (Join-Path $JarvisHome '.jarvis-install')))
# L'utilisateur a déjà accepté l'avertissement « Éditeur inconnu » pour ce fichier : on retire la marque
# « téléchargé depuis Internet » afin que la relance en administrateur ne pose pas la question une 2e fois.
if ($JarvisSelf -like '*.cmd') { Unblock-File -LiteralPath $JarvisSelf -ErrorAction SilentlyContinue }
# Dossiers de Windows demandés à Windows, jamais lus dans les variables d'environnement (windir, ProgramW6432...) :
# un programme du compte peut les redéfinir dans le profil, et JARVIS les utilisait en administrateur pour lancer
# un outil, écrire la commande de désinstallation et choisir un dossier à nettoyer (v3.24, constat S3).
$WinDir = [Environment]::GetFolderPath('Windows')
if (-not $WinDir) { $WinDir = $env:windir }
$SysDrive = $WinDir.Substring(0, 2)
$DefaultInstallDir = Join-Path (Get-ProgramFilesDir) 'JARVIS'
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
# v3.25 (relecture du lot D) : entrée redirigée (scan d'essai de GitHub, banc d'essai), les erreurs du programme lui-même
# ne sont plus masquées : un essai qui en rencontre échoue (tools/scan-essai.ps1 refuse toute sortie d'erreur). Une
# erreur rattrapée par try/catch reste silencieuse ; les commandes de Windows gardent le réglage ci-dessous.
try { if ([Console]::IsInputRedirected) { $ErrorActionPreference = 'Continue' } } catch { $null = $_ }
# Lancé par JARVIS.cmd (ScriptBlock), la ligne SilentlyContinue ci-dessus n'atteint pas les commandes de Windows écrites en
# modules CIM (Get-PnpDevice, Get-NetRoute, Get-MpComputerStatus...) : leurs erreurs s'affichaient en rouge
# (PC sans Bluetooth, capture du 19/11/2026 ; reproduit avec JARVIS.cmd, pas avec -File). Réglage par défaut
# de chaque commande ; un -ErrorAction écrit dans l'appel (Stop, pour un OK) reste prioritaire.
$PSDefaultParameterValues['*:ErrorAction'] = 'SilentlyContinue'
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
$script:NotChecked  = New-Object System.Collections.Generic.List[string]   # contrôles non vérifiés (lecture impossible), v3.23
$script:CurSection  = ''        # numéro de la section en cours, repris devant chaque point de la synthèse (v3.23)
$script:Report      = New-Object System.Collections.Generic.List[string]
$script:WUCount     = 0
$script:ScanDetected = $null    # défauts du magasin de composants vus par DISM /ScanHealth (CBS.log), v3.21
$script:WUManual    = 0
$script:WUDrivers   = @()     # pilotes proposés par Windows Update (HardwareId, Title, Kind), v3.27
$script:WGItems     = @()
$script:WGCount     = 0
$script:WingetExe   = $null    # winget.exe par son chemin complet (Get-WingetPath), v3.24
$script:WingetLookup = ''      # '' tant que non cherché, puis OK, ABSENT ou UNREADABLE
$script:WGSkipIds   = @()      # applications que winget refuse de mettre à jour (exclues de la vérification)
$script:CleanTargets = @()      # cibles du nettoyage mesurées par la section 11 (New-CleanTarget)
$script:KeepSysDumps = $true     # vidages système gardés (écran bleu récent ou journal illisible)
$script:ComponentInfo = $null    # analyse des composants Windows (scan complet)
$script:WinOld      = $false     # dossier Windows.old présent et assez ancien pour proposer de le retirer
$script:WuTouched   = $false     # installation de mises à jour Windows lancée par JARVIS pendant cette session
$script:WuOpened    = $false     # page Windows Update ouverte par JARVIS (recherche ou téléchargement possibles), v3.21
$script:CleanUser   = $null      # compte qui exécute JARVIS, quand ce n'est pas celui de la session
$script:NeedRestore = $false
$script:DefenderScan = $false    # Defender est l'antivirus en service : analyse rapide proposable
$script:ChkdskFix   = New-Object System.Collections.Generic.List[string]
$script:DeepMode    = $false
$script:SpinState   = ''         # fin du dernier Invoke-Spinner : DONE, TIMEOUT, STOPPED ou FAILED
$script:ConModeSaved = $null     # mode de la console au lancement (sélection à la souris remise en partant)
$script:ConFontSaved = $null     # police de l'ancienne console au lancement, quand JARVIS l'a agrandie
$script:StoreItems  = @()        # applications du Microsoft Store à mettre à jour (Pfn, Name)

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
        Write-Host '      module check-up v3.28' -ForegroundColor DarkGray
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
    Write-Host '      module check-up v3.28' -ForegroundColor DarkGray
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
    $script:CurSection = $Num
}

function Cut([string]$s, [int]$n) {
    if ($null -eq $s) { return '' }
    if ($s.Length -le $n) { return $s }
    return $s.Substring(0, $n - 1) + '…'
}

function Remove-ControlChars([string]$Text) {
    # Texte venu de l'extérieur (winget, Windows Update, GitHub, noms de périphériques ou de volumes) :
    # caractères de contrôle retirés avant affichage, aucune séquence d'échappement n'atteint la console
    if ($null -eq $Text) { return '' }
    return ($Text -replace '[\x00-\x1F\x7F-\x9F]', '')
}

function ConvertTo-DisplayText([string]$Text) {
    # Texte affiché et écrit dans le rapport : caractères de contrôle retirés, puis tirets longs reçus de
    # Windows ou des éditeurs (U+2012 à U+2015, signe moins U+2212) remplacés par « - » (v3.21 : titre de la
    # mise à jour Defender « Antivirus - KB2267602 » ; Thomas n'en veut nulle part). Fonction pure, T1.
    $t = Remove-ControlChars $Text
    return ($t -replace ('[{0}-{1}{2}]' -f [char]0x2012, [char]0x2015, [char]0x2212), '-')
}

function Write-Status {
    param(
        [string]$Label,
        [string]$Value,
        [ValidateSet('OK', 'WARN', 'FAIL', 'INFO')][string]$State = 'INFO'
    )
    $Label = ConvertTo-DisplayText $Label
    $Value = ConvertTo-DisplayText $Value
    $tags   = @{ OK = '[ OK ]'; WARN = '[WARN]'; FAIL = '[FAIL]'; INFO = '[INFO]' }
    $colors = @{ OK = 'Green';  WARN = 'Yellow'; FAIL = 'Red';    INFO = 'DarkCyan' }
    $lbl = Cut $Label 32
    Write-Host '   ' -NoNewline
    Write-Host $tags[$State] -NoNewline -ForegroundColor $colors[$State]
    Write-Host (' {0,-33}' -f $lbl) -NoNewline -ForegroundColor Gray
    Write-Host $Value -ForegroundColor White
    $script:Report.Add(('{0} {1,-33} {2}' -f $tags[$State], $lbl, $Value))
    # v3.23 : chaque point de la synthèse dit dans quelle section lire son conseil ; une lecture impossible (INFO) est
    # comptée à part, sauf au nettoyage (section 11 : des mesures de place, pas des contrôles de santé)
    $where = ''
    if ($script:CurSection) { $where = '[' + $script:CurSection + '] ' }
    switch ($State) {
        'OK'   { $script:Ok++ }
        'WARN' { $script:Warnings.Add("$where$Label : $Value") }
        'FAIL' { $script:Alerts.Add("$where$Label : $Value") }
        'INFO' { if ($script:CurSection -ne '11' -and (Test-UnreadValue $Value)) { $script:NotChecked.Add("$where$Label : $Value") } }
    }
}

function Test-UnreadValue([string]$Value) {
    # Ligne INFO qui dit qu'un contrôle n'a pas pu être fait (règle 15 : jamais de OK sans lecture). v3.23, constat V2
    # de l'audit du 23/11/2026 : ces lignes ne comptaient nulle part, un PC dont l'antivirus, le pare-feu et les
    # disques étaient illisibles pouvait finir « nominal ». Vocabulaire à garder pour toute lecture en échec.
    # Fonction pure, T1.
    if ($null -eq $Value) { return $false }
    return ($Value -match 'impossible|illisible|indisponible|non v.rifiable|non reconnu|\bnon lue?s?\b|n.cessite les droits admin')
}

function Get-ScanVerdict([int]$Warn, [int]$Fail, [int]$Unread) {
    # État général de la synthèse (v3.23, constats V2 et V4 de l'audit) : remplace le pourcentage, qui comptait
    # un FAIL comme un WARN (antivirus coupé = 91 %, PC sain = 89 %) et ignorait les lectures impossibles.
    # Trois niveaux : ACT (au moins une alerte), WATCH (avertissements), GOOD. Sans alerte ni avertissement, « en bon
    # état » n'est écrit que si tout a été lu. Fonction pure, T1.
    if ($Fail -gt 0) {
        return [pscustomobject]@{ Level = 'ACT'; Title = 'À TRAITER'; Color = 'Red'
                                  Line = 'Au moins un point demande une intervention : commence par la liste ALERTES.' }
    }
    if ($Warn -gt 0) {
        return [pscustomobject]@{ Level = 'WATCH'; Title = 'À SURVEILLER'; Color = 'Yellow'
                                  Line = 'Rien d''urgent : quelques points à régler quand tu as le temps.' }
    }
    if ($Unread -gt 0) {
        return [pscustomobject]@{ Level = 'GOOD'; Title = 'RIEN D''ANORMAL VU'; Color = 'Green'
                                  Line = ('Rien d''anormal dans ce qui a été lu, mais {0} point(s) n''ont pas pu être vérifiés.' -f $Unread) }
    }
    return [pscustomobject]@{ Level = 'GOOD'; Title = 'EN BON ÉTAT'; Color = 'Green'; Line = 'Aucun point à traiter.' }
}

function Write-Sub {
    param([string]$Text, [ConsoleColor]$Color = 'DarkGray')
    $Text = ConvertTo-DisplayText $Text
    Write-Host ('          > ' + $Text) -ForegroundColor $Color
    $script:Report.Add('          > ' + $Text)
}

function Write-Action {
    # Résultat d'une action lancée après le scan : affiché et ajouté au rapport
    param([ValidateSet('OK', 'WARN', 'FAIL', 'INFO')][string]$State, [string]$Text)
    $tags   = @{ OK = '[ OK ]'; WARN = '[WARN]'; FAIL = '[FAIL]'; INFO = '[INFO]' }
    $colors = @{ OK = 'Green';  WARN = 'Yellow'; FAIL = 'Red';    INFO = 'Cyan' }
    $Text = ConvertTo-DisplayText $Text
    Write-Host ('   ' + $tags[$State] + ' ' + $Text) -ForegroundColor $colors[$State]
    $script:Report.Add($tags[$State] + ' ' + $Text)
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
        [object[]]$ArgumentList,
        # Travail qu'il vaut mieux ne pas interrompre (Windows Update) : au délai, jamais d'arrêt d'office.
        # La question est posée, la réponse par défaut est d'attendre encore ; $StopRisk dit ce que l'arrêt risque.
        [switch]$AskOnTimeout,
        [string]$StopRisk = 'L''arrêter en cours de route peut abîmer Windows : le plus sûr est d''attendre.'
    )
    # Retour $null : $script:SpinState dit pourquoi, TIMEOUT (délai dépassé) ou STOPPED (arrêté à la demande)
    $script:SpinState = 'RUNNING'
    # Dossiers de modules du programme repris dans le job (PowerShell y remet celui de Documents, constat S2)
    $sj = @{ ScriptBlock = $ScriptBlock }
    if ($script:JobInit) { $sj.InitializationScript = $script:JobInit }
    if ($ArgumentList) { $sj.ArgumentList = $ArgumentList }
    $job = Start-Job @sj
    $frames = @('|', '/', '-', '\')
    $blank = "`r" + (' ' * ($Label.Length + 30)) + "`r"
    $sw = [Diagnostics.Stopwatch]::StartNew()
    $limit = [double]$TimeoutSec
    $stopped = $false
    $k = 0
    while ($job.State -eq 'Running') {
        if ($sw.Elapsed.TotalSeconds -ge $limit) {
            if (-not $AskOnTimeout) { break }
            Write-Host $blank -NoNewline
            Write-Host ("   [!] {0} : en cours depuis {1:N0} min, plus longtemps que prévu." -f $Label, $sw.Elapsed.TotalMinutes) -ForegroundColor Yellow
            Write-Host ('       ' + $StopRisk) -ForegroundColor Yellow
            if (Read-YesNo '   >> L''arrêter quand même ?') { $stopped = $true; break }
            Write-Host '   >> J''attends encore 30 minutes.' -ForegroundColor DarkGray
            $limit = $sw.Elapsed.TotalSeconds + 1800
            continue
        }
        $f = $frames[$k % $frames.Count]; $k++
        $el = $sw.Elapsed
        Write-Host ("`r   [{0}] {1} ... {2:00}:{3:00}   " -f $f, $Label, [math]::Floor($el.TotalMinutes), $el.Seconds) -NoNewline -ForegroundColor DarkCyan
        Start-Sleep -Milliseconds 150
    }
    Write-Host $blank -NoNewline
    if ($job.State -eq 'Running') {
        Stop-Job $job; Remove-Job $job -Force
        $script:SpinState = 'TIMEOUT'
        if ($stopped) { $script:SpinState = 'STOPPED' }
        return $null
    }
    $failed = ($job.State -eq 'Failed')
    $res = Receive-Job $job | Select-Object -Last 1
    Remove-Job $job -Force
    $script:SpinState = 'DONE'
    if ($failed) { $script:SpinState = 'FAILED' }
    return $res
}

function ConvertFrom-ToolBytes([byte[]]$Bytes) {
    # Sortie d'un outil Windows redirigée vers un fichier : UTF-16 (SFC) si au moins un quart des octets
    # sont nuls, sinon UTF-8 quand la suite d'octets est valide, sinon page de code OEM (DISM).
    # Fonction pure, testée en T1.
    if ($null -eq $Bytes -or $Bytes.Length -eq 0) { return '' }
    $zeros = 0
    foreach ($b in $Bytes) { if ($b -eq 0) { $zeros++ } }
    if ($zeros -gt ($Bytes.Length / 4)) { return [Text.Encoding]::Unicode.GetString($Bytes) }
    try {
        return (New-Object System.Text.UTF8Encoding($false, $true)).GetString($Bytes)
    } catch {
        $oem = [Globalization.CultureInfo]::CurrentCulture.TextInfo.OEMCodePage
        return [Text.Encoding]::GetEncoding($oem).GetString($Bytes)
    }
}

function Invoke-ProcessSpinner {
    # Lance un exécutable attaché à la console (requis par SFC), sortie
    # redirigée vers un fichier, avec indicateur d'attente.
    # Retour : code et texte, ou $null. $script:ProcState dit alors pourquoi : NOSTART (lancement
    # impossible), TIMEOUT (délai dépassé, processus arrêté) ou STOPPED (arrêté à la demande).
    param(
        [string]$Label,
        [string]$FilePath,
        [string]$Arguments,
        [int]$TimeoutSec = 3600,
        [string]$Encoding = 'Oem',
        # Outil qui répare Windows (SFC, DISM /RestoreHealth) : au délai, jamais d'arrêt d'office.
        # La question est posée, et la réponse par défaut est d'attendre encore.
        [switch]$AskOnTimeout
    )
    $script:ProcState = 'NOSTART'
    $out = Join-Path $env:TEMP ('jarvis_{0}.txt' -f [guid]::NewGuid().ToString('N'))
    $err = $out + '.err'
    $p = $null
    try {
        $p = Start-Process -FilePath $FilePath -ArgumentList $Arguments -NoNewWindow -PassThru `
             -RedirectStandardOutput $out -RedirectStandardError $err -ErrorAction Stop
    } catch { $p = $null }
    if ($null -eq $p) {
        Remove-Item $out, $err -Force
        return $null
    }
    $null = $p.Handle
    $frames = @('|', '/', '-', '\')
    $blank = "`r" + (' ' * ($Label.Length + 30)) + "`r"
    $sw = [Diagnostics.Stopwatch]::StartNew()
    $limit = [double]$TimeoutSec
    $stopped = $false
    $k = 0
    while (-not $p.HasExited) {
        if ($sw.Elapsed.TotalSeconds -ge $limit) {
            if (-not $AskOnTimeout) { break }
            Write-Host $blank -NoNewline
            $short = $Label -replace '\s*\(.*\)\s*$', ''
            Write-Host ("   [!] {0} tourne depuis {1:N0} min, plus longtemps que prévu." -f $short, $sw.Elapsed.TotalMinutes) -ForegroundColor Yellow
            Write-Host '       L''arrêter en cours de route peut abîmer Windows : le plus sûr est d''attendre.' -ForegroundColor Yellow
            if (Read-YesNo '   >> L''arrêter quand même ?') { $stopped = $true; break }
            Write-Host '   >> J''attends encore 30 minutes.' -ForegroundColor DarkGray
            $limit = $sw.Elapsed.TotalSeconds + 1800
            continue
        }
        $f = $frames[$k % $frames.Count]; $k++
        $el = $sw.Elapsed
        Write-Host ("`r   [{0}] {1} ... {2:00}:{3:00}   " -f $f, $Label, [math]::Floor($el.TotalMinutes), $el.Seconds) -NoNewline -ForegroundColor DarkCyan
        Start-Sleep -Milliseconds 150
    }
    Write-Host $blank -NoNewline
    if (-not $p.HasExited) {
        try { $p.Kill() } catch {}
        Remove-Item $out, $err -Force
        $script:ProcState = 'TIMEOUT'
        if ($stopped) { $script:ProcState = 'STOPPED' }
        return $null
    }
    $p.WaitForExit()
    $txt = ''
    if (Test-Path -LiteralPath $out) {
        if ($Encoding -eq 'Auto') { $txt = ConvertFrom-ToolBytes ([IO.File]::ReadAllBytes($out)) }
        else { $txt = Get-Content -LiteralPath $out -Encoding $Encoding -Raw }
    }
    Remove-Item $out, $err -Force
    $script:ProcState = 'DONE'
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
    if (-not $interactive) {
        $a = Microsoft.PowerShell.Utility\Read-Host -Prompt $Prompt
        # Entrée redirigée (banc d'essai, scan d'essai de GitHub) : la fin de l'entrée vaut annulation ; elle est écrite
        # pour que le journal montre chaque question posée (v3.25, tools/scan-essai.ps1 les compte)
        if ($null -eq $a) { Write-Host ($Prompt + ' : [annulé, fin de l''entrée]') -ForegroundColor DarkGray }
        return $a
    }
    $null = Request-Attention   # fenêtre remise devant sans prendre le clavier (v3.26)
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

function Get-YesNo($Answer, [bool]$DefaultYes = $false) {
    # Lecture stricte d'une réponse oui/non. Fonction pure, testée en T1.
    # 'YES' : o, oui, y, yes. 'NO' : n, non, no, ou annulation ($null : Échap, Ctrl+C).
    # Réponse vide (Entrée) : la réponse par défaut de la question. Tout le reste : 'UNKNOWN'.
    if ($null -eq $Answer) { return 'NO' }
    $t = ([string]$Answer).Trim().ToLowerInvariant()
    if ($t -eq '') { if ($DefaultYes) { return 'YES' } else { return 'NO' } }
    if (@('o', 'oui', 'y', 'yes') -contains $t) { return 'YES' }
    if (@('n', 'non', 'no') -contains $t) { return 'NO' }
    return 'UNKNOWN'
}

function Read-YesNo([string]$Prompt, [switch]$DefaultYes) {
    # Toute question oui/non passe par ici : $true = oui, $false = non ou annulation.
    # Une réponse qui n'est ni oui ni non ne vaut jamais accord : la question est reposée.
    $suffix = ' [o/N]'
    if ($DefaultYes) { $suffix = ' [O/n]' }
    for ($attempt = 0; $attempt -lt 5; $attempt++) {
        $v = Get-YesNo (Read-Answer ($Prompt + $suffix)) ([bool]$DefaultYes)
        if ($v -eq 'YES') { return $true }
        if ($v -eq 'NO') { return $false }
        Write-Host '   [!] Réponse non comprise : tape o (oui) ou n (non), puis Entrée.' -ForegroundColor Yellow
    }
    Write-Host '   >> Trop de réponses non comprises : je considère que c''est non.' -ForegroundColor DarkGray
    return $false
}

function Get-MenuChoice($Answer, [string[]]$Keys, [string]$Default = '') {
    # Lecture stricte d'un choix de menu. Fonction pure, testée en T1.
    # $null : annulation. Touche en majuscule : choix affiché, ou choix par défaut sur Entrée.
    # Chaîne vide : réponse qui n'est pas une touche affichée.
    if ($null -eq $Answer) { return $null }
    $t = ([string]$Answer).Trim().ToUpperInvariant()
    if ($t -eq '') { return $Default.ToUpperInvariant() }
    foreach ($k in $Keys) { if ($t -eq $k.ToUpperInvariant()) { return $k.ToUpperInvariant() } }
    return ''
}

function Read-Choice([string]$Prompt, [string[]]$Keys, [string]$Default = '') {
    # Menu : seules les touches affichées sont acceptées. $null = annulation (Échap).
    for ($attempt = 0; $attempt -lt 5; $attempt++) {
        $c = Get-MenuChoice (Read-Answer $Prompt) $Keys $Default
        if ($null -eq $c) { return $null }
        if ($c -ne '') { return $c }
        Write-Host ('   [!] Choix non reconnu : tape ' + ($Keys -join ', ') + ' puis Entrée (Échap pour annuler).') -ForegroundColor Yellow
    }
    Write-Host '   >> Trop de réponses non reconnues : question annulée.' -ForegroundColor DarkGray
    return $null
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

function Test-SafeArgValue([string]$Text) {
    # Valeur qu'une relance peut retransmettre entre guillemets (dossier d'installation) : lettres, chiffres, espaces
    # et \ : . _ - ( ) ' seulement. L'en-tête de JARVIS.cmd recopie les arguments par « set "JARVIS_ARGS=%*" » :
    # un & ou un ^ y deviendrait une commande de cmd, lancée en administrateur après une relance (v3.24). T1.
    if ([string]::IsNullOrEmpty($Text)) { return $false }
    return ($Text -match '^[\p{L}\p{M}0-9 \\:._()''\-]+$')
}

function Test-SafeTempPath([string]$Path) {
    # N'accepte qu'un vrai dossier « Temp », jamais une racine ou un dossier système
    if ([string]::IsNullOrWhiteSpace($Path)) { return $false }
    try { $full = [IO.Path]::GetFullPath($Path).TrimEnd('\') } catch { return $false }
    if ($full -match '^[A-Za-z]:$') { return $false }
    if ((Split-Path -Leaf $full) -ne 'Temp') { return $false }
    # Variables d'environnement et dossiers demandés à Windows (une variable peut être redéfinie, v3.24)
    $forbidden = @($env:SystemDrive, $env:SystemRoot, $env:USERPROFILE, $env:ProgramFiles, ${env:ProgramFiles(x86)},
                   $env:ProgramData, $env:LOCALAPPDATA, $env:APPDATA, $env:PUBLIC,
                   [Environment]::GetFolderPath('Windows'), [Environment]::GetFolderPath('ProgramFiles'),
                   [Environment]::GetFolderPath('ProgramFilesX86'), [Environment]::GetFolderPath('CommonApplicationData'),
                   [Environment]::GetFolderPath('UserProfile')) |
                 Where-Object { $_ } | ForEach-Object { $_.TrimEnd('\') }
    if ($forbidden -contains $full) { return $false }
    # Sous Windows, Program Files ou ProgramData, seul Windows\Temp est accepté : %TEMP% est une variable du compte, qui
    # pourrait désigner le dossier « Temp » d'un programme installé, vidé ensuite en administrateur (v3.24, relecture S3)
    $win = [Environment]::GetFolderPath('Windows')
    if ($full -ne (([string]$win).TrimEnd('\') + '\Temp')) {
        foreach ($top in @($win, (Get-ProgramFilesDir), [Environment]::GetFolderPath('ProgramFiles'),
                           [Environment]::GetFolderPath('ProgramFilesX86'), [Environment]::GetFolderPath('CommonApplicationData'))) {
            if ($top -and $full.StartsWith(([string]$top).TrimEnd('\') + '\', [StringComparison]::OrdinalIgnoreCase)) { return $false }
        }
    }
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

function Test-NoLinkInChain([string]$Root, [string]$Path) {
    # Vrai si aucun dossier, du parent de $Path jusqu'à $Root compris, n'est une jonction ou un lien.
    # Contrôlé juste avant chaque suppression : entre la liste et la suppression, un dossier listé peut
    # avoir été remplacé par une jonction, et la suppression irait alors détruire des fichiers ailleurs.
    # Les deux chemins sont d'abord dépliés : %TEMP% peut être au format court (C:\Users\MARIED~1\...)
    # alors que les fichiers listés arrivent au format long.
    $rootFull = $null
    $cur = $null
    try {
        $rootFull = [IO.Path]::GetFullPath($Root).TrimEnd('\')
        $cur = Split-Path -Parent ([IO.Path]::GetFullPath($Path))
    } catch { return $false }
    while ($cur) {
        if (-not $cur.StartsWith($rootFull, [StringComparison]::OrdinalIgnoreCase)) { return $false }
        $at = $null
        try { $at = [IO.File]::GetAttributes($cur) } catch { return $false }
        if ($at -band [IO.FileAttributes]::ReparsePoint) { return $false }
        if ($cur.Length -le $rootFull.Length) { return $true }
        $cur = Split-Path -Parent $cur
    }
    return $false
}

function Get-TempCandidates([string]$Path, [int]$MinAgeHours = 24, [string]$Extension = '') {
    # Ce que le nettoyage peut retirer : fichiers de plus de $MinAgeHours (un fichier récent est peut-être
    # en cours d'utilisation) et sous-dossiers anciens. Les jonctions ne sont jamais suivies.
    # $Extension (vidages mémoire : '.dmp') : seuls ces fichiers sont pris, et aucun dossier.
    $limit = (Get-Date).AddHours(-$MinAgeHours)
    $files = [System.Collections.Generic.List[object]]::new()
    $dirs = [System.Collections.Generic.List[string]]::new()
    foreach ($it in @(Get-FilesNoJunction $Path -WithDirs)) {
        if ($it.PSIsContainer) {
            if (-not $Extension -and $it.CreationTime -lt $limit) { $dirs.Add($it.FullName) }
            continue
        }
        if ($it.LastWriteTime -ge $limit) { continue }
        if ($Extension -and $it.Extension -ne $Extension) { continue }
        $files.Add([pscustomobject]@{ Path = $it.FullName; Length = [int64]$it.Length })
    }
    # Tableaux simples en sortie : sous PowerShell 5.1, « @(...) » autour d'une liste générique échoue
    return [pscustomobject]@{ Files = $files.ToArray(); Dirs = $dirs.ToArray() }
}

function Remove-TempCandidates([string]$Root, $Candidates) {
    # Supprime la liste préparée par Get-TempCandidates, chaque chemin étant recontrôlé juste avant
    $freed = [int64]0
    $skipped = 0
    foreach ($f in @($Candidates.Files)) {
        if (-not (Test-NoLinkInChain $Root $f.Path)) { $skipped++; continue }
        try { [IO.File]::Delete($f.Path); $freed += $f.Length } catch {}
    }
    # Dossiers anciens devenus vides, du plus profond au moins profond, jamais de suppression récursive
    foreach ($d in (@($Candidates.Dirs) | Sort-Object { $_.Length } -Descending)) {
        if (-not (Test-NoLinkInChain $Root $d)) { $skipped++; continue }
        try { [IO.Directory]::Delete($d, $false) } catch {}
    }
    return [pscustomobject]@{ FreedBytes = $freed; Skipped = $skipped }
}

function Clear-TempFolder([string]$Path, [int]$MinAgeHours = 24) {
    $res = [pscustomobject]@{ Ok = $false; FreedMB = 0; Reason = '' }
    if (-not (Test-SafeTempPath $Path)) { $res.Reason = 'nettoyage refusé, chemin anormal : ' + $Path; return $res }
    $Path = [IO.Path]::GetFullPath($Path).TrimEnd('\')
    $done = Remove-TempCandidates $Path (Get-TempCandidates $Path $MinAgeHours)
    $res.Ok = $true
    $res.FreedMB = [math]::Round($done.FreedBytes / 1MB)
    return $res
}

function Remove-EmptyDir([string]$Path) {
    # Retire un dossier seulement s'il est vide (jamais de suppression récursive) ; $true s'il n'existe plus
    if ([string]::IsNullOrWhiteSpace($Path)) { return $false }
    try { [IO.Directory]::Delete($Path, $false) } catch { return (-not (Test-Path -LiteralPath $Path)) }
    return (-not (Test-Path -LiteralPath $Path))
}

function Remove-TreeNoJunction([string]$Path) {
    # Supprime un dossier créé par JARVIS et tout son contenu sans jamais suivre une jonction ni un lien :
    # le lien lui-même est retiré, sa cible n'est pas touchée. $true si le dossier n'existe plus à la fin.
    if ([string]::IsNullOrWhiteSpace($Path)) { return $true }
    $full = $null
    try { $full = [IO.Path]::GetFullPath($Path).TrimEnd('\') } catch { return $false }
    if ($full -match '^[A-Za-z]:$' -or $full -match '^\\\\[^\\]+\\[^\\]+$') { return $false }   # jamais une racine
    if (-not (Test-Path -LiteralPath $full)) { return $true }
    $isLink = { param($Item) [bool]($Item.Attributes -band [IO.FileAttributes]::ReparsePoint) }
    $top = Get-Item -LiteralPath $full -Force
    if ($null -eq $top) { return $false }
    if (& $isLink $top) { return (Remove-EmptyDir $full) }
    $dirs = New-Object System.Collections.Generic.List[string]
    $stack = New-Object System.Collections.Stack
    $stack.Push($full)
    while ($stack.Count -gt 0) {
        $cur = $stack.Pop()
        $dirs.Add($cur)
        foreach ($it in @(Get-ChildItem -LiteralPath $cur -Force)) {
            # Dossier remplacé par une jonction pendant le parcours : on n'y touche plus
            if (-not (Test-NoLinkInChain $full $it.FullName)) { continue }
            if ($it.PSIsContainer) {
                # Directory.Delete non récursif sur un lien retire le lien, pas le contenu de sa cible
                if (& $isLink $it) { $null = Remove-EmptyDir $it.FullName } else { $stack.Push($it.FullName) }
                continue
            }
            try {
                if ($it.Attributes -band [IO.FileAttributes]::ReadOnly) { [IO.File]::SetAttributes($it.FullName, [IO.FileAttributes]::Normal) }
                [IO.File]::Delete($it.FullName)
            } catch { continue }
        }
    }
    foreach ($d in ($dirs | Sort-Object { $_.Length } -Descending)) { $null = Remove-EmptyDir $d }
    return (-not (Test-Path -LiteralPath $full))
}

# ------------------------------------------------------------------
# Nettoyage étendu (v3.16) : cibles calculées par le programme, jamais saisies
# ------------------------------------------------------------------
$CleanMinBytes = 100MB      # une cible plus petite n'est pas proposée (une question de moins)
$CleanMinDoBytes = 1GB      # optimisation de livraison : Windows la vide de lui-même après quelques jours

function Get-CleanTargetPaths {
    # Chemins exacts que le nettoyage étendu peut toucher. Dossier Windows et profil lus par l'API de Windows,
    # pas par des variables d'environnement qu'un programme pourrait détourner.
    $t = [ordered]@{}
    $win = [Environment]::GetFolderPath('Windows')
    $local = [Environment]::GetFolderPath('LocalApplicationData')
    if ($win -match '^[A-Za-z]:\\.') {
        $t['WuCache'] = Join-Path $win 'SoftwareDistribution\Download'
        $t['Minidump'] = Join-Path $win 'Minidump'
        $t['MemoryDump'] = Join-Path $win 'MEMORY.DMP'
    }
    if ($local -match '^[A-Za-z]:\\.') { $t['CrashDumps'] = Join-Path $local 'CrashDumps' }
    return $t
}

function Test-SafeCleanTarget([string]$Path, $Allowed = $null) {
    # Vrai seulement pour un chemin de la liste blanche (comparaison exacte après dépliage), qui existe, et dont
    # aucun élément, de lui-même jusqu'à la racine du disque, n'est une jonction ou un lien. $Allowed ne sert
    # qu'à l'auto-test (bac à sable) : sinon la liste est celle de Get-CleanTargetPaths.
    if ([string]::IsNullOrWhiteSpace($Path)) { return $false }
    if ($null -eq $Allowed) { $Allowed = @((Get-CleanTargetPaths).Values) }
    $full = $null
    try { $full = [IO.Path]::GetFullPath($Path).TrimEnd('\') } catch { return $false }
    if ($Path -notmatch '^[A-Za-z]:\\' -or $full -notmatch '^[A-Za-z]:\\.') { return $false }   # chemin complet, ni racine ni réseau
    $listed = $false
    foreach ($a in @($Allowed)) {
        if ([string]::IsNullOrWhiteSpace([string]$a)) { continue }
        $af = $null
        try { $af = [IO.Path]::GetFullPath([string]$a).TrimEnd('\') } catch { continue }
        if ($af -notmatch '^[A-Za-z]:\\.') { continue }
        if ([string]::Equals($af, $full, [StringComparison]::OrdinalIgnoreCase)) { $listed = $true; break }
    }
    if (-not $listed) { return $false }
    $cur = $full
    while ($cur -match '^[A-Za-z]:\\.') {
        $at = $null
        try { $at = [IO.File]::GetAttributes($cur) } catch { return $false }
        if ($at -band [IO.FileAttributes]::ReparsePoint) { return $false }
        $cur = Split-Path -Parent $cur
    }
    return $true
}

function Get-OnDiskBytes([int64]$Length, [IO.FileAttributes]$Attributes, $Allocated) {
    # Place qu'un fichier libère vraiment. Fichier creux ou compressé : la place allouée ($Allocated, lue par
    # Get-AllocatedBytes), jamais plus que sa taille ; $null si elle n'a pas pu être lue. Autre fichier : sa taille.
    # Relevé du 20/11/2026 : cache de l'optimisation de livraison, 9 fichiers creux sur 18 (mises à jour reçues
    # en partie), 5,11 Go de tailles pour 1,04 Go sur le disque. Fonction pure, testée en T1.
    $flags = [int]([IO.FileAttributes]::SparseFile) -bor [int]([IO.FileAttributes]::Compressed)
    if (([int]$Attributes -band $flags) -eq 0) { return $Length }
    if ($null -eq $Allocated -or [int64]$Allocated -lt 0) { return $null }
    if ([int64]$Allocated -gt $Length) { return $Length }
    return [int64]$Allocated
}

function Get-AllocatedBytes([string]$Path) {
    # Place réellement occupée sur le disque par un fichier (GetCompressedFileSizeW) ; $null si illisible
    try {
        if (-not ('JarvisNative.DiskSize' -as [type])) {
            Add-Type -Namespace JarvisNative -Name DiskSize -MemberDefinition @'
[DllImport("kernel32.dll", SetLastError = true, CharSet = CharSet.Unicode)] public static extern uint GetCompressedFileSizeW(string path, out uint high);
'@
        }
        $hi = [uint32]0
        $lo = [JarvisNative.DiskSize]::GetCompressedFileSizeW($Path, [ref]$hi)
        if ($lo -eq [uint32]::MaxValue -and [Runtime.InteropServices.Marshal]::GetLastWin32Error() -ne 0) { return $null }
        return (([int64]$hi -shl 32) + [int64]$lo)
    } catch { return $null }
}

function Get-FileDiskSize($File) {
    # Place libérée par la suppression de ce fichier ($File : FileInfo) ; $null si elle n'a pas pu être lue.
    # La place allouée n'est lue que pour un fichier creux ou compressé (un appel à Windows de plus par fichier).
    $len = [int64]$File.Length
    $flags = [int]([IO.FileAttributes]::SparseFile) -bor [int]([IO.FileAttributes]::Compressed)
    if (([int]$File.Attributes -band $flags) -eq 0) { return $len }
    return (Get-OnDiskBytes $len $File.Attributes (Get-AllocatedBytes $File.FullName))
}

function Measure-AgedFiles([string]$Path, [int]$MinAgeHours, [string]$Extension = '') {
    # Taille totale et taille des fichiers de plus de $MinAgeHours (avec l'extension voulue), sans suivre les
    # jonctions. Ok = $false si la cible existe mais ne peut pas être lue (droits) : jamais un « 0 » trompeur.
    # Link : la cible elle-même est une jonction ou un lien (dossier déplacé), elle n'est ni comptée ni nettoyée.
    # Partial : un sous-dossier n'a pas pu être lu, les tailles sont des minimums. Tailles = place sur le disque
    # (Get-FileDiskSize) : un fichier creux compte pour ce qu'il occupe ; place illisible = 0 et Partial.
    $r = [pscustomobject]@{ Ok = $false; Exists = $false; Link = $false; Partial = $false; TotalBytes = [int64]0; AgedBytes = [int64]0; AgedCount = 0 }
    $top = $null
    try { $top = Get-Item -LiteralPath $Path -Force -ErrorAction Stop }
    catch [System.Management.Automation.ItemNotFoundException] { $r.Ok = $true; return $r }
    catch { return $r }
    $r.Exists = $true
    if ($top.Attributes -band [IO.FileAttributes]::ReparsePoint) { $r.Ok = $true; $r.Link = $true; return $r }
    $files = New-Object System.Collections.Generic.List[object]
    if ($top.PSIsContainer) {
        # Parcours sans suivre les jonctions, chaque dossier lu avec arrêt sur erreur pour savoir s'il manque quelque chose
        $stack = New-Object System.Collections.Stack
        $stack.Push($top.FullName)
        $first = $true
        while ($stack.Count -gt 0) {
            $cur = [string]$stack.Pop()
            $items = $null
            try { $items = @(Get-ChildItem -LiteralPath $cur -Force -ErrorAction Stop) }
            catch {
                if ($first) { return $r }       # dossier lui-même illisible : aucune mesure
                $r.Partial = $true
                continue
            }
            $first = $false
            foreach ($it in $items) {
                if ($it.Attributes -band [IO.FileAttributes]::ReparsePoint) { continue }
                if ($it.PSIsContainer) { $stack.Push($it.FullName) } else { $files.Add($it) }
            }
        }
    } else { $files.Add($top) }
    $limit = (Get-Date).AddHours(-$MinAgeHours)
    foreach ($f in $files) {
        $size = Get-FileDiskSize $f
        if ($null -eq $size) { $r.Partial = $true; $size = [int64]0 }
        $r.TotalBytes += $size
        if ($f.LastWriteTime -ge $limit) { continue }
        if ($Extension -and $f.Extension -ne $Extension) { continue }
        $r.AgedBytes += $size
        $r.AgedCount++
    }
    $r.Ok = $true
    return $r
}

function Clear-CleanTarget([string]$Key, [int]$MinAgeHours, [string]$Extension = '', $Paths = $null) {
    # Nettoyage d'une cible de la liste blanche : fichiers de plus de $MinAgeHours, sans suivre les jonctions,
    # chaque chemin recontrôlé juste avant sa suppression. Le résultat vient d'un nouveau contrôle des fichiers
    # visés (ceux qui existent encore sont « conservés »), pas de l'absence d'erreur.
    # $Paths ne sert qu'à l'auto-test (bac à sable) : le programme passe toujours par Get-CleanTargetPaths.
    $res = [pscustomobject]@{ Ok = $false; FreedBytes = [int64]0; LeftBytes = [int64]0; Reason = '' }
    if ($null -eq $Paths) { $Paths = Get-CleanTargetPaths }
    $allowed = @($Paths.Values)
    $p = $null
    if ($Paths.Contains($Key)) { $p = [string]$Paths[$Key] }
    if ($p -and -not [IO.Directory]::Exists($p) -and -not [IO.File]::Exists($p) -and -not (Test-Path -LiteralPath $p)) {
        $res.Ok = $true      # rien à cet endroit : rien à nettoyer
        return $res
    }
    if (-not $p -or -not (Test-SafeCleanTarget $p $allowed)) { $res.Reason = 'nettoyage refusé, chemin anormal : ' + $p; return $res }
    $full = [IO.Path]::GetFullPath($p).TrimEnd('\')
    $limit = (Get-Date).AddHours(-$MinAgeHours)
    if (-not [IO.Directory]::Exists($full)) {
        # Fichier seul (MEMORY.DMP)
        $f = Get-Item -LiteralPath $full -Force
        if ($null -eq $f) { $res.Reason = 'cible introuvable'; return $res }
        $res.Ok = $true
        if ($f.LastWriteTime -ge $limit -or ($Extension -and $f.Extension -ne $Extension)) { return $res }
        $len = [int64]$f.Length
        if (Test-SafeCleanTarget $full $allowed) {
            try { [IO.File]::Delete($full) } catch { $res.LeftBytes = $len }
        }
        if ([IO.File]::Exists($full)) { $res.LeftBytes = $len } else { $res.FreedBytes = $len }
        return $res
    }
    $cand = Get-TempCandidates $full $MinAgeHours $Extension
    $null = Remove-TempCandidates $full $cand
    foreach ($c in @($cand.Files)) {
        if ([IO.File]::Exists($c.Path)) { $res.LeftBytes += $c.Length } else { $res.FreedBytes += $c.Length }
    }
    $res.Ok = $true
    return $res
}

function Initialize-NativeBin {
    # Fonctions de Windows pour mesurer et vider la corbeille (chargées une seule fois). La lecture par
    # Shell.Application compte 0 octet pour un dossier supprimé ; SHQueryRecycleBin donne le vrai total.
    # En PowerShell 32 bits, Windows range cette structure sans trou après cbSize (taille 20 au lieu de 24) :
    # sans « Pack = 4 », la taille lue valait le nombre d'éléments fois 4 Go et le nombre, 0 (essai du 19/11/2026).
    if ('JarvisNative.Bin' -as [type]) { return $true }
    $pack = ''
    if ([IntPtr]::Size -eq 4) { $pack = ', Pack = 4' }
    $def = '[StructLayout(LayoutKind.Sequential' + $pack + ')] public struct SHQUERYRBINFO { public int cbSize; public long i64Size; public long i64NumItems; }' + "`r`n" +
           '[DllImport("shell32.dll", CharSet = CharSet.Unicode)] public static extern int SHQueryRecycleBin(string pszRootPath, ref SHQUERYRBINFO pSHQueryRBInfo);' + "`r`n" +
           '[DllImport("shell32.dll", CharSet = CharSet.Unicode)] public static extern int SHEmptyRecycleBin(IntPtr hwnd, string pszRootPath, uint dwFlags);'
    try {
        Add-Type -Namespace JarvisNative -Name Bin -MemberDefinition $def
        return $true
    } catch { return $false }
}

function Get-RecycleBinState {
    # Corbeille du compte qui exécute JARVIS, tous disques confondus. Ok = $false si la lecture échoue ou si elle
    # est incohérente (structure de taille inattendue, octets sans aucun élément).
    $r = [pscustomobject]@{ Ok = $false; Bytes = [int64]0; Count = [int64]0 }
    if (-not (Initialize-NativeBin)) { return $r }
    try {
        $q = New-Object JarvisNative.Bin+SHQUERYRBINFO
        $q.cbSize = [Runtime.InteropServices.Marshal]::SizeOf($q)
        $expected = 24
        if ([IntPtr]::Size -eq 4) { $expected = 20 }
        if ($q.cbSize -ne $expected) { return $r }
        $hr = [JarvisNative.Bin]::SHQueryRecycleBin([NullString]::Value, [ref]$q)
        if ($hr -eq 0 -and $q.i64Size -ge 0 -and $q.i64NumItems -ge 0 -and -not ($q.i64NumItems -eq 0 -and $q.i64Size -gt 0)) {
            $r.Bytes = [int64]$q.i64Size; $r.Count = [int64]$q.i64NumItems; $r.Ok = $true
        }
    } catch { $r.Ok = $false }
    return $r
}

function Clear-RecycleBinChecked {
    # Vide la corbeille (tous les disques), sans fenêtre ni son, puis la relit : le résultat vient de la
    # nouvelle lecture, pas de la réponse de Windows (qui répond aussi « erreur » pour une corbeille déjà vide).
    $res = [pscustomobject]@{ Ok = $false; FreedBytes = [int64]0; LeftCount = [int64]0; Reason = '' }
    $before = Get-RecycleBinState
    if (-not $before.Ok) { $res.Reason = 'contenu de la corbeille illisible, rien n''a été supprimé'; return $res }
    try { $null = [JarvisNative.Bin]::SHEmptyRecycleBin([IntPtr]::Zero, [NullString]::Value, 7) }
    catch { $res.Reason = 'Windows a refusé le vidage' }
    $after = Get-RecycleBinState
    if (-not $after.Ok) { $res.Reason = 'résultat non vérifiable : corbeille illisible après le vidage'; return $res }
    $res.Ok = $true
    $res.FreedBytes = [math]::Max([int64]0, $before.Bytes - $after.Bytes)
    $res.LeftCount = $after.Count
    return $res
}

function Get-DoCacheDir {
    # Dossier par défaut du cache de l'optimisation de livraison ; $null si une stratégie l'a déplacé
    # (DOModifyCacheDrive) ou si la stratégie est illisible : la taille est alors estimée.
    $pol = Get-RegValueSafe 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization' 'DOModifyCacheDrive'
    if (-not $pol.Ok -and -not $pol.Missing) { return $null }
    if ($pol.Ok -and -not [string]::IsNullOrWhiteSpace([string]$pol.Value)) { return $null }
    $win = [Environment]::GetFolderPath('Windows')
    if ($win -notmatch '^[A-Za-z]:\\.') { return $null }
    return (Join-Path $win 'ServiceProfiles\NetworkService\AppData\Local\Microsoft\Windows\DeliveryOptimization\Cache')
}

function Get-DoCacheEstimate {
    # Taille estimée sans droits admin : somme de ce que Windows annonce pour chaque fichier du cache, la part
    # réellement présente (FileSizeInCache) quand elle est fournie, sinon la taille du fichier ($null si illisible).
    # Sur le PC de Thomas le 19/11/2026 : 7,1 Go de tailles de fichiers pour 7,0 Go sur le disque.
    # Cache vide : Windows répond par un avertissement en anglais (« No active Delivery Optimization download or
    # upload jobs »), masqué ici ; aucun fichier = 0.
    try {
        $sum = [int64]0
        foreach ($f in @(Get-DeliveryOptimizationStatus -ErrorAction Stop -WarningAction SilentlyContinue)) {
            if ($null -ne $f.FileSizeInCache) { $sum += [int64]$f.FileSizeInCache }
            elseif ($null -ne $f.FileSize) { $sum += [int64]$f.FileSize }
        }
        return $sum
    } catch { return $null }
}

function Get-DoCacheState {
    # Cache de l'optimisation de livraison (copies de mises à jour partagées avec d'autres PC) : taille et
    # téléchargements en cours. Taille : le dossier lui-même quand il est lisible (droits admin), Exact = $true ;
    # sinon l'estimation de Get-DoCacheEstimate. Jamais CacheSizeBytes de Get-DeliveryOptimizationPerfSnap : ce
    # n'est pas la taille du cache (460 Mo annoncés pour 7,0 Go sur le disque, auto-test du 19/11/2026).
    # Busy = $null : nombre de téléchargements en attente illisible (anciennes versions de Windows 10), traité
    # comme un empêchement : [int]$null vaudrait 0, soit « aucun téléchargement » sans preuve (règle 24).
    $r = [pscustomobject]@{ Ok = $false; Bytes = [int64]0; Exact = $false; Busy = $null }
    try {
        $s = Get-DeliveryOptimizationPerfSnap -ErrorAction Stop -WarningAction SilentlyContinue
        if ($null -ne $s) {
            $fg = ConvertTo-IntOrNull $s.ForegroundDownloadsPending
            $bg = ConvertTo-IntOrNull $s.BackgroundDownloadsPending
            if ($null -ne $fg -and $null -ne $bg) { $r.Busy = ($fg + $bg) -gt 0 }
        }
    } catch { $r.Busy = $null }
    $dir = Get-DoCacheDir
    if ($dir) {
        $m = Measure-AgedFiles $dir 0
        if ($m.Ok -and -not $m.Partial -and -not $m.Link) {
            $r.Bytes = $m.TotalBytes; $r.Exact = $true; $r.Ok = $true
            return $r
        }
    }
    $est = Get-DoCacheEstimate
    if ($null -ne $est) { $r.Bytes = [int64]$est; $r.Ok = $true }
    return $r
}

function Format-DoSize($State) {
    # « 7,0 Go » mesuré sur le disque, « environ 7,1 Go » estimé
    if ($State.Exact -or $State.Bytes -le 0) { return (Format-Bytes $State.Bytes) }
    return ('environ ' + (Format-Bytes $State.Bytes))
}

function Test-DoDeleteAvailable {
    # $true si Windows sait vider ce cache par l'interface qu'utilise Clear-DoCache. Absente sous Windows 10 22H2
    # (PC-LV le 21/11/2026 : classe sans aucune méthode, module DeliveryOptimization 1.0.2.0 sans
    # Delete-DeliveryOptimizationCache, vidage refusé « Méthode Delete introuvable ») ; présente sous Windows 11
    # (Delete, SetPinned, SetExpiration).
    try {
        $c = Get-CimClass -Namespace 'root/Microsoft/Windows/DeliveryOptimization' -ClassName MSFT_DeliveryOptimizationFile -ErrorAction Stop
        return (@($c.CimClassMethods | ForEach-Object { [string]$_.Name }) -contains 'Delete')
    } catch { return $false }
}

function Clear-DoCache {
    # Vidage par l'interface de Windows (celle qu'appelle Delete-DeliveryOptimizationCache, sans ses messages
    # en anglais) ; fichiers épinglés conservés. Résultat lu dans une nouvelle mesure, de même nature qu'avant.
    $res = [pscustomobject]@{ Ok = $false; FreedBytes = [int64]0; LeftBytes = [int64]0; Reason = '' }
    $before = Get-DoCacheState
    if (-not $before.Ok) { $res.Reason = 'taille du cache illisible, rien n''a été supprimé'; return $res }
    if ($null -eq $before.Busy) { $res.Reason = 'état des téléchargements illisible, rien n''a été supprimé'; return $res }
    if ($before.Busy) { $res.Reason = 'un téléchargement est en cours : réessaie plus tard'; return $res }
    try {
        $null = Invoke-CimMethod -Namespace 'root/Microsoft/Windows/DeliveryOptimization' -ClassName MSFT_DeliveryOptimizationFile `
                -MethodName Delete -Arguments @{ deletePinned = $false } -ErrorAction Stop
    } catch {
        $res.Reason = 'Windows a refusé le vidage : ' + (Cut (Remove-ControlChars $_.Exception.Message) 80)
        return $res
    }
    $after = Get-DoCacheState
    if ($after.Ok -and $after.Bytes -gt 0) {
        # Le service peut lâcher ses fichiers avec un peu de retard : une seconde mesure
        Start-Sleep -Seconds 3
        $after = Get-DoCacheState
    }
    if (-not $after.Ok -or $after.Exact -ne $before.Exact) {
        $res.Reason = 'résultat non vérifiable : taille du cache illisible après le vidage'
        return $res
    }
    $res.Ok = $true
    $res.FreedBytes = [math]::Max([int64]0, $before.Bytes - $after.Bytes)
    $res.LeftBytes = $after.Bytes
    if (-not $after.Exact) { $res.Reason = 'tailles estimées par Windows, pas mesurées sur le disque' }
    return $res
}

function Get-WuBusyState {
    # Raisons de ne pas toucher aux fichiers de Windows Update ni aux composants. InstallerBusy = $null :
    # état de l'installateur illisible (traité comme un empêchement).
    $rp = (Test-Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending') -or
          (Test-Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired')
    $sv = [bool](Get-Process TiWorker)
    $ib = $null
    try { $ib = [bool](New-Object -ComObject Microsoft.Update.Session -ErrorAction Stop).CreateUpdateInstaller().IsBusy } catch { $ib = $null }
    return [pscustomobject]@{ RebootPending = [bool]$rp; ServicingBusy = $sv; InstallerBusy = $ib }
}

function Get-ServicingBlocker($RebootPending, $ServicingBusy, $InstallerBusy) {
    # Raison de reporter le vidage du cache Windows Update ou le nettoyage des composants, '' si rien ne
    # l'empêche. Un état illisible ($null) empêche aussi. Fonction pure, testée en T1.
    if ($null -eq $RebootPending -or [bool]$RebootPending) { return 'un redémarrage est en attente (mises à jour à terminer)' }
    if ($null -eq $InstallerBusy) { return 'état de Windows Update illisible' }
    if ([bool]$InstallerBusy) { return 'Windows Update installe des mises à jour en ce moment' }
    if ($null -eq $ServicingBusy -or [bool]$ServicingBusy) { return 'Windows installe des composants en ce moment' }
    return ''
}

function Clear-WuCache {
    # Vide SoftwareDistribution\Download : Windows Update et BITS arrêtés, suppression par Clear-CleanTarget,
    # puis relance vérifiée des services qui tournaient. Rien n'est supprimé si l'arrêt échoue.
    $res = [pscustomobject]@{ Ok = $false; FreedBytes = [int64]0; LeftBytes = [int64]0; Reason = ''; Restarted = $true }
    $b = Get-WuBusyState
    $why = Get-ServicingBlocker $b.RebootPending $b.ServicingBusy $b.InstallerBusy
    if ($why) { $res.Reason = $why; return $res }
    $wasRunning = @()
    foreach ($n in @('wuauserv', 'bits')) {
        $s = Get-Service -Name $n
        if ($null -eq $s) { $res.Reason = 'service ' + $n + ' introuvable, rien n''a été supprimé'; return $res }
        if ($s.Status -ne 'Stopped') { $wasRunning += $n }
    }
    $stopped = $true
    $deleting = $false
    # v3.26 (audit, constat S8) : relance dans un finally. Avant, une erreur imprévue entre l'arrêt et la relance
    # (dans la suppression par exemple) laissait Windows Update et BITS arrêtés.
    try {
        foreach ($n in $wasRunning) {
            try {
                $s = Get-Service -Name $n
                # En cours de démarrage : attendre qu'il tourne ; en cours d'arrêt : attendre seulement
                if ($s.Status -eq 'StartPending') { $s.WaitForStatus('Running', [TimeSpan]::FromSeconds(60)); $s.Refresh() }
                if ($s.Status -eq 'Running' -or $s.Status -eq 'Paused') { $s.Stop() }
                $s.WaitForStatus('Stopped', [TimeSpan]::FromSeconds(60))
            } catch { $stopped = $false; break }
        }
        if (-not $stopped) {
            $res.Reason = 'Windows Update n''a pas pu être arrêté, rien n''a été supprimé'
        } else {
            # Juste avant la suppression : un déclencheur de Windows a pu relancer un service entre-temps
            foreach ($n in @('wuauserv', 'bits')) {
                $s = Get-Service -Name $n
                if ($null -eq $s -or $s.Status -ne 'Stopped') { $stopped = $false }
            }
            if ($stopped) {
                $deleting = $true
                $c = Clear-CleanTarget 'WuCache' 0
                $res.Ok = $c.Ok; $res.FreedBytes = $c.FreedBytes; $res.LeftBytes = $c.LeftBytes; $res.Reason = $c.Reason
            } else {
                $res.Reason = 'Windows Update s''est relancé tout seul, rien n''a été supprimé : réessaie plus tard'
            }
        }
    } catch {
        $res.Ok = $false
        # Erreur après le début des suppressions : une partie a pu partir, ne pas laisser croire « rien de fait »
        if ($deleting) { $res.Reason = 'erreur pendant le nettoyage, une partie a pu être supprimée : ' + $_.Exception.Message }
        else { $res.Reason = 'erreur avant le nettoyage, rien n''a été supprimé : ' + $_.Exception.Message }
    } finally {
        # Relance, dans l'ordre inverse de l'arrêt, de ce qui tournait au départ
        foreach ($n in @('bits', 'wuauserv')) {
            if ($wasRunning -notcontains $n) { continue }
            try {
                $s = Get-Service -Name $n
                if ($s.Status -eq 'StopPending') { $s.WaitForStatus('Stopped', [TimeSpan]::FromSeconds(60)); $s.Refresh() }
                if ($s.Status -eq 'Stopped') { $s.Start() }
                $s.WaitForStatus('Running', [TimeSpan]::FromSeconds(60))
            } catch { $res.Restarted = $false }
        }
    }
    return $res
}

function Measure-FolderBounded([string]$Path, [int]$MaxSeconds) {
    # Taille d'un gros dossier (Windows.old), sans suivre les jonctions, arrêtée au bout de $MaxSeconds.
    # Complete = $false si le temps a manqué ou si un sous-dossier était illisible : la taille est un minimum.
    $r = [pscustomobject]@{ Bytes = [int64]0; Complete = $false }
    $sw = [Diagnostics.Stopwatch]::StartNew()
    $stack = New-Object System.Collections.Stack
    $stack.Push($Path)
    $partial = $false
    while ($stack.Count -gt 0) {
        if ($sw.Elapsed.TotalSeconds -ge $MaxSeconds) { return $r }
        $cur = [string]$stack.Pop()
        try {
            foreach ($it in (New-Object IO.DirectoryInfo $cur).EnumerateFileSystemInfos()) {
                if ($it.Attributes -band [IO.FileAttributes]::ReparsePoint) { continue }
                if ($it -is [IO.DirectoryInfo]) { $stack.Push($it.FullName); continue }
                # Place sur le disque (fichiers compressés ou creux comptés pour ce qu'ils occupent)
                $sz = Get-FileDiskSize $it
                if ($null -eq $sz) { $partial = $true } else { $r.Bytes += $sz }
            }
        } catch { $partial = $true }
    }
    $r.Complete = -not $partial
    return $r
}

function Format-Bytes($Bytes) {
    # Taille lisible : « 812 Mo », « 2,3 Go », « moins de 1 Mo ». Fonction pure, testée en T1.
    if ($null -eq $Bytes) { return 'taille inconnue' }
    $b = [double]$Bytes
    if ($b -le 0) { return '0 Mo' }
    if ($b -lt 1MB) { return 'moins de 1 Mo' }
    if ($b -lt 1GB) { return ('{0:N0} Mo' -f ($b / 1MB)) }
    return ('{0:N1} Go' -f ($b / 1GB))
}

function Format-AgedText($M, [string]$AgeText) {
    # Mesure de Measure-AgedFiles en clair : « 1 234 Mo, dont 812 Mo de plus de 24 h ». Fonction pure, testée en T1.
    # Partial (sous-dossier illisible) : « au moins », la mesure n'est pas complète
    if ($null -eq $M -or -not $M.Ok) { return 'lecture impossible' }
    if ($M.Link) { return 'dossier déplacé (lien)' }
    $min = ''
    if ($M.Partial) { $min = 'au moins ' }
    if ((-not $M.Exists -or $M.TotalBytes -eq 0) -and -not $M.Partial) { return '0 Mo' }
    if (-not $AgeText) { return ($min + (Format-Bytes $M.TotalBytes)) }
    return ('{0}{1}, dont {0}{2} {3}' -f $min, (Format-Bytes $M.TotalBytes), (Format-Bytes $M.AgedBytes), $AgeText)
}

function New-CleanTarget([string]$Key, [string]$Label, $Bytes, [bool]$Ok, [bool]$NeedAdmin, [string]$Blocker = '', [bool]$Forced = $false, [string]$Detail = '') {
    # Une cible du nettoyage étendu, telle que mesurée par la section 11. Forced : proposée quelle que soit sa
    # taille (composants Windows, quand DISM conseille le nettoyage). Detail : précision pour la question.
    # MinBytes : seuil propre à la cible quand il dépasse le seuil commun (optimisation de livraison).
    $n = [int64]0
    if ($null -ne $Bytes) { $n = [int64]$Bytes }
    return [pscustomobject]@{ Key = $Key; Label = $Label; Bytes = $n; Ok = $Ok; NeedAdmin = $NeedAdmin; Blocker = $Blocker; Forced = $Forced; Detail = $Detail; MinBytes = [int64]0 }
}

function Get-CleanProposal($Targets, [int64]$MinBytes, [bool]$IsAdmin) {
    # Cibles réellement proposées : lecture réussie, droits suffisants, rien qui l'empêche, et au moins $MinBytes
    # (ou conseillée par Windows), ou le seuil propre à la cible s'il est plus haut. Le total « récupérable » ne
    # compte que celles-là. Fonction pure, testée en T1.
    $keep = @(@($Targets) | Where-Object {
        $min = $MinBytes
        if ($null -ne $_ -and $_.MinBytes -gt $min) { $min = $_.MinBytes }
        $null -ne $_ -and $_.Ok -and (-not $_.NeedAdmin -or $IsAdmin) -and -not $_.Blocker -and ($_.Forced -or $_.Bytes -ge $min)
    })
    $sum = [int64]0
    foreach ($k in $keep) { $sum += [int64]$k.Bytes }
    return [pscustomobject]@{ Items = $keep; Bytes = $sum }
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
        @{ P = [Environment]::GetFolderPath('Windows'); N = 'dossier Windows' },
        @{ P = $env:ProgramData; N = 'ProgramData' },
        @{ P = [Environment]::GetFolderPath('CommonApplicationData'); N = 'ProgramData' },
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
        $allowed = @('JARVIS.cmd', '.jarvis-install', 'jarvis-checkup.ps1', 'Rapports', '.jarvis-update.cmd',
                     'JARVIS.cmd.new', 'JARVIS.cmd.old')
        $other = @(Get-ChildItem -LiteralPath $d -Force | Where-Object { $allowed -notcontains $_.Name })
        if ($other.Count -gt 0) { $r.Reason = 'le dossier existe déjà et contient d''autres fichiers'; return $r }
    }
    $r.Ok = $true
    $r.Path = $d
    return $r
}

function Confirm-InstallDir([string]$Dir) {
    # Dossier d'installation prêt à recevoir JARVIS : chemin valide (Resolve-InstallDir), dossier créé, et
    # modifiable par les seuls administrateurs. Contrôlé AVANT toute copie : un dossier que n'importe quel
    # programme peut modifier est refusé (JARVIS s'y lance en administrateur). Un dossier créé pour l'essai
    # puis refusé est retiré.
    $r = [pscustomobject]@{ Ok = $false; Path = $null; Reason = ''; Created = $false }
    $rv = Resolve-InstallDir $Dir
    if (-not $rv.Ok) { $r.Reason = $rv.Reason; return $r }
    $made = @()
    $p = $rv.Path
    while ($p -and -not (Test-Path -LiteralPath $p)) { $made += $p; $p = Split-Path -Parent $p }
    try { New-Item -ItemType Directory -Path $rv.Path -Force -ErrorAction Stop | Out-Null }
    catch { $r.Reason = 'création du dossier impossible : ' + $_.Exception.Message; return $r }
    $weak = @(Get-WeakWriters @($rv.Path))
    if ($weak.Count -gt 0) {
        foreach ($m in $made) { $null = Remove-EmptyDir $m }      # du plus profond au moins profond
        $r.Reason = 'dossier modifiable sans droits administrateur (' + (Cut ($weak -join ', ') 60) + ')'
        return $r
    }
    $r.Ok = $true
    $r.Path = $rv.Path
    $r.Created = ($made.Count -gt 0)
    return $r
}

function Get-WeakWriters([string[]]$Paths) {
    # Comptes non administrateurs ayant le droit de modifier ces chemins. Des droits illisibles comptent
    # comme un défaut : sans preuve, le chemin n'est pas déclaré protégé.
    $weak = @('S-1-5-32-545', 'S-1-5-11', 'S-1-1-0', ([Security.Principal.WindowsIdentity]::GetCurrent().User.Value))
    $writeMask = 0x2 -bor 0x4 -bor 0x10000 -bor 0x40000 -bor 0x80000 -bor 0x10000000 -bor 0x40000000
    $bad = @()
    foreach ($t in $Paths) {
        if (-not (Test-Path -LiteralPath $t)) { continue }
        $acl = $null
        try { $acl = Get-Acl -LiteralPath $t -ErrorAction Stop } catch { $acl = $null }
        if ($null -eq $acl) { $bad += 'droits illisibles'; continue }
        foreach ($ace in $acl.Access) {
            if ([string]$ace.AccessControlType -ne 'Allow') { continue }
            $sid = $null
            try { $sid = $ace.IdentityReference.Translate([Security.Principal.SecurityIdentifier]).Value } catch {}
            if ($sid -in $weak -and (([int64]$ace.FileSystemRights) -band $writeMask)) { $bad += $ace.IdentityReference.Value }
        }
    }
    return @($bad | Select-Object -Unique)
}

function Get-TallWindowPlacement([int]$Top, [int]$Height, [int]$ClientHeight, [int]$Rows, [int]$WorkTop, [int]$WorkBottom, [int]$WantRows = 50) {
    # Nouvelle position verticale d'une fenêtre de console trop basse, en pixels, ou $null s'il n'y a rien à faire.
    # $Top, $Height : fenêtre actuelle. $ClientHeight : sa zone utile, qui affiche $Rows lignes.
    # $WorkTop, $WorkBottom : zone libre de l'écran (hors barre des tâches). La fenêtre grandit jusqu'à
    # $WantRows lignes environ, sans jamais dépasser l'écran ni rétrécir. Fonction pure, testée en T1.
    if ($Rows -le 0 -or $Rows -ge $WantRows -or $ClientHeight -le 0 -or $Height -le 0) { return $null }
    $workH = $WorkBottom - $WorkTop
    if ($workH -le 0) { return $null }
    $newH = [int][math]::Ceiling($Height + ($WantRows - $Rows) * ($ClientHeight / $Rows))
    if ($newH -gt $workH) { $newH = $workH }
    if ($newH -le $Height) { return $null }
    $newTop = $Top
    if ($newTop + $newH -gt $WorkBottom) { $newTop = $WorkBottom - $newH }
    if ($newTop -lt $WorkTop) { $newTop = $WorkTop }
    return [pscustomobject]@{ Top = $newTop; Height = $newH }
}

function Format-WinRect([int]$X, [int]$Y, [int]$W, [int]$H) {
    # Place et taille d'une fenêtre écrites pour l'argument -WinRect (exemple : R226_234_1200_1053). Le texte
    # commence par une lettre (une coordonnée négative serait prise pour un nom de paramètre) et n'a pas de
    # virgule (l'en-tête de JARVIS.cmd en ferait une liste). Fonction pure, testée en T1.
    return ('R{0}_{1}_{2}_{3}' -f $X, $Y, $W, $H)
}

function ConvertFrom-WinRect([string]$Text) {
    # Lecture stricte du texte de Format-WinRect : X, Y, W, H, ou $null. Fonction pure, testée en T1.
    if ($Text -notmatch '^R(-?\d{1,5})_(-?\d{1,5})_(\d{1,5})_(\d{1,5})$') { return $null }
    return [pscustomobject]@{ X = [int]$Matches[1]; Y = [int]$Matches[2]; W = [int]$Matches[3]; H = [int]$Matches[4] }
}

function Get-RestoredPlacement($Rect, [int]$WorkLeft, [int]$WorkTop, [int]$WorkRight, [int]$WorkBottom) {
    # Place et taille reprises d'une fenêtre précédente ($Rect : X, Y, W, H), ramenées dans la zone libre de
    # l'écran (hors barre des tâches). $null si la taille est absurde. Fonction pure, testée en T1.
    if ($null -eq $Rect) { return $null }
    $ww = $WorkRight - $WorkLeft
    $wh = $WorkBottom - $WorkTop
    $x = [int]$Rect.X; $y = [int]$Rect.Y; $w = [int]$Rect.W; $h = [int]$Rect.H
    if ($ww -le 0 -or $wh -le 0 -or $w -lt 200 -or $h -lt 150) { return $null }
    if ($w -gt $ww) { $w = $ww }
    if ($h -gt $wh) { $h = $wh }
    if ($x + $w -gt $WorkRight) { $x = $WorkRight - $w }
    if ($x -lt $WorkLeft) { $x = $WorkLeft }
    if ($y + $h -gt $WorkBottom) { $y = $WorkBottom - $h }
    if ($y -lt $WorkTop) { $y = $WorkTop }
    return [pscustomobject]@{ X = $x; Y = $y; W = $w; H = $h }
}

function Get-ClassicConsolePlacement([int]$CurX, [int]$CurY, [int]$CurW, [int]$CurH, [int]$WorkLeft, [int]$WorkTop, [int]$WorkRight, [int]$WorkBottom) {
    # Ancienne console de Windows ouverte sans fenêtre précédente à reprendre (raccourci lancé en administrateur) :
    # mêmes proportions que la fenêtre validée par Thomas pendant les essais du 19/11/2026 (1 200 x 1 053 pixels
    # pour une zone libre de 2 560 x 1 392), jamais plus petite que la fenêtre actuelle, toujours dans l'écran.
    # $null s'il n'y a rien à faire. Fonction pure, testée en T1.
    $ww = $WorkRight - $WorkLeft
    $wh = $WorkBottom - $WorkTop
    if ($ww -le 0 -or $wh -le 0 -or $CurW -le 0 -or $CurH -le 0) { return $null }
    $w = [int][math]::Round($ww * 1200 / 2560)
    $h = [int][math]::Round($wh * 1053 / 1392)
    if ($w -lt $CurW) { $w = $CurW }
    if ($h -lt $CurH) { $h = $CurH }
    if ($w -eq $CurW -and $h -eq $CurH) { return $null }
    return (Get-RestoredPlacement ([pscustomobject]@{ X = $CurX; Y = $CurY; W = $w; H = $h }) $WorkLeft $WorkTop $WorkRight $WorkBottom)
}

function Get-ConsoleFontPlan([int]$CurrentHeight, [int]$Family, [string]$Face) {
    # Police à essayer dans l'ancienne console : nom, famille et hauteurs, de la plus grande à la plus petite, ou
    # $null s'il n'y a rien à faire. 20 pixels donne à peu près l'affichage de Windows Terminal (mesuré le
    # 19/11/2026 dans une fenêtre de 1 200 x 1 053 : Consolas 16 = 145 x 63, 18 = 145 x 56, 20 = 129 x 50).
    # Police bitmap (bit 0x4 de la famille absent) : c'est « Terminal » 8 x 12 que l'ancienne console prend après
    # le « chcp 65001 » de JARVIS.cmd (relevé le 19/11/2026), d'où des lettres minuscules ; elle est remplacée
    # par Consolas, présente sur tout Windows. Police TrueType : même police, seulement plus grande.
    # Fonction pure, testée en T1.
    if ($CurrentHeight -le 0) { return $null }
    if (($Family -band 0x4) -eq 0) { return [pscustomobject]@{ Face = 'Consolas'; Family = 0x36; Heights = @(20, 18, 16) } }
    $hs = @(@(20, 18) | Where-Object { $_ -gt $CurrentHeight })
    if ($hs.Count -eq 0) { return $null }
    return [pscustomobject]@{ Face = $Face; Family = $Family; Heights = $hs }
}

function Initialize-NativeWin {
    # Fonctions de Windows pour lire et placer la fenêtre (chargées une seule fois)
    if ('JarvisNative.Win' -as [type]) { return $true }
    try {
        Add-Type -Namespace JarvisNative -Name Win -MemberDefinition @'
[StructLayout(LayoutKind.Sequential)] public struct RECT { public int Left; public int Top; public int Right; public int Bottom; }
[StructLayout(LayoutKind.Sequential)] public struct POINT { public int X; public int Y; }
[StructLayout(LayoutKind.Sequential)] public struct MONITORINFO { public int cbSize; public RECT rcMonitor; public RECT rcWork; public uint dwFlags; }
[DllImport("kernel32.dll")] public static extern IntPtr GetConsoleWindow();
[DllImport("user32.dll")] public static extern IntPtr GetAncestor(IntPtr hwnd, uint flags);
[DllImport("user32.dll")] public static extern bool GetWindowRect(IntPtr hwnd, out RECT r);
[DllImport("user32.dll")] public static extern bool GetClientRect(IntPtr hwnd, out RECT r);
[DllImport("user32.dll")] public static extern bool IsZoomed(IntPtr hwnd);
[DllImport("user32.dll")] public static extern bool IsIconic(IntPtr hwnd);
[DllImport("user32.dll")] public static extern bool IsWindowVisible(IntPtr hwnd);
[DllImport("user32.dll")] public static extern IntPtr MonitorFromWindow(IntPtr hwnd, uint flags);
[DllImport("user32.dll")] public static extern IntPtr MonitorFromPoint(POINT pt, uint flags);
[DllImport("user32.dll")] public static extern bool GetMonitorInfo(IntPtr hmon, ref MONITORINFO mi);
[DllImport("user32.dll")] public static extern bool SetWindowPos(IntPtr hwnd, IntPtr after, int x, int y, int cx, int cy, uint flags);
[DllImport("user32.dll", CharSet = CharSet.Unicode)] public static extern int GetClassName(IntPtr hwnd, System.Text.StringBuilder name, int max);
[StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)] public struct FONTEX { public uint cbSize; public uint nFont; public short Width; public short Height; public int Family; public int Weight; [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 32)] public string Face; }
[DllImport("kernel32.dll")] public static extern IntPtr GetStdHandle(int which);
[DllImport("kernel32.dll")] public static extern bool GetCurrentConsoleFontEx(IntPtr h, bool maxWindow, ref FONTEX font);
[DllImport("kernel32.dll")] public static extern bool SetCurrentConsoleFontEx(IntPtr h, bool maxWindow, ref FONTEX font);
'@
        return $true
    } catch { return $false }
}

function Get-JarvisWindow {
    # Fenêtre réellement affichée, ou zéro. Dans Windows Terminal, la fenêtre de console est cachée : la vraie
    # fenêtre est son propriétaire. Rien si elle est invisible (sortie redirigée), en plein écran ou réduite.
    if (-not (Initialize-NativeWin)) { return [IntPtr]::Zero }
    $con = [JarvisNative.Win]::GetConsoleWindow()
    if ($con -eq [IntPtr]::Zero) { return [IntPtr]::Zero }
    $win = [JarvisNative.Win]::GetAncestor($con, 3)
    if ($win -eq [IntPtr]::Zero) { $win = $con }
    if (-not [JarvisNative.Win]::IsWindowVisible($win)) { return [IntPtr]::Zero }
    if ([JarvisNative.Win]::IsZoomed($win) -or [JarvisNative.Win]::IsIconic($win)) { return [IntPtr]::Zero }
    return $win
}

function Initialize-NativeFocus {
    # Fonctions de Windows pour signaler une question (chargées une seule fois). FLASHWINFO : 32 octets en 64 bits,
    # 20 en 32 bits (règle 28, contrôlé en T1) ; cbSize est pris par Marshal.SizeOf.
    if ('JarvisNative.Focus' -as [type]) { return $true }
    try {
        Add-Type -Namespace JarvisNative -Name Focus -MemberDefinition @'
[StructLayout(LayoutKind.Sequential)] public struct FLASHWINFO { public uint cbSize; public IntPtr hwnd; public uint dwFlags; public uint uCount; public uint dwTimeout; }
[DllImport("user32.dll")] public static extern IntPtr GetForegroundWindow();
[DllImport("user32.dll")] public static extern bool FlashWindowEx(ref FLASHWINFO fi);
'@
        return $true
    } catch { return $false }
}

function Request-Attention {
    # v3.26 (demande de Thomas, 24/11/2026 : une question attendait parfois longtemps derrière d'autres fenêtres).
    # Avant chaque question, si la fenêtre de JARVIS n'est pas au premier plan : elle repasse devant les autres
    # fenêtres SANS prendre le clavier (passage « toujours visible » puis retour, SWP_NOACTIVATE), et son bouton
    # clignote dans la barre des tâches jusqu'à ce qu'on y revienne. On clique dessus pour répondre.
    # Relevés du 24/11/2026 sur le PC de Thomas :
    # - SetForegroundWindow est refusé à un programme qui n'a pas reçu la dernière action au clavier ou à la souris,
    #   quel que soit le temps d'inactivité (scan complet de 4 min sans toucher au PC : JARVIS restait derrière) ;
    #   appelé quand même avant la remise devant, Windows donnait ensuite le clavier à JARVIS : jamais appelé ici ;
    # - remise devant sans activation : fenêtre visible devant, clavier resté dans l'autre fenêtre, dans l'ancienne
    #   console comme dans Windows Terminal ;
    # - fenêtre réduite : la restaurer (même SW_SHOWNOACTIVATE) lui donnait le clavier : elle reste réduite, seul
    #   son bouton clignote.
    # Aucun contournement du verrou de Windows (Alt simulé, AttachThreadInput) : la frappe destinée à une autre
    # fenêtre répondrait à JARVIS. Limite : dans Windows Terminal, un onglet caché d'une fenêtre déjà au premier plan
    # ne reçoit aucun signal. Rend NONE, SHOWN (remise devant et clignotement) ou FLASH (clignotement seul).
    if ($script:AttentionOff) { return 'NONE' }
    try {
        if (-not (Initialize-NativeWin) -or -not (Initialize-NativeFocus)) {
            # Chargement refusé (antivirus qui bloque la compilation...) : pas de nouvel essai à chaque question
            $script:AttentionOff = $true
            return 'NONE'
        }
        $con = [JarvisNative.Win]::GetConsoleWindow()
        if ($con -eq [IntPtr]::Zero) { return 'NONE' }
        # Windows Terminal : la fenêtre affichée est le propriétaire de la fenêtre de console (règle 26)
        $win = [JarvisNative.Win]::GetAncestor($con, 3)
        if ($win -eq [IntPtr]::Zero) { $win = $con }
        if (-not [JarvisNative.Win]::IsWindowVisible($win)) { return 'NONE' }
        if ([JarvisNative.Focus]::GetForegroundWindow() -eq $win) { return 'NONE' }
        $res = 'FLASH'
        if (-not [JarvisNative.Win]::IsIconic($win)) {
            # SWP_NOSIZE (1) + SWP_NOMOVE (2) + SWP_NOACTIVATE (0x10) ; HWND_TOPMOST (-1) puis HWND_NOTOPMOST (-2) :
            # la fenêtre reste au-dessus des fenêtres ordinaires sans rester « toujours visible »
            $null = [JarvisNative.Win]::SetWindowPos($win, [IntPtr](-1), 0, 0, 0, 0, [uint32]0x13)
            $null = [JarvisNative.Win]::SetWindowPos($win, [IntPtr](-2), 0, 0, 0, 0, [uint32]0x13)
            $res = 'SHOWN'
        }
        $fi = New-Object JarvisNative.Focus+FLASHWINFO
        $fi.cbSize = [uint32][Runtime.InteropServices.Marshal]::SizeOf($fi)
        $fi.hwnd = $win
        $fi.dwFlags = [uint32]15   # FLASHW_ALL (3) + FLASHW_TIMERNOFG (12) : jusqu'au retour au premier plan
        $null = [JarvisNative.Focus]::FlashWindowEx([ref]$fi)
        return $res
    } catch { return 'NONE' }
}

function Get-WinRectArg {
    # Argument ajouté à une relance de cette même version (administrateur, installation) : la nouvelle fenêtre
    # reprend la place et la taille de celle-ci. Constaté le 19/11/2026 : relancé en administrateur depuis
    # Windows Terminal, JARVIS s'ouvre dans l'ancienne console de Windows, 50 lignes mais une police plus
    # petite (839 pixels de haut au lieu de 1 053) ; Set-ConsoleTall la jugeait assez haute. '' : rien à transmettre.
    try {
        $win = Get-JarvisWindow
        if ($win -eq [IntPtr]::Zero) { return '' }
        $wr = New-Object JarvisNative.Win+RECT
        if (-not [JarvisNative.Win]::GetWindowRect($win, [ref]$wr)) { return '' }
        return (' -WinRect ' + (Format-WinRect $wr.Left $wr.Top ($wr.Right - $wr.Left) ($wr.Bottom - $wr.Top)))
    } catch { return '' }
}

function Set-ConsoleRect([string]$Text) {
    # Reprend la place et la taille transmises par -WinRect, sur l'écran où était la fenêtre d'avant.
    # $false si rien n'a été fait (texte illisible, fenêtre invisible, en plein écran ou réduite).
    try {
        $rect = ConvertFrom-WinRect $Text
        if ($null -eq $rect) { return $false }
        $win = Get-JarvisWindow
        if ($win -eq [IntPtr]::Zero) { return $false }
        $pt = New-Object JarvisNative.Win+POINT
        $pt.X = $rect.X + [int]($rect.W / 2)
        $pt.Y = $rect.Y + [int]($rect.H / 2)
        $mi = New-Object JarvisNative.Win+MONITORINFO
        $mi.cbSize = [Runtime.InteropServices.Marshal]::SizeOf($mi)
        if (-not [JarvisNative.Win]::GetMonitorInfo([JarvisNative.Win]::MonitorFromPoint($pt, 2), [ref]$mi)) { return $false }
        $pl = Get-RestoredPlacement $rect $mi.rcWork.Left $mi.rcWork.Top $mi.rcWork.Right $mi.rcWork.Bottom
        if ($null -eq $pl) { return $false }
        # 0x14 : ordre d'empilement inchangé, fenêtre non activée
        return [JarvisNative.Win]::SetWindowPos($win, [IntPtr]::Zero, $pl.X, $pl.Y, $pl.W, $pl.H, 0x14)
    } catch { return $false }
}

function Set-ConsoleClassicSize {
    # Ancienne console de Windows (classe ConsoleWindowClass). Windows Terminal ne s'ouvre pas pour une application
    # lancée en administrateur : les raccourcis de JARVIS ouvrent donc cette console, à ses réglages d'origine
    # (relevé le 19/11/2026 : 993 x 639 pixels, que Set-ConsoleTall laissait tels quels). Elle prend les proportions
    # de la fenêtre des essais (Get-ClassicConsolePlacement). $false si ce n'est pas elle ou si rien n'a été fait.
    try {
        $win = Get-JarvisWindow
        if ($win -eq [IntPtr]::Zero) { return $false }
        $cls = New-Object System.Text.StringBuilder 64
        $null = [JarvisNative.Win]::GetClassName($win, $cls, 64)
        if ($cls.ToString() -ne 'ConsoleWindowClass') { return $false }
        $wr = New-Object JarvisNative.Win+RECT
        if (-not [JarvisNative.Win]::GetWindowRect($win, [ref]$wr)) { return $false }
        $mi = New-Object JarvisNative.Win+MONITORINFO
        $mi.cbSize = [Runtime.InteropServices.Marshal]::SizeOf($mi)
        if (-not [JarvisNative.Win]::GetMonitorInfo([JarvisNative.Win]::MonitorFromWindow($win, 2), [ref]$mi)) { return $false }
        $pl = Get-ClassicConsolePlacement $wr.Left $wr.Top ($wr.Right - $wr.Left) ($wr.Bottom - $wr.Top) $mi.rcWork.Left $mi.rcWork.Top $mi.rcWork.Right $mi.rcWork.Bottom
        if ($null -eq $pl) { return $false }
        # 0x14 : ordre d'empilement inchangé, fenêtre non activée
        return [JarvisNative.Win]::SetWindowPos($win, [IntPtr]::Zero, $pl.X, $pl.Y, $pl.W, $pl.H, 0x14)
    } catch { return $false }
}

function Set-ConsoleFontBigger {
    # Ancienne console seulement (demande de Thomas le 19/11/2026 : « la taille de la police un poil plus grande ») :
    # police agrandie pour cette fenêtre (rien n'est changé dans les réglages de Windows), la fenêtre gardant sa
    # taille. Une taille est gardée si JARVIS dispose encore d'au moins 110 colonnes, sinon la suivante est essayée,
    # sinon la police d'origine est remise. La police d'origine est retenue pour être remise en partant.
    try {
        $win = Get-JarvisWindow
        if ($win -eq [IntPtr]::Zero) { return $false }
        $cls = New-Object System.Text.StringBuilder 64
        $null = [JarvisNative.Win]::GetClassName($win, $cls, 64)
        if ($cls.ToString() -ne 'ConsoleWindowClass') { return $false }
        $out = [JarvisNative.Win]::GetStdHandle(-11)
        $orig = New-Object JarvisNative.Win+FONTEX
        $orig.cbSize = [Runtime.InteropServices.Marshal]::SizeOf($orig)
        if (-not [JarvisNative.Win]::GetCurrentConsoleFontEx($out, $false, [ref]$orig)) { return $false }
        $plan = Get-ConsoleFontPlan $orig.Height $orig.Family $orig.Face
        if ($null -eq $plan) { return $false }
        $wr = New-Object JarvisNative.Win+RECT
        if (-not [JarvisNative.Win]::GetWindowRect($win, [ref]$wr)) { return $false }
        $script:ConFontSaved = $orig
        $steps = @($plan.Heights | ForEach-Object { [pscustomobject]@{ Face = $plan.Face; Family = $plan.Family; Width = 0; Height = $_; Last = $false } })
        $steps += [pscustomobject]@{ Face = $orig.Face; Family = $orig.Family; Width = $orig.Width; Height = [int]$orig.Height; Last = $true }
        foreach ($s in $steps) {
            # Structure neuve à chaque essai : la police d'origine retenue ne doit jamais être modifiée
            $f = New-Object JarvisNative.Win+FONTEX
            $f.cbSize = $orig.cbSize; $f.Family = $s.Family; $f.Weight = $orig.Weight; $f.Face = $s.Face
            $f.Width = [int16]$s.Width
            $f.Height = [int16]$s.Height
            if (-not [JarvisNative.Win]::SetCurrentConsoleFontEx($out, $false, [ref]$f)) { continue }
            # La console garde ses colonnes et ses lignes en changeant de police : la fenêtre reprend sa taille
            $null = [JarvisNative.Win]::SetWindowPos($win, [IntPtr]::Zero, $wr.Left, $wr.Top, ($wr.Right - $wr.Left), ($wr.Bottom - $wr.Top), 0x14)
            Start-Sleep -Milliseconds 100
            if ($s.Last) { $script:ConFontSaved = $null; return $false }
            if ([Console]::WindowWidth -ge 110) { return $true }
        }
        return $false
    } catch { return $false }
}

function Restore-ConsoleFont {
    # Police d'origine remise en partant (utile si JARVIS a été lancé dans une console déjà ouverte)
    if ($null -eq $script:ConFontSaved) { return }
    try {
        $o = $script:ConFontSaved
        $f = New-Object JarvisNative.Win+FONTEX
        $f.cbSize = $o.cbSize; $f.Family = $o.Family; $f.Weight = $o.Weight; $f.Face = $o.Face; $f.Width = $o.Width; $f.Height = $o.Height
        $null = [JarvisNative.Win]::SetCurrentConsoleFontEx([JarvisNative.Win]::GetStdHandle(-11), $false, [ref]$f)
    } catch { $script:ConFontSaved = $null }
}

function Set-ConsoleTall {
    # Agrandit la fenêtre en hauteur (30 lignes d'origine : le scan défile trop vite pour être lu).
    # Marche dans Windows Terminal comme dans la console classique : c'est la fenêtre elle-même qui est
    # redimensionnée, largeur et position horizontale inchangées. Rien n'est fait si la fenêtre est
    # agrandie en plein écran, réduite, invisible (sortie redirigée) ou déjà assez haute.
    try {
        $rows = [Console]::WindowHeight
        $win = Get-JarvisWindow
        if ($win -eq [IntPtr]::Zero) { return $false }
        $wr = New-Object JarvisNative.Win+RECT
        $cr = New-Object JarvisNative.Win+RECT
        if (-not [JarvisNative.Win]::GetWindowRect($win, [ref]$wr)) { return $false }
        if (-not [JarvisNative.Win]::GetClientRect($win, [ref]$cr)) { return $false }
        $mi = New-Object JarvisNative.Win+MONITORINFO
        $mi.cbSize = [Runtime.InteropServices.Marshal]::SizeOf($mi)
        $mon = [JarvisNative.Win]::MonitorFromWindow($win, 2)
        if (-not [JarvisNative.Win]::GetMonitorInfo($mon, [ref]$mi)) { return $false }
        $pl = Get-TallWindowPlacement $wr.Top ($wr.Bottom - $wr.Top) ($cr.Bottom - $cr.Top) $rows $mi.rcWork.Top $mi.rcWork.Bottom
        if ($null -eq $pl) { return $false }
        # 0x14 : ordre d'empilement inchangé, fenêtre non activée
        return [JarvisNative.Win]::SetWindowPos($win, [IntPtr]::Zero, $wr.Left, $pl.Top, ($wr.Right - $wr.Left), $pl.Height, 0x14)
    } catch { return $false }
}

function Get-NoQuickEditMode([uint32]$Mode) {
    # Mode de la console sans sélection à la souris : ENABLE_QUICK_EDIT_MODE (0x40) retiré et
    # ENABLE_EXTENDED_FLAGS (0x80) ajouté, sans quoi Windows ignore le changement. v3.27 : ENABLE_MOUSE_INPUT (0x10)
    # retiré aussi. Sans sélection et avec lui, la console envoie la molette au programme au lieu de défiler
    # (essai du 26/11/2026 dans l'ancienne console : 0x1B7 ne défile pas, 0x1A7 et 0x1F7 défilent de 9 lignes).
    # JARVIS ne lit pas la souris. Fonction pure, testée en T1.
    return [uint32](([int64]$Mode -band 0xFFFFFFAFL) -bor 0x80)
}

function Get-QuickEditRestoreMode([uint32]$Current, [uint32]$Saved) {
    # Mode à remettre en partant : le mode actuel (Ctrl+C a pu être réglé entre-temps), avec la sélection à
    # la souris seulement si elle était active au départ, et la souris rendue au programme seulement si elle
    # l'était (v3.27). Fonction pure, testée en T1.
    $r = [int64]$Current
    if (([int64]$Saved -band 0x40) -ne 0) { $r = $r -bor 0xC0 }
    if (([int64]$Saved -band 0x10) -ne 0) { $r = $r -bor 0x10 }
    return [uint32]$r
}

function Set-QuickEdit([bool]$Off) {
    # Ancienne console de Windows (celle de la relance en administrateur) : un clic dans la fenêtre la met en
    # mode « Sélection », qui gèle l'affichage et JARVIS avec lui (constaté le 19/11/2026 pendant une mise à
    # jour du Store : compteur figé, titre « Sélection J.A.R.V.I.S. »). Ce mode est coupé pendant que JARVIS
    # tourne ($Off = $true), puis remis s'il était actif ($Off = $false). Sans effet dans Windows Terminal.
    try {
        if (-not ('JarvisNative.ConMode' -as [type])) {
            Add-Type -Namespace JarvisNative -Name ConMode -MemberDefinition @'
[DllImport("kernel32.dll")] public static extern IntPtr GetStdHandle(int n);
[DllImport("kernel32.dll")] public static extern bool GetConsoleMode(IntPtr h, out uint m);
[DllImport("kernel32.dll")] public static extern bool SetConsoleMode(IntPtr h, uint m);
'@
        }
        $h = [JarvisNative.ConMode]::GetStdHandle(-10)
        $m = [uint32]0
        if (-not [JarvisNative.ConMode]::GetConsoleMode($h, [ref]$m)) { return $false }
        if ($Off) {
            $script:ConModeSaved = $m
            $new = Get-NoQuickEditMode $m
            if ($new -eq $m) { return $true }
            return [JarvisNative.ConMode]::SetConsoleMode($h, $new)
        }
        if ($null -eq $script:ConModeSaved) { return $false }
        $back = Get-QuickEditRestoreMode $m ([uint32]$script:ConModeSaved)
        if ($back -eq $m) { return $true }
        return [JarvisNative.ConMode]::SetConsoleMode($h, $back)
    } catch { return $false }
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
    # Conditions sûres pour SFC / DISM / CHKDSK. Rend GO (lancer), QUICK (scan rapide demandé par la touche R) ou
    # MENU (non ou annulation : retour au menu). v3.27 : avant, un « non » lançait le scan rapide sans le demander
    # (retour d'un utilisateur, 25/11/2026).
    $st = Get-PowerSource
    while ($st -eq 'BATTERY') {
        Write-Host '   [!] PC sur batterie : une coupure pendant SFC ou DISM peut interrompre une réparation de Windows.' -ForegroundColor Yellow
        $a = Read-Answer '   >> Branche le chargeur puis appuie sur Entrée, ou tape R pour un scan rapide (Échap = retour au menu)'
        if ($null -eq $a) { return 'MENU' }
        if ($a -match '^[rR]') { return 'QUICK' }
        $st = Get-PowerSource
    }
    if ($st -eq 'UNKNOWN') {
        Write-Host '   [!] Impossible de savoir si le PC est sur secteur : une coupure pendant SFC ou DISM peut interrompre une réparation.' -ForegroundColor Yellow
        Write-Host '       Sur un PC portable, branche le chargeur avant de continuer.' -ForegroundColor Yellow
        if (-not (Read-YesNo '   >> Continuer le scan complet (chargeur branché, ou PC fixe) ?')) { return 'MENU' }
    }
    $reasons = @()
    $rebootPending = (Test-Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending') -or
        (Test-Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired')
    if ($rebootPending) { $reasons += 'un redémarrage est en attente' }
    if (Get-Process TiWorker) { $reasons += 'Windows Update installe des composants en ce moment' }
    if ($reasons.Count -gt 0) {
        Write-Host ('   [!] ' + ($reasons -join ' et ') + '.') -ForegroundColor Yellow
        Write-Host '       SFC et DISM risquent d''échouer ou de donner un résultat faux. Redémarrer d''abord est conseillé.' -ForegroundColor Yellow
        if ($rebootPending) {
            # Relevé le 21/11/2026 dans CBS.log : après un simple « Redémarrer », « Deferring shutdown processing
            # at users request », la mise à jour reste en attente et l'avertissement revient.
            Write-Host '       Choisis Démarrer > Marche/Arrêt > « Mettre à jour et redémarrer » si ce choix est affiché :' -ForegroundColor Yellow
            Write-Host '       un simple « Redémarrer » peut laisser les mises à jour en attente.' -ForegroundColor Yellow
        }
        if (-not (Read-YesNo '   >> Continuer quand même le scan complet ?')) { return 'MENU' }
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
    if (Read-YesNo '   >> Lancer le scan complet ?' -DefaultYes) { return 'GO' }
    return 'MENU'
}

# ------------------------------------------------------------------
# Préférences mémorisées (%APPDATA%\JARVIS\config.json)
# ------------------------------------------------------------------
function ConvertFrom-JarvisConfigText([string]$Json) {
    # Lecture de config.json. Fonction pure, testée en T1. Seules les valeurs simples sont gardées (texte de
    # 200 caractères au plus, nombre, vrai/faux) ; un fichier illisible ou d'une autre forme ne donne rien.
    $h = @{}
    $o = $null
    try { $o = $Json | ConvertFrom-Json -ErrorAction Stop } catch { return $h }
    if ($null -eq $o -or $o -is [string] -or $o -is [array] -or $o -is [ValueType]) { return $h }
    foreach ($pr in $o.PSObject.Properties) {
        $v = $pr.Value
        if ($v -is [string]) { if ($v.Length -le 200) { $h[$pr.Name] = $v } }
        elseif ($v -is [bool] -or $v -is [int] -or $v -is [long] -or $v -is [double] -or $v -is [decimal]) { $h[$pr.Name] = $v }
    }
    return $h
}

function Get-JarvisConfig {
    if (-not (Test-Path -LiteralPath $CfgFile)) { return @{} }
    $txt = $null
    try { $txt = Get-Content -LiteralPath $CfgFile -Raw -Encoding UTF8 -ErrorAction Stop } catch { return @{} }
    return (ConvertFrom-JarvisConfigText $txt)
}

function Set-JarvisConfigValue([string]$Key, $Value) {
    # Modifie une seule clé en conservant les autres ; $null supprime la clé.
    # Écriture dans un fichier voisin puis remplacement (jamais de config.json à moitié écrit),
    # et $true seulement si la valeur est relue.
    try {
        $h = Get-JarvisConfig
        if ($null -eq $Value) { $h.Remove($Key) } else { $h[$Key] = $Value }
        if (-not (Test-Path -LiteralPath $CfgDir)) { New-Item -ItemType Directory -Path $CfgDir -Force -ErrorAction Stop | Out-Null }
        $tmp = $CfgFile + '.tmp'
        ([pscustomobject]$h) | ConvertTo-Json | Set-Content -LiteralPath $tmp -Encoding UTF8 -ErrorAction Stop
        Move-Item -LiteralPath $tmp -Destination $CfgFile -Force -ErrorAction Stop
        $back = Get-JarvisConfig
        if ($null -eq $Value) { return (-not $back.ContainsKey($Key)) }
        return ($back.ContainsKey($Key) -and [string]$back[$Key] -eq [string]$Value)
    } catch { return $false }
}

# ------------------------------------------------------------------
# Module winget (facultatif)
# ------------------------------------------------------------------
function Test-WingetModule { return [bool](Get-Module -ListAvailable -Name Microsoft.WinGet.Client) }

function Get-WingetExeCandidates {
    # Chemins possibles de winget.exe, le plus récent d'abord, tirés des paquets « Programme d'installation
    # d'application » (Get-AppxPackage). Seulement le paquet de Microsoft installé sous <Program Files>\WindowsApps,
    # que seul Windows peut modifier. Appelé par son nom, winget passait par le PATH et par l'alias du dossier
    # %LOCALAPPDATA%\Microsoft\WindowsApps, que le compte peut remplacer (v3.24, constat S2). Fonction pure, T1.
    param($Packages, [string]$ProgramFiles)
    if (-not $ProgramFiles) { return @() }
    $base = $ProgramFiles.TrimEnd('\') + '\WindowsApps\'
    $ok = @(@($Packages) | Where-Object {
        $null -ne $_ -and [string]$_.PackageFamilyName -eq 'Microsoft.DesktopAppInstaller_8wekyb3d8bbwe' -and
        ([string]$_.InstallLocation).StartsWith($base, [StringComparison]::OrdinalIgnoreCase) -and
        ([string]$_.InstallLocation).IndexOf('..') -lt 0
    })
    $sorted = @($ok | Sort-Object { $v = $null; if ([version]::TryParse([string]$_.Version, [ref]$v)) { $v } else { [version]'0.0' } } -Descending)
    return @($sorted | ForEach-Object { ([string]$_.InstallLocation).TrimEnd('\') + '\winget.exe' })
}

function Get-WingetPath {
    # winget.exe par son chemin complet, lu une fois par session ; $null si introuvable.
    # $script:WingetLookup : OK, ABSENT (aucun paquet) ou UNREADABLE (lecture des paquets en échec).
    if ($script:WingetLookup) { return $script:WingetExe }
    $script:WingetExe = $null
    $pk = $null
    try { $pk = @(Get-AppxPackage -Name 'Microsoft.DesktopAppInstaller' -ErrorAction Stop) }
    catch { $script:WingetLookup = 'UNREADABLE'; return $null }
    foreach ($c in (Get-WingetExeCandidates $pk (Get-ProgramFilesDir))) {
        if (Test-Path -LiteralPath $c -PathType Leaf) { $script:WingetExe = $c; break }
    }
    if ($script:WingetExe) { $script:WingetLookup = 'OK' } else { $script:WingetLookup = 'ABSENT' }
    return $script:WingetExe
}

function Test-ShowWingetOffer {
    if (-not $isAdmin) { return $false }
    if (Test-WingetModule) { return $false }
    if (-not (Get-WingetPath)) { return $false }
    $c = Get-JarvisConfig
    return ([string]$c['WingetModule'] -ne 'never')
}

function Install-WingetModule {
    # Accès contrôlé actif et dossier absent : l'installateur de Microsoft (PowerShellGet) va tenter de créer un
    # dossier vide dans Documents et Windows va le signaler. Prévenir avant, pour que personne ne clique sur
    # « Autoriser » (cela autoriserait tout PowerShell, vu le 21/11/2026).
    $cfaNow = 'UNKNOWN'
    $mpp = Get-MpPreference
    if ($mpp) { $cfaNow = Get-CfaVerdict $mpp.EnableControlledFolderAccess }
    $docs = [Environment]::GetFolderPath('MyDocuments')
    if ($docs -and (Test-CfaNoticeExpected $cfaNow (Test-Path -LiteralPath (Join-Path $docs 'WindowsPowerShell\Scripts\InstalledScriptInfos')))) {
        Write-Host '   [i] Sécurité Windows peut afficher « Modification non autorisée bloquée » pour PowerShell.' -ForegroundColor Yellow
        Write-Host '       C''est attendu et sans danger : l''installateur de Microsoft tente de créer un dossier vide' -ForegroundColor Gray
        Write-Host '       dans Documents, l''accès contrôlé aux dossiers le refuse, et le module s''installe quand même.' -ForegroundColor Gray
        Write-Host '       Ferme simplement la notification. Ne clique pas sur « Autoriser » : tous les scripts' -ForegroundColor Gray
        Write-Host '       PowerShell pourraient alors modifier tes documents.' -ForegroundColor Gray
    }
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
    $a = Read-Choice '   >> Choix [O/N/J] (Entrée = N)' @('O', 'N', 'J') 'N'
    if ($a -eq 'J') {
        if (Set-JarvisConfigValue 'WingetModule' 'never') {
            Write-Host '   >> Compris, cette proposition ne réapparaîtra plus.' -ForegroundColor DarkGray
            Write-Host '      Pour changer d''avis : JARVIS.cmd -ResetChoices' -ForegroundColor DarkGray
        } else {
            Write-Host '   [!] Choix non enregistré (profil inaccessible en écriture).' -ForegroundColor Yellow
        }
    } elseif ($a -eq 'O') {
        $null = Install-WingetModule
    } else {
        Write-Host '   >> Pas de souci, l''option reste disponible dans le menu.' -ForegroundColor DarkGray
    }
    Write-Host ''
}

# ------------------------------------------------------------------
# Windows Update : installation par J.A.R.V.I.S. (API officielle Windows Update Agent)
# ------------------------------------------------------------------
function Test-WuDefinitionUpdate {
    # Vrai pour une mise à jour des signatures de Microsoft Defender : catégorie « Definition Updates »
    # (e0789628-ce08-4437-be74-2495b842f43b) ou article KB2267602. Le titre français écrit « Ko » : relevé le
    # 21/11/2026, « Mise à jour de la sélection disjointe pour Microsoft Defender Antivirus - 2267602 Ko
    # (version 1.463.399.0) », d'où la recherche du seul numéro. T1.
    param($Update)
    if ($null -eq $Update) { return $false }
    if ($Update.PSObject.Properties['Categories']) {
        foreach ($c in @($Update.Categories)) {
            if ($null -ne $c -and $c.PSObject.Properties['CategoryID'] -and [string]$c.CategoryID -eq 'e0789628-ce08-4437-be74-2495b842f43b') { return $true }
        }
    }
    if ($Update.PSObject.Properties['KBs'] -and @($Update.KBs) -contains '2267602') { return $true }
    if (-not $Update.PSObject.Properties['Title']) { return $false }
    return ([string]$Update.Title -match '(^|\D)2267602(\D|$)')
}

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

function Get-DriverOffer {
    # Pilote proposé par Windows Update pour un appareil de la section 04 (v3.27, demande de Thomas : sur MAJÉRION
    # le 25/11/2026, Bluetooth Intel 24.70.0.4 en section 04 et « Intel Corporation Bluetooth Driver Update
    # (24.80.0.2) » en section 02, sans lien entre les deux). Rapprochement par l'identifiant matériel que vise la
    # mise à jour (DriverHardwareID) : égal à un des identifiants de l'appareil, ou début de son identifiant
    # d'instance. Rend la première offre qui correspond, sinon $null. Fonction pure, testée en T1.
    param([string]$InstanceId, [string[]]$HardwareIds, [object[]]$Offers)
    $ids = @(@($HardwareIds) + @($InstanceId) | Where-Object { $_ } | ForEach-Object { ([string]$_).Trim().ToUpperInvariant() })
    if ($ids.Count -eq 0) { return $null }
    $inst = ([string]$InstanceId).Trim().ToUpperInvariant()
    foreach ($o in @($Offers)) {
        if ($null -eq $o -or -not $o.PSObject.Properties['HardwareId']) { continue }
        $h = ([string]$o.HardwareId).Trim().ToUpperInvariant()
        if (-not $h) { continue }
        if ($ids -contains $h) { return $o }
        if ($inst -and ($inst.StartsWith($h + '\') -or $inst.StartsWith($h + '&'))) { return $o }
    }
    return $null
}

function Get-PowerVerdict {
    # Alimentation : AC (secteur, ou PC sans batterie), BATTERY ou UNKNOWN. $Line : état du secteur lu par Windows
    # (Online, Offline, Unknown ; vide = lecture en échec). $NoBattery : $true si Windows dit « aucune batterie »,
    # $null si inconnu. Jusqu'à la v3.23, une batterie illisible valait « sur secteur » : DISM, SFC ou Windows Update
    # pouvaient partir sur batterie sans avertissement (constat S7). Fonction pure, T1.
    param([string]$Line, $NoBattery)
    if ($Line -eq 'Online') { return 'AC' }
    if ($Line -eq 'Offline') { return 'BATTERY' }
    if ($NoBattery -is [bool] -and $NoBattery) { return 'AC' }
    return 'UNKNOWN'
}

function Get-PowerSource {
    # Lecture de Windows (GetSystemPowerStatus, par SystemInformation.PowerStatus), puis Get-PowerVerdict
    $line = ''
    $noBat = $null
    try {
        Add-Type -AssemblyName System.Windows.Forms -ErrorAction Stop
        $ps = [System.Windows.Forms.SystemInformation]::PowerStatus
        $line = [string]$ps.PowerLineStatus
        $cs = [int]$ps.BatteryChargeStatus
        if ($cs -ne 255) { $noBat = [bool]($cs -band 128) }
    } catch { $line = '' }
    return (Get-PowerVerdict $line $noBat)
}

function Wait-ACPower([string]$Reason) {
    $st = Get-PowerSource
    while ($st -eq 'BATTERY') {
        Write-Host ('   [!] PC sur batterie : ' + $Reason) -ForegroundColor Yellow
        $a = Read-Answer '   >> Branche le chargeur puis appuie sur Entrée (Échap pour annuler)'
        if ($null -eq $a) { return $false }
        $st = Get-PowerSource
    }
    if ($st -eq 'UNKNOWN') {
        Write-Host ('   [!] Impossible de savoir si le PC est sur secteur : ' + $Reason) -ForegroundColor Yellow
        Write-Host '       Sur un PC portable, branche le chargeur avant de continuer.' -ForegroundColor Yellow
        return (Read-YesNo '   >> Continuer (chargeur branché, ou PC fixe) ?')
    }
    return $true
}

function Install-WindowsUpdates {
    $script:WuTouched = $true      # l'analyse des composants faite pendant le scan n'est plus à jour
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
            $ready = 0
            if ($coll.Count -gt 0) {
                $d = $s.CreateUpdateDownloader()
                $d.Updates = $coll
                $code = [int]$d.Download().ResultCode
                # Preuve du téléchargement : ce que Windows Update déclare lui-même prêt à installer
                foreach ($u in $coll) { if ($u.IsDownloaded) { $ready++ } }
            }
            [pscustomobject]@{ Ok = $true; Count = $coll.Count; Ready = $ready; Skipped = $skipped; Code = $code; Error = $null }
        } catch {
            [pscustomobject]@{ Ok = $false; Count = 0; Ready = 0; Skipped = @(); Code = 0; Error = $_.Exception.Message }
        }
    } 3600 -ArgumentList $filter -AskOnTimeout -StopRisk 'L''arrêter ne casse rien, mais le téléchargement serait à reprendre plus tard.'

    if ($null -eq $dl) {
        if ($script:SpinState -eq 'STOPPED') { Write-Status 'Téléchargement' 'arrêté à ta demande' 'WARN' }
        elseif ($script:SpinState -eq 'TIMEOUT') { Write-Status 'Téléchargement' 'délai dépassé' 'WARN' }
        else { Write-Status 'Téléchargement' 'arrêté sans réponse de Windows Update' 'WARN' }
        Write-Sub 'Rien n''a été installé : reprends plus tard avec J.A.R.V.I.S. ou dans Windows Update'
        return
    }
    if (-not $dl.Ok) { Write-Status 'Téléchargement' ('échec : ' + (Cut $dl.Error 60)) 'WARN'; Open-WindowsUpdateGuided; return }
    foreach ($sk in @($dl.Skipped)) { Write-Sub ('Exclue, ' + (Cut $sk 90)) 'DarkGray' }
    if ($dl.Count -eq 0) {
        Write-Host '   >> Aucune mise à jour installable automatiquement : celles qui restent sont facultatives' -ForegroundColor Yellow
        Write-Host '      ou demandent une action à l''écran.' -ForegroundColor Yellow
        if (Read-YesNo '   >> Ouvrir Windows Update pour les traiter toi-même ?') { Open-WindowsUpdateGuided }
        return
    }
    $dlState = Get-WuDownloadState $dl.Code $dl.Count $dl.Ready
    if ($dlState -eq 'FAILED') {
        Write-Status 'Téléchargement' ("échec, aucune mise à jour téléchargée (code de résultat {0})" -f $dl.Code) 'WARN'
        Write-Sub 'Vérifie la connexion Internet, puis réessaie ou passe par Windows Update'
        Open-WindowsUpdateGuided
        return
    }
    if ($dlState -eq 'PARTIAL') {
        Write-Status 'Téléchargement' ("{0} mise(s) à jour prête(s) sur {1}" -f $dl.Ready, $dl.Count) 'WARN'
        Write-Sub 'Les autres n''ont pas pu être téléchargées : elles resteront à faire dans Windows Update'
    } else {
        Write-Status 'Téléchargement' ("{0} mise(s) à jour prête(s)" -f $dl.Ready) 'OK'
    }

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
    } 3600 -ArgumentList $filter -AskOnTimeout -StopRisk ('Arrêter l''attente ne garantit pas l''arrêt de l''installation, et une installation coupée ' +
                                                          'peut abîmer Windows : le plus sûr est d''attendre.')

    if ($null -eq $ins) {
        # On ne sait pas si Windows Update poursuit ou abandonne l'installation une fois l'attente arrêtée
        if ($script:SpinState -eq 'STOPPED') { Write-Status 'Installation' 'attente arrêtée à ta demande, résultat inconnu' 'WARN' }
        elseif ($script:SpinState -eq 'TIMEOUT') { Write-Status 'Installation' 'délai dépassé, résultat inconnu' 'WARN' }
        else { Write-Status 'Installation' 'arrêtée sans réponse de Windows Update, résultat inconnu' 'WARN' }
        Write-Sub 'J.A.R.V.I.S. ne sait pas si Windows Update a continué. Ne force pas l''arrêt du PC, puis regarde'
        Write-Sub 'Paramètres > Windows Update > Historique des mises à jour, et redémarre si Windows le demande'
        return
    }
    if (-not $ins.Ok) { Write-Status 'Installation' ('échec : ' + (Cut $ins.Error 60)) 'WARN'; Open-WindowsUpdateGuided; return }
    foreach ($x in @($ins.Results)) {
        if ($x.Code -eq 2) { Write-Sub ('Installée : ' + (Cut $x.Title 80)) 'Green' }
        elseif ($x.Code -eq 3) { Write-Sub ('Installée avec avertissement : ' + (Cut $x.Title 62)) 'Yellow' }
        else { Write-Sub ('Échec    : ' + (Cut $x.Title 80)) 'Red' }
    }
    $sum = Get-WuInstallSummary ([int[]]@(@($ins.Results) | ForEach-Object { [int]$_.Code }))
    switch ($sum.State) {
        'OK' { Write-Status 'Installation' ("{0} mise(s) à jour installée(s)" -f $sum.Ok) 'OK' }
        'WARN' {
            Write-Status 'Installation' ("{0} installée(s), dont {1} avec avertissement" -f ($sum.Ok + $sum.Warn), $sum.Warn) 'WARN'
            Write-Sub 'Avertissement de Windows Update : redémarre, puis vérifie dans Windows Update qu''il ne reste rien'
        }
        'FAIL' {
            Write-Status 'Installation' ("{0} réussie(s), {1} échec(s)" -f ($sum.Ok + $sum.Warn), $sum.Fail) 'WARN'
            Write-Sub 'Les échecs se règlent souvent après un redémarrage puis un nouveau passage dans Windows Update'
        }
        default {
            Write-Status 'Installation' 'rien n''a été installé : aucune mise à jour n''était prête' 'WARN'
            Write-Sub 'Passe par Windows Update pour les installer'
        }
    }
    if ($ins.Reboot) {
        Write-Host ''
        Write-Host '   [!] Un redémarrage est nécessaire pour terminer l''installation.' -ForegroundColor Yellow
        if (Read-YesNo '   >> Redémarrer dans 1 minute ? (enregistre ton travail)') {
            & (Get-SystemToolPath 'shutdown.exe') /r /t 60 /c 'J.A.R.V.I.S. : redémarrage pour terminer les mises à jour Windows.'
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
    $uso = Get-SystemToolPath 'UsoClient.exe'
    if (Test-Path -LiteralPath $uso) { Start-Process -FilePath $uso -ArgumentList 'StartInteractiveScan' -WindowStyle Hidden }
    Start-Process 'ms-settings:windowsupdate'
    # Le cache de Windows Update ne sera plus proposé pendant cette session : le vider arrête Windows Update
    $script:WuOpened = $true
    $build = $null
    try { $build = ConvertTo-IntOrNull (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' -ErrorAction Stop).CurrentBuild } catch { $build = $null }
    Write-Host ''
    Write-Host '   DANS LA FENÊTRE WINDOWS UPDATE QUI VIENT DE S''OUVRIR :' -ForegroundColor Cyan
    if ($null -ne $build -and $build -lt 22000) {
        # Windows 10 : « Télécharger et installer tout » est un bouton de Windows 11 (PC-LV, 21/11/2026 ; mots de
        # Windows 10 à confirmer à l'écran)
        Write-Host '   1. Clique sur « Rechercher des mises à jour ».' -ForegroundColor Gray
        Write-Host '      Si la recherche est déjà en cours, attends simplement.' -ForegroundColor DarkGray
        Write-Host '   2. Windows installe ensuite ce qu''il trouve. Clique sur « Télécharger et installer »' -ForegroundColor Gray
        Write-Host '      si ce bouton apparaît sous une mise à jour.' -ForegroundColor Gray
        Write-Host '   3. Les pilotes peuvent être rangés sous « Afficher les mises à jour facultatives ».' -ForegroundColor Gray
        Write-Host '   4. Attends la fin, puis clique sur « Redémarrer maintenant » si Windows le demande.' -ForegroundColor Gray
    } else {
        Write-Host '   1. Clique sur « Rechercher des mises à jour » (bouton en haut à droite).' -ForegroundColor Gray
        Write-Host '      Si la recherche est déjà en cours, attends simplement.' -ForegroundColor DarkGray
        Write-Host '   2. Clique ensuite sur « Télécharger et installer tout » s''il apparaît.' -ForegroundColor Gray
        Write-Host '   3. Attends la fin, puis clique sur « Redémarrer maintenant » si Windows le demande.' -ForegroundColor Gray
    }
    Write-Host ''
}

function Test-ReportDirSafe([string]$Dir) {
    # Vrai si le dossier de rapports et, pour %LOCALAPPDATA%\JARVIS\Rapports, le dossier JARVIS au-dessus (les
    # dossiers que JARVIS crée lui-même) ne sont ni une jonction ni un lien. Un dossier pas encore créé ne compte
    # pas ; une lecture en échec, si. Rien au-dessus : un AppData déplacé ailleurs reste accepté (v3.26, S8).
    $own = @($Dir)
    if ($Dir -eq $ReportRoot) { $own += (Split-Path -Parent $ReportRoot) }
    foreach ($p in $own) {
        $at = $null
        $absent = $false
        try { $at = [IO.File]::GetAttributes($p) }
        catch [IO.FileNotFoundException], [IO.DirectoryNotFoundException] { $absent = $true }
        catch { return $false }
        if ($absent) { continue }
        if ($at -band [IO.FileAttributes]::ReparsePoint) { return $false }
    }
    return $true
}

function Get-ReportDir {
    # Premier emplacement réellement inscriptible : profil local, puis dossier
    # temporaire. Évite Documents (souvent dans OneDrive ou protégé par
    # l'Accès contrôlé aux dossiers) et le dossier du programme (lecture seule).
    # v3.26 (audit, constat S8) : dossier refusé s'il est, ou si son dossier JARVIS est, une jonction ou un lien
    # (Test-ReportDirSafe, contrôlé avant la création puis après). Sinon, lancé en administrateur, JARVIS écrivait
    # ses rapports là où mène la jonction et y supprimait les plus anciens.
    $candidates = @($ReportRoot, (Join-Path $env:TEMP 'JARVIS'))
    foreach ($d in $candidates) {
        try {
            if (-not (Test-ReportDirSafe $d)) { continue }
            if (-not (Test-Path $d)) { New-Item -ItemType Directory -Path $d -Force -ErrorAction Stop | Out-Null }
            if (-not (Test-ReportDirSafe $d)) { continue }
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
        # Rotation : 30 rapports conservés par type. Dossier recontrôlé juste avant (v3.26, relecture : une jonction
        # posée après Get-ReportDir aurait été suivie)
        if (Test-ReportDirSafe $dir) {
            Get-ChildItem -LiteralPath $dir -File -Filter ($Prefix + '_*.txt') | Sort-Object LastWriteTime -Descending |
                Select-Object -Skip 30 | Remove-Item -Force
        }
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
    $sc.IconLocation = (Join-Path $WinDir 'System32\shell32.dll') + ',15'
    $sc.Description = 'J.A.R.V.I.S. // Check-up système'
    $sc.Save()
    if (-not (Test-Path -LiteralPath $Path)) { throw 'raccourci non créé' }
    # Drapeau « Exécuter en tant qu'administrateur » : octet 0x15, bit 0x20
    $bytes = [IO.File]::ReadAllBytes($Path)
    $bytes[0x15] = $bytes[0x15] -bor 0x20
    [IO.File]::WriteAllBytes($Path, $bytes)
}

function Start-DelayedDelete([string]$File, [string]$Dir) {
    # Fichier en cours d'exécution : effacé 3 s après la fermeture, puis son dossier s'il est vide.
    # Outils appelés par chemin complet ; la ligne est entourée de guillemets car elle en contient plusieurs.
    $line = '/c ""{0}" /t 3 /nobreak >nul & del /f /q "{1}" & rmdir "{2}""' -f (Get-SystemToolPath 'timeout.exe'), $File, $Dir
    Start-Process -FilePath (Get-SystemToolPath 'cmd.exe') -ArgumentList $line -WindowStyle Hidden
}

function Test-PlainFile([string]$Path) {
    # Vrai fichier : ni dossier, ni jonction, ni lien. Remove-Item sur une jonction vers un dossier plein demande
    # « l'élément a des enfants » et, sur un oui, descend dans la cible (PowerShell 5.1). v3.24, constat S6.
    $at = $null
    try { $at = [IO.File]::GetAttributes($Path) } catch { return $false }
    return (-not ($at -band [IO.FileAttributes]::Directory) -and -not ($at -band [IO.FileAttributes]::ReparsePoint))
}

function Test-NoLinkUpward([string]$Path) {
    # Vrai si ni $Path ni aucun dossier au-dessus, jusqu'à la racine du disque, n'est une jonction ou un lien.
    # Chemin illisible ou absent : faux. Resolve-Path ne déplie pas une jonction (v3.24, constat S6).
    $cur = $null
    try { $cur = [IO.Path]::GetFullPath($Path) } catch { return $false }
    while ($cur) {
        $at = $null
        try { $at = [IO.File]::GetAttributes($cur) } catch { return $false }
        if ($at -band [IO.FileAttributes]::ReparsePoint) { return $false }
        $cur = [IO.Path]::GetDirectoryName($cur)
    }
    return $true
}

function Invoke-LegacyCleanup([string]$NewCmd, [string[]]$ExtraDirs) {
    # Anciennes installations (avant v3.1, ou dossier précédent refusé depuis la v3.13) :
    # rapports déplacés, fichiers JARVIS supprimés.
    # v3.24 (constat S6) : C:\Outils peut être créé par n'importe quel compte. Un ancien dossier qui est, ou dont un
    # dossier au-dessus est, une jonction mènerait ailleurs : il est laissé tel quel, contrôle refait avant chaque
    # suppression. Réponse par défaut : non (règle 5).
    $newFull = $null
    try { $newFull = [IO.Path]::GetFullPath((Split-Path -Parent $NewCmd)).TrimEnd('\') } catch { return }
    foreach ($old in (@($LegacyDirs) + @($ExtraDirs) | Where-Object { $_ } | Select-Object -Unique)) {
        if (-not (Test-Path -LiteralPath $old)) { continue }
        $oldFull = $null
        try { $oldFull = [IO.Path]::GetFullPath($old).TrimEnd('\') } catch { continue }
        if ($oldFull -eq $newFull) { continue }
        $files = @('JARVIS.cmd', 'jarvis-checkup.ps1', '.jarvis-install') | Where-Object { Test-PlainFile (Join-Path $oldFull $_) }
        if ($files.Count -eq 0) { continue }
        if (-not (Test-NoLinkUpward $oldFull)) {
            Write-Host ("   [!] Ancienne installation dans {0} laissée telle quelle : ce dossier mène vers un autre emplacement (jonction ou lien)." -f $old) -ForegroundColor Yellow
            continue
        }
        if (-not (Read-YesNo ("   >> Ancienne installation trouvée dans {0}. La nettoyer (rapports conservés) ?" -f $old))) { continue }
        $oldRep = Join-Path $oldFull 'Rapports'
        # v3.26 (relecture) : rapports déplacés seulement vers le vrai dossier des rapports, contrôlé par Get-ReportDir
        $repDest = $null
        if ((Test-Path -LiteralPath $oldRep) -and (Test-NoLinkUpward $oldRep)) { $repDest = Get-ReportDir }
        if ($repDest -and $repDest -eq $ReportRoot) {
            Get-ChildItem -LiteralPath $oldRep -File | Where-Object { $_.Name -match '^(checkup|selftest)_\d{8}_\d{4}\.txt$' } |
                Move-Item -Destination $repDest -Force
            if (-not (Get-ChildItem -LiteralPath $oldRep -Force)) { $null = Remove-EmptyDir $oldRep }
        }
        $running = $null
        if ($JarvisSelf) { try { $running = [IO.Path]::GetFullPath($JarvisSelf) } catch { $running = $null } }
        $delayed = @()
        foreach ($f in $files) {
            $fp = Join-Path $oldFull $f
            if (-not (Test-NoLinkUpward $oldFull)) { break }
            if (-not (Test-PlainFile $fp)) { continue }
            if ($fp -eq $running) { $delayed += $fp } else { Remove-Item -LiteralPath $fp -Force }
        }
        if ($delayed.Count -gt 0) {
            Start-DelayedDelete $delayed[0] $oldFull
        } elseif (-not (Get-ChildItem -LiteralPath $oldFull -Force)) {
            $null = Remove-EmptyDir $oldFull
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
    # -1, 0 ou 1 ; $null si l'une des deux versions est illisible (jamais traitée comme « égale »)
    try { return ([version]$A).CompareTo([version]$B) } catch { return $null }
}

function Register-Jarvis([string]$Dir, [string]$Cmd, [string]$Version = $JarvisVersion) {
    # Inscription dans « Applications installées » de Windows (désinstallation possible depuis Paramètres)
    New-Item -Path $RegKey -Force -ErrorAction Stop | Out-Null
    $str = [ordered]@{
        DisplayName     = 'J.A.R.V.I.S. (check-up système)'
        DisplayVersion  = $Version
        Publisher       = 'J.A.R.V.I.S.'
        InstallLocation = $Dir
        DisplayIcon     = (Join-Path $WinDir 'System32\shell32.dll') + ',15'
        UninstallString = ('"{0}" /c ""{1}" -Uninstall"' -f (Join-Path $WinDir 'System32\cmd.exe'), $Cmd)
        InstallDate     = (Get-Date -Format 'yyyyMMdd')
    }
    foreach ($n in $str.Keys) { New-ItemProperty -LiteralPath $RegKey -Name $n -Value $str[$n] -PropertyType String -Force -ErrorAction Stop | Out-Null }
    $kb = [int]([math]::Ceiling((Get-Item -LiteralPath $Cmd).Length / 1KB))
    foreach ($d in @(@('NoModify', 1), @('NoRepair', 1), @('EstimatedSize', $kb))) {
        New-ItemProperty -LiteralPath $RegKey -Name $d[0] -Value $d[1] -PropertyType DWord -Force -ErrorAction Stop | Out-Null
    }
}

function Install-Jarvis {
    # Par défaut installe cette copie ; la mise à jour en ligne passe le fichier téléchargé (-Source), sa
    # version (-Version), son empreinte contrôlée (-ExpectedSha256) et -Quiet (aucune question, raccourcis
    # existants conservés). -OldDir : dossier de l'installation précédente, proposé au nettoyage si JARVIS
    # s'installe ailleurs.
    param([string]$TargetDir, [string]$Source = $JarvisSelf, [string]$Version = $JarvisVersion, [switch]$Quiet,
          [string]$ExpectedSha256 = '', [string]$OldDir = '')
    if ($Source -notlike '*.cmd') {
        Write-Host '   [!] Installation possible uniquement depuis JARVIS.cmd.' -ForegroundColor Yellow
        return $null
    }
    # Dossier : contrôlé (chemin, puis droits d'écriture) AVANT toute copie
    $chk = $null
    $asked = @()
    if ($TargetDir) { $asked += $TargetDir }
    if (-not $Quiet -and $InstallDir) { $asked += $InstallDir }
    foreach ($cand in $asked) {
        $chk = Confirm-InstallDir $cand
        if ($chk.Ok) { break }
        Write-Host ("   [!] Dossier refusé ({0}) : {1}" -f (Cut $cand 50), $chk.Reason) -ForegroundColor Yellow
        $chk = $null
    }
    if (-not $chk -and $Quiet) {
        # Mise à jour sans question : jamais de saisie de dossier
        Write-Host ("       Pour mettre à jour : télécharge la dernière version ({0})," -f $JarvisReleasePage) -ForegroundColor Yellow
        Write-Host ("       lance-la et choisis « Mettre à jour » : elle s'installera dans {0}." -f $DefaultInstallDir) -ForegroundColor Yellow
        return $null
    }
    while (-not $chk) {
        Write-Host ("   Dossier d'installation proposé : {0}" -f $DefaultInstallDir) -ForegroundColor Gray
        $ans = Read-Answer '   >> Entrée pour accepter, ou tape un autre chemin (Échap pour annuler)'
        if ($null -eq $ans) { Write-Host '   >> Installation annulée.' -ForegroundColor DarkGray; return $null }
        if ([string]::IsNullOrWhiteSpace($ans)) { $ans = $DefaultInstallDir }
        $chk = Confirm-InstallDir $ans
        if (-not $chk.Ok) {
            Write-Host ("   [!] Dossier refusé : {0}" -f $chk.Reason) -ForegroundColor Yellow
            $chk = $null
        }
    }
    $dir = $chk.Path
    $marker = Join-Path $dir '.jarvis-install'
    $oldVer = ''
    if (Test-Path -LiteralPath $marker) {
        $oldVer = [string]((Get-Content -LiteralPath $marker | Where-Object { $_ -like 'version=*' }) -replace '^version=', '')
        Write-Host ("   >> Version {0} trouvée : mise à jour vers {1}." -f $oldVer, $Version) -ForegroundColor Cyan
    }
    $dest = Join-Path $dir 'JARVIS.cmd'
    $tmp = $dest + '.new'
    $bak = $dest + '.old'
    $swapped = $false
    $hadOld = $false
    $prevReg = Get-ItemProperty -LiteralPath $RegKey       # inscription d'avant, pour pouvoir la remettre
    $same = $false
    try {
        Show-Bar 'Dossier d''installation'
        $same = $false
        try { $same = ((Resolve-Path -LiteralPath $Source).Path -eq (Join-Path (Resolve-Path -LiteralPath $dir).Path 'JARVIS.cmd')) } catch {}
        if (-not $same) {
            # 1. Copie dans un fichier voisin, contrôlée avant de toucher au programme en place : identique à
            #    l'original, empreinte attendue (mise à jour en ligne), empreinte interne du fichier JARVIS.
            Copy-Item -LiteralPath $Source -Destination $tmp -Force -ErrorAction Stop
            $newBytes = [IO.File]::ReadAllBytes($tmp)
            $newHash = Get-Sha256Hex $newBytes
            if ($newHash -ne (Get-Sha256Hex ([IO.File]::ReadAllBytes($Source)))) { throw 'copie différente de l''original' }
            if ($ExpectedSha256 -and $newHash -ne $ExpectedSha256.ToLowerInvariant()) { throw 'empreinte différente de celle du fichier contrôlé' }
            if ((Get-JarvisCmdState ([Text.Encoding]::UTF8.GetString($newBytes))) -ne 'OK') { throw 'fichier JARVIS abîmé ou incomplet (empreinte interne fausse)' }
            # 2. L'ancien programme est gardé de côté jusqu'au contrôle final, pour pouvoir revenir en arrière.
            #    Remplacer le JARVIS.cmd en cours d'exécution est sans risque : l'en-tête batch, que cmd.exe relit
            #    après la fin de PowerShell, a toujours la même longueur (seule l'empreinte change).
            if (Test-Path -LiteralPath $dest) {
                Copy-Item -LiteralPath $dest -Destination $bak -Force -ErrorAction Stop
                $hadOld = $true
            }
            Move-Item -LiteralPath $tmp -Destination $dest -Force -ErrorAction Stop
            $swapped = $true
            if ((Get-Sha256Hex ([IO.File]::ReadAllBytes($dest))) -ne $newHash) { throw 'fichier installé différent du fichier contrôlé' }
        }
        if (-not (Test-Path -LiteralPath $dest)) { throw 'copie absente après installation' }
        Unblock-File -LiteralPath $dest
        $weakW = @(Get-WeakWriters @($dir, $dest))
        if ($weakW.Count -gt 0) { throw ('programme modifiable sans droits administrateur (' + (Cut ($weakW -join ', ') 60) + ')') }
        Show-Bar 'Copie de J.A.R.V.I.S.'
        Register-Jarvis $dir $dest $Version
        if ([string](Get-ItemProperty -LiteralPath $RegKey -ErrorAction Stop).DisplayVersion -ne $Version) { throw 'inscription dans Windows non relue' }
        Show-Bar 'Inscription dans Windows'
        Set-Content -LiteralPath $marker -Value @("version=$Version", ("date={0}" -f (Get-Date -Format 'yyyy-MM-dd HH:mm'))) -ErrorAction Stop
    } catch {
        Write-Host ("   [!] Installation impossible : {0}" -f $_.Exception.Message) -ForegroundColor Red
        if ($swapped -and $hadOld) {
            # Retour à l'ancien programme, gardé de côté
            $back = $false
            try {
                Move-Item -LiteralPath $bak -Destination $dest -Force -ErrorAction Stop
                if ($oldVer) { Register-Jarvis $dir $dest $oldVer }
                $back = $true
            } catch { $back = $false }
            if ($back) { Write-Host '       L''ancienne version a été remise en place.' -ForegroundColor Yellow }
            else { Write-Host '       [!] Retour à l''ancienne version impossible : relance l''installation depuis le fichier JARVIS.cmd téléchargé.' -ForegroundColor Red }
        } elseif (-not $hadOld -and -not $same) {
            # Première installation dans ce dossier, interrompue : rien n'est laissé derrière
            if ($swapped) { Remove-Item -LiteralPath $dest -Force }
            if (Test-Path -LiteralPath $tmp) { Remove-Item -LiteralPath $tmp -Force }
            if ($chk.Created) { $null = Remove-EmptyDir $dir }
            # Inscription dans Windows : remise comme avant (autre dossier), ou retirée si elle vise ce fichier absent
            $nowReg = Get-ItemProperty -LiteralPath $RegKey
            if ($nowReg -and ([string]$nowReg.InstallLocation).TrimEnd('\') -eq $dir -and -not (Test-Path -LiteralPath $dest)) {
                $prevCmd = $null
                if ($prevReg -and $prevReg.InstallLocation) { $prevCmd = Join-Path ([string]$prevReg.InstallLocation) 'JARVIS.cmd' }
                $restored = $false
                if ($prevCmd -and (Test-Path -LiteralPath $prevCmd)) {
                    try { Register-Jarvis ([string]$prevReg.InstallLocation) $prevCmd ([string]$prevReg.DisplayVersion); $restored = $true } catch { $restored = $false }
                }
                if (-not $restored) { Remove-Item -LiteralPath $RegKey -Force }
            }
        }
        return $null
    } finally {
        foreach ($f in @($tmp, $bak)) { if (Test-Path -LiteralPath $f) { Remove-Item -LiteralPath $f -Force } }
    }
    try {
        New-JarvisShortcut $StartLnk $dest $dir
        Show-Bar 'Raccourci menu Démarrer'
    } catch {
        Write-Host ("   [!] Raccourci menu Démarrer non créé : {0}" -f $_.Exception.Message) -ForegroundColor Yellow
    }
    $wantDesk = $false
    if ($Quiet) { $wantDesk = (Test-Path -LiteralPath $DeskLnk) }
    else { $wantDesk = Read-YesNo '   >> Ajouter aussi un raccourci sur le Bureau ?' -DefaultYes }
    if ($wantDesk) {
        try {
            New-JarvisShortcut $DeskLnk $dest $dir
            Show-Bar 'Raccourci Bureau'
        } catch {
            Write-Host '   [!] Raccourci Bureau refusé (Accès contrôlé aux dossiers ?). Le menu Démarrer suffit.' -ForegroundColor Yellow
        }
    }
    if (-not $Quiet) {
        Invoke-LegacyCleanup $dest @($OldDir)
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
    if (("$a").Trim().ToUpperInvariant() -ne 'DESINSTALLER') { Write-Host '   >> Désinstallation annulée.' -ForegroundColor DarkGray; return }

    # Chaque suppression est contrôlée : ce qui reste est listé, rien n'est annoncé sans preuve
    $left = @()
    foreach ($l in @($StartLnk, $DeskLnk)) {
        if (Test-Path -LiteralPath $l) { Remove-Item -LiteralPath $l -Force }
        if (Test-Path -LiteralPath $l) { $left += $l }
    }
    foreach ($d in @((Join-Path $env:APPDATA 'JARVIS'), (Join-Path $env:LOCALAPPDATA 'JARVIS'))) {
        # Dossiers du profil, modifiables par n'importe quel programme : suppression qui ne suit aucune jonction
        if (-not $d -or (Split-Path -Leaf $d) -ne 'JARVIS') { continue }
        if (-not (Remove-TreeNoJunction $d)) { $left += $d }
    }
    # Uniquement les fichiers créés par JARVIS : un dossier partagé avec d'autres fichiers est conservé
    $rep = Join-Path $JarvisHome 'Rapports'
    Get-ChildItem -LiteralPath $rep -File | Where-Object { $_.Name -match '^(checkup|selftest)_\d{8}_\d{4}\.txt$' } | Remove-Item -Force
    if (Test-Path -LiteralPath $rep) { if (-not (Get-ChildItem -LiteralPath $rep -Force)) { Remove-Item -LiteralPath $rep -Force } }
    $mk = Join-Path $JarvisHome '.jarvis-install'
    Remove-Item -LiteralPath $mk -Force
    if (Test-Path -LiteralPath $mk) { $left += $mk }
    if (Test-Path -LiteralPath $RegKey) { Remove-Item -LiteralPath $RegKey -Recurse -Force }
    if (Test-Path -LiteralPath $RegKey) { $left += 'inscription dans « Applications installées » de Windows' }
    # JARVIS.cmd est en cours d'exécution : suppression différée de 3 s, puis du dossier s'il est vide
    Start-DelayedDelete (Join-Path $JarvisHome 'JARVIS.cmd') $JarvisHome
    Write-Host ''
    if ($left.Count -eq 0) {
        Write-Host '   [ OK ] Raccourcis, profil, rapports et inscription dans Windows supprimés (vérifié).' -ForegroundColor Green
        Write-Host '          Le fichier du programme s''efface 3 secondes après la fermeture de cette fenêtre.' -ForegroundColor DarkGray
        Type-Line '   >> J.A.R.V.I.S. a été désinstallé. Fin de transmission.' 'Cyan'
    } else {
        Write-Host '   [!] Désinstallation incomplète. Il reste, à supprimer à la main :' -ForegroundColor Yellow
        foreach ($x in $left) { Write-Host ('       - ' + $x) -ForegroundColor Yellow }
        Write-Host '       Le fichier du programme, lui, s''efface 3 secondes après la fermeture de cette fenêtre.' -ForegroundColor DarkGray
    }
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
    # Empreinte publiée par GitHub : obligatoire. Sans elle, rien ne prouve que le fichier téléchargé
    # est celui qui a été publié.
    $d = ''
    if ($asset.PSObject.Properties['digest']) { $d = [string]$asset.digest }
    if (-not $d) { $r.Reason = 'empreinte absente de la version publiée'; return $r }
    if ($d -notmatch '^sha256:([0-9a-fA-F]{64})$') { $r.Reason = 'empreinte publiée illisible'; return $r }
    $r.Sha256 = $Matches[1].ToLowerInvariant()
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
    if (-not $Info.Sha256) { return 'empreinte publiée par GitHub absente' }
    if ((Get-Sha256Hex $Bytes) -ne $Info.Sha256) { return 'empreinte différente de celle publiée sur GitHub' }
    $t = [Text.Encoding]::UTF8.GetString($Bytes)
    if (-not $t.StartsWith('<# : JARVIS.cmd')) { return 'ce n''est pas un fichier JARVIS' }
    if ((Get-JarvisCmdState $t) -ne 'OK') { return 'fichier modifié ou incomplet (empreinte interne fausse)' }
    if ($t -notmatch '\$JarvisVersion = ''([0-9.]+)''') { return 'version introuvable dans le fichier' }
    $v = $Matches[1]
    if ($v -ne $Info.Version) { return ('version du fichier (v{0}) différente de la version publiée (v{1})' -f $v, $Info.Version) }
    $cmp = Compare-JarvisVersion $v $CurrentVersion
    if ($null -eq $cmp) { return ('numéro de version illisible (v{0} ou v{1})' -f $v, $CurrentVersion) }
    if ($cmp -le 0) { return ('v{0} n''est pas plus récente que v{1}' -f $v, $CurrentVersion) }
    return $null
}

function Get-ReleaseNotesLines([string]$Body, [int]$Max = 6) {
    # Nouveautés affichables : caractères de contrôle retirés (aucune séquence d'échappement console), lignes coupées
    $out = @()
    foreach ($l in ("$Body" -split "`n")) {
        $t = (Remove-ControlChars $l).Trim()
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
    # v3.26 (audit, constat S8) : réception plafonnée (fichier refusé au-delà de 5 Mo après coup ; sans plafond,
    # un fichier énorme était d'abord reçu en entier en mémoire, jusqu'à 2 Go)
    $c.MaxResponseContentBufferSize = 8MB
    $c.DefaultRequestHeaders.UserAgent.ParseAdd('JARVIS-checkup/' + $JarvisVersion)
    $script:JarvisHttp = $c
    return $c
}

function Get-ClockSample {
    # Heure d'Internet pour Get-ClockCheck : en-tête Date d'une réponse de www.msftconnecttest.com (adresse que
    # Windows interroge lui-même pour savoir s'il a Internet). En HTTP simple : la lecture marche même quand l'heure
    # du PC est assez fausse pour faire échouer une connexion chiffrée. Relevé du 24/11/2026 sur le PC de Thomas :
    # cette adresse et www.microsoft.com à moins d'une seconde de time.windows.com (w32tm /stripchart), github.com
    # 6 s en retard (page gardée en cache). Server = $null sans réponse dans les 5 s.
    $s = [pscustomobject]@{ Server = $null; Age = $null; Before = $null; After = $null }
    try {
        $c = Get-JarvisHttpClient
        $s.Before = [DateTime]::UtcNow
        $t = $c.GetAsync('http://www.msftconnecttest.com/connecttest.txt')
        if (-not $t.Wait(5000)) { return $s }
        $s.After = [DateTime]::UtcNow
        $resp = $t.Result
        # Relecture v3.26 : seule la vraie réponse compte. Portail d'hôtel, proxy en erreur, redirection : leur
        # horloge peut être fausse (faux « en avance de 9 000 jours »), la mesure reste « non vérifiable »
        $body = ''
        if ([int]$resp.StatusCode -eq 200) { $body = [string]$resp.Content.ReadAsStringAsync().Result }
        if ($body.Trim() -ne 'Microsoft Connect Test') { $resp.Dispose(); return $s }
        if ($null -ne $resp.Headers.Date) { $s.Server = $resp.Headers.Date.UtcDateTime }
        if ($null -ne $resp.Headers.Age) { $s.Age = $resp.Headers.Age.TotalSeconds }
        $resp.Dispose()
    } catch { $s.Server = $null }
    return $s
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
    $cmp = Compare-JarvisVersion $info.Version $JarvisVersion
    if ($null -eq $cmp) { $r.Detail = 'numéro de version publié illisible'; return $r }
    $r.Info = $info
    if ($cmp -gt 0) { $r.Status = 'NEW' } else { $r.Status = 'UPTODATE' }
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
    if (-not (Read-YesNo ("   >> Installer la v{0} maintenant ?" -f $Info.Version) -DefaultYes)) {
        Write-Host '   >> Mise à jour reportée. Elle reste proposée au menu.' -ForegroundColor DarkGray
        return
    }

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
    Write-Host '   [ OK ] Fichier contrôlé : empreinte publiée sur GitHub et empreinte interne conformes.' -ForegroundColor Green

    # Fichier posé dans le dossier d'installation (modifiable par les seuls administrateurs), revérifié, puis installé
    $stage = Join-Path $JarvisHome '.jarvis-update.cmd'
    $dest = $null
    try {
        [IO.File]::WriteAllBytes($stage, $bytes)
        if ((Get-FileHash -LiteralPath $stage -Algorithm SHA256).Hash.ToLower() -ne $hash) { throw 'fichier altéré après écriture' }
        $dest = Install-Jarvis -TargetDir $JarvisHome -Source $stage -Version $Info.Version -Quiet -ExpectedSha256 $hash
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
    # Messages de SFC en anglais et en français (Windows 10 et 11, relevés dans sfc.exe.mui le 19/11/2026).
    # Les lettres accentuées et les apostrophes sont remplacées par des jokers : la sortie de l'outil peut
    # arriver mal décodée, et l'apostrophe est typographique sous Windows 11.
    $t = ($Text -replace "`0", '') -replace '\s+', ' '
    # « Aucune violation détectée, mais intégrité non garantie : métadonnées des composants endommagées »
    if ($t -match 'cannot guarantee|ne peut pas garantir') { return 'STOREDAMAGED' }
    if ($t -match 'did not find any integrity violations|aucune violation') { return 'CLEAN' }
    if ($t -match 'could not perform|could not start the repair|must be an administrator|pas pu effectuer|pas r.{1,3}ussi .{1,3} (effectuer|d.{1,3}marrer)|devez .{1,3}tre un administrateur') { return 'NORUN' }
    if ($t -match 'unable to fix|pas pu en r|pas pu r.{1,3}parer') { return 'UNFIXED' }
    if ($t -match 'successfully repaired|les a r.{1,3}par') { return 'REPAIRED' }
    # /verifyonly : violations trouvées, rien n'a été réparé
    if ($t -match 'found integrity violations|d.{1,3}tect.{1,3} des violations') { return 'UNFIXED' }
    return 'UNKNOWN'
}

function Get-DismVerdict([string]$Text, $Code) {
    # DISM /ScanHealth ou /CheckHealth (messages relevés dans CbsProvider.dll.mui le 19/11/2026).
    # « irréparable » est cherché avant « réparable », qu'il contient. Un texte qui n'est reconnu ni en
    # français ni en anglais donne UNKNOWN, jamais CLEAN : pas de « sain » sans preuve.
    $t = ($Text -replace "`0", '') -replace '\s+', ' '
    if ($t -match 'cannot be repaired|not repairable|irr.{1,3}parable|ne peut pas .{1,3}tre r.{1,3}par') { return 'UNREPAIRABLE' }
    if ($t -match 'is repairable|r.{1,3}parable|peut .{1,3}tre r.{1,3}par') { return 'REPAIRABLE' }
    if ($null -ne $Code -and [int]$Code -ne 0) { return 'ERROR' }
    if ($t -match 'No component store corruption|Aucun endommagement|Aucune alt') { return 'CLEAN' }
    return 'UNKNOWN'
}

function Get-DismRepairVerdict([string]$Text, $Code) {
    # DISM /RestoreHealth : REPAIRED (réparation annoncée par DISM, code 0), NOSOURCE (fichiers de réparation
    # introuvables ou image irréparable), FAILED (autre échec), UNKNOWN (code 0 mais message non reconnu)
    $t = ($Text -replace "`0", '') -replace '\s+', ' '
    if ($t -match 'restore operation failed|chec de la restauration|source files could not be|repair content could not be found|introuvable') { return 'NOSOURCE' }
    # 0x800F081F (source introuvable) et 0x800F0915 (« Le contenu de réparation est introuvable », relevé
    # sur l'autre PC le 20/11/2026, texte dans CbsProvider.dll.mui) : même cas, quel que soit le texte
    if ($null -ne $Code -and ([int]$Code -eq -2146498529 -or [int]$Code -eq -2146498283)) { return 'NOSOURCE' }
    if ($null -eq $Code -or [int]$Code -ne 0) { return 'FAILED' }
    if ($t -match 'restore operation completed successfully|restauration a .{1,3}t.{1,3} effectu') { return 'REPAIRED' }
    return 'UNKNOWN'
}

function Get-CbsSummary([string]$Text, $Since, [string]$Kind) {
    # Dernier bilan « Summary: » de CBS.log écrit après $Since (journal en anglais quelle que soit la langue de
    # Windows). $Kind : 'DETECT' (DISM /ScanHealth, « Operation: Detect only ») ou 'REPAIR' (/RestoreHealth,
    # « Operation: Detect and Repair »). Rend Time, Detected, Repaired, Remaining, ou $null sans bilan complet.
    # Relevé sur l'autre PC le 20/11/2026 : DISM rendait 0x800F0915 (« échec ») alors que 1 929 défauts sur
    # 1 973 avaient été réparés. Fonction pure, testée en T1 (fins de ligne CRLF).
    # v3.26 : FilesDetected, FilesRepaired, Flags. Relevé sur le PC de Thomas le 24/11/2026 : /ScanHealth trouvait
    # 33 défauts (fichiers), /RestoreHealth en annonçait 1 187 réparés, dont 1 154 « CSI FileFlags » (marques
    # internes des fichiers en attente, vues seulement pendant la réparation). Ces marques sont mises à part
    # seulement si toutes ont été réparées : FilesDetected - FilesRepaired reste alors égal à Remaining.
    if ([string]::IsNullOrEmpty($Text)) { return $null }
    $found = $null
    $cur = $null
    foreach ($line in ($Text -split "`r?`n")) {
        $m = [regex]::Match($line, '^(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}),\s+\w+\s+CBS\s+(.*)$')
        if (-not $m.Success) { continue }
        $body = $m.Groups[2].Value.Trim()
        if ($body -eq 'Summary:') {
            $t = [datetime]::ParseExact($m.Groups[1].Value, 'yyyy-MM-dd HH:mm:ss', [Globalization.CultureInfo]::InvariantCulture)
            $cur = @{ Time = $t; Kind = ''; Detected = $null; Repaired = $null; FlagsDet = $null; FlagsRep = $null }
            continue
        }
        if ($null -eq $cur) { continue }
        if ($body -match '^Operation:\s*Detect and Repair') { $cur.Kind = 'REPAIR' }
        elseif ($body -match '^Operation:\s*Detect only') { $cur.Kind = 'DETECT' }
        elseif ($body -match '^Total Detected Corruption:\s*(\d+)') { $cur.Detected = [int]$Matches[1] }
        elseif ($body -match '^Total Repaired Corruption:\s*(\d+)') { $cur.Repaired = [int]$Matches[1] }
        elseif ($body -match '^CSI FileFlags Corrupt:\s*(\d+)') { $cur.FlagsDet = [int]$Matches[1] }
        elseif ($body -match '^CSI FileFlags Repaired:\s*(\d+)') { $cur.FlagsRep = [int]$Matches[1] }
        elseif ($body -match '^Total Operation Time:') {
            if ($cur.Kind -eq $Kind -and $null -ne $cur.Detected -and $null -ne $cur.Repaired -and
                ($null -eq $Since -or $cur.Time -ge $Since)) {
                $fl = 0
                if ($null -ne $cur.FlagsDet -and $null -ne $cur.FlagsRep -and $cur.FlagsDet -eq $cur.FlagsRep -and
                    $cur.FlagsRep -le $cur.Repaired -and $cur.FlagsDet -le $cur.Detected) { $fl = $cur.FlagsRep }
                $found = [pscustomobject]@{
                    Time = $cur.Time; Detected = $cur.Detected; Repaired = $cur.Repaired
                    Remaining = [math]::Max(0, $cur.Detected - $cur.Repaired)
                    FilesDetected = $cur.Detected - $fl; FilesRepaired = $cur.Repaired - $fl; Flags = $fl
                }
            }
            $cur = $null
        }
    }
    return $found
}

function Read-CbsLogText($Since) {
    # Fin de CBS.log (8 Mo au plus par fichier), lue sans gêner Windows (partage lecture et écriture). Si
    # Windows a mis le journal de côté depuis $Since (CbsPersist_*.log, vu le 20/11/2026 juste après une
    # réparation), le plus récent est lu avant. Droits admin. '' si rien n'est lisible.
    $dir = Join-Path ([Environment]::GetFolderPath('Windows')) 'Logs\CBS'
    $paths = @()
    try {
        $paths += @(Get-ChildItem -LiteralPath $dir -Filter 'CbsPersist_*.log' -ErrorAction Stop |
            Where-Object { $null -eq $Since -or $_.LastWriteTime -ge $Since } |
            Sort-Object LastWriteTime | Select-Object -Last 1 | ForEach-Object { $_.FullName })
    } catch { $paths = @() }
    $paths += (Join-Path $dir 'CBS.log')
    $sb = New-Object Text.StringBuilder
    foreach ($p in $paths) {
        $fs = $null
        try {
            $fs = [IO.File]::Open($p, [IO.FileMode]::Open, [IO.FileAccess]::Read, ([IO.FileShare]::ReadWrite -bor [IO.FileShare]::Delete))
            if ($fs.Length -gt 8MB) { $null = $fs.Seek(-8MB, [IO.SeekOrigin]::End) }
            $sr = New-Object IO.StreamReader($fs, [Text.Encoding]::UTF8)
            $null = $sb.Append($sr.ReadToEnd())
            $null = $sb.Append("`r`n")
        } catch {
            $null = $sb.Append("`r`n")
        } finally {
            if ($fs) { $fs.Dispose() }
        }
    }
    return $sb.ToString()
}

function Get-SfcRepairSummary([string]$Text, $Since) {
    # Fichiers remis par SFC depuis $Since, lus dans les lignes « [SR] Repairing file ... from store » de CBS.log.
    # OnlyOneDrive : seul le raccourci OneDrive du profil par défaut a été remis. Relevé sur PC-LV le 21/11/2026 :
    # OneDrive, mis à jour le matin, avait remplacé ce raccourci ; SFC a remis celui de Windows (2019) et annonçait
    # « fichiers corrompus réparés, redémarrage conseillé » pour rien. Fonction pure, testée en T1 (fins CRLF).
    $files = New-Object System.Collections.Generic.List[string]
    if (-not [string]::IsNullOrEmpty($Text)) {
        foreach ($line in ($Text -split "`r?`n")) {
            $m = [regex]::Match($line, '^(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}),\s+\w+\s+CSI\s+\w+\s+\[SR\] Repairing file (.+?)(?: from store)?\s*$')
            if (-not $m.Success) { continue }
            if ($null -ne $Since) {
                $t = [datetime]::ParseExact($m.Groups[1].Value, 'yyyy-MM-dd HH:mm:ss', [Globalization.CultureInfo]::InvariantCulture)
                if ($t -lt $Since) { continue }
            }
            $f = $m.Groups[2].Value.Trim()
            if ($f.StartsWith('\??\')) { $f = $f.Substring(4) }
            $f = $f -replace '\\{2,}', '\'
            if (-not $files.Contains($f)) { $files.Add($f) }
        }
    }
    $arr = $files.ToArray()
    $only = $arr.Count -gt 0
    foreach ($f in $arr) {
        if ($f -notmatch '\\Users\\Default\\AppData\\Roaming\\Microsoft\\Windows\\Start Menu\\Programs\\OneDrive\.lnk$') { $only = $false }
    }
    return [pscustomobject]@{ Files = $arr; OnlyOneDrive = $only }
}

function Write-SfcRepairedFiles($Summary) {
    # Fichiers remis par SFC (3 au plus), dans la console et le rapport
    $list = @($Summary.Files)
    foreach ($f in ($list | Select-Object -First 3)) { Write-Sub ('Remis : ' + (Cut $f 90)) }
    if ($list.Count -gt 3) { Write-Sub ('... et {0} autre(s), détails dans C:\Windows\Logs\CBS\CBS.log' -f ($list.Count - 3)) }
}

function Get-RepairRetryAdvice([string]$Last, $Now, $DetectedNow) {
    # Avant de reproposer DISM /RestoreHealth (v3.21). $Last : dernière réparation mémorisée dans config.json
    # (« LastRepair » = 'AAAA-MM-JJ|RÉSULTAT|restants'). Rend $null (proposer comme d'habitude), 'SAME'
    # (dernière réparation incomplète et pas plus de défauts aujourd'hui qu'il n'en restait) ou 'FAILED'
    # (dernière réparation incomplète il y a moins de 90 jours, comparaison impossible). Plus de défauts
    # qu'il n'en restait : $null, une nouvelle réparation peut en corriger une partie. Fonction pure, T1.
    if ([string]::IsNullOrWhiteSpace($Last) -or $null -eq $Now) { return $null }
    $p = @($Last -split '\|')
    if ($p.Count -lt 2) { return $null }
    $d = [datetime]::MinValue
    if (-not [datetime]::TryParseExact($p[0], 'yyyy-MM-dd', [Globalization.CultureInfo]::InvariantCulture,
            [Globalization.DateTimeStyles]::None, [ref]$d)) { return $null }
    $age = ([datetime]$Now - $d).TotalDays
    if ($age -lt 0 -or $age -gt 90) { return $null }
    if ($p[1] -notin @('PARTIAL', 'NOSOURCE')) { return $null }
    $left = $null
    if ($p.Count -ge 3) { $left = ConvertTo-IntOrNull $p[2] }
    if ($null -ne $DetectedNow -and $null -ne $left) {
        if ([int]$DetectedNow -le $left) { return 'SAME' }
        return $null
    }
    return 'FAILED'
}

function ConvertFrom-DismSize([string]$Text) {
    # Taille écrite par DISM (« 7.85 GB », « 7,85 Go », « 0 bytes », « 512.30 MB ») : octets, ou $null si
    # illisible. Fonction pure, testée en T1.
    if ([string]::IsNullOrWhiteSpace($Text)) { return $null }
    $t = $Text.Trim()
    $m = [regex]::Match($t, '^(\d[\d\s]*(?:[.,]\d+)?)\s*(bytes|octets|KB|Ko|MB|Mo|GB|Go|TB|To|B|o)(?![A-Za-z])', 'IgnoreCase')
    if (-not $m.Success) { return $null }
    $num = ($m.Groups[1].Value -replace '\s', '') -replace ',', '.'
    $v = 0.0
    if (-not [double]::TryParse($num, [Globalization.NumberStyles]::Float, [Globalization.CultureInfo]::InvariantCulture, [ref]$v)) { return $null }
    $u = $m.Groups[2].Value.ToUpperInvariant()
    $mult = 1.0
    if ($u.StartsWith('K')) { $mult = 1KB }
    elseif ($u.StartsWith('M')) { $mult = 1MB }
    elseif ($u.StartsWith('G')) { $mult = 1GB }
    elseif ($u.StartsWith('T')) { $mult = 1TB }
    return [int64][math]::Round($v * $mult)
}

function Get-ComponentStoreInfo([string]$Text) {
    # Lecture de DISM /AnalyzeComponentStore. Libellés français relevés dans CbsProvider.dll.mui le 19/11/2026
    # (accents en jokers, règle 21). Recommended : 'YES', 'NO', ou $null si le texte n'est pas reconnu (jamais
    # « rien à faire » sans preuve). Fonction pure, testée en T1.
    $r = [pscustomobject]@{ Recommended = $null; Reclaimable = $null; ActualBytes = $null; BackupBytes = $null; CacheBytes = $null }
    if ([string]::IsNullOrEmpty($Text)) { return $r }
    foreach ($raw in (($Text -replace "`0", '') -split "`r?`n")) {
        $l = $raw.Trim()
        $m = [regex]::Match($l, '^(Component Store Cleanup Recommended|Nettoyage du magasin de composants recommand.{1,3})\s*:\s*(\S+)', 'IgnoreCase')
        if ($m.Success) {
            $v = $m.Groups[2].Value.ToLowerInvariant()
            if (@('yes', 'oui') -contains $v) { $r.Recommended = 'YES' }
            elseif (@('no', 'non') -contains $v) { $r.Recommended = 'NO' }
            continue
        }
        $m = [regex]::Match($l, '^(Number of Reclaimable Packages|Nombre de packages r.{1,3}cup.{1,3}rables)\s*:\s*(\d+)', 'IgnoreCase')
        if ($m.Success) { $r.Reclaimable = [int]$m.Groups[2].Value; continue }
        $m = [regex]::Match($l, '^(Actual Size of Component Store|Taille r.{1,3}elle du magasin de composants)\s*:\s*(.+)$', 'IgnoreCase')
        if ($m.Success) { $r.ActualBytes = ConvertFrom-DismSize $m.Groups[2].Value; continue }
        $m = [regex]::Match($l, '^(Backups and Disabled Features|Sauvegardes et fonctionnalit.{1,3}s d.{1,3}sactiv.{1,3}es)\s*:\s*(.+)$', 'IgnoreCase')
        if ($m.Success) { $r.BackupBytes = ConvertFrom-DismSize $m.Groups[2].Value; continue }
        $m = [regex]::Match($l, '^(Cache and Temporary Data|Cache et donn.{1,3}es temporaires)\s*:\s*(.+)$', 'IgnoreCase')
        if ($m.Success) { $r.CacheBytes = ConvertFrom-DismSize $m.Groups[2].Value }
    }
    return $r
}

function Get-ComponentCleanupVerdict([string]$Text, $Code) {
    # DISM /StartComponentCleanup : DONE (code 0 ou 3010 et réussite annoncée), PENDING (opérations en attente
    # d'un redémarrage, 0x800F0806), FAILED (autre code ou aucun), UNKNOWN (code 0 sans message reconnu).
    # « L'opération a réussi » relevé dans Dism.exe.mui le 19/11/2026. Fonction pure, testée en T1.
    $t = ($Text -replace "`0", '') -replace '\s+', ' '
    if ($null -eq $Code) { return 'FAILED' }
    if (('{0:X8}' -f [int]$Code) -eq '800F0806' -or $t -match '0x800f0806') { return 'PENDING' }
    if ([int]$Code -ne 0 -and [int]$Code -ne 3010) { return 'FAILED' }
    if ($t -match 'operation completed successfully|op.{1,3}ration a r.{1,3}ussi') { return 'DONE' }
    return 'UNKNOWN'
}

function Get-CleanupTaskVerdict($State, $LastRun, $LastResult, $Deadline, [datetime]$Now) {
    # État de la tâche de Windows qui nettoie les composants (\Microsoft\Windows\Servicing\StartComponentCleanup).
    # Relevé sur le PC de Thomas le 19/11/2026 : maintenance automatique tous les 7 jours (Period P7D), rattrapage
    # forcé au bout de 14 (Deadline P14D). OK ou RUNNING : Windows fait ce nettoyage lui-même. DISABLED, NEVER,
    # FAILED, LATE (pas de passage réussi depuis plus que son propre délai de rattrapage) : il ne le fait pas.
    # UNKNOWN : lecture impossible. Fonction pure, testée en T1.
    if ($null -eq $State -or [string]::IsNullOrWhiteSpace([string]$State)) { return 'UNKNOWN' }
    if ([string]$State -eq 'Disabled') { return 'DISABLED' }
    if ([string]$State -eq 'Running') { return 'RUNNING' }
    $code = $null
    if ($null -ne $LastResult) {
        $v = [int64]$LastResult
        if ($v -lt 0) { $v += 4294967296 }           # code rendu en entier signé
        $code = '{0:X8}' -f $v
    }
    if ($code -eq '00041303') { return 'NEVER' }    # la tâche n'a encore jamais tourné
    if ($code -eq '00041301') { return 'RUNNING' }  # en cours d'exécution
    if ($null -eq $LastRun) { return 'NEVER' }
    $lr = $null
    try { $lr = [datetime]$LastRun } catch { return 'UNKNOWN' }
    if ($lr.Year -lt 2000) { return 'NEVER' }       # date vide du planificateur (30/11/1999)
    if ($null -eq $code) { return 'UNKNOWN' }
    if ($code -ne '00000000') { return 'FAILED' }
    if ($null -eq $Deadline) { return 'UNKNOWN' }
    if (($Now - $lr) -gt [TimeSpan]$Deadline) { return 'LATE' }
    return 'OK'
}

function Get-CleanupTaskState {
    # Lecture, sans droits admin, de la tâche de Windows qui nettoie les composants. State = $null : illisible.
    return (Get-WinTaskState '\Microsoft\Windows\Servicing\' 'StartComponentCleanup')
}

function Get-OptimizeTaskState {
    # v3.28 : tâche de Windows qui optimise les lecteurs (TRIM des SSD, défragmentation des disques durs), celle que
    # règle « Défragmenter et optimiser les lecteurs > Exécution planifiée ». Relevé sur le PC de Thomas le
    # 26/11/2026 : prête, dernier passage le 20/11/2026, résultat 0. Verdict par Get-CleanupTaskVerdict (T1).
    return (Get-WinTaskState '\Microsoft\Windows\Defrag\' 'ScheduledDefrag')
}

function Get-WinTaskState([string]$TaskPath, [string]$TaskName) {
    # Lecture, sans droits admin, d'une tâche planifiée de Windows. State = $null : illisible.
    $r = [pscustomobject]@{ State = $null; LastRun = $null; LastResult = $null; Deadline = $null; Period = $null }
    try {
        $task = Get-ScheduledTask -TaskPath $TaskPath -TaskName $TaskName -ErrorAction Stop
        $ms = $task.Settings.MaintenanceSettings
        if ($ms -and $ms.Deadline) { $r.Deadline = [Xml.XmlConvert]::ToTimeSpan([string]$ms.Deadline) }
        if ($ms -and $ms.Period) { $r.Period = [Xml.XmlConvert]::ToTimeSpan([string]$ms.Period) }
        $info = Get-ScheduledTaskInfo -InputObject $task -ErrorAction Stop
        $r.LastRun = $info.LastRunTime
        $r.LastResult = $info.LastTaskResult
        $r.State = [string]$task.State
    } catch { $r.State = $null }
    return $r
}

function Invoke-ComponentAnalysis {
    # DISM /AnalyzeComponentStore (lecture seule, droits admin). $null si DISM n'a pas pu tourner jusqu'au bout.
    # Pas de -AskOnTimeout : arrêter une analyse ne touche à rien.
    $r = Invoke-ProcessSpinner -Label 'Analyse des composants Windows (jusqu''à 15 min)' -FilePath (Get-SystemToolPath 'dism.exe') `
         -Arguments '/Online /Cleanup-Image /AnalyzeComponentStore' -TimeoutSec 900 -Encoding 'Auto'
    if ($null -eq $r) { return $null }
    $i = Get-ComponentStoreInfo $r.Text
    $i | Add-Member -NotePropertyName Code -NotePropertyValue $r.Code
    return $i
}

function Invoke-ComponentCleanup {
    # DISM /StartComponentCleanup sans /ResetBase (avec /ResetBase, plus aucune mise à jour installée ne
    # pourrait être désinstallée). Reporté si un redémarrage ou une installation est en cours ; résultat lu,
    # puis gain mesuré par une nouvelle analyse.
    $b = Get-WuBusyState
    $why = Get-ServicingBlocker $b.RebootPending $b.ServicingBusy $b.InstallerBusy
    if ($why) {
        Write-Action 'INFO' ('Composants Windows : nettoyage reporté, ' + $why)
        Write-Host '          Redémarre le PC puis relance un scan complet.' -ForegroundColor DarkGray
        return
    }
    if (-not (Wait-ACPower 'une coupure pendant le nettoyage des composants peut abîmer Windows.')) {
        Write-Action 'INFO' 'Composants Windows : nettoyage annulé (PC sur batterie)'
        return
    }
    $before = $script:ComponentInfo
    $r = Invoke-ProcessSpinner -Label 'Nettoyage des composants Windows (jusqu''à 30 min)' -FilePath (Get-SystemToolPath 'dism.exe') `
         -Arguments '/Online /Cleanup-Image /StartComponentCleanup' -TimeoutSec 3600 -Encoding 'Auto' -AskOnTimeout
    if ($null -eq $r) {
        if ($script:ProcState -eq 'STOPPED') { Write-Action 'WARN' 'Composants Windows : nettoyage arrêté à ta demande avant la fin' }
        else { Write-Action 'WARN' 'Composants Windows : DISM n''a pas pu être lancé' }
        return
    }
    $v = Get-ComponentCleanupVerdict $r.Text $r.Code
    if ($v -eq 'PENDING') {
        Write-Action 'INFO' 'Composants Windows : des mises à jour attendent un redémarrage, nettoyage impossible pour l''instant'
        Write-Host '          Redémarre le PC puis relance un scan complet.' -ForegroundColor DarkGray
        return
    }
    if ($v -eq 'FAILED') {
        Write-Action 'WARN' ('Composants Windows : échec du nettoyage (code 0x{0:X8})' -f [int]$r.Code)
        Write-Host '          Détails : C:\Windows\Logs\DISM\dism.log' -ForegroundColor DarkGray
        return
    }
    $after = Invoke-ComponentAnalysis
    $gain = ''
    if ($null -ne $before -and $null -ne $after -and $null -ne $before.ActualBytes -and $null -ne $after.ActualBytes) {
        $gain = ', ' + (Format-Bytes ([math]::Max([int64]0, [int64]$before.ActualBytes - [int64]$after.ActualBytes))) + ' libérés'
    }
    if ($v -eq 'UNKNOWN') {
        Write-Action 'INFO' ('Composants Windows : DISM a terminé sans message reconnu' + $gain)
        Write-Host '          Détails : C:\Windows\Logs\DISM\dism.log' -ForegroundColor DarkGray
    } elseif ($null -ne $after -and $after.Recommended -eq 'NO') {
        Write-Action 'OK' ('Composants Windows : nettoyage vérifié' + $gain)
    } elseif ($null -ne $after -and $after.Recommended -eq 'YES') {
        # Relevé du 19/11/2026 (Windows 11 build 26300) : DISM a fini en 2 s, sans rien retirer ni demander de
        # redémarrage (dism.log), et l'analyse suivante conseillait toujours le nettoyage (2 paquets).
        Write-Action 'INFO' ('Composants Windows : DISM a terminé' + $gain + ', mais Windows garde des composants qu''il dit récupérables')
        Write-Host '          Rien d''autre à faire de ton côté.' -ForegroundColor DarkGray
    } else {
        Write-Action 'INFO' 'Composants Windows : nettoyage terminé d''après DISM, gain non mesuré (nouvelle analyse impossible)'
    }
}

function Write-CleanResult([string]$Label, $Res) {
    # Résultat d'un nettoyage, d'après la nouvelle mesure. Ok = $false : rien de fait (Reason dit pourquoi).
    # Reason non vide avec Ok : résultat partiel, jamais affiché en « OK ».
    # Un reste de moins de 1 Mo (fichiers verrouillés, fichiers de suivi d'un service) ne change pas le verdict.
    if (-not $Res.Ok) { Write-Action 'WARN' ($Label + ' : ' + $Res.Reason); return }
    $left = [int64]$Res.LeftBytes
    if ($left -lt 1MB) { $left = 0 }
    $txt = '{0} : {1} libérés' -f $Label, (Format-Bytes $Res.FreedBytes)
    if ($left -gt 0) { $txt += (', {0} conservés (fichiers verrouillés ou en cours d''utilisation)' -f (Format-Bytes $left)) }
    if ($Res.Reason) { $txt += ' ; ' + $Res.Reason }
    if ($left -gt 0 -or $Res.Reason) { Write-Action 'INFO' $txt } else { Write-Action 'OK' $txt }
}

function Wait-ServicingIdle([int]$TimeoutSec = 300) {
    # TiWorker (programme d'installation des modules Windows) démarre à chaque recherche de mises à jour, celle de
    # la section 02 comprise, et reste environ 2 minutes (relevé le 19/11/2026) : on attend qu'il s'arrête de
    # lui-même. $true quand il ne tourne plus.
    if (-not (Get-Process TiWorker)) { return $true }
    $null = Invoke-Spinner -Label 'Windows termine une vérification de ses composants' -TimeoutSec $TimeoutSec -ScriptBlock {
        while (Get-Process TiWorker -ErrorAction SilentlyContinue) { Start-Sleep -Seconds 2 }
        $true
    }
    return (-not (Get-Process TiWorker))
}

function Test-MsiBusy {
    # $true si Windows Installer exécute une installation (verrou « Global\_MSIExecute », documenté par Microsoft),
    # $false s'il est libre. Un verrou présent mais illisible compte comme occupé.
    try {
        $m = [Threading.Mutex]::OpenExisting('Global\_MSIExecute')
        $m.Dispose()
        return $true
    } catch {
        return ($_.Exception.GetBaseException() -is [UnauthorizedAccessException])
    }
}

function Wait-MsiIdle([int]$TimeoutSec = 300) {
    # Avant chaque mise à jour winget : attendre qu'aucune autre installation ne tourne (Windows Update, Store,
    # programme d'installation précédent). PC-LV le 21/11/2026 : l'installateur de Java a retiré l'ancienne version
    # puis échoué avec le code 1618 (« une autre installation est déjà en cours »). $true quand il est libre.
    if (-not (Test-MsiBusy)) { return $true }
    Write-Host '   >> Une autre installation est en cours : j''attends qu''elle se termine (5 min au plus)...' -ForegroundColor DarkCyan
    $sw = [Diagnostics.Stopwatch]::StartNew()
    while ((Test-MsiBusy) -and $sw.Elapsed.TotalSeconds -lt $TimeoutSec) { Start-Sleep -Seconds 2 }
    return (-not (Test-MsiBusy))
}

function Test-CleanStillBlocked([string]$Label) {
    # Juste avant la question : un redémarrage ou une installation a pu apparaître depuis la section 11
    # (mises à jour Windows installées par JARVIS juste avant). TiWorker en cours : attente de 5 minutes au plus.
    # $true = cible écartée, sans question.
    $b = Get-WuBusyState
    $why = Get-ServicingBlocker $b.RebootPending $false $b.InstallerBusy
    if (-not $why -and $b.ServicingBusy -and -not (Wait-ServicingIdle 300)) {
        $why = 'Windows installe des composants depuis plus de 5 minutes'
    }
    if (-not $why) { return $false }
    Write-Action 'INFO' ($Label + ' : pas de nettoyage maintenant, ' + $why)
    Write-Host '          Relance un scan plus tard (après un redémarrage si des mises à jour l''attendent).' -ForegroundColor DarkGray
    return $true
}

function Invoke-CleanTarget($Target) {
    # Une question par cible (réponse par défaut : non), posée sur un état relu juste avant (taille, empêchements),
    # puis le résultat vérifié par une nouvelle mesure, ajouté au rapport
    $size = Format-Bytes $Target.Bytes
    $who = ''
    if ($script:CleanUser) { $who = ', compte ' + $script:CleanUser }
    switch ($Target.Key) {
        'Temp' {
            $dirs = @((Join-Path $WinDir 'Temp'))
            if (Test-SafeTempPath $env:TEMP) { $dirs = @($env:TEMP) + $dirs }
            # Taille relue juste avant la question : les installations faites depuis le scan ont pu en ajouter
            # (PC-LV le 21/11/2026 : environ 135 Mo mesurés pendant le scan, 578 Mo supprimés)
            $now = [int64]0
            $known = $true
            foreach ($p in $dirs) {
                $m0 = Measure-AgedFiles $p 24
                if ($m0.Ok) { $now += $m0.AgedBytes } else { $known = $false }
            }
            if ($known) {
                if ($now -le 0) { return }
                $size = Format-Bytes $now
            }
            if (-not (Read-YesNo ('   >> Supprimer les fichiers temporaires de plus de 24 h ({0}{1}) ?' -f $size, $who))) { return }
            $res = [pscustomobject]@{ Ok = $false; FreedBytes = [int64]0; LeftBytes = [int64]0; Reason = '' }
            $notes = @()
            foreach ($p in $dirs) {
                $m1 = Measure-AgedFiles $p 24
                $r = Clear-TempFolder $p 24
                if (-not $r.Ok) { $notes += $r.Reason; continue }
                $m2 = Measure-AgedFiles $p 24
                if ($m1.Ok -and $m2.Ok) {
                    $res.Ok = $true
                    $res.FreedBytes += [math]::Max([int64]0, $m1.AgedBytes - $m2.AgedBytes)
                    $res.LeftBytes += $m2.AgedBytes
                } elseif (-not $isAdmin) {
                    $notes += ($p + ' : droits admin nécessaires')
                } else {
                    $notes += ($p + ' : non mesuré, résultat inconnu')
                }
            }
            $res.Reason = $notes -join ' ; '
            Write-CleanResult 'Fichiers temporaires' $res
        }
        'RecycleBin' {
            # Contenu relu juste avant : un fichier jeté depuis la section 11 doit figurer dans la question
            $rb = Get-RecycleBinState
            if (-not $rb.Ok) { Write-Action 'INFO' 'Corbeille : lecture impossible, rien n''a été supprimé'; return }
            if ($rb.Count -eq 0) { return }
            if (-not (Read-YesNo ('   >> Vider la corbeille ({0}, {1} élément(s), contenu perdu définitivement) ?' -f (Format-Bytes $rb.Bytes), $rb.Count))) { return }
            $r = Clear-RecycleBinChecked
            if (-not $r.Ok) { Write-Action 'WARN' ('Corbeille : ' + $r.Reason) }
            elseif ($r.LeftCount -eq 0) { Write-Action 'OK' ('Corbeille vidée : {0} libérés' -f (Format-Bytes $r.FreedBytes)) }
            else { Write-Action 'WARN' ('Corbeille : {0} libérés, {1} élément(s) encore présent(s)' -f (Format-Bytes $r.FreedBytes), $r.LeftCount) }
        }
        'WuCache' {
            if ($script:WuOpened) {
                # Le vider arrête Windows Update : la recherche ou le téléchargement lancés dans la page ouverte par
                # JARVIS seraient coupés (Get-WuBusyState ne voit que les installations ; PC-LV, 21/11/2026)
                Write-Action 'INFO' 'Cache Windows Update : pas de nettoyage maintenant, Windows Update vient d''être ouvert'
                Write-Host '          Relance un scan plus tard pour le vider.' -ForegroundColor DarkGray
                return
            }
            if (Test-CleanStillBlocked 'Cache Windows Update') { return }
            Write-Host '   [i] Fichiers de mises à jour déjà téléchargés. Windows Update est arrêté quelques secondes puis relancé ;' -ForegroundColor DarkGray
            Write-Host '       il retéléchargera au besoin ce qui manque.' -ForegroundColor DarkGray
            if (-not (Read-YesNo ('   >> Vider le cache de Windows Update ({0}) ?' -f $size))) { return }
            $r = Clear-WuCache
            Write-CleanResult 'Cache Windows Update' $r
            if (-not $r.Restarted) {
                Write-Action 'WARN' 'Windows Update ou BITS n''a pas redémarré : redémarre le PC pour le relancer'
            }
        }
        'DoCache' {
            $d = Get-DoCacheState
            if (-not $d.Ok -or $d.Busy -ne $false) {
                Write-Action 'INFO' 'Optimisation de livraison : pas de nettoyage maintenant (téléchargement en cours ou état illisible)'
                return
            }
            Write-Host '   [i] Copies de mises à jour gardées pour les partager avec d''autres PC ; Windows les retire de lui-même' -ForegroundColor DarkGray
            Write-Host '       après quelques jours. Les vider ne change rien au fonctionnement du PC.' -ForegroundColor DarkGray
            if (-not (Read-YesNo ('   >> Vider le cache de l''optimisation de livraison ({0}) ?' -f (Format-DoSize $d)))) { return }
            Write-CleanResult 'Optimisation de livraison' (Clear-DoCache)
        }
        'Dumps' {
            Write-Host '   [i] Fichiers écrits lors d''anciens plantages (applications ou écrans bleus), utiles seulement pour en' -ForegroundColor DarkGray
            Write-Host '       chercher la cause. Seuls ceux de plus de 30 jours sont supprimés.' -ForegroundColor DarkGray
            if (-not (Read-YesNo ('   >> Supprimer les vidages mémoire de plus de 30 jours ({0}{1}) ?' -f $size, $who))) { return }
            $keys = @('CrashDumps')
            if ($isAdmin -and -not $script:KeepSysDumps) { $keys += @('Minidump', 'MemoryDump') }
            $res = [pscustomobject]@{ Ok = $false; FreedBytes = [int64]0; LeftBytes = [int64]0; Reason = '' }
            $notes = @()
            foreach ($k in $keys) {
                $r = Clear-CleanTarget $k 720 '.dmp'
                if ($r.Ok) { $res.Ok = $true; $res.FreedBytes += $r.FreedBytes; $res.LeftBytes += $r.LeftBytes }
                else { $notes += $r.Reason }
            }
            $res.Reason = $notes -join ' ; '
            Write-CleanResult 'Vidages mémoire' $res
        }
        'Components' {
            if (Test-CleanStillBlocked 'Composants Windows') { return }
            if ($script:WuTouched) {
                # Des mises à jour viennent d'être installées : l'analyse du scan n'est plus à jour
                $script:ComponentInfo = Invoke-ComponentAnalysis
                if ($null -eq $script:ComponentInfo) { Write-Action 'INFO' 'Composants Windows : nouvelle analyse impossible, nettoyage non proposé'; return }
                if ($script:ComponentInfo.Recommended -ne 'YES') { Write-Action 'INFO' 'Composants Windows : plus de nettoyage conseillé après les mises à jour'; return }
            }
            $upTo = ''
            if ($null -ne $script:ComponentInfo -and $null -ne $script:ComponentInfo.BackupBytes) {
                $upTo = ' (jusqu''à ' + (Format-Bytes $script:ComponentInfo.BackupBytes) + ')'
            }
            Write-Host '   [i] Retire les anciennes versions de composants remplacées par des mises à jour. Sans /ResetBase :' -ForegroundColor DarkGray
            Write-Host '       la désinstallation des mises à jour reste possible. Jusqu''à 30 min, ne ferme pas la fenêtre.' -ForegroundColor DarkGray
            if (-not (Read-YesNo ('   >> Nettoyer les anciens composants de Windows' + $upTo + ' ?'))) { return }
            Invoke-ComponentCleanup
        }
    }
}

function Get-ChkdskVerdict($Code) {
    # Code de sortie de « chkdsk X: /scan » (documentation de chkdsk : 0 aucune erreur, 1 corrigées, 2 nettoyage,
    # 3 erreurs non corrigées). v3.26 (audit, constat V7) : code absent ou non numérique = UNKNOWN (avant,
    # [int]$null valait 0, soit « aucune erreur », règle 24) ; code hors 0 à 3 (outil en panne ou refusé) =
    # UNKNOWN, plus « erreurs détectées, correction nécessaire » en rouge. Fonction pure, T1.
    $n = ConvertTo-IntOrNull $Code
    if ($null -eq $n) { return 'UNKNOWN' }
    if ($n -eq 0) { return 'CLEAN' }
    if ($n -eq 1) { return 'FIXED' }
    if ($n -eq 2) { return 'MINOR' }
    if ($n -eq 3) { return 'ERRORS' }
    return 'UNKNOWN'
}

function ConvertFrom-WingetText {
    param([string]$Raw)
    # Fin de ligne Windows retirée d'abord, puis seul le texte après le dernier retour chariot est gardé
    # (animation de progression). Sans le TrimEnd, chaque ligne CRLF devenait vide : liste toujours vide.
    # Caractères de contrôle retirés ici même (regex en ligne : cette fonction est aussi exécutée dans un job,
    # où les autres fonctions de JARVIS n'existent pas).
    $lines = $Raw -split "`n" | ForEach-Object { ((($_.TrimEnd("`r") -split "`r")[-1]) -replace '[\x00-\x1F\x7F-\x9F]', '').TrimEnd() }
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

function Get-WingetUnknownNames {
    # Noms des applications de version inconnue, lus dans la liste de « winget upgrade --include-unknown » déjà
    # analysée par ConvertFrom-WingetText (v3.27, MAJÉRION le 25/11/2026 : sans le module winget, le rapport
    # disait « 1 » sans dire laquelle). winget écrit « Unknown » sans le traduire (relevé le 25/11/2026, version
    # française). Autonome (param dans le corps) : passée telle quelle au job. Fonction pure, testée en T1.
    param([object[]]$Items)
    return @(@($Items) | Where-Object { $null -ne $_ -and ([string]$_.Installed).Trim() -eq 'Unknown' -and $_.Name } |
             ForEach-Object { [string]$_.Name })
}

function Test-WingetNoUpgrade([string]$Raw) {
    # Message explicite de winget : aucune mise à jour (français ou anglais), ou seulement des
    # applications de version inconnue (winget n'affiche alors ni tableau ni « aucune mise à niveau »)
    if ($Raw -match 'Aucune mise . niveau disponible|No available upgrade found|Aucun package install. ne correspond|No installed package found') { return $true }
    return ($Raw -notmatch '(?m)^\s*-{10,}\s*$' -and (Get-WingetUnknownCount $Raw) -gt 0)
}

function Test-WingetStillListed([string]$Id, $Rows) {
    # winget a répondu « terminé » pour $Id : $true si la nouvelle liste de winget ($Rows, ConvertFrom-WingetText) le
    # propose encore. Un identifiant coupé par winget (terminé par des points de suspension) se compare par son début,
    # à condition qu'il en reste au moins 3 caractères. Fonction pure, testée en T1.
    if (-not $Id) { return $false }
    $ell = [string][char]0x2026
    foreach ($r in @($Rows)) {
        if ($null -eq $r) { continue }
        $rid = [string]$r.Id
        if ($rid -eq $Id) { return $true }
        if ($rid.EndsWith($ell)) {
            $head = $rid.TrimEnd([char]0x2026)
            if ($head.Length -ge 3 -and $Id.StartsWith($head, [StringComparison]::OrdinalIgnoreCase)) { return $true }
        }
    }
    return $false
}

function Get-WingetScanState([string]$Raw, [int]$Parsed) {
    # Que prouve la réponse de « winget upgrade » ? LIST : un tableau a été lu ($Parsed lignes).
    # NONE : winget dit lui-même qu'il n'y a rien à mettre à jour. UNREADABLE : ni l'un ni l'autre,
    # on ne conclut pas (jamais « aucune mise à jour » par défaut).
    if ($Parsed -gt 0) { return 'LIST' }
    if (Test-WingetNoUpgrade $Raw) { return 'NONE' }
    return 'UNREADABLE'
}

function Test-NoEventError([string]$ErrorId) {
    # Get-WinEvent signale « aucun événement trouvé » par une erreur : c'est une lecture réussie (0 événement).
    # Toute autre erreur (journal ou fournisseur absent, accès refusé) est une lecture en échec.
    return ($ErrorId -like 'NoMatchingEventsFound*')
}

function Test-AppxInUseMessage([string]$Text) {
    # Journal de déploiement de Windows : erreur 0x80073D02, « impossible d'installer, car les applications
    # suivantes doivent être fermées ». Le code est le même dans toutes les langues de Windows.
    return ($Text -match '0x80073D02')
}

function Get-WuDownloadState($Code, $Count, $Ready) {
    # Téléchargement Windows Update : $Code = code de résultat (2 = réussi, 3 = réussi avec erreurs),
    # $Count = mises à jour demandées, $Ready = celles que Windows Update déclare téléchargées.
    if ([int]$Ready -le 0) { return 'FAILED' }
    if ([int]$Code -eq 2 -and [int]$Ready -ge [int]$Count) { return 'READY' }
    return 'PARTIAL'
}

function Get-WuInstallSummary([int[]]$Codes) {
    # Codes de résultat par mise à jour : 2 = installée, 3 = installée avec avertissement, autre = échec.
    # State : OK, WARN (au moins un avertissement), FAIL (au moins un échec), NONE (rien n'a été installé)
    $r = [pscustomobject]@{ Ok = 0; Warn = 0; Fail = 0; State = 'NONE' }
    foreach ($c in @($Codes)) {
        if ($c -eq 2) { $r.Ok++ } elseif ($c -eq 3) { $r.Warn++ } else { $r.Fail++ }
    }
    if ($r.Fail -gt 0) { $r.State = 'FAIL' }
    elseif ($r.Warn -gt 0) { $r.State = 'WARN' }
    elseif ($r.Ok -gt 0) { $r.State = 'OK' }
    return $r
}

function Get-WuHistoryKey([string]$Title, [string]$UpdateId) {
    # Même mise à jour d'une tentative à l'autre : numéro KB du titre (les définitions de Defender changent
    # de version dans leur titre, pas de numéro KB), sinon identifiant de la mise à jour, sinon le titre.
    if ($Title -match '\b(KB\d{6,8})\b') { return $Matches[1].ToUpperInvariant() }
    if ($UpdateId) { return $UpdateId.ToLowerInvariant() }
    return $Title
}

function Get-WuHistoryFailures {
    # Historique de Windows Update (QueryHistory) : installations en échec (code de résultat 4) ou abandonnées
    # (5) depuis $Since, sans réussite plus récente de la même mise à jour. Les applications du Microsoft Store
    # (titre du type « 9NCBCSZSJRSB-SpotifyAB.SpotifyMusic ») sont comptées à part : le Store les reprend
    # lui-même sans laisser de trace dans cet historique (constaté le 19/11/2026) et la section Store dit ce qui
    # reste à faire. Entrées : objets Date, Operation (1 = installation), ResultCode, HResult, Title, UpdateId.
    # Fonction pure, testée en T1.
    # $Pending : mises à jour encore proposées (objets Title, UpdateId), ou $null si la recherche a échoué.
    # Un échec qui n'est plus proposé (remplacé par une version plus récente, ou réussi sous un autre nom)
    # compte dans Resolved : il n'y a plus rien à faire.
    # Lignes venues du journal Système (Source = 'Log', ConvertFrom-WuClientEvent) : l'API ne voit pas toujours ces
    # mises à jour, ni dans l'historique ni dans la recherche (KB5132057 le 21/11/2026, absente des deux) ; la liste
    # $Pending ne sert donc que pour une mise à jour que l'API connaît. $OsBuild (« 26300.9974 ») : une mise à jour
    # dont le titre donne une version de Windows déjà atteinte ou dépassée (« (26300.10075) ») est réglée.
    param([object[]]$Entries, [datetime]$Since, [object[]]$Pending = $null, [string]$OsBuild = '')
    $r = [pscustomobject]@{ Failed = @(); Resolved = 0; Store = 0 }
    $osMaj = $null; $osUbr = $null
    if ($OsBuild -match '^(\d+)\.(\d+)$') { $osMaj = [int]$Matches[1]; $osUbr = [int]$Matches[2] }
    $apiKeys = @{}
    foreach ($e in @($Entries)) {
        if ($null -eq $e) { continue }
        $src = $e.PSObject.Properties['Source']
        if ($null -eq $src -or [string]$src.Value -ne 'Log') { $apiKeys[(Get-WuHistoryKey ([string]$e.Title) ([string]$e.UpdateId))] = $true }
    }
    $pendKeys = $null
    if ($null -ne $Pending) {
        $pendKeys = @{}
        foreach ($p in @($Pending)) {
            if ($null -eq $p) { continue }
            $pendKeys[(Get-WuHistoryKey ([string]$p.Title) ([string]$p.UpdateId))] = $true
            if ($p.UpdateId) { $pendKeys[([string]$p.UpdateId).ToLowerInvariant()] = $true }
        }
    }
    $okLast = @{}
    $fails = @()
    foreach ($e in @($Entries)) {
        if ($null -eq $e -or [int]$e.Operation -ne 1) { continue }
        $k = Get-WuHistoryKey ([string]$e.Title) ([string]$e.UpdateId)
        if ([int]$e.ResultCode -in 2, 3) {
            if (-not $okLast.ContainsKey($k) -or [datetime]$e.Date -gt $okLast[$k]) { $okLast[$k] = [datetime]$e.Date }
        } elseif ([int]$e.ResultCode -in 4, 5 -and [datetime]$e.Date -ge $Since) {
            $fails += [pscustomobject]@{ Key = $k; Entry = $e }
        }
    }
    $seen = @{}
    $list = @()
    foreach ($f in @($fails | Sort-Object { [datetime]$_.Entry.Date } -Descending)) {
        if ($seen.ContainsKey($f.Key)) { continue }
        $seen[$f.Key] = $true
        $t = [string]$f.Entry.Title
        if ($t -cmatch '^[0-9A-Z]{12}-') { $r.Store++; continue }
        if ($okLast.ContainsKey($f.Key) -and $okLast[$f.Key] -gt [datetime]$f.Entry.Date) { $r.Resolved++; continue }
        if ($null -ne $osMaj -and $t -match '\((\d{5})\.(\d+)\)' -and [int]$Matches[1] -eq $osMaj -and [int]$Matches[2] -le $osUbr) {
            $r.Resolved++; continue
        }
        if ($null -ne $pendKeys -and $apiKeys.ContainsKey($f.Key) -and -not $pendKeys.ContainsKey($f.Key) -and -not $pendKeys.ContainsKey(([string]$f.Entry.UpdateId).ToLowerInvariant())) {
            $r.Resolved++; continue
        }
        $list += [pscustomobject]@{ Title = $t; Code = ('0x{0:X8}' -f [int]$f.Entry.HResult); Date = [datetime]$f.Entry.Date }
    }
    $r.Failed = $list
    return $r
}

function ConvertFrom-WuClientEvent {
    # Événements 19 (installation réussie) et 20 (échec) du journal Système (Microsoft-Windows-WindowsUpdateClient),
    # rendus sous la forme des lignes de l'historique pour Get-WuHistoryFailures. L'historique de l'API Windows Update
    # ne montre pas tout : le 21/11/2026, les cinq échecs de KB5132057 (0x80070306) n'y étaient pas, seul ce journal
    # les gardait. $Data : champs de l'événement (updateTitle, updateGuid, errorCode, comme dans son XML).
    # $null : événement inexploitable. Fonction pure, testée en T1.
    # Applications du Store écartées (titre « 9PLM9XGG6VKS-OpenAI.Codex ») : une ligne par version dans ce journal,
    # 21 au lieu de 1 le 21/11/2026 ; l'historique de l'API les compte déjà et la section 03 dit ce qui reste à faire.
    param([int]$Id, [datetime]$Date, [hashtable]$Data)
    if (($Id -ne 19 -and $Id -ne 20) -or $null -eq $Data) { return $null }
    $t = ([string]$Data['updateTitle']).Trim()
    if (-not $t -or $t -cmatch '^[0-9A-Z]{12}-') { return $null }
    $rc = 2
    $hr = 0
    if ($Id -eq 20) {
        $rc = 4
        $c = ([string]$Data['errorCode']).Trim()
        if ($c -notmatch '^0x([0-9A-Fa-f]{1,8})$') { return $null }
        $hr = [Convert]::ToInt32($Matches[1], 16)
    }
    $g = ([string]$Data['updateGuid']).Trim().Trim('{', '}').ToLowerInvariant()
    return [pscustomobject]@{ Date = $Date; Operation = 1; ResultCode = $rc; HResult = $hr; Title = $t; UpdateId = $g; Source = 'Log' }
}

function Test-WuPreviewTitle([string]$Title) {
    # Préversion facultative (« Mise à jour de la préversion », « Preview ») : ses corrections arrivent ensuite avec
    # la mise à jour de sécurité du mois suivant, rien n'oblige à l'installer. Fonction pure, testée en T1.
    return ($Title -match 'pr.version|\bpreview\b')
}

function Get-WuErrorHint([string]$Code) {
    # Explication courte des codes d'échec les plus fréquents (codes publics de Windows Update et du
    # magasin de composants). $null : code sans explication, il est affiché seul.
    switch -Regex ($Code) {
        '^0x(80073712|800F0831|800F081F)$' { return 'fichiers de Windows abîmés : le scan complet [2], en administrateur, les vérifie et propose une réparation' }
        '^0x80070070$' { return 'espace disque insuffisant : libère de la place sur le disque C:' }
        '^0x800F0922$' { return 'souvent un VPN actif ou une partition réservée de Windows trop pleine' }
        '^0x(80240034|8024402C|80072EE2|80072EFD)$' { return 'téléchargement impossible : vérifie la connexion Internet' }
        '^0x8024000B$' { return 'opération annulée (souvent par un arrêt ou un redémarrage du PC)' }
        # KB5132057 sur le PC de Thomas, 21/11/2026 : « Hydration failed » dans CBS.log, fichier téléchargé intact, copie
        # du PC impossible à mettre à jour (fonctions non activées : Hyper-V, IIS, SMB1). Reconnu par Microsoft en novembre.
        # 0x800F0993 (PSFX_E_REBASE_HYDRATION_CANDIDATES_MISSING, nom lu dans CBS.log) : même mise à jour, même PC, le
        # 22/11/2026 à 17 h 50 ; même cause (fichiers de Windows que la mise à jour ne peut pas reconstruire).
        '^0x(80070306|800F0993)$' { return 'Windows n''a pas pu mettre à jour certaines copies de ses fichiers gardées sur le PC (défaut connu chez Microsoft) ; une réinstallation qui garde fichiers et applications le corrige si l''échec dure' }
        # Pilote d'imprimante Canon sur PC-LV le 21/11/2026 : imprimante absente, l'échec revient à chaque essai
        '^0x800F020B$' { return 'appareil introuvable, souvent une imprimante ou un périphérique éteint ou débranché : branche-le et allume-le, sinon ce pilote peut être ignoré' }
    }
    return $null
}

function Get-WingetErrorHint([string]$Code) {
    # Explication courte d'un code de sortie de winget, d'après ses journaux (PC-LV, 21/11/2026). $null : code
    # sans explication, il est affiché seul. Fonction pure, testée en T1.
    switch -Regex ($Code) {
        # « Package hash verification failed » : l'éditeur a changé son fichier sans que winget le sache (CCleaner)
        '^0x8A150011$' { return 'le fichier de l''éditeur ne correspond pas à celui attendu : winget refuse de l''installer, par sécurité. Réessaie dans quelques jours ou mets-la à jour depuis l''application' }
        # « ShellExecute installer failed » : le programme d'installation de l'éditeur a échoué (Java : code 1618)
        '^0x8A150006$' { return 'son programme d''installation a échoué, souvent parce qu''une autre installation tournait : redémarre le PC, puis relance J.A.R.V.I.S.' }
        '^0x80070002$' { return 'un fichier manquait pendant l''installation : relance un scan pour réessayer' }
        # 0x8019xxxx = réponse HTTP d'erreur au téléchargement (0x80190193 = 403, « Interdit » selon « winget error ») :
        # le site de l'éditeur a refusé le fichier (Intel Extreme Tuning Utility sur MAJÉRION, 25/11/2026)
        '^0x80190(1[9A-F][0-9A-F]|2[0-5][0-9A-F])$' { return 'le site de l''éditeur a refusé le téléchargement : réessaie dans quelques jours, ou prends la nouvelle version sur le site de l''éditeur' }
    }
    return $null
}

function Test-WingetNotApplicable($ExitCode) {
    # Code de « winget upgrade » qui veut dire « pas de version adaptée à cette installation » : ce n'est pas une
    # panne, l'application doit se mettre à jour par elle-même. 0x8A15002B « aucune mise à niveau applicable » ;
    # 0x8A15008E « la mise à niveau utilise une technologie d'installation différente » (Epic Online Services sur
    # MAJÉRION, 25/11/2026, sens lu par « winget error »). Fonction pure, testée en T1.
    if ($null -eq $ExitCode) { return $false }
    try { $h = '{0:X8}' -f $ExitCode } catch { return $false }
    return ($h -eq '8A15002B' -or $h -eq '8A15008E')
}

function Get-WingetPresence($ExitCode) {
    # Code de sortie de « winget list --id X --exact » : PRESENT (0), ABSENT (0x8A150014, aucun paquet installé ne
    # correspond, relevé le 21/11/2026), UNKNOWN pour tout le reste (winget introuvable, source illisible).
    # Fonction pure, testée en T1.
    if ($null -eq $ExitCode) { return 'UNKNOWN' }
    try { $h = '{0:X8}' -f $ExitCode } catch { return 'UNKNOWN' }
    if ($h -eq '00000000') { return 'PRESENT' }
    if ($h -eq '8A150014' -or $h -eq 'FFFFFFFF8A150014') { return 'ABSENT' }
    return 'UNKNOWN'
}

function Get-WingetVersionChange([string]$Before, [string]$After) {
    # Version inscrite avant et après une mise à jour winget « terminée » mais encore proposée : CHANGED (Google Play
    # Games sur PC-LV le 21/11/2026 : 26.6.957.0 puis 26.11.281.0, winget proposant toujours 159.0.8140.0, numérotée
    # autrement), SAME, ou UNKNOWN si l'une est illisible (vide, « < 1.4.7 », « Unknown », coupée par winget).
    # Fonction pure, testée en T1.
    $b = ([string]$Before).Trim()
    $a = ([string]$After).Trim()
    $ell = [string][char]0x2026
    foreach ($v in @($b, $a)) {
        if (-not $v -or $v -notmatch '^\d' -or $v.EndsWith($ell)) { return 'UNKNOWN' }
    }
    if ($b -eq $a) { return 'SAME' }
    return 'CHANGED'
}

function Get-MachineLabel([string]$Maker, [string]$Model) {
    # « Fabricant Modèle », sans répéter le fabricant quand le modèle commence déjà par lui (PC-LV le 21/11/2026 :
    # « HP » et « HP ENVY x360 m6 Convertible » donnaient « HP HP ENVY... »). Fonction pure, testée en T1.
    $mk = ([string]$Maker).Trim()
    $md = ([string]$Model).Trim()
    if (-not $mk) { return $md }
    if (-not $md) { return $mk }
    if ($md.StartsWith($mk, [StringComparison]::OrdinalIgnoreCase)) { return $md }
    return ($mk + ' ' + $md)
}

function Split-NativeOutput {
    # Sortie d'un exécutable capturée par « 2>&1 » : texte normal et messages d'erreur (stderr, que
    # PowerShell 5.1 rend sous forme d'ErrorRecord) séparés, pour que l'analyse ne lise que le texte de
    # l'outil. Autonome (n'appelle aucune autre fonction de JARVIS) : passée telle quelle aux jobs. T1.
    param([object[]]$Lines)
    $o = New-Object System.Text.StringBuilder
    $e = New-Object System.Text.StringBuilder
    foreach ($l in @($Lines)) {
        if ($null -eq $l) { continue }
        if ($l -is [System.Management.Automation.ErrorRecord]) { [void]$e.Append($l.ToString()).Append("`r`n") }
        else { [void]$o.Append([string]$l).Append("`r`n") }
    }
    return [pscustomobject]@{ Out = $o.ToString(); Err = $e.ToString().Trim() }
}

function Get-StoreAppLabel([string]$Pfn, $StartNames) {
    # Nom lisible d'une application du Store : nom du menu Démarrer (identifiant « famille!App »), sinon le
    # nom du paquet sans l'éditeur (« SpotifyAB.SpotifyMusic_zpdnekdrzrea0 » donne « SpotifyMusic »). T1.
    if (-not $Pfn) { return '' }
    if ($StartNames -and $StartNames.ContainsKey($Pfn)) { return [string]$StartNames[$Pfn] }
    $name = ($Pfn -split '_')[0]
    $parts = @($name -split '\.')
    if ($parts.Count -gt 1) { $name = ($parts[1..($parts.Count - 1)] -join '.') }
    # « XboxIdentityProvider » devient « Xbox Identity Provider »
    return ($name -creplace '(?<=[a-z])(?=[A-Z])', ' ')
}

function Get-StoreAutoVerdict([string]$Setting) {
    # Mises à jour automatiques des applications du Store (AppInstallManager.AutoUpdateSetting). T1.
    switch ($Setting) {
        'Enabled' { return 'OK' }
        'EnabledByPolicy' { return 'OK' }
        'Disabled' { return 'WARN' }
        'DisabledByPolicy' { return 'POLICY' }
    }
    return 'UNKNOWN'
}

function Get-StoreUpdateVerdict([string]$State, $StillListed) {
    # Résultat d'une mise à jour lancée par le Store. $State : dernier état lu (Completed, Error, Canceled,
    # NoUpdate quand le Store n'a rien à faire, autre = pas terminé). $StillListed : la nouvelle recherche la
    # propose encore ($true), ne la propose plus ($false), ou n'a pas pu être faite ($null).
    # « Completed » ne suffit pas : le 19/11/2026, le Store a répondu « Completed » en réinstallant la même
    # version d'un composant ; la preuve est la nouvelle recherche. Fonction pure, testée en T1.
    # PAUSED : le Store attend un geste (pause, batterie, Wi-Fi limité). WAITING : jamais démarrée par le Store.
    # NOSTART : le Store n'a rien lancé alors que la mise à jour est toujours proposée.
    if ($State -eq 'Error') { return 'FAIL' }
    if ($State -eq 'Canceled') { return 'CANCELED' }
    if ($State -like 'Paused*') { return 'PAUSED' }
    if ($State -in @('ReadyToDownload', 'NotStarted')) { return 'WAITING' }
    if ($State -notin @('Completed', 'NoUpdate')) { return 'PENDING' }
    if ($null -eq $StillListed) { return 'UNVERIFIED' }
    if ($StillListed -and $State -eq 'NoUpdate') { return 'NOSTART' }
    if ($StillListed) { return 'NOTDONE' }
    return 'OK'
}

function Get-BiosSearchName([string]$BoardProduct, [string]$SystemModel, [string]$From) {
    # Nom à chercher sur la page de support : modèle du PC si le lien vient du fabricant du PC, sinon carte mère.
    # Les textes de remplissage des PC montés (« To Be Filled By O.E.M. », « Default string ») sont écartés ;
    # si le modèle du PC diffère de la carte (carte MSI « MS-7C02 »), les deux sont donnés. '' : rien d'utile. T1.
    $filler = '^\s*$|To be filled|Default string|System Product Name|System manufacturer|O\.E\.M|Not Applicable'
    $b = ([string]$BoardProduct).Trim()
    $m = ([string]$SystemModel).Trim()
    if ($b -match $filler) { $b = '' }
    if ($m -match $filler) { $m = '' }
    if ($From -ne 'System' -or -not $m) { return $b }
    if (-not $b -or $b -eq $m) { return $m }
    # Un nom qui contient déjà l'autre suffit (v3.21 : « MS-7B98 (carte mère Z390-A PRO (MS-7B98)) » vu sur l'autre PC)
    if ($b.IndexOf($m, [StringComparison]::OrdinalIgnoreCase) -ge 0) { return $b }
    if ($m.IndexOf($b, [StringComparison]::OrdinalIgnoreCase) -ge 0) { return $m }
    return ('{0} (carte mère {1})' -f $m, $b)
}

function Get-BiosSupportLink([string]$BoardMaker, [string]$SystemMaker, [string]$SystemModel) {
    # Page de support du fabricant (adresses ouvertes dans un navigateur le 19/11/2026). Le fabricant du PC
    # (portable, PC de marque) passe avant celui de la carte mère ; une machine virtuelle n'est pas un PC de
    # marque. Rend Name, Url et From (System ou Board), ou $null si le fabricant n'est pas dans la table. T1.
    $table = @(
        @('Dell', 'Dell', 'https://www.dell.com/support/home/fr-fr'),
        @('^(HP|Hewlett)', 'HP', 'https://support.hp.com/fr-fr/drivers'),
        @('Lenovo', 'Lenovo', 'https://pcsupport.lenovo.com/fr/fr'),
        @('Acer', 'Acer', 'https://www.acer.com/fr-fr/support'),
        @('Samsung', 'Samsung', 'https://www.samsung.com/fr/support/'),
        @('Medion', 'Medion', 'https://www.medion.com/fr/service/'),
        @('Dynabook|Toshiba', 'Dynabook', 'https://fr.dynabook.com/support/'),
        @('ASUS', 'ASUS', 'https://www.asus.com/fr/support/download-center/'),
        @('Gigabyte', 'Gigabyte', 'https://www.gigabyte.com/fr/Support'),
        @('Micro-Star|^MSI\b', 'MSI', 'https://fr.msi.com/support'),
        @('ASRock', 'ASRock', 'https://www.asrock.com/support/index.fr.asp')
    )
    $sources = @()
    if ($SystemModel -notmatch 'Virtual|VMware') {
        if ($SystemMaker -match 'Microsoft' -and $SystemModel -match 'Surface') {
            return [pscustomobject]@{ Name = 'Microsoft Surface'; Url = 'https://support.microsoft.com/fr-fr/surface'; From = 'System' }
        }
        $sources += , @('System', $SystemMaker)
    }
    $sources += , @('Board', $BoardMaker)
    foreach ($s in $sources) {
        if (-not $s[1]) { continue }
        foreach ($t in $table) {
            if ($s[1] -match $t[0]) { return [pscustomobject]@{ Name = $t[1]; Url = $t[2]; From = $s[0] } }
        }
    }
    return $null
}

function Get-AvState($ProductState) {
    # productState d'un antivirus du Centre de sécurité (SecurityCenter2). v3.23 (audit, constat T10) : valeur absente
    # ou non numérique = $null (lecture impossible) ; avant, [int]$null valait 0, soit « installé mais inactif ».
    $n = ConvertTo-IntOrNull $ProductState
    if ($null -eq $n -or $n -lt 0) { return $null }
    $hex = '{0:X6}' -f $n
    return [pscustomobject]@{
        On       = ($hex.Substring(2, 2) -in @('10', '11'))
        UpToDate = ($hex.Substring(4, 2) -eq '00')
    }
}

function Get-FirewallVerdict($Off, $Others) {
    # Pare-feu (section 06). v3.26 (audit, constats V14 et V16) : le pare-feu d'un autre logiciel de sécurité,
    # déclaré actif au Centre de sécurité de Windows (classe FirewallProduct, même productState que les
    # antivirus), compte : quand un tel logiciel s'installe, il coupe normalement le pare-feu de Windows, qui
    # sortait alors en FAIL. Le pare-feu de Windows lui-même n'est pas dans cette liste. Fonction pure, T1.
    # $Off    : profils du pare-feu de Windows désactivés (noms affichés) ; $null = lecture impossible
    # $Others : autres pare-feu, objets { Name ; On } (On = $null : état illisible) ; $null = Centre de sécurité illisible
    # Rend { Level ; Text ; Subs } (Level : OK, FAIL ou INFO ; Subs : lignes de conseil).
    $on = @(); $offOthers = @(); $unread = @()
    foreach ($o in @($Others)) {
        if ($null -eq $o) { continue }
        $n = [string]$o.Name
        if ($null -eq $o.On) { $unread += $n } elseif ($o.On) { $on += $n } else { $offOthers += $n }
    }
    $r = [pscustomobject]@{ Level = 'INFO'; Text = 'lecture impossible'; Subs = @() }
    if ($null -ne $Off -and @($Off).Count -eq 0) {
        $r.Level = 'OK'; $r.Text = 'actif sur tous les profils'
        return $r
    }
    if ($on.Count -gt 0) {
        $r.Level = 'OK'; $r.Text = 'géré par ' + ($on -join ', ')
        if ($null -ne $Off) { $r.Text += ' (celui de Windows est coupé, c''est normal)' }
        return $r
    }
    if ($null -eq $Off) { return $r }
    $where = 'réseau ' + (@($Off) -join ', ')
    if ($unread.Count -gt 0) {
        # Pare-feu de Windows coupé, celui de l'autre logiciel illisible : rien ne permet de conclure
        $r.Text = 'celui de Windows désactivé (' + $where + '), état de ' + ($unread -join ', ') + ' illisible'
        $r.Subs = @('Ouvre ' + ($unread -join ', ') + ' et vérifie que son pare-feu est actif. Sinon : Sécurité Windows',
                    '> Pare-feu et protection du réseau > chaque réseau désactivé > Activé.')
        return $r
    }
    $r.Level = 'FAIL'; $r.Text = 'désactivé : ' + $where
    if ($offOthers.Count -gt 0) {
        $r.Subs = @('Le pare-feu de ' + ($offOthers -join ', ') + ' est coupé lui aussi : rouvre ce logiciel et réactive-le,',
                    'ou Sécurité Windows > Pare-feu et protection du réseau > chaque réseau désactivé > Activé.')
    } else {
        $r.Subs = @('Sécurité Windows > Pare-feu et protection du réseau > chaque réseau désactivé > Activé.',
                    'Si un autre logiciel de sécurité gère ton pare-feu, vérifie plutôt qu''il est actif.')
    }
    return $r
}

function Get-StartupApprovedState($Bytes) {
    # Programmes au démarrage (section 08). Valeur « StartupApproved » de l'entrée, écrite par le Gestionnaire des
    # tâches (Applications de démarrage) : premier octet pair = activé (02, 06), impair = désactivé (03, 07). Valeur
    # absente = activé (Windows ne l'écrit qu'au premier changement) : l'appelant passe 'ABSENT'. Relevé le
    # 23/11/2026 sur le PC de Thomas : Steam et Docker Desktop désactivés = 03. Fonction pure, T1.
    if ($Bytes -is [string] -and $Bytes -eq 'ABSENT') { return 'ON' }
    if ($null -eq $Bytes -or $Bytes -isnot [byte[]] -or $Bytes.Length -lt 1) { return 'UNKNOWN' }
    if ($Bytes[0] -band 1) { return 'OFF' }
    return 'ON'
}

function Get-StartupCount($Entries) {
    # v3.26 (audit, constat V11) : seules les entrées actives comptent ; avant, celles désactivées dans le
    # Gestionnaire des tâches comptaient aussi (Win32_StartupCommand ne regarde pas StartupApproved, et ne
    # voyait pas les programmes 32 bits de HKLM). $Entries : objets { Name ; Approved } (Approved : octets lus,
    # 'ABSENT' ou $null si illisible). État illisible = compté comme actif (rien ne dit qu'il est coupé). Pure, T1.
    $r = [pscustomobject]@{ On = 0; Off = 0; Unknown = 0 }
    foreach ($e in @($Entries)) {
        if ($null -eq $e) { continue }
        switch (Get-StartupApprovedState $e.Approved) {
            'ON' { $r.On++ }
            'OFF' { $r.Off++ }
            default { $r.On++; $r.Unknown++ }
        }
    }
    return $r
}

function Get-StartupEntries([switch]$MachineOnly) {
    # Programmes lancés à l'ouverture de session, lus comme le Gestionnaire des tâches (v3.26, constat V11) : clés
    # Run du compte et de la machine (64 et 32 bits, registre en vue 64 bits même depuis une console 32 bits),
    # dossiers Démarrage du compte et de tous les utilisateurs, chacun avec sa valeur StartupApproved
    # ('ABSENT' si Windows ne l'a jamais écrite). Les applications du Store qui démarrent seules n'y sont pas.
    # -MachineOnly : partie commune seulement (JARVIS élevé sous un autre compte : HKCU et le dossier Démarrage
    # seraient ceux de cet autre compte). Rend un tableau (vide possible) ; $null = lecture impossible.
    $apr = 'Software\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\'
    $run = 'Software\Microsoft\Windows\CurrentVersion\Run'
    $list = [System.Collections.Generic.List[object]]::new()
    $hkcu = $null; $hklm = $null
    try {
        $hkcu = [Microsoft.Win32.RegistryKey]::OpenBaseKey([Microsoft.Win32.RegistryHive]::CurrentUser, [Microsoft.Win32.RegistryView]::Registry64)
        $hklm = [Microsoft.Win32.RegistryKey]::OpenBaseKey([Microsoft.Win32.RegistryHive]::LocalMachine, [Microsoft.Win32.RegistryView]::Registry64)
        $sources = @(@($hkcu, $run, 'Run'), @($hklm, $run, 'Run'),
                     @($hklm, 'Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Run', 'Run32'))
        $folders = @(@('Startup', $hkcu), @('CommonStartup', $hklm))
        if ($MachineOnly) {
            $sources = @($sources | Where-Object { $_[0] -eq $hklm })
            $folders = @(, @('CommonStartup', $hklm))
        }
        foreach ($src in $sources) {
            $k = $src[0].OpenSubKey($src[1])
            if ($null -eq $k) { continue }
            $a = $src[0].OpenSubKey($apr + $src[2])
            try {
                foreach ($n in $k.GetValueNames()) {
                    if (-not $n) { continue }   # valeur par défaut de la clé
                    $b = $null
                    if ($null -ne $a) { $b = $a.GetValue($n) }
                    if ($null -eq $b) { $b = 'ABSENT' }
                    $list.Add([pscustomobject]@{ Name = $n; Approved = $b })
                }
            } finally { $k.Close(); if ($null -ne $a) { $a.Close() } }
        }
        foreach ($f in $folders) {
            $dir = [Environment]::GetFolderPath($f[0])
            if (-not $dir -or -not [IO.Directory]::Exists($dir)) { continue }
            $a = $f[1].OpenSubKey($apr + 'StartupFolder')
            try {
                foreach ($fi in [IO.Directory]::GetFiles($dir)) {
                    $n = [IO.Path]::GetFileName($fi)
                    if ($n -eq 'desktop.ini') { continue }
                    $b = $null
                    if ($null -ne $a) { $b = $a.GetValue($n) }
                    if ($null -eq $b) { $b = 'ABSENT' }
                    $list.Add([pscustomobject]@{ Name = $n; Approved = $b })
                }
            } finally { if ($null -ne $a) { $a.Close() } }
        }
    } catch {
        return $null
    } finally {
        if ($null -ne $hkcu) { $hkcu.Close() }
        if ($null -ne $hklm) { $hklm.Close() }
    }
    return , ($list.ToArray())
}

# ------------------------------------------------------------------
# Réglages de sécurité de Windows (v3.14) : interprétations pures, testées en T1.
# Une valeur absente ou illisible donne UNKNOWN, jamais « actif » par défaut.
# ------------------------------------------------------------------
function ConvertTo-IntOrNull($Value) {
    # Nombre entier lu dans le registre ou rendu par un outil ; $null si absent ou non numérique
    # (jamais 0 par défaut : 0 est souvent une vraie valeur, « désactivé »)
    if ($null -eq $Value) { return $null }
    $n = 0
    if ([int]::TryParse(([string]$Value).Trim(), [ref]$n)) { return $n }
    return $null
}

function Get-OnOffVerdict($Value) {
    # Réglage binaire (booléen, ou 0 / 1) : ON, OFF, ou UNKNOWN si la lecture n'a rien donné
    if ($null -eq $Value) { return 'UNKNOWN' }
    if ($Value -is [bool]) {
        if ($Value) { return 'ON' }
        return 'OFF'
    }
    $n = ConvertTo-IntOrNull $Value
    if ($null -eq $n) { return 'UNKNOWN' }
    if ($n -ne 0) { return 'ON' }
    return 'OFF'
}

function Get-UacVerdict($EnableLua, $ConsentAdmin) {
    # Contrôle de compte d'utilisateur. OFF : désactivé (EnableLUA = 0). NOPROMPT : curseur tout en bas,
    # les droits administrateur sont accordés sans demande (ConsentPromptBehaviorAdmin = 0). ON : actif.
    $lua = ConvertTo-IntOrNull $EnableLua
    if ($null -eq $lua) { return 'UNKNOWN' }
    if ($lua -eq 0) { return 'OFF' }
    $c = ConvertTo-IntOrNull $ConsentAdmin
    if ($null -ne $c -and $c -eq 0) { return 'NOPROMPT' }
    return 'ON'
}

function Get-SmartScreenVerdict($Policy, $Explorer) {
    # SmartScreen pour les applications et les fichiers. La stratégie (EnableSmartScreen : 0 ou 1) l'emporte,
    # puis le réglage de Sécurité Windows (Off, Warn, Block ; Prompt et RequireAdmin sous Windows 10).
    # DEFAULT : rien d'enregistré, Windows garde son réglage d'origine (relevé le 19/11/2026 sur
    # Windows 11 build 26300 : la valeur n'existe pas tant que le réglage n'a pas été modifié).
    $p = ConvertTo-IntOrNull $Policy
    if ($null -ne $p) {
        if ($p -eq 0) { return 'OFF' }
        return 'ON'
    }
    $e = ([string]$Explorer).Trim()
    if ($e -eq '') { return 'DEFAULT' }
    if ($e -eq 'Off') { return 'OFF' }
    if (@('Warn', 'Block', 'Prompt', 'RequireAdmin', 'On') -contains $e) { return 'ON' }
    return 'UNKNOWN'
}

function Get-CfaVerdict($Value) {
    # Accès contrôlé aux dossiers (Get-MpPreference.EnableControlledFolderAccess)
    $n = ConvertTo-IntOrNull $Value
    if ($null -eq $n) { return 'UNKNOWN' }
    switch ($n) {
        0 { return 'OFF' }
        1 { return 'ON' }
        2 { return 'AUDIT' }
        3 { return 'DISKONLY' }
        4 { return 'AUDIT' }
        default { return 'UNKNOWN' }
    }
}

function Get-CfaAllowedRisk {
    # Applications autorisées par l'accès contrôlé aux dossiers (Get-MpPreference.ControlledFolderAccessAllowedApplications).
    # Un programme qui lance n'importe quel script ou programme (PowerShell, cmd, svchost...) ouvre la porte aux
    # rançongiciels : le 21/11/2026, un clic sur « Autoriser » après une notification a ajouté powershell.exe entier
    # sur le PC de Thomas ; sur PC-LV, svchost.exe et dllhost.exe étaient autorisés. Sans droits administrateur,
    # Windows rend « N/A: Must be an administrator to view exclusions ». Fonction pure, testée en T1.
    # State : OK (Count = applications autorisées, aucune à risque), WARN (Risky = noms), UNKNOWN (liste illisible).
    param([object[]]$Apps)
    $r = [pscustomobject]@{ State = 'OK'; Count = 0; Risky = @() }
    $risky = @('powershell.exe', 'powershell_ise.exe', 'pwsh.exe', 'cmd.exe', 'wscript.exe', 'cscript.exe', 'mshta.exe',
               'rundll32.exe', 'regsvr32.exe', 'dllhost.exe', 'svchost.exe')
    $found = @()
    foreach ($a in @($Apps)) {
        if ($null -eq $a) { continue }
        $s = ([string]$a).Trim()
        if (-not $s) { continue }
        if ($s -match '^N/A') { $r.State = 'UNKNOWN'; return $r }
        $r.Count++
        $leaf = ($s -split '\\')[-1].ToLowerInvariant()
        if ($risky -contains $leaf -and $found -notcontains $leaf) { $found += $leaf }
    }
    if ($found.Count -gt 0) { $r.State = 'WARN'; $r.Risky = $found }
    return $r
}

function Test-CfaNoticeExpected([string]$CfaVerdict, [bool]$FolderExists) {
    # Bouton [M] : PowerShellGet (fourni avec Windows) crée Documents\WindowsPowerShell\Scripts\InstalledScriptInfos à
    # chaque chargement s'il manque. Accès contrôlé actif : Windows refuse et affiche « Modification non autorisée
    # bloquée » pour powershell.exe (PC-LV, 21/11/2026 ; le module s'est installé quand même). Fonction pure, T1.
    return ($CfaVerdict -eq 'ON' -and -not $FolderExists)
}

function Get-RdpVerdict($Policy, $Local) {
    # fDenyTSConnections : 1 = connexions refusées, 0 = Bureau à distance activé. La stratégie l'emporte.
    $v = ConvertTo-IntOrNull $Policy
    if ($null -eq $v) { $v = ConvertTo-IntOrNull $Local }
    if ($null -eq $v) { return 'UNKNOWN' }
    if ($v -eq 0) { return 'ON' }
    return 'OFF'
}

function Get-HvciVerdict($Running, $RegEnabled, [bool]$CimOk) {
    # Intégrité de la mémoire. $Running : services de sécurité en service d'après Win32_DeviceGuard
    # (2 = intégrité de la mémoire), lus seulement si $CimOk. $RegEnabled : réglage enregistré.
    # RUNNING : en service. PENDING : réglée sur « activée » mais pas en service. OFF. UNKNOWN : rien de lisible.
    if ($CimOk -and (@($Running) -contains 2)) { return 'RUNNING' }
    $e = ConvertTo-IntOrNull $RegEnabled
    if ($null -ne $e -and $e -ne 0) { return 'PENDING' }
    if ($CimOk -or $null -ne $e) { return 'OFF' }
    return 'UNKNOWN'
}

function Get-AccountFindings($Users) {
    # $Users : comptes locaux (Name, Sid en texte, Enabled, PasswordRequired, PasswordSet).
    # Seuls les comptes actifs comptent. BuiltinAdmin : le compte Administrateur intégré (SID en -500) est actif.
    # NoPassword : mot de passe non exigé et jamais défini. Optional : non exigé, mais un mot de passe a été défini
    # (Windows ne permet pas de savoir s'il est vide).
    $r = [pscustomobject]@{ Active = 0; BuiltinAdmin = $false; NoPassword = @(); Optional = @() }
    $np = New-Object System.Collections.Generic.List[string]
    $op = New-Object System.Collections.Generic.List[string]
    foreach ($u in @($Users)) {
        if ($null -eq $u -or -not [bool]$u.Enabled) { continue }
        $r.Active++
        if ([string]$u.Sid -match '^S-1-5-21-[\d-]+-500$') { $r.BuiltinAdmin = $true }
        if (-not [bool]$u.PasswordRequired) {
            if ([bool]$u.PasswordSet) { $op.Add([string]$u.Name) } else { $np.Add([string]$u.Name) }
        }
    }
    $r.NoPassword = $np.ToArray()
    $r.Optional = $op.ToArray()
    return $r
}

function Get-HostsFindings([string]$Text) {
    # Fichier hosts : Entries = noms redirigés (hors localhost), Sensitive = ceux qui appartiennent à
    # Microsoft ou à un éditeur d'antivirus (un logiciel malveillant bloque ainsi mises à jour et antivirus).
    $r = [pscustomobject]@{ Entries = 0; Sensitive = @() }
    $watch = @('microsoft.com', 'windowsupdate.com', 'windows.com', 'live.com', 'office.com', 'microsoftonline.com',
               'msftconnecttest.com', 'avast.com', 'avg.com', 'avira.com', 'bitdefender.com', 'bitdefender.net',
               'eset.com', 'kaspersky.com', 'kaspersky-labs.com', 'malwarebytes.com', 'mcafee.com', 'norton.com',
               'symantec.com', 'sophos.com', 'trendmicro.com', 'f-secure.com', 'pandasecurity.com', 'drweb.com',
               'emsisoft.com', 'virustotal.com')
    $local = @('localhost', 'localhost.localdomain', 'ip6-localhost', 'ip6-loopback', 'broadcasthost')
    $sens = New-Object System.Collections.Generic.List[string]
    foreach ($line in ([string]$Text -split "`n")) {
        # Commentaire retiré, puis espaces et retour chariot de fin de ligne Windows
        $l = (($line -replace '#.*$', '') -replace '[\x00-\x1F﻿]', ' ').Trim()
        if ($l -eq '') { continue }
        $parts = @($l -split '\s+')
        for ($i = 1; $i -lt $parts.Count; $i++) {
            $h = $parts[$i].ToLower().TrimEnd('.')
            if ($h -eq '' -or $local -contains $h) { continue }
            $r.Entries++
            foreach ($d in $watch) {
                if ($h -eq $d -or $h.EndsWith('.' + $d)) {
                    if (-not $sens.Contains($h)) { $sens.Add($h) }
                    break
                }
            }
        }
    }
    $r.Sensitive = $sens.ToArray()
    return $r
}

function Get-ProxyVerdict($Enable, $Server, $AutoConfig) {
    # Proxy du compte courant. MANUAL : serveur proxy actif. SCRIPT : script de configuration automatique.
    # NONE : aucun. Detail : adresse affichable (identifiants éventuels retirés).
    $r = [pscustomobject]@{ State = 'NONE'; Detail = '' }
    $e = ConvertTo-IntOrNull $Enable
    $srv = ([string]$Server).Trim()
    $auto = ([string]$AutoConfig).Trim()
    if ($null -ne $e -and $e -ne 0 -and $srv -ne '') {
        $r.State = 'MANUAL'
        $r.Detail = ($srv -replace '[^\s;=/@]+@', '')
    } elseif ($auto -ne '') {
        $r.State = 'SCRIPT'
        $r.Detail = ($auto -replace '[^\s;=/@]+@', '')
    }
    return $r
}

function Get-ActivationVerdict($Statuses) {
    # LicenseStatus des produits Windows qui ont une clé : 1 = activé. Liste vide = rien de lu, on ne conclut pas.
    $s = @($Statuses | Where-Object { $null -ne $_ })
    if ($s.Count -eq 0) { return 'UNKNOWN' }
    if ($s -contains 1) { return 'ACTIVATED' }
    return 'NOTACTIVATED'
}

function Get-MpScanVerdict($JobOk, $Start, $End, [bool]$TimedOut = $false) {
    # Analyse Defender lancée par JARVIS. $JobOk : $true (lancée sans erreur), $false (erreur), $null (le job
    # n'a rien rendu : délai dépassé si $TimedOut, sinon job interrompu).
    # DONE seulement si Defender a enregistré une fin d'analyse postérieure au lancement.
    if ($null -ne $JobOk -and -not [bool]$JobOk) { return 'FAILED' }
    if ($End -is [datetime] -and $Start -is [datetime] -and $End -ge $Start) { return 'DONE' }
    if ($null -eq $JobOk -and $TimedOut) { return 'TIMEOUT' }
    return 'UNVERIFIED'
}

function Get-MpThreatsSince($Detections, [datetime]$Since) {
    # Détections de Defender apparues depuis le lancement de l'analyse. Une détection ancienne dont seul
    # le statut a changé entre-temps (nettoyage de l'historique, par exemple) n'est pas une nouvelle menace.
    return @($Detections | Where-Object {
        $null -ne $_ -and $_.InitialDetectionTime -is [datetime] -and $_.InitialDetectionTime -ge $Since
    })
}

function Test-MpThreatHandled($StatusId) {
    # ThreatStatusID de Defender : 2 nettoyée, 3 mise en quarantaine, 4 supprimée, 6 bloquée.
    # Tout autre statut (1 détectée, 5 autorisée, 102 à 107 échecs, inconnu) : menace non traitée.
    $n = ConvertTo-IntOrNull $StatusId
    return ($null -ne $n -and @(2, 3, 4, 6) -contains $n)
}

function Get-HostsDirVerdict([string]$DataBasePath, [string]$WinDir) {
    # Dossier où Windows lit le fichier hosts (valeur DataBasePath des paramètres Tcpip).
    # DEFAULT : dossier d'origine. MOVED : ailleurs (détournement connu). UNKNOWN : valeur absente.
    $p = ([string]$DataBasePath).Trim().TrimEnd('\')
    $w = ([string]$WinDir).Trim().TrimEnd('\')
    if ($p -eq '' -or $w -eq '') { return 'UNKNOWN' }
    $p = $p -replace '%SystemRoot%|%windir%', $w.Replace('$', '$$')
    if ($p -eq ($w + '\System32\drivers\etc')) { return 'DEFAULT' }
    return 'MOVED'
}

function Test-SameAccount([string]$SessionUser, [string]$ProcessUser) {
    # Le compte de la session ouverte à l'écran (« PC\Marie ») est-il celui sous lequel JARVIS tourne ?
    # Après une élévation avec le mot de passe d'un autre compte, non : HKCU est alors le profil de cet autre
    # compte. Session inconnue (connexion à distance) : on ne peut pas dire qu'il diffère.
    $s = (([string]$SessionUser).Trim() -split '\\')[-1]
    $u = (([string]$ProcessUser).Trim() -split '\\')[-1]
    if ($s -eq '' -or $u -eq '') { return $true }
    return ($s -eq $u)
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

function Get-SystemToolPath([string]$Name) {
    # Chemin complet d'un outil de Windows (dism.exe, sfc.exe, cmd.exe...) : jamais de recherche dans le
    # PATH, où un programme du même nom pourrait être lancé à sa place avec les droits administrateur.
    # Ces outils sont en 64 bits : passage par Sysnative si la console est en 32 bits.
    $win = [Environment]::GetFolderPath('Windows')
    if (-not $win) { $win = $env:windir }
    $p = Join-Path $win ('System32\' + $Name)
    if (-not [Environment]::Is64BitProcess) {
        $native = Join-Path $win ('Sysnative\' + $Name)
        if (Test-Path -LiteralPath $native) { $p = $native }
    }
    return $p
}

function Get-SfcPath { return (Get-SystemToolPath 'sfc.exe') }

function Get-EventsSafe([hashtable]$Filter) {
    # Lecture d'un journal Windows qui distingue « aucun événement » (Ok, liste vide) d'une lecture en échec
    $r = [pscustomobject]@{ Ok = $false; Events = @(); Error = '' }
    try {
        $r.Events = @(Get-WinEvent -FilterHashtable $Filter -ErrorAction Stop)
        $r.Ok = $true
    } catch {
        if (Test-NoEventError ([string]$_.FullyQualifiedErrorId)) { $r.Ok = $true }
        else { $r.Error = [string]$_.Exception.Message }
    }
    return $r
}

function Test-AppxInUseBetween([datetime]$From, [datetime]$To) {
    # Entre $From et $To, Windows a-t-il refusé d'installer une application du Store parce qu'elle tournait
    # encore (fenêtre ouverte, icône près de l'horloge ou service en arrière-plan) ? winget répond alors
    # « terminé » (code 0) alors que la nouvelle version est seulement téléchargée. $null : journal illisible.
    # À appeler quelques secondes après la mise à jour, pas aussitôt : le journal de Windows n'est lisible
    # qu'avec un léger retard (constaté le 19/11/2026 : rien lu juste après winget, tout lu 20 s plus tard).
    # Événements 404 et 419 : échec d'une installation. Une suppression différée d'ancienne version porte le
    # même code d'erreur sous d'autres numéros (401, 664) et ne compte pas.
    $r = Get-EventsSafe @{ LogName = 'Microsoft-Windows-AppXDeploymentServer/Operational'; Id = 404, 419; StartTime = $From }
    if (-not $r.Ok) { return $null }
    $limit = $To.AddSeconds(2)
    return (@($r.Events | Where-Object { $_.TimeCreated -le $limit -and (Test-AppxInUseMessage ([string]$_.Message)) }).Count -gt 0)
}

function Invoke-StoreQuery {
    # Microsoft Store par l'API de Windows (AppInstallManager), sans droits admin. Autonome : passée aux jobs.
    # Search : recherche seule des mises à jour (Items : Pfn, ProductId). Sans l'option ci-dessous, le Store
    # lancerait aussitôt les téléchargements (valeur par défaut : vrai, relevé le 19/11/2026) ; si l'option
    # n'existe pas (Windows 10 ancien), la recherche échoue au lieu d'installer. « winget --source msstore »
    # ne voit pas les applications installées par le Store (relevé le même jour), d'où cette API.
    # Update : met à jour les familles $Pfns et suit leur état (Items : Pfn, State, Code), $TimeoutSec au total.
    param([string]$Mode, [string[]]$Pfns, [int]$TimeoutSec = 150)
    $o = [pscustomobject]@{ Ok = $false; Auto = ''; Items = @(); Error = $null }
    try {
        Add-Type -AssemblyName System.Runtime.WindowsRuntime
        $null = [Windows.ApplicationModel.Store.Preview.InstallControl.AppInstallManager, Windows.ApplicationModel.Store.Preview, ContentType = WindowsRuntime]
        $asTask = @([System.WindowsRuntimeSystemExtensions].GetMethods() | Where-Object {
            $_.Name -eq 'AsTask' -and $_.GetParameters().Count -eq 1 -and $_.GetParameters()[0].ParameterType.Name -eq 'IAsyncOperation`1' })[0]
        $itemType = [Windows.ApplicationModel.Store.Preview.InstallControl.AppInstallItem]
        $m = New-Object Windows.ApplicationModel.Store.Preview.InstallControl.AppInstallManager
        $o.Auto = [string]$m.AutoUpdateSetting
        $sw = [Diagnostics.Stopwatch]::StartNew()
        if ($Mode -eq 'Search') {
            $opt = New-Object Windows.ApplicationModel.Store.Preview.InstallControl.AppUpdateOptions
            $opt.AutomaticallyDownloadAndInstallUpdateIfFound = $false
            # Les mises à jour trouvées restent inscrites dans la file du Store à l'état ReadyToDownload, sans
            # téléchargement (file identique avant, après et 20 s après une recherche, relevé le 19/11/2026)
            $listType = [Collections.Generic.IReadOnlyList`1].MakeGenericType($itemType)
            $task = $asTask.MakeGenericMethod($listType).Invoke($null, @($m.SearchForAllUpdatesAsync('', '', $opt)))
            if (-not $task.Wait($TimeoutSec * 1000)) { throw 'le Microsoft Store ne répond pas' }
            $o.Items = @(foreach ($i in $task.Result) { [pscustomobject]@{ Pfn = [string]$i.PackageFamilyName; ProductId = [string]$i.ProductId } })
        } elseif ($Mode -eq 'Update') {
            $run = @()
            foreach ($p in @($Pfns)) {
                $r = [pscustomobject]@{ Pfn = [string]$p; State = 'NotStarted'; Code = 0; Item = $null }
                # Démarrage compris dans le délai total : au-delà, les suivantes restent « NotStarted »
                $left = [int](($TimeoutSec - $sw.Elapsed.TotalSeconds) * 1000)
                if ($left -gt 1000) {
                    try {
                        $task = $asTask.MakeGenericMethod($itemType).Invoke($null, @($m.UpdateAppByPackageFamilyNameAsync([string]$p)))
                        if ($task.Wait([Math]::Min(120000, $left))) {
                            $r.Item = $task.Result
                            if ($null -eq $r.Item) { $r.State = 'NoUpdate' }
                        }
                    } catch {
                        $r.State = 'Error'
                        $r.Code = [int]$_.Exception.GetBaseException().HResult
                    }
                }
                $run += $r
            }
            # États où l'attente s'arrête : fin, ou attente d'un geste de l'utilisateur (pause, batterie, Wi-Fi
            # limité). « ReadyToDownload » est normal au départ : il ne compte qu'après 90 s.
            $final = @('Completed', 'Error', 'Canceled', 'NoUpdate', 'Paused', 'PausedLowBattery', 'PausedWiFiRecommended', 'PausedWiFiRequired')
            while ($sw.Elapsed.TotalSeconds -lt $TimeoutSec) {
                $busy = 0
                foreach ($r in $run) {
                    if ($null -eq $r.Item -or $final -contains $r.State) { continue }
                    try {
                        $st = $r.Item.GetCurrentStatus()
                        $r.State = [string]$st.InstallState
                        if ($null -ne $st.ErrorCode) { $r.Code = [int]$st.ErrorCode.HResult }
                    } catch {
                        # Élément retiré de la file ou service du Store relancé : état illisible, les autres continuent
                        $r.State = 'Unknown'
                        $r.Item = $null
                        continue
                    }
                    if ($final -contains $r.State) { continue }
                    if ($r.State -eq 'ReadyToDownload' -and $sw.Elapsed.TotalSeconds -gt 90) { continue }
                    $busy++
                }
                if ($busy -eq 0) { break }
                Start-Sleep -Milliseconds 1000
            }
            $o.Items = @($run | ForEach-Object { [pscustomobject]@{ Pfn = $_.Pfn; State = $_.State; Code = $_.Code } })
        } else {
            throw ('mode inconnu : ' + $Mode)
        }
        $o.Ok = $true
    } catch {
        $o.Error = [string]$_.Exception.GetBaseException().Message
    }
    return $o
}

function Get-StartAppNames {
    # Noms affichés dans le menu Démarrer, par famille de paquets (identifiant « famille!App »)
    $map = @{}
    try {
        foreach ($a in @(Get-StartApps -ErrorAction Stop)) {
            $id = [string]$a.AppID
            $k = $id.IndexOf('!')
            if ($k -gt 0) {
                $f = $id.Substring(0, $k)
                if (-not $map.ContainsKey($f)) { $map[$f] = [string]$a.Name }
            }
        }
    } catch { $map.Clear() }
    return $map
}

function Get-AppxVersionMap {
    # Version installée de chaque application du Store pour ce compte, par famille de paquets (la plus haute
    # si la famille a plusieurs paquets). Vide si la liste est illisible.
    $map = @{}
    try {
        foreach ($p in @(Get-AppxPackage -ErrorAction Stop)) {
            $f = [string]$p.PackageFamilyName
            if (-not $f) { continue }
            $v = [string]$p.Version
            if (-not $map.ContainsKey($f)) { $map[$f] = $v; continue }
            $a = $null; $b = $null
            if ([version]::TryParse($v, [ref]$a) -and [version]::TryParse([string]$map[$f], [ref]$b) -and $a -gt $b) { $map[$f] = $v }
        }
    } catch { $map.Clear() }
    return $map
}

function Open-StoreLibraryGuided {
    # Repli garanti : la page des mises à jour du Store, avec le mode d'emploi
    try { Start-Process 'ms-windows-store://downloadsandupdates' -ErrorAction Stop } catch {
        Write-Host '   [!] Le Microsoft Store n''a pas pu être ouvert : ouvre-le depuis le menu Démarrer.' -ForegroundColor Yellow
    }
    Write-Host ''
    Write-Host '   DANS LE MICROSOFT STORE (page Bibliothèque) :' -ForegroundColor Cyan
    Write-Host '   1. Clique sur « Obtenir les mises à jour » (en haut à droite).' -ForegroundColor Gray
    Write-Host '   2. Ferme les applications concernées si le Store le demande, puis attends la fin.' -ForegroundColor Gray
    Write-Host ''
}

function Update-StoreApps {
    # Mise à jour des applications du Store trouvées pendant le scan, puis vérification par une nouvelle recherche
    $q = ${function:Invoke-StoreQuery}.ToString()
    $items = @($script:StoreItems)
    $pfns = [string[]]@($items | ForEach-Object { $_.Pfn })
    $before = Get-AppxVersionMap
    $up = Invoke-Spinner 'Mise à jour par le Microsoft Store' {
        param($QueryText, $List)
        & ([scriptblock]::Create($QueryText)) -Mode 'Update' -Pfns $List -TimeoutSec 900
    } 1020 -ArgumentList $q, $pfns
    if ($null -eq $up -or -not $up.Ok) {
        $why = 'pas de réponse du Store'
        if ($up -and $up.Error) { $why = Cut $up.Error 60 }
        Write-Action 'WARN' ('Microsoft Store : mise à jour impossible par J.A.R.V.I.S. (' + $why + ')')
        Open-StoreLibraryGuided
        return
    }
    Write-Host '   >> Vérification auprès du Microsoft Store...' -ForegroundColor DarkCyan
    Start-Sleep -Seconds 5
    $chk = Invoke-Spinner 'Nouvelle recherche dans le Microsoft Store' {
        param($QueryText)
        & ([scriptblock]::Create($QueryText)) -Mode 'Search' -TimeoutSec 150
    } 180 -ArgumentList $q
    $left = $null
    if ($chk -and $chk.Ok) { $left = @(@($chk.Items) | ForEach-Object { [string]$_.Pfn }) }
    $after = Get-AppxVersionMap
    $notOk = 0
    foreach ($s in $items) {
        $state = 'NotStarted'; $code = 0
        $r = @(@($up.Items) | Where-Object { $_.Pfn -eq $s.Pfn }) | Select-Object -First 1
        if ($r) { $state = [string]$r.State; $code = [int]$r.Code }
        $listed = $null
        if ($null -ne $left) { $listed = ($left -contains $s.Pfn) }
        $hex = '0x{0:X8}' -f $code
        switch (Get-StoreUpdateVerdict $state $listed) {
            'OK' {
                # Constaté le 19/11/2026 : le Store peut cesser de proposer une mise à jour sans que la version
                # change pour ce compte (composants Xbox) ; « vérifiée » seulement si la version a changé.
                $v1 = [string]$before[$s.Pfn]; $v2 = [string]$after[$s.Pfn]
                if ($v1 -and $v2 -and $v1 -ne $v2) { Write-Action 'OK' ('{0} : mise à jour vérifiée ({1} -> {2})' -f $s.Name, $v1, $v2) }
                elseif ($v1 -and $v2) { Write-Action 'INFO' ('{0} : le Store ne la propose plus, version inchangée ({1})' -f $s.Name, $v2) }
                else { Write-Action 'INFO' ($s.Name + ' : le Store ne la propose plus, version installée non lue') }
            }
            'FAIL' {
                $notOk++
                if (Test-AppxInUseMessage $hex) { Write-Action 'WARN' ($s.Name + ' : pas installée, l''application tournait encore (ferme-la puis réessaie)') }
                elseif ($code -ne 0) { Write-Action 'FAIL' ('{0} : échec dans le Store (code {1})' -f $s.Name, $hex) }
                else { Write-Action 'FAIL' ($s.Name + ' : échec dans le Store') }
            }
            'CANCELED' { $notOk++; Write-Action 'WARN' ($s.Name + ' : mise à jour annulée dans le Store') }
            'PAUSED' { $notOk++; Write-Action 'WARN' ($s.Name + ' : en pause dans le Store (batterie, Wi-Fi limité ou pause demandée) : branche le secteur ou ouvre le Store') }
            'WAITING' { $notOk++; Write-Action 'WARN' ($s.Name + ' : le Store ne l''a pas démarrée') }
            'NOSTART' { $notOk++; Write-Action 'WARN' ($s.Name + ' : le Store n''a pas lancé la mise à jour, toujours proposée') }
            'NOTDONE' { $notOk++; Write-Action 'WARN' ($s.Name + ' : le Store a répondu « terminé », mais propose toujours la mise à jour') }
            'UNVERIFIED' { Write-Action 'INFO' ($s.Name + ' : le Store a répondu « terminé », résultat non vérifié') }
            default { $notOk++; Write-Action 'INFO' ($s.Name + ' : pas terminée à temps, peut-être encore en cours dans le Store') }
        }
    }
    if ($null -eq $left) {
        Write-Action 'INFO' 'Nouvelle recherche dans le Store impossible : regarde dans Microsoft Store > Bibliothèque'
    }
    if ($notOk -gt 0) {
        if (Read-YesNo '   >> Ouvrir la page des mises à jour du Microsoft Store ?') { Open-StoreLibraryGuided }
    }
}

function Write-EventCount([string]$Label, [bool]$ReadOk, [int]$Count, [string]$BadState, [string[]]$Advice = @()) {
    # Un compteur d'événements à 0 n'est « OK » que si le journal a vraiment été lu.
    # $Advice : quoi faire, affiché sous la ligne quand le compteur n'est pas à 0 (v3.23).
    if (-not $ReadOk) { Write-Status $Label 'lecture du journal impossible' 'INFO' }
    elseif ($Count -gt 0) {
        Write-Status $Label ([string]$Count) $BadState
        foreach ($a in $Advice) { Write-Sub $a }
    }
    else { Write-Status $Label '0' 'OK' }
}

function Get-DiskHealthVerdict($Health, $Temperature, $Wear, $ReadErrors) {
    # Santé d'un disque (Get-PhysicalDisk) et compteurs de fiabilité (Get-StorageReliabilityCounter, admin seulement).
    # v3.23, constat V6 de l'audit du 23/11/2026 : l'état était FAIL par défaut (un « Unknown » donnait une alerte
    # rouge), le texte restait en anglais et une usure de 100 % n'était qu'un avertissement.
    # $Health : nom (Healthy, Warning, Unhealthy, Unknown) ou nombre (0, 1, 2, 5) ; compteurs $null si non lus.
    # Rend State (OK, WARN, FAIL, INFO), Text (« santé : bonne »...) et Why : HEALTH, ERRORS, WORN (usure de 100 %),
    # WEAR (80 %), HOT (65 °C), UNKNOWN (santé illisible, rien d'autre de grave) ou ''. Fonction pure, T1.
    $h = ([string]$Health).Trim()
    switch ($h) {
        '0' { $h = 'Healthy' }
        '1' { $h = 'Warning' }
        '2' { $h = 'Unhealthy' }
    }
    $txt = 'santé illisible'
    if ($h -eq 'Healthy') { $txt = 'santé : bonne' }
    elseif ($h -eq 'Warning') { $txt = 'santé : à surveiller' }
    elseif ($h -eq 'Unhealthy') { $txt = 'santé : mauvaise' }
    $t = ConvertTo-IntOrNull $Temperature
    $w = ConvertTo-IntOrNull $Wear
    $e = ConvertTo-IntOrNull $ReadErrors
    $state = 'INFO'; $why = 'UNKNOWN'
    if ($h -eq 'Unhealthy') { $state = 'FAIL'; $why = 'HEALTH' }
    elseif ($null -ne $e -and $e -gt 0) { $state = 'FAIL'; $why = 'ERRORS' }
    elseif ($null -ne $w -and $w -ge 100) { $state = 'FAIL'; $why = 'WORN' }
    elseif ($h -eq 'Warning') { $state = 'WARN'; $why = 'HEALTH' }
    elseif ($null -ne $w -and $w -ge 80) { $state = 'WARN'; $why = 'WEAR' }
    elseif ($null -ne $t -and $t -ge 65) { $state = 'WARN'; $why = 'HOT' }
    elseif ($h -eq 'Healthy') { $state = 'OK'; $why = '' }
    return [pscustomobject]@{ State = $state; Text = $txt; Why = $why }
}

function Get-DiskAdvice([string]$Why) {
    # Quoi faire pour un disque, selon la raison rendue par Get-DiskHealthVerdict (v3.23)
    switch ($Why) {
        'HEALTH'  { return @('Copie dès maintenant tes fichiers importants (photos, documents) sur un disque externe',
                             'ou un cloud : ce disque peut lâcher. Fais-le ensuite vérifier ou remplacer.') }
        'ERRORS'  { return @('Des données n''ont pas pu être lues : copie dès maintenant tes fichiers importants ailleurs',
                             '(disque externe ou cloud), puis fais vérifier ou remplacer ce disque.') }
        'WORN'    { return @('Ce SSD a atteint la durée de vie prévue par son fabricant : sauvegarde tes fichiers',
                             'importants ailleurs et prévois son remplacement.') }
        'WEAR'    { return @('Usure avancée : sauvegarde régulièrement tes fichiers et prévois son remplacement.') }
        'HOT'     { return @('Disque chaud : vérifie que les aérations du PC ne sont pas bouchées par la poussière.') }
    }
    return @()
}

function Get-BitLockerVerdict([string]$Protection, [string]$VolumeStatus) {
    # Chiffrement du disque système (Get-BitLockerVolume). v3.23, constat V9 de l'audit : « protection suspendue »
    # était une simple information, et un chiffrement en cours était écrit « protection suspendue ».
    # Disque chiffré mais protection coupée : la clé est lisible sur le disque, le chiffrement ne protège plus.
    # Rend State (INFO ou WARN) et Text. Fonction pure, T1.
    $p = ([string]$Protection).Trim()
    $v = ([string]$VolumeStatus).Trim()
    if ($p -eq 'On') { return [pscustomobject]@{ State = 'INFO'; Text = 'chiffré et protégé' } }
    switch ($v) {
        'FullyDecrypted'       { return [pscustomobject]@{ State = 'INFO'; Text = 'non chiffré' } }
        'EncryptionInProgress' { return [pscustomobject]@{ State = 'INFO'; Text = 'chiffrement en cours' } }
        'DecryptionInProgress' { return [pscustomobject]@{ State = 'INFO'; Text = 'déchiffrement en cours' } }
        'EncryptionPaused'     { return [pscustomobject]@{ State = 'INFO'; Text = 'chiffrement en pause' } }
        'DecryptionPaused'     { return [pscustomobject]@{ State = 'INFO'; Text = 'déchiffrement en pause' } }
        'FullyEncrypted' {
            if ($p -eq 'Off') { return [pscustomobject]@{ State = 'WARN'; Text = 'chiffré, protection suspendue' } }
        }
    }
    return [pscustomobject]@{ State = 'INFO'; Text = 'état illisible' }
}

function Test-TcpReach([string]$HostName, [int]$Port, [int]$TimeoutMs = 3000) {
    # Connexion TCP bornée dans le temps (v3.23, constat V8 de l'audit) : certaines box et certains réseaux ne
    # répondent pas au ping alors qu'Internet fonctionne. $true si la connexion s'établit, $false sinon.
    $c = $null
    try {
        $c = New-Object Net.Sockets.TcpClient
        $ar = $c.BeginConnect($HostName, $Port, $null, $null)
        if (-not $ar.AsyncWaitHandle.WaitOne($TimeoutMs)) { return $false }
        $c.EndConnect($ar)
        return [bool]$c.Connected
    } catch {
        return $false
    } finally {
        if ($null -ne $c) { $c.Close() }
    }
}

function Get-NetworkVerdict([string]$Gateway, [bool]$GatewayReply, [int]$Sent, [int]$Replies, $AvgMs, $TcpOk, [bool]$DnsOk, $DnsMs) {
    # Section 09 (v3.23, constat V8 de l'audit du 23/11/2026) : le ping seul ne juge plus l'accès à Internet.
    # Une box qui ne répond pas au ping donnait « injoignable » en FAIL alors que le DNS réussissait juste après ;
    # un seul ping perdu sur 4 donnait un avertissement. $TcpOk : connexion TCP réussie, testée seulement si aucun
    # ping n'a répondu ($null sinon). Rend Up (Internet joignable) et Rows : Label, State, Text, Advice (lignes de
    # conseil). Fonction pure, T1.
    $up = ($Replies -gt 0) -or ($TcpOk -eq $true)
    $rows = @()
    $boxAdvice = 'vérifie le câble ou le Wi-Fi (icône près de l''horloge), puis redémarre la box (débranche-la 30 secondes).'
    if ($Gateway) {
        if ($GatewayReply) {
            $rows += [pscustomobject]@{ Label = 'Box ou routeur (passerelle)'; State = 'OK'; Text = "$Gateway joignable"; Advice = @() }
        } elseif ($up) {
            $rows += [pscustomobject]@{ Label = 'Box ou routeur (passerelle)'; State = 'INFO'
                                        Text = "$Gateway ne répond pas au ping (fréquent : Internet fonctionne)"; Advice = @() }
        } else {
            $rows += [pscustomobject]@{ Label = 'Box ou routeur (passerelle)'; State = 'FAIL'; Text = "$Gateway injoignable"
                                        Advice = @('Le PC n''atteint pas ta box : ' + $boxAdvice) }
        }
    }
    if ($Replies -gt 0) {
        $avg = 0
        if ($null -ne $AvgMs) { $avg = [math]::Round([double]$AvgMs) }
        $loss = 0
        if ($Sent -gt 0) { $loss = [math]::Round((($Sent - $Replies) / $Sent) * 100) }
        $txt = '{0} ms en moyenne  //  perte {1}%' -f $avg, $loss
        if ($avg -gt 100 -or $loss -ge 50) {
            $rows += [pscustomobject]@{ Label = 'Temps de réponse Internet'; State = 'WARN'; Text = $txt
                                        Advice = @('Connexion lente ou instable : en Wi-Fi, rapproche-toi de la box ; sinon redémarre-la.') }
        } else {
            $rows += [pscustomobject]@{ Label = 'Temps de réponse Internet'; State = 'OK'; Text = $txt; Advice = @() }
        }
    } elseif ($up) {
        $rows += [pscustomobject]@{ Label = 'Accès Internet'; State = 'OK'
                                    Text = 'fonctionne (ping bloqué par le réseau, temps de réponse non mesuré)'; Advice = @() }
    } else {
        $adv = 'Le PC n''est relié à aucun réseau : branche le câble ou connecte-toi au Wi-Fi (icône près de l''horloge).'
        if ($Gateway -and $GatewayReply) {
            $adv = 'Ta box répond mais pas Internet : redémarre-la (débranche-la 30 secondes) ; si ça continue, appelle ton fournisseur.'
        } elseif ($Gateway) {
            $adv = 'Commence par la box : ' + $boxAdvice
        }
        $rows += [pscustomobject]@{ Label = 'Accès Internet'; State = 'FAIL'; Text = 'aucune réponse'; Advice = @($adv) }
    }
    if ($DnsOk) {
        $ms = 0
        if ($null -ne $DnsMs) { $ms = [double]$DnsMs }
        $rows += [pscustomobject]@{ Label = 'Noms de sites (DNS)'; State = 'OK'; Text = ('{0:N0} ms' -f $ms); Advice = @() }
    } elseif ($up) {
        $rows += [pscustomobject]@{ Label = 'Noms de sites (DNS)'; State = 'FAIL'; Text = 'échec'
                                    Advice = @('Internet répond, mais les noms de sites ne sont pas traduits en adresses : redémarre la box.',
                                               'Si ça continue : Paramètres > Réseau et Internet > ta connexion > serveur DNS : Automatique.') }
    } else {
        $rows += [pscustomobject]@{ Label = 'Noms de sites (DNS)'; State = 'INFO'; Text = 'échec, faute d''accès Internet'; Advice = @() }
    }
    return [pscustomobject]@{ Up = $up; Rows = $rows }
}

function Get-DiskErrorVerdict($Events, $Arrivals, $Present) {
    # Erreurs disque de la section 10 : lesquelles viennent d'un appareil amovible débranché depuis (clé USB, carte
    # mémoire, disque virtuel monté) ? Sans gravité pour le PC, elles passent en INFO. PC de Thomas, 21/11/2026 :
    # « erreur du contrôleur sur \Device\Harddisk1\DR5 » (disk 11) = clé Kingston DataTraveler 3.0 retirée depuis,
    # reconnue dans le journal des disques branchés (Partition/Diagnostic, événement 1006, bus 7 = USB).
    # $Events : Provider, Time, Device (1er champ de l'événement). $Arrivals : Time, DiskNumber, BusType, Manufacturer,
    # Model, Serial ; $null = journal illisible. $Present : Number, Serial (disques branchés maintenant) ; $null =
    # lecture impossible. Tout doute garde l'alerte : un disque interne qui disparaît est en panne, c'est grave.
    # Débranché = type amovible, et plus aucun disque branché à ce numéro ni avec ce numéro de série.
    # Rend Alert (nombre gardé en alerte), Unplugged (nombre sans gravité) et Devices (Name, What, Kind, Events ;
    # Kind = UNPLUGGED, REMOVABLE (amovible encore branché), FIXED (disque interne) ou UNKNOWN). Fonction pure, T1.
    $types = @{ 7 = 'clé USB ou disque externe'; 12 = 'carte mémoire'; 13 = 'carte mémoire'; 15 = 'disque virtuel monté' }
    $norm = { param($s) $t = ([string]$s).Trim(); if ($t -eq 'NULL') { return '' }; return (($t -replace '[^A-Za-z0-9]', '').ToUpperInvariant()) }
    $alert = 0
    $unpl = 0
    $dev = [ordered]@{}
    foreach ($e in @($Events)) {
        if ($null -eq $e) { continue }
        $kind = 'UNKNOWN'
        $name = ''
        $what = ''
        $m = [regex]::Match([string]$e.Device, '\\Device\\Harddisk(\d+)\\DR\d+', 'IgnoreCase')
        if ([string]$e.Provider -eq 'disk' -and $m.Success -and $null -ne $Arrivals -and $null -ne $Present) {
            $n = [int]$m.Groups[1].Value
            $arr = @(@($Arrivals) | Where-Object { $null -ne $_ -and $_.DiskNumber -eq $n -and $_.Time -le $e.Time } | Sort-Object Time -Descending)
            if ($arr.Count -gt 0) {
                $a = $arr[0]
                $man = ([string]$a.Manufacturer).Trim()
                $mod = ([string]$a.Model).Trim()
                if ($man -eq 'NULL') { $man = '' }
                if ($mod -eq 'NULL') { $mod = '' }
                $name = $mod
                if ($man -and -not ($mod -like ($man + '*'))) { $name = ($man + ' ' + $mod).Trim() }
                $bus = 0
                if (-not [int]::TryParse(([string]$a.BusType).Trim(), [ref]$bus)) { $bus = -1 }
                if ($types.ContainsKey($bus)) {
                    $what = $types[$bus]
                    $sn = & $norm $a.Serial
                    $here = @(@($Present) | Where-Object { $null -ne $_ -and ($_.Number -eq $n -or ($sn -and (& $norm $_.Serial) -eq $sn)) })
                    if ($here.Count -gt 0) { $kind = 'REMOVABLE' } else { $kind = 'UNPLUGGED' }
                } else {
                    $kind = 'FIXED'
                }
            }
        }
        if ($kind -eq 'UNPLUGGED') { $unpl++ } else { $alert++ }
        if ($name) {
            $key = $kind + '|' + $name
            if ($dev.Contains($key)) { $dev[$key].Events++ }
            else { $dev[$key] = [pscustomobject]@{ Name = $name; What = $what; Kind = $kind; Events = 1 } }
        }
    }
    return [pscustomobject]@{ Alert = $alert; Unplugged = $unpl; Devices = @($dev.Values) }
}

function Get-DiskArrivals([datetime]$Since) {
    # Disques branchés depuis $Since d'après le journal « Partition/Diagnostic » de Windows : événement 1006, écrit à
    # chaque arrivée d'un disque (démarrage du PC, clé USB branchée...), avec son numéro, son type de bus, son modèle
    # et son numéro de série. Lisible sans droits admin sous Windows 10 22H2 et Windows 11 (relevé le 22/11/2026 sur
    # les trois PC). $null : journal illisible.
    $r = Get-EventsSafe @{ LogName = 'Microsoft-Windows-Partition/Diagnostic'; Id = 1006; StartTime = $Since }
    if (-not $r.Ok) { return $null }
    $out = New-Object System.Collections.Generic.List[object]
    foreach ($ev in @($r.Events)) {
        $h = @{}
        try {
            foreach ($x in @(([xml]$ev.ToXml()).Event.EventData.Data)) { $h[[string]$x.Name] = [string]$x.'#text' }
        } catch { continue }
        $out.Add([pscustomobject]@{
            Time = $ev.TimeCreated; DiskNumber = (ConvertTo-IntOrNull $h['DiskNumber']); BusType = $h['BusType']
            Manufacturer = $h['Manufacturer']; Model = $h['Model']; Serial = $h['SerialNumber']
        })
    }
    return ,($out.ToArray())
}

function Get-RegValueSafe([string]$Path, [string]$Name) {
    # Lecture d'une valeur du registre. Ok : la clé a été lue (Value = $null si la valeur n'existe pas).
    # Missing : la clé n'existe pas. Ni l'un ni l'autre : clé illisible.
    $r = [pscustomobject]@{ Ok = $false; Missing = $false; Value = $null }
    try {
        $k = Get-Item -LiteralPath $Path -ErrorAction Stop
        $r.Value = $k.GetValue($Name, $null)
        $r.Ok = $true
    } catch [System.Management.Automation.ItemNotFoundException] {
        $r.Missing = $true
    } catch {
        $r.Ok = $false
    }
    return $r
}

# ------------------------------------------------------------------
# Version de Windows encore maintenue ? (v3.28) Dates relues le 26/11/2026 sur les pages de Microsoft :
# « Windows 11 release information » (révisée le 19/11/2026) et « lifecycle » de chaque produit (fin de 24H2
# Famille/Pro : 13/10/2026). À relire à chaque montée de version (règle 13) : un an après AsOf, une version
# encore maintenue dans la table devient « non vérifiable » plutôt qu'un OK donné de mémoire.
# ------------------------------------------------------------------
function Get-WindowsLifecycleTable {
    # Dans une fonction et non dans une variable : les tests T1 n'ont pas les variables du programme.
    # Home : éditions Famille et Pro ; Ent : Entreprise et Éducation. EsuEnd : fin du programme ESU grand public
    # de Windows 10 (page « extended security updates » de Microsoft, relue le 26/11/2026).
    $rows = @(
        @(19045, 'Windows 10 22H2', '2025-10-14', '2025-10-14'),
        @(22000, 'Windows 11 21H2', '2023-10-10', '2024-10-08'),
        @(22621, 'Windows 11 22H2', '2024-10-08', '2025-10-14'),
        @(22631, 'Windows 11 23H2', '2025-11-11', '2026-11-10'),
        @(26100, 'Windows 11 24H2', '2026-10-13', '2027-10-12'),
        @(26200, 'Windows 11 25H2', '2027-10-12', '2028-10-10'),
        @(28000, 'Windows 11 26H1', '2028-03-14', '2029-03-13'),
        @(26300, 'Windows 11 26H2', '2028-10-10', '2029-10-09')
    )
    $inv = [Globalization.CultureInfo]::InvariantCulture
    $list = foreach ($r in $rows) {
        [pscustomobject]@{ Build = [int]$r[0]; Name = [string]$r[1]
                           Home = [datetime]::ParseExact($r[2], 'yyyy-MM-dd', $inv)
                           Ent = [datetime]::ParseExact($r[3], 'yyyy-MM-dd', $inv) }
    }
    return [pscustomobject]@{
        AsOf = [datetime]::ParseExact('2026-11-19', 'yyyy-MM-dd', $inv)
        EsuEnd = [datetime]::ParseExact('2027-10-12', 'yyyy-MM-dd', $inv)
        Rows = @($list)
    }
}

function Get-WindowsEditionFamily($EditionId) {
    # Famille de l'édition (valeur EditionID du registre), qui fixe le calendrier des correctifs. HOME : Famille et
    # Pro ; ENT : Entreprise et Éducation ; OTHER : LTSC (calendrier de 5 ou 10 ans), Windows Server, édition
    # inconnue : JARVIS ne juge pas. Fonction pure, T1.
    $e = ([string]$EditionId).Trim()
    if ($e -eq '') { return 'OTHER' }
    if ($e -match '^(Enterprise|IoTEnterprise)S') { return 'OTHER' }
    if ($e -match '^Server') { return 'OTHER' }
    if ($e -match '^(Core|Professional)') { return 'HOME' }
    if ($e -match '^(Enterprise|Education|IoTEnterprise)') { return 'ENT' }
    return 'OTHER'
}

function Get-WindowsSupportVerdict($Build, $EditionId, [datetime]$Now) {
    # Cette version de Windows reçoit-elle encore ses correctifs de sécurité ? Jugé sur le numéro de build et
    # l'édition, jamais sur ProductName (relevé du 26/11/2026 : « Windows 10 Pro » sur un Windows 11 26H2).
    # Rend { State ; Text ; Subs ; Kind ; IsWin10 }. Kind : ENDED (WARN), SOON (moins de 90 jours, INFO), OK,
    # UNKNOWN (INFO « non vérifiable » : build ou édition hors table, table de plus d'un an). Un état inconnu n'est
    # jamais un avertissement (règle 15). Le dernier jour de service compte encore. Fonction pure, T1.
    $inv = [Globalization.CultureInfo]::InvariantCulture
    $r = [pscustomobject]@{ State = 'INFO'; Text = ''; Subs = @(); Kind = 'UNKNOWN'; IsWin10 = $false }
    $b = ConvertTo-IntOrNull $Build
    if ($null -eq $b -or $b -lt 10240) {
        $r.Text = 'non vérifiable (numéro de version de Windows illisible)'
        return $r
    }
    $fam = Get-WindowsEditionFamily $EditionId
    if ($fam -eq 'OTHER') {
        $ed = ([string]$EditionId).Trim()
        if ($ed -eq '') { $ed = 'inconnue' }
        $r.Text = ('non vérifiable (édition {0} : calendrier particulier)' -f $ed)
        return $r
    }
    $tab = Get-WindowsLifecycleTable
    $stale = ($Now -gt $tab.AsOf.AddDays(365))
    if ($b -lt 22000) {
        # Windows 10 : toutes les versions sont terminées, la dernière (22H2, build 19045) le 14/10/2025
        $r.IsWin10 = $true
        $r.Kind = 'ENDED'
        $r.State = 'WARN'
        if ($b -lt 19045) {
            $r.Text = 'terminés (ancienne version de Windows 10)'
            $r.Subs = @('Windows ne reçoit plus aucun correctif de sécurité dans cette version.',
                        'Paramètres > Mise à jour et sécurité > Windows Update : installe tout ce qui est proposé,',
                        'jusqu''à la version 22H2 de Windows 10, puis relance J.A.R.V.I.S.')
            return $r
        }
        $r.Text = 'terminés le 14/10/2025 (Windows 10)'
        if ($Now.Date -le $tab.EsuEnd) {
            $r.Subs = @(('Microsoft en fournit encore jusqu''au {0} aux PC inscrits à son programme ESU' -f $tab.EsuEnd.ToString('dd/MM/yyyy', $inv)),
                        '(gratuit avec un compte Microsoft) : Paramètres > Mise à jour et sécurité > Windows Update,',
                        'lien d''inscription aux mises à jour de sécurité étendues. J.A.R.V.I.S. ne sait pas lire si c''est fait.',
                        'Ensuite, le passage à Windows 11 : voir la ligne « Passage à Windows 11 » en section 06.')
        } else {
            $r.Subs = @('Windows 10 ne reçoit plus aucun correctif de sécurité, même par le programme ESU.',
                        'Passage à Windows 11 conseillé si le matériel le permet (ligne « Passage à Windows 11 » en section 06).')
        }
        return $r
    }
    $row = $null
    foreach ($x in @($tab.Rows)) { if ($x.Build -eq $b) { $row = $x } }
    if ($null -eq $row) {
        $r.Text = ('non vérifiable (version {0} inconnue de J.A.R.V.I.S. : mets-le à jour)' -f $b)
        return $r
    }
    $end = $row.Home
    if ($fam -eq 'ENT') { $end = $row.Ent }
    $endTxt = $end.ToString('dd/MM/yyyy', $inv)
    if ($Now.Date -gt $end) {
        $r.Kind = 'ENDED'
        $r.State = 'WARN'
        $r.Text = ('terminés le {0} ({1})' -f $endTxt, $row.Name)
        $r.Subs = @('Cette version de Windows 11 ne reçoit plus de correctifs de sécurité.',
                    'Paramètres > Windows Update : installe la mise à jour de version proposée (« Windows 11, version ... »).',
                    'Si rien n''est proposé : installe d''abord les mises à jour en attente, redémarre, puis regarde à nouveau.')
        return $r
    }
    if ($stale) {
        $r.Text = 'non vérifiable (dates de J.A.R.V.I.S. trop anciennes : mets-le à jour)'
        return $r
    }
    $left = [int][math]::Floor(($end - $Now.Date).TotalDays)
    if ($left -le 90) {
        $r.Kind = 'SOON'
        $r.Text = ('assurés jusqu''au {0} seulement ({1}, encore {2} j)' -f $endTxt, $row.Name, $left)
        $r.Subs = @('Paramètres > Windows Update : installe la mise à jour de version dès qu''elle est proposée.')
        return $r
    }
    $r.Kind = 'OK'
    $r.State = 'OK'
    $r.Text = ('assurés jusqu''au {0} ({1})' -f $endTxt, $row.Name)
    return $r
}

function Get-Win11ReadinessVerdict($TpmPresent, $TpmSpec, $SecureBoot, $RamBytes, $SysVolBytes, $Is64) {
    # PC sous Windows 10 : ce qui s'oppose au passage à Windows 11, dans ce que JARVIS sait lire (puce TPM 2.0,
    # Secure Boot, 4 Go de mémoire, 64 Go de disque, Windows 64 bits ; page « Windows 11 requirements » de Microsoft).
    # Le processeur n'est pas contrôlé (liste de modèles tenue par Microsoft) : jamais « compatible » tout court.
    # Une valeur $null = non lue. Seuils un peu sous l'exigence : Windows annonce 3,9 Go pour 4 Go installés, et le
    # volume système d'un disque de 64 Go fait environ 57 Go. Toujours INFO (l'avertissement est celui de la
    # section 01). Rend { State ; Text ; Subs ; Kind } avec Kind : BLOCKED, PARTIAL, CLEAR. Fonction pure, T1.
    $block = @(); $unk = @()
    if ($null -eq $Is64) { $unk += 'type de Windows' }
    elseif (-not $Is64) { $block += 'Windows 10 en 32 bits (une réinstallation complète serait nécessaire)' }
    if ($null -eq $RamBytes) { $unk += 'mémoire' }
    elseif ([double]$RamBytes -lt 3.5GB) { $block += ('mémoire de {0} Go (4 Go exigés)' -f [int][math]::Round([double]$RamBytes / 1GB)) }
    if ($null -eq $SysVolBytes) { $unk += 'disque' }
    elseif ([double]$SysVolBytes -lt 50GB) { $block += ('disque système de {0} Go (64 Go exigés)' -f [int][math]::Round([double]$SysVolBytes / 1GB)) }
    if ($null -eq $TpmPresent) { $unk += 'puce TPM' }
    elseif (-not $TpmPresent) { $block += 'puce de sécurité (TPM) absente ou désactivée dans le BIOS' }
    elseif (([string]$TpmSpec) -match '^\s*(\d+)\.(\d+)') {
        if ([int]$Matches[1] -lt 2) { $block += ('puce de sécurité (TPM) en version {0}.{1} (2.0 exigée)' -f $Matches[1], $Matches[2]) }
    } else { $unk += 'version de la puce TPM' }
    if ($null -eq $SecureBoot) { $unk += 'Secure Boot' }
    elseif (-not $SecureBoot) { $block += 'démarrage sécurisé (Secure Boot) désactivé : il s''active dans le BIOS' }
    $tool = 'Verdict complet : menu Démarrer, tape « Contrôle d''intégrité du PC » (outil de Microsoft) > Vérifier maintenant.'
    $r = [pscustomobject]@{ State = 'INFO'; Text = ''; Subs = @(); Kind = 'CLEAR' }
    if ($block.Count -gt 0) {
        $r.Kind = 'BLOCKED'
        $r.Text = ('{0} obstacle(s) vu(s)' -f $block.Count)
        $r.Subs = @($block) + @($tool)
    } elseif ($unk.Count -gt 0) {
        $r.Kind = 'PARTIAL'
        $r.Text = ('non vérifiable en entier (non lu : {0})' -f ($unk -join ', '))
        $r.Subs = @($tool)
    } else {
        $r.Text = 'aucun obstacle vu (processeur non contrôlé)'
        $r.Subs = @($tool, 'S''il confirme : Paramètres > Mise à jour et sécurité > Windows Update propose Windows 11.')
    }
    return $r
}

function Get-SecureBootCertVerdict($SecureBootOn, $KeyRead, $Status, $ErrorCode) {
    # Certificats du démarrage sécurisé (v3.28). Ceux de 2011 ont expiré en 2026 (24/06, 27/06 et 19/10, article
    # 5062710 du support Microsoft) ; Windows Update pose ceux de 2023 et note l'avancement dans
    # HKLM\SYSTEM\CurrentControlSet\Control\SecureBoot\Servicing : UEFICA2023Status = NotStarted, InProgress ou
    # Updated, UEFICA2023Error = code du dernier échec. Relevé sur le PC de Thomas le 26/11/2026 : « Updated ».
    # Lecture seule : JARVIS n'écrit jamais dans cette clé (une pose ratée peut empêcher le PC de démarrer).
    # $null si Secure Boot n'est pas actif (rien à dire). Rend { State ; Text ; Subs }. Fonction pure, T1.
    if ($SecureBootOn -isnot [bool] -or -not $SecureBootOn) { return $null }
    $r = [pscustomobject]@{ State = 'INFO'; Text = ''; Subs = @() }
    if (-not $KeyRead) { $r.Text = 'lecture impossible'; return $r }
    $s = ([string]$Status).Trim()
    if ($s -eq '') {
        $r.Text = 'non vérifiable (information absente de ce Windows)'
        $r.Subs = @('Les mises à jour de Windows apportent ces certificats : installe celles qui sont en attente.')
        return $r
    }
    if ($s -match '^Updated$') { $r.State = 'OK'; $r.Text = 'à jour (certificats de 2023)'; return $r }
    $bios = 'Si la ligne revient après plusieurs semaines : mets à jour le BIOS (lien du fabricant en section 12).'
    $code = $null
    if ($null -ne $ErrorCode) { try { $code = [int64]$ErrorCode } catch { $code = $null } }
    if ($null -ne $code -and $code -lt 0) { $code += 4294967296 }
    if ($s -match '^(InProgress|NotStarted)$' -and $null -ne $code -and $code -ne 0) {
        $r.State = 'WARN'
        $r.Text = ('mise à jour en échec (code 0x{0:X8})' -f $code)
        $r.Subs = @('Le PC démarre normalement, mais son démarrage sécurisé ne reçoit plus de nouvelles protections.',
                    'Installe toutes les mises à jour Windows, redémarre deux fois, puis relance le scan.', $bios)
        return $r
    }
    if ($s -match '^InProgress$') {
        $r.Text = 'mise à jour en cours'
        $r.Subs = @('Windows la termine seul en un ou deux redémarrages. Rien d''autre à faire.')
        return $r
    }
    if ($s -match '^NotStarted$') {
        $r.State = 'WARN'
        $r.Text = 'anciens (ceux de 2011 ont expiré en 2026)'
        $r.Subs = @('Le PC démarre normalement, mais son démarrage sécurisé ne reçoit plus de nouvelles protections.',
                    'Installe toutes les mises à jour Windows puis redémarre : Windows pose les nouveaux certificats seul.', $bios)
        return $r
    }
    $r.Text = ('état non reconnu ({0})' -f $s)
    return $r
}

function Get-PuaVerdict($Value) {
    # Blocage des applications potentiellement indésirables de Defender (Get-MpPreference.PUAProtection) :
    # 0 = désactivé, 1 = actif, 2 = audit. Relevé sur le PC de Thomas le 26/11/2026 : 1. Fonction pure, T1.
    $n = ConvertTo-IntOrNull $Value
    if ($null -eq $n) { return 'UNKNOWN' }
    switch ($n) {
        0 { return 'OFF' }
        1 { return 'ON' }
        2 { return 'AUDIT' }
    }
    return 'UNKNOWN'
}

function Get-StorageSenseVerdict($Policy, $User) {
    # Assistant de stockage de Windows (Paramètres > Système > Stockage). La stratégie l'emporte
    # (HKLM\SOFTWARE\Policies\Microsoft\Windows\StorageSense, AllowStorageSenseGlobal : 0 ou 1), puis le réglage du
    # compte (HKCU\...\StorageSense\Parameters\StoragePolicy, valeur « 01 » : 1 = activé). Valeur absente = jamais
    # réglé, donc éteint (réglage d'origine de Windows). Relevé sur le PC de Thomas le 26/11/2026 : 01 = 1.
    # ON, OFF, DEFAULT (jamais réglé) ou UNKNOWN. Fonction pure, T1.
    $p = ConvertTo-IntOrNull $Policy
    if ($null -ne $p) {
        if ($p -eq 0) { return 'OFF' }
        return 'ON'
    }
    if ($null -eq $User) { return 'DEFAULT' }
    $u = ConvertTo-IntOrNull $User
    if ($null -eq $u) { return 'UNKNOWN' }
    if ($u -ne 0) { return 'ON' }
    return 'OFF'
}

function Get-TimeSyncMode($Value) {
    # « Régler l'heure automatiquement » (Paramètres > Heure et langue) : valeur Type de W32Time\Parameters.
    # AUTO : NTP (PC seul), NT5DS (domaine), AllSync. OFF : NoSync (réglage coupé). Fonction pure, testée en T1.
    if ($null -eq $Value) { return 'UNKNOWN' }
    $t = ([string]$Value).Trim()
    if ($t -match '^(NTP|NT5DS|AllSync)$') { return 'AUTO' }
    if ($t -match '^NoSync$') { return 'OFF' }
    return 'UNKNOWN'
}

function Test-ClockManualFix($Offset, $MaxPos, $MaxNeg) {
    # Relecture v3.26 : le service Heure Windows refuse de corriger seul un écart plus grand que MaxPosPhaseCorrection
    # (PC en retard, $Offset positif) ou MaxNegPhaseCorrection (PC en avance), 54 000 s (15 h) relevés sur le PC de
    # Thomas le 24/11/2026 (W32Time\Config) ; « Synchroniser maintenant » ne suffit alors pas (pile du BIOS usée,
    # date fausse de plusieurs années). Valeur absente ou illisible : 54 000 ; 0xFFFFFFFF (-1 lu en entier) : aucune
    # limite. $true = l'heure est à remettre à la main. Fonction pure, testée en T1.
    if ($null -eq $Offset) { return $false }
    $lim = $MaxPos
    if ([double]$Offset -lt 0) { $lim = $MaxNeg }
    $n = $null
    if ($null -ne $lim) { try { $n = [int64]$lim } catch { $n = $null } }
    if ($null -eq $n) { $n = 54000 }
    if ($n -eq -1 -or $n -eq 4294967295) { return $false }
    return ([math]::Abs([double]$Offset) -gt $n)
}

function Get-ClockCheck($ServerUtc, $AgeSec, $Before, $After) {
    # v3.26 (demande de Thomas, 24/11/2026 : PC-LV, rallumé après une longue pause, avait plusieurs minutes
    # d'écart et une mise à jour y avait échoué). Écart entre l'heure du PC et celle d'un serveur : $ServerUtc =
    # en-tête Date (à la seconde près), $AgeSec = en-tête Age (réponse gardée en cache), $Before et $After = heure
    # UTC du PC avant et après la requête. Positif : le PC retarde. Status OK (moins d'une minute : Windows
    # garde son heure à la seconde près quand sa mise à l'heure fonctionne), WARN, ou UNKNOWN (pas de réponse,
    # réponse trop lente pour une mesure fiable). Fonction pure, testée en T1.
    $r = [pscustomobject]@{ Status = 'UNKNOWN'; Offset = $null; Text = 'non vérifiable (pas de réponse d''Internet)' }
    if ($null -eq $ServerUtc -or $null -eq $Before -or $null -eq $After) { return $r }
    $rtt = ([datetime]$After - [datetime]$Before).TotalSeconds
    if ($rtt -lt 0 -or $rtt -gt 10) { $r.Text = 'non vérifiable (réponse d''Internet trop lente)'; return $r }
    $age = 0.0
    if ($null -ne $AgeSec) { $age = [double]$AgeSec }
    if ($age -lt 0 -or $age -gt 86400) { $r.Text = 'non vérifiable (réponse non reconnue)'; return $r }
    $mid = ([datetime]$Before).AddSeconds($rtt / 2)
    $off = (([datetime]$ServerUtc).AddSeconds($age + 0.5) - $mid).TotalSeconds
    $r.Offset = $off
    $g = [math]::Round([math]::Abs($off))
    if ($g -lt 60) {
        $r.Status = 'OK'
        if ($g -le 1) { $r.Text = 'à l''heure' } else { $r.Text = 'à l''heure (écart de {0} s)' -f $g }
        return $r
    }
    if ($g -lt 3600) {
        $gt = '{0} min' -f [math]::Floor($g / 60)
        if ($g % 60) { $gt += (' {0} s' -f ($g % 60)) }
    } elseif ($g -lt 172800) {
        $gt = '{0} h' -f [math]::Floor($g / 3600)
        $m = [math]::Floor(($g % 3600) / 60)
        if ($m) { $gt += (' {0} min' -f $m) }
    } else {
        $gt = '{0} jours' -f [math]::Floor($g / 86400)
    }
    $r.Status = 'WARN'
    if ($off -gt 0) { $r.Text = 'en retard de ' + $gt } else { $r.Text = 'en avance de ' + $gt }
    return $r
}

function Get-UacState {
    $k = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System'
    $lua = Get-RegValueSafe $k 'EnableLUA'
    if (-not $lua.Ok) { return 'UNKNOWN' }
    $consent = Get-RegValueSafe $k 'ConsentPromptBehaviorAdmin'
    return (Get-UacVerdict $lua.Value $consent.Value)
}

function Get-SmartScreenState {
    # Stratégie de groupe, puis stratégie d'un PC géré à distance (Intune), puis réglage de Sécurité Windows.
    # Une clé de stratégie illisible (ni lue, ni absente) : on ne conclut pas.
    $pol = Get-RegValueSafe 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System' 'EnableSmartScreen'
    $mdm = Get-RegValueSafe 'HKLM:\SOFTWARE\Microsoft\PolicyManager\current\device\SmartScreen' 'EnableSmartScreenInShell'
    $exp = Get-RegValueSafe 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer' 'SmartScreenEnabled'
    if (-not $pol.Ok -and -not $pol.Missing) { return 'UNKNOWN' }
    if (-not $mdm.Ok -and -not $mdm.Missing) { return 'UNKNOWN' }
    $p = $pol.Value
    if ($null -eq $p) { $p = $mdm.Value }
    if ($null -eq $p -and -not $exp.Ok) { return 'UNKNOWN' }
    return (Get-SmartScreenVerdict $p $exp.Value)
}

function Get-RdpState {
    $pol = Get-RegValueSafe 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services' 'fDenyTSConnections'
    $loc = Get-RegValueSafe 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server' 'fDenyTSConnections'
    if (-not $pol.Ok -and -not $pol.Missing) { return 'UNKNOWN' }
    return (Get-RdpVerdict $pol.Value $loc.Value)
}

function Get-Smb1State {
    try {
        $cfg = Get-SmbServerConfiguration -ErrorAction Stop
        return (Get-OnOffVerdict $cfg.EnableSMB1Protocol)
    } catch { return 'UNKNOWN' }
}

function Get-HvciState {
    $run = $null
    $cimOk = $false
    try {
        $dg = Get-CimInstance -Namespace 'root\Microsoft\Windows\DeviceGuard' -ClassName Win32_DeviceGuard -ErrorAction Stop | Select-Object -First 1
        if ($dg) {
            $run = @($dg.SecurityServicesRunning)
            $cimOk = $true
        }
    } catch { $cimOk = $false }
    $reg = Get-RegValueSafe 'HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity' 'Enabled'
    return (Get-HvciVerdict $run $reg.Value $cimOk)
}

function Get-LocalAccountState {
    # Ok : la liste des comptes a été lue. Admins : nombre de comptes actifs du groupe Administrateurs,
    # ou $null (Get-LocalGroupMember échoue sur certains PC quand le groupe contient un compte orphelin).
    # CurrentIsBuiltin : JARVIS tourne sous le compte Administrateur intégré. Domain : PC rattaché à un domaine.
    $r = [pscustomobject]@{ Ok = $false; Findings = $null; Admins = $null; CurrentIsBuiltin = $false; Domain = $false }
    $users = @()
    try {
        $users = @(Get-LocalUser -ErrorAction Stop | ForEach-Object {
            [pscustomobject]@{
                Name = [string]$_.Name; Sid = [string]$_.SID.Value; Enabled = [bool]$_.Enabled
                PasswordRequired = [bool]$_.PasswordRequired; PasswordSet = ($null -ne $_.PasswordLastSet)
            }
        })
        if ($users.Count -gt 0) {
            $r.Findings = Get-AccountFindings $users
            $r.Ok = $true
        }
    } catch { $r.Ok = $false }
    if ($r.Ok) {
        try {
            $sids = @(Get-LocalGroupMember -SID 'S-1-5-32-544' -ErrorAction Stop | ForEach-Object { [string]$_.SID.Value })
            $r.Admins = @($users | Where-Object { $_.Enabled -and $sids -contains $_.Sid }).Count
        } catch { $r.Admins = $null }
        try { $r.CurrentIsBuiltin = ([string][Security.Principal.WindowsIdentity]::GetCurrent().User.Value -match '^S-1-5-21-[\d-]+-500$') } catch { $r.CurrentIsBuiltin = $false }
        $r.Domain = [bool](Get-CimInstance Win32_ComputerSystem).PartOfDomain
    }
    return $r
}

function Get-HostsState {
    # Ok : le fichier a été lu, ou il n'existe pas (aucune redirection). Accès refusé : Ok reste faux.
    # Moved : Windows lit le fichier hosts dans un autre dossier que celui d'origine (chemin), on ne va pas plus loin.
    $r = [pscustomobject]@{ Ok = $false; Moved = ''; Findings = $null }
    $win = [Environment]::GetFolderPath('Windows')
    if (-not $win) { $win = $env:windir }
    $db = Get-RegValueSafe 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters' 'DataBasePath'
    $dir = 'UNKNOWN'
    if ($db.Ok) { $dir = Get-HostsDirVerdict ([string]$db.Value) $win }
    if ($dir -eq 'UNKNOWN') { return $r }
    if ($dir -eq 'MOVED') {
        $r.Ok = $true
        $r.Moved = [string]$db.Value
        return $r
    }
    $p = Join-Path $win 'System32\drivers\etc\hosts'
    $txt = $null
    try { $txt = [IO.File]::ReadAllText($p) }
    catch [System.IO.FileNotFoundException] { $txt = '' }
    catch [System.IO.DirectoryNotFoundException] { $txt = '' }
    catch { $txt = $null }
    if ($null -ne $txt) {
        $r.Findings = Get-HostsFindings $txt
        $r.Ok = $true
    }
    return $r
}

function Get-ProxyState {
    # Le proxy est un réglage par compte : après une élévation sous un autre compte, HKCU n'est pas celui de l'utilisateur
    $sess = [string](Get-CimInstance Win32_ComputerSystem).UserName
    if (-not (Test-SameAccount $sess ([Environment]::UserName))) { return [pscustomobject]@{ State = 'OTHERUSER'; Detail = '' } }
    $k = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings'
    $en = Get-RegValueSafe $k 'ProxyEnable'
    if (-not $en.Ok) { return [pscustomobject]@{ State = 'UNKNOWN'; Detail = '' } }
    $srv = Get-RegValueSafe $k 'ProxyServer'
    $auto = Get-RegValueSafe $k 'AutoConfigURL'
    return (Get-ProxyVerdict $en.Value $srv.Value $auto.Value)
}

function Get-ActivationState {
    # Requête filtrée (sans filtre, la classe met plus d'une minute à répondre sur certains PC)
    try {
        $lic = @(Get-CimInstance -ClassName SoftwareLicensingProduct -OperationTimeoutSec 30 -ErrorAction Stop `
                 -Filter "ApplicationID='55c92734-d682-4d71-983e-d6ec3f16059f' AND PartialProductKey IS NOT NULL")
        return (Get-ActivationVerdict @($lic | ForEach-Object { $_.LicenseStatus }))
    } catch { return 'UNKNOWN' }
}

function Invoke-DefenderQuickScan {
    # Analyse rapide de Microsoft Defender, sur confirmation. Le succès n'est annoncé que si Defender a
    # enregistré une fin d'analyse postérieure au lancement ; « aucune menace » seulement si la liste des
    # détections a été lue.
    $where = 'Sécurité Windows > Protection contre les virus et menaces'
    $start = Get-Date
    Write-Host ''
    Write-Host '   >> Analyse antivirus rapide (Microsoft Defender). Tu peux continuer à utiliser le PC.' -ForegroundColor Cyan
    $job = Invoke-Spinner 'Analyse antivirus rapide' {
        try {
            Start-MpScan -ScanType QuickScan -ErrorAction Stop
            [pscustomobject]@{ Ok = $true; Error = '' }
        } catch {
            [pscustomobject]@{ Ok = $false; Error = [string]$_.Exception.Message }
        }
    } 1800
    $jobOk = $null
    if ($null -ne $job) { $jobOk = [bool]$job.Ok }
    # Aucun résultat : délai dépassé seulement si les 30 min sont écoulées, sinon le job s'est interrompu
    $timedOut = ($null -eq $job -and ((Get-Date) - $start).TotalSeconds -ge 1790)
    # Defender peut mettre quelques secondes à enregistrer la fin de l'analyse
    $end = $null
    for ($i = 0; $i -lt 6; $i++) {
        $st = Get-MpComputerStatus
        if ($st) { $end = $st.QuickScanEndTime }
        if ((Get-MpScanVerdict $jobOk $start $end $timedOut) -ne 'UNVERIFIED') { break }
        Start-Sleep -Seconds 2
    }
    $verdict = Get-MpScanVerdict $jobOk $start $end $timedOut
    if ($verdict -eq 'FAILED') {
        Write-Action 'FAIL' ('Analyse antivirus : Defender ne l''a pas lancée (' + (Cut ([string]$job.Error) 90) + ')')
        Write-Host ('          Lance-la à la main : ' + $where + ' > Analyse rapide.') -ForegroundColor DarkGray
        return
    }
    if ($verdict -eq 'TIMEOUT') {
        Write-Action 'WARN' 'Analyse antivirus : pas terminée après 30 min, J.A.R.V.I.S. n''attend plus'
        Write-Host ('          Son résultat se lit dans ' + $where + ' > Historique de protection.') -ForegroundColor DarkGray
        return
    }
    if ($verdict -ne 'DONE') {
        Write-Action 'INFO' 'Analyse antivirus : Defender n''a pas enregistré de fin d''analyse (résultat non vérifié)'
        Write-Host ('          Contrôle dans ' + $where + ' > Historique de protection.') -ForegroundColor DarkGray
        return
    }
    $mins = [math]::Max(1, [math]::Round(((Get-Date) - $start).TotalMinutes))
    $det = $null
    try { $det = @(Get-MpThreatDetection -ErrorAction Stop) } catch { $det = $null }
    if ($null -eq $det) {
        Write-Action 'INFO' ("Analyse antivirus terminée ({0} min), mais la liste des menaces est illisible" -f $mins)
        Write-Host ('          Contrôle dans ' + $where + ' > Historique de protection.') -ForegroundColor DarkGray
        return
    }
    $new = @(Get-MpThreatsSince $det $start)
    if ($new.Count -eq 0) {
        Write-Action 'OK' ("Analyse antivirus rapide terminée et vérifiée ({0} min) : aucune menace détectée" -f $mins)
        return
    }
    $names = @()
    try {
        $known = @(Get-MpThreat -ErrorAction Stop)
        $names = @($new | ForEach-Object {
            $id = $_.ThreatID
            ($known | Where-Object { $_.ThreatID -eq $id } | Select-Object -First 1).ThreatName
        } | Where-Object { $_ } | Select-Object -Unique)
    } catch { $names = @() }
    $open = @($new | Where-Object { -not (Test-MpThreatHandled $_.ThreatStatusID) })
    $txt = "Analyse antivirus : {0} menace(s) détectée(s)" -f $new.Count
    if ($names.Count -gt 0) { $txt += ' : ' + (Cut ($names -join ', ') 120) }
    if ($open.Count -eq 0) {
        Write-Action 'WARN' ($txt + ', traitée(s) par Defender (quarantaine ou suppression)')
        Write-Host ('          Détail : ' + $where + ' > Historique de protection.') -ForegroundColor Yellow
        Write-Host '          Si une menace revient, demande de l''aide.' -ForegroundColor Yellow
        return
    }
    Write-Action 'FAIL' ($txt + (', dont {0} pas encore traitée(s)' -f $open.Count))
    Write-Host '          Defender les met en général lui-même en quarantaine. Ouvre' -ForegroundColor Yellow
    Write-Host ('          ' + $where + ' > Historique de protection') -ForegroundColor Yellow
    Write-Host '          et applique les actions proposées. Si une menace revient, demande de l''aide.' -ForegroundColor Yellow
}

function Update-Report([string]$File, [string[]]$Lines) {
    # Réécrit le rapport déjà enregistré pour y ajouter le résultat des actions ; $true seulement si relu
    try {
        $Lines | Set-Content -LiteralPath $File -Encoding UTF8 -ErrorAction Stop
        return ((Get-Item -LiteralPath $File -ErrorAction Stop).Length -gt 0)
    } catch { return $false }
}

function Invoke-WindowsRepair {
    # Réparation de Windows : DISM /RestoreHealth puis SFC /scannow. Chaque outil est lancé par son chemin
    # complet, son code et son texte sont lus, et le résultat affiché vient d'un analyseur testé (T1).
    # v3.21 : le bilan de DISM (défauts trouvés et réparés) est lu dans CBS.log juste après DISM, avant que
    # SFC ne relance le service qui peut mettre ce journal de côté ; il est mémorisé (LastRepair) pour
    # prévenir avant de reproposer une réparation qui n'ira pas plus loin.
    Write-Host '   NE FERME PAS CETTE FENÊTRE pendant la réparation.' -ForegroundColor Yellow
    Write-Host ''
    $start = (Get-Date).AddSeconds(-5)
    $dism = Invoke-ProcessSpinner -Label 'DISM /RestoreHealth (10-30 min)' -FilePath (Get-SystemToolPath 'dism.exe') `
            -Arguments '/Online /Cleanup-Image /RestoreHealth' -TimeoutSec 3600 -Encoding 'Auto' -AskOnTimeout
    if ($null -eq $dism) {
        if ($script:ProcState -eq 'STOPPED') { Write-Status 'DISM RestoreHealth' 'arrêté à ta demande avant la fin' 'WARN' }
        else { Write-Status 'DISM RestoreHealth' 'lancement impossible' 'WARN' }
        Write-Sub 'Réparation non faite : relance un scan complet pour recommencer'
        return
    }
    $sum = Get-CbsSummary (Read-CbsLogText $start) $start 'REPAIR'
    $incomplete = $false
    $memo = $null
    switch (Get-DismRepairVerdict $dism.Text $dism.Code) {
        'REPAIRED' {
            Write-Status 'DISM RestoreHealth' 'image Windows réparée' 'OK'
            if ($sum -and $sum.FilesRepaired -gt 0) { Write-Sub ('{0:N0} défaut(s) réparé(s) dans le magasin de composants' -f $sum.FilesRepaired) }
            if ($sum -and $sum.Flags -gt 0) {
                # Relecture v3.26 : « plus » seulement après une ligne de défauts réparés
                $flTxt = '{0:N0} marque(s) interne(s) de Windows remise(s) en ordre, sans gravité' -f $sum.Flags
                if ($sum.FilesRepaired -gt 0) { $flTxt = 'plus ' + $flTxt }
                Write-Sub $flTxt
            }
            $memo = 'REPAIRED|0'
        }
        'NOSOURCE' {
            $incomplete = $true
            if ($sum -and $sum.FilesRepaired -gt 0 -and $sum.Remaining -gt 0) {
                Write-Status 'DISM RestoreHealth' ('réparation partielle : {0:N0} défauts réparés sur {1:N0}' -f $sum.FilesRepaired, $sum.FilesDetected) 'WARN'
                Write-Sub ('{0:N0} restent : Windows Update ne fournit plus les fichiers qui les remplaceraient' -f $sum.Remaining)
                $memo = 'PARTIAL|{0}' -f $sum.Remaining
            } else {
                Write-Status 'DISM RestoreHealth' 'échec : fichiers de réparation introuvables' 'FAIL'
                Write-Sub 'Vérifie la connexion Internet, puis réessaie après la prochaine mise à jour de Windows'
                $memo = 'NOSOURCE|'
                if ($sum) { $memo = 'NOSOURCE|{0}' -f $sum.Remaining }
            }
        }
        'FAILED' {
            Write-Status 'DISM RestoreHealth' ("échec, code 0x{0:X8}" -f [int]$dism.Code) 'FAIL'
            Write-Sub 'Détails : C:\Windows\Logs\DISM\dism.log'
            $memo = 'FAILED|'
        }
        default {
            Write-Status 'DISM RestoreHealth' 'terminé, mais résultat non reconnu' 'INFO'
            Write-Sub 'Détails : C:\Windows\Logs\DISM\dism.log'
        }
    }
    if ($memo) { $null = Set-JarvisConfigValue 'LastRepair' ('{0}|{1}' -f (Get-Date -Format 'yyyy-MM-dd'), $memo) }
    $sfcStart = (Get-Date).AddSeconds(-5)
    $sfc = Invoke-ProcessSpinner -Label 'SFC /scannow (5-20 min)' -FilePath (Get-SfcPath) `
           -Arguments '/scannow' -TimeoutSec 3600 -Encoding 'Auto' -AskOnTimeout
    if ($null -eq $sfc) {
        if ($script:ProcState -eq 'STOPPED') { Write-Status 'SFC /scannow' 'arrêté à ta demande avant la fin' 'WARN' }
        else { Write-Status 'SFC /scannow' 'lancement impossible' 'WARN' }
        return
    }
    switch (Get-SfcVerdict $sfc.Text) {
        'CLEAN' {
            Write-Status 'SFC /scannow' 'aucune violation d''intégrité' 'OK'
            # DISM incomplet mais Windows en service intact : aucune réinstallation à conseiller
            if ($incomplete) { Write-Sub 'Windows en service intact : rien d''urgent, réessaie après la prochaine mise à jour de Windows' }
        }
        'REPAIRED' {
            $rep = Get-SfcRepairSummary (Read-CbsLogText $sfcStart) $sfcStart
            if ($rep.OnlyOneDrive) {
                Write-Status 'SFC /scannow' 'seul le raccourci OneDrive des nouveaux comptes a été remis' 'OK'
                Write-Sub 'OneDrive remplace ce raccourci quand il se met à jour, SFC remet celui de Windows : rien à faire'
            } else {
                Write-Status 'SFC /scannow' 'fichiers système corrompus réparés' 'OK'
                Write-SfcRepairedFiles $rep
                Write-Sub 'Redémarre le PC pour terminer la réparation'
            }
        }
        'UNFIXED' {
            Write-Status 'SFC /scannow' 'des fichiers corrompus n''ont pas pu être réparés' 'FAIL'
            Write-Sub 'Détails : C:\Windows\Logs\CBS\CBS.log. Réparation de Windows conseillée (réinstallation sur place)'
        }
        'STOREDAMAGED' {
            Write-Status 'SFC /scannow' 'intégrité non garantie : magasin de composants encore endommagé' 'FAIL'
            Write-Sub 'Réparation de Windows conseillée (réinstallation sur place)'
        }
        'NORUN' {
            Write-Status 'SFC /scannow' 'n''a pas pu s''exécuter' 'WARN'
            Write-Sub 'Redémarre le PC puis relance un scan complet'
        }
        default {
            Write-Status 'SFC /scannow' 'résultat non reconnu' 'INFO'
            Write-Sub 'Détails : C:\Windows\Logs\CBS\CBS.log'
        }
    }
}

# ------------------------------------------------------------------
# Auto-test
# ------------------------------------------------------------------
function Invoke-SelfTestAnalyzers {
    # T1 : analyseurs (cas connus, aucune dépendance au PC ni à la console).
    # Appelée par Invoke-SelfTest (auto-test) et par tools/check.ps1 (contrôle avant chaque fabrication) :
    # Test-Case, Assert-True et Write-Section sont fournis par l'appelant.
    Write-Section 'T1' 'Analyseurs de résultats (cas de référence)'

    $ap = [string][char]0x2019      # apostrophe typographique des messages de Windows 11
    $sfcCases = @(
        @('Windows Resource Protection did not find any integrity violations.', 'CLEAN'),
        @("La protection des ressources Windows n'a trouvé aucune violation d'intégrité.", 'CLEAN'),
        @('Windows Resource Protection found corrupt files and successfully repaired them.', 'REPAIRED'),
        @('La protection des ressources Windows a trouvé des fichiers endommagés et les a réparés.', 'REPAIRED'),
        @('Windows Resource Protection found corrupt files but was unable to fix some of them.', 'UNFIXED'),
        @("La protection des ressources Windows a trouvé des fichiers endommagés, mais n'a pas pu en réparer certains.", 'UNFIXED'),
        @('Windows Resource Protection could not perform the requested operation.', 'NORUN'),
        @("La protection des ressources Windows n'a pas pu effectuer l'opération demandée.", 'NORUN'),
        # Messages de Windows 11 en français, relevés dans sfc.exe.mui le 19/11/2026
        @(('Le programme de protection des ressources Windows n' + $ap + 'a trouvé aucune violation d' + $ap + 'intégrité.'), 'CLEAN'),
        @(('La protection des ressources Windows n' + $ap + 'a pas réussi à effectuer l' + $ap + 'opération demandée.'), 'NORUN'),
        @(('La protection des ressources Windows n' + $ap + 'a pas réussi à démarrer le service de réparation.'), 'NORUN'),
        @(('Pour pouvoir utiliser l' + $ap + 'utilitaire sfc, vous devez être un administrateur exécutant une session de console.'), 'NORUN'),
        @('La Protection des ressources Windows a détecté des fichiers corrompus et les a réparés. Pour les réparations en ligne, les détails sont inclus dans le fichier journal de CBS.', 'REPAIRED'),
        @("La Protection des ressources Windows a détecté des fichiers corrompus, mais n'a pas pu réparer certains d'entre eux.", 'UNFIXED'),
        @("La Protection des ressources Windows a détecté des violations de l'intégrité.", 'UNFIXED'),
        @("La Protection des ressources Windows n'a pas détecté de violations de l'intégrité, mais ne peut pas garantir l'intégrité du système, car les métadonnées des composants sont endommagées.", 'STOREDAMAGED'),
        @('Windows Resource Protection did not find any integrity violations, but cannot guarantee system integrity.', 'STOREDAMAGED'),
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
    Test-Case 'SFC : sortie réelle (UTF-16, fins de ligne Windows)' {
        $txt = "`r`n`r`nDébut de l'analyse du système. Cette opération peut nécessiter un certain temps.`r`n`r`n" +
               "Démarrage de la phase de vérification de l'analyse du système.`r`nLa vérification est à 100 % terminée.`r`n`r`n" +
               'La Protection des ressources Windows a détecté des fichiers corrompus, mais n' + $ap + "a pas pu réparer certains d'entre eux.`r`n"
        $got = Get-SfcVerdict (ConvertFrom-ToolBytes ([Text.Encoding]::Unicode.GetBytes($txt)))
        Assert-True ($got -eq 'UNFIXED') "obtenu $got"
        'fichiers non réparés reconnus'
    }
    Test-Case 'Sortie d''outil : décodage UTF-16, UTF-8, OEM' {
        $txt = "Le magasin de composants est réparable.`r`nL'opération a réussi.`r`n"
        Assert-True ((ConvertFrom-ToolBytes ([Text.Encoding]::Unicode.GetBytes($txt))) -eq $txt) 'UTF-16 mal décodé'
        Assert-True ((ConvertFrom-ToolBytes ([Text.Encoding]::UTF8.GetBytes($txt))) -eq $txt) 'UTF-8 mal décodé'
        # Octet 0x82 isolé (« é » dans les pages de code OEM 850 et 437) : invalide en UTF-8, donc lu en OEM
        $oem = ConvertFrom-ToolBytes ([byte[]](0x72, 0x82, 0x70, 0x61, 0x72, 0x61, 0x62, 0x6C, 0x65, 0x0D, 0x0A))
        Assert-True ($oem.EndsWith("arable`r`n") -and $oem.Length -ge 9) ('page de code OEM mal décodée : ' + $oem.Trim())
        Assert-True ((ConvertFrom-ToolBytes $null) -eq '') 'sortie absente'
        '4/4 cas'
    }

    $dismCases = @(
        @('No component store corruption detected.', 0, 'CLEAN'),
        @(('Aucun endommagement du magasin de composants n' + $ap + 'a été détecté.'), 0, 'CLEAN'),
        @('The component store is repairable.', 0, 'REPAIRABLE'),
        @('Le magasin de composants est réparable.', 0, 'REPAIRABLE'),
        @('The component store cannot be repaired.', 0, 'UNREPAIRABLE'),
        @('Le magasin de composants est irréparable.', 0, 'UNREPAIRABLE'),
        # Accents mal décodés (UTF-8 lu comme page de code 850) : le verdict doit rester le bon
        @(([Text.Encoding]::GetEncoding(850).GetString([Text.Encoding]::UTF8.GetBytes('Le magasin de composants est réparable.'))), 0, 'REPAIRABLE'),
        @(([Text.Encoding]::GetEncoding(850).GetString([Text.Encoding]::UTF8.GetBytes('Le magasin de composants est irréparable.'))), 0, 'UNREPAIRABLE'),
        @('Error: 87 The parameter is incorrect.', 87, 'ERROR'),
        # Aucun message reconnu : jamais « sain » par défaut
        @('The operation completed successfully.', 0, 'UNKNOWN'),
        @('', 0, 'UNKNOWN')
    )
    Test-Case 'DISM : messages et codes' {
        foreach ($c in $dismCases) {
            $got = Get-DismVerdict $c[0] $c[1]
            Assert-True ($got -eq $c[2]) ("« {0} » -> {1}, attendu {2}" -f (Cut $c[0] 30), $got, $c[2])
        }
        '{0}/{0} cas' -f $dismCases.Count
    }
    Test-Case 'DISM : sortie réelle avec fins de ligne Windows' {
        $head = "`r`nOutil Gestion et maintenance des images de déploiement`r`nVersion : 10.0.26100.1`r`n`r`nVersion de l'image : 10.0.26300.1`r`n`r`n"
        $bar = '[==========================100.0%==========================] '
        $clean = $head + $bar + 'Aucun endommagement du magasin de composants n' + $ap + "a été détecté.`r`nL" + $ap + "opération a réussi.`r`n"
        Assert-True ((Get-DismVerdict $clean 0) -eq 'CLEAN') 'magasin sain non reconnu'
        $rep = $head + $bar + "Le magasin de composants est réparable.`r`nL" + $ap + "opération a réussi.`r`n"
        Assert-True ((Get-DismVerdict $rep 0) -eq 'REPAIRABLE') 'magasin réparable non reconnu'
        # Octets dans la page de code OEM de ce PC, comme DISM les écrit
        $oemPage = [Globalization.CultureInfo]::CurrentCulture.TextInfo.OEMCodePage
        $oemBytes = [Text.Encoding]::GetEncoding($oemPage).GetBytes($head + $bar + "Le magasin de composants est irréparable.`r`n")
        Assert-True ((Get-DismVerdict (ConvertFrom-ToolBytes $oemBytes) 0) -eq 'UNREPAIRABLE') 'magasin irréparable non reconnu (octets OEM)'
        '3/3 cas'
    }
    Test-Case 'DISM : résultat de la réparation' {
        $cases = @(
            @("The restore operation completed successfully.`r`nThe operation completed successfully.`r`n", 0, 'REPAIRED'),
            @(("La restauration a été effectuée.`r`nL" + $ap + "opération a réussi.`r`n"), 0, 'REPAIRED'),
            @('The restore operation failed. Either the repair source was not found or the component store cannot be repaired.', -2146498529, 'NOSOURCE'),
            @('Échec de la restauration. La source de réparation est introuvable ou le magasin de composants est irréparable.', -2146498529, 'NOSOURCE'),
            # 0x800F0915, autre PC le 20/11/2026 ; texte français relevé dans CbsProvider.dll.mui le 21/11/2026
            @(("Erreur : 0x800f0915`r`n`r`nLe contenu de réparation est introuvable. Vérifiez la connectivité Internet ou utilisez l" + $ap + "option « Source ».`r`n"), -2146498283, 'NOSOURCE'),
            @("Error: 0x800f0915`r`n`r`nThe repair content could not be found anywhere.`r`n", -2146498283, 'NOSOURCE'),
            @('Erreur', -2146498283, 'NOSOURCE'),
            @('Error: 1726 The remote procedure call failed.', 1726, 'FAILED'),
            @('The operation completed successfully.', 0, 'UNKNOWN'),
            @('', $null, 'FAILED')
        )
        foreach ($c in $cases) {
            $got = Get-DismRepairVerdict $c[0] $c[1]
            Assert-True ($got -eq $c[2]) ("« {0} » -> {1}, attendu {2}" -f (Cut $c[0] 30), $got, $c[2])
        }
        '{0}/{0} cas' -f $cases.Count
    }

    Test-Case 'CHKDSK : codes de sortie 0-3, code absent ou inattendu' {
        # v3.26 (constat V7) : code absent = UNKNOWN (avant [int]$null = 0 = « aucune erreur ») ; code hors 0 à 3 =
        # UNKNOWN (avant « erreurs détectées » en rouge)
        $cases = @(
            @(0, 'CLEAN'), @(1, 'FIXED'), @(2, 'MINOR'), @(3, 'ERRORS'), @('0', 'CLEAN'), @(' 3 ', 'ERRORS'),
            @($null, 'UNKNOWN'), @('', 'UNKNOWN'), @('abc', 'UNKNOWN'), @(4, 'UNKNOWN'), @(-1, 'UNKNOWN'),
            @(-1073741819, 'UNKNOWN')
        )
        foreach ($c in $cases) {
            $got = Get-ChkdskVerdict $c[0]
            Assert-True ($got -eq $c[1]) ("code « {0} » -> {1}, attendu {2}" -f $c[0], $got, $c[1])
        }
        '{0}/{0} cas' -f $cases.Count
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
        # v3.27 : noms lus dans la sortie réelle de « winget upgrade --include-unknown » (25/11/2026, CRLF)
        $fmt = '{0,-16}{1,-22}{2,-19}{3,-19}{4}'
        $raw = "   - `r   \ `r`r`n" + ($fmt -f 'Nom', 'ID', 'Version', 'Disponible', 'Source') + "`r`n" + ('-' * 82) + "`r`n" +
               ($fmt -f 'Docker Desktop', 'Docker.DockerDesktop', '4.99.0', '4.100.1', 'winget') + "`r`n" +
               ($fmt -f 'Epson Scan 2', 'EPSON.EpsonScan2', 'Unknown', '6.7.89.1', 'winget') + "`r`n" +
               "2 mises à niveau disponibles.`r`n"
        $n = @(Get-WingetUnknownNames @(ConvertFrom-WingetText $raw))
        Assert-True ($n.Count -eq 1 -and $n[0] -eq 'Epson Scan 2') ('noms inconnus lus : ' + ($n -join ', '))
        Assert-True (@(Get-WingetUnknownNames @()).Count -eq 0) 'liste vide : nom inventé'
        '5/5 cas'
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
    Test-Case 'winget : « aucune » seulement si winget le dit' {
        Assert-True ((Get-WingetScanState "Aucune mise à niveau disponible.`r`n" 0) -eq 'NONE') 'message FR (fin de ligne Windows) non reconnu'
        Assert-True ((Get-WingetScanState 'No available upgrade found.' 0) -eq 'NONE') 'message EN non reconnu'
        Assert-True ((Get-WingetScanState 'tableau lu' 3) -eq 'LIST') 'liste lue non reconnue'
        Assert-True ((Get-WingetScanState '' 0) -eq 'UNREADABLE') 'réponse vide prise pour « aucune »'
        Assert-True ((Get-WingetScanState "Échec lors de la recherche dans la source : winget`r`n" 0) -eq 'UNREADABLE') 'erreur de winget prise pour « aucune »'
        '5/5 cas'
    }
    Test-Case 'winget : caractères de contrôle retirés' {
        $esc = [string][char]27
        $fmt = '{0,-16}{1,-22}{2,-19}{3,-19}{4}'
        $raw = ($fmt -f 'Nom', 'ID', 'Version', 'Disponible', 'Source') + "`r`n" + ('-' * 82) + "`r`n" +
               ($fmt -f ('Outil' + $esc + '[2J'), 'Editeur.Outil', '1.0', ('2.0' + [char]7), 'winget') + "`r`n"
        $r = @(ConvertFrom-WingetText $raw)
        Assert-True ($r.Count -eq 1) ("{0} paquet(s), attendu 1" -f $r.Count)
        $all = $r[0].Name + $r[0].Id + $r[0].Installed + $r[0].Available
        Assert-True ($all -notmatch '[\x00-\x1F\x7F-\x9F]') 'caractère de contrôle conservé'
        'séquence d''échappement neutralisée'
    }
    Test-Case 'DISM : bilan de la réparation lu dans CBS.log' {
        # Lignes réelles de l'autre PC (20/11/2026), fins de ligne CRLF comme le vrai journal (règle 0)
        $L = { param($ts, $msg) '{0}, Info                  CBS    {1}' -f $ts, $msg }
        $rows = @(
            (& $L '2026-11-20 12:29:20' 'Summary:'),
            (& $L '2026-11-20 12:29:20' 'Operation: Detect only '),
            (& $L '2026-11-20 12:29:20' 'Operation result: 0x0'),
            (& $L '2026-11-20 12:29:20' 'Last Successful Step: Stage package detection completes.'),
            (& $L '2026-11-20 12:29:20' "Total Detected Corruption:`t692"),
            (& $L '2026-11-20 12:29:20' "`tCSI Payload Corruption:`t692"),
            (& $L '2026-11-20 12:29:20' "Total Repaired Corruption:`t0"),
            (& $L '2026-11-20 12:29:20' 'Total Operation Time: 212 seconds.'),
            (& $L '2026-11-20 13:01:24' 'Repair failed: Missing replacement payload.'),
            (& $L '2026-11-20 13:01:24' 'Summary:'),
            (& $L '2026-11-20 13:01:24' 'Operation: Detect and Repair '),
            (& $L '2026-11-20 13:01:24' 'Operation result: 0x0'),
            (& $L '2026-11-20 13:01:24' "Total Detected Corruption:`t1973"),
            (& $L '2026-11-20 13:01:24' "Total Repaired Corruption:`t1929"),
            (& $L '2026-11-20 13:01:24' "`tCSI Payload Repaired:`t648"),
            (& $L '2026-11-20 13:01:24' 'Total Operation Time: 1582 seconds.')
        )
        $crlf = ($rows -join "`r`n") + "`r`n"
        $lf = ($rows -join "`n") + "`n"
        $t0 = [datetime]'2026-11-20 12:35:00'
        $r = Get-CbsSummary $crlf $t0 'REPAIR'
        Assert-True ($null -ne $r -and $r.Detected -eq 1973 -and $r.Repaired -eq 1929 -and $r.Remaining -eq 44) 'bilan de la réparation (CRLF) mal lu'
        $r = Get-CbsSummary $lf $t0 'REPAIR'
        Assert-True ($null -ne $r -and $r.Remaining -eq 44) 'bilan de la réparation (LF) mal lu'
        $d = Get-CbsSummary $crlf ([datetime]'2026-11-20 12:25:00') 'DETECT'
        Assert-True ($null -ne $d -and $d.Detected -eq 692 -and $d.Repaired -eq 0) 'bilan de l''analyse mal lu'
        Assert-True ($null -eq (Get-CbsSummary $crlf $t0 'DETECT')) 'analyse antérieure au lancement prise en compte'
        $cut = ($rows[9..13] -join "`r`n") + "`r`n"
        Assert-True ($null -eq (Get-CbsSummary $cut $t0 'REPAIR')) 'bilan incomplet accepté'
        Assert-True ($null -eq (Get-CbsSummary '' $t0 'REPAIR')) 'texte vide accepté'
        Assert-True ($r.FilesRepaired -eq 1929 -and $r.FilesDetected -eq 1973 -and $r.Flags -eq 0) 'bilan sans marques de fichiers modifié'
        # Bilan réel du PC de Thomas le 24/11/2026 (/RestoreHealth) : 33 fichiers et 1 154 marques internes
        $mk = { param($fd, $fr) @(
                (& $L '2026-11-24 15:44:30' 'Summary:'),
                (& $L '2026-11-24 15:44:30' 'Operation: Detect and Repair '),
                (& $L '2026-11-24 15:44:30' "Total Detected Corruption:`t1187"),
                (& $L '2026-11-24 15:44:30' "`tCSI Payload Corruption:`t33"),
                (& $L '2026-11-24 15:44:30' ("`tCSI FileFlags Corrupt:`t{0}" -f $fd)),
                (& $L '2026-11-24 15:44:30' ("Total Repaired Corruption:`t{0}" -f (33 + $fr))),
                (& $L '2026-11-24 15:44:30' "`tCSI Payload Repaired:`t33"),
                (& $L '2026-11-24 15:44:30' ("`tCSI FileFlags Repaired:`t{0}" -f $fr)),
                (& $L '2026-11-24 15:44:30' 'Total Operation Time: 678 seconds.')) -join "`r`n" }
        $f = Get-CbsSummary ((& $mk 1154 1154) + "`r`n") $t0 'REPAIR'
        Assert-True ($null -ne $f -and $f.FilesDetected -eq 33 -and $f.FilesRepaired -eq 33 -and $f.Flags -eq 1154 -and $f.Remaining -eq 0) 'marques de fichiers non mises à part'
        $f = Get-CbsSummary ((& $mk 1154 1000) + "`r`n") $t0 'REPAIR'
        Assert-True ($null -ne $f -and $f.Flags -eq 0 -and $f.FilesDetected -eq 1187 -and $f.FilesRepaired -eq 1033 -and $f.Remaining -eq 154) 'marques en partie réparées mises à part'
        '9/9 cas'
    }
    Test-Case 'Heure du PC : écart avec Internet et réglage automatique' {
        # Mesure réelle du 24/11/2026 sur le PC de Thomas (www.msftconnecttest.com, 72 ms, PC en retard de 1,8 s)
        $b = [datetime]'2026-11-24 17:06:46.149'
        $a = $b.AddMilliseconds(72)
        $s0 = [datetime]'2026-11-24 17:06:48'
        $v = Get-ClockCheck $s0 $null $b $a
        Assert-True ($v.Status -eq 'OK' -and $v.Text -eq 'à l''heure (écart de 2 s)' -and $v.Offset -gt 2 -and $v.Offset -lt 3) ('mesure réelle : ' + $v.Text)
        $cases = @(
            @(372, 'WARN', 'en retard de 6 min 12 s'),
            @(-11100, 'WARN', 'en avance de 3 h 5 min'),
            @(-259200, 'WARN', 'en avance de 3 jours'),
            @(58, 'OK', 'à l''heure (écart de 58 s)'),
            @(61, 'WARN', 'en retard de 1 min 1 s'),
            @(0, 'OK', 'à l''heure'),
            @(59.6, 'WARN', 'en retard de 1 min'),
            @(3600, 'WARN', 'en retard de 1 h'),
            @(172800, 'WARN', 'en retard de 2 jours')
        )
        foreach ($c in $cases) {
            # Serveur décalé de $c[0] s par rapport au milieu de la mesure (moins la demi-seconde de l'en-tête Date)
            $v = Get-ClockCheck ($b.AddMilliseconds(36 - 500).AddSeconds($c[0])) $null $b $a
            Assert-True ($v.Status -eq $c[1] -and $v.Text -eq $c[2]) ('écart {0} s : {1} {2}' -f $c[0], $v.Status, $v.Text)
        }
        $v = Get-ClockCheck ($s0.AddSeconds(-30)) 30 $b $a
        Assert-True ($v.Status -eq 'OK') 'réponse en cache (en-tête Age) mal comptée'
        Assert-True ((Get-ClockCheck $null $null $b $a).Status -eq 'UNKNOWN') 'sans réponse : pas UNKNOWN'
        $v = Get-ClockCheck $s0 $null $b $b.AddSeconds(12)
        Assert-True ($v.Status -eq 'UNKNOWN' -and (Test-UnreadValue $v.Text)) 'réponse lente acceptée, ou absente de « Non vérifié »'
        Assert-True ((Get-ClockCheck $s0 $null $a $b).Status -eq 'UNKNOWN') 'heure du PC revenue en arrière acceptée'
        Assert-True ((Get-ClockCheck $s0 (-5) $b $a).Status -eq 'UNKNOWN') 'en-tête Age négatif accepté'
        Assert-True (Test-UnreadValue (Get-ClockCheck $null $null $b $a).Text) 'absence de réponse hors de « Non vérifié »'
        foreach ($p in @(@('NTP', 'AUTO'), @('nt5ds', 'AUTO'), @('AllSync', 'AUTO'), @('NoSync', 'OFF'), @($null, 'UNKNOWN'), @('', 'UNKNOWN'), @('Autre', 'UNKNOWN'))) {
            Assert-True ((Get-TimeSyncMode $p[0]) -eq $p[1]) ('réglage « {0} » mal lu' -f $p[0])
        }
        # Écart trop grand pour le service Heure Windows (limites relevées sur le PC de Thomas : 54 000 s)
        $mf = @(
            @(372, 54000, 54000, $false), @(54001, 54000, 54000, $true), @(-54001, 54000, 54000, $true),
            @(-60000, 54000, 172800, $false), @(60000, $null, $null, $true), @(9999999, -1, -1, $false),
            @($null, 54000, 54000, $false)
        )
        foreach ($m in $mf) {
            Assert-True ((Test-ClockManualFix $m[0] $m[1] $m[2]) -eq $m[3]) ('écart {0} s, limites {1}/{2} : mal jugé' -f $m[0], $m[1], $m[2])
        }
        '30/30 cas'
    }
    Test-Case 'Windows : fin des correctifs selon la version et l''édition' {
        # Dates des pages Microsoft relues le 26/11/2026 ; jugé ce jour-là
        $now = [datetime]'2026-11-26'
        $n = 0
        $cases = @(
            @(26300, 'Professional', 'OK', 'OK', '10/10/2028'),
            @('26300', 'CoreSingleLanguage', 'OK', 'OK', '10/10/2028'),
            @(26200, 'Core', 'OK', 'OK', '12/10/2027'),
            @(28000, 'Core', 'OK', 'OK', '14/03/2028'),
            @(26100, 'Core', 'WARN', 'ENDED', '13/10/2026'),
            @(26100, 'Professional', 'WARN', 'ENDED', '13/10/2026'),
            @(26100, 'Enterprise', 'OK', 'OK', '12/10/2027'),
            @(22631, 'ProfessionalWorkstation', 'WARN', 'ENDED', '11/11/2025'),
            @(22631, 'Education', 'WARN', 'ENDED', '10/11/2026'),
            @(22621, 'Enterprise', 'WARN', 'ENDED', '14/10/2025'),
            @(22000, 'Core', 'WARN', 'ENDED', '10/10/2023'),
            @(19045, 'Professional', 'WARN', 'ENDED', '14/10/2025')
        )
        foreach ($c in $cases) {
            $v = Get-WindowsSupportVerdict $c[0] $c[1] $now
            Assert-True ($v.State -eq $c[2] -and $v.Kind -eq $c[3] -and $v.Text -like ('*' + $c[4] + '*')) ('build {0} {1} : {2} {3} « {4} »' -f $c[0], $c[1], $v.State, $v.Kind, $v.Text)
            # Règle 14 : un avertissement a son geste juste dessous
            if ($v.State -eq 'WARN') { Assert-True (@($v.Subs).Count -gt 0) ('build {0} : avertissement sans geste' -f $c[0]) }
            Assert-True ($v.IsWin10 -eq ($c[0] -eq 19045)) ('build {0} : Windows 10 mal reconnu' -f $c[0])
            $n++
        }
        # Windows 10 : le programme ESU est cité tant qu'il court, plus après
        $v = Get-WindowsSupportVerdict 19045 'Core' $now
        Assert-True ((@($v.Subs) -join ' ') -like '*12/10/2027*') 'Windows 10 : date de fin du programme ESU absente'; $n++
        $v = Get-WindowsSupportVerdict 19045 'Core' ([datetime]'2027-10-13')
        Assert-True ($v.State -eq 'WARN' -and (@($v.Subs) -join ' ') -notlike '*12/10/2027*') 'Windows 10 : programme ESU encore conseillé après sa fin'; $n++
        $v = Get-WindowsSupportVerdict 19044 'Core' $now
        Assert-True ($v.State -eq 'WARN' -and $v.IsWin10 -and (@($v.Subs) -join ' ') -like '*22H2*') 'ancienne version de Windows 10 : pas de renvoi vers la 22H2'; $n++
        # Inconnu = « non vérifiable », jamais un avertissement ni un OK (règle 15)
        $unk = @(@(27000, 'Professional'), @(26300, 'EnterpriseS'), @(19044, 'EnterpriseS'), @(20348, 'ServerDatacenter'),
                 @(26100, 'ServerStandard'), @($null, 'Core'), @('abc', 'Core'), @(9600, 'Core'), @(26300, $null), @(26300, ''), @(26300, 'Autre'))
        foreach ($c in $unk) {
            $v = Get-WindowsSupportVerdict $c[0] $c[1] $now
            Assert-True ($v.State -eq 'INFO' -and $v.Kind -eq 'UNKNOWN' -and -not $v.IsWin10 -and (Test-UnreadValue $v.Text)) ('build « {0} » édition « {1} » : {2} « {3} »' -f $c[0], $c[1], $v.State, $v.Text)
            $n++
        }
        # Le dernier jour de service compte encore ; le lendemain, c'est terminé
        $v = Get-WindowsSupportVerdict 26100 'Core' ([datetime]'2026-10-13 23:00')
        Assert-True ($v.Kind -eq 'SOON' -and $v.State -eq 'INFO') ('dernier jour de 24H2 : ' + $v.Kind); $n++
        $v = Get-WindowsSupportVerdict 26100 'Core' ([datetime]'2026-10-14 00:30')
        Assert-True ($v.Kind -eq 'ENDED') ('lendemain de la fin de 24H2 : ' + $v.Kind); $n++
        # Fin proche : information, qui ne part pas sous « Non vérifié »
        $v = Get-WindowsSupportVerdict 26200 'Core' ([datetime]'2027-08-01')
        Assert-True ($v.Kind -eq 'SOON' -and $v.Text -like '*encore 72 j*' -and -not (Test-UnreadValue $v.Text)) ('25H2 au 01/08/2027 : ' + $v.Text); $n++
        $v = Get-WindowsSupportVerdict 26200 'Core' ([datetime]'2027-07-13')
        Assert-True ($v.Kind -eq 'OK') ('25H2 à 91 jours de sa fin : ' + $v.Kind); $n++
        # Table de plus d'un an : plus de OK donné de mémoire, mais une fin déjà passée reste une fin
        $v = Get-WindowsSupportVerdict 26300 'Professional' ([datetime]'2027-11-20')
        Assert-True ($v.Kind -eq 'UNKNOWN' -and $v.State -eq 'INFO' -and (Test-UnreadValue $v.Text)) ('table périmée : ' + $v.Text); $n++
        $v = Get-WindowsSupportVerdict 26100 'Core' ([datetime]'2028-03-01')
        Assert-True ($v.Kind -eq 'ENDED') 'table périmée : fin de 24H2 oubliée'; $n++
        foreach ($p in @(@('Core', 'HOME'), @('CoreN', 'HOME'), @('Professional', 'HOME'), @('ProfessionalEducation', 'HOME'),
                         @('Enterprise', 'ENT'), @('Education', 'ENT'), @('IoTEnterprise', 'ENT'), @('EnterpriseS', 'OTHER'),
                         @('IoTEnterpriseS', 'OTHER'), @('ServerDatacenter', 'OTHER'), @(' professional ', 'HOME'), @($null, 'OTHER'))) {
            Assert-True ((Get-WindowsEditionFamily $p[0]) -eq $p[1]) ('édition « {0} » mal classée' -f $p[0])
            $n++
        }
        ('{0}/{0} cas' -f $n)
    }
    Test-Case 'Windows 10 : obstacles au passage à Windows 11' {
        $n = 0
        $v = Get-Win11ReadinessVerdict $true '2.0, 0, 1.59' $true 16GB 475GB $true
        Assert-True ($v.Kind -eq 'CLEAR' -and $v.State -eq 'INFO' -and $v.Text -like '*processeur non contrôlé*' -and -not (Test-UnreadValue $v.Text)) ('PC conforme : ' + $v.Text); $n++
        # 4 Go installés = 3,9 Go annoncés ; disque de 64 Go = volume système d'environ 57 Go
        $v = Get-Win11ReadinessVerdict $true '2.0' $true (3.9GB) (57GB) $true
        Assert-True ($v.Kind -eq 'CLEAR') ('4 Go et 64 Go réels refusés : ' + (@($v.Subs) -join ' | ')); $n++
        $cases = @(
            @($false, $null, $true, 16GB, 475GB, $true, 'TPM'),
            @($true, '1.2, 2, 3', $true, 16GB, 475GB, $true, '1.2'),
            @($true, '2.0', $false, 16GB, 475GB, $true, 'Secure Boot'),
            @($true, '2.0', $true, 2GB, 475GB, $true, 'mémoire de 2 Go'),
            @($true, '2.0', $true, 16GB, 30GB, $true, 'disque système de 30 Go'),
            @($true, '2.0', $true, 16GB, 475GB, $false, '32 bits')
        )
        foreach ($c in $cases) {
            $v = Get-Win11ReadinessVerdict $c[0] $c[1] $c[2] $c[3] $c[4] $c[5]
            Assert-True ($v.Kind -eq 'BLOCKED' -and $v.State -eq 'INFO' -and $v.Text -eq '1 obstacle(s) vu(s)' -and (@($v.Subs) -join ' ') -like ('*' + $c[6] + '*')) ('obstacle « {0} » : {1} / {2}' -f $c[6], $v.Text, (@($v.Subs) -join ' | '))
            $n++
        }
        $v = Get-Win11ReadinessVerdict $false $null $false 2GB 30GB $true
        Assert-True ($v.Text -eq '4 obstacle(s) vu(s)' -and @($v.Subs).Count -eq 5) ('quatre obstacles : ' + $v.Text); $n++
        # Une lecture manquante ne vaut jamais « aucun obstacle » ; un obstacle vu reste dit
        $v = Get-Win11ReadinessVerdict $null $null $null 16GB 475GB $true
        Assert-True ($v.Kind -eq 'PARTIAL' -and (Test-UnreadValue $v.Text) -and $v.Text -like '*puce TPM*' -and $v.Text -like '*Secure Boot*') ('lectures manquantes : ' + $v.Text); $n++
        $v = Get-Win11ReadinessVerdict $true $null $true 16GB 475GB $true
        Assert-True ($v.Kind -eq 'PARTIAL' -and $v.Text -like '*version de la puce TPM*') ('version de TPM non lue : ' + $v.Text); $n++
        $v = Get-Win11ReadinessVerdict $null $null $null $null $null $null
        Assert-True ($v.Kind -eq 'PARTIAL') ('rien de lu : ' + $v.Kind); $n++
        $v = Get-Win11ReadinessVerdict $null $null $true 2GB 475GB $true
        Assert-True ($v.Kind -eq 'BLOCKED') ('obstacle et lecture manquante : ' + $v.Kind); $n++
        ('{0}/{0} cas' -f $n)
    }
    Test-Case 'Réglages de Windows : certificats Secure Boot, applications indésirables, Assistant de stockage' {
        $n = 0
        # Relevé du 26/11/2026 sur le PC de Thomas : Status = « Updated », valeur d'erreur absente
        $v = Get-SecureBootCertVerdict $true $true 'Updated' $null
        Assert-True ($v.State -eq 'OK') ('relevé réel : ' + $v.Text); $n++
        $cases = @(
            @($true, $true, ' updated ', 0, 'OK', $false),
            @($true, $true, 'Updated', 5, 'OK', $false),
            @($true, $true, 'InProgress', 0, 'INFO', $false),
            @($true, $true, 'InProgress', $null, 'INFO', $false),
            @($true, $true, 'NotStarted', 0, 'WARN', $false),
            @($true, $true, 'NotStarted', $null, 'WARN', $false),
            @($true, $true, 'InProgress', -2147024891, 'WARN', $false),
            @($true, $true, $null, $null, 'INFO', $true),
            @($true, $true, '', 0, 'INFO', $true),
            @($true, $false, 'Updated', 0, 'INFO', $true),
            @($true, $true, 'Autre', 0, 'INFO', $true)
        )
        foreach ($c in $cases) {
            $v = Get-SecureBootCertVerdict $c[0] $c[1] $c[2] $c[3]
            Assert-True ($null -ne $v -and $v.State -eq $c[4] -and (Test-UnreadValue $v.Text) -eq $c[5]) ('état « {0} » erreur « {1} » : {2} « {3} »' -f $c[2], $c[3], $v.State, $v.Text)
            if ($v.State -eq 'WARN') { Assert-True (@($v.Subs).Count -gt 0) ('état « {0} » : avertissement sans geste' -f $c[2]) }
            $n++
        }
        $v = Get-SecureBootCertVerdict $true $true 'InProgress' (-2147024891)
        Assert-True ($v.Text -like '*0x80070005*') ('code d''erreur mal écrit : ' + $v.Text); $n++
        # Secure Boot coupé ou non lu : aucune ligne
        foreach ($sb in @($false, $null, 'True', 1)) {
            Assert-True ($null -eq (Get-SecureBootCertVerdict $sb $true 'NotStarted' 0)) ('Secure Boot « {0} » : ligne affichée' -f $sb)
            $n++
        }
        foreach ($p in @(@(1, 'ON'), @(0, 'OFF'), @(2, 'AUDIT'), @('1', 'ON'), @([byte]1, 'ON'), @($null, 'UNKNOWN'), @(7, 'UNKNOWN'), @('x', 'UNKNOWN'))) {
            Assert-True ((Get-PuaVerdict $p[0]) -eq $p[1]) ('applications indésirables « {0} » mal lu' -f $p[0])
            $n++
        }
        # Assistant de stockage : la stratégie l'emporte ; jamais réglé = éteint (DEFAULT), valeur illisible = UNKNOWN
        foreach ($p in @(@($null, 1, 'ON'), @($null, 0, 'OFF'), @($null, $null, 'DEFAULT'), @(0, 1, 'OFF'), @(1, 0, 'ON'),
                         @(1, $null, 'ON'), @($null, 'x', 'UNKNOWN'), @($null, '1', 'ON'))) {
            Assert-True ((Get-StorageSenseVerdict $p[0] $p[1]) -eq $p[2]) ('Assistant de stockage, stratégie « {0} » compte « {1} » : mal lu' -f $p[0], $p[1])
            $n++
        }
        ('{0}/{0} cas' -f $n)
    }
    Test-Case 'Premier plan : structure FLASHWINFO (32 et 64 bits)' {
        Assert-True (Initialize-NativeFocus) 'fonctions de Windows non chargées'
        $size = [Runtime.InteropServices.Marshal]::SizeOf([type]'JarvisNative.Focus+FLASHWINFO')
        $want = 20
        if ([IntPtr]::Size -eq 8) { $want = 32 }
        Assert-True ($size -eq $want) ('taille {0} au lieu de {1}' -f $size, $want)
        '{0} octets ({1} bits)' -f $size, ([IntPtr]::Size * 8)
    }
    Test-Case 'SFC : fichiers remis lus dans CBS.log' {
        # Lignes réelles de PC-LV le 21/11/2026 (SFC lancé vers 17 h 02), espaces d'origine
        $pre = 'Info                  CSI    '
        $lnk = '\??\C:\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\\OneDrive.lnk'
        $rows = @(
            ('2026-11-21 17:05:29, ' + $pre + '00000241 [SR] Repairing file ' + $lnk + ' from store'),
            ('2026-11-21 17:05:57, ' + $pre + '000002a0 [SR] Repairing file ' + $lnk + ' from store'),
            ('2026-11-21 17:05:57, ' + $pre + '000002a2 [SR] Repair complete')
        )
        $t0 = [datetime]'2026-11-21 17:02:00'
        $crlf = ($rows -join "`r`n") + "`r`n"
        $r = Get-SfcRepairSummary $crlf $t0
        Assert-True ($r.OnlyOneDrive -and @($r.Files).Count -eq 1) 'raccourci OneDrive seul non reconnu (CRLF)'
        Assert-True (@($r.Files)[0] -eq 'C:\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\OneDrive.lnk') 'chemin mal nettoyé'
        $r = Get-SfcRepairSummary ($rows -join "`n") $t0
        Assert-True ($r.OnlyOneDrive) 'raccourci OneDrive seul non reconnu (LF)'
        $dll = '2026-11-21 17:06:10, ' + $pre + '000002b0 [SR] Repairing file \??\C:\Windows\System32\\exemple.dll from store'
        $r = Get-SfcRepairSummary ($crlf + $dll + "`r`n") $t0
        Assert-True (-not $r.OnlyOneDrive -and @($r.Files).Count -eq 2) 'autre fichier réparé caché derrière OneDrive'
        $r = Get-SfcRepairSummary $crlf ([datetime]'2026-11-21 17:10:00')
        Assert-True (-not $r.OnlyOneDrive -and @($r.Files).Count -eq 0) 'réparation antérieure au lancement prise en compte'
        $r = Get-SfcRepairSummary '' $t0
        Assert-True (-not $r.OnlyOneDrive -and @($r.Files).Count -eq 0) 'journal illisible pris pour une fausse alerte'
        $other = '2026-11-21 17:05:29, ' + $pre + '00000241 [SR] Repairing file \??\C:\Users\Utilisateur\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\\OneDrive.lnk from store'
        Assert-True (-not (Get-SfcRepairSummary $other $t0).OnlyOneDrive) 'raccourci OneDrive d''un vrai compte pris pour celui du modèle'
        '7/7 cas'
    }
    Test-Case 'DISM : réparation déjà tentée' {
        $now = [datetime]'2026-11-21'
        $cases = @(
            @('2026-11-20|PARTIAL|44', 44, 'SAME'),
            @('2026-11-20|PARTIAL|44', 30, 'SAME'),
            @('2026-11-20|PARTIAL|44', 120, $null),
            @('2026-11-20|PARTIAL|44', $null, 'FAILED'),
            @('2026-11-20|NOSOURCE|', 10, 'FAILED'),
            @('2026-11-20|REPAIRED|0', 5, $null),
            @('2026-11-20|FAILED|', 5, $null),
            @('2026-06-01|PARTIAL|44', 44, $null),
            @('2026-12-01|PARTIAL|44', 44, $null),
            @('pas une date', 1, $null),
            @('', 1, $null)
        )
        foreach ($c in $cases) {
            $got = Get-RepairRetryAdvice $c[0] $now $c[1]
            Assert-True ($got -eq $c[2]) ("« {0} », {1} défauts -> {2}, attendu {3}" -f $c[0], $c[1], $got, $c[2])
        }
        '{0}/{0} cas' -f $cases.Count
    }
    Test-Case 'Windows Update : signatures Defender reconnues' {
        $mk = { param($t, $cat, $kb) [pscustomobject]@{ Title = $t; Categories = @($cat | ForEach-Object { [pscustomobject]@{ CategoryID = $_ } }); KBs = @($kb) } }
        $fr = 'Mise à jour de la sélection disjointe pour Microsoft Defender Antivirus - 2267602 Ko (version 1.463.399.0) - Canal actuel (large)'
        Assert-True (Test-WuDefinitionUpdate (& $mk $fr @() @())) 'titre français (Ko) non reconnu'
        Assert-True (Test-WuDefinitionUpdate (& $mk 'Security Intelligence Update' @('E0789628-CE08-4437-BE74-2495B842F43B') @())) 'catégorie non reconnue'
        Assert-True (Test-WuDefinitionUpdate (& $mk 'Mise à jour' @() @('2267602'))) 'numéro KB non reconnu'
        Assert-True (-not (Test-WuDefinitionUpdate (& $mk '2026-11 Mise à jour cumulative (KB5070773)' @('0fa1201d-4330-4fa8-8ae9-b877473b6441') @('5070773')))) 'mise à jour cumulative prise pour une signature'
        Assert-True (-not (Test-WuDefinitionUpdate (& $mk 'Pilote 22676021' @() @()))) 'numéro voisin pris pour une signature'
        Assert-True (-not (Test-WuDefinitionUpdate ([pscustomobject]@{ Title = 'Sans catégories' }))) 'objet incomplet'
        Assert-True (-not (Test-WuDefinitionUpdate $null)) 'valeur nulle'
        '7/7 cas'
    }
    Test-Case 'Affichage : tirets longs remplacés' {
        $got = ConvertTo-DisplayText ('Antivirus ' + [char]0x2013 + ' KB2267602 ' + [char]0x2014 + ' 1 ' + [char]0x2212 + ' 2' + [char]7)
        Assert-True ($got -eq 'Antivirus - KB2267602 - 1 - 2') ('obtenu : ' + $got)
        Assert-True ((ConvertTo-DisplayText 'Défaut ok') -eq 'Défaut ok') 'texte ordinaire modifié'
        Assert-True ((ConvertTo-DisplayText $null) -eq '') 'valeur nulle'
        '3/3 cas'
    }
    Test-Case 'Affichage : caractères de contrôle retirés' {
        $esc = [string][char]27
        $got = Remove-ControlChars ('Mise' + $esc + '[2J à jour' + [char]7 + [char]0x9B + "`r`n")
        Assert-True ($got -eq 'Mise[2J à jour') ('obtenu : ' + $got)
        Assert-True ((Remove-ControlChars $null) -eq '') 'valeur nulle'
        '2/2 cas'
    }
    Test-Case 'Réponses oui/non : lecture stricte' {
        foreach ($y in @('o', 'O', 'oui', 'OUI', 'y', 'yes', ' o ', "oui`r`n")) {
            Assert-True ((Get-YesNo $y $false) -eq 'YES') ('non lu comme oui : ' + $y.Trim())
        }
        foreach ($n in @('n', 'N', 'non', 'no', ' NON ', "n`r`n")) {
            Assert-True ((Get-YesNo $n $true) -eq 'NO') ('non lu comme non : ' + $n.Trim())
        }
        Assert-True ((Get-YesNo $null $true) -eq 'NO') 'annulation acceptée comme oui'
        Assert-True ((Get-YesNo '' $true) -eq 'YES') 'Entrée : réponse par défaut « oui » non appliquée'
        Assert-True ((Get-YesNo '' $false) -eq 'NO') 'Entrée : réponse par défaut « non » non appliquée'
        # « peut-être » : repris du test T5 « Réponses annulées = non », retiré en v3.25 (il ne faisait que répéter ce test)
        foreach ($u in @('ok', 'ouais', 'x', '1', 'on', 'nope', 'oo', 'o n', 'peut-être')) {
            Assert-True ((Get-YesNo $u $true) -eq 'UNKNOWN') ('réponse floue acceptée : ' + $u)
            Assert-True ((Get-YesNo $u $false) -eq 'UNKNOWN') ('réponse floue acceptée : ' + $u)
        }
        '35/35 cas'
    }
    Test-Case 'Menus : seules les touches affichées' {
        $keys = @('1', '2', 'U', 'R')
        Assert-True ((Get-MenuChoice '2' $keys '1') -eq '2') 'touche affichée refusée'
        Assert-True ((Get-MenuChoice ' u ' $keys '1') -eq 'U') 'minuscule ou espaces refusés'
        Assert-True ((Get-MenuChoice "r`r`n" $keys '1') -eq 'R') 'fin de ligne Windows non retirée'
        Assert-True ((Get-MenuChoice '' $keys '1') -eq '1') 'Entrée : choix par défaut non appliqué'
        Assert-True ((Get-MenuChoice '' $keys '') -eq '') 'Entrée acceptée alors qu''aucun choix par défaut n''existe'
        Assert-True ($null -eq (Get-MenuChoice $null $keys '1')) 'annulation non transmise'
        foreach ($bad in @('3', 'M', '12', 'oui', '?')) {
            Assert-True ((Get-MenuChoice $bad $keys '1') -eq '') ('touche non affichée acceptée : ' + $bad)
        }
        '11/11 cas'
    }
    Test-Case 'Journaux : « aucun événement » ou lecture en échec' {
        Assert-True (Test-NoEventError 'NoMatchingEventsFound,Microsoft.PowerShell.Commands.GetWinEventCommand') 'aucun événement pris pour un échec'
        Assert-True (-not (Test-NoEventError 'NoMatchingLogsFound,Microsoft.PowerShell.Commands.GetWinEventCommand')) 'journal absent pris pour « aucun événement »'
        Assert-True (-not (Test-NoEventError 'NoMatchingProvidersFound,Microsoft.PowerShell.Commands.GetWinEventCommand')) 'fournisseur absent pris pour « aucun événement »'
        Assert-True (-not (Test-NoEventError '')) 'erreur inconnue prise pour « aucun événement »'
        '4/4 cas'
    }
    Test-Case 'Journaux : erreurs d''un appareil débranché' {
        # PC de Thomas, 21/11/2026 : erreur disk 11 sur la clé Kingston (bus 7 = USB), retirée depuis ; seul le
        # disque 0 est branché. Arrivées relevées dans son journal Partition/Diagnostic (texte « NULL » compris).
        $t0 = [datetime]'2026-11-21T13:54:18'
        $arr = @(
            [pscustomobject]@{ Time = $t0.AddDays(-2); DiskNumber = 1; BusType = '7'; Manufacturer = 'Linux'; Model = 'File-Stor Gadget'; Serial = 'NULL' },
            [pscustomobject]@{ Time = $t0.AddMinutes(-20); DiskNumber = 1; BusType = '7'; Manufacturer = 'Kingston'; Model = 'DataTraveler 3.0'; Serial = '4B0F8AD05FC9' },
            [pscustomobject]@{ Time = $t0.AddMinutes(50); DiskNumber = 1; BusType = '7'; Manufacturer = 'Kingston'; Model = 'DataTraveler 3.0'; Serial = '4B0F8AD05FC9' },
            [pscustomobject]@{ Time = $t0.AddHours(-5); DiskNumber = 0; BusType = '17'; Manufacturer = 'NULL'; Model = 'Samsung SSD 990 PRO 1TB'; Serial = '0025_3845_3141_E9FB.' })
        $now = @([pscustomobject]@{ Number = 0; Serial = '0025_3845_3141_E9FB.' })
        $ev = [pscustomobject]@{ Provider = 'disk'; Time = $t0; Device = "\Device\Harddisk1\DR5`r`n" }
        $v = Get-DiskErrorVerdict @($ev) $arr $now
        Assert-True ($v.Alert -eq 0 -and $v.Unplugged -eq 1) 'clé USB débranchée comptée en alerte'
        $d1 = @($v.Devices)
        Assert-True ($d1.Count -eq 1 -and $d1[0].Name -eq 'Kingston DataTraveler 3.0' -and $d1[0].Kind -eq 'UNPLUGGED' -and $d1[0].What -like 'cl*USB*') 'clé débranchée mal nommée'
        # Même clé encore branchée sous un autre numéro, ou autre disque branché au même numéro : alerte gardée
        $now2 = @($now) + @([pscustomobject]@{ Number = 2; Serial = '4B0F8AD05FC9' })
        $v2 = Get-DiskErrorVerdict @($ev) $arr $now2
        Assert-True ($v2.Alert -eq 1 -and @($v2.Devices)[0].Kind -eq 'REMOVABLE') 'clé encore branchée sortie de l''alerte'
        $now3 = @($now) + @([pscustomobject]@{ Number = 1; Serial = 'AUTRE' })
        Assert-True ((Get-DiskErrorVerdict @($ev) $arr $now3).Alert -eq 1) 'numéro repris par un autre disque : alerte perdue'
        # Disque interne disparu (en panne) : alerte gardée, modèle sans le fabricant « NULL »
        $ev0 = [pscustomobject]@{ Provider = 'disk'; Time = $t0; Device = '\Device\Harddisk0\DR0' }
        $v0 = Get-DiskErrorVerdict @($ev0) $arr @()
        Assert-True ($v0.Alert -eq 1 -and @($v0.Devices)[0].Kind -eq 'FIXED' -and @($v0.Devices)[0].Name -eq 'Samsung SSD 990 PRO 1TB') 'disque interne disparu sorti de l''alerte'
        # Lectures impossibles ou appareil inconnu : alerte gardée
        Assert-True ((Get-DiskErrorVerdict @($ev) $null $now).Alert -eq 1) 'journal des disques illisible : alerte perdue'
        Assert-True ((Get-DiskErrorVerdict @($ev) $arr $null).Alert -eq 1) 'disques branchés illisibles : alerte perdue'
        $evOld = [pscustomobject]@{ Provider = 'disk'; Time = $t0.AddDays(-3); Device = '\Device\Harddisk1\DR1' }
        Assert-True ((Get-DiskErrorVerdict @($evOld) $arr $now).Alert -eq 1) 'erreur antérieure à toute arrivée connue : alerte perdue'
        $ntfs = [pscustomobject]@{ Provider = 'Ntfs'; Time = $t0; Device = '\Device\HarddiskVolume12' }
        Assert-True ((Get-DiskErrorVerdict @($ntfs) $arr $now).Alert -eq 1) 'erreur NTFS sortie de l''alerte'
        $evNo = [pscustomobject]@{ Provider = 'disk'; Time = $t0; Device = '' }
        Assert-True ((Get-DiskErrorVerdict @($evNo) $arr $now).Alert -eq 1) 'erreur sans disque nommé sortie de l''alerte'
        # Appareil USB sans numéro de série (téléphone en mode stockage), puis la clé : deux appareils débranchés
        $evG = [pscustomobject]@{ Provider = 'disk'; Time = $t0.AddDays(-1); Device = '\Device\Harddisk1\DR3' }
        $vG = Get-DiskErrorVerdict @($evG, $ev, $ev) $arr $now
        Assert-True ($vG.Unplugged -eq 3 -and @($vG.Devices).Count -eq 2 -and @($vG.Devices | Where-Object { $_.Name -eq 'Kingston DataTraveler 3.0' })[0].Events -eq 2) 'appareils débranchés mal comptés'
        # Disque virtuel monté puis démonté (bus 15, relevé le 19/11/2026 sur le PC de Thomas)
        $arrV = @([pscustomobject]@{ Time = $t0.AddHours(-1); DiskNumber = 2; BusType = '15'; Manufacturer = 'Msft'; Model = 'Virtual Disk'; Serial = 'NULL' })
        $vV = Get-DiskErrorVerdict @([pscustomobject]@{ Provider = 'disk'; Time = $t0; Device = '\Device\Harddisk2\DR2' }) $arrV $now
        Assert-True ($vV.Unplugged -eq 1 -and @($vV.Devices)[0].What -like '*virtuel*' -and @($vV.Devices)[0].Name -eq 'Msft Virtual Disk') 'disque virtuel démonté mal lu'
        Assert-True ((Get-DiskErrorVerdict @() $arr $now).Alert -eq 0) 'aucune erreur mal lue'
        '13/13 cas'
    }
    Test-Case 'Windows Update : téléchargement et installation prouvés' {
        Assert-True ((Get-WuDownloadState 2 3 3) -eq 'READY') 'téléchargement complet non reconnu'
        Assert-True ((Get-WuDownloadState 3 3 2) -eq 'PARTIAL') 'téléchargement partiel non reconnu'
        Assert-True ((Get-WuDownloadState 2 3 2) -eq 'PARTIAL') 'mise à jour manquante non vue'
        Assert-True ((Get-WuDownloadState 4 3 0) -eq 'FAILED') 'échec non reconnu'
        Assert-True ((Get-WuDownloadState 2 3 0) -eq 'FAILED') 'code « réussi » accepté alors que rien n''est téléchargé'
        $s1 = Get-WuInstallSummary ([int[]]@(2, 2))
        Assert-True ($s1.State -eq 'OK' -and $s1.Ok -eq 2) 'installation réussie mal lue'
        $s2 = Get-WuInstallSummary ([int[]]@(2, 3))
        Assert-True ($s2.State -eq 'WARN' -and $s2.Warn -eq 1) 'avertissement compté comme réussite simple'
        $s3 = Get-WuInstallSummary ([int[]]@(2, 3, 4))
        Assert-True ($s3.State -eq 'FAIL' -and $s3.Fail -eq 1) 'échec mal lu'
        $s4 = Get-WuInstallSummary ([int[]]@())
        Assert-True ($s4.State -eq 'NONE') 'aucune installation prise pour une réussite'
        '9/9 cas'
    }
    Test-Case 'Préférences : lecture de config.json' {
        $c = ConvertFrom-JarvisConfigText "{`r`n  `"Name`": `"Camille`",`r`n  `"WingetModule`": `"never`"`r`n}`r`n"
        Assert-True ($c['Name'] -eq 'Camille' -and $c['WingetModule'] -eq 'never') 'valeurs simples mal lues (fins de ligne Windows)'
        Assert-True ((ConvertFrom-JarvisConfigText 'pas du JSON').Count -eq 0) 'texte illisible accepté'
        Assert-True ((ConvertFrom-JarvisConfigText '').Count -eq 0) 'fichier vide accepté'
        Assert-True ((ConvertFrom-JarvisConfigText '[1,2]').Count -eq 0) 'tableau accepté'
        Assert-True ((ConvertFrom-JarvisConfigText '"texte"').Count -eq 0) 'texte seul accepté'
        $d = ConvertFrom-JarvisConfigText ('{"Name":{"a":1},"Liste":[1,2],"Long":"' + ('x' * 201) + '","Ok":true,"N":3}')
        Assert-True (-not $d.ContainsKey('Name') -and -not $d.ContainsKey('Liste') -and -not $d.ContainsKey('Long')) 'valeur complexe ou trop longue gardée'
        Assert-True ($d['Ok'] -eq $true -and $d['N'] -eq 3) 'booléen ou nombre perdu'
        '7/7 cas'
    }

    Test-Case 'Antivirus : décodage productState' {
        $a = Get-AvState 266240; Assert-True ($a.On -and $a.UpToDate) '266240 : attendu actif + à jour'
        $b = Get-AvState 262144; Assert-True (-not $b.On) '262144 : attendu inactif'
        $c = Get-AvState 397584; Assert-True ($c.On -and -not $c.UpToDate) '397584 : attendu actif + obsolète'
        # v3.23 (audit T10) : valeur absente ou illisible = lecture impossible, plus « inactif »
        Assert-True ($null -eq (Get-AvState $null)) 'valeur absente lue comme un état'
        Assert-True ($null -eq (Get-AvState '')) 'valeur vide lue comme un état'
        Assert-True ($null -eq (Get-AvState 'abc')) 'valeur non numérique lue comme un état'
        $d = Get-AvState '397568'; Assert-True ($d.On -and $d.UpToDate) '397568 (texte) : attendu actif + à jour'
        '7/7 cas'
    }
    Test-Case 'Pare-feu : Windows et autres logiciels' {
        # v3.26 (constats V14 et V16) : un pare-feu tiers actif au Centre de sécurité remplace celui de Windows
        $on = [pscustomobject]@{ Name = 'Norton'; On = $true }
        $off = [pscustomobject]@{ Name = 'Norton'; On = $false }
        $unk = [pscustomobject]@{ Name = 'Norton'; On = $null }
        $cases = @(
            @(@(), @(), 'OK', 'actif sur tous'),
            @(@(), $null, 'OK', 'actif sur tous'),
            @(@('privé', 'public'), @(), 'FAIL', 'désactivé : réseau privé, public'),
            @(@('public'), $null, 'FAIL', 'désactivé'),
            @(@('public'), @($on), 'OK', 'géré par Norton (celui de Windows'),
            @($null, @($on), 'OK', 'géré par Norton'),
            @(@('public'), @($off), 'FAIL', 'désactivé'),
            @(@('public'), @($unk), 'INFO', 'celui de Windows désactivé (réseau public), état de Norton illisible'),
            @(@('public'), @($off, [pscustomobject]@{ Name = 'Bitdefender'; On = $true }), 'OK', 'géré par Bitdefender'),
            @($null, @(), 'INFO', 'lecture impossible'),
            @($null, $null, 'INFO', 'lecture impossible')
        )
        foreach ($c in $cases) {
            $v = Get-FirewallVerdict $c[0] $c[1]
            Assert-True ($v.Level -eq $c[2] -and $v.Text.StartsWith($c[3])) ("{0} / « {1} », attendu {2} / « {3} »" -f $v.Level, $v.Text, $c[2], $c[3])
            if ($v.Level -eq 'FAIL' -or $v.Level -eq 'WARN') { Assert-True (@($v.Subs).Count -gt 0) ("{0} sans conseil" -f $v.Text) }
            if ($v.Level -eq 'INFO') { Assert-True (Test-UnreadValue $v.Text) ("« {0} » absent de « Non vérifié »" -f $v.Text) }
        }
        '{0}/{0} cas' -f $cases.Count
    }
    Test-Case 'Démarrage : programmes actifs et désactivés' {
        # v3.26 (constat V11) : octets relevés le 23/11/2026 (02 activé, 03 désactivé, 06 activé)
        $b = { param([int[]]$x) , ([byte[]]$x) }   # virgule : le tableau d'octets sort entier, pas octet par octet
        $states = @(
            @((& $b 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0), 'ON'), @((& $b 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0), 'OFF'),
            @((& $b 6, 0, 0, 0), 'ON'), @((& $b 7, 0, 0, 0), 'OFF'), @('ABSENT', 'ON'),
            @($null, 'UNKNOWN'), @('03', 'UNKNOWN'), @([byte[]]@(), 'UNKNOWN')
        )
        foreach ($s in $states) {
            $got = Get-StartupApprovedState $s[0]
            Assert-True ($got -eq $s[1]) ("état -> {0}, attendu {1}" -f $got, $s[1])
        }
        $entries = @(
            [pscustomobject]@{ Name = 'OneDrive'; Approved = (& $b 2, 0, 0, 0) },
            [pscustomobject]@{ Name = 'Steam'; Approved = (& $b 3, 0, 0, 0) },
            [pscustomobject]@{ Name = 'Docker Desktop'; Approved = (& $b 3, 0, 0, 0) },
            [pscustomobject]@{ Name = 'SecurityHealth'; Approved = (& $b 6, 0, 0, 0) },
            [pscustomobject]@{ Name = 'Handy'; Approved = 'ABSENT' },
            [pscustomobject]@{ Name = 'Bizarre'; Approved = 'texte' }
        )
        $n = Get-StartupCount $entries
        Assert-True ($n.On -eq 4 -and $n.Off -eq 2 -and $n.Unknown -eq 1) ("actifs {0}, désactivés {1}, illisibles {2}, attendu 4, 2, 1" -f $n.On, $n.Off, $n.Unknown)
        $z = Get-StartupCount @()
        Assert-True ($z.On -eq 0 -and $z.Off -eq 0) 'liste vide'
        '{0}/{0} cas' -f ($states.Count + 2)
    }
    Test-Case 'Synthèse : contrôles non vérifiés' {
        # Lignes INFO réelles du scan qui disent qu'une lecture a échoué, et lignes qui n'en sont pas
        $yes = @('lecture impossible', 'lecture du journal impossible', 'âge illisible', 'santé illisible', 'statut indisponible',
                 'non vérifiable (BIOS ancien ?)', 'résultat non reconnu', 'non lues : J.A.R.V.I.S. tourne sous un autre compte que le tien',
                 'non lu : J.A.R.V.I.S. tourne sous un autre compte que le tien', 'nécessite les droits admin',
                 'v1.2  (date du pilote illisible)', 'non lues (liste visible seulement en administrateur)')
        $no = @('aucun', 'non chiffré', 'désactivé (réglage d''origine de Windows)', '3 actif(s), dont 1 administrateur(s)',
                'en retrait, remplacé par Avast', 'Erreurs d''un appareil débranché', '', 'échec, faute d''accès Internet',
                '192.168.1.1 ne répond pas au ping (fréquent : Internet fonctionne)')
        foreach ($v in $yes) { Assert-True (Test-UnreadValue $v) ("« {0} » non repéré" -f $v) }
        foreach ($v in $no) { Assert-True (-not (Test-UnreadValue $v)) ("« {0} » pris pour une lecture impossible" -f $v) }
        Assert-True (-not (Test-UnreadValue $null)) 'valeur absente'
        '{0}/{0} cas' -f ($yes.Count + $no.Count + 1)
    }
    Test-Case 'Synthèse : état général' {
        $cases = @(
            @(0, 0, 0, 'GOOD', 'EN BON ÉTAT'),
            @(0, 0, 2, 'GOOD', 'RIEN D''ANORMAL VU'),     # jamais « en bon état » avec des points non lus
            @(3, 0, 0, 'WATCH', 'À SURVEILLER'),
            @(3, 0, 5, 'WATCH', 'À SURVEILLER'),
            @(0, 1, 0, 'ACT', 'À TRAITER'),
            @(12, 1, 4, 'ACT', 'À TRAITER')                # une alerte l'emporte, quel que soit le nombre de OK
        )
        foreach ($c in $cases) {
            $v = Get-ScanVerdict $c[0] $c[1] $c[2]
            Assert-True ($v.Level -eq $c[3] -and $v.Title -eq $c[4]) ('{0} WARN, {1} FAIL, {2} non lus -> {3} « {4} »' -f $c[0], $c[1], $c[2], $v.Level, $v.Title)
        }
        Assert-True ((Get-ScanVerdict 0 0 2).Line -match '2 point') 'nombre de points non vérifiés absent'
        '{0}/{0} cas' -f ($cases.Count + 1)
    }
    Test-Case 'Disques : santé et compteurs' {
        $cases = @(
            @('Healthy', 40, 3, 0, 'OK', ''),
            @('Healthy', $null, $null, $null, 'OK', ''),          # sans droits admin : compteurs non lus
            @('0', 40, 3, 0, 'OK', ''),                           # état rendu en nombre
            @('Unknown', $null, $null, $null, 'INFO', 'UNKNOWN'), # avant la v3.23 : alerte rouge
            @('', $null, $null, $null, 'INFO', 'UNKNOWN'),
            @('Warning', 40, 3, 0, 'WARN', 'HEALTH'),
            @('Unhealthy', 40, 3, 0, 'FAIL', 'HEALTH'),
            @('2', $null, $null, $null, 'FAIL', 'HEALTH'),
            @('Healthy', 40, 100, 0, 'FAIL', 'WORN'),            # avant la v3.23 : simple avertissement
            @('Healthy', 40, 85, 0, 'WARN', 'WEAR'),
            @('Healthy', 70, 3, 0, 'WARN', 'HOT'),
            @('Healthy', 40, 3, 2, 'FAIL', 'ERRORS'),
            @('Unknown', 40, 3, 2, 'FAIL', 'ERRORS'),             # santé illisible mais erreurs lues : l'alerte reste
            @('Unknown', 40, 90, 0, 'WARN', 'WEAR')
        )
        foreach ($c in $cases) {
            $v = Get-DiskHealthVerdict $c[0] $c[1] $c[2] $c[3]
            Assert-True ($v.State -eq $c[4] -and $v.Why -eq $c[5]) ('« {0} » / {1} °C / usure {2} / {3} erreurs -> {4} {5}, attendu {6} {7}' -f $c[0], $c[1], $c[2], $c[3], $v.State, $v.Why, $c[4], $c[5])
        }
        Assert-True ((Get-DiskHealthVerdict 'Healthy' $null $null $null).Text -eq 'santé : bonne') 'texte de santé'
        Assert-True ((Get-DiskHealthVerdict 'Unknown' $null $null $null).Text -eq 'santé illisible') 'texte de santé illisible'
        foreach ($w in 'HEALTH', 'ERRORS', 'WORN', 'WEAR', 'HOT') { Assert-True (@(Get-DiskAdvice $w).Count -gt 0) "aucun conseil pour $w" }
        Assert-True (@(Get-DiskAdvice '').Count -eq 0) 'conseil pour un disque sain'
        '{0}/{0} cas' -f ($cases.Count + 8)
    }
    Test-Case 'BitLocker : état du chiffrement' {
        $cases = @(
            @('On', 'FullyEncrypted', 'INFO', 'chiffré et protégé'),
            @('Off', 'FullyDecrypted', 'INFO', 'non chiffré'),
            @('Off', 'FullyEncrypted', 'WARN', 'chiffré, protection suspendue'),
            @('Off', 'EncryptionInProgress', 'INFO', 'chiffrement en cours'),   # avant la v3.23 : « protection suspendue »
            @('Off', 'DecryptionInProgress', 'INFO', 'déchiffrement en cours'),
            @('Unknown', 'FullyEncrypted', 'INFO', 'état illisible'),
            @('', '', 'INFO', 'état illisible')
        )
        foreach ($c in $cases) {
            $v = Get-BitLockerVerdict $c[0] $c[1]
            Assert-True ($v.State -eq $c[2] -and $v.Text -eq $c[3]) ('{0} / {1} -> {2} « {3} »' -f $c[0], $c[1], $v.State, $v.Text)
        }
        '{0}/{0} cas' -f $cases.Count
    }
    Test-Case 'Réseau : box, ping, TCP et DNS' {
        # Rend « Label=État » pour chaque ligne, dans l'ordre d'affichage
        $sum = { param($v) (@($v.Rows) | ForEach-Object { '{0}={1}' -f $_.Label, $_.State }) -join ' | ' }
        $box = 'Box ou routeur (passerelle)'; $rt = 'Temps de réponse Internet'; $ia = 'Accès Internet'; $dn = 'Noms de sites (DNS)'
        $cases = @(
            # PC de Thomas (rapport du 22/11/2026) : tout répond
            @('192.168.1.1', $true, 4, 15, $null, $true, "$box=OK | $rt=OK | $dn=OK", $true),
            # 1 ping perdu sur 4 : plus un avertissement
            @('192.168.1.1', $true, 3, 20, $null, $true, "$box=OK | $rt=OK | $dn=OK", $true),
            @('192.168.1.1', $true, 2, 20, $null, $true, "$box=OK | $rt=WARN | $dn=OK", $true),
            @('192.168.1.1', $true, 4, 150, $null, $true, "$box=OK | $rt=WARN | $dn=OK", $true),
            # Box muette au ping, Internet joignable : information, plus une alerte
            @('192.168.1.1', $false, 4, 15, $null, $true, "$box=INFO | $rt=OK | $dn=OK", $true),
            # Réseau qui bloque tout ping, connexion TCP réussie
            @('192.168.1.1', $false, 0, $null, $true, $true, "$box=INFO | $ia=OK | $dn=OK", $true),
            # Vraie panne : box et Internet muets, DNS en échec sans faute propre
            @('192.168.1.1', $false, 0, $null, $false, $false, "$box=FAIL | $ia=FAIL | $dn=INFO", $false),
            # Box joignable, Internet coupé chez le fournisseur
            @('192.168.1.1', $true, 0, $null, $false, $false, "$box=OK | $ia=FAIL | $dn=INFO", $false),
            # Aucun réseau (pas de passerelle)
            @('', $false, 0, $null, $false, $false, "$ia=FAIL | $dn=INFO", $false),
            # Internet joignable mais DNS en panne
            @('192.168.1.1', $true, 4, 15, $null, $false, "$box=OK | $rt=OK | $dn=FAIL", $true)
        )
        foreach ($c in $cases) {
            $v = Get-NetworkVerdict $c[0] $c[1] 4 $c[2] $c[3] $c[4] $c[5] 20
            $got = & $sum $v
            Assert-True ($got -eq $c[6] -and $v.Up -eq $c[7]) ('« {0} » attendu « {1} »' -f $got, $c[6])
            foreach ($r in @($v.Rows | Where-Object { $_.State -eq 'WARN' -or $_.State -eq 'FAIL' })) {
                Assert-True (@($r.Advice).Count -gt 0) ('{0} en {1} sans conseil' -f $r.Label, $r.State)
            }
        }
        $v = Get-NetworkVerdict '192.168.1.1' $true 4 3 20.4 $null $true 20
        Assert-True (@($v.Rows)[1].Text -eq '20 ms en moyenne  //  perte 25%') ('texte du temps de réponse : ' + @($v.Rows)[1].Text)
        '{0}/{0} cas' -f ($cases.Count + 1)
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
        $dg = 'sha256:' + ('AB' * 32)
        $ok = Get-JarvisReleaseInfo (& $mk 'v9.1' 'JARVIS.cmd' $base $dg) $JarvisRepo
        Assert-True ($ok.Ok -and $ok.Version -eq '9.1' -and $ok.Sha256 -eq ('ab' * 32) -and $ok.Size -eq 1234) ('version valide refusée : ' + $ok.Reason)
        Assert-True ((Get-JarvisReleaseInfo (& $mk '9.1' 'JARVIS.cmd' $base $dg) $JarvisRepo).Ok) 'numéro sans « v » refusé'
        $noDg = Get-JarvisReleaseInfo (& $mk 'v9.1' 'JARVIS.cmd' $base $null) $JarvisRepo
        Assert-True (-not $noDg.Ok -and $noDg.Reason -match 'empreinte') 'version publiée sans empreinte acceptée'
        Assert-True (-not (Get-JarvisReleaseInfo (& $mk 'latest' 'JARVIS.cmd' $base $dg) $JarvisRepo).Ok) 'numéro invalide accepté'
        Assert-True (-not (Get-JarvisReleaseInfo (& $mk 'v9.1' 'autre.exe' $base $dg) $JarvisRepo).Ok) 'fichier absent accepté'
        Assert-True (-not (Get-JarvisReleaseInfo (& $mk 'v9.1' 'JARVIS.cmd' 'https://exemple.com/JARVIS.cmd' $dg) $JarvisRepo).Ok) 'adresse étrangère acceptée'
        Assert-True (-not (Get-JarvisReleaseInfo (& $mk 'v9.1' 'JARVIS.cmd' $base 'md5:1234') $JarvisRepo).Ok) 'empreinte illisible acceptée'
        Assert-True (-not (Get-JarvisReleaseInfo 'pas du JSON' $JarvisRepo).Ok) 'réponse illisible acceptée'
        '8/8 cas'
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
        # Empreinte publiée conforme mais empreinte interne fausse : c'est le contrôle interne qui doit refuser
        $infoT = [pscustomobject]@{ Version = '9.1'; Size = [int64]$t.Length; Sha256 = (Get-Sha256Hex $t) }
        $whyT = [string](Test-JarvisPackage $t $infoT '3.11')
        Assert-True ($whyT -match 'interne') ('fichier modifié accepté, ou refusé pour une autre raison : ' + $whyT)
        $infoBad = [pscustomobject]@{ Version = '9.1'; Size = [int64]$b.Length; Sha256 = ('0' * 64) }
        Assert-True ($null -ne (Test-JarvisPackage $b $infoBad '3.11')) 'empreinte publiée différente acceptée'
        $infoNo = [pscustomobject]@{ Version = '9.1'; Size = [int64]$b.Length; Sha256 = $null }
        Assert-True ($null -ne (Test-JarvisPackage $b $infoNo '3.11')) 'fichier sans empreinte publiée accepté'
        $infoV = [pscustomobject]@{ Version = '9.2'; Size = [int64]$b.Length; Sha256 = (Get-Sha256Hex $b) }
        Assert-True ($null -ne (Test-JarvisPackage $b $infoV '3.11')) 'version différente de la version publiée acceptée'
        Assert-True ($null -ne (Test-JarvisPackage $b $info '9.1')) 'version identique acceptée'
        Assert-True ($null -ne (Test-JarvisPackage $b $info '10.0')) 'rétrogradation acceptée'
        Assert-True ($null -ne (Test-JarvisPackage $b $info 'illisible')) 'version installée illisible acceptée'
        $short = [byte[]]$b[0..($b.Length - 50)]
        $infoS = [pscustomobject]@{ Version = '9.1'; Size = 0; Sha256 = (Get-Sha256Hex $short) }
        Assert-True ($null -ne (Test-JarvisPackage $short $infoS '3.11')) 'fichier tronqué accepté'
        '10/10 cas'
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
    Test-Case 'Sécurité : nombre lu ou absent' {
        Assert-True ((ConvertTo-IntOrNull 0) -eq 0) '0 perdu'
        Assert-True ((ConvertTo-IntOrNull ' 5 ') -eq 5) 'texte numérique non lu'
        Assert-True ($null -eq (ConvertTo-IntOrNull $null)) 'valeur absente lue comme un nombre'
        Assert-True ($null -eq (ConvertTo-IntOrNull 'Off')) 'texte lu comme un nombre'
        Assert-True ($null -eq (ConvertTo-IntOrNull '')) 'texte vide lu comme 0'
        Assert-True ((Get-OnOffVerdict $true) -eq 'ON' -and (Get-OnOffVerdict $false) -eq 'OFF') 'booléen mal lu'
        Assert-True ((Get-OnOffVerdict 1) -eq 'ON' -and (Get-OnOffVerdict 0) -eq 'OFF') 'nombre mal lu'
        Assert-True ((Get-OnOffVerdict $null) -eq 'UNKNOWN') 'valeur absente lue comme un réglage'
        Assert-True ((Get-OnOffVerdict 'peut-être') -eq 'UNKNOWN') 'texte inattendu lu comme un réglage'
        '9/9 cas'
    }
    Test-Case 'Sécurité : contrôle de compte (UAC)' {
        Assert-True ((Get-UacVerdict 1 5) -eq 'ON') 'réglage d''origine mal lu'
        Assert-True ((Get-UacVerdict 1 2) -eq 'ON') 'curseur au maximum mal lu'
        Assert-True ((Get-UacVerdict 1 $null) -eq 'ON') 'niveau absent mal lu'
        Assert-True ((Get-UacVerdict 1 0) -eq 'NOPROMPT') 'curseur tout en bas non signalé'
        Assert-True ((Get-UacVerdict 0 5) -eq 'OFF') 'UAC désactivé non signalé'
        Assert-True ((Get-UacVerdict 0 0) -eq 'OFF') 'UAC désactivé non signalé (niveau 0)'
        Assert-True ((Get-UacVerdict $null 5) -eq 'UNKNOWN') 'lecture impossible prise pour « actif »'
        '7/7 cas'
    }
    Test-Case 'Sécurité : SmartScreen' {
        Assert-True ((Get-SmartScreenVerdict $null 'Warn') -eq 'ON') 'Warn mal lu'
        Assert-True ((Get-SmartScreenVerdict $null 'Block') -eq 'ON') 'Block mal lu'
        Assert-True ((Get-SmartScreenVerdict $null 'RequireAdmin') -eq 'ON') 'RequireAdmin mal lu'
        Assert-True ((Get-SmartScreenVerdict $null 'off') -eq 'OFF') 'Off non signalé'
        Assert-True ((Get-SmartScreenVerdict 0 'Warn') -eq 'OFF') 'stratégie de désactivation ignorée'
        Assert-True ((Get-SmartScreenVerdict 1 'Off') -eq 'ON') 'stratégie d''activation ignorée'
        Assert-True ((Get-SmartScreenVerdict $null $null) -eq 'DEFAULT') 'valeur absente prise pour « actif »'
        Assert-True ((Get-SmartScreenVerdict $null 'Autre') -eq 'UNKNOWN') 'valeur inconnue prise pour « actif »'
        '8/8 cas'
    }
    Test-Case 'Sécurité : accès contrôlé, RDP, mémoire' {
        Assert-True ((Get-CfaVerdict 0) -eq 'OFF' -and (Get-CfaVerdict 1) -eq 'ON') 'accès contrôlé : 0 ou 1 mal lu'
        Assert-True ((Get-CfaVerdict 2) -eq 'AUDIT' -and (Get-CfaVerdict 3) -eq 'DISKONLY') 'accès contrôlé : 2 ou 3 mal lu'
        Assert-True ((Get-CfaVerdict $null) -eq 'UNKNOWN' -and (Get-CfaVerdict 9) -eq 'UNKNOWN') 'accès contrôlé : inconnu pris pour un réglage'
        Assert-True ((Get-RdpVerdict $null 1) -eq 'OFF') 'Bureau à distance désactivé mal lu'
        Assert-True ((Get-RdpVerdict $null 0) -eq 'ON') 'Bureau à distance activé non signalé'
        Assert-True ((Get-RdpVerdict 0 1) -eq 'ON') 'stratégie d''activation ignorée'
        Assert-True ((Get-RdpVerdict 1 0) -eq 'OFF') 'stratégie de refus ignorée'
        Assert-True ((Get-RdpVerdict $null $null) -eq 'UNKNOWN') 'lecture impossible prise pour « désactivé »'
        Assert-True ((Get-HvciVerdict @(2, 7) 1 $true) -eq 'RUNNING') 'mémoire : en service mal lu'
        Assert-True ((Get-HvciVerdict @(1) 1 $true) -eq 'PENDING') 'mémoire : activée mais pas en service mal lu'
        Assert-True ((Get-HvciVerdict @() $null $true) -eq 'OFF') 'mémoire : désactivée mal lue'
        Assert-True ((Get-HvciVerdict $null 0 $false) -eq 'OFF') 'mémoire : réglage 0 mal lu'
        Assert-True ((Get-HvciVerdict @(2) $null $false) -eq 'UNKNOWN') 'mémoire : lecture en échec prise pour « active »'
        Assert-True ((Get-HvciVerdict $null $null $false) -eq 'UNKNOWN') 'mémoire : rien de lisible pris pour un réglage'
        '14/14 cas'
    }
    Test-Case 'Sécurité : comptes Windows' {
        $mk = { param($n, $sid, $on, $req, $set) [pscustomobject]@{ Name = $n; Sid = $sid; Enabled = $on; PasswordRequired = $req; PasswordSet = $set } }
        $dom = 'S-1-5-21-1111111111-2222222222-3333333333-'
        $sain = @(
            (& $mk 'Administrateur' ($dom + '500') $false $true $false),
            (& $mk 'Invité' ($dom + '501') $false $false $false),
            (& $mk 'Marie' ($dom + '1001') $true $true $true),
            (& $mk 'Ancien' ($dom + '1002') $false $false $true)
        )
        $f = Get-AccountFindings $sain
        Assert-True ($f.Active -eq 1) ("{0} compte(s) actif(s), attendu 1" -f $f.Active)
        Assert-True (-not $f.BuiltinAdmin) 'Administrateur intégré désactivé signalé'
        Assert-True ($f.NoPassword.Count -eq 0 -and $f.Optional.Count -eq 0) 'compte désactivé signalé'
        $risque = @(
            (& $mk 'Administrateur' ($dom + '500') $true $true $true),
            (& $mk 'Enfant' ($dom + '1003') $true $false $false),
            (& $mk 'Paul' ($dom + '1004') $true $false $true),
            (& $mk 'Chef' ($dom + '15001') $true $true $true)
        )
        $g = Get-AccountFindings $risque
        Assert-True ($g.Active -eq 4) ("{0} compte(s) actif(s), attendu 4" -f $g.Active)
        Assert-True $g.BuiltinAdmin 'Administrateur intégré actif non signalé'
        Assert-True ($g.NoPassword.Count -eq 1 -and $g.NoPassword[0] -eq 'Enfant') 'compte sans mot de passe non signalé'
        Assert-True ($g.Optional.Count -eq 1 -and $g.Optional[0] -eq 'Paul') 'mot de passe non obligatoire non signalé'
        $h = Get-AccountFindings $null
        Assert-True ($h.Active -eq 0 -and $h.NoPassword.Count -eq 0) 'liste absente mal lue'
        '8/8 cas'
    }
    Test-Case 'Sécurité : fichier hosts (CRLF et LF)' {
        $origine = "# Copyright (c) 1993-2009 Microsoft Corp.`r`n#`r`n# 102.54.94.97     rhino.acme.com          # source server`r`n" +
                   "#       127.0.0.1       localhost`r`n#       ::1             localhost`r`n"
        $h0 = Get-HostsFindings $origine
        Assert-True ($h0.Entries -eq 0 -and $h0.Sensitive.Count -eq 0) 'fichier d''origine de Windows lu comme modifié'
        $perso = $origine + "127.0.0.1 localhost`r`n::1 localhost`r`n192.168.1.20`tnas.maison nas   # mon NAS`r`n" +
                 "127.0.0.1 host.docker.internal`r`n0.0.0.0 pub.exemple.com`r`n"
        $h1 = Get-HostsFindings $perso
        Assert-True ($h1.Entries -eq 4) ("{0} redirection(s), attendu 4" -f $h1.Entries)
        Assert-True ($h1.Sensitive.Count -eq 0) 'redirection ordinaire signalée comme suspecte'
        $pirate = $perso + "127.0.0.1 update.microsoft.com www.Kaspersky.com`r`n0.0.0.0 download.windowsupdate.com.`r`n" +
                  "0.0.0.0 fauxmicrosoft.com`r`n127.0.0.1 update.microsoft.com`r`n# 0.0.0.0 www.avast.com`r`n"
        $h2 = Get-HostsFindings $pirate
        Assert-True ($h2.Sensitive.Count -eq 3) ("{0} site(s) sensible(s), attendu 3 : {1}" -f $h2.Sensitive.Count, ($h2.Sensitive -join ' '))
        Assert-True ($h2.Sensitive -contains 'www.kaspersky.com') 'antivirus détourné non signalé'
        Assert-True ($h2.Sensitive -contains 'download.windowsupdate.com') 'Windows Update détourné non signalé'
        Assert-True (-not ($h2.Sensitive -contains 'fauxmicrosoft.com')) 'nom ressemblant pris pour Microsoft'
        Assert-True (-not ($h2.Sensitive -contains 'www.avast.com')) 'ligne en commentaire prise en compte'
        # Même contenu avec des fins de ligne Unix : même résultat
        $h3 = Get-HostsFindings ($pirate -replace "`r`n", "`n")
        Assert-True ($h3.Entries -eq $h2.Entries -and $h3.Sensitive.Count -eq 3) 'résultat différent selon les fins de ligne'
        $h4 = Get-HostsFindings ''
        Assert-True ($h4.Entries -eq 0) 'fichier vide mal lu'
        Assert-True ((Get-HostsDirVerdict 'C:\WINDOWS\System32\drivers\etc' 'C:\Windows') -eq 'DEFAULT') 'dossier d''origine non reconnu'
        Assert-True ((Get-HostsDirVerdict '%SystemRoot%\System32\drivers\etc\' 'C:\Windows\') -eq 'DEFAULT') 'forme %SystemRoot% non reconnue'
        Assert-True ((Get-HostsDirVerdict 'C:\ProgramData\x\etc' 'C:\Windows') -eq 'MOVED') 'dossier déplacé non signalé'
        Assert-True ((Get-HostsDirVerdict '' 'C:\Windows') -eq 'UNKNOWN') 'valeur absente prise pour le dossier d''origine'
        Assert-True ((Get-HostsDirVerdict $null 'C:\Windows') -eq 'UNKNOWN') 'valeur illisible prise pour le dossier d''origine'
        '15/15 cas'
    }
    Test-Case 'Sécurité : proxy et activation de Windows' {
        Assert-True ((Get-ProxyVerdict 0 '' '').State -eq 'NONE') 'aucun proxy mal lu'
        Assert-True ((Get-ProxyVerdict $null $null $null).State -eq 'NONE') 'valeurs absentes mal lues'
        Assert-True ((Get-ProxyVerdict 0 'ancien:8080' '').State -eq 'NONE') 'proxy désactivé pris pour actif'
        $m = Get-ProxyVerdict 1 'http=jean:secret@10.0.0.1:3128;https=10.0.0.1:3128' ''
        Assert-True ($m.State -eq 'MANUAL') 'proxy actif non signalé'
        Assert-True ($m.Detail -eq 'http=10.0.0.1:3128;https=10.0.0.1:3128') ('identifiants conservés : ' + $m.Detail)
        $s = Get-ProxyVerdict 0 '' 'http://wpad.exemple/proxy.pac'
        Assert-True ($s.State -eq 'SCRIPT' -and $s.Detail -eq 'http://wpad.exemple/proxy.pac') 'script de configuration non signalé'
        Assert-True ((Get-ActivationVerdict @(1)) -eq 'ACTIVATED') 'Windows activé mal lu'
        Assert-True ((Get-ActivationVerdict @(0, 1)) -eq 'ACTIVATED') 'un produit activé parmi plusieurs mal lu'
        Assert-True ((Get-ActivationVerdict @(5)) -eq 'NOTACTIVATED') 'Windows non activé non signalé'
        Assert-True ((Get-ActivationVerdict @(0, 2)) -eq 'NOTACTIVATED') 'période de grâce prise pour « activé »'
        Assert-True ((Get-ActivationVerdict @()) -eq 'UNKNOWN') 'liste vide prise pour un résultat'
        Assert-True ((Get-ActivationVerdict $null) -eq 'UNKNOWN') 'lecture impossible prise pour un résultat'
        Assert-True (Test-SameAccount 'PC-SALON\Marie' 'marie') 'même compte non reconnu'
        Assert-True (-not (Test-SameAccount 'PC-SALON\Marie' 'AdminPapa')) 'élévation sous un autre compte non vue'
        Assert-True (Test-SameAccount '' 'Marie') 'session inconnue prise pour un autre compte'
        '15/15 cas'
    }
    Test-Case 'Defender : résultat de l''analyse rapide' {
        $t0 = [datetime]'2026-11-19T10:00:00'
        Assert-True ((Get-MpScanVerdict $true $t0 $t0.AddMinutes(3)) -eq 'DONE') 'analyse terminée non reconnue'
        Assert-True ((Get-MpScanVerdict $true $t0 $t0.AddHours(-4)) -eq 'UNVERIFIED') 'ancienne analyse prise pour la nouvelle'
        Assert-True ((Get-MpScanVerdict $true $t0 $null) -eq 'UNVERIFIED') 'aucune fin enregistrée prise pour un succès'
        Assert-True ((Get-MpScanVerdict $false $t0 $t0.AddMinutes(3)) -eq 'FAILED') 'erreur de lancement prise pour un succès'
        Assert-True ((Get-MpScanVerdict $null $t0 $t0.AddHours(-4) $true) -eq 'TIMEOUT') 'délai dépassé non signalé'
        Assert-True ((Get-MpScanVerdict $null $t0 $t0.AddHours(-4) $false) -eq 'UNVERIFIED') 'job interrompu pris pour un délai dépassé'
        Assert-True ((Get-MpScanVerdict $null $t0 $t0.AddMinutes(29) $true) -eq 'DONE') 'analyse finie pendant l''attente non reconnue'
        $mkd = { param($first, $last) [pscustomobject]@{ ThreatID = 1; InitialDetectionTime = $first; LastThreatStatusChangeTime = $last } }
        $det = @(
            (& $mkd $t0.AddDays(-30) $t0.AddDays(-30)),
            (& $mkd $t0.AddMinutes(2) $t0.AddMinutes(2)),
            (& $mkd $t0.AddDays(-5) $t0.AddMinutes(1)),
            (& $mkd $null $null)
        )
        Assert-True (@(Get-MpThreatsSince $det $t0).Count -eq 1) 'menaces de cette analyse mal comptées'
        Assert-True (@(Get-MpThreatsSince @($det[0]) $t0).Count -eq 0) 'ancienne menace comptée'
        Assert-True (@(Get-MpThreatsSince @($det[2]) $t0).Count -eq 0) 'ancienne menace au statut modifié comptée comme nouvelle'
        Assert-True (@(Get-MpThreatsSince @() $t0).Count -eq 0) 'liste vide mal lue'
        Assert-True ((Test-MpThreatHandled 3) -and (Test-MpThreatHandled 4) -and (Test-MpThreatHandled 2)) 'menace traitée non reconnue'
        Assert-True (-not (Test-MpThreatHandled 1) -and -not (Test-MpThreatHandled 102)) 'menace non traitée dite traitée'
        Assert-True (-not (Test-MpThreatHandled $null) -and -not (Test-MpThreatHandled 5)) 'statut absent ou « autorisée » dit traité'
        '14/14 cas'
    }
    Test-Case 'winget : application encore en service' {
        $ap2 = [string][char]0x2019
        $vrai = 'erreur 0x80073D02' + [char]0xA0 + ': impossible d' + $ap2 + "installer, car les applications suivantes doivent être fermées OpenAI.Codex_26.1111.2228.0_x64__2p2nqsd0c76g0.`r`n"
        Assert-True (Test-AppxInUseMessage $vrai) 'message réel de Windows non reconnu'
        Assert-True (Test-AppxInUseMessage 'Deployment failed with HRESULT: 0x80073d02, The package could not be installed because resources it modifies are currently in use.') 'message anglais non reconnu'
        Assert-True (-not (Test-AppxInUseMessage 'erreur 0x80073CF9 : échec de l''installation.')) 'autre erreur prise pour une application en service'
        Assert-True (-not (Test-AppxInUseMessage '')) 'texte vide pris pour une erreur'
        Assert-True (-not (Test-AppxInUseMessage $null)) 'texte absent pris pour une erreur'
        '5/5 cas'
    }
    Test-Case 'Fenêtre : agrandissement en hauteur' {
        # Windows Terminal d'origine sur un écran 1440 : 30 lignes, fenêtre de 640 px en haut de l'écran
        $a = Get-TallWindowPlacement 100 640 600 30 0 1400
        Assert-True ($null -ne $a -and $a.Top -eq 100 -and $a.Height -eq 1040) 'agrandissement simple mal calculé'
        # Fenêtre basse dans l'écran : elle remonte pour ne pas dépasser la barre des tâches
        $b2 = Get-TallWindowPlacement 700 640 600 30 0 1400
        Assert-True ($null -ne $b2 -and $b2.Top -eq 360 -and ($b2.Top + $b2.Height) -eq 1400) 'fenêtre qui dépasse le bas de l''écran'
        # Petit écran (768) : toute la hauteur libre, pas plus
        $c2 = Get-TallWindowPlacement 50 640 600 30 0 728
        Assert-True ($null -ne $c2 -and $c2.Top -eq 0 -and $c2.Height -eq 728) 'fenêtre plus haute que l''écran'
        # Écran secondaire placé au-dessus (coordonnées négatives)
        $d2 = Get-TallWindowPlacement -900 640 600 30 -1080 -40
        Assert-True ($null -ne $d2 -and $d2.Top -ge -1080 -and ($d2.Top + $d2.Height) -le -40) 'écran aux coordonnées négatives mal géré'
        Assert-True ($null -eq (Get-TallWindowPlacement 0 1100 1060 55 0 1400)) 'fenêtre déjà haute modifiée'
        Assert-True ($null -eq (Get-TallWindowPlacement 0 728 690 34 0 728)) 'fenêtre déjà à la hauteur de l''écran modifiée'
        Assert-True ($null -eq (Get-TallWindowPlacement 0 640 600 0 0 1400)) 'nombre de lignes inconnu accepté'
        Assert-True ($null -eq (Get-TallWindowPlacement 0 640 600 30 0 0)) 'écran sans hauteur accepté'
        '8/8 cas'
    }
    Test-Case 'Windows Update : échecs de l''historique' {
        $since = (Get-Date '2026-11-19 12:00').AddDays(-30)
        $mk = { param($d, $rc, $t, $id, $hr) [pscustomobject]@{ Date = (Get-Date $d); Operation = 1; ResultCode = $rc; HResult = $hr; Title = $t; UpdateId = $id } }
        $e = @(
            (& $mk '2026-11-10' 4 '2026-11 Mise à jour cumulative (KB5132061) (26300.9974)' 'aaa' 0x800F0922),
            (& $mk '2026-11-12' 2 '2026-11 Mise à jour cumulative (KB5132061) (26300.9980)' 'bbb' 0),
            (& $mk '2026-11-15' 4 'Intel - Display - 31.0.101.5590' 'ccc' 0x80240034),
            (& $mk '2026-11-16' 4 'Intel - Display - 31.0.101.5590' 'ccc' 0x80240034),
            (& $mk '2026-10-22' 4 '9NCBCSZSJRSB-SpotifyAB.SpotifyMusic' 'ddd' 0x80240034),
            (& $mk '2026-09-01' 4 'Ancien pilote' 'eee' 0x80070005),
            (& $mk '2026-11-17' 2 'Pilote installé' 'fff' 0),
            [pscustomobject]@{ Date = (Get-Date '2026-11-18'); Operation = 2; ResultCode = 4; HResult = 1; Title = 'Désinstallation ratée'; UpdateId = 'ggg' }
        )
        $r = Get-WuHistoryFailures $e $since
        Assert-True (@($r.Failed).Count -eq 1) ('{0} échec(s) retenu(s), attendu 1 (même échec en double, réussi ensuite, hors période ou désinstallation comptés)' -f @($r.Failed).Count)
        Assert-True ($r.Failed[0].Title -like 'Intel*' -and $r.Failed[0].Code -eq '0x80240034') ('échec mal lu : ' + $r.Failed[0].Code)
        Assert-True ($r.Resolved -eq 1) 'échec suivi d''une réussite (même KB, autre version) non reconnu'
        Assert-True ($r.Store -eq 1) 'application du Store non mise à part'
        $r2 = Get-WuHistoryFailures @((& $mk '2026-11-12' 2 'X (KB5000001)' 'a' 0), (& $mk '2026-11-14' 4 'X (KB5000001)' 'b' 0x80070070)) $since
        Assert-True (@($r2.Failed).Count -eq 1) 'nouvel échec après une réussite ignoré'
        $r3 = Get-WuHistoryFailures @() $since
        Assert-True (@($r3.Failed).Count -eq 0 -and $r3.Resolved -eq 0 -and $r3.Store -eq 0) 'historique vide mal lu'
        # Recherche réussie : seul un échec encore proposé reste à faire (le pilote Intel a été remplacé)
        $pend = @([pscustomobject]@{ Title = 'Autre mise à jour'; UpdateId = 'zzz' })
        $r4 = Get-WuHistoryFailures $e $since $pend
        Assert-True (@($r4.Failed).Count -eq 0 -and $r4.Resolved -eq 2) 'échec remplacé depuis compté comme à faire'
        $r5 = Get-WuHistoryFailures $e $since @([pscustomobject]@{ Title = 'Intel - Display - 31.0.101.5590'; UpdateId = 'CCC' })
        Assert-True (@($r5.Failed).Count -eq 1) 'échec toujours proposé non retenu (identifiant en majuscules)'
        $r6 = Get-WuHistoryFailures $e $since @()
        Assert-True (@($r6.Failed).Count -eq 0) 'aucune mise à jour proposée : échec retenu à tort'
        Assert-True ((Get-WuErrorHint '0x800F0922') -match 'VPN') 'code 0x800F0922 sans explication'
        Assert-True ((Get-WuErrorHint '0x80073712') -match 'scan complet') 'fichiers de Windows abîmés sans conseil'
        Assert-True ($null -eq (Get-WuErrorHint '0x12345678')) 'code inconnu expliqué'
        Assert-True ((Get-WuErrorHint '0x800F020B') -match 'débranché') 'appareil absent (0x800F020B) sans explication'
        '13/13 cas'
    }
    Test-Case 'Windows Update : journal Système et préversions' {
        $d0 = Get-Date '2026-11-21 17:25:52'
        $kbT = '2026-11 Mise à jour de la préversion (KB5132057) (26300.10075)'
        $ev = ConvertFrom-WuClientEvent 20 $d0 @{ updateTitle = $kbT; updateGuid = '{71AB9CFC-4BDF-48B7-B7AD-7F4CE4605CD7}'; errorCode = "0x80070306`r`n" }
        Assert-True ($null -ne $ev -and $ev.ResultCode -eq 4 -and ('0x{0:X8}' -f [int]$ev.HResult) -eq '0x80070306') 'échec du journal mal lu (code)'
        Assert-True ($ev.UpdateId -eq '71ab9cfc-4bdf-48b7-b7ad-7f4ce4605cd7') ('identifiant mal lu : ' + $ev.UpdateId)
        $ok = ConvertFrom-WuClientEvent 19 $d0 @{ updateTitle = 'Pilote'; updateGuid = '{ABC}' }
        Assert-True ($null -ne $ok -and $ok.ResultCode -eq 2 -and $ok.HResult -eq 0) 'réussite du journal mal lue'
        Assert-True ($null -eq (ConvertFrom-WuClientEvent 20 $d0 @{ updateTitle = 'X'; errorCode = 'inconnu' })) 'code illisible accepté'
        Assert-True ($null -eq (ConvertFrom-WuClientEvent 43 $d0 @{ updateTitle = 'X'; errorCode = '0x1' })) 'début d''installation pris pour un résultat'
        Assert-True ($null -eq (ConvertFrom-WuClientEvent 20 $d0 @{ errorCode = '0x80070306' })) 'échec sans titre accepté'
        # Cas réel du 21/11/2026 : l'historique de l'API ne contient pas KB5132057, le journal la contient plusieurs fois ;
        # le pilote Canon est dans les deux sources et ne doit compter qu'une fois
        $com = @([pscustomobject]@{ Date = $d0.AddHours(-4); Operation = 1; ResultCode = 2; HResult = 0; Title = 'Mise à jour de la sélection disjointe pour Microsoft Defender Antivirus - 2267602 Ko (version 1.463.399.0)'; UpdateId = 'aaa' },
                 [pscustomobject]@{ Date = $d0.AddHours(-5); Operation = 1; ResultCode = 4; HResult = [Convert]::ToInt32('800F020B', 16); Title = 'Canon - Printer - 2.90.2.30'; UpdateId = 'ccc' })
        $evs = @()
        foreach ($m in 0, 12, 16) { $evs += ConvertFrom-WuClientEvent 20 ($d0.AddMinutes($m)) @{ updateTitle = $kbT; updateGuid = '{71ab9cfc-4bdf-48b7-b7ad-7f4ce4605cd7}'; errorCode = '0x80070306' } }
        $evs += ConvertFrom-WuClientEvent 20 ($d0.AddHours(-5)) @{ updateTitle = 'Canon - Printer - 2.90.2.30'; updateGuid = '{CCC}'; errorCode = '0x800F020B' }
        $pend = @([pscustomobject]@{ Title = $kbT; UpdateId = '71ab9cfc-4bdf-48b7-b7ad-7f4ce4605cd7' },
                  [pscustomobject]@{ Title = 'Canon - Printer - 2.90.2.30'; UpdateId = 'ccc' })
        $r = Get-WuHistoryFailures (@($com) + @($evs)) ($d0.AddDays(-30)) $pend
        Assert-True (@($r.Failed).Count -eq 2) ('{0} échec(s), attendu 2 (préversion du journal, pilote vu dans les deux sources)' -f @($r.Failed).Count)
        $kb = @($r.Failed | Where-Object { $_.Title -like '*KB5132057*' })
        Assert-True ($kb.Count -eq 1 -and $kb[0].Code -eq '0x80070306') 'échec présent seulement dans le journal non retenu'
        # Le 21/11/2026, la recherche de l'API ne proposait rien : l'échec du journal reste à signaler
        $r2 = Get-WuHistoryFailures @($evs) ($d0.AddDays(-30)) @() '26300.9974'
        Assert-True (@($r2.Failed | Where-Object { $_.Title -like '*KB5132057*' }).Count -eq 1) 'échec du journal effacé parce que l''API ne le propose pas'
        $r3 = Get-WuHistoryFailures @($evs) ($d0.AddDays(-30)) @() '26300.10075'
        Assert-True (@($r3.Failed | Where-Object { $_.Title -like '*KB5132057*' }).Count -eq 0 -and $r3.Resolved -ge 1) 'version de Windows atteinte : échec encore signalé'
        Assert-True ($null -eq (ConvertFrom-WuClientEvent 20 $d0 @{ updateTitle = '9PLM9XGG6VKS-OpenAI.Codex'; errorCode = '0x80073D02' })) 'application du Store reprise du journal'
        Assert-True (Test-WuPreviewTitle $kbT) 'préversion (titre français) non reconnue'
        Assert-True (Test-WuPreviewTitle '2026-11 Cumulative Update Preview for Windows 11 Version 24H2 for x64-based Systems (KB5000000)') 'préversion (titre anglais) non reconnue'
        Assert-True (Test-WuPreviewTitle '2026-11 .NET Framework Mise à jour de la préversion (KB5137006)') 'préversion de .NET non reconnue'
        Assert-True (-not (Test-WuPreviewTitle '2026-11 Mise à jour cumulative pour Windows 11 (KB5132061) (26300.9974)')) 'mise à jour de sécurité prise pour une préversion'
        Assert-True (-not (Test-WuPreviewTitle 'Canon - Printer - 2.90.2.30')) 'pilote pris pour une préversion'
        Assert-True ($null -ne (Get-WuErrorHint '0x80070306')) 'code 0x80070306 sans explication'
        # KB5132057 sur le PC de Thomas le 22/11/2026, 17 h 50 (événement 20, -2146498157)
        Assert-True ((Get-WuErrorHint ('0x{0:X8}' -f -2146498157)) -eq (Get-WuErrorHint '0x80070306')) 'code 0x800F0993 sans l''explication de 0x80070306'
        Assert-True ($null -eq (Get-WuErrorHint '0x800F0994')) 'code voisin expliqué par erreur'
        '19/19 cas'
    }
    Test-Case 'Accès contrôlé : exceptions à risque' {
        $r0 = Get-CfaAllowedRisk $null
        Assert-True ($r0.State -eq 'OK' -and $r0.Count -eq 0) 'aucune exception mal lue'
        Assert-True ((Get-CfaAllowedRisk @()).State -eq 'OK') 'liste vide mal lue'
        Assert-True ((Get-CfaAllowedRisk @('N/A: Must be an administrator to view exclusions')).State -eq 'UNKNOWN') 'liste masquée (sans droits admin) prise pour une liste vide'
        # Liste réelle de PC-LV (21/11/2026), nom du compte remplacé
        $lv = @('C:\Program Files (x86)\Common Files\Adobe\Adobe Desktop Common\AdobeGenuineClient\customhook\gccustomhook.exe',
                'C:\Program Files\CCleaner\CCleaner64.exe', 'C:\Program Files\CCleaner\CCUpdate.exe', 'C:\Program Files\Scrivener3\Scrivener.exe',
                'C:\Users\Utilisateur\Downloads\ccsetup561.exe', 'C:\Windows\System32\dllhost.exe', 'C:\Windows\System32\MoUsoCoreWorker.exe',
                'C:\Windows\System32\SrTasks.exe', 'C:\Windows\System32\svchost.exe')
        $r1 = Get-CfaAllowedRisk $lv
        Assert-True ($r1.State -eq 'WARN' -and $r1.Count -eq 9 -and (@($r1.Risky) -join ',') -eq 'dllhost.exe,svchost.exe') ('liste de PC-LV mal lue : ' + (@($r1.Risky) -join ','))
        $r2 = Get-CfaAllowedRisk @('C:\WINDOWS\System32\WindowsPowerShell\v1.0\POWERSHELL.EXE', 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe')
        Assert-True ($r2.State -eq 'WARN' -and @($r2.Risky).Count -eq 1 -and $r2.Risky[0] -eq 'powershell.exe') 'PowerShell autorisé non signalé (ou signalé deux fois)'
        Assert-True ((Get-CfaAllowedRisk @('C:\Program Files\CCleaner\CCleaner64.exe')).State -eq 'OK') 'application ordinaire signalée à tort'
        Assert-True ((Test-CfaNoticeExpected 'ON' $false) -and -not (Test-CfaNoticeExpected 'ON' $true)) 'avertissement de [M] mal décidé (accès contrôlé actif)'
        Assert-True (-not (Test-CfaNoticeExpected 'OFF' $false) -and -not (Test-CfaNoticeExpected 'UNKNOWN' $false)) 'avertissement de [M] sans accès contrôlé actif'
        '8/8 cas'
    }
    Test-Case 'Microsoft Store : noms, réglage et résultat' {
        $names = @{ 'SpotifyAB.SpotifyMusic_zpdnekdrzrea0' = 'Spotify' }
        Assert-True ((Get-StoreAppLabel 'SpotifyAB.SpotifyMusic_zpdnekdrzrea0' $names) -eq 'Spotify') 'nom du menu Démarrer ignoré'
        Assert-True ((Get-StoreAppLabel 'SPOTIFYAB.SPOTIFYMUSIC_zpdnekdrzrea0' $names) -eq 'Spotify') 'identifiant en majuscules non reconnu'
        Assert-True ((Get-StoreAppLabel 'Microsoft.Xbox.TCUI_8wekyb3d8bbwe' @{}) -eq 'Xbox.TCUI') 'nom de repli mal formé'
        Assert-True ((Get-StoreAppLabel 'Microsoft.XboxIdentityProvider_8wekyb3d8bbwe' @{}) -eq 'Xbox Identity Provider') 'nom de repli sans espaces'
        Assert-True ((Get-StoreAppLabel 'Paquet_abc' $null) -eq 'Paquet') 'paquet sans éditeur'
        Assert-True ((Get-StoreAppLabel '' $names) -eq '') 'identifiant vide'
        Assert-True ((Get-StoreAutoVerdict 'Enabled') -eq 'OK' -and (Get-StoreAutoVerdict 'Disabled') -eq 'WARN') 'réglage automatique mal lu'
        Assert-True ((Get-StoreAutoVerdict 'DisabledByPolicy') -eq 'POLICY' -and (Get-StoreAutoVerdict '') -eq 'UNKNOWN') 'stratégie ou valeur vide'
        Assert-True ((Get-StoreUpdateVerdict 'Completed' $false) -eq 'OK') 'mise à jour vérifiée non reconnue'
        Assert-True ((Get-StoreUpdateVerdict 'Completed' $true) -eq 'NOTDONE') '« Completed » cru alors que le Store la propose encore'
        Assert-True ((Get-StoreUpdateVerdict 'Completed' $null) -eq 'UNVERIFIED') 'succès annoncé sans nouvelle recherche'
        Assert-True ((Get-StoreUpdateVerdict 'Downloading' $false) -eq 'PENDING') 'téléchargement en cours pris pour un succès'
        Assert-True ((Get-StoreUpdateVerdict 'Error' $false) -eq 'FAIL') 'erreur ignorée'
        Assert-True ((Get-StoreUpdateVerdict 'NoUpdate' $false) -eq 'OK' -and (Get-StoreUpdateVerdict 'Canceled' $false) -eq 'CANCELED') 'rien à faire ou annulation'
        Assert-True ((Get-StoreUpdateVerdict 'NoUpdate' $true) -eq 'NOSTART') 'mise à jour non lancée prise pour « terminé »'
        Assert-True ((Get-StoreUpdateVerdict 'PausedLowBattery' $true) -eq 'PAUSED' -and (Get-StoreUpdateVerdict 'Paused' $null) -eq 'PAUSED') 'pause prise pour une attente normale'
        Assert-True ((Get-StoreUpdateVerdict 'ReadyToDownload' $true) -eq 'WAITING' -and (Get-StoreUpdateVerdict 'NotStarted' $true) -eq 'WAITING') 'mise à jour jamais démarrée'
        Assert-True ((Get-StoreUpdateVerdict 'Unknown' $false) -eq 'PENDING') 'état illisible pris pour un succès'
        '18/18 cas'
    }
    Test-Case 'winget : erreurs séparées du texte analysé' {
        # Même tableau que la sortie réelle du 19/11/2026, avec un message d'erreur (stderr) au milieu
        $fmt = '{0,-16}{1,-22}{2,-19}{3,-19}{4}'
        $er = [System.Management.Automation.ErrorRecord]::new([Exception]::new('Échec lors de la recherche dans la source : msstore'), 'NativeCommandError', 'NotSpecified', $null)
        $lines = @(($fmt -f 'Nom', 'ID', 'Version', 'Disponible', 'Source'), ('-' * 82), $er,
                   ($fmt -f 'Hytale Launcher', 'HypixelStudios.Hytale', '2026.05.14-26cebac', '2026.11.16-1726018', 'winget'),
                   '1 mises à niveau disponibles.')
        $sp = Split-NativeOutput -Lines $lines
        Assert-True ($sp.Out -notmatch 'msstore') 'message d''erreur mêlé au texte analysé'
        Assert-True ($sp.Err -eq 'Échec lors de la recherche dans la source : msstore') ('message d''erreur perdu : ' + $sp.Err)
        Assert-True ($sp.Out.EndsWith("1 mises à niveau disponibles.`r`n")) 'lignes non terminées par CRLF'
        $r = @(ConvertFrom-WingetText $sp.Out)
        Assert-True ($r.Count -eq 1 -and $r[0].Id -eq 'HypixelStudios.Hytale') ('tableau mal lu après séparation : {0} paquet(s)' -f $r.Count)
        $sp2 = Split-NativeOutput -Lines @()
        Assert-True ($sp2.Out -eq '' -and $sp2.Err -eq '') 'sortie vide'
        '5/5 cas'
    }
    Test-Case 'BIOS : page de support du fabricant' {
        $g = Get-BiosSupportLink 'Gigabyte Technology Co., Ltd.' 'Gigabyte Technology Co., Ltd.' 'Z790 AORUS ELITE DDR4'
        Assert-True ($g -and $g.Name -eq 'Gigabyte') 'Gigabyte non reconnu'
        $d = Get-BiosSupportLink 'Dell Inc.' 'Dell Inc.' 'Latitude 5420'
        Assert-True ($d -and $d.Name -eq 'Dell' -and $d.From -eq 'System') 'PC Dell'
        $a = Get-BiosSupportLink 'ASUSTeK COMPUTER INC.' 'System manufacturer' 'System Product Name'
        Assert-True ($a -and $a.Name -eq 'ASUS' -and $a.From -eq 'Board') 'carte ASUS dans un PC monté'
        $m = Get-BiosSupportLink 'Micro-Star International Co., Ltd.' 'To Be Filled By O.E.M.' 'To Be Filled By O.E.M.'
        Assert-True ($m -and $m.Name -eq 'MSI') 'carte MSI'
        $h = Get-BiosSupportLink 'HP' 'HP' 'HP Pavilion Laptop 15-eh1xxx'
        Assert-True ($h -and $h.Name -eq 'HP') 'PC HP'
        Assert-True ($null -eq (Get-BiosSupportLink 'Microsoft Corporation' 'Microsoft Corporation' 'Virtual Machine')) 'machine virtuelle prise pour un PC de marque'
        $s = Get-BiosSupportLink 'Microsoft Corporation' 'Microsoft Corporation' 'Surface Laptop 5'
        Assert-True ($s -and $s.Name -eq 'Microsoft Surface') 'Surface'
        Assert-True ($null -eq (Get-BiosSupportLink 'Fabricant inconnu' '' '')) 'fabricant inconnu'
        Assert-True ($null -eq (Get-BiosSupportLink '' '' '')) 'aucun fabricant'
        Assert-True (@(@($g, $d, $a, $m, $h, $s) | Where-Object { [string]$_.Url -notmatch '^https://[a-z0-9.-]+/' }).Count -eq 0) 'adresse non https'
        Assert-True ((Get-BiosSearchName 'Z790 AORUS ELITE DDR4' 'Z790 AORUS ELITE DDR4' 'System') -eq 'Z790 AORUS ELITE DDR4') 'carte et PC du même nom'
        Assert-True ((Get-BiosSearchName 'B450 TOMAHAWK MAX (MS-7C02)' 'MS-7C02' 'System') -eq 'B450 TOMAHAWK MAX (MS-7C02)') 'modèle du PC déjà dans le nom de la carte'
        Assert-True ((Get-BiosSearchName 'Z390-A PRO (MS-7B98)' 'MS-7B98' 'System') -eq 'Z390-A PRO (MS-7B98)') 'nom doublé (autre PC, 20/11/2026)'
        Assert-True ((Get-BiosSearchName 'PRO Z790-A WIFI' 'MS-7E07' 'System') -eq 'MS-7E07 (carte mère PRO Z790-A WIFI)') 'modèle du PC différent de la carte'
        Assert-True ((Get-BiosSearchName 'PRIME B550-PLUS' 'System Product Name' 'System') -eq 'PRIME B550-PLUS') 'texte de remplissage cherché'
        Assert-True ((Get-BiosSearchName 'X570 Steel Legend' 'To Be Filled By O.E.M.' 'Board') -eq 'X570 Steel Legend') 'carte mère ignorée'
        Assert-True ((Get-BiosSearchName 'Default string' 'Default string' 'System') -eq '') 'aucun nom utile'
        '17/17 cas'
    }
    Test-Case 'Fenêtre : place reprise après une relance' {
        $t = Format-WinRect -8 234 1200 1053
        Assert-True ($t -eq 'R-8_234_1200_1053') ('texte mal formé : ' + $t)
        $r = ConvertFrom-WinRect $t
        Assert-True ($null -ne $r -and $r.X -eq -8 -and $r.Y -eq 234 -and $r.W -eq 1200 -and $r.H -eq 1053) 'aller-retour du texte'
        Assert-True ($null -eq (ConvertFrom-WinRect '226,234,1200,1053')) 'virgules acceptées'
        Assert-True ($null -eq (ConvertFrom-WinRect 'R1_2_3_4; calc')) 'texte en trop accepté'
        Assert-True ($null -eq (ConvertFrom-WinRect '')) 'texte vide accepté'
        # Écran 2560x1440, barre des tâches de 40 pixels : fenêtre reprise telle quelle
        $p = Get-RestoredPlacement (ConvertFrom-WinRect 'R226_234_1200_1053') 0 0 2560 1400
        Assert-True ($null -ne $p -and $p.X -eq 226 -and $p.Y -eq 234 -and $p.W -eq 1200 -and $p.H -eq 1053) 'place modifiée à tort'
        # Fenêtre collée au bord gauche (bordure invisible à -8) et trop haute pour un écran de 768
        $q = Get-RestoredPlacement (ConvertFrom-WinRect 'R-8_100_1200_1053') 0 0 1366 728
        Assert-True ($null -ne $q -and $q.X -eq 0 -and $q.Y -eq 0 -and $q.H -eq 728) 'fenêtre hors de l''écran'
        Assert-True ($null -eq (Get-RestoredPlacement (ConvertFrom-WinRect 'R0_0_100_80') 0 0 2560 1400)) 'fenêtre minuscule acceptée'
        Assert-True ($null -eq (Get-RestoredPlacement $null 0 0 2560 1400)) 'texte illisible accepté'
        '9/9 cas'
    }
    Test-Case 'Fenêtre : ancienne console aux proportions des essais' {
        # Relevé du PC de Thomas : raccourci administrateur, 993 x 639 à (1304,340), zone libre 2 560 x 1 392
        $p = Get-ClassicConsolePlacement 1304 340 993 639 0 0 2560 1392
        Assert-True ($null -ne $p -and $p.W -eq 1200 -and $p.H -eq 1053 -and $p.X -eq 1304 -and $p.Y -eq 339) ('écran de Thomas : {0} {1} {2} {3}' -f $p.X, $p.Y, $p.W, $p.H)
        # Écran 1920 x 1080 : hauteur proportionnelle, largeur actuelle gardée (jamais rétrécie)
        $q = Get-ClassicConsolePlacement 200 150 993 639 0 0 1920 1040
        Assert-True ($null -ne $q -and $q.W -eq 993 -and $q.H -eq 787 -and $q.Y -eq 150) ('écran 1920 : {0} {1} {2} {3}' -f $q.X, $q.Y, $q.W, $q.H)
        # Petit portable 1366 x 768 : la fenêtre d'origine est déjà plus grande que les proportions, rien à faire
        Assert-True ($null -eq (Get-ClassicConsolePlacement 100 50 993 639 0 0 1366 728)) 'fenêtre rétrécie sur un petit écran'
        Assert-True ($null -eq (Get-ClassicConsolePlacement 0 0 993 639 0 0 0 0)) 'écran illisible accepté'
        # Second écran à gauche (coordonnées négatives) : la fenêtre reste dans sa zone
        $r = Get-ClassicConsolePlacement -1800 900 993 639 -2560 0 0 1392
        Assert-True ($null -ne $r -and $r.X + $r.W -le 0 -and $r.Y + $r.H -le 1392) ('second écran : {0} {1} {2} {3}' -f $r.X, $r.Y, $r.W, $r.H)
        '5/5 cas'
    }
    Test-Case 'Bluetooth : puce, absence et lecture impossible' {
        $usb = [pscustomobject]@{ InstanceId = 'USB\VID_8087&PID_0029\5&2A3D'; FriendlyName = 'Intel(R) Wireless Bluetooth(R)'; Status = 'OK' }
        $pci = [pscustomobject]@{ InstanceId = 'PCI\VEN_8086&DEV_51F1\3&11583659'; FriendlyName = 'Intel(R) Bluetooth'; Status = 'OK' }
        $tel = [pscustomobject]@{ InstanceId = 'BTHENUM\{0000111E-0000-1000-8000-00805F9B34FB}_LOCALMFG'; FriendlyName = 'Téléphone'; Status = 'OK' }
        $a = Get-BtRadioVerdict @($tel, $usb) ''
        Assert-True ($a.State -eq 'RADIO' -and $a.Radio.FriendlyName -like 'Intel*') 'puce USB non trouvée derrière un service'
        Assert-True ((Get-BtRadioVerdict @($pci) '').State -eq 'RADIO') 'puce PCI non trouvée'
        Assert-True ((Get-BtRadioVerdict @($tel) '').State -eq 'NONE') 'service du téléphone pris pour une puce'
        # PC sans Bluetooth (capture du 19/11/2026) : Get-PnpDevice lève ObjectNotFound
        $n = Get-BtRadioVerdict $null 'ObjectNotFound'
        Assert-True ($n.State -eq 'NONE' -and $null -eq $n.Radio) 'absence de Bluetooth prise pour une lecture impossible'
        Assert-True ((Get-BtRadioVerdict $null 'NotSpecified').State -eq 'UNKNOWN') 'échec de lecture pris pour une absence'
        Assert-True ((Get-BtRadioVerdict @() '').State -eq 'NONE') 'liste vide mal lue'
        '6/6 cas'
    }
    Test-Case 'Nettoyage : place réelle des fichiers creux' {
        $sp = [IO.FileAttributes]::SparseFile -bor [IO.FileAttributes]::Archive
        # Relevé du 20/11/2026 (cache de livraison) : fichier de 4,43 Go dont 0,69 Go reçus
        Assert-True ((Get-OnDiskBytes 4756602880 $sp 740884480) -eq 740884480) 'fichier creux compté à sa taille annoncée'
        Assert-True ((Get-OnDiskBytes 1000 ([IO.FileAttributes]::Archive) $null) -eq 1000) 'fichier ordinaire mal compté'
        Assert-True ((Get-OnDiskBytes 1000 ([IO.FileAttributes]::Compressed) 400) -eq 400) 'fichier compressé compté à sa taille'
        Assert-True ($null -eq (Get-OnDiskBytes 1000 $sp $null)) 'place illisible remplacée par une taille'
        Assert-True ((Get-OnDiskBytes 1000 $sp 4096) -eq 1000) 'place arrondie au-delà de la taille du fichier'
        Assert-True ((Get-OnDiskBytes 0 $sp 0) -eq 0) 'fichier creux vide mal compté'
        '6/6 cas'
    }
    Test-Case 'winget : application encore proposée après « terminé »' {
        $ell = [string][char]0x2026
        $rows = @(
            [pscustomobject]@{ Name = 'Discord'; Id = 'Discord.Discord'; Installed = '1.0.9244'; Available = '1.0.9269' },
            [pscustomobject]@{ Name = 'Microsoft Visual C++'; Id = ('Microsoft.VCRedist.2015+' + $ell); Installed = '14.40'; Available = '14.42' }
        )
        Assert-True (Test-WingetStillListed 'Discord.Discord' $rows) 'identifiant exact non reconnu'
        Assert-True (Test-WingetStillListed 'discord.discord' $rows) 'casse différente non reconnue'
        Assert-True (Test-WingetStillListed 'Microsoft.VCRedist.2015+.x64' $rows) 'identifiant coupé par winget non reconnu'
        Assert-True (-not (Test-WingetStillListed 'Mozilla.Firefox' $rows)) 'application absente crue encore proposée'
        Assert-True (-not (Test-WingetStillListed 'Discord.Discord' @())) 'liste vide mal lue'
        # Identifiant réduit aux points de suspension : il ne doit pas correspondre à tout
        Assert-True (-not (Test-WingetStillListed 'Mozilla.Firefox' @([pscustomobject]@{ Id = ('Mo' + $ell) }))) 'début trop court accepté'
        '6/6 cas'
    }
    Test-Case 'winget : codes, application retirée, version changée' {
        # Relevés de PC-LV le 21/11/2026 (journaux de winget) : CCleaner 0x8A150011, Java 0x8A150006 puis absent
        Assert-True ((Get-WingetErrorHint '0x8A150011') -match 'sécurité') 'empreinte différente (0x8A150011) sans explication'
        Assert-True ((Get-WingetErrorHint '0x8A150006') -match 'autre installation') 'installateur en échec (0x8A150006) sans explication'
        Assert-True ($null -eq (Get-WingetErrorHint '0x8A15FFFF')) 'code inconnu expliqué'
        # MAJÉRION le 25/11/2026 : Intel XTU 0x80190193 (HTTP 403), Epic Online Services 0x8A15008E
        Assert-True ((Get-WingetErrorHint '0x80190193') -match 'refusé le téléchargement') 'téléchargement refusé (403) sans explication'
        Assert-True ((Get-WingetErrorHint '0x80190194') -match 'refusé le téléchargement') 'fichier introuvable (404) sans explication'
        Assert-True ($null -eq (Get-WingetErrorHint '0x8019012C')) 'code HTTP hors erreur expliqué'
        Assert-True (Test-WingetNotApplicable ([int]0x8A15002B)) 'aucune mise à niveau applicable non reconnue'
        Assert-True (Test-WingetNotApplicable ([int]0x8A15008E)) 'technologie d''installation différente non reconnue'
        Assert-True (-not (Test-WingetNotApplicable ([int]0x8A150011))) 'empreinte différente prise pour « pas adaptée »'
        Assert-True (-not (Test-WingetNotApplicable 0)) 'succès pris pour « pas adaptée »'
        Assert-True (-not (Test-WingetNotApplicable $null)) 'code absent pris pour « pas adaptée »'
        Assert-True ((Get-WingetPresence 0) -eq 'PRESENT') 'application présente mal lue'
        Assert-True ((Get-WingetPresence (-1978335212)) -eq 'ABSENT') 'application absente (0x8A150014) mal lue'
        Assert-True ((Get-WingetPresence (-1978335231)) -eq 'UNKNOWN') 'autre erreur de winget prise pour une réponse'
        Assert-True ((Get-WingetPresence $null) -eq 'UNKNOWN') 'code absent pris pour une réponse'
        $ell = [string][char]0x2026
        Assert-True ((Get-WingetVersionChange '26.6.957.0' '26.11.281.0') -eq 'CHANGED') 'version changée non vue'
        Assert-True ((Get-WingetVersionChange '26.6.957.0' '26.6.957.0') -eq 'SAME') 'même version crue changée'
        Assert-True ((Get-WingetVersionChange '< 1.4.7' '1.4.7') -eq 'UNKNOWN') 'version « < 1.4.7 » comparée'
        Assert-True ((Get-WingetVersionChange 'Unknown' '1.0') -eq 'UNKNOWN') 'version inconnue comparée'
        Assert-True ((Get-WingetVersionChange '1.2.3' '') -eq 'UNKNOWN') 'version vide comparée'
        Assert-True ((Get-WingetVersionChange ('14.50.357' + $ell) '14.52.37029.0') -eq 'UNKNOWN') 'version coupée par winget comparée'
        '13/13 cas'
    }
    Test-Case 'Système : fabricant et modèle' {
        Assert-True ((Get-MachineLabel 'HP' 'HP ENVY x360 m6 Convertible') -eq 'HP ENVY x360 m6 Convertible') 'fabricant répété (HP HP)'
        Assert-True ((Get-MachineLabel 'hp' 'HP Pavilion') -eq 'HP Pavilion') 'casse différente : fabricant répété'
        Assert-True ((Get-MachineLabel 'Micro-Star International Co., Ltd.' 'MS-7B51') -eq 'Micro-Star International Co., Ltd. MS-7B51') 'fabricant perdu'
        Assert-True ((Get-MachineLabel 'LENOVO' '') -eq 'LENOVO') 'modèle vide mal lu'
        Assert-True ((Get-MachineLabel $null ' Model ') -eq 'Model') 'fabricant vide mal lu'
        '5/5 cas'
    }
    Test-Case 'Console : police essayée' {
        # Relevés du 19/11/2026 : « Terminal » 8 x 12, famille 0x30 (bitmap) après chcp 65001 ; Consolas 16, famille 0x36
        $b = Get-ConsoleFontPlan 12 0x30 'Terminal'
        Assert-True ($null -ne $b -and $b.Face -eq 'Consolas' -and $b.Family -eq 0x36 -and (@($b.Heights) -join ',') -eq '20,18,16') 'police bitmap : Consolas 20, 18, 16 attendus'
        $c = Get-ConsoleFontPlan 16 0x36 'Consolas'
        Assert-True ($null -ne $c -and $c.Face -eq 'Consolas' -and (@($c.Heights) -join ',') -eq '20,18') 'Consolas 16 : 20 puis 18 attendus'
        $d = Get-ConsoleFontPlan 18 0x36 'Lucida Console'
        Assert-True ($null -ne $d -and $d.Face -eq 'Lucida Console' -and (@($d.Heights) -join ',') -eq '20') 'police TrueType gardée, seulement plus grande'
        Assert-True ($null -eq (Get-ConsoleFontPlan 20 0x36 'Consolas')) 'police déjà assez grande agrandie'
        Assert-True ($null -eq (Get-ConsoleFontPlan 0 0x36 'Consolas')) 'police illisible changée'
        '5/5 cas'
    }
    Test-Case 'Console : sélection à la souris coupée puis remise' {
        # Mode réel de l'ancienne console de Windows : 0x1F7 (sélection à la souris active)
        # v3.27 : souris (0x10) retirée aussi, sinon la molette ne fait plus défiler l'ancienne console
        Assert-True ((Get-NoQuickEditMode 0x1F7) -eq 0x1A7) ('mode sans sélection mal calculé : 0x{0:X}' -f (Get-NoQuickEditMode 0x1F7))
        Assert-True ((Get-NoQuickEditMode 0x1B7) -eq 0x1A7) 'souris laissée au programme : molette bloquée'
        Assert-True ((Get-NoQuickEditMode 0x1A7) -eq 0x1A7) 'mode déjà sans sélection ni souris modifié'
        Assert-True ((Get-NoQuickEditMode 0x7) -eq 0x87) 'drapeau 0x80 non ajouté'
        Assert-True ((Get-QuickEditRestoreMode 0x1A6 0x1F7) -eq 0x1F6) 'sélection ou souris non remise, ou réglage de Ctrl+C écrasé'
        Assert-True ((Get-QuickEditRestoreMode 0x1A7 0x1B7) -eq 0x1B7) 'souris non remise, ou sélection remise alors qu''elle était coupée'
        Assert-True ((Get-QuickEditRestoreMode 0x1A7 0x1A7) -eq 0x1A7) 'souris remise alors qu''elle était coupée au départ'
        '5/5 cas'
    }
    Test-Case 'Composants Windows : analyse DISM EN/FR' {
        # Sortie anglaise de référence et sortie française reconstituée avec les libellés de CbsProvider.dll.mui
        # (relevés le 19/11/2026), fins de ligne Windows, espace insécable avant les deux-points
        $nb = [string][char]0x00A0
        $en = ("`r`nDeployment Image Servicing and Management tool`r`nVersion: 10.0.26100.1`r`n`r`n" +
               "[==========================100.0%==========================]`r`n`r`nComponent Store (WinSxS) information:`r`n`r`n" +
               "Windows Explorer Reported Size of Component Store : 8.42 GB`r`n`r`nActual Size of Component Store : 8.12 GB`r`n`r`n" +
               "    Shared with Windows : 6.01 GB`r`n    Backups and Disabled Features : 2.03 GB`r`n    Cache and Temporary Data :  0 bytes`r`n`r`n" +
               "Date of Last Cleanup : 2026-10-12 03:41:07`r`n`r`nNumber of Reclaimable Packages : 3`r`n" +
               "Component Store Cleanup Recommended : Yes`r`n`r`nThe operation completed successfully.`r`n")
        $i = Get-ComponentStoreInfo $en
        Assert-True ($i.Recommended -eq 'YES') 'nettoyage conseillé non lu (anglais)'
        Assert-True ($i.Reclaimable -eq 3) 'paquets récupérables (anglais)'
        Assert-True ($i.ActualBytes -eq [int64][math]::Round(8.12 * 1GB)) 'taille réelle (anglais)'
        Assert-True ($i.CacheBytes -eq 0) 'cache à 0 octet'
        $fr = ("`r`nInformations sur le magasin de composants (WinSxS)" + $nb + ":`r`n`r`n" +
               'L' + $ap + "Explorateur Windows a signalé la taille du magasin de composants. : 7,95 Go`r`n`r`n" +
               "Taille réelle du magasin de composants : 7,75 Go`r`n`r`n    Partagé avec Windows : 6,04 Go`r`n" +
               "    Sauvegardes et fonctionnalités désactivées : 1,71 Go`r`n    Cache et données temporaires : 512,30 Mo`r`n`r`n" +
               "Date du dernier nettoyage : 2026-11-10 09:12:34`r`n`r`nNombre de packages récupérables" + $nb + ": 0`r`n" +
               'Nettoyage du magasin de composants recommandé' + $nb + ": Non`r`n`r`nL" + $ap + "opération a réussi.`r`n")
        $f = Get-ComponentStoreInfo $fr
        Assert-True ($f.Recommended -eq 'NO') 'nettoyage non nécessaire non lu (français)'
        Assert-True ($f.Reclaimable -eq 0) 'paquets récupérables (français)'
        Assert-True ($f.ActualBytes -eq [int64][math]::Round(7.75 * 1GB)) 'taille réelle (français, virgule décimale)'
        Assert-True ($f.CacheBytes -eq [int64][math]::Round(512.30 * 1MB)) 'cache en Mo'
        # Accents décodés dans une autre page de code : les jokers des expressions doivent tenir
        Assert-True ((Get-ComponentStoreInfo ($fr -replace 'é', 'Ã©')).Recommended -eq 'NO') 'accents mal décodés non tolérés'
        Assert-True ($null -eq (Get-ComponentStoreInfo 'Error: 87 The parameter is incorrect.').Recommended) 'texte inconnu pris pour une réponse'
        Assert-True ($null -eq (Get-ComponentStoreInfo '').Recommended) 'texte vide pris pour une réponse'
        $sizes = @(@('8.42 GB', [int64][math]::Round(8.42 * 1GB)), @('0 bytes', 0), @('1 234,5 Mo', [int64][math]::Round(1234.5 * 1MB)),
                   @('12 Ko', 12288), @('beaucoup', $null))
        foreach ($c in $sizes) {
            $got = ConvertFrom-DismSize $c[0]
            Assert-True ($got -eq $c[1]) ('taille « {0} » lue {1}' -f $c[0], $got)
        }
        '16/16 cas'
    }
    Test-Case 'Composants Windows : résultat du nettoyage' {
        $cases = @(
            @(("[==========================100.0%==========================]`r`nL" + $ap + "opération a réussi.`r`n"), 0, 'DONE'),
            @("The operation completed successfully.`r`n", 0, 'DONE'),
            @("Error: 0x800f0806`r`n`r`nThe operation could not be completed due to pending operations.`r`n", -2146498554, 'PENDING'),
            @("Erreur : 0x800f0806`r`n", -2146498554, 'PENDING'),
            @('Error: 5 Access is denied.', 5, 'FAILED'),
            @('', 0, 'UNKNOWN'),
            @('', $null, 'FAILED')
        )
        foreach ($c in $cases) {
            $got = Get-ComponentCleanupVerdict $c[0] $c[1]
            Assert-True ($got -eq $c[2]) ("« {0} » -> {1}, attendu {2}" -f (Cut $c[0] 30), $got, $c[2])
        }
        '{0}/{0} cas' -f $cases.Count
    }
    Test-Case 'Nettoyage : conditions de Windows Update' {
        Assert-True ((Get-ServicingBlocker $false $false $false) -eq '') 'PC libre bloqué à tort'
        Assert-True ((Get-ServicingBlocker $true $false $false) -match 'redémarrage') 'redémarrage en attente ignoré'
        Assert-True ((Get-ServicingBlocker $false $false $true) -match 'installe des mises') 'installation en cours ignorée'
        Assert-True ((Get-ServicingBlocker $false $true $false) -match 'composants') 'maintenance de Windows ignorée'
        Assert-True ((Get-ServicingBlocker $false $false $null) -ne '') 'installateur illisible pris pour « libre »'
        Assert-True ((Get-ServicingBlocker $null $false $false) -ne '') 'redémarrage illisible pris pour « aucun »'
        '6/6 cas'
    }
    Test-Case 'Nettoyage : total proposé et tailles affichées' {
        $mb = [int64]1MB
        $ts = @(
            (New-CleanTarget 'Temp' 'Temp' (812 * $mb) $true $false),
            (New-CleanTarget 'RecycleBin' 'Corbeille' (50 * $mb) $true $false),
            (New-CleanTarget 'WuCache' 'Cache WU' (300 * $mb) $true $true 'un redémarrage est en attente'),
            (New-CleanTarget 'DoCache' 'Optimisation' (400 * $mb) $true $true),
            (New-CleanTarget 'Dumps' 'Vidages' (900 * $mb) $false $false),
            (New-CleanTarget 'Components' 'Composants' 0 $true $true '' $true),
            (New-CleanTarget 'Seuil' 'Seuil propre plus haut' (600 * $mb) $true $false)
        )
        $ts[6].MinBytes = 1024 * $mb
        $na = Get-CleanProposal $ts (100 * $mb) $false
        $k1 = (@($na.Items) | ForEach-Object { $_.Key }) -join ','
        Assert-True ($k1 -eq 'Temp') ('sans droits admin : ' + $k1)
        Assert-True ($na.Bytes -eq 812 * $mb) 'total sans droits admin'
        $ad = Get-CleanProposal $ts (100 * $mb) $true
        $k2 = (@($ad.Items) | ForEach-Object { $_.Key }) -join ','
        Assert-True ($k2 -eq 'Temp,DoCache,Components') ('avec droits admin : ' + $k2)
        Assert-True ($ad.Bytes -eq 1212 * $mb) 'total avec droits admin'
        Assert-True (@((Get-CleanProposal @() (100 * $mb) $true).Items).Count -eq 0) 'liste vide'
        Assert-True ((Format-Bytes 0) -eq '0 Mo') 'zéro'
        Assert-True ((Format-Bytes 1000) -eq 'moins de 1 Mo') 'moins de 1 Mo'
        Assert-True ((Format-Bytes (812 * $mb)) -eq ('{0:N0} Mo' -f 812)) 'Mo'
        Assert-True ((Format-Bytes ([int64](2.34 * 1GB))) -eq ('{0:N1} Go' -f 2.34)) 'Go'
        Assert-True ((Format-Bytes $null) -eq 'taille inconnue') 'taille inconnue'
        $m = [pscustomobject]@{ Ok = $true; Exists = $true; Link = $false; Partial = $false; TotalBytes = 900 * $mb; AgedBytes = 812 * $mb; AgedCount = 3 }
        Assert-True ((Format-AgedText $m 'de plus de 24 h') -eq ('{0:N0} Mo, dont {1:N0} Mo de plus de 24 h' -f 900, 812)) 'mesure avec âge'
        $m.Partial = $true
        Assert-True ((Format-AgedText $m 'de plus de 24 h') -eq ('au moins {0:N0} Mo, dont au moins {1:N0} Mo de plus de 24 h' -f 900, 812)) 'mesure partielle présentée comme complète'
        $m.Ok = $false
        Assert-True ((Format-AgedText $m 'de plus de 24 h') -eq 'lecture impossible') 'lecture en échec affichée comme une taille'
        '14/14 cas'
    }
    Test-Case 'Composants Windows : tâche de nettoyage de Windows' {
        $now = [datetime]'2026-11-19 18:00'
        $d14 = [TimeSpan]::FromDays(14)
        $cases = @(
            @('Ready', [datetime]'2026-11-16 04:27', 0, $d14, 'OK'),              # relevé du PC de Thomas
            @('Disabled', [datetime]'2026-11-16 04:27', 0, $d14, 'DISABLED'),
            @('Running', [datetime]'2026-11-16 04:27', 267009, $d14, 'RUNNING'),
            @('Ready', [datetime]'2026-11-16 04:27', 267009, $d14, 'RUNNING'),    # 0x41301
            @('Ready', [datetime]'1999-11-30 00:00', 267011, $d14, 'NEVER'),      # 0x41303
            @('Ready', [datetime]'1999-11-30 00:00', 0, $d14, 'NEVER'),
            @('Ready', [datetime]'2026-11-16 04:27', -2147024891, $d14, 'FAILED'),  # 0x80070005 en entier signé
            @('Ready', [datetime]'2026-11-16 04:27', 2147942405, $d14, 'FAILED'),   # 0x80070005 en entier non signé
            @('Ready', [datetime]'2026-10-20 04:27', 0, $d14, 'LATE'),
            @('Ready', [datetime]'2026-11-16 04:27', 0, $null, 'UNKNOWN'),
            @($null, [datetime]'2026-11-16 04:27', 0, $d14, 'UNKNOWN'),
            @('Ready', [datetime]'2026-11-16 04:27', $null, $d14, 'UNKNOWN')
        )
        foreach ($c in $cases) {
            $got = Get-CleanupTaskVerdict $c[0] $c[1] $c[2] $c[3] $now
            Assert-True ($got -eq $c[4]) ('{0} / {1} / {2} -> {3}, attendu {4}' -f $c[0], $c[1], $c[2], $got, $c[4])
        }
        Assert-True ([Xml.XmlConvert]::ToTimeSpan('P14D') -eq $d14) 'délai de rattrapage « P14D » mal lu'
        '{0}/{0} cas' -f ($cases.Count + 1)
    }
    Test-Case 'Mode ASCII : conversion des glyphes' {
        $got = Convert-Glyph '█░┌─┐…'
        Assert-True ($got -eq '#.+-+...') "obtenu $got"
        'OK'
    }
    Test-Case 'Options de JARVIS.cmd lues sans exécution (S1)' {
        $sw = @('Quick', 'Deep', 'NoAnim', 'NoWinget', 'NoElevate', 'ResetName', 'ResetChoices', 'Ascii', 'SelfTest', 'Install', 'Uninstall', 'Update')
        $st = @('InstallDir', 'Name', 'WinRect')
        $r = ConvertFrom-JarvisArgLine '' $sw $st
        Assert-True ($r.Ok -and $r.Values.Count -eq 0) 'texte vide refusé'
        # Relances réelles de JARVIS (installation, administrateur)
        $r = ConvertFrom-JarvisArgLine '-Install -InstallDir "C:\Program Files (x86)\JARVIS" -WinRect R-8_234_1200_1053' $sw $st
        Assert-True ($r.Ok -and $r.Values['Install'] -eq $true -and $r.Values['InstallDir'] -eq 'C:\Program Files (x86)\JARVIS' -and
                     $r.Values['WinRect'] -eq 'R-8_234_1200_1053' -and $r.Values.Count -eq 3) 'relance d''installation mal lue'
        $r = ConvertFrom-JarvisArgLine ("-Name `"Marie-Claire O'Neil`"`t-ResetName -NoAnim -Quick") $sw $st
        Assert-True ($r.Ok -and $r.Values['Name'] -eq "Marie-Claire O'Neil" -and $r.Values['ResetName'] -and $r.Values['Quick']) 'relance administrateur mal lue'
        $r = ConvertFrom-JarvisArgLine "-selftest -Q -name 'Jo'" $sw $st
        Assert-True ($r.Ok -and $r.Values['SelfTest'] -and $r.Values['Quick'] -and $r.Values['Name'] -eq 'Jo') 'casse ou début de nom refusé'
        # Code dans un argument : texte gardé tel quel, jamais exécuté
        $mark = 'jarvisT1Pwned' + [guid]::NewGuid().ToString('N').Substring(0, 6)
        $evil = '-InstallDir "C:\x$(Set-Variable -Name ' + $mark + ' -Value 1 -Scope Global)"'
        $r = ConvertFrom-JarvisArgLine $evil $sw $st
        Assert-True ($null -eq (Get-Variable -Name $mark -Scope Global -ErrorAction SilentlyContinue)) 'code de l''argument exécuté'
        Assert-True ($r.Ok -and $r.Values['InstallDir'] -eq ('C:\x$(Set-Variable -Name ' + $mark + ' -Value 1 -Scope Global)')) 'texte de l''argument modifié'
        $bad = @('-Quick; calc', 'Thomas', '-Quick -Quick', '-N', '-Inconnu', '-Name', '-Name -Quick', '-Name "Jean', '-Name a"b"',
                 '-Name "a"b', '-InstallDir:C:\x', '"-Quick"', '-Quick & calc', '-Quick:$false')
        foreach ($b in $bad) {
            $r = ConvertFrom-JarvisArgLine $b $sw $st
            Assert-True (-not $r.Ok -and $r.Bad) ('accepté à tort : ' + $b)
        }
        '{0} cas' -f (6 + $bad.Count)
    }
    Test-Case 'Valeur retransmise à une relance (S1)' {
        $good = @('C:\Program Files\JARVIS', 'C:\Program Files (x86)\JARVIS', 'D:\Logiciels\Été 2026\JARVIS', "D:\Jeux d'Hiver\JARVIS", 'E:\Outils_1.2\JARVIS')
        $bad = @('', 'C:\a&calc', 'C:\a^b', 'C:\x$(calc)', 'C:\a%PATH%', 'C:\a"b', 'C:\a|b', 'C:\a`b', 'C:\a!b', 'C:\a<b', 'C:\a;b',
                 ('C:\a' + [char]10 + 'b'))
        foreach ($g in $good) { Assert-True (Test-SafeArgValue $g) ('refusé à tort : ' + $g) }
        foreach ($b in $bad) { Assert-True (-not (Test-SafeArgValue $b)) ('accepté à tort : ' + $b) }
        '{0} cas' -f ($good.Count + $bad.Count)
    }
    Test-Case 'Dossiers de modules PowerShell (S2)' {
        # Liste fixe : ni Documents, ni un dossier ajouté par le compte (C:\Windows\tracing est ouvert en écriture)
        $sys = 'C:\WINDOWS\System32\WindowsPowerShell\v1.0\Modules'
        $got = Get-SafeModulePath 'C:\WINDOWS\' @('C:\Program Files', 'C:\Program Files (x86)\')
        Assert-True ($got -ceq ('C:\Program Files\WindowsPowerShell\Modules;C:\Program Files (x86)\WindowsPowerShell\Modules;' + $sys)) ('obtenu ' + $got)
        # Console 64 bits sur un Windows 32 bits (pas de Program Files (x86)), doublon, valeur vide
        $got = Get-SafeModulePath 'C:\WINDOWS' @('C:\Program Files', '', 'C:\Program Files', $null)
        Assert-True ($got -ceq ('C:\Program Files\WindowsPowerShell\Modules;' + $sys)) ('obtenu ' + $got)
        Assert-True ((Get-SafeModulePath '' @()) -eq '') 'aucun dossier : liste non vide'
        Assert-True ($got -notmatch 'Documents|tracing') 'dossier modifiable gardé'
        '4 cas'
    }
    Test-Case 'winget par son chemin complet (S2)' {
        $fam = 'Microsoft.DesktopAppInstaller_8wekyb3d8bbwe'
        $mk = { param($F, $L, $V) [pscustomobject]@{ PackageFamilyName = $F; InstallLocation = $L; Version = $V } }
        $wa = 'C:\Program Files\WindowsApps\'
        $old = & $mk $fam ($wa + 'Microsoft.DesktopAppInstaller_1.9.25200.0_x64__8wekyb3d8bbwe') '1.9.25200.0'
        $new = & $mk $fam ($wa + 'Microsoft.DesktopAppInstaller_1.29.380.0_x64__8wekyb3d8bbwe') '1.29.380.0'
        $got = @(Get-WingetExeCandidates @($old, $new) 'C:\Program Files\')
        Assert-True ($got.Count -eq 2 -and $got[0] -eq ($wa + 'Microsoft.DesktopAppInstaller_1.29.380.0_x64__8wekyb3d8bbwe\winget.exe')) ('obtenu ' + ($got -join ' | '))
        $bad = @((& $mk $fam 'C:\Users\x\AppData\Local\Faux' '9.0.0.0'), (& $mk 'Faux.AppInstaller_8wekyb3d8bbwe' ($wa + 'Faux') '9.0.0.0'),
                 (& $mk $fam ($wa + '..\..\Users\x') '9.0.0.0'), (& $mk $fam 'C:\Program FilesX\WindowsApps\x' '9.0.0.0'), $null)
        Assert-True (@(Get-WingetExeCandidates $bad 'C:\Program Files').Count -eq 0) 'paquet hors de WindowsApps accepté'
        Assert-True (@(Get-WingetExeCandidates @($new) '').Count -eq 0) 'Program Files inconnu accepté'
        '{0} cas' -f (3 + $bad.Count)
    }
    Test-Case 'Alimentation : secteur ou batterie (S7)' {
        $cases = @(@('Online', $null, 'AC'), @('Offline', $false, 'BATTERY'), @('Offline', $true, 'BATTERY'), @('Unknown', $true, 'AC'),
                   @('Unknown', $false, 'UNKNOWN'), @('Unknown', $null, 'UNKNOWN'), @('', $null, 'UNKNOWN'), @('Unknown', 'True', 'UNKNOWN'))
        foreach ($c in $cases) {
            $got = Get-PowerVerdict $c[0] $c[1]
            Assert-True ($got -eq $c[2]) ('{0} / {1} -> {2}, attendu {3}' -f $c[0], $c[1], $got, $c[2])
        }
        '{0} cas' -f $cases.Count
    }

    # ---- Garde-fous purs, rangés en T5 jusqu'à la v3.24 (audit, constat T5) : ils n'étaient vérifiés ni avant la
    # fabrication ni sur GitHub. Seulement des lectures (variables, dossiers demandés à Windows, type du disque C:) :
    # aucun dossier n'est créé ni vidé ici. Les variables du programme n'existent pas en T1 (tools/check.ps1).
    Test-Case 'Temp : chemins dangereux refusés' {
        # v3.24 : %TEMP% redéfini vers le dossier Temp d'un programme installé ou de Windows (chemins non créés ici)
        $win = [Environment]::GetFolderPath('Windows')
        $bad = @("$env:SystemDrive\", $env:USERPROFILE, $env:SystemRoot, $env:ProgramFiles, $env:LOCALAPPDATA, '',
                 (Join-Path (Get-ProgramFilesDir) 'Editeur\Temp'), (Join-Path $win 'System32\Temp'),
                 (Join-Path ([Environment]::GetFolderPath('CommonApplicationData')) 'Editeur\Temp'))
        foreach ($p in $bad) { Assert-True (-not (Test-SafeTempPath $p)) ('accepté à tort : ' + $p) }
        Assert-True (Test-SafeTempPath (Join-Path $env:SystemRoot 'Temp')) 'Windows\Temp refusé à tort'
        Assert-True (Test-SafeTempPath (Join-Path $win 'Temp')) 'Windows\Temp (dossier demandé à Windows) refusé à tort'
        '{0} refus, 2 acceptations' -f $bad.Count
    }
    Test-Case 'Installation : chemins interdits refusés' {
        $bad = @($env:SystemRoot, [Environment]::GetFolderPath('Windows'), [Environment]::GetFolderPath('Desktop'),
                 (Join-Path $env:USERPROFILE 'Downloads'), 'dossier\relatif', 'C:\Program Files\JA?RVIS', '\\serveur\partage\JARVIS', '')
        foreach ($p in $bad) { Assert-True (-not (Resolve-InstallDir $p).Ok) ('accepté à tort : ' + $p) }
        # Dossier choisi sous Program Files (demandé à Windows, comme $DefaultInstallDir) : \JARVIS ajouté. Dossier qui
        # n'existe pas : le résultat ne dépend pas du contenu d'une installation présente sur le PC (relecture du lot D)
        $pf = Join-Path (Get-ProgramFilesDir) ('Essai JARVIS ' + [guid]::NewGuid().ToString('N').Substring(0, 8))
        $ok = Resolve-InstallDir $pf
        Assert-True ($ok.Ok -and $ok.Path -eq (Join-Path $pf 'JARVIS')) ('Program Files mal traité : ' + $ok.Path + ' ' + $ok.Reason)
        '{0} refus, \JARVIS ajouté automatiquement' -f $bad.Count
    }
    Test-Case 'Prénom : caractères dangereux filtrés' {
        # Le prénom est retransmis à la relance administrateur : rien qui puisse y devenir une commande
        $n = Get-SafeName 'Bob"; calc $(whoami) `x & y | z % ^'
        Assert-True ($n -notmatch '[";$`()&|%^]') ('non filtré : ' + $n)
        Assert-True ((Get-SafeName "D'Artagnan") -eq "D'Artagnan") 'apostrophe perdue'
        Assert-True ((Get-SafeName 'Jean-Pierre') -eq 'Jean-Pierre') 'tiret perdu'
        Assert-True ((Get-SafeName 'Éloïse') -eq 'Éloïse') 'accents perdus'
        Assert-True ($null -eq (Get-SafeName '$();')) 'saisie vide non rejetée'
        Assert-True ($null -eq (Get-SafeName $null)) 'valeur nulle'
        Assert-True ((Get-SafeName ('a' * 50)).Length -eq 30) 'prénom trop long non coupé'
        '7/7 cas'
    }
    Test-Case 'Mises à jour : comparaison de versions' {
        Assert-True ((Compare-JarvisVersion '3.3' '3.2') -gt 0) '3.3 > 3.2'
        Assert-True ((Compare-JarvisVersion '3.10' '3.9') -gt 0) '3.10 > 3.9 (pas un tri alphabétique)'
        Assert-True ((Compare-JarvisVersion '3.2' '3.3') -lt 0) '3.2 < 3.3'
        Assert-True ((Compare-JarvisVersion '3.3' '3.3') -eq 0) 'égalité'
        Assert-True ($null -eq (Compare-JarvisVersion 'abc' '3.3')) 'version illisible traitée comme une version'
        Assert-True ($null -eq (Compare-JarvisVersion '3.3' '')) 'version absente traitée comme « égale »'
        '6/6 cas'
    }
    Test-Case 'Windows Update : pilote proposé rattaché à l''appareil' {
        # v3.27 : identifiants de la forme relevée sur les PC (USB pour le Bluetooth Intel, PCI pour la carte graphique)
        $bt = [pscustomobject]@{ HardwareId = 'USB\VID_8087&PID_0033'; Title = 'Intel Corporation Bluetooth Driver Update (24.80.0.2)' }
        $gpu = [pscustomobject]@{ HardwareId = 'pci\ven_10de&dev_2786&subsys_51111458'; Title = 'NVIDIA - Display - 32.0.15.9999' }
        $offers = @($bt, $gpu)
        $r = Get-DriverOffer 'USB\VID_8087&PID_0033\5&2A6B8C1&0&10' @('USB\VID_8087&PID_0033&REV_0000', 'USB\VID_8087&PID_0033') $offers
        Assert-True ($null -ne $r -and $r.Title -match 'Bluetooth') 'Bluetooth non rattaché par son identifiant'
        $r = Get-DriverOffer 'PCI\VEN_10DE&DEV_2786&SUBSYS_51111458&REV_A1\4&1D2E3F&0&0008' @() $offers
        Assert-True ($null -ne $r -and $r.Title -match 'NVIDIA') 'carte graphique non rattachée par le début de son identifiant (casse différente)'
        $r = Get-DriverOffer 'PCI\VEN_10DE&DEV_27860&SUBSYS_1\0' @() @([pscustomobject]@{ HardwareId = 'PCI\VEN_10DE&DEV_2786'; Title = 'x' })
        Assert-True ($null -eq $r) 'identifiant voisin (DEV_27860) pris pour DEV_2786'
        Assert-True ($null -eq (Get-DriverOffer 'PCI\VEN_8086&DEV_7AF0\3&0' @('PCI\VEN_8086&DEV_7AF0') $offers)) 'appareil sans offre rattaché'
        Assert-True ($null -eq (Get-DriverOffer '' @() $offers)) 'appareil sans identifiant rattaché'
        Assert-True ($null -eq (Get-DriverOffer 'USB\VID_8087&PID_0033\5' @() @([pscustomobject]@{ HardwareId = ''; Title = 'vide' }))) 'offre sans identifiant rattachée'
        '6/6 cas'
    }
    Test-Case 'Windows Update : mises à jour exclues' {
        # Une mise à niveau de Windows ne s'installe jamais sans surveillance. Objets construits comme ceux de Windows
        # Update (BrowseOnly toujours présent : le mode strict de T1 refuse une propriété absente)
        $mk = { param($t, $cat, $ui, $browse) [pscustomobject]@{ Title = $t; BrowseOnly = [bool]$browse
                Categories = @($cat | ForEach-Object { [pscustomobject]@{ CategoryID = $_ } })
                InstallationBehavior = [pscustomobject]@{ CanRequestUserInput = $ui } } }
        Assert-True ([bool](Test-SkipWuUpdate (& $mk 'Windows 11, version 25H2' @('3689bdc8-b205-4af4-8d4b-a63924c5e9d5') $false $false))) 'mise à niveau (catégorie) non exclue'
        Assert-True ([bool](Test-SkipWuUpdate (& $mk 'Mise à jour de fonctionnalité vers Windows 11' @() $false $false))) 'mise à niveau (titre) non exclue'
        Assert-True ([bool](Test-SkipWuUpdate (& $mk 'Feature update to Windows 11, version 25H2' @() $false $false))) 'mise à niveau (titre anglais) non exclue'
        Assert-True ([bool](Test-SkipWuUpdate (& $mk 'Pilote interactif' @() $true $false))) 'mise à jour interactive non exclue'
        Assert-True ($null -eq (Test-SkipWuUpdate (& $mk '2026-11 Mise à jour cumulative' @('0fa1201d-4330-4fa8-8ae9-b877473b6441') $false $false))) 'mise à jour normale exclue à tort'
        Assert-True ((Test-SkipWuUpdate (& $mk 'Pilote facultatif' @() $false $true)) -eq 'facultative') 'mise à jour facultative non exclue'
        '6/6 cas'
    }
}

function Test-OtherAvListed {
    # Auto-test (v3.25) : $true si le Centre de sécurité montre un antivirus actif autre que Defender. Sert à distinguer
    # « Defender illisible » (lecture en échec) de « Defender remplacé par un autre antivirus » (non applicable).
    $avs = $null
    try { $avs = @(Get-CimInstance -Namespace root/SecurityCenter2 -ClassName AntiVirusProduct -ErrorAction Stop) } catch { return $false }
    foreach ($av in $avs) {
        if ([string]$av.displayName -match 'Defender') { continue }
        $st = Get-AvState $av.productState
        if ($st -and $st.On) { return $true }
    }
    return $false
}

function Invoke-SelfTest {
    $results = New-Object System.Collections.Generic.List[object]
    $log = New-Object System.Collections.Generic.List[string]

    # États : PASS, FAIL, SKIP (non applicable : droits, équipement, lancement hors installation) et, depuis la v3.25
    # (audit, constat T4), WARN : une lecture a échoué (journal, état de Defender, GitHub). Jusqu'à la v3.24 elle
    # comptait comme SKIP et le bilan restait vert ; le test renvoie alors 'UNREAD:raison'.
    function Add-Result([string]$Name, [string]$State, [string]$Detail, [double]$Ms) {
        $results.Add([pscustomobject]@{ Name = $Name; State = $State; Detail = $Detail })
        $col = @{ PASS = 'Green'; FAIL = 'Red'; WARN = 'Yellow'; SKIP = 'DarkGray' }[$State]
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
            elseif ($r -is [string] -and $r.StartsWith('UNREAD:')) { Add-Result $Name 'WARN' ('lecture impossible : ' + $r.Substring(7)) $sw.Elapsed.TotalMilliseconds }
            else { Add-Result $Name 'PASS' ([string]$r) $sw.Elapsed.TotalMilliseconds }
        } catch {
            $sw.Stop()
            Add-Result $Name 'FAIL' (Cut $_.Exception.Message 80) $sw.Elapsed.TotalMilliseconds
        }
    }

    Write-Host ''
    Type-Line '   >> Protocole d''auto-diagnostic engagé.' 'Cyan'

    # ---------------- T1 : analyseurs (cas connus, aucune dépendance au PC)
    Invoke-SelfTestAnalyzers

    # ---------------- T2 : moteurs d'exécution
    Write-Section 'T2' 'Moteurs d''exécution'

    Test-Case 'Job en arrière-plan (aller-retour)' {
        $r = Invoke-Spinner 'job de test' { [pscustomobject]@{ V = 42 } } 60
        Assert-True ($null -ne $r -and $r.V -eq 42) 'résultat absent ou invalide'
        'valeur reçue'
    }
    Test-Case 'Processus console + capture' {
        $r = Invoke-ProcessSpinner -Label 'cmd de test' -FilePath (Get-SystemToolPath 'cmd.exe') `
             -Arguments '/c echo JARVIS_OK' -TimeoutSec 30 -Encoding 'Oem'
        Assert-True ($null -ne $r) 'pas de retour'
        Assert-True ($r.Code -eq 0) "code $($r.Code)"
        Assert-True ($r.Text -match 'JARVIS_OK') 'sortie non capturée'
        'code 0, sortie lue'
    }
    Test-Case 'Délai dépassé : arrêt du processus' {
        $r = Invoke-ProcessSpinner -Label 'arrêt forcé' -FilePath (Get-SystemToolPath 'PING.EXE') `
             -Arguments '-n 30 127.0.0.1' -TimeoutSec 2 -Encoding 'Oem'
        Assert-True ($null -eq $r) 'le délai n''a pas interrompu le processus'
        Assert-True ($script:ProcState -eq 'TIMEOUT') ('motif de l''arrêt mal noté : ' + $script:ProcState)
        Start-Sleep -Milliseconds 300
        'interrompu à 2 s'
    }
    Test-Case 'Outil introuvable : pas de plantage' {
        $r = Invoke-ProcessSpinner -Label 'outil absent' -FilePath (Get-SystemToolPath 'outil-absent-jarvis.exe') `
             -Arguments '/x' -TimeoutSec 5 -Encoding 'Auto'
        Assert-True ($null -eq $r) 'un résultat a été renvoyé pour un outil absent'
        Assert-True ($script:ProcState -eq 'NOSTART') ('motif mal noté : ' + $script:ProcState)
        'lancement impossible signalé, JARVIS continue'
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
        $r = Invoke-ProcessSpinner -Label 'DISM /CheckHealth' -FilePath (Get-SystemToolPath 'dism.exe') `
             -Arguments '/Online /Cleanup-Image /CheckHealth' -TimeoutSec 300 -Encoding 'Auto'
        Assert-True ($null -ne $r) 'délai dépassé'
        Assert-True ($r.Code -eq 0) "code de sortie $($r.Code)"
        $dv = Get-DismVerdict $r.Text $r.Code
        Assert-True ($dv -ne 'UNKNOWN') 'message de DISM non reconnu (langue de Windows autre que français ou anglais ?)'
        'verdict : ' + $dv
    } -NeedAdmin
    Test-Case 'CHKDSK : lancement' {
        $r = Invoke-ProcessSpinner -Label 'chkdsk /?' -FilePath (Get-SystemToolPath 'chkdsk.exe') `
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
    Test-Case 'Windows Update : historique' {
        $se = (New-Object -ComObject Microsoft.Update.Session -ErrorAction Stop).CreateUpdateSearcher()
        $n = [int]$se.GetTotalHistoryCount()
        if ($n -eq 0) { return 'historique vide' }
        $h = @($se.QueryHistory(0, [Math]::Min($n, 50)))
        Assert-True ($h.Count -gt 0) 'historique annoncé mais illisible'
        Assert-True ($null -ne $h[0].Date -and $null -ne $h[0].ResultCode) 'entrée sans date ni résultat'
        "$n entrée(s)"
    }
    Test-Case 'Microsoft Store : recherche (sans installer)' {
        $r = Invoke-Spinner 'recherche Store' {
            param($QueryText)
            & ([scriptblock]::Create($QueryText)) -Mode 'Search' -TimeoutSec 150
        } 180 -ArgumentList ${function:Invoke-StoreQuery}.ToString()
        Assert-True ($null -ne $r) 'délai dépassé'
        Assert-True ($r.Ok) ('recherche impossible : ' + $r.Error)
        ('{0} mise(s) à jour proposée(s), mises à jour automatiques : {1}' -f @($r.Items).Count, $r.Auto)
    }
    Test-Case 'winget' {
        $wx = Get-WingetPath
        if ($script:WingetLookup -eq 'UNREADABLE') { throw 'paquets de Windows illisibles (Get-AppxPackage) : winget introuvable par son chemin complet' }
        if (-not $wx) { return 'SKIP:non installé' }
        $v = (& $wx --version 2>$null) | Select-Object -First 1
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
        $r = Get-EventsSafe @{ LogName = 'System'; Level = 1, 2; StartTime = (Get-Date).AddDays(-7) }
        Assert-True $r.Ok ('lecture impossible : ' + $r.Error)
        $none = Get-EventsSafe @{ LogName = 'Journal-Inexistant-JARVIS' }
        Assert-True (-not $none.Ok) 'journal absent lu comme « aucun événement »'
        ('lisible, {0} erreur(s) en 7 jours' -f @($r.Events).Count)
    }
    Test-Case 'Journal des disques branchés' {
        # Sert à reconnaître les erreurs d'un appareil débranché (section 10) ; illisible, elles restent en alerte
        $a = Get-DiskArrivals ((Get-Date).AddDays(-37))
        if ($null -eq $a) { return 'UNREAD:journal Partition/Diagnostic illisible, les erreurs disque restent toutes en alerte' }
        $p = @(Get-CimInstance Win32_DiskDrive -ErrorAction Stop)
        Assert-True ($p.Count -gt 0) 'aucun disque branché lu'
        $bad = @(@($a) | Where-Object { $null -eq $_.DiskNumber })
        Assert-True ($bad.Count -eq 0) ('{0} arrivée(s) sans numéro de disque' -f $bad.Count)
        ('{0} arrivée(s) de disque en 37 jours, {1} disque(s) branché(s)' -f @($a).Count, $p.Count)
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
    Test-Case 'Sécurité : UAC, SmartScreen, RDP' {
        $u = Get-UacState
        $s = Get-SmartScreenState
        $d = Get-RdpState
        Assert-True ($u -ne 'UNKNOWN') 'réglage UAC illisible dans le registre'
        Assert-True ($s -ne 'UNKNOWN') 'réglage SmartScreen illisible ou non reconnu'
        Assert-True ($d -ne 'UNKNOWN') 'réglage du Bureau à distance illisible'
        "UAC $u  //  SmartScreen $s  //  Bureau à distance $d"
    }
    Test-Case 'Sécurité : réglages de Defender' {
        $mp3 = Get-MpComputerStatus
        if (-not $mp3) {
            # Illisible : non applicable seulement si le Centre de sécurité montre un autre antivirus (v3.25, constat T4)
            if (Test-OtherAvListed) { return 'SKIP:Defender n''est pas l''antivirus en service' }
            return 'UNREAD:état de Defender illisible (Get-MpComputerStatus)'
        }
        if (-not $mp3.AntivirusEnabled) { return 'SKIP:Defender n''est pas l''antivirus en service' }
        $t = Get-OnOffVerdict $mp3.IsTamperProtected
        $pref = Get-MpPreference
        Assert-True ($null -ne $pref) 'préférences de Defender illisibles'
        $c = Get-CfaVerdict $pref.EnableControlledFolderAccess
        Assert-True ($t -ne 'UNKNOWN') 'protection contre les falsifications illisible'
        Assert-True ($c -ne 'UNKNOWN') 'accès contrôlé aux dossiers illisible'
        Assert-True ($mp3.QuickScanEndTime -is [datetime] -or $null -eq $mp3.QuickScanEndTime) 'date de fin d''analyse dans un format inattendu'
        $null = @(Get-MpThreatDetection -ErrorAction Stop)
        "falsification $t  //  accès contrôlé $c  //  détections lisibles"
    }
    Test-Case 'Sécurité : SMBv1, intégrité mémoire' {
        $s = Get-Smb1State
        $h = Get-HvciState
        Assert-True ($s -ne 'UNKNOWN') 'configuration du partage de fichiers illisible'
        Assert-True ($h -ne 'UNKNOWN') 'état de l''intégrité de la mémoire illisible'
        "SMBv1 $s  //  mémoire $h"
    }
    Test-Case 'Sécurité : comptes locaux du PC' {
        $a = Get-LocalAccountState
        Assert-True $a.Ok 'liste des comptes illisible'
        $adm = 'groupe Administrateurs illisible'
        if ($null -ne $a.Admins) { $adm = '{0} administrateur(s)' -f $a.Admins }
        ('{0} compte(s) actif(s), {1}' -f $a.Findings.Active, $adm)
    }
    Test-Case 'Sécurité : hosts, proxy, activation' {
        $h = Get-HostsState
        $p = Get-ProxyState
        $w = Get-ActivationState
        Assert-True $h.Ok 'fichier hosts illisible'
        Assert-True ($p.State -ne 'UNKNOWN') 'réglages de proxy illisibles'
        Assert-True ($w -ne 'UNKNOWN') 'état d''activation de Windows illisible'
        ('hosts : {0} redirection(s)  //  proxy {1}  //  Windows {2}' -f $h.Findings.Entries, $p.State, $w)
    }
    Test-Case 'Nettoyage : corbeille lisible' {
        $rb = Get-RecycleBinState
        Assert-True $rb.Ok 'contenu de la corbeille illisible'
        ('{0} élément(s), {1}' -f $rb.Count, (Format-Bytes $rb.Bytes))
    }
    Test-Case 'Nettoyage : optimisation de livraison' {
        $d = Get-DoCacheState
        Assert-True $d.Ok 'taille du cache illisible'
        Assert-True ($null -ne $d.Busy) 'téléchargements en cours illisibles'
        $est = Get-DoCacheEstimate
        Assert-True ($null -ne $est) 'liste des fichiers du cache illisible'
        $txt = 'estimation ' + (Format-Bytes $est)
        # Avec les droits admin, le dossier est mesuré : l'estimation affichée sans droits admin doit en être proche
        if ($isAdmin -and (Get-DoCacheDir)) {
            Assert-True $d.Exact 'dossier du cache illisible en administrateur'
            $gap = [math]::Abs([double]$d.Bytes - [double]$est)
            Assert-True ($gap -le [math]::Max([double]50MB, 0.1 * [double]$d.Bytes)) ('estimation {0}, dossier {1}' -f (Format-Bytes $est), (Format-Bytes $d.Bytes))
            $txt += ', dossier ' + (Format-Bytes $d.Bytes)
        }
        # Lire la taille ne suffit pas : sous Windows 10 22H2, le vidage est impossible (PC-LV, 21/11/2026) et le
        # scan ne doit alors pas le proposer
        if (Test-DoDeleteAvailable) { $txt += ' ; vidage possible' }
        else { $txt += ' ; vidage impossible sur ce Windows, non proposé par le scan' }
        $txt
    }
    Test-Case 'Composants Windows : tâche de nettoyage lisible' {
        $s = Get-CleanupTaskState
        $v = Get-CleanupTaskVerdict $s.State $s.LastRun $s.LastResult $s.Deadline (Get-Date)
        Assert-True ($v -ne 'UNKNOWN') 'tâche StartComponentCleanup de Windows illisible'
        $per = 'inconnue'
        if ($null -ne $s.Period) { $per = '{0:N0} j' -f $s.Period.TotalDays }
        ('{0}, dernier passage {1}, période {2}' -f $v, (Format-Date $s.LastRun), $per)
    }
    Test-Case 'Version de Windows : fin des correctifs lue sur ce PC' {
        # v3.28. Une version absente de la table (plus récente que ce JARVIS) n'est pas un échec : lecture impossible.
        $cv = Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' -ErrorAction Stop
        $v = Get-WindowsSupportVerdict $cv.CurrentBuild $cv.EditionID (Get-Date)
        if ($v.Kind -eq 'UNKNOWN') { return ('UNREAD:build {0}, édition {1} : {2}' -f $cv.CurrentBuild, $cv.EditionID, $v.Text) }
        ('build {0}, édition {1} : {2}' -f $cv.CurrentBuild, $cv.EditionID, $v.Text)
    }
    Test-Case 'Disques : tâche d''optimisation de Windows lisible' {
        $s = Get-OptimizeTaskState
        $v = Get-CleanupTaskVerdict $s.State $s.LastRun $s.LastResult ([TimeSpan]::FromDays(35)) (Get-Date)
        if ($v -eq 'UNKNOWN') { return 'UNREAD:tâche ScheduledDefrag de Windows illisible' }
        ('{0}, dernier passage {1}' -f $v, (Format-Date $s.LastRun))
    }
    Test-Case 'Composants Windows : analyse réelle' {
        # Le scan complet ne lance cette analyse que si Windows ne nettoie plus lui-même ses composants : l'auto-test
        # fait de même. Elle prenait 154 s sur 177 de l'auto-test du PC de Thomas (20/11/2026) et plus de 6 min sur
        # un PC moins rapide ; la lecture des messages de DISM reste vérifiée en T1 (textes EN/FR).
        $s = Get-CleanupTaskState
        $v = Get-CleanupTaskVerdict $s.State $s.LastRun $s.LastResult $s.Deadline (Get-Date)
        if ($v -eq 'OK' -or $v -eq 'RUNNING') { return 'SKIP:Windows nettoie lui-même ses composants, le scan ne lance pas cette analyse' }
        $ci = Invoke-ComponentAnalysis
        Assert-True ($null -ne $ci) 'DISM n''a pas répondu à temps'
        if ($ci.Code -ne 0 -and (Get-ComponentCleanupVerdict '' $ci.Code) -eq 'PENDING') { return 'SKIP:mises à jour en attente d''un redémarrage' }
        Assert-True ($ci.Code -eq 0) ('code de sortie ' + $ci.Code)
        Assert-True ($null -ne $ci.Recommended) 'message de DISM non reconnu (langue de Windows autre que français ou anglais ?)'
        ('nettoyage conseillé : {0}, taille réelle {1}, sauvegardes {2}' -f $ci.Recommended, (Format-Bytes $ci.ActualBytes), (Format-Bytes $ci.BackupBytes))
    } -NeedAdmin
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
            # v3.25 (constat T4) : sans réponse, la recherche de version est en échec (connexion, TLS), pas « non applicable »
            'OFFLINE'  { 'UNREAD:' + $u.Detail + ', le menu [U] ne proposera pas les nouvelles versions' }
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
        if ($null -eq $pref) {
            if (Test-OtherAvListed) { return 'SKIP:Defender n''est pas l''antivirus en service' }
            return 'UNREAD:réglages de Defender illisibles (Get-MpPreference)'
        }
        $docs = [Environment]::GetFolderPath('MyDocuments')
        $od = ''
        if ($docs -match 'OneDrive') { $od = '  //  Documents dans OneDrive' }
        # Règle 24 : [int]$null vaudrait 0, soit « inactif », pour une valeur illisible (v3.25)
        switch (ConvertTo-IntOrNull $pref.EnableControlledFolderAccess) {
            $null { 'UNREAD:valeur EnableControlledFolderAccess absente' }
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
    # v3.25 (audit, constat T5) : les garde-fous purs (chemins Temp et d'installation, prénom, versions, mises à jour
    # Windows exclues) sont passés en T1, donc contrôlés avant chaque fabrication et sur GitHub
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
        & (Get-SystemToolPath 'cmd.exe') /c ('mklink /J "{0}" "{1}"' -f $j, $outside) | Out-Null
        try {
            Assert-True (Test-Path -LiteralPath $j) 'jonction de test non créée'
            $r = Clear-TempFolder $sand 24
            Assert-True $r.Ok 'nettoyage refusé'
            Assert-True (-not (Test-Path -LiteralPath $old)) 'fichier ancien non supprimé'
            Assert-True (Test-Path -LiteralPath $new) 'fichier récent supprimé à tort'
            Assert-True (Test-Path -LiteralPath $keep) 'jonction suivie : fichier extérieur supprimé'
        } finally {
            if (Test-Path -LiteralPath $j) { [IO.Directory]::Delete($j, $false) }
            if (-not (Test-Path -LiteralPath $j)) { $null = Remove-TreeNoJunction $root }
        }
        'ancien supprimé, récent et jonction préservés'
    }
    Test-Case 'Temp : nettoyage par un chemin au format court' {
        # %TEMP% vaut parfois C:\Users\MARIED~1\AppData\Local\Temp (nom de compte long ou avec espace)
        $root = Join-Path $env:TEMP ('jarvis dossier long ' + [guid]::NewGuid().ToString('N').Substring(0, 8))
        $sand = Join-Path $root 'Temp'
        New-Item -ItemType Directory -Path $sand -Force -ErrorAction Stop | Out-Null
        try {
            $short = [string](New-Object -ComObject Scripting.FileSystemObject).GetFolder($root).ShortPath
            if (-not $short -or $short -eq $root) { return 'SKIP:noms courts désactivés sur ce disque' }
            $old = Join-Path $sand 'ancien.tmp'
            Set-Content -Path $old -Value 'x'
            (Get-Item -LiteralPath $old).LastWriteTime = (Get-Date).AddDays(-3)
            $r = Clear-TempFolder (Join-Path $short 'Temp') 24
            Assert-True $r.Ok ('nettoyage refusé : ' + $r.Reason)
            Assert-True (-not (Test-Path -LiteralPath $old)) 'fichier ancien non supprimé par le chemin court'
        } finally {
            $null = Remove-TreeNoJunction $root
        }
        'fichier ancien supprimé'
    }
    Test-Case 'Temp : dossier remplacé par une jonction' {
        # Entre la liste et la suppression, un sous-dossier listé devient une jonction vers un dossier à protéger :
        # sans contrôle juste avant la suppression, le fichier du même nom serait détruit de l'autre côté
        $root = Join-Path $env:TEMP ('jarvis_course_' + [guid]::NewGuid().ToString('N').Substring(0, 8))
        $sand = Join-Path $root 'Temp'
        $sub = Join-Path $sand 'sous-dossier'
        $outside = Join-Path $root 'Protege'
        New-Item -ItemType Directory -Path $sub -Force -ErrorAction Stop | Out-Null
        New-Item -ItemType Directory -Path $outside -Force -ErrorAction Stop | Out-Null
        $victim = Join-Path $sub 'vieux.tmp'
        $keep = Join-Path $outside 'vieux.tmp'
        Set-Content -Path $victim -Value 'x'; Set-Content -Path $keep -Value 'precieux'
        (Get-Item -LiteralPath $victim).LastWriteTime = (Get-Date).AddDays(-3)
        try {
            $cand = Get-TempCandidates $sand 24
            Assert-True (@($cand.Files).Count -eq 1) 'fichier ancien non listé'
            [IO.File]::Delete($victim)
            [IO.Directory]::Delete($sub, $false)
            & (Get-SystemToolPath 'cmd.exe') /c ('mklink /J "{0}" "{1}"' -f $sub, $outside) | Out-Null
            Assert-True (Test-Path -LiteralPath $victim) 'jonction de test non créée'
            $done = Remove-TempCandidates $sand $cand
            Assert-True (Test-Path -LiteralPath $keep) 'fichier extérieur supprimé à travers la jonction'
            Assert-True ($done.Skipped -ge 1) 'chemin détourné non écarté'
        } finally {
            $null = Remove-TreeNoJunction $root
        }
        'chemin détourné écarté, fichier extérieur intact'
    }
    Test-Case 'Ancienne installation derrière une jonction (S6)' {
        # Comme C:\Outils\JARVIS, que tout compte peut créer : un dossier au-dessus remplacé par une jonction mène ailleurs
        if (-not (Test-NoLinkUpward $env:TEMP)) { return 'SKIP:dossier temporaire lui-même derrière un lien' }
        $root = Join-Path $env:TEMP ('jarvis_ancien_' + [guid]::NewGuid().ToString('N').Substring(0, 8))
        $real = Join-Path $root 'Outils\JARVIS'
        $link = Join-Path $root 'Lien'
        New-Item -ItemType Directory -Path $real -Force -ErrorAction Stop | Out-Null
        try {
            & (Get-SystemToolPath 'cmd.exe') /c ('mklink /J "{0}" "{1}"' -f $link, (Join-Path $root 'Outils')) | Out-Null
            Assert-True (Test-Path -LiteralPath (Join-Path $link 'JARVIS')) 'jonction de test non créée'
            Assert-True (Test-NoLinkUpward $real) 'dossier normal refusé'
            Assert-True (-not (Test-NoLinkUpward (Join-Path $link 'JARVIS'))) 'dossier derrière une jonction accepté'
            Assert-True (-not (Test-NoLinkUpward $link)) 'jonction elle-même acceptée'
            Assert-True (-not (Test-NoLinkUpward (Join-Path $root 'absent'))) 'dossier absent accepté'
            # Élément de l'installation remplacé par une jonction (vers un dossier plein) ou par un dossier
            $f = Join-Path $real 'JARVIS.cmd'
            [IO.File]::WriteAllText($f, 'x')
            $target = Join-Path $root 'Cible'
            New-Item -ItemType Directory -Path $target -Force -ErrorAction Stop | Out-Null
            [IO.File]::WriteAllText((Join-Path $target 'garde.txt'), 'x')
            & (Get-SystemToolPath 'cmd.exe') /c ('mklink /J "{0}" "{1}"' -f (Join-Path $real '.jarvis-install'), $target) | Out-Null
            New-Item -ItemType Directory -Path (Join-Path $real 'jarvis-checkup.ps1') -Force -ErrorAction Stop | Out-Null
            Assert-True (Test-PlainFile $f) 'vrai fichier refusé'
            Assert-True (-not (Test-PlainFile (Join-Path $real '.jarvis-install'))) 'jonction prise pour un fichier'
            Assert-True (-not (Test-PlainFile (Join-Path $real 'jarvis-checkup.ps1'))) 'dossier pris pour un fichier'
            Assert-True (-not (Test-PlainFile (Join-Path $real 'absent.cmd'))) 'fichier absent accepté'
        } finally {
            $null = Remove-TreeNoJunction $root
        }
        'jonctions repérées (dossier et élément), dossier normal accepté'
    }
    Test-Case 'Nettoyage étendu : liste blanche' {
        # Lecture seule : aucun vrai dossier n'est vidé ici (règle 18)
        $real = Get-CleanTargetPaths
        Assert-True (@($real.Keys).Count -eq 4) ('cibles calculées : ' + (@($real.Keys) -join ', '))
        $win = [Environment]::GetFolderPath('Windows')
        $bad = @($win, (Join-Path $win 'SoftwareDistribution'), (Join-Path $win 'System32'), ([IO.Path]::GetPathRoot($win)),
                 $env:USERPROFILE, $env:TEMP, '', 'SoftwareDistribution\Download', '..\SoftwareDistribution\Download',
                 '\\serveur\partage\Download')
        foreach ($p in $bad) { Assert-True (-not (Test-SafeCleanTarget $p)) ('accepté à tort : ' + $p) }
        $n = $bad.Count
        if (Test-Path -LiteralPath $real['WuCache']) {
            Assert-True (Test-SafeCleanTarget $real['WuCache']) 'cache Windows Update refusé à tort'
            Assert-True (Test-SafeCleanTarget ($real['WuCache'] + '\')) 'barre finale refusée à tort'
            Assert-True (-not (Test-SafeCleanTarget (Join-Path $real['WuCache'] 'sous-dossier'))) 'sous-dossier accepté'
        }
        ('4 cibles, {0} refus' -f $n)
    }
    Test-Case 'Nettoyage étendu : bac à sable' {
        $root = Join-Path $env:TEMP ('jarvis_cible_' + [guid]::NewGuid().ToString('N').Substring(0, 8))
        $win = Join-Path $root 'Windows'
        $outside = Join-Path $root 'Protege'
        $paths = [ordered]@{
            WuCache    = (Join-Path $win 'SoftwareDistribution\Download')
            Minidump   = (Join-Path $win 'Minidump')
            MemoryDump = (Join-Path $win 'MEMORY.DMP')
            CrashDumps = (Join-Path $root 'Local\CrashDumps')
        }
        foreach ($d in @((Join-Path $paths.WuCache 'a1b2'), $paths.Minidump, $paths.CrashDumps, $outside)) {
            New-Item -ItemType Directory -Path $d -Force -ErrorAction Stop | Out-Null
        }
        $old = (Get-Date).AddDays(-40)
        $mk = { param($File, $When) Set-Content -LiteralPath $File -Value 'x'; if ($When) { (Get-Item -LiteralPath $File).LastWriteTime = $When } }
        & $mk (Join-Path $paths.WuCache 'a1b2\maj.cab') $null          # récent : le cache se vide en entier
        & $mk (Join-Path $paths.Minidump 'ancien.dmp') $old
        & $mk (Join-Path $paths.Minidump 'recent.dmp') $null
        & $mk (Join-Path $paths.Minidump 'notes.txt') $old             # pas un vidage : gardé
        & $mk $paths.MemoryDump $old
        & $mk (Join-Path $paths.CrashDumps 'appli.exe.1234.dmp') $old
        $keep = Join-Path $outside 'precieux.dmp'
        & $mk $keep $old
        $j = Join-Path $paths.WuCache 'lien'
        & (Get-SystemToolPath 'cmd.exe') /c ('mklink /J "{0}" "{1}"' -f $j, $outside) | Out-Null
        try {
            Assert-True (Test-Path -LiteralPath (Join-Path $j 'precieux.dmp')) 'jonction de test non créée'
            $one = [int64](Get-Item -LiteralPath $keep).Length
            $fb = Measure-FolderBounded $win 30
            Assert-True ($fb.Complete -and $fb.Bytes -eq 5 * $one) ('mesure du dossier : {0} octets, complète {1}' -f $fb.Bytes, $fb.Complete)
            Assert-True (-not (Measure-FolderBounded $win 0).Complete) 'mesure arrêtée annoncée complète'
            $w = Clear-CleanTarget 'WuCache' 0 '' $paths
            Assert-True ($w.Ok -and $w.LeftBytes -eq 0 -and $w.FreedBytes -eq $one) ('cache non vidé : ' + $w.Reason)
            Assert-True (-not (Test-Path -LiteralPath (Join-Path $paths.WuCache 'a1b2'))) 'sous-dossier du cache laissé'
            Assert-True (Test-Path -LiteralPath $keep) 'jonction suivie : fichier extérieur supprimé'
            $m = Clear-CleanTarget 'Minidump' 720 '.dmp' $paths
            Assert-True ($m.Ok -and $m.FreedBytes -eq $one) ('vidages refusés : ' + $m.Reason)
            Assert-True (-not (Test-Path -LiteralPath (Join-Path $paths.Minidump 'ancien.dmp'))) 'vidage ancien non supprimé'
            Assert-True (Test-Path -LiteralPath (Join-Path $paths.Minidump 'recent.dmp')) 'vidage récent supprimé'
            Assert-True (Test-Path -LiteralPath (Join-Path $paths.Minidump 'notes.txt')) 'fichier autre qu''un vidage supprimé'
            $f = Clear-CleanTarget 'MemoryDump' 720 '.dmp' $paths
            Assert-True ($f.Ok -and $f.FreedBytes -eq $one -and -not (Test-Path -LiteralPath $paths.MemoryDump)) 'MEMORY.DMP ancien non supprimé'
            $c = Clear-CleanTarget 'CrashDumps' 720 '.dmp' $paths
            Assert-True ($c.Ok -and $c.FreedBytes -eq $one) 'vidage d''application non supprimé'
            Assert-True (-not (Clear-CleanTarget 'Inconnue' 0 '' $paths).Ok) 'cible hors liste acceptée'
        } finally {
            if (Test-Path -LiteralPath $j) { [IO.Directory]::Delete($j, $false) }
            if (-not (Test-Path -LiteralPath $j)) { $null = Remove-TreeNoJunction $root }
        }
        '4 cibles nettoyées ; jonction, fichiers récents et autres fichiers préservés'
    }
    Test-Case 'Nettoyage étendu : cible remplacée par une jonction' {
        $root = Join-Path $env:TEMP ('jarvis_lien_' + [guid]::NewGuid().ToString('N').Substring(0, 8))
        $outside = Join-Path $root 'Protege'
        $mini = Join-Path $root 'Windows\Minidump'
        $par = Join-Path $root 'Parent'
        New-Item -ItemType Directory -Path (Join-Path $outside 'CrashDumps') -Force -ErrorAction Stop | Out-Null
        New-Item -ItemType Directory -Path (Split-Path -Parent $mini) -Force -ErrorAction Stop | Out-Null
        $keep = Join-Path $outside 'ancien.dmp'
        $keep2 = Join-Path $outside 'CrashDumps\ancien.dmp'
        foreach ($k in @($keep, $keep2)) {
            Set-Content -LiteralPath $k -Value 'x'
            (Get-Item -LiteralPath $k).LastWriteTime = (Get-Date).AddDays(-40)
        }
        $cmd = Get-SystemToolPath 'cmd.exe'
        & $cmd /c ('mklink /J "{0}" "{1}"' -f $mini, $outside) | Out-Null
        & $cmd /c ('mklink /J "{0}" "{1}"' -f $par, $outside) | Out-Null
        try {
            Assert-True ((Test-Path -LiteralPath (Join-Path $mini 'ancien.dmp')) -and (Test-Path -LiteralPath (Join-Path $par 'CrashDumps'))) 'jonctions de test non créées'
            $paths = [ordered]@{ Minidump = $mini; CrashDumps = (Join-Path $par 'CrashDumps') }
            Assert-True (-not (Test-SafeCleanTarget $mini @($paths.Values))) 'jonction acceptée comme cible'
            Assert-True (-not (Test-SafeCleanTarget $paths.CrashDumps @($paths.Values))) 'cible sous un dossier-jonction acceptée'
            Assert-True (-not (Clear-CleanTarget 'Minidump' 720 '.dmp' $paths).Ok) 'nettoyage accepté à travers une jonction'
            Assert-True (-not (Clear-CleanTarget 'CrashDumps' 720 '.dmp' $paths).Ok) 'nettoyage accepté sous un dossier-jonction'
            Assert-True ((Test-Path -LiteralPath $keep) -and (Test-Path -LiteralPath $keep2)) 'fichier extérieur supprimé'
            $m = Measure-AgedFiles $mini 720 '.dmp'
            Assert-True ($m.Ok -and $m.Link -and $m.AgedBytes -eq 0) 'jonction comptée dans la mesure'
        } finally {
            foreach ($l in @($mini, $par)) { if (Test-Path -LiteralPath $l) { [IO.Directory]::Delete($l, $false) } }
            if (-not (Test-Path -LiteralPath $mini) -and -not (Test-Path -LiteralPath $par)) { $null = Remove-TreeNoJunction $root }
        }
        'jonctions refusées, fichiers extérieurs intacts'
    }
    Test-Case 'Désinstallation : suppression sans suivre les jonctions' {
        $root = Join-Path $env:TEMP ('jarvis_arbre_' + [guid]::NewGuid().ToString('N').Substring(0, 8))
        $tree = Join-Path $root 'JARVIS'
        $outside = Join-Path $root 'Protege'
        New-Item -ItemType Directory -Path (Join-Path $tree 'Rapports') -Force -ErrorAction Stop | Out-Null
        New-Item -ItemType Directory -Path $outside -Force -ErrorAction Stop | Out-Null
        $keep = Join-Path $outside 'precieux.txt'
        $ro = Join-Path $tree 'lecture-seule.txt'
        Set-Content -Path (Join-Path $tree 'config.json') -Value 'x'
        Set-Content -Path (Join-Path $tree 'Rapports\checkup_20260101_1200.txt') -Value 'x'
        Set-Content -Path $ro -Value 'x'; Set-Content -Path $keep -Value 'x'
        (Get-Item -LiteralPath $ro).IsReadOnly = $true
        $j = Join-Path $tree 'lien'
        & (Get-SystemToolPath 'cmd.exe') /c ('mklink /J "{0}" "{1}"' -f $j, $outside) | Out-Null
        try {
            Assert-True (Test-Path -LiteralPath (Join-Path $j 'precieux.txt')) 'jonction de test non créée'
            Assert-True (Remove-TreeNoJunction $tree) 'dossier non supprimé en entier'
            Assert-True (Test-Path -LiteralPath $keep) 'jonction suivie : fichier extérieur supprimé'
        } finally {
            $null = Remove-TreeNoJunction $root
        }
        'dossier supprimé, cible de la jonction intacte'
    }
    Test-Case 'Installation : dossier modifiable refusé' {
        # Dossier du profil : n'importe quel programme peut y écrire, JARVIS (lancé en administrateur) n'y va pas
        $base = Join-Path $env:LOCALAPPDATA ('jarvis_garde_' + [guid]::NewGuid().ToString('N').Substring(0, 8))
        try {
            $r = Confirm-InstallDir $base
            Assert-True (-not $r.Ok) 'dossier du profil accepté'
            Assert-True ($r.Reason -match 'modifiable') ('refusé pour une autre raison : ' + $r.Reason)
            Assert-True (-not (Test-Path -LiteralPath $base)) 'dossier d''essai laissé en place'
        } finally {
            if (Test-Path -LiteralPath $base) { $null = Remove-TreeNoJunction $base }
        }
        Assert-True (@(Get-WeakWriters @($env:ProgramFiles)).Count -eq 0) 'Program Files vu comme modifiable sans droits admin'
        'refusé avant toute copie, dossier d''essai retiré'
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
    $warn = @($results | Where-Object { $_.State -eq 'WARN' }).Count
    $skip = @($results | Where-Object { $_.State -eq 'SKIP' }).Count

    Write-Host ''
    Write-Host ('  ╔' + ('═' * 64) + '╗') -ForegroundColor Cyan
    Write-Host '  ║' -NoNewline -ForegroundColor Cyan
    Write-Host ('  BILAN DE L''AUTO-TEST'.PadRight(64)) -NoNewline -ForegroundColor White
    Write-Host '║' -ForegroundColor Cyan
    Write-Host ('  ╚' + ('═' * 64) + '╝') -ForegroundColor Cyan
    $col = 'Green'
    if ($fail -gt 0) { $col = 'Red' } elseif ($warn -gt 0) { $col = 'Yellow' }
    Write-Host ("   Réussis : {0}   //   Échecs : {1}   //   Lectures impossibles : {2}   //   Ignorés : {3}" -f $pass, $fail, $warn, $skip) -ForegroundColor $col
    foreach ($r in ($results | Where-Object { $_.State -eq 'FAIL' })) {
        Write-Host ('   ! {0} : {1}' -f $r.Name, $r.Detail) -ForegroundColor Red
    }
    foreach ($r in ($results | Where-Object { $_.State -eq 'WARN' })) {
        Write-Host ('   ? {0} : {1}' -f $r.Name, $r.Detail) -ForegroundColor Yellow
    }
    if ($fail -gt 0) {
        Type-Line '   >> Certains composants ne sont pas fiables sur ce PC. Les sections concernées peuvent donner des résultats faux ou incomplets.' 'Red'
    } elseif ($warn -gt 0) {
        Type-Line '   >> Les composants testés fonctionnent, mais certaines lectures ont échoué : le scan affichera « lecture impossible » pour ces points.' 'Yellow'
    } elseif ($skip -gt 0) {
        Type-Line '   >> Tous les composants testés fonctionnent. Les tests ignorés dépendent des droits ou de l''équipement.' 'Green'
    } else {
        Type-Line '   >> Tous les composants de J.A.R.V.I.S. sont opérationnels sur ce PC.' 'Green'
    }

    $head = @('J.A.R.V.I.S. // Auto-test', ('Date : {0}   Hôte : {1}   Admin : {2}' -f (Get-Date -Format 'yyyy-MM-dd HH:mm'), $env:COMPUTERNAME, $isAdmin), '')
    $null = Save-Report 'selftest' ([string[]]($head + $log + @('', ("Réussis {0} / Échecs {1} / Lectures impossibles {2} / Ignorés {3}" -f $pass, $fail, $warn, $skip))))

    return $fail
}

function Get-BtRadioVerdict($Devices, [string]$ErrorCategory) {
    # Puce Bluetooth d'après Get-PnpDevice -Class Bluetooth -PresentOnly : State = 'RADIO' (Radio = l'appareil),
    # 'NONE' ou 'UNKNOWN' (lecture impossible). $ErrorCategory : catégorie de l'erreur levée, ou vide. Windows dit
    # « aucun appareil de cette classe » par une erreur ObjectNotFound (PC sans Bluetooth, capture du 19/11/2026) :
    # c'est une lecture réussie. La puce a un identifiant USB\ ou PCI\ ; les autres entrées Bluetooth sont des
    # services (ceux du téléphone, par exemple). Fonction pure, testée en T1.
    if ($ErrorCategory) {
        if ($ErrorCategory -eq 'ObjectNotFound') { return [pscustomobject]@{ State = 'NONE'; Radio = $null } }
        return [pscustomobject]@{ State = 'UNKNOWN'; Radio = $null }
    }
    $r = @(@($Devices) | Where-Object { $null -ne $_ -and ([string]$_.InstanceId -like 'USB\*' -or [string]$_.InstanceId -like 'PCI\*') })
    if ($r.Count -eq 0) { return [pscustomobject]@{ State = 'NONE'; Radio = $null } }
    return [pscustomobject]@{ State = 'RADIO'; Radio = $r[0] }
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

# ------------------------------------------------------------------
# Droits administrateur
# ------------------------------------------------------------------
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator)

try {
$placed = $false
if ($WinRect) { $placed = Set-ConsoleRect $WinRect }
if (-not $placed) {
    $null = Set-ConsoleClassicSize
    $null = Set-ConsoleFontBigger
    $null = Set-ConsoleTall
} else {
    # Relance administrateur depuis Windows Terminal : l'ancienne console reprend la fenêtre d'avant, mais avec la
    # police « Terminal » 8 x 12 (capture du 19/11/2026 sur un écran 1920 x 1080 : 134 colonnes x 82 lignes de
    # petites lettres). Même police agrandie que par les raccourcis (essai : Consolas 20, 119 x 49).
    $null = Set-ConsoleFontBigger
}
Clear-Host
Show-Banner
if ($script:ArgRefused) {
    Write-Host ('   [!] Options de lancement non reconnues, toutes ignorées : ' + (Cut (Remove-ControlChars $script:ArgRefused) 40)) -ForegroundColor Yellow
    Write-Host '       J.A.R.V.I.S. démarre normalement. Options possibles : JARVIS.cmd -Quick, -Deep, -SelfTest, -Update...' -ForegroundColor DarkGray
}
if ($Name) { $Name = [string](Get-SafeName $Name) }
if ($ResetChoices) {
    if (Set-JarvisConfigValue 'WingetModule' $null) {
        Write-Host '   >> Choix mémorisés effacés : les propositions facultatives réapparaîtront.' -ForegroundColor DarkGray
    }
}

$null = Set-QuickEdit $true   # un clic dans l'ancienne console ne gèle plus JARVIS
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
            if ($null -eq $cmpV) {
                Write-Host ("   [!] Une installation de J.A.R.V.I.S. existe dans {0}, mais sa version est illisible." -f $inst.Dir) -ForegroundColor Yellow
                Write-Host ("   [1] Réinstaller la v{0} par-dessus (recommandé)   prénom, rapports et raccourcis conservés" -f $JarvisVersion) -ForegroundColor Gray
                Write-Host '   [2] Lancer cette copie sans installer' -ForegroundColor Gray
                Write-Host '   [Échap] Quitter' -ForegroundColor DarkGray
                $c = Read-Choice '   >> Choix [1/2] (Entrée = 1)' @('1', '2') '1'
                if ($null -eq $c) { $choice = 'quit' } elseif ($c -eq '2') { $choice = 'run' } else { $choice = 'install' }
            } elseif ($cmpV -gt 0) {
                Write-Host ("   MISE À JOUR DISPONIBLE : v{0} installée, cette copie est la v{1}." -f $inst.Version, $JarvisVersion) -ForegroundColor Cyan
                Write-Host '   [1] Mettre à jour (recommandé)   prénom, rapports et raccourcis conservés' -ForegroundColor Gray
                Write-Host ("   [2] Lancer la version installée (v{0})" -f $inst.Version) -ForegroundColor Gray
                Write-Host '   [3] Lancer cette copie sans installer' -ForegroundColor Gray
                Write-Host '   [Échap] Quitter' -ForegroundColor DarkGray
                $c = Read-Choice '   >> Choix [1/2/3] (Entrée = 1)' @('1', '2', '3') '1'
                if ($null -eq $c) { $choice = 'quit' } elseif ($c -eq '2') { $choice = 'launch' } elseif ($c -eq '3') { $choice = 'run' } else { $choice = 'install' }
            } elseif ($cmpV -eq 0) {
                Write-Host ("   Cette version (v{0}) est déjà installée dans {1}." -f $JarvisVersion, $inst.Dir) -ForegroundColor Cyan
                Write-Host '   [1] Lancer la version installée (recommandé)' -ForegroundColor Gray
                Write-Host '   [2] Réinstaller (répare l''installation et les raccourcis)' -ForegroundColor Gray
                Write-Host '   [3] Lancer cette copie sans installer' -ForegroundColor Gray
                Write-Host '   [Échap] Quitter' -ForegroundColor DarkGray
                $c = Read-Choice '   >> Choix [1/2/3] (Entrée = 1)' @('1', '2', '3') '1'
                if ($null -eq $c) { $choice = 'quit' } elseif ($c -eq '2') { $choice = 'install' } elseif ($c -eq '3') { $choice = 'run' } else { $choice = 'launch' }
            } else {
                Write-Host ("   [!] Cette copie (v{0}) est PLUS ANCIENNE que la version installée (v{1})." -f $JarvisVersion, $inst.Version) -ForegroundColor Yellow
                Write-Host '       Elle ne remplacera pas la version installée.' -ForegroundColor Yellow
                Write-Host ("   [1] Lancer la version installée v{0} (recommandé)" -f $inst.Version) -ForegroundColor Gray
                Write-Host '   [2] Lancer quand même cette ancienne copie, sans installer' -ForegroundColor Gray
                Write-Host '   [Échap] Quitter' -ForegroundColor DarkGray
                $c = Read-Choice '   >> Choix [1/2] (Entrée = 1)' @('1', '2') '1'
                if ($null -eq $c) { $choice = 'quit' } elseif ($c -eq '2') { $choice = 'run' } else { $choice = 'launch' }
            }
        } else {
            Write-Host '   J.A.R.V.I.S. n''est pas encore installé sur ce PC.' -ForegroundColor Cyan
            Write-Host '   [1] Installer (recommandé)   C:\Program Files\JARVIS + raccourci menu Démarrer' -ForegroundColor Gray
            Write-Host '   [2] Lancer sans installer' -ForegroundColor Gray
            Write-Host '   [Échap] Quitter' -ForegroundColor DarkGray
            $c = Read-Choice '   >> Choix [1/2] (Entrée = 1)' @('1', '2') '1'
            if ($null -eq $c) { $choice = 'quit' } elseif ($c -eq '2') { $choice = 'run' } else { $choice = 'install' }
        }
    } elseif ($inst -and (Compare-JarvisVersion $JarvisVersion $inst.Version) -eq -1) {
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
        if ($InstallDir -and (Test-SafeArgValue $InstallDir)) { $ia += " -InstallDir `"$InstallDir`"" }
        elseif ($InstallDir) { Write-Host '   [!] Dossier demandé ignoré (caractères non pris en charge) : le dossier te sera proposé.' -ForegroundColor Yellow }
        $ia += Get-WinRectArg
        Write-Host '   >> Validation administrateur requise pour installer dans Program Files.' -ForegroundColor Cyan
        if (Start-Elevated $JarvisSelf $ia) { exit }
        Write-Host '   >> Installation annulée. Lancement sans installation.' -ForegroundColor DarkGray
        $choice = 'run'
    }
    if ($choice -eq 'install') {
        Write-Host ''
        $target = $null
        if ($inst) { $target = $inst.Dir }
        $dest = Install-Jarvis -TargetDir $target -OldDir $target
        if ($dest) {
            Write-Host ''
            if (Read-YesNo '   >> Lancer J.A.R.V.I.S. maintenant ?' -DefaultYes) {
                # Version tout juste installée, donc la même : elle connaît -WinRect
                if (-not (Start-Elevated $dest ((Get-WinRectArg).Trim()))) {
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
    if (Read-YesNo '   >> Relancer en mode administrateur ?' -DefaultYes) {
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
        $argList += Get-WinRectArg
        $okUac = $false
        if ($JarvisSelf -like '*.cmd') { $okUac = Start-Elevated $JarvisSelf $argList.Trim() }
        else { $okUac = Start-Elevated (Get-SystemToolPath 'WindowsPowerShell\v1.0\powershell.exe') ("-NoProfile -ExecutionPolicy Bypass -File `"$JarvisSelf`"" + $argList) }
        if ($okUac) { exit }
        Write-Host '   >> Poursuite sans droits administrateur : contrôles réduits, scan complet indisponible.' -ForegroundColor DarkGray
    }
}

# ------------------------------------------------------------------
# Choix du mode
# ------------------------------------------------------------------

$script:RunSelfTest = $false
# v3.27 : un scan complet refusé (non, Échap, droits absents) ramène au menu au lieu de lancer le scan rapide
# sans le demander (retour d'un utilisateur, 25/11/2026). Lancé par -Deep, le refus ouvre aussi le menu.
$showMenu = $false
if ($SelfTest) {
    $script:RunSelfTest = $true
} elseif ($Deep) {
    $script:DeepMode = $true
} elseif (-not $Quick) {
    $showMenu = $true
}
$modeOk = $false
while (-not $modeOk) {
    if ($showMenu) {
        $script:DeepMode = $false
        Write-Host '   SÉLECTION DU PROTOCOLE' -ForegroundColor Cyan
        Write-Host '   [1] Scan rapide    ~2-5 min    état, mises à jour, pilotes, sécurité, journaux' -ForegroundColor Gray
        Write-Host '   [2] Scan complet   ~20-60 min  tout le scan rapide + DISM, SFC /scannow, CHKDSK' -ForegroundColor Gray
        Write-Host '   [3] Auto-test      ~1-5 min    vérifie que JARVIS fonctionne correctement sur ce PC' -ForegroundColor Gray
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
            $k
        }
        # Seules les touches affichées sont acceptées ; Entrée lance le scan rapide
        $keys = @(& $buildKeys)
        $m = Read-Choice ('   >> Protocole [' + ($keys -join '/') + '] (Entrée = 1)') $keys '1'
        if ($null -eq $m) { exit }
        while ($m -eq 'R' -or $m -eq 'M' -or $m -eq 'U') {
            if ($m -eq 'R') {
                $rd = Get-ReportDir
                if ($rd) { Start-Process -FilePath (Join-Path $WinDir 'explorer.exe') -ArgumentList ('"{0}"' -f $rd) }
                else { Write-Host '   [!] Aucun dossier de rapports accessible.' -ForegroundColor Yellow }
            } elseif ($m -eq 'U') {
                Invoke-JarvisSelfUpdate $upd.Info      # ne revient ici qu'en cas d'annulation ou d'échec
                Write-Host ''
            } else {
                Invoke-WingetModuleOffer
                $showM = Test-ShowWingetOffer
                $keys = @(& $buildKeys)
            }
            $m = Read-Choice ('   >> Protocole [' + ($keys -join '/') + '] (Entrée = 1)') $keys '1'
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
    $modeOk = $true
    if ($script:DeepMode -and -not $isAdmin) {
        Write-Host '   [!] Le scan complet exige les droits administrateur.' -ForegroundColor Yellow
        Write-Host '       Ferme J.A.R.V.I.S., relance-le et réponds O à « Relancer en mode administrateur ? ».' -ForegroundColor Yellow
        Write-Host ''
        $script:DeepMode = $false
        $showMenu = $true
        $modeOk = $false
    } elseif ($script:DeepMode) {
        $dc = Confirm-DeepScan
        if ($dc -eq 'QUICK') {
            Write-Host '   >> Scan rapide, comme demandé.' -ForegroundColor DarkGray
            $script:DeepMode = $false
        } elseif ($dc -ne 'GO') {
            Write-Host '   >> Scan complet annulé : retour au menu.' -ForegroundColor DarkGray
            Write-Host ''
            $script:DeepMode = $false
            $showMenu = $true
            $modeOk = $false
        }
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

$script:Report.Add(('J.A.R.V.I.S. v{0} // Rapport de check-up' -f $JarvisVersion))
$script:Report.Add(('Date : {0}   Hôte : {1}   Admin : {2}   Protocole : {3}' -f (Get-Date -Format 'yyyy-MM-dd HH:mm'), $env:COMPUTERNAME, $adminTxt, $modeTxt))

# ==================================================================
# [01] SYSTÈME
# ==================================================================
Write-Section '01' 'Système'

$os = Get-CimInstance Win32_OperatingSystem
$cv = Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion'
Write-Status 'Système' ('{0} {1}' -f $os.Caption, $cv.DisplayVersion) 'INFO'
Write-Status 'Numéro de version (build)' ('{0}.{1}' -f $cv.CurrentBuild, $cv.UBR) 'INFO'
# v3.28 : fin des correctifs selon la version exacte et l'édition (avant : Windows 10 seulement, texte figé)
$winSup = Get-WindowsSupportVerdict $cv.CurrentBuild $cv.EditionID (Get-Date)
Write-Status 'Correctifs de sécurité Windows' $winSup.Text $winSup.State
foreach ($l in @($winSup.Subs)) { Write-Sub $l }
$isLaptop = [bool](Get-CimInstance Win32_Battery)
$typeTxt = 'PC fixe'
if ($isLaptop) { $typeTxt = 'PC portable' }
$cs = Get-CimInstance Win32_ComputerSystem
Write-Status 'Machine' ('{0}  //  {1}' -f $typeTxt, (Get-MachineLabel $cs.Manufacturer $cs.Model)) 'INFO'

if ($os -and $os.LastBootUpTime) {
    # v3.23 (audit, constat V10) : « Uptime » remplacé, et le conseil dit pourquoi « Arrêter » ne suffit pas
    $up = (Get-Date) - $os.LastBootUpTime
    $upTxt = 'il y a {0} j {1} h {2} min' -f $up.Days, $up.Hours, $up.Minutes
    if ($up.TotalDays -gt 7) {
        Write-Status 'Dernier redémarrage' "$upTxt (redémarrage conseillé)" 'WARN'
        Write-Sub 'Démarrer > Marche/Arrêt > Redémarrer. « Arrêter » ne suffit pas : avec le démarrage rapide de'
        Write-Sub 'Windows, le PC reprend là où il s''était arrêté au lieu de repartir de zéro.'
    }
    else { Write-Status 'Dernier redémarrage' $upTxt 'OK' }
} else {
    Write-Status 'Dernier redémarrage' 'lecture impossible' 'INFO'
}

$pending = @()
if (Test-Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending') { $pending += 'composants Windows' }
if (Test-Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired') { $pending += 'Windows Update' }
if ($pending.Count -gt 0) {
    Write-Status 'Redémarrage en attente' ($pending -join ', ') 'WARN'
    Write-Sub 'Démarrer > Marche/Arrêt > « Mettre à jour et redémarrer » si ce choix est affiché'
    Write-Sub '(un simple « Redémarrer » peut laisser les mises à jour en attente)'
}
else { Write-Status 'Redémarrage en attente' 'aucun' 'OK' }

# v3.26 : heure du PC comparée à celle d'Internet (Get-ClockSample, Get-ClockCheck), avec l'état du réglage
# « Régler l'heure automatiquement » (Get-TimeSyncMode) pour donner le bon geste
$clk = Get-ClockSample
$clkV = Get-ClockCheck $clk.Server $clk.Age $clk.Before $clk.After
$clkSync = Get-TimeSyncMode (Get-RegValueSafe 'HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\Parameters' 'Type').Value
$clkWhere = 'Paramètres > Heure et langue > Date et heure'
$clkCfg = 'HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\Config'
$clkManual = Test-ClockManualFix $clkV.Offset (Get-RegValueSafe $clkCfg 'MaxPosPhaseCorrection').Value (Get-RegValueSafe $clkCfg 'MaxNegPhaseCorrection').Value
if ($clkV.Status -eq 'WARN') {
    Write-Status 'Heure du PC' $clkV.Text 'WARN'
    if ($clkManual) {
        Write-Sub ('Écart trop grand pour que Windows le corrige seul. Dans ' + $clkWhere + ' :')
        Write-Sub 'coupe « Régler l''heure automatiquement », clique sur « Modifier » et règle la date et l''heure,'
        Write-Sub 'puis réactive « Régler l''heure automatiquement ».'
        Write-Sub 'Si l''heure se dérègle à chaque allumage, la pile de la carte mère est sans doute usée.'
    }
    elseif ($clkSync -eq 'OFF') {
        Write-Sub ($clkWhere + ' : active « Régler l''heure automatiquement »,')
        Write-Sub 'puis clique sur « Synchroniser maintenant ».'
    }
    else { Write-Sub ($clkWhere + ' > « Synchroniser maintenant ».') }
    Write-Sub 'Une heure fausse peut faire échouer des mises à jour et des connexions sécurisées.'
}
elseif ($clkV.Status -eq 'OK') {
    Write-Status 'Heure du PC' $clkV.Text 'OK'
    if ($clkSync -eq 'OFF') { Write-Sub ('Mise à l''heure automatique coupée : ' + $clkWhere + ' pour la réactiver') }
}
else { Write-Status 'Heure du PC' $clkV.Text 'INFO' }
# Relecture v3.26 : la mesure se fait en heure universelle ; un mauvais fuseau horaire affiche une heure fausse sur
# un PC pourtant « à l'heure ». Son nom suffit à le repérer (même écran de Paramètres pour le changer).
try { Write-Sub ('Fuseau horaire : ' + [TimeZoneInfo]::Local.DisplayName) } catch { Write-Sub 'Fuseau horaire : illisible' }

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
        if ($age -gt 30) {
            Write-Status 'Dernière installation' $txt 'WARN'
            Write-Sub 'Paramètres > Windows Update > Rechercher des mises à jour ; si rien ne s''installe, redémarre et réessaie.'
        }
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
                UpdateId = [string]$u.Identity.UpdateID
                Driver = ($u.Type -eq 2)
                Optional = [bool]$u.BrowseOnly
                Interactive = [bool]$u.InstallationBehavior.CanRequestUserInput
                DriverHwId = $(if ($u.Type -eq 2) { try { [string]$u.DriverHardwareID } catch { '' } } else { '' })
                Categories = @(foreach ($c in $u.Categories) { [pscustomobject]@{ CategoryID = [string]$c.CategoryID } })
                KBs = @(foreach ($k in $u.KBArticleIDs) { [string]$k })
            }
        }
        [pscustomobject]@{ Ok = $true; Updates = $list; Error = $null }
    } catch {
        [pscustomobject]@{ Ok = $false; Updates = @(); Error = $_.Exception.Message }
    }
} 240

$wuRetry = 'Vérifie la connexion Internet, redémarre le PC puis relance le scan ; sinon Paramètres > Windows Update.'
if ($null -eq $wu) {
    Write-Status 'Recherche de mises à jour' 'délai dépassé (4 min)' 'WARN'
    Write-Sub $wuRetry
} elseif (-not $wu.Ok) {
    Write-Status 'Recherche de mises à jour' ('échec : ' + (Cut $wu.Error 50)) 'WARN'
    Write-Sub $wuRetry
} else {
    $all = @($wu.Updates)
    # Signatures de Defender : Defender les installe lui-même plusieurs fois par jour, leur âge est jugé en
    # section 06 ; une en attente n'est donc pas une alerte (v3.21, vue à chaque scan sur les deux PC)
    $defs      = @($all | Where-Object { -not $_.Optional -and (Test-WuDefinitionUpdate $_) })
    $all       = @($all | Where-Object { $_.Optional -or -not (Test-WuDefinitionUpdate $_) })
    $important = @($all | Where-Object { -not $_.Optional -and -not $_.Interactive })
    $manual    = @($all | Where-Object { -not $_.Optional -and $_.Interactive })
    $optional  = @($all | Where-Object { $_.Optional })
    $script:WUCount = $important.Count
    $script:WUManual = $manual.Count
    # Pilotes proposés, pour les rattacher aux appareils de la section 04 (v3.27)
    $script:WUDrivers = @(foreach ($u in @($important + $manual + $optional)) {
        if (-not $u.Driver -or -not $u.DriverHwId) { continue }
        $k = 'AUTO'
        if ($u.Optional) { $k = 'OPTIONAL' } elseif ($u.Interactive) { $k = 'MANUAL' }
        [pscustomobject]@{ HardwareId = [string]$u.DriverHwId; Title = [string]$u.Title; Kind = $k }
    })
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
        Write-Sub 'J.A.R.V.I.S. te propose de les installer à la fin du scan.'
    }
    if ($defs.Count -gt 0) {
        Write-Status 'Signatures Defender' ("{0} en attente : Defender les installe de lui-même" -f $defs.Count) 'INFO'
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

# Historique des 30 derniers jours : installations en échec jamais réussies depuis
$wuh = Invoke-Spinner 'Lecture de l''historique des mises à jour' {
    try {
        $se = (New-Object -ComObject Microsoft.Update.Session).CreateUpdateSearcher()
        $n = [int]$se.GetTotalHistoryCount()
        $rows = @()
        if ($n -gt 0) {
            $lim = (Get-Date).AddDays(-30)
            foreach ($e in $se.QueryHistory(0, [Math]::Min($n, 500))) {
                if ($null -eq $e.Date) { continue }
                # Dates rendues en heure UTC (11 h 52 dans l'historique = 12 h 52 dans le journal Système, relevé le 19/11/2026)
                $d = [DateTime]::SpecifyKind([datetime]$e.Date, [DateTimeKind]::Utc).ToLocalTime()
                if ($d -lt $lim) { continue }
                $rows += [pscustomobject]@{ Date = $d; Operation = [int]$e.Operation; ResultCode = [int]$e.ResultCode
                                            HResult = [int]$e.HResult; Title = [string]$e.Title; UpdateId = [string]$e.UpdateIdentity.UpdateID }
            }
        }
        [pscustomobject]@{ Ok = $true; Entries = $rows; Error = $null }
    } catch {
        [pscustomobject]@{ Ok = $false; Entries = @(); Error = $_.Exception.Message }
    }
} 60

# Même période dans le journal Système (événements 19 et 20) : certains échecs n'apparaissent que là
# (KB5132057 sur le PC de Thomas le 21/11/2026, cinq échecs absents de l'historique ci-dessus)
$wue = Get-EventsSafe @{ LogName = 'System'; ProviderName = 'Microsoft-Windows-WindowsUpdateClient'; Id = 19, 20; StartTime = (Get-Date).AddDays(-30) }
$wuRows = @()
if ($null -ne $wuh -and $wuh.Ok) { $wuRows += @($wuh.Entries) }
if ($wue.Ok) {
    foreach ($ev in @($wue.Events)) {
        $evData = @{}
        try {
            foreach ($x in @(([xml]$ev.ToXml()).Event.EventData.Data)) { $evData[[string]$x.Name] = [string]$x.'#text' }
        } catch { continue }
        $row = ConvertFrom-WuClientEvent $ev.Id $ev.TimeCreated $evData
        if ($null -ne $row) { $wuRows += $row }
    }
}

if (($null -eq $wuh -or -not $wuh.Ok) -and -not $wue.Ok) {
    Write-Status 'Échecs d''installation (30 j)' 'historique illisible' 'INFO'
} else {
    $pend = $null
    if ($null -ne $wu -and $wu.Ok) { $pend = @($wu.Updates) }
    $osVer = ''
    if ($cv -and $cv.CurrentBuild -and $null -ne $cv.UBR) { $osVer = '{0}.{1}' -f $cv.CurrentBuild, $cv.UBR }
    $hf = Get-WuHistoryFailures $wuRows ((Get-Date).AddDays(-30)) $pend $osVer
    # Préversions facultatives à part : leur échec n'oblige à rien
    $hfPrev = @($hf.Failed | Where-Object { Test-WuPreviewTitle $_.Title })
    $hfReq = @($hf.Failed | Where-Object { -not (Test-WuPreviewTitle $_.Title) })
    $cvBuild = $null
    if ($cv) { $cvBuild = ConvertTo-IntOrNull $cv.CurrentBuild }
    if ($hfReq.Count -eq 0 -and $hfPrev.Count -eq 0) {
        Write-Status 'Échecs d''installation (30 j)' 'aucun' 'OK'
    }
    if ($hfReq.Count -gt 0) {
        $nfTxt = "{0} mise(s) à jour jamais réussie(s) depuis" -f $hfReq.Count
        if ($null -ne $pend) { $nfTxt = "{0} mise(s) à jour en échec, toujours proposée(s)" -f $hfReq.Count }
        Write-Status 'Échecs d''installation (30 j)' $nfTxt 'WARN'
        foreach ($f in $hfReq) {
            Write-Sub ("{0}  {1}  (code {2})" -f (Format-Date $f.Date), (Cut $f.Title 58), $f.Code) 'Yellow'
            $hint = Get-WuErrorHint $f.Code
            if ($hint) { Write-Sub ('  ' + $hint) }
            if ($f.Code -in '0x80070306', '0x800F0993' -and $null -ne $cvBuild -and $cvBuild -ge 26100) {
                Write-Sub '  Paramètres > Système > Récupération > Résoudre les problèmes à l''aide de Windows Update (environ 1 h)'
            }
        }
        Write-Sub 'Windows Update les retente seul. Si l''échec revient, note le code et cherche-le sur support.microsoft.com'
    }
    if ($hfPrev.Count -gt 0) {
        Write-Status 'Préversions en échec (30 j)' ("{0}, facultative(s) : rien d'obligatoire" -f $hfPrev.Count) 'INFO'
        foreach ($f in $hfPrev) { Write-Sub ("{0}  {1}  (code {2})" -f (Format-Date $f.Date), (Cut $f.Title 58), $f.Code) }
        Write-Sub 'Leurs corrections arrivent avec la mise à jour de sécurité du mois suivant : tu peux les ignorer.'
        $ci = Get-RegValueSafe 'HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings' 'IsContinuousInnovationOptedIn'
        if ($ci.Ok -and (ConvertTo-IntOrNull $ci.Value) -eq 1) {
            Write-Sub 'Pour que Windows arrête de les installer : Paramètres > Windows Update > désactive'
            Write-Sub '« Recevoir les dernières mises à jour dès qu''elles sont disponibles »'
        }
    }
    if ($hf.Resolved -gt 0) { Write-Sub ("{0} autre(s) échec(s), réussi(s) ou remplacé(s) depuis : rien à faire" -f $hf.Resolved) }
    if ($hf.Store -gt 0) { Write-Sub ("{0} échec(s) d'applications du Microsoft Store : s'il reste une mise à jour à faire, elle est en section 03" -f $hf.Store) }
}

# ==================================================================
# [03] APPLICATIONS (winget et Microsoft Store)
# ==================================================================
Write-Section '03' 'Applications (winget et Store)'

if ($NoWinget) {
    Write-Status 'winget' 'vérification sautée (-NoWinget)' 'INFO'
} else {
    $wgParser = ${function:ConvertFrom-WingetText}.ToString()
    $wgUnknown = ${function:Get-WingetUnknownCount}.ToString()
    $wgSplit = ${function:Split-NativeOutput}.ToString()
    $wgUnkNames = ${function:Get-WingetUnknownNames}.ToString()
    $wgExe = [string](Get-WingetPath)
    $wg = Invoke-Spinner 'Analyse des paquets installés' {
        param($ParserText, $UnknownText, $SplitText, $WgExe, $UnkNamesText)
        # Liste de départ : « winget upgrade ». Le module (s'il est là) complète noms, identifiants et
        # versions tronqués, et écarte ce que winget refusera d'installer (IsUpdateAvailable faux).
        # Constaté le 19/11/2026 : Epson Scan 2 (version « Unknown ») et Hytale Launcher (installé pour
        # tous les utilisateurs, winget ne propose qu'une installation par utilisateur) étaient proposés
        # puis refusés par winget ; le module, lui, savait que Hytale n'était pas applicable.
        $out = [pscustomobject]@{ Mode = 'text'; Items = @(); Unknown = 0; UnknownNames = @(); NotApplicable = @(); Error = $null
                                  Raw = ''; Err = ''; Code = $null; Parsed = 0; ModuleErr = '' }
        if (-not $WgExe -or -not (Test-Path -LiteralPath $WgExe -PathType Leaf)) {
            $out.Error = 'NOWINGET'
            return $out
        }
        try { [Console]::OutputEncoding = [Text.Encoding]::UTF8 } catch {}
        $lines = @(& $WgExe upgrade --accept-source-agreements --disable-interactivity 2>&1)
        $wgCode = $LASTEXITCODE
        # Messages d'erreur (stderr) mis à part : seul le texte normal de winget est analysé
        $sp = & ([scriptblock]::Create($SplitText)) -Lines $lines
        $raw = $sp.Out
        $out.Err = [string]$sp.Err
        # Texte brut et code de retour renvoyés aussi : « aucune mise à jour » ne s'affiche que si winget le dit
        $out.Code = $wgCode
        $out.Raw = [string]$raw
        $out.Items = @(& ([scriptblock]::Create($ParserText)) $raw)
        $out.Parsed = @($out.Items).Count
        $out.Unknown = [int](& ([scriptblock]::Create($UnknownText)) $raw)
        if ($out.Unknown -gt 0) {
            # v3.27 : leurs noms, que « winget upgrade » ne donne pas (second appel d'environ 1 s, source déjà lue).
            # En cas d'échec, le nombre reste affiché seul, comme avant.
            try {
                $uLines = @(& $WgExe upgrade --include-unknown --accept-source-agreements --disable-interactivity 2>&1)
                $uSp = & ([scriptblock]::Create($SplitText)) -Lines $uLines
                $uItems = @(& ([scriptblock]::Create($ParserText)) ([string]$uSp.Out))
                $out.UnknownNames = @(& ([scriptblock]::Create($UnkNamesText)) -Items $uItems)
            } catch { $out.UnknownNames = @() }
        }
        # v3.26 (audit, constat T9) : le résultat du module n'est pris qu'une fois le filtrage fini. Avant, le mode
        # « avec module » était écrit d'abord : une erreur en cours de route laissait une liste non filtrée annoncée
        # filtrée. Chaque ligne est complétée sur une copie, la liste de winget reste intacte si le module échoue.
        try {
            if (Get-Module -ListAvailable -Name Microsoft.WinGet.Client) {
                Import-Module Microsoft.WinGet.Client -ErrorAction Stop
                $all = @(Get-WinGetPackage -ErrorAction Stop)
                if ($all.Count -eq 0) { throw 'aucun paquet lu par le module' }
                $ell = [string][char]0x2026
                $keep = @()
                $na = @()
                foreach ($src in $out.Items) {
                    $it = $src.PSObject.Copy()
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
                            $na += [pscustomobject]@{ Name = $it.Name; Ids = @($it.Id, $cliId) }
                            continue
                        }
                    }
                    $keep += $it
                }
                $unk = @($all | Where-Object { $_.IsUpdateAvailable -and [string]$_.InstalledVersion -eq 'Unknown' } |
                         ForEach-Object { [string]$_.Name })
                $out.Items = $keep
                $out.NotApplicable = $na
                if ($unk.Count -gt 0) { $out.UnknownNames = $unk }   # sinon, les noms lus par winget restent
                $out.Mode = 'text+module'
            }
        } catch { $out.ModuleErr = [string]$_.Exception.Message }
        return $out
    } 300 -ArgumentList $wgParser, $wgUnknown, $wgSplit, $wgExe, $wgUnkNames

    $wgRetry = 'Vérifie la connexion Internet puis relance le scan ; si ça revient, mets à jour'
    $wgRetry2 = '« Programme d''installation d''application » dans le Microsoft Store (Bibliothèque).'
    if ($null -eq $wg) {
        Write-Status 'winget' 'délai dépassé (5 min)' 'WARN'
        Write-Sub $wgRetry; Write-Sub $wgRetry2
    } elseif ($wg.Error -eq 'NOWINGET' -and $script:WingetLookup -eq 'UNREADABLE') {
        # Liste des paquets de Windows illisible : winget n'est jamais cherché par son seul nom (v3.24)
        Write-Status 'winget' 'emplacement illisible (liste des applications de Windows)' 'INFO'
        Write-Sub 'Vérifie toi-même : Microsoft Store > Bibliothèque > Obtenir les mises à jour'
    } elseif ($wg.Error -eq 'NOWINGET') {
        Write-Status 'winget' 'non installé' 'INFO'
        Write-Sub 'Installer « Programme d''installation d''application » depuis le Microsoft Store'
    } elseif ($wg.Error) {
        Write-Status 'winget' $wg.Error 'WARN'
        Write-Sub $wgRetry; Write-Sub $wgRetry2
    } else {
        $items = @($wg.Items)
        foreach ($it in $items) {
            $it.Name = Remove-ControlChars $it.Name
            $it.Installed = Remove-ControlChars $it.Installed
            $it.Available = Remove-ControlChars $it.Available
        }
        # Seules les applications dont l'identifiant est lu sont proposées à la mise à jour, une par une (v3.24 :
        # plus de repli « winget upgrade --all », qui mettait à jour au-delà de la liste annoncée, constat S5)
        $script:WGItems = $items
        $script:WGCount = @($items | Where-Object { $_.Id }).Count
        $wgNoId = $items.Count - $script:WGCount
        $wgState = Get-WingetScanState ([string]$wg.Raw) ([int]$wg.Parsed)
        if ($items.Count -eq 0 -and $wgState -eq 'UNREADABLE') {
            # Ni tableau, ni message « aucune mise à niveau » : on ne conclut pas
            Write-Status 'Applications à mettre à jour' 'réponse de winget illisible' 'WARN'
            $first = @(([string]$wg.Raw -split "`n") | ForEach-Object { (Remove-ControlChars $_).Trim() } |
                       Where-Object { $_ -and $_ -notmatch '^[\\|/\-\s]+$' } | Select-Object -First 1)
            if ($first.Count -gt 0) { Write-Sub ('winget a répondu : ' + (Cut $first[0] 70)) }
            if ($wg.Err) { Write-Sub ('Message d''erreur de winget : ' + (Cut (Remove-ControlChars (([string]$wg.Err -split "`r?`n")[0])) 60)) }
            if ($null -ne $wg.Code -and [int]$wg.Code -ne 0) { Write-Sub ('Code de retour de winget : 0x{0:X8}' -f [int]$wg.Code) }
            Write-Sub 'Vérifie la connexion Internet puis relance le scan'
        } elseif ($items.Count -eq 0) {
            Write-Status 'Applications à mettre à jour' 'aucune' 'OK'
        } else {
            Write-Status 'Applications à mettre à jour' ([string]$items.Count) 'WARN'
            if ($wg.ModuleErr) {
                # Module présent mais en échec : liste de winget seule, sans le tri du module (v3.26, constat T9)
                Write-Sub 'Liste de winget seule (module winget illisible) : certaines peuvent être refusées par winget.'
            }
            if ($wg.Mode -eq 'text' -and -not $wg.ModuleErr -and (Test-ShowWingetOffer)) {
                Write-Sub 'Versions détaillées possibles avec le module winget : menu [M]'
            }
            foreach ($it in $items) {
                if ($it.Available) {
                    Write-Sub ("{0,-34} {1} -> {2}" -f (Cut $it.Name 34), $it.Installed, $it.Available) 'Yellow'
                } else {
                    Write-Sub (Cut $it.Name 90) 'Yellow'
                }
            }
            if ($wgNoId -eq 0) { Write-Sub 'J.A.R.V.I.S. te propose de les mettre à jour à la fin du scan.' }
            else {
                if ($script:WGCount -gt 0) { Write-Sub ('J.A.R.V.I.S. te propose de mettre à jour les {0} dont l''identifiant est lu, à la fin du scan.' -f $script:WGCount) }
                Write-Sub ('{0} application(s) sans identifiant lisible : à mettre à jour depuis l''application elle-même ou Microsoft Store > Bibliothèque' -f $wgNoId)
            }
        }
        if ($wg.Unknown -gt 0) {
            # winget ne connaît pas leur version installée : il refuse de les mettre à jour, inutile de les proposer
            $names = ''
            if (@($wg.UnknownNames).Count -gt 0) { $names = ' : ' + (Cut (@($wg.UnknownNames) -join ', ') 60) }
            Write-Status 'Version inconnue de winget' ([string]$wg.Unknown + $names) 'INFO'
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

$stQuery = ${function:Invoke-StoreQuery}.ToString()
$stq = Invoke-Spinner 'Recherche des mises à jour du Microsoft Store' {
    param($QueryText)
    & ([scriptblock]::Create($QueryText)) -Mode 'Search' -TimeoutSec 150
} 180 -ArgumentList $stQuery
if ($null -eq $stq -or -not $stq.Ok) {
    $why = 'pas de réponse'
    if ($script:SpinState -eq 'TIMEOUT') { $why = 'délai dépassé' }
    if ($stq -and $stq.Error) { $why = Cut $stq.Error 45 }
    Write-Status 'Applications du Store' ('lecture impossible (' + $why + ')') 'INFO'
    Write-Sub 'Vérifie toi-même : Microsoft Store > Bibliothèque > Obtenir les mises à jour'
} elseif (-not (Test-SameAccount ([string](Get-CimInstance Win32_ComputerSystem).UserName) ([Environment]::UserName))) {
    # Le Store est propre à chaque compte : après une élévation sous un autre compte, ce serait le sien
    Write-Status 'Applications du Store' 'non lues : J.A.R.V.I.S. tourne sous un autre compte que le tien' 'INFO'
    Write-Sub 'Vérifie toi-même : Microsoft Store > Bibliothèque > Obtenir les mises à jour'
} else {
    $startNames = Get-StartAppNames
    $wgNames = @(@($script:WGItems) | ForEach-Object { [string]$_.Name })
    $sItems = @()
    foreach ($i in @($stq.Items)) {
        $lbl = Remove-ControlChars (Get-StoreAppLabel ([string]$i.Pfn) $startNames)
        if (-not $lbl -or $wgNames -contains $lbl) { continue }   # déjà proposée par winget
        $sItems += [pscustomobject]@{ Pfn = [string]$i.Pfn; Name = $lbl }
    }
    $script:StoreItems = $sItems
    if ($sItems.Count -eq 0) {
        Write-Status 'Applications du Store' 'aucune mise à jour' 'OK'
    } else {
        Write-Status 'Applications du Store' ("{0} à mettre à jour" -f $sItems.Count) 'WARN'
        foreach ($s in $sItems) { Write-Sub (Cut $s.Name 90) 'Yellow' }
        Write-Sub 'J.A.R.V.I.S. te propose de les mettre à jour à la fin du scan.'
    }
    switch (Get-StoreAutoVerdict ([string]$stq.Auto)) {
        'OK' { Write-Status 'Mises à jour auto. du Store' 'activées' 'OK' }
        'WARN' {
            Write-Status 'Mises à jour auto. du Store' 'désactivées' 'WARN'
            Write-Sub 'Pour les réactiver : Microsoft Store > ta photo de profil > Paramètres > Mises à jour des applications'
        }
        'POLICY' { Write-Status 'Mises à jour auto. du Store' 'désactivées par une stratégie (PC géré)' 'INFO' }
        default { Write-Status 'Mises à jour auto. du Store' 'réglage illisible' 'INFO' }
    }
}

# ==================================================================
# [04] PILOTES
# ==================================================================
Write-Section '04' 'Pilotes'

$drv = @(Get-CimInstance Win32_PnPSignedDriver | Where-Object { $_.DeviceName })
if ($drv.Count -eq 0) { Write-Status 'Liste des pilotes' 'lecture impossible' 'INFO' }

# Appareils lus une seule fois : identifiants matériels (pilotes proposés, v3.27) et appareils en erreur (plus bas)
$pnpRead = $true
$pnpAll = @()
try { $pnpAll = @(Get-CimInstance Win32_PnPEntity -ErrorAction Stop) } catch { $pnpRead = $false }
$pnpHw = @{}
foreach ($pe in $pnpAll) {
    # Identifiants matériels et compatibles : DriverHardwareID peut viser l'un ou l'autre (documentation de
    # IWindowsDriverUpdate ; pas encore vu en réel, aucun pilote en attente sur le PC de Thomas le 26/11/2026)
    if ($pe.DeviceID -and -not $pnpHw.ContainsKey([string]$pe.DeviceID)) {
        $pnpHw[[string]$pe.DeviceID] = @(@($pe.HardwareID) + @($pe.CompatibleID) | Where-Object { $_ })
    }
}

function Write-DriverOffer($Dev) {
    # Pilote proposé par Windows Update pour cet appareil (section 02), écrit sous sa ligne avec le geste (v3.27)
    if ($null -eq $Dev -or @($script:WUDrivers).Count -eq 0) { return }
    $id = [string]$Dev.DeviceID
    $hw = @()
    if ($id -and $pnpHw.ContainsKey($id)) { $hw = @($pnpHw[$id]) }
    if ($Dev.HardWareID) { $hw += [string]$Dev.HardWareID }
    $o = Get-DriverOffer $id $hw @($script:WUDrivers)
    if ($null -eq $o) { return }
    Write-Sub ('Windows Update propose : ' + (Cut $o.Title 70))
    if ($o.Kind -eq 'AUTO') {
        if ($isAdmin) { Write-Sub 'J.A.R.V.I.S. te propose de l''installer à la fin du scan, avec les mises à jour Windows.' }
        else { Write-Sub 'Relance J.A.R.V.I.S. en administrateur pour l''installer, ou Paramètres > Windows Update.' }
    } elseif ($o.Kind -eq 'MANUAL') {
        Write-Sub 'Elle demande une action à l''écran : J.A.R.V.I.S. te propose d''ouvrir Windows Update à la fin du scan.'
    } else {
        Write-Sub 'Facultative, utile si l''appareil fonctionne mal : Windows Update > Options avancées > Mises à jour facultatives.'
    }
}

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
    Write-DriverOffer $wifi
}

# Bluetooth
$bt = $drv | Where-Object { $_.DeviceClass -eq 'BLUETOOTH' -and ($_.DeviceID -like 'USB\*' -or $_.DeviceID -like 'PCI\*') } | Select-Object -First 1
if ($bt) {
    $btVal = "v{0}  ({1})" -f $bt.DriverVersion, (Format-Date $bt.DriverDate)
    if ($wifiModel -and $Ref.ContainsKey($wifiModel) -and $bt.Manufacturer -match 'Intel') {
        $refBT = $Ref[$wifiModel].BT
        $c2 = Compare-DriverVersion $bt.DriverVersion $refBT
        if ($null -eq $c2) {
            Write-Status (Cut $bt.DeviceName 32) ("$btVal  (version illisible, non comparée à la référence $refBT)") 'INFO'
        } elseif ($c2 -ge 0) {
            Write-Status (Cut $bt.DeviceName 32) $btVal 'OK'
            Write-Sub $Ref[$wifiModel].BTNote
        } else {
            Write-Status (Cut $bt.DeviceName 32) ("$btVal  -> $refBT disponible") 'WARN'
            Write-Sub 'Mise à jour : Intel Driver & Support Assistant (site d''Intel), ou Windows Update >'
            Write-Sub 'Options avancées > Mises à jour facultatives si elle y est proposée.'
        }
    } else {
        Write-Status (Cut $bt.DeviceName 32) $btVal 'INFO'
    }
    Write-DriverOffer $bt
}

# Ethernet
$ethNa = @($phys | Where-Object { $_.PhysicalMediaType -match '802\.3' })
foreach ($e in $ethNa) {
    $ed = $drv | Where-Object { $_.DeviceName -eq $e.InterfaceDescription } | Select-Object -First 1
    if ($ed) {
        Write-Status (Cut $ed.DeviceName 32) ("v{0}  ({1})" -f $ed.DriverVersion, (Format-Date $ed.DriverDate)) 'INFO'
        Write-DriverOffer $ed
    }
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
        Write-Sub 'Affichage et jeux limités : Windows Update > Options avancées > Mises à jour facultatives,'
        Write-Sub 'sinon le site du fabricant du PC ou de la carte graphique (NVIDIA, AMD, Intel).'
        Write-DriverOffer $g
        continue
    }
    if ($g.Manufacturer -match 'AMD|Advanced Micro') { $v += '  (version Adrenalin : logiciel AMD)' }
    $gAge = $null
    try { $gAge = ((Get-Date) - [datetime]$g.DriverDate).Days } catch { $gAge = $null }
    if ($null -eq $gAge) { Write-Status (Cut $g.DeviceName 32) ("$v  (date du pilote illisible)") 'INFO' }
    elseif ($gAge -gt 180) {
        # v3.23 (audit, constat V1) : INFO comme le BIOS, la date seule ne dit pas qu'une mise à jour manque
        # (vu 30 scans sur 30 pour la puce Intel intégrée d'un PC dont la carte NVIDIA est à jour)
        Write-Status (Cut $g.DeviceName 32) ("$v  (> 6 mois)") 'INFO'
        $gTool = 'logiciel du fabricant de la carte graphique'
        if ($g.Manufacturer -match 'NVIDIA') { $gTool = 'application NVIDIA App' }
        elseif ($g.Manufacturer -match 'AMD|Advanced Micro') { $gTool = 'logiciel AMD Software (Adrenalin)' }
        elseif ($g.Manufacturer -match 'Intel') { $gTool = 'Intel Driver & Support Assistant' }
        Write-Sub ('Utile surtout pour les jeux ou un souci d''affichage : ' + $gTool + '.')
    }
    else { Write-Status (Cut $g.DeviceName 32) $v 'OK' }
    Write-DriverOffer $g
}

# Périphériques en erreur
$bad = @($pnpAll | Where-Object { $null -ne $_.ConfigManagerErrorCode -and $_.ConfigManagerErrorCode -ne 0 })
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
if (-not $pnpRead) { Write-Status 'Périphériques en erreur' 'lecture impossible' 'INFO' }
elseif ($realBad -eq 0) { Write-Status 'Périphériques en erreur' 'aucun' 'OK' }
else {
    Write-Sub 'Appareil externe : débranche-le et rebranche-le. Sinon, clic droit sur Démarrer > Gestionnaire de'
    Write-Sub 'périphériques > appareil marqué d''un triangle > clic droit > Mettre à jour le pilote, puis redémarre.'
}

# ==================================================================
# [05] BLUETOOTH
# ==================================================================
Write-Section '05' 'Bluetooth'

$btDevs = $null
$btErr = $null
try { $btDevs = @(Get-PnpDevice -Class Bluetooth -PresentOnly -ErrorAction Stop) }
catch {
    $btErr = [string]$_.CategoryInfo.Category
    if ($btErr -eq '') { $btErr = 'NotSpecified' }
}
$bt = Get-BtRadioVerdict $btDevs $btErr
$hasBtRadio = ($bt.State -eq 'RADIO')

$svc = Get-Service bthserv
if ($svc) {
    $svcTxt = switch ([string]$svc.Status) {
        'Stopped'      { 'arrêté' }
        'StartPending' { 'en cours de démarrage' }
        'StopPending'  { 'en cours d''arrêt' }
        'Paused'       { 'en pause' }
        default        { [string]$svc.Status }
    }
}
if ($svc -and $svc.Status -eq 'Running') { Write-Status 'Service Bluetooth (bthserv)' 'en cours' 'OK' }
elseif ($svc -and $hasBtRadio) {
    Write-Status 'Service Bluetooth (bthserv)' $svcTxt 'FAIL'
    Write-Sub 'Redémarre le PC. Si la ligne revient : menu Démarrer, tape « services », ouvre'
    Write-Sub '« Service de prise en charge Bluetooth » > Type de démarrage : Manuel > Démarrer.'
}
elseif ($svc -and $bt.State -eq 'NONE') { Write-Status 'Service Bluetooth (bthserv)' ($svcTxt + ' (normal sans Bluetooth)') 'INFO' }
elseif ($svc) { Write-Status 'Service Bluetooth (bthserv)' $svcTxt 'INFO' }
else { Write-Status 'Service Bluetooth (bthserv)' 'introuvable' 'INFO' }

$radio = $bt.Radio
if ($bt.State -eq 'UNKNOWN') {
    Write-Status 'Adaptateur' 'lecture impossible' 'INFO'
} elseif ($radio) {
    if ($radio.Status -eq 'OK') { Write-Status 'Adaptateur' $radio.FriendlyName 'OK' }
    else {
        Write-Status 'Adaptateur' ("{0} : {1}" -f $radio.FriendlyName, $radio.Status) 'FAIL'
        Write-Sub 'Redémarre le PC. Si la ligne revient : clic droit sur Démarrer > Gestionnaire de périphériques >'
        Write-Sub 'Bluetooth > clic droit sur l''adaptateur > Activer le périphérique (ou Mettre à jour le pilote).'
    }

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
$avDef = $null      # état de Defender d'après le Centre de sécurité (repli si Get-MpComputerStatus ne répond pas)
$avs = $null        # $null = Centre de sécurité illisible (différent de « aucun antivirus »)
try { $avs = @(Get-CimInstance -Namespace root/SecurityCenter2 -ClassName AntiVirusProduct -ErrorAction Stop) } catch { $avs = $null }
$secWhere = 'Sécurité Windows > Protection contre les virus et menaces > Gérer les paramètres'
$sigWhere = @('Sécurité Windows > Protection contre les virus et menaces > Mises à jour de la protection',
              '> Rechercher des mises à jour.')
if ($null -ne $avs) {
    foreach ($av in $avs) {
        $st = Get-AvState $av.productState
        if ($av.displayName -match 'Defender') { $avDef = $st; continue }
        if ($null -eq $st) { Write-Status ('Antivirus ' + $av.displayName) 'état illisible' 'INFO'; continue }
        if ($st.On) { $avOther += $av.displayName }
        if (-not $st.On) {
            Write-Status ('Antivirus ' + $av.displayName) 'installé mais inactif' 'WARN'
            Write-Sub 'Ouvre ce logiciel et réactive sa protection. Si tu ne t''en sers plus, désinstalle-le'
            Write-Sub '(Paramètres > Applications) : Microsoft Defender, gratuit, reprendra le relais.'
        }
        elseif ($st.UpToDate) { Write-Status ('Antivirus ' + $av.displayName) 'actif, à jour' 'OK' }
        else {
            Write-Status ('Antivirus ' + $av.displayName) 'actif, signatures obsolètes' 'FAIL'
            Write-Sub 'Ouvre ce logiciel et lance sa mise à jour. Abonnement terminé ? Désinstalle-le'
            Write-Sub '(Paramètres > Applications) : Microsoft Defender, gratuit, reprendra le relais.'
        }
    }
}

$mp = Get-MpComputerStatus
if ($mp -and -not $mp.RealTimeProtectionEnabled -and $avOther.Count -gt 0) {
    Write-Status 'Microsoft Defender' ('en retrait, remplacé par ' + ($avOther -join ', ')) 'INFO'
} elseif ($mp) {
    if ($mp.RealTimeProtectionEnabled) { Write-Status 'Defender temps réel' 'actif' 'OK' }
    else {
        Write-Status 'Defender temps réel' 'inactif' 'FAIL'
        Write-Sub $secWhere
        Write-Sub '> Protection en temps réel : Activé. S''il se recoupe seul ou reste grisé, demande de l''aide.'
    }
    $sig = $null
    if ($null -ne $mp.AntivirusSignatureAge -and [double]$mp.AntivirusSignatureAge -lt 4294967295) { $sig = [int]$mp.AntivirusSignatureAge }
    if ($null -eq $sig) {
        Write-Status 'Signatures antivirus' 'âge illisible' 'INFO'
    } else {
        $sigTxt = "v{0}  (âge {1} j)" -f $mp.AntivirusSignatureVersion, $sig
        if ($sig -gt 7) { Write-Status 'Signatures antivirus' $sigTxt 'FAIL'; foreach ($l in $sigWhere) { Write-Sub $l } }
        elseif ($sig -gt 1) { Write-Status 'Signatures antivirus' $sigTxt 'WARN'; foreach ($l in $sigWhere) { Write-Sub $l } }
        else { Write-Status 'Signatures antivirus' $sigTxt 'OK' }
    }
    if ($null -ne $mp.QuickScanAge -and $mp.QuickScanAge -lt 4294967295) {
        $qs = [int]$mp.QuickScanAge
        if ($qs -gt 14) {
            Write-Status 'Dernière analyse rapide' "il y a $qs j" 'WARN'
            if ($mp.AntivirusEnabled) { Write-Sub 'J.A.R.V.I.S. te propose une analyse rapide à la fin du scan.' }
        }
        else { Write-Status 'Dernière analyse rapide' "il y a $qs j" 'OK' }
    }
    $tp = Get-OnOffVerdict $mp.IsTamperProtected
    if ($tp -eq 'ON') { Write-Status 'Protection anti-falsification' 'active' 'OK' }
    elseif ($tp -eq 'OFF') {
        Write-Status 'Protection anti-falsification' 'désactivée' 'WARN'
        Write-Sub 'Un programme peut alors couper l''antivirus sans te le demander. À réactiver :'
        Write-Sub $secWhere
    } else { Write-Status 'Protection anti-falsification' 'lecture impossible' 'INFO' }
    $mpPref = Get-MpPreference
    $cfa = 'UNKNOWN'
    if ($mpPref) { $cfa = Get-CfaVerdict $mpPref.EnableControlledFolderAccess }
    switch ($cfa) {
        'ON'       { Write-Status 'Accès contrôlé aux dossiers' 'actif (protège tes documents des rançongiciels)' 'INFO' }
        'OFF'      { Write-Status 'Accès contrôlé aux dossiers' 'désactivé (réglage d''origine de Windows)' 'INFO' }
        'AUDIT'    { Write-Status 'Accès contrôlé aux dossiers' 'mode audit (note sans rien bloquer)' 'INFO' }
        'DISKONLY' { Write-Status 'Accès contrôlé aux dossiers' 'partiel (secteurs de disque seulement)' 'INFO' }
        default    { Write-Status 'Accès contrôlé aux dossiers' 'lecture impossible' 'INFO' }
    }
    if ($cfa -eq 'ON') {
        # Exceptions : un programme capable de tout lancer, une fois autorisé, laisse passer n'importe quel script
        $car = Get-CfaAllowedRisk @($mpPref.ControlledFolderAccessAllowedApplications)
        # Sans droits administrateur, une liste vide ne prouve rien (Windows masque les exceptions)
        if ($car.State -eq 'OK' -and -not $isAdmin) { $car.State = 'UNKNOWN' }
        if ($car.State -eq 'WARN') {
            Write-Status 'Accès contrôlé : exceptions' (($car.Risky -join ', ') + ' autorisé(s)') 'WARN'
            Write-Sub 'Ces programmes peuvent lancer n''importe quel script : un rançongiciel peut passer par eux pour'
            Write-Sub 'modifier tes documents. Retire-les, sauf si tu les as autorisés exprès : Sécurité Windows >'
            Write-Sub 'Protection contre les virus et menaces > Gérer la protection contre les ransomwares >'
            Write-Sub 'Autoriser une application via l''accès contrôlé aux dossiers > clique dessus > Supprimer'
        } elseif ($car.State -eq 'OK') {
            if ($car.Count -eq 0) { Write-Status 'Accès contrôlé : exceptions' 'aucune application ajoutée' 'OK' }
            else { Write-Status 'Accès contrôlé : exceptions' ('{0} application(s) ajoutée(s), aucune à risque' -f $car.Count) 'OK' }
        } else {
            Write-Status 'Accès contrôlé : exceptions' 'non lues (liste visible seulement en administrateur)' 'INFO'
        }
    }
    if ($mp.AntivirusEnabled) {
        # v3.28 : blocage des applications indésirables (logiciels publicitaires, programmes ajoutés par un installeur)
        $pua = 'UNKNOWN'
        if ($mpPref) { $pua = Get-PuaVerdict $mpPref.PUAProtection }
        switch ($pua) {
            'ON'    { Write-Status 'Blocage des applis indésirables' 'actif' 'OK' }
            'AUDIT' { Write-Status 'Blocage des applis indésirables' 'mode audit (note sans rien bloquer)' 'INFO' }
            'OFF'   {
                Write-Status 'Blocage des applis indésirables' 'désactivé' 'WARN'
                Write-Sub 'Arrête les logiciels publicitaires et les programmes ajoutés en douce par certains installeurs. À activer :'
                Write-Sub 'Sécurité Windows > Contrôle des applications et du navigateur > Protection fondée sur la réputation >'
                Write-Sub '« Blocage des applications potentiellement indésirables ».'
            }
            default { Write-Status 'Blocage des applis indésirables' 'lecture impossible' 'INFO' }
        }
    }
    # L'analyse rapide n'est proposée en fin de scan que si Defender est bien l'antivirus en service
    $script:DefenderScan = [bool]$mp.AntivirusEnabled
} elseif ($avOther.Count -gt 0) {
    # Defender ne répond pas, mais un autre antivirus est actif : Defender est en retrait, c'est normal
    Write-Status 'Microsoft Defender' ('en retrait, remplacé par ' + ($avOther -join ', ')) 'INFO'
} elseif ($null -ne $avDef) {
    # v3.23 (audit, constat V3) : Get-MpComputerStatus muet, le Centre de sécurité de Windows fait foi pour Defender.
    # Avant, ce cas donnait « statut indisponible » en INFO, même pour un Defender arrêté.
    if ($avDef.On -and $avDef.UpToDate) {
        Write-Status 'Microsoft Defender' 'actif d''après Sécurité Windows (détails illisibles)' 'OK'
    } elseif ($avDef.On) {
        Write-Status 'Microsoft Defender' 'actif, signatures obsolètes d''après Sécurité Windows' 'FAIL'
        foreach ($l in $sigWhere) { Write-Sub $l }
    } else {
        Write-Status 'Microsoft Defender' 'inactif d''après Sécurité Windows' 'FAIL'
        Write-Sub $secWhere
        Write-Sub '> Protection en temps réel : Activé. S''il se recoupe seul ou reste grisé, demande de l''aide.'
    }
} elseif ($null -eq $avs) {
    Write-Status 'Antivirus' 'lecture impossible' 'INFO'
} elseif ($avs.Count -eq 0) {
    Write-Status 'Antivirus' 'aucun antivirus détecté' 'FAIL'
    Write-Sub 'Ouvre Sécurité Windows > Protection contre les virus et menaces et active Microsoft Defender.'
    Write-Sub 'Si rien ne s''active, demande de l''aide : le PC n''est pas protégé.'
} else {
    Write-Status 'Microsoft Defender' 'statut indisponible' 'INFO'
}

# Pare-feu de Windows, puis ceux d'autres logiciels déclarés au Centre de sécurité (v3.26, constat V14)
$fwOff = $null
$fw = @(Get-NetFirewallProfile)
if ($fw.Count -gt 0) {
    $fwOff = @($fw | Where-Object { -not $_.Enabled } | ForEach-Object {
        switch ([string]$_.Name) { 'Domain' { 'domaine' } 'Private' { 'privé' } 'Public' { 'public' } default { [string]$_.Name } }
    })
}
$fwOthers = $null
try {
    $fwOthers = @(Get-CimInstance -Namespace root/SecurityCenter2 -ClassName FirewallProduct -ErrorAction Stop | ForEach-Object {
        $fwSt = Get-AvState $_.productState
        $fwIsOn = $null
        if ($null -ne $fwSt) { $fwIsOn = [bool]$fwSt.On }
        # Relecture v3.26 : un logiciel mal désinstallé peut laisser son entrée « active » figée. « Actif » n'est cru
        # que si son programme existe encore ; sinon état illisible (INFO), jamais OK.
        if ($fwIsOn) {
            $fwFound = $false
            try {
                $fwExe = [Environment]::ExpandEnvironmentVariables(([string]$_.pathToSignedProductExe).Trim(' ', '"'))
                if ($fwExe) { $fwFound = [IO.File]::Exists($fwExe) }
            } catch { $fwFound = $false }
            if (-not $fwFound) { $fwIsOn = $null }
        }
        [pscustomobject]@{ Name = [string]$_.displayName; On = $fwIsOn }
    })
} catch { $fwOthers = $null }
$fv = Get-FirewallVerdict $fwOff $fwOthers
Write-Status 'Pare-feu' $fv.Text $fv.Level
foreach ($fwSub in @($fv.Subs)) { Write-Sub $fwSub }

if ($isAdmin) {
    $sbOn = $null
    try {
        $sb = Confirm-SecureBootUEFI -ErrorAction Stop
        $sbOn = [bool]$sb
        if ($sb) { Write-Status 'Démarrage sécurisé (Secure Boot)' 'actif' 'OK' }
        else {
            Write-Status 'Démarrage sécurisé (Secure Boot)' 'désactivé' 'WARN'
            Write-Sub 'Protège le démarrage de Windows ; il s''active dans le BIOS (menu Boot ou Security)'
            Write-Sub 'Pas urgent. Jamais allé dans le BIOS ? Fais-toi aider : un mauvais réglage peut empêcher Windows de démarrer'
        }
    } catch { Write-Status 'Démarrage sécurisé (Secure Boot)' 'non vérifiable (BIOS ancien ?)' 'INFO' }
    # v3.28 : certificats de 2023 du démarrage sécurisé (ceux de 2011 ont expiré en 2026), lecture seule
    $sbKey = 'HKLM:\SYSTEM\CurrentControlSet\Control\SecureBoot\Servicing'
    $sbSt = Get-RegValueSafe $sbKey 'UEFICA2023Status'
    $sbErr = Get-RegValueSafe $sbKey 'UEFICA2023Error'
    $sbCert = Get-SecureBootCertVerdict $sbOn ($sbSt.Ok -or $sbSt.Missing) $sbSt.Value $sbErr.Value
    if ($null -ne $sbCert) {
        Write-Status 'Certificats Secure Boot (2023)' $sbCert.Text $sbCert.State
        foreach ($l in @($sbCert.Subs)) { Write-Sub $l }
    }

    $tpm = Get-Tpm
    if ($tpm) {
        if ($tpm.TpmPresent -and $tpm.TpmReady) { Write-Status 'Puce de sécurité (TPM)' 'présente et prête' 'OK' }
        elseif ($tpm.TpmPresent) {
            Write-Status 'Puce de sécurité (TPM)' 'présente mais pas prête' 'WARN'
            Write-Sub 'Sert au chiffrement et à Windows Hello. Windows la prépare en général seul : redémarre le PC.'
            Write-Sub 'Si la ligne revient : Sécurité Windows > Sécurité de l''appareil > Processeur de sécurité.'
        }
        else {
            Write-Status 'Puce de sécurité (TPM)' 'absente ou désactivée dans le BIOS' 'WARN'
            Write-Sub 'Sert au chiffrement, exigée par Windows 11. Sur un PC récent, elle s''active dans le BIOS'
            Write-Sub '(option TPM, PTT chez Intel, fTPM chez AMD). Pas urgent. Jamais allé dans le BIOS ? Fais-toi aider.'
        }
    } else {
        Write-Status 'Puce de sécurité (TPM)' 'lecture impossible' 'INFO'
    }
    if ($winSup.IsWin10) {
        # v3.28 : PC sous Windows 10, ce qui s'oppose au passage à Windows 11 dans ce que JARVIS sait lire
        $w11Tpm = $null; $w11Spec = $null
        if ($tpm) {
            $w11Tpm = [bool]$tpm.TpmPresent
            $tpmWmi = Get-CimInstance -Namespace 'root\cimv2\Security\MicrosoftTpm' -ClassName Win32_Tpm
            if ($tpmWmi) { $w11Spec = [string]@($tpmWmi)[0].SpecVersion }
        }
        $w11Ram = $null
        $w11Cs = Get-CimInstance Win32_ComputerSystem
        if ($w11Cs -and $w11Cs.TotalPhysicalMemory) { $w11Ram = [double]$w11Cs.TotalPhysicalMemory }
        $w11Vol = $null
        $w11Ld = Get-CimInstance Win32_LogicalDisk -Filter ("DeviceID='{0}'" -f $SysDrive)
        if ($w11Ld -and $w11Ld.Size) { $w11Vol = [double]$w11Ld.Size }
        $w11 = Get-Win11ReadinessVerdict $w11Tpm $w11Spec $sbOn $w11Ram $w11Vol ([Environment]::Is64BitOperatingSystem)
        Write-Status 'Passage à Windows 11' $w11.Text $w11.State
        foreach ($l in @($w11.Subs)) { Write-Sub $l }
    }

    # v3.23 (audit, constat V9) : aucun point de restauration = avertissement (rien pour revenir en arrière), un point
    # ancien = information (il reste utilisable). C'était l'inverse.
    $rpOk = $true
    $rp = $null
    try { $rp = Get-ComputerRestorePoint -ErrorAction Stop | Sort-Object SequenceNumber -Descending | Select-Object -First 1 } catch { $rpOk = $false }
    $rpHow = 'menu Démarrer, tape « point de restauration » > Créer un point de restauration'
    if (-not $rpOk) {
        Write-Status 'Point de restauration' 'lecture impossible' 'INFO'
    } elseif ($rp) {
        $rpDate = $null
        try { $rpDate = [Management.ManagementDateTimeConverter]::ToDateTime($rp.CreationTime) } catch {}
        if (-not $rpDate) {
            Write-Status 'Dernier point de restauration' 'date illisible' 'INFO'
        } else {
            $rpAge = ((Get-Date) - $rpDate).Days
            $rpTxt = "{0} (il y a {1} j)" -f (Format-Date $rpDate), $rpAge
            if ($rpAge -gt 30) {
                Write-Status 'Dernier point de restauration' $rpTxt 'INFO'
                Write-Sub 'Toujours utilisable. Avant une grosse modification (pilote, logiciel inconnu), crées-en un :'
                Write-Sub ($rpHow + ' > Créer.')
            }
            else { Write-Status 'Dernier point de restauration' $rpTxt 'OK' }
        }
    } else {
        Write-Status 'Point de restauration' 'aucun' 'WARN'
        Write-Sub 'Rien pour annuler un pilote ou une mise à jour qui pose problème. Pour en avoir :'
        Write-Sub ($rpHow + ' > disque C: > Configurer >')
        Write-Sub '« Activer la protection du système » > OK, puis Créer.'
    }
} else {
    Write-Status 'Secure Boot / TPM / restauration' 'nécessite les droits admin' 'INFO'
    if ($winSup.IsWin10) { Write-Status 'Passage à Windows 11' 'non vérifiable (nécessite les droits admin)' 'INFO' }
}

# --- Réglages de sécurité de Windows (lecture seule, rien n'est modifié)
switch (Get-UacState) {
    'ON'       { Write-Status 'Contrôle de compte (UAC)' 'actif' 'OK' }
    'NOPROMPT' {
        Write-Status 'Contrôle de compte (UAC)' 'actif, mais sans demande de confirmation' 'WARN'
        Write-Sub 'Un programme peut obtenir les droits administrateur sans que tu le voies.'
        Write-Sub 'Menu Démarrer, tape « UAC », puis remonte le curseur au 2e cran en partant du haut.'
    }
    'OFF'      {
        Write-Status 'Contrôle de compte (UAC)' 'désactivé' 'FAIL'
        Write-Sub 'Tout programme lancé a les droits administrateur, sans aucune demande.'
        Write-Sub 'Menu Démarrer, tape « UAC », remonte le curseur au 2e cran en partant du haut, redémarre.'
    }
    default    { Write-Status 'Contrôle de compte (UAC)' 'lecture impossible' 'INFO' }
}

switch (Get-SmartScreenState) {
    'ON'      { Write-Status 'SmartScreen (applications)' 'actif' 'OK' }
    'OFF'     {
        Write-Status 'SmartScreen (applications)' 'désactivé' 'WARN'
        Write-Sub 'Windows ne te prévient plus avant d''ouvrir un programme inconnu ou dangereux.'
        Write-Sub 'Sécurité Windows > Contrôle des applications et du navigateur >'
        Write-Sub 'Protection fondée sur la réputation > « Vérifier les applications et les fichiers ».'
    }
    'DEFAULT' { Write-Status 'SmartScreen (applications)' 'réglage d''origine de Windows, aucune désactivation notée' 'INFO' }
    default   { Write-Status 'SmartScreen (applications)' 'lecture impossible' 'INFO' }
}

switch (Get-RdpState) {
    'OFF'   { Write-Status 'Bureau à distance' 'désactivé' 'OK' }
    'ON'    {
        Write-Status 'Bureau à distance' 'activé' 'WARN'
        Write-Sub 'Ce PC accepte d''être piloté depuis un autre appareil.'
        Write-Sub 'Si tu ne t''en sers pas : Paramètres > Système > Bureau à distance > Désactivé.'
    }
    default { Write-Status 'Bureau à distance' 'lecture impossible' 'INFO' }
}

switch (Get-Smb1State) {
    'OFF'   { Write-Status 'Partage SMBv1 (ancien protocole)' 'désactivé' 'OK' }
    'ON'    {
        Write-Status 'Partage SMBv1 (ancien protocole)' 'activé' 'WARN'
        Write-Sub 'Protocole ancien et vulnérable, utile seulement pour un très vieux NAS ou une vieille imprimante.'
        Write-Sub 'Menu Démarrer, tape « fonctionnalités Windows », puis décoche'
        Write-Sub '« Support de partage de fichiers SMB 1.0/CIFS ».'
    }
    default { Write-Status 'Partage SMBv1 (ancien protocole)' 'lecture impossible' 'INFO' }
}

switch (Get-HvciState) {
    'RUNNING' { Write-Status 'Intégrité de la mémoire' 'active' 'INFO' }
    'PENDING' { Write-Status 'Intégrité de la mémoire' 'activée dans les réglages, pas en service (redémarrage à faire ?)' 'INFO' }
    'OFF'     { Write-Status 'Intégrité de la mémoire' 'désactivée' 'INFO' }
    default   { Write-Status 'Intégrité de la mémoire' 'lecture impossible' 'INFO' }
}

$acc = Get-LocalAccountState
if (-not $acc.Ok) {
    Write-Status 'Comptes Windows locaux' 'lecture impossible' 'INFO'
} else {
    # INFO : la présence réelle d'un mot de passe ne se lit pas, cette ligne ne conclut donc rien
    $accTxt = '{0} actif(s)' -f $acc.Findings.Active
    if ($null -ne $acc.Admins) { $accTxt += ', dont {0} administrateur(s)' -f $acc.Admins }
    Write-Status 'Comptes Windows locaux' $accTxt 'INFO'
    if (-not $acc.Findings.BuiltinAdmin) {
        Write-Status 'Compte Administrateur intégré' 'désactivé' 'OK'
    } elseif ($acc.Domain) {
        Write-Status 'Compte Administrateur intégré' 'actif (PC rattaché à un domaine : souvent voulu)' 'INFO'
    } else {
        Write-Status 'Compte Administrateur intégré' 'actif' 'WARN'
        Write-Sub 'Ce compte agit sans aucune demande de confirmation.'
        if ($acc.CurrentIsBuiltin) {
            Write-Sub 'Tu l''utilises en ce moment : ne le désactive pas. Mieux vaut créer un autre compte'
            Write-Sub 'administrateur et t''en servir au quotidien (demande de l''aide).'
        } else {
            Write-Sub 'Si tu ne l''as pas activé toi-même, demande de l''aide avant d''y toucher :'
            Write-Sub 'le désactiver sans autre compte administrateur bloquerait le PC.'
        }
    }
    if ($acc.Findings.NoPassword.Count -gt 0) {
        Write-Status 'Compte sans mot de passe' (Cut ($acc.Findings.NoPassword -join ', ') 60) 'WARN'
        Write-Sub 'Aucun mot de passe n''y a jamais été défini.'
        Write-Sub 'Paramètres > Comptes > Options de connexion > Mot de passe.'
    }
    if ($acc.Findings.Optional.Count -gt 0) {
        Write-Status 'Mot de passe non obligatoire' (Cut ($acc.Findings.Optional -join ', ') 60) 'INFO'
        Write-Sub 'Windows accepterait un mot de passe vide pour ce(s) compte(s) : vérifie qu''il en a bien un.'
    }
}

$hostsState = Get-HostsState
if (-not $hostsState.Ok) {
    Write-Status 'Fichier hosts' 'lecture impossible' 'INFO'
} elseif ($hostsState.Moved) {
    Write-Status 'Fichier hosts' ('dossier déplacé : ' + (Cut $hostsState.Moved 60)) 'WARN'
    Write-Sub 'Windows ne lit plus le fichier hosts habituel, mais celui de ce dossier :'
    Write-Sub 'procédé connu de logiciels malveillants. Demande de l''aide si ce réglage ne vient pas de toi.'
} elseif ($hostsState.Findings.Sensitive.Count -gt 0) {
    Write-Status 'Fichier hosts' ('{0} site(s) Microsoft ou antivirus détourné(s)' -f $hostsState.Findings.Sensitive.Count) 'WARN'
    Write-Sub (Cut ($hostsState.Findings.Sensitive -join ', ') 90)
    Write-Sub 'Sans gravité si cela vient de toi ou d''un outil qui bloque la télémétrie.'
    Write-Sub 'Sinon c''est suspect : un logiciel malveillant bloque ainsi mises à jour et antivirus.'
    Write-Sub 'Fichier : C:\Windows\System32\drivers\etc\hosts'
} elseif ($hostsState.Findings.Entries -gt 0) {
    Write-Status 'Fichier hosts' ('{0} redirection(s), aucune vers Microsoft ou un antivirus' -f $hostsState.Findings.Entries) 'INFO'
} else {
    Write-Status 'Fichier hosts' 'aucune redirection' 'OK'
}

$proxy = Get-ProxyState
switch ($proxy.State) {
    'NONE'   { Write-Status 'Proxy' 'aucun' 'OK' }
    'MANUAL' {
        Write-Status 'Proxy' ('actif : ' + (Cut $proxy.Detail 50)) 'INFO'
        Write-Sub 'Tout ton trafic web passe par ce serveur. Normal au travail ou avec certains VPN ;'
        Write-Sub 'sinon : Paramètres > Réseau et Internet > Proxy.'
    }
    'SCRIPT' {
        Write-Status 'Proxy' ('script de configuration : ' + (Cut $proxy.Detail 40)) 'INFO'
        Write-Sub 'Normal au travail ou avec certains VPN ; sinon : Paramètres > Réseau et Internet > Proxy.'
    }
    'OTHERUSER' { Write-Status 'Proxy' 'non lu : J.A.R.V.I.S. tourne sous un autre compte que le tien' 'INFO' }
    default  { Write-Status 'Proxy' 'lecture impossible' 'INFO' }
}

switch (Get-ActivationState) {
    'ACTIVATED'    { Write-Status 'Activation de Windows' 'activé' 'OK' }
    'NOTACTIVATED' {
        Write-Status 'Activation de Windows' 'non activé' 'WARN'
        Write-Sub 'Windows 11 : Paramètres > Système > Activation.'
        Write-Sub 'Windows 10 : Paramètres > Mise à jour et sécurité > Activation.'
    }
    default        { Write-Status 'Activation de Windows' 'lecture impossible' 'INFO' }
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
    if ($pct -lt 20) {
        if ($pct -lt 10) { Write-Status $label $txt 'FAIL' } else { Write-Status $label $txt 'WARN' }
        if (('{0}:' -f $v.DriveLetter) -eq $SysDrive) {
            Write-Sub 'Windows a besoin de place pour ses mises à jour. Paramètres > Système > Stockage montre ce qui'
            Write-Sub 'la prend ; Paramètres > Applications : désinstalle les jeux et logiciels dont tu ne te sers plus.'
        } else {
            Write-Sub 'Déplace ou supprime des fichiers volumineux (vidéos, jeux installés) de ce disque.'
        }
    }
    else { Write-Status $label $txt 'OK' }
}

if ($vols.Count -eq 0) { Write-Status 'Volumes' 'lecture impossible' 'INFO' }

$disks = @(Get-PhysicalDisk)
if ($disks.Count -eq 0) { Write-Status 'Disques' 'lecture impossible' 'INFO' }
foreach ($d in $disks) {
    # v3.23 (audit, constat V6) : verdict par Get-DiskHealthVerdict (T1), santé et type en français, conseil sous la ligne
    $media = switch ([string]$d.MediaType) { 'HDD' { 'Disque dur' } 'SSD' { 'SSD' } 'SCM' { 'SCM' } default { 'Disque' } }
    $rc = $null
    if ($isAdmin) { $rc = $d | Get-StorageReliabilityCounter }
    $extra = @()
    $rcTemp = $null; $rcWear = $null; $rcErr = $null
    if ($rc) {
        if ($rc.Temperature -gt 0) { $rcTemp = $rc.Temperature; $extra += ('{0} °C' -f $rc.Temperature) }
        if ($null -ne $rc.Wear) { $rcWear = $rc.Wear; $extra += ('usure {0}%' -f $rc.Wear) }
        if ($rc.PowerOnHours -gt 0) { $extra += ('{0:N0} h allumé' -f $rc.PowerOnHours) }
        if ($rc.ReadErrorsUncorrected -gt 0) { $rcErr = $rc.ReadErrorsUncorrected; $extra += ('{0} erreurs de lecture' -f $rc.ReadErrorsUncorrected) }
    }
    $dv = Get-DiskHealthVerdict ([string]$d.HealthStatus) $rcTemp $rcWear $rcErr
    Write-Status (Cut $d.FriendlyName 32) ("{0}  {1:N0} Go  {2}" -f $media, ($d.Size / 1GB), $dv.Text) $dv.State
    if ($extra.Count -gt 0) { Write-Sub ($extra -join '  //  ') }
    foreach ($l in (Get-DiskAdvice $dv.Why)) { Write-Sub $l }
}

# v3.28 : Windows entretient-il encore les disques tout seul (TRIM des SSD, défragmentation des disques durs) ?
# Seule une tâche désactivée est un avertissement : un passage manqué ou en échec peut venir d'un PC peu allumé.
$optTask = Get-OptimizeTaskState
$optV = Get-CleanupTaskVerdict $optTask.State $optTask.LastRun $optTask.LastResult ([TimeSpan]::FromDays(35)) (Get-Date)
$optHow = 'Menu Démarrer, tape « Défragmenter et optimiser les lecteurs »'
switch ($optV) {
    'OK'       { Write-Status 'Optimisation des disques' ('faite par Windows (dernier passage le {0})' -f (Format-Date $optTask.LastRun)) 'OK' }
    'RUNNING'  { Write-Status 'Optimisation des disques' 'en cours (faite par Windows)' 'OK' }
    'DISABLED' {
        Write-Status 'Optimisation des disques' 'désactivée' 'WARN'
        Write-Sub 'Windows n''entretient plus les disques (les SSD ralentissent peu à peu, les disques durs se fragmentent).'
        Write-Sub ($optHow + ' > Modifier les paramètres >')
        Write-Sub 'coche « Exécution planifiée (recommandé) », fréquence « Toutes les semaines ».'
    }
    'NEVER'    {
        Write-Status 'Optimisation des disques' 'jamais faite par Windows' 'INFO'
        Write-Sub ($optHow + ' > bouton Optimiser.')
    }
    'FAILED'   {
        Write-Status 'Optimisation des disques' ('dernier passage du {0} en échec' -f (Format-Date $optTask.LastRun)) 'INFO'
        Write-Sub ('Souvent sans gravité (PC éteint ou sur batterie). Pour la lancer : ' + $optHow + ' > Optimiser.')
    }
    'LATE'     {
        Write-Status 'Optimisation des disques' ('pas de passage depuis le {0}' -f (Format-Date $optTask.LastRun)) 'INFO'
        Write-Sub ('Windows la fait quand le PC reste allumé sans servir. Pour la lancer : ' + $optHow + ' > Optimiser.')
    }
    default    { Write-Status 'Optimisation des disques' 'lecture impossible' 'INFO' }
}

if ($isAdmin -and (Get-Command Get-BitLockerVolume -ErrorAction SilentlyContinue)) {
    $bl = Get-BitLockerVolume -MountPoint $SysDrive
    if ($bl) {
        # v3.23 (audit, constat V9) : « protection suspendue » devient un avertissement, avec quoi faire
        $blv = Get-BitLockerVerdict ([string]$bl.ProtectionStatus) ([string]$bl.VolumeStatus)
        Write-Status ('Chiffrement ' + $SysDrive + ' (BitLocker)') $blv.Text $blv.State
        if ($blv.State -eq 'WARN') {
            Write-Sub 'Tes fichiers sont chiffrés mais la clé reste lisible : le chiffrement ne protège plus.'
            Write-Sub 'Il reprend en général seul au redémarrage (après une mise à jour du BIOS ou de Windows).'
            Write-Sub 'Si la ligne revient : menu Démarrer, tape « BitLocker » > Reprendre la protection,'
            Write-Sub 'ou Paramètres > Confidentialité et sécurité > Chiffrement de l''appareil.'
        }
    }
}

# ==================================================================
# [08] RESSOURCES
# ==================================================================
Write-Section '08' 'Ressources'

$cpus = @(Get-CimInstance Win32_Processor)
if ($cpus.Count -gt 0) {
    Write-Status 'Processeur' (Cut ($cpus[0].Name.Trim()) 45) 'INFO'
    $avgLoad = ($cpus | Measure-Object -Property LoadPercentage -Average).Average
    if ($null -eq $avgLoad) {
        Write-Status 'Charge du processeur' 'lecture impossible' 'INFO'
    } else {
        $load = [math]::Round($avgLoad)
        $txt = "{0}  {1}%" -f (Get-MiniBar $load), $load
        if ($load -gt 85) {
            Write-Status 'Charge du processeur' $txt 'WARN'
            Write-Sub 'Mesure prise pendant le scan, qui fait lui-même travailler le PC. Si le PC est lent au quotidien :'
            Write-Sub 'Ctrl + Maj + Échap (Gestionnaire des tâches) > Processus, et ferme ce qui consomme sans raison.'
        } else { Write-Status 'Charge du processeur' $txt 'OK' }
    }
}

$os = Get-CimInstance Win32_OperatingSystem
if ($os -and $os.TotalVisibleMemorySize -gt 0 -and $null -ne $os.FreePhysicalMemory) {
    $totGB = $os.TotalVisibleMemorySize / 1MB
    $freeGB = $os.FreePhysicalMemory / 1MB
    $usedPct = [math]::Round((1 - ($freeGB / $totGB)) * 100)
    $txt = "{0}  {1}%  ({2:N1} / {3:N1} Go)" -f (Get-MiniBar $usedPct), $usedPct, ($totGB - $freeGB), $totGB
    if ($usedPct -gt 90) {
        Write-Status 'Mémoire vive' $txt 'WARN'
        Write-Sub 'Ferme les programmes et onglets inutiles (les plus gourmands sont listés ci-dessous).'
        Write-Sub 'Si ça revient souvent, la mémoire est juste pour ton usage.'
    } else { Write-Status 'Mémoire vive' $txt 'OK' }
} else {
    Write-Status 'Mémoire vive' 'lecture impossible' 'INFO'
}

$top = Get-Process | Group-Object ProcessName | ForEach-Object {
    [pscustomobject]@{ Name = $_.Name; MB = [math]::Round((($_.Group | Measure-Object WorkingSet64 -Sum).Sum) / 1MB) }
} | Sort-Object MB -Descending | Select-Object -First 5
foreach ($p in $top) { Write-Sub ("{0,-30} {1,7:N0} Mo" -f (Cut $p.Name 30), $p.MB) }

$plan = (& (Get-SystemToolPath 'powercfg.exe') /getactivescheme) -join ' '
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
        if ($health -lt 60) {
            Write-Status 'Santé batterie' $txt 'FAIL'
            Write-Sub 'Batterie très usée : autonomie réduite, le PC peut s''éteindre d''un coup.'
            Write-Sub 'Son remplacement est conseillé (fabricant du PC ou réparateur).'
        }
        elseif ($health -lt 80) {
            Write-Status 'Santé batterie' $txt 'WARN'
            Write-Sub 'Usure normale avec l''âge : l''autonomie baisse. Rien d''urgent.'
        }
        else { Write-Status 'Santé batterie' $txt 'OK' }
        Write-Sub ('{0:N0} mWh / {1:N0} mWh d''origine' -f $full, $design)
    } elseif (-not $isAdmin) {
        Write-Status 'Santé batterie' 'nécessite les droits admin' 'INFO'
    }
}

# v3.26 (constat V11) : seuls les programmes actifs comptent, ceux désactivés dans le Gestionnaire des tâches à part
# Élevé sous un autre compte (mot de passe d'un autre administrateur) : partie commune seulement (relecture v3.26)
$stSame = Test-SameAccount ([string](Get-CimInstance Win32_ComputerSystem).UserName) ([Environment]::UserName)
$stEntries = Get-StartupEntries -MachineOnly:(-not $stSame)
$stLbl = 'Programmes au démarrage'
if (-not $stSame) {
    $stLbl = 'Démarrage (tous les comptes)'
    Write-Status 'Démarrage de ton compte' 'non lu : J.A.R.V.I.S. tourne sous un autre compte que le tien' 'INFO'
}
if ($null -eq $stEntries) { Write-Status $stLbl 'lecture impossible' 'INFO' }
else {
    $stc = Get-StartupCount $stEntries
    $stTxt = '{0} actif' -f $stc.On
    if ($stc.On -gt 1) { $stTxt += 's' }
    if ($stc.Off -gt 0) { $stTxt += ' ({0} désactivé{1})' -f $stc.Off, $(if ($stc.Off -gt 1) { 's' } else { '' }) }
    if ($stc.On -gt 15) {
        Write-Status $stLbl ($stTxt + ', beaucoup') 'WARN'
        Write-Sub 'Ils ralentissent l''allumage. Ctrl + Maj + Échap > Applications de démarrage (ou Démarrage) :'
        Write-Sub 'clic droit > Désactiver sur ce dont tu n''as pas besoin dès l''allumage.'
    }
    else { Write-Status $stLbl $stTxt 'OK' }
}

# ==================================================================
# [09] RÉSEAU
# ==================================================================
Write-Section '09' 'Réseau'

$ups = @(Get-NetAdapter | Where-Object { $_.Status -eq 'Up' -and -not $_.Virtual })
foreach ($n in $ups) { Write-Status (Cut $n.Name 32) ("{0}  //  {1}" -f $n.LinkSpeed, (Cut $n.InterfaceDescription 34)) 'INFO' }

$gw = [string](Get-NetRoute -DestinationPrefix '0.0.0.0/0' | Sort-Object RouteMetric | Select-Object -First 1).NextHop
$gwReply = $false
if ($gw) { $gwReply = [bool](Test-Connection -ComputerName $gw -Count 2 -Quiet) }

$ping = @(Test-Connection -ComputerName 1.1.1.1 -Count 4)
$pingAvg = $null
if ($ping.Count -gt 0) {
    $prop = 'ResponseTime'
    if (-not $ping[0].PSObject.Properties['ResponseTime']) { $prop = 'Latency' }
    $pingAvg = ($ping | Measure-Object -Property $prop -Average).Average
}
# v3.23 (audit, constat V8) : sans réponse au ping, une connexion TCP (port 443) dit si Internet fonctionne quand même
# (box ou réseau qui bloquent le ping) ; par nom ensuite, si l'adresse 1.1.1.1 elle-même est bloquée
$tcpOk = $null
if ($ping.Count -eq 0) {
    $tcpOk = Test-TcpReach '1.1.1.1' 443 3000
    if (-not $tcpOk) { $tcpOk = Test-TcpReach 'www.microsoft.com' 443 3000 }
}

# Premier appel à vide : il charge la commande (module DnsClient), soit 400 à 600 ms comptés à tort
# comme du temps de réponse DNS jusqu'à la v3.20 (mesuré le 21/11/2026 : 439 ms puis 19 ms)
$null = Resolve-DnsName 'localhost' -DnsOnly -QuickTimeout -ErrorAction SilentlyContinue
$dnsSw = [Diagnostics.Stopwatch]::StartNew()
$dnsOk = [bool](Resolve-DnsName 'www.microsoft.com' -DnsOnly -QuickTimeout)
$dnsMs = $dnsSw.Elapsed.TotalMilliseconds

$netV = Get-NetworkVerdict $gw $gwReply 4 $ping.Count $pingAvg $tcpOk $dnsOk $dnsMs
foreach ($r in $netV.Rows) {
    Write-Status $r.Label $r.Text $r.State
    foreach ($l in @($r.Advice)) { Write-Sub $l }
}

# ==================================================================
# [10] JOURNAUX D'ÉVÉNEMENTS (7 jours)
# ==================================================================
Write-Section '10' 'Journaux d''événements (7 jours)'

$since = (Get-Date).AddDays(-7)
# Un « 0 » n'est affiché en OK que si le journal a vraiment été lu (Get-EventsSafe)
$sysRead = Get-EventsSafe @{ LogName = 'System'; Level = 1, 2; StartTime = $since }
$sysErr = @($sysRead.Events)

# v3.23 (audit, constats V5 et V13) : libellés sans jargon (le nom technique est dans le conseil), conseil sous chaque
# compteur qui n'est pas à 0
$kp = @($sysErr | Where-Object { $_.ProviderName -eq 'Microsoft-Windows-Kernel-Power' -and $_.Id -eq 41 }).Count
Write-EventCount 'Arrêts brutaux' $sysRead.Ok $kp 'WARN' @(
    'Le PC s''est éteint sans passer par « Arrêter » (coupure de courant, bouton maintenu, plantage ;',
    'événement Kernel-Power 41). Rien à faire si c''était toi ; s''il s''éteint seul, fais vérifier',
    'l''alimentation et la chauffe (aérations, poussière).')

$bsodRead = Get-EventsSafe @{ LogName = 'System'; ProviderName = 'Microsoft-Windows-WER-SystemErrorReporting'; Id = 1001; StartTime = $since }
Write-EventCount 'Écrans bleus (plantages)' $bsodRead.Ok (@($bsodRead.Events).Count) 'FAIL' @(
    'Windows a planté (BugCheck). Installe les mises à jour de Windows et des pilotes (carte graphique',
    'en premier) et débranche le matériel ajouté récemment. Si ça revient, fais vérifier mémoire et disque.')

# Erreurs matérielles : seules les erreurs non corrigées (niveaux critique et erreur) sont un avertissement. Les
# erreurs corrigées par le matériel lui-même (niveau avertissement, fréquentes sur certaines cartes mères) passent en
# information (v3.23, constat V12 de l'audit : elles donnaient un avertissement sans conseil).
$wheaRead = Get-EventsSafe @{ LogName = 'System'; ProviderName = 'Microsoft-Windows-WHEA-Logger'; StartTime = $since }
$wheaAll = @($wheaRead.Events)
$wheaBad = @($wheaAll | Where-Object { $null -ne $_.Level -and [int]$_.Level -ge 1 -and [int]$_.Level -le 2 }).Count
$wheaFixed = @($wheaAll | Where-Object { $null -ne $_.Level -and [int]$_.Level -eq 3 }).Count
Write-EventCount 'Erreurs matérielles' $wheaRead.Ok $wheaBad 'WARN' @(
    'Le processeur, la mémoire ou la carte mère ont signalé une erreur (WHEA). Si le PC plante ou',
    'redémarre seul, fais-le vérifier ; sinon, surveille cette ligne aux prochains scans.')
if ($wheaRead.Ok -and $wheaFixed -gt 0) {
    Write-Status 'Erreurs matérielles corrigées' ([string]$wheaFixed) 'INFO'
    Write-Sub 'Corrigées par le matériel lui-même : rien à faire tant que le PC est stable.'
}

$diskEv = @($sysErr | Where-Object { $_.ProviderName -in 'disk', 'Ntfs', 'stornvme', 'storahci', 'Microsoft-Windows-Ntfs' })
# v3.22 : une erreur d'un appareil amovible débranché depuis (clé USB du 21/11/2026 sur le PC de Thomas) n'est plus
# une alerte. Le journal des disques branchés n'est lu que s'il y a une erreur à classer (Get-DiskErrorVerdict).
$diskV = $null
if ($diskEv.Count -gt 0) {
    $diskRows = @(foreach ($dkE in $diskEv) {
        $devTxt = ''
        if (@($dkE.Properties).Count -gt 0) { $devTxt = [string]$dkE.Properties[0].Value }
        [pscustomobject]@{ Provider = [string]$dkE.ProviderName; Time = $dkE.TimeCreated; Device = $devTxt }
    })
    $diskArr = $null
    if (@($diskRows | Where-Object { $_.Provider -eq 'disk' }).Count -gt 0) { $diskArr = Get-DiskArrivals ($since.AddDays(-30)) }
    $diskNow = $null
    try {
        $diskNow = @(Get-CimInstance Win32_DiskDrive -ErrorAction Stop | ForEach-Object { [pscustomobject]@{ Number = $_.Index; Serial = [string]$_.SerialNumber } })
    } catch { $diskNow = $null }
    $diskV = Get-DiskErrorVerdict $diskRows $diskArr $diskNow
}
$diskAlert = 0
if ($null -ne $diskV) { $diskAlert = $diskV.Alert }
Write-EventCount 'Erreurs disque / NTFS' $sysRead.Ok $diskAlert 'WARN'
if ($null -ne $diskV) {
    foreach ($dkD in @($diskV.Devices | Where-Object { $_.Kind -eq 'FIXED' })) { Write-Sub ("sur {0} : {1}" -f (Cut $dkD.Name 50), $dkD.Events) 'Yellow' }
    if (@($diskV.Devices | Where-Object { $_.Kind -eq 'FIXED' -or $_.Kind -eq 'UNKNOWN' }).Count -gt 0) {
        Write-Sub 'Par précaution, copie tes fichiers importants ailleurs (disque externe ou cloud).'
        if ($script:DeepMode) { Write-Sub 'La section 13 vérifie ensuite le disque (CHKDSK).' }
        else { Write-Sub 'Puis lance le scan complet (menu [2]) : il vérifie le disque (CHKDSK).' }
    }
    foreach ($dkD in @($diskV.Devices | Where-Object { $_.Kind -eq 'REMOVABLE' })) {
        Write-Sub ("sur {0} ({1}, branché) : {2}" -f (Cut $dkD.Name 40), $dkD.What, $dkD.Events) 'Yellow'
        Write-Sub '  si elles reviennent, copie son contenu ailleurs : il peut être en fin de vie'
    }
    if ($diskV.Unplugged -gt 0) {
        Write-Status 'Erreurs d''un appareil débranché' ("{0}, sans gravité pour le PC" -f $diskV.Unplugged) 'INFO'
        foreach ($dkD in @($diskV.Devices | Where-Object { $_.Kind -eq 'UNPLUGGED' })) { Write-Sub ("{0} ({1}) : {2}, débranché depuis" -f (Cut $dkD.Name 40), $dkD.What, $dkD.Events) }
        if (@($diskV.Devices | Where-Object { $_.Kind -eq 'UNPLUGGED' -and $_.What -ne 'disque virtuel monté' }).Count -gt 0) {
            Write-Sub 'Avant de débrancher une clé ou un disque externe : icône près de l''horloge > Éjecter.'
            Write-Sub 'Si ses erreurs reviennent quand il est branché, copie son contenu ailleurs : il peut être en fin de vie.'
        }
    }
}

if ($sysRead.Ok) {
    Write-Status 'Erreurs système (total)' ([string]$sysErr.Count) 'INFO'
    if ($sysErr.Count -gt 0) { Write-Sub 'Toujours quelques-unes, même sur un PC sain : seules les lignes ci-dessus comptent.' }
}
$topErr = $sysErr | Group-Object ProviderName | Sort-Object Count -Descending | Select-Object -First 3
foreach ($t in $topErr) { Write-Sub ("{0,-40} {1,4}" -f (Cut $t.Name 40), $t.Count) }

# ==================================================================
# [11] NETTOYAGE
# ==================================================================
Write-Section '11' 'Nettoyage'

# Chaque cible est mesurée ici ; seules celles qui peuvent vraiment être nettoyées sont proposées en fin de
# scan, une question par cible (Get-CleanProposal), et le total « récupérable » ne compte qu'elles.
$cleanPaths = Get-CleanTargetPaths
$script:CleanTargets = @()
# Élévation sous un autre compte (enfant aidé par un parent) : %TEMP%, corbeille et vidages d'applications sont
# ceux du compte qui a validé les droits admin. Sa corbeille n'est jamais proposée : ses fichiers ne sont pas les tiens.
$script:CleanUser = $null
if (-not (Test-SameAccount ([string](Get-CimInstance Win32_ComputerSystem).UserName) ([Environment]::UserName))) {
    $script:CleanUser = [Environment]::UserName
}

# --- Fichiers temporaires : seuls ceux de plus de 24 h sont proposés (un fichier récent sert peut-être encore)
$tmpUser = $null
if (Test-SafeTempPath $env:TEMP) {
    $tmpUser = Measure-AgedFiles $env:TEMP 24
    Write-Status 'Temp utilisateur (%TEMP%)' (Format-AgedText $tmpUser 'de plus de 24 h') 'INFO'
} else {
    Write-Status 'Variable %TEMP% anormale' (Cut $env:TEMP 40) 'WARN'
    Write-Sub 'Nettoyage désactivé pour ce dossier par sécurité'
    Write-Sub 'Un programme a changé l''emplacement des fichiers temporaires : demande de l''aide si ce n''est pas toi.'
}
$tmpWin = Measure-AgedFiles (Join-Path $WinDir 'Temp') 24
$twTxt = Format-AgedText $tmpWin 'de plus de 24 h'
if (-not $tmpWin.Ok -and -not $isAdmin) { $twTxt = 'lecture impossible sans droits admin' }
Write-Status 'Temp Windows' $twTxt 'INFO'
$tmpAged = [int64]0
$tmpOk = $false
foreach ($m in @($tmpUser, $tmpWin)) { if ($null -ne $m -and $m.Ok) { $tmpAged += $m.AgedBytes; $tmpOk = $true } }
$script:CleanTargets += New-CleanTarget 'Temp' 'Fichiers temporaires de plus de 24 h' $tmpAged $tmpOk $false

# --- Corbeille
$rb = Get-RecycleBinState
if ($rb.Ok) { Write-Status 'Corbeille' ('{0}  ({1} élément(s))' -f (Format-Bytes $rb.Bytes), $rb.Count) 'INFO' }
else { Write-Status 'Corbeille' 'lecture impossible' 'INFO' }
$rbWhy = ''
if ($script:CleanUser) {
    $rbWhy = 'autre compte'
    if ($rb.Ok -and $rb.Count -gt 0) { Write-Sub ('Corbeille du compte ' + $script:CleanUser + ' : JARVIS ne propose pas de la vider') }
}
$script:CleanTargets += New-CleanTarget 'RecycleBin' 'Corbeille' $rb.Bytes $rb.Ok $false $rbWhy

# --- Cache Windows Update : vidé seulement si aucune mise à jour n'attend un redémarrage ni ne s'installe
# TiWorker n'est pas regardé ici : la recherche de mises à jour de la section 02 vient de le réveiller pour
# environ 2 minutes (relevé le 19/11/2026), il bloquait donc chaque scan. Il est attendu juste avant la question.
$svcWhy = ''
if ($isAdmin) {
    $svcBusy = Get-WuBusyState
    $svcWhy = Get-ServicingBlocker $svcBusy.RebootPending $false $svcBusy.InstallerBusy
}
$wuM = Measure-AgedFiles $cleanPaths['WuCache'] 0
Write-Status 'Cache Windows Update' (Format-AgedText $wuM '') 'INFO'
if ($wuM.Link) { Write-Sub 'Dossier déplacé par un lien : JARVIS n''y touche pas' }
elseif ($svcWhy -and $wuM.Ok -and $wuM.TotalBytes -ge $CleanMinBytes) { Write-Sub ('Pas de nettoyage maintenant : ' + $svcWhy) }
$script:CleanTargets += New-CleanTarget 'WuCache' 'Cache Windows Update' $wuM.TotalBytes ($wuM.Ok -and -not $wuM.Link) $true $svcWhy

# --- Optimisation de livraison
$doS = Get-DoCacheState
$doCan = Test-DoDeleteAvailable
if ($doS.Ok) {
    Write-Status 'Optimisation de livraison' (Format-DoSize $doS) 'INFO'
    if ($doS.Bytes -ge $CleanMinBytes) {
        Write-Sub 'Copies de mises à jour déjà téléchargées ; Windows les retire de lui-même après quelques jours'
        if (-not $doCan) { Write-Sub 'Cette version de Windows ne permet pas à J.A.R.V.I.S. de les vider : rien à faire' }
    }
} else {
    Write-Status 'Optimisation de livraison' 'lecture impossible' 'INFO'
}
$doWhy = ''
if (-not $doCan) { $doWhy = 'vidage impossible sur cette version de Windows' }
elseif ($null -eq $doS.Busy) { $doWhy = 'état des téléchargements illisible' }
elseif ($doS.Busy) { $doWhy = 'téléchargement en cours' }
$doT = New-CleanTarget 'DoCache' 'Cache de l''optimisation de livraison' $doS.Bytes $doS.Ok $true $doWhy
$doT.MinBytes = $CleanMinDoBytes
$script:CleanTargets += $doT

# --- Vidages mémoire de plus de 30 jours. Ceux de Windows (écrans bleus) sont gardés s'il y a eu un écran bleu
# ces 7 derniers jours, ou si ce journal n'a pas pu être lu (section 10) : ils servent au diagnostic.
$script:KeepSysDumps = (-not $bsodRead.Ok) -or (@($bsodRead.Events).Count -gt 0)
$dApp = Measure-AgedFiles $cleanPaths['CrashDumps'] 720 '.dmp'
$dSys = @((Measure-AgedFiles $cleanPaths['Minidump'] 720 '.dmp'), (Measure-AgedFiles $cleanPaths['MemoryDump'] 720 '.dmp'))
$dSysBytes = [int64]0
$dSysOk = $true
foreach ($m in $dSys) { if ($m.Ok) { $dSysBytes += $m.AgedBytes } else { $dSysOk = $false } }
$dShown = $dSysBytes
if ($dApp.Ok) { $dShown += $dApp.AgedBytes }
if ($dApp.Ok -or $dSysOk) { Write-Status 'Vidages mémoire de plus de 30 j' (Format-Bytes $dShown) 'INFO' }
else { Write-Status 'Vidages mémoire de plus de 30 j' 'lecture impossible' 'INFO' }
$dProp = [int64]0
if ($dApp.Ok) { $dProp += $dApp.AgedBytes }
if ($dSysBytes -gt 0) {
    if ($script:KeepSysDumps -and $bsodRead.Ok) { Write-Sub 'Vidages de Windows conservés : écran bleu ces 7 derniers jours, utiles au diagnostic' }
    elseif ($script:KeepSysDumps) { Write-Sub 'Vidages de Windows conservés : journal des écrans bleus illisible' }
    elseif ($isAdmin) { $dProp += $dSysBytes }
    else { Write-Sub ('Vidages de Windows (' + (Format-Bytes $dSysBytes) + ') : droits admin nécessaires pour les supprimer') }
}
$script:CleanTargets += New-CleanTarget 'Dumps' 'Vidages mémoire de plus de 30 jours' $dProp ($dApp.Ok -or $dSysOk) $false

# --- Composants Windows (scan complet). Windows les nettoie lui-même (tâche StartComponentCleanup de la
# maintenance automatique) : JARVIS ne regarde plus loin que si cette tâche ne fait pas son travail. Raison : le
# 19/11/2026, un nettoyage lancé par JARVIS trois jours après celui de Windows a fini en 2 s sans rien retirer
# (CBS.log : rien de changé depuis le dernier passage, travail sauté).
$ctask = $null
$ctv = $null
if ($script:DeepMode) {
    $ctask = Get-CleanupTaskState
    $ctv = Get-CleanupTaskVerdict $ctask.State $ctask.LastRun $ctask.LastResult $ctask.Deadline (Get-Date)
}
if ($script:DeepMode -and ($ctv -eq 'OK' -or $ctv -eq 'RUNNING')) {
    $every = ''
    if ($null -ne $ctask.Period -and $ctask.Period.TotalDays -ge 1) { $every = ' tous les {0:N0} jours' -f $ctask.Period.TotalDays }
    Write-Status 'Anciens composants de Windows' ('nettoyés par Windows' + $every) 'OK'
    if ($ctv -eq 'RUNNING') { Write-Sub 'Nettoyage de Windows en cours en ce moment, rien à faire de ton côté' }
    else { Write-Sub ('Dernier passage : ' + (Format-Date $ctask.LastRun) + ', rien à faire de ton côté') }
} elseif ($script:DeepMode) {
    switch ($ctv) {
        'DISABLED' { $ctWhy = 'tâche désactivée' }
        'NEVER'    { $ctWhy = 'tâche jamais lancée' }
        'FAILED'   { $ctWhy = 'dernier passage en échec ({0})' -f (Format-Date $ctask.LastRun) }
        'LATE'     { $ctWhy = 'pas de passage réussi depuis le {0}' -f (Format-Date $ctask.LastRun) }
        default    { $ctWhy = 'état de la tâche illisible' }
    }
    $script:ComponentInfo = Invoke-ComponentAnalysis
    $ci = $script:ComponentInfo
    if ($null -eq $ci) {
        Write-Status 'Anciens composants de Windows' 'analyse impossible' 'INFO'
    } elseif ($ci.Code -ne 0 -and (Get-ComponentCleanupVerdict '' $ci.Code) -eq 'PENDING') {
        Write-Status 'Anciens composants de Windows' 'analyse impossible : mises à jour en attente' 'INFO'
        Write-Sub 'Redémarre le PC puis relance un scan complet.'
    } elseif ($ci.Code -ne 0) {
        Write-Status 'Anciens composants de Windows' ('analyse impossible (code 0x{0:X8})' -f [int]$ci.Code) 'INFO'
        Write-Sub 'Détails : C:\Windows\Logs\DISM\dism.log'
    } elseif ($ci.Recommended -eq 'YES') {
        $ciTxt = 'nettoyage conseillé par Windows'
        if ($null -ne $ci.Reclaimable) { $ciTxt += (' ({0} paquet(s) remplacé(s))' -f $ci.Reclaimable) }
        Write-Status 'Anciens composants de Windows' $ciTxt 'INFO'
        # Sauvegardes de composants remplacés : le nettoyage ne peut pas libérer plus. Trop peu : pas de question.
        if ($null -ne $ci.BackupBytes -and $ci.BackupBytes -lt $CleanMinBytes) {
            Write-Sub ('Gain trop faible pour être proposé : ' + (Format-Bytes $ci.BackupBytes) + ' au plus')
        } else {
            $script:CleanTargets += New-CleanTarget 'Components' 'Anciens composants de Windows' 0 $true $true $svcWhy $true
            if ($svcWhy) { Write-Sub ('Pas de nettoyage maintenant : ' + $svcWhy) }
        }
    } elseif ($ci.Recommended -eq 'NO') {
        Write-Status 'Anciens composants de Windows' 'aucun nettoyage nécessaire' 'OK'
    } else {
        Write-Status 'Anciens composants de Windows' 'résultat non reconnu' 'INFO'
        Write-Sub 'Détails : C:\Windows\Logs\DISM\dism.log'
    }
    if ($null -ne $ci -and $null -ne $ci.ActualBytes) { Write-Sub ('Taille réelle : ' + (Format-Bytes $ci.ActualBytes)) }
    Write-Sub ('Nettoyage automatique de Windows : ' + $ctWhy)
}

# --- Windows.old : mesuré seulement, le retirer empêche de revenir à la version précédente de Windows
$script:WinOld = $false
$woPath = $null
try { $woPath = Join-Path ([IO.Path]::GetPathRoot([Environment]::GetFolderPath('Windows'))) 'Windows.old' } catch { $woPath = $null }
$wo = $null
if ($woPath) { try { $wo = Get-Item -LiteralPath $woPath -Force -ErrorAction Stop } catch { $wo = $null } }
if ($wo -and $wo.PSIsContainer -and -not ($wo.Attributes -band [IO.FileAttributes]::ReparsePoint)) {
    $wm = Measure-FolderBounded $woPath 15
    $woTxt = Format-Bytes $wm.Bytes
    if (-not $wm.Complete) { $woTxt = 'au moins ' + $woTxt }
    Write-Status 'Windows.old (version précédente)' ('{0}, depuis le {1}' -f $woTxt, (Format-Date $wo.CreationTime)) 'INFO'
    Write-Sub 'Le supprimer empêche de revenir à la version précédente de Windows.'
    if ($wo.CreationTime -gt (Get-Date).AddDays(-10)) {
        # Délai habituel de retour en arrière après une mise à niveau : JARVIS n'oriente pas vers la suppression
        Write-Sub 'Mise à niveau récente : garde-le au moins 10 jours, le temps de vérifier que tout fonctionne.'
    } else {
        $script:WinOld = $true
        Write-Sub 'Pour le retirer : Paramètres > Système > Stockage > Fichiers temporaires.'
    }
}

# --- Assistant de stockage (v3.28) : le nettoyage automatique de Windows, réglage du compte de la session
if (-not $script:CleanUser) {
    $ssPol = Get-RegValueSafe 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\StorageSense' 'AllowStorageSenseGlobal'
    $ssUser = Get-RegValueSafe 'HKCU:\Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy' '01'
    $ssV = 'UNKNOWN'
    if (($ssPol.Ok -or $ssPol.Missing) -and ($ssUser.Ok -or $ssUser.Missing)) { $ssV = Get-StorageSenseVerdict $ssPol.Value $ssUser.Value }
    if ($ssV -eq 'ON') {
        Write-Status 'Assistant de stockage' 'actif (Windows nettoie seul ses fichiers temporaires)' 'OK'
    } elseif ($ssV -eq 'OFF' -or $ssV -eq 'DEFAULT') {
        Write-Status 'Assistant de stockage' 'désactivé' 'INFO'
        Write-Sub 'Windows peut vider seul ses fichiers temporaires et la corbeille quand la place manque :'
        Write-Sub 'Paramètres > Système > Stockage > Assistant de stockage, bouton sur Activé.'
    } else {
        Write-Status 'Assistant de stockage' 'lecture impossible' 'INFO'
    }
}

# --- Total : seulement ce qui sera proposé
$cleanProp = Get-CleanProposal $script:CleanTargets $CleanMinBytes $isAdmin
$allTxt = Format-Bytes $cleanProp.Bytes
if (@($cleanProp.Items | Where-Object { $_.Key -eq 'Components' }).Count -gt 0) { $allTxt += ' + composants Windows' }
$unread = @($script:CleanTargets | Where-Object { -not $_.Ok }).Count
if ($cleanProp.Bytes -gt 5GB) {
    Write-Status 'Espace récupérable' $allTxt 'WARN'
    Write-Sub 'J.A.R.V.I.S. te propose le nettoyage à la fin du scan, élément par élément.'
}
elseif (-not $isAdmin) { Write-Status 'Espace récupérable' ($allTxt + '  (sans droits admin)') 'INFO' }
elseif ($unread -gt 0) { Write-Status 'Espace récupérable' ($allTxt + '  (certaines mesures impossibles)') 'INFO' }
else { Write-Status 'Espace récupérable' $allTxt 'OK' }
if (-not $isAdmin) { Write-Sub 'Sans droits admin, seuls %TEMP%, la corbeille et les vidages d''applications sont proposés' }
if ($script:CleanUser) {
    Write-Sub ('%TEMP% et vidages d''applications : ceux du compte ' + $script:CleanUser + ', pas de ta session')
}

# ==================================================================
# [12] BIOS
# ==================================================================
Write-Section '12' 'BIOS / carte mère'

$board = Get-CimInstance Win32_BaseBoard
$bios  = Get-CimInstance Win32_BIOS
Write-Status 'Carte mère' ("{0} {1}" -f $board.Manufacturer, $board.Product) 'INFO'
if (-not $bios) {
    Write-Status 'Version BIOS' 'lecture impossible' 'INFO'
} else {
    $bAge = $null
    if ($bios.ReleaseDate) { try { $bAge = ((Get-Date) - [datetime]$bios.ReleaseDate).Days } catch { $bAge = $null } }
    $bTxt = "{0}  ({1})" -f $bios.SMBIOSBIOSVersion, (Format-Date $bios.ReleaseDate)
    if ($null -eq $bAge) { Write-Status 'Version BIOS' "$bTxt  (date illisible)" 'INFO' }
    elseif ($bAge -gt 365) { Write-Status 'Version BIOS' "$bTxt  (> 1 an)" 'INFO' }   # v3.21 : INFO, pas WARN (rien à faire sans conseil du fabricant)
    else { Write-Status 'Version BIOS' $bTxt 'OK' }
}
$csys = $null
try { $csys = Get-CimInstance Win32_ComputerSystem -ErrorAction Stop } catch { $csys = $null }
$sysMaker = ''; $sysModel = ''
if ($csys) { $sysMaker = [string]$csys.Manufacturer; $sysModel = [string]$csys.Model }
$bLink = Get-BiosSupportLink ([string]$board.Manufacturer) $sysMaker $sysModel
$bFrom = 'Board'
if ($bLink) { $bFrom = $bLink.From }
$bModel = Remove-ControlChars (Get-BiosSearchName ([string]$board.Product) $sysModel $bFrom)
if ($bLink) {
    Write-Sub ("Dernière version : {0}" -f $bLink.Url)
    if ($bModel) { Write-Sub ("puis cherche « {0} » et la rubrique BIOS" -f (Cut $bModel 60)) }
    else { Write-Sub 'puis cherche le modèle de ton PC et la rubrique BIOS' }
} elseif ($bModel) {
    Write-Sub ("Dernière version : site du fabricant > Support > {0}" -f (Cut $bModel 60))
} else {
    Write-Sub 'Dernière version : site du fabricant de ton PC ou de sa carte mère, rubrique Support'
}
if ($bios -and $null -ne $bAge -and $bAge -gt 365) {
    Write-Sub 'J.A.R.V.I.S. n''installe pas de BIOS : une mise à jour ratée peut rendre le PC inutilisable.'
    Write-Sub 'Ne le mets à jour que si le fabricant le conseille ou pour régler un problème.'
}

# ==================================================================
# [13] INTÉGRITÉ WINDOWS (mode complet)
# ==================================================================
if ($script:DeepMode) {
    Write-Section '13' 'Intégrité Windows (DISM / SFC / CHKDSK)'
    Write-Host '   Ces analyses sont longues. Ne ferme pas la fenêtre.' -ForegroundColor DarkGray

    # --- DISM : état du magasin de composants
    $scanStart = (Get-Date).AddSeconds(-5)
    $dism = Invoke-ProcessSpinner -Label 'DISM /ScanHealth (5-20 min)' `
            -FilePath (Get-SystemToolPath 'dism.exe') `
            -Arguments '/Online /Cleanup-Image /ScanHealth' -TimeoutSec 2400 -Encoding 'Auto'

    # v3.23 (audit, constats V5 et V13) : libellés « Image de Windows (DISM) », « Fichiers système (SFC) »,
    # « Disque X: (CHKDSK) », et un geste sous chaque avertissement ou alerte
    $later = 'Relance le scan complet plus tard, PC branché sur secteur et sans autre travail en cours.'
    $repairLater = 'J.A.R.V.I.S. te propose la réparation à la fin du scan (connexion Internet nécessaire).'
    $dv = $null
    if ($dism) { $dv = Get-DismVerdict $dism.Text $dism.Code }
    if ($null -eq $dism) {
        Write-Status 'Image de Windows (DISM)' 'délai dépassé (40 min)' 'WARN'
        Write-Sub $later
    } elseif ($dv -eq 'CLEAN') {
        Write-Status 'Image de Windows (DISM)' 'magasin de composants sain' 'OK'
    } elseif ($dv -eq 'UNREPAIRABLE') {
        Write-Status 'Image de Windows (DISM)' 'corruption NON réparable' 'FAIL'
        $b13 = $null
        if ($cv) { $b13 = ConvertTo-IntOrNull $cv.CurrentBuild }
        if ($null -ne $b13 -and $b13 -ge 26100) {
            Write-Sub 'Paramètres > Système > Récupération > « Résoudre les problèmes à l''aide de Windows Update » :'
            Write-Sub 'réinstalle Windows en gardant tes fichiers et applications (environ 1 h).'
        } else {
            Write-Sub 'Fais-toi aider : une réinstallation de Windows « sur place » garde fichiers et applications.'
        }
    } elseif ($dv -eq 'REPAIRABLE') {
        Write-Status 'Image de Windows (DISM)' 'corruption réparable détectée' 'WARN'
        $script:NeedRestore = $true
        # Nombre de défauts lu dans CBS.log (v3.21), comparé ensuite à ce qui restait après la dernière réparation
        $scanSum = Get-CbsSummary (Read-CbsLogText $scanStart) $scanStart 'DETECT'
        if ($scanSum -and $scanSum.Detected -gt 0) {
            $script:ScanDetected = $scanSum.Detected
            Write-Sub ('{0:N0} défaut(s) dans le magasin de composants (copies de Windows)' -f $scanSum.Detected)
        }
        Write-Sub $repairLater
    } elseif ($dv -eq 'ERROR') {
        Write-Status 'Image de Windows (DISM)' ("code de sortie {0}" -f $dism.Code) 'WARN'
        Write-Sub 'Redémarre le PC puis relance le scan complet. Détails : C:\Windows\Logs\DISM\dism.log'
    } else {
        # Message ni français ni anglais reconnu : pas de « sain » sans preuve
        Write-Status 'Image de Windows (DISM)' 'résultat non reconnu' 'INFO'
        Write-Sub 'Détails : C:\Windows\Logs\DISM\dism.log'
    }

    # --- SFC /scannow
    $sfcExe = Get-SfcPath
    $sfcStart = (Get-Date).AddSeconds(-5)
    $sfc = Invoke-ProcessSpinner -Label 'SFC /scannow (5-20 min)' -FilePath $sfcExe `
           -Arguments '/scannow' -TimeoutSec 3600 -Encoding 'Auto' -AskOnTimeout

    if ($null -eq $sfc) {
        if ($script:ProcState -eq 'STOPPED') { Write-Status 'Fichiers système (SFC)' 'arrêté à ta demande avant la fin' 'WARN' }
        else { Write-Status 'Fichiers système (SFC)' 'lancement impossible' 'WARN' }
        Write-Sub $later
    } else {
        $sv = Get-SfcVerdict $sfc.Text
        if ($sv -eq 'STOREDAMAGED') {
            Write-Status 'Fichiers système (SFC)' 'intégrité non garantie : magasin de composants endommagé' 'WARN'
            $script:NeedRestore = $true
            Write-Sub $repairLater
        } elseif ($sv -eq 'CLEAN') {
            Write-Status 'Fichiers système (SFC)' 'aucune violation d''intégrité' 'OK'
        } elseif ($sv -eq 'NORUN') {
            Write-Status 'Fichiers système (SFC)' 'n''a pas pu s''exécuter' 'WARN'
            Write-Sub 'Redémarre le PC puis relance le scan complet.'
        } elseif ($sv -eq 'UNFIXED') {
            Write-Status 'Fichiers système (SFC)' 'fichiers corrompus NON réparés' 'FAIL'
            $script:NeedRestore = $true
            Write-Sub $repairLater
        } elseif ($sv -eq 'REPAIRED') {
            $rep = Get-SfcRepairSummary (Read-CbsLogText $sfcStart) $sfcStart
            if ($rep.OnlyOneDrive) {
                Write-Status 'Fichiers système (SFC)' 'seul le raccourci OneDrive des nouveaux comptes a été remis' 'INFO'
                Write-Sub 'OneDrive remplace ce raccourci quand il se met à jour, SFC remet celui de Windows : rien à faire'
            } else {
                Write-Status 'Fichiers système (SFC)' 'fichiers corrompus trouvés et réparés' 'WARN'
                Write-SfcRepairedFiles $rep
                Write-Sub 'Redémarre le PC pour terminer la réparation.'
            }
        } else {
            Write-Status 'Fichiers système (SFC)' 'résultat non reconnu' 'INFO'
            Write-Sub 'Détails : C:\Windows\Logs\CBS\CBS.log'
        }
    }

    # --- CHKDSK /scan (analyse en ligne, sans démontage)
    $ntfs = @(Get-Volume | Where-Object { $_.DriveLetter -and $_.DriveType -eq 'Fixed' -and $_.FileSystem -eq 'NTFS' } | Sort-Object DriveLetter)
    foreach ($v in $ntfs) {
        $L = [string]$v.DriveLetter
        $ck = Invoke-ProcessSpinner -Label ("CHKDSK {0}: /scan" -f $L) `
              -FilePath (Get-SystemToolPath 'chkdsk.exe') `
              -Arguments ("{0}: /scan" -f $L) -TimeoutSec 3600 -Encoding 'Oem'
        $code = $null
        if ($ck) { $code = $ck.Code }

        $lbl = "Disque {0}: (CHKDSK)" -f $L
        $ckv = Get-ChkdskVerdict $code
        if ($null -eq $code) { Write-Status $lbl 'délai dépassé' 'WARN'; Write-Sub $later }
        elseif ($ckv -eq 'CLEAN') { Write-Status $lbl 'aucune erreur' 'OK' }
        elseif ($ckv -eq 'FIXED') {
            Write-Status $lbl 'erreurs trouvées et corrigées' 'WARN'
            Write-Sub 'Rien d''autre à faire. Si elles reviennent au prochain scan complet, sauvegarde tes fichiers.'
        }
        elseif ($ckv -eq 'MINOR') { Write-Status $lbl 'nettoyage mineur nécessaire' 'INFO' }
        elseif ($ckv -eq 'UNKNOWN') {
            # v3.26 (constat V7) : code inattendu = l'analyse n'a pas abouti, pas « erreurs » en rouge
            Write-Status $lbl ('résultat non reconnu (code {0})' -f $code) 'INFO'
            Write-Sub $later
        }
        else {
            Write-Status $lbl 'erreurs détectées, correction nécessaire' 'FAIL'
            $script:ChkdskFix.Add($L)
            # v3.23 : la commande de correction est aussi dans le rapport (avant, seulement à l'écran en fin de scan)
            Write-Sub 'Sauvegarde d''abord tes fichiers importants. Puis clic droit sur Démarrer > Terminal (admin)'
            Write-Sub ('ou Windows PowerShell (admin), tape  chkdsk {0}: /spotfix  et Entrée.' -f $L)
            if (('{0}:' -f $L) -eq $SysDrive) { Write-Sub 'Pour ce disque, réponds O : la correction se fait au prochain redémarrage.' }
        }
    }
}

# ==================================================================
# SYNTHÈSE
# ==================================================================
# v3.23 (audit, constats V2 et V4) : le pourcentage est remplacé par un état général à trois niveaux
# (Get-ScanVerdict, T1) ; les contrôles non vérifiés sont listés à part au lieu de disparaître.
$verdict = Get-ScanVerdict $script:Warnings.Count $script:Alerts.Count $script:NotChecked.Count

Write-Host ''
Write-Host ('  ╔' + ('═' * 64) + '╗') -ForegroundColor Cyan
Write-Host '  ║' -NoNewline -ForegroundColor Cyan
Write-Host ('  SYNTHÈSE DU DIAGNOSTIC'.PadRight(64)) -NoNewline -ForegroundColor White
Write-Host '║' -ForegroundColor Cyan
Write-Host ('  ╚' + ('═' * 64) + '╝') -ForegroundColor Cyan

Write-Host '   État général  ' -NoNewline -ForegroundColor Gray
Write-Host ('██ ' + $verdict.Title + ' ██') -ForegroundColor $verdict.Color
Write-Host ('   ' + $verdict.Line) -ForegroundColor $verdict.Color
Write-Host ("   Contrôles OK : {0}   //   Avertissements : {1}   //   Alertes : {2}   //   Non vérifiés : {3}" -f $script:Ok, $script:Warnings.Count, $script:Alerts.Count, $script:NotChecked.Count) -ForegroundColor Gray

$script:Report.Add('')
$script:Report.Add('== SYNTHÈSE ==')
$script:Report.Add(('État général : {0} - {1}' -f $verdict.Title, $verdict.Line))
$script:Report.Add(("OK {0} / WARN {1} / FAIL {2} / non vérifiés {3}" -f $script:Ok, $script:Warnings.Count, $script:Alerts.Count, $script:NotChecked.Count))

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
if ($script:NotChecked.Count -gt 0) {
    Write-Host ''
    Write-Host '   NON VÉRIFIÉ' -ForegroundColor Cyan
    $script:Report.Add('Non vérifié :')
    foreach ($x in $script:NotChecked) { Write-Host ('   ? ' + $x) -ForegroundColor Cyan; $script:Report.Add('? ' + $x) }
    if (-not $isAdmin) {
        Write-Host '   Relance J.A.R.V.I.S. en administrateur pour en vérifier davantage.' -ForegroundColor DarkGray
        $script:Report.Add('Relance J.A.R.V.I.S. en administrateur pour en vérifier davantage.')
    }
}
if ($script:Alerts.Count -gt 0 -or $script:Warnings.Count -gt 0) {
    Write-Host ''
    Write-Host '   Quoi faire : écrit sous chaque ligne, dans la section indiquée entre crochets.' -ForegroundColor DarkGray
}

Write-Host ''
if ($script:Alerts.Count -eq 0 -and $script:Warnings.Count -eq 0 -and $script:NotChecked.Count -gt 0) {
    Type-Line "   >> Rien d'anormal dans ce que j'ai pu lire, $Name. Certains points restent à vérifier." 'Green'
} elseif ($script:Alerts.Count -eq 0 -and $script:Warnings.Count -eq 0) {
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
$repMark = $script:Report.Count       # tout ce qui s'ajoute au rapport après ce point vient des actions
if ($script:NeedRestore -and $isAdmin) {
    $online = Test-Connection -ComputerName 1.1.1.1 -Count 1 -Quiet
    if (-not $online) { $online = [bool](Resolve-DnsName 'www.microsoft.com' -DnsOnly -QuickTimeout) }
    if (-not $online) {
        Write-Host '   [!] Réparation DISM impossible sans Internet : elle télécharge les fichiers sains depuis Windows Update.' -ForegroundColor Yellow
        Write-Host '       Connecte le PC puis relance le scan complet.' -ForegroundColor Yellow
    } else {
        $retry = Get-RepairRetryAdvice ([string](Get-JarvisConfig)['LastRepair']) (Get-Date) $script:ScanDetected
        if ($retry) {
            $lastDate = ([string](Get-JarvisConfig)['LastRepair'] -split '\|')[0]
            Write-Host ('   [i] La dernière réparation ({0}) n''a pas pu tout corriger : Windows Update ne fournissait plus certains fichiers.' -f $lastDate) -ForegroundColor Yellow
            if ($retry -eq 'SAME') { Write-Host '       Les défauts vus aujourd''hui ne sont pas plus nombreux : une nouvelle réparation n''ira sans doute pas plus loin.' -ForegroundColor Yellow }
            else { Write-Host '       Une nouvelle tentative a peu de chances d''aller plus loin, sauf après une nouvelle mise à jour de Windows.' -ForegroundColor Yellow }
        }
        if (Read-YesNo '   >> Réparer l''image Windows (DISM /RestoreHealth puis SFC, 15-45 min) ?') {
            if (Wait-ACPower 'une coupure pendant la réparation peut abîmer Windows.') { Invoke-WindowsRepair }
            else { Write-Host '   >> Réparation annulée.' -ForegroundColor DarkGray }
        }
    }
}
foreach ($L in $script:ChkdskFix) {
    Write-Host ("   >> Volume {0}: correction conseillée : chkdsk {0}: /spotfix" -f $L) -ForegroundColor Yellow
    Write-Host '      (pour le disque système, la correction a lieu au prochain redémarrage)' -ForegroundColor DarkGray
}
if ($script:DefenderScan) {
    if (Read-YesNo '   >> Lancer une analyse antivirus rapide (Microsoft Defender, quelques minutes) ?') { Invoke-DefenderQuickScan }
}
if ($script:WGCount -gt 0 -and $script:WingetExe) {
    Write-Host '   [i] winget peut fermer les applications concernées (navigateur, jeux, messageries) pendant leur mise à jour.' -ForegroundColor DarkGray
    Write-Host '       Enregistre ton travail avant de valider.' -ForegroundColor DarkGray
    if (Read-YesNo ("   >> Mettre à jour les {0} application(s) avec winget ?" -f $script:WGCount)) {
        Write-Host ''
        $okItems = @(); $koList = @(); $naList = @(); $selfList = @()
        $spans = @{}      # début et fin de chaque mise à jour, pour relire ensuite le journal de Windows
        $explained = @()  # applications dont le retard vient d'être expliqué (encore en service)
        $resolved = @()   # « terminées » encore proposées, mais dont la version a changé (autre numérotation)
        $skip = @($script:WGSkipIds)
        # Seulement les applications annoncées, une par une : plus de repli « winget upgrade --all » (v3.24, S5)
        $targets = @($script:WGItems | Where-Object { $_.Id })
        if ($targets.Count -gt 0) {
            foreach ($it in $targets) {
                if ($it.Id -eq 'Microsoft.AppInstaller') {
                    # winget est dans ce paquet et ne peut pas se remplacer pendant qu'il tourne (PC-LV le 21/11/2026 :
                    # code 0x80070002, MSIX 80073CF1 ; le Microsoft Store l'a mis à jour peu après)
                    $selfList += $it.Name
                    $skip += $it.Id
                    continue
                }
                Write-Host ''
                Write-Host ('   >> Mise à jour de ' + $it.Name) -ForegroundColor Cyan
                $null = Wait-MsiIdle
                $itStart = Get-Date
                & $script:WingetExe upgrade --id $it.Id --exact --accept-source-agreements --accept-package-agreements --disable-interactivity
                $rc = $LASTEXITCODE
                if ($rc -eq 0) {
                    $okItems += $it
                    $spans[$it.Id] = @($itStart, (Get-Date))
                }
                elseif (Test-WingetNotApplicable $rc) {
                    # La nouvelle version ne convient pas à cette installation (aucune mise à niveau applicable, ou
                    # autre technologie d'installation). Ce n'est pas une panne : l'application se met à jour seule.
                    $naList += $it.Name
                    $skip += $it.Id
                } else {
                    $koList += [pscustomobject]@{ Item = $it; Code = ('0x{0:X8}' -f $rc) }
                }
            }
        }
        Write-Host ''
        Write-Host '   >> Vérification du résultat...' -ForegroundColor DarkCyan
        $raw2 = (Split-NativeOutput -Lines @(& $script:WingetExe upgrade --accept-source-agreements --disable-interactivity 2>&1)).Out
        $leftAll = @(ConvertFrom-WingetText $raw2)
        $verif = Get-WingetScanState $raw2 $leftAll.Count
        # Certaines applications finissent leur mise à jour en se relançant après la fin de winget (Discord, autre PC
        # le 20/11/2026 : annoncé « toujours en retard », relancé seul quelques secondes plus tard, à jour au scan
        # suivant). Nouvelle lecture toutes les 20 s, 3 fois au plus, tant qu'une application annoncée « terminée » est
        # encore proposée ; une lecture illisible garde la précédente.
        # Ligne de la nouvelle liste pour une application, $null si elle n'y est plus
        $rowOf = {
            param($Id, $Rows)
            foreach ($r in @($Rows)) { if (Test-WingetStillListed $Id @($r)) { return $r } }
            return $null
        }
        # Encore proposée, mais version inscrite changée : mise à jour faite, l'éditeur numérote autrement
        $changed = {
            param($It, $Rows)
            $r = & $rowOf $It.Id $Rows
            return ($null -ne $r -and (Get-WingetVersionChange $It.Installed ([string]$r.Installed)) -eq 'CHANGED')
        }
        for ($try = 1; $try -le 3 -and $verif -ne 'UNREADABLE'; $try++) {
            $waiting = @($okItems | Where-Object { (Test-WingetStillListed $_.Id $leftAll) -and -not (& $changed $_ $leftAll) })
            if ($waiting.Count -eq 0) { break }
            if ($try -eq 1) {
                Write-Host '   >> Certaines applications finissent leur mise à jour en se relançant toutes seules.' -ForegroundColor DarkCyan
            }
            Write-Host ('   >> Ancienne version encore inscrite pour {0} application(s) : nouvelle vérification dans 20 s ({1}/3)...' -f $waiting.Count, $try) -ForegroundColor DarkCyan
            Start-Sleep -Seconds 20
            $raw3 = (Split-NativeOutput -Lines @(& $script:WingetExe upgrade --accept-source-agreements --disable-interactivity 2>&1)).Out
            $all3 = @(ConvertFrom-WingetText $raw3)
            if ((Get-WingetScanState $raw3 $all3.Count) -eq 'UNREADABLE') { break }
            $leftAll = $all3
        }
        foreach ($it in $okItems) {
            # winget a répondu « terminé » : le succès n'est annoncé que si la nouvelle liste le confirme.
            $still = Test-WingetStillListed $it.Id $leftAll
            if ($verif -eq 'UNREADABLE') { Write-Action 'INFO' ($it.Name + ' : winget a répondu « terminé », résultat non vérifié') }
            elseif ($still -and (& $changed $it $leftAll)) {
                # Preuve : la version inscrite a changé (Google Play Games sur PC-LV, 21/11/2026)
                $r = & $rowOf $it.Id $leftAll
                Write-Action 'OK' ('{0} : mise à jour vérifiée ({1} -> {2})' -f $it.Name, $it.Installed, $r.Installed)
                Write-Sub ('winget annonce encore une version {0}, numérotée autrement par l''éditeur : rien à faire' -f $r.Available)
                $resolved += $it.Id
            }
            elseif ($still -and $spans.ContainsKey($it.Id) -and (Test-AppxInUseBetween $spans[$it.Id][0] $spans[$it.Id][1])) {
                # Preuve lue dans le journal de Windows (erreur 0x80073D02)
                Write-Action 'WARN' ($it.Name + ' : nouvelle version téléchargée, mais pas installée : Windows a constaté que l''application tournait encore')
                $explained += $it.Id
                Write-Host '          Même sans fenêtre ouverte : icône près de l''horloge ou service en arrière-plan,' -ForegroundColor DarkGray
                Write-Host '          parfois lancé dès le démarrage de Windows. Le plus sûr : Microsoft Store >' -ForegroundColor DarkGray
                Write-Host '          Bibliothèque > Obtenir les mises à jour, ou la mise à jour proposée par l''application.' -ForegroundColor DarkGray
            }
            elseif ($still) {
                Write-Action 'WARN' ($it.Name + ' : winget a répondu « terminé », mais l''ancienne version est toujours là')
                Write-Host '          Si l''application vient de se relancer, refais un scan dans quelques minutes pour vérifier.' -ForegroundColor DarkGray
            }
            else { Write-Action 'OK' ($it.Name + ' : mise à jour vérifiée') }
        }
        foreach ($k in $koList) {
            $it = $k.Item
            $hint = Get-WingetErrorHint $k.Code
            if ($verif -ne 'UNREADABLE' -and -not (Test-WingetStillListed $it.Id $leftAll)) {
                # Plus proposée malgré l'erreur : faite quand même, ou application retirée par son propre installateur
                # (Java sur PC-LV le 21/11/2026 : ancienne version désinstallée, nouvelle refusée, code 1618)
                $null = & $script:WingetExe list --id $it.Id --exact --accept-source-agreements --disable-interactivity 2>&1
                $pres = Get-WingetPresence $LASTEXITCODE
                if ($pres -eq 'ABSENT') {
                    Write-Action 'FAIL' ('{0} : n''est plus installée (code {1})' -f $it.Name, $k.Code)
                    Write-Sub 'Son programme d''installation a retiré l''ancienne version, puis n''a pas pu installer la nouvelle.' 'Yellow'
                    if ($hint) { Write-Sub ('Cause probable : ' + $hint) }
                    Write-Sub 'Pour la remettre : clic droit sur Démarrer > Windows PowerShell (admin) ou Terminal (admin), puis :' 'Yellow'
                    Write-Sub ('winget install --id {0} --exact' -f $it.Id) 'Yellow'
                    $resolved += $it.Id
                    continue
                }
                if ($pres -eq 'PRESENT') {
                    Write-Action 'INFO' ('{0} : winget a signalé une erreur (code {1}), mais elle n''est plus en retard' -f $it.Name, $k.Code)
                    continue
                }
            }
            Write-Action 'FAIL' ('{0} : code {1}' -f $it.Name, $k.Code)
            if ($hint) {
                Write-Sub $hint
                # Cause déjà dite : pas de « l'application tournait encore » pour elle dans la liste des retards
                $explained += $it.Id
            }
        }
        foreach ($n in $selfList) {
            Write-Action 'INFO' ($n + ' : contient winget, qui ne peut pas se remplacer pendant qu''il tourne ; le Microsoft Store le met à jour')
        }
        # Toujours en retard : sans les applications que winget refuse, ni celles réglées ci-dessus
        $left = @($leftAll | Where-Object {
                $row = $_
                ($skip -notcontains $row.Id) -and (@($resolved | Where-Object { Test-WingetStillListed $_ @($row) }).Count -eq 0)
            })
        foreach ($n in $naList) {
            Write-Action 'INFO' ($n + ' : winget n''a pas de version adaptée à cette installation')
            Write-Host '          Mets-la à jour depuis l''application elle-même (souvent automatique à son ouverture).' -ForegroundColor DarkGray
        }
        if ($left.Count -gt 0) {
            Write-Action 'WARN' ("{0} application(s) toujours en retard :" -f $left.Count)
            foreach ($l in $left) {
                Write-Host ('       - ' + (Cut $l.Name 60) + '  ' + $l.Installed + ' -> ' + $l.Available) -ForegroundColor Yellow
                $script:Report.Add('       - ' + (Cut $l.Name 60) + '  ' + $l.Installed + ' -> ' + $l.Available)
            }
            if (@($left | Where-Object { $explained -notcontains $_.Id }).Count -gt 0) {
                # Au moins un retard sans explication lue dans le journal : cause la plus courante rappelée
                Write-Host '       Cause fréquente : l''application tournait encore pendant la mise à jour, parfois sans fenêtre' -ForegroundColor DarkGray
                Write-Host '       (icône près de l''horloge, service en arrière-plan). Ferme-la complètement ou redémarre le PC,' -ForegroundColor DarkGray
                Write-Host '       puis relance JARVIS ; sinon mets-la à jour depuis l''application ou le Microsoft Store.' -ForegroundColor DarkGray
            }
        } elseif ($leftAll.Count -gt 0) {
            # Seules restent des applications que winget refuse de mettre à jour (signalées ci-dessus)
            Write-Action 'OK' 'Vérifié : tout ce que winget peut mettre à jour est à jour'
        } elseif ($verif -eq 'NONE') {
            Write-Action 'OK' 'Vérifié : toutes les applications sont à jour'
        } else {
            # Ni liste lisible, ni message « aucune mise à jour » : on ne conclut pas
            Write-Action 'WARN' 'Vérification impossible : la réponse de winget n''a pas pu être lue'
            Write-Host '          Relance un scan pour contrôler.' -ForegroundColor DarkGray
        }
    }
}
if (@($script:StoreItems).Count -gt 0) {
    Write-Host ('   [i] Applications du Microsoft Store concernées : ' + (Cut ((@($script:StoreItems) | ForEach-Object { $_.Name }) -join ', ') 80)) -ForegroundColor DarkGray
    Write-Host '       Une application ouverte ne peut pas être mise à jour : ferme-les avant de valider.' -ForegroundColor DarkGray
    if (Read-YesNo ("   >> Mettre à jour les {0} application(s) du Microsoft Store ?" -f @($script:StoreItems).Count)) {
        Write-Host ''
        Update-StoreApps
    }
}
if ($script:WUCount -eq 0 -and $script:WUManual -gt 0) {
    Write-Host ''
    Write-Host ("   {0} mise(s) à jour Windows demandent une action à l'écran (souvent des pilotes de périphériques)." -f $script:WUManual) -ForegroundColor Cyan
    if (Read-YesNo '   >> Ouvrir Windows Update avec le mode d''emploi ?') { Open-WindowsUpdateGuided }
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
    $a = Read-Choice ('   >> Choix [' + ($wkeys -join '/') + '] (Entrée = N)') $wkeys 'N'
    if ($a -eq '1' -and $isAdmin) { Install-WindowsUpdates }
    elseif ($a -eq '2') { Open-WindowsUpdateGuided }
}
$cleanProp = Get-CleanProposal $script:CleanTargets $CleanMinBytes $isAdmin
if (@($cleanProp.Items).Count -gt 0) {
    Write-Host ''
    $cpTxt = Format-Bytes $cleanProp.Bytes
    if (@($cleanProp.Items | Where-Object { $_.Key -eq 'Components' }).Count -gt 0) { $cpTxt += ' + composants Windows' }
    Write-Host ('   NETTOYAGE : ' + $cpTxt + ' récupérables') -ForegroundColor Cyan
    Write-Host '   Suppressions définitives : une question par élément, réponse par défaut non.' -ForegroundColor DarkGray
    foreach ($t in @($cleanProp.Items)) { Invoke-CleanTarget $t }
}
if ($script:WinOld) {
    Write-Host ''
    Write-Host '   [i] Windows.old : ancienne version de Windows, gardée pour pouvoir y revenir. J.A.R.V.I.S. n''y touche pas.' -ForegroundColor DarkGray
    if (Read-YesNo '   >> Ouvrir Paramètres > Stockage pour le retirer toi-même ?') {
        Write-Host '   Dans la fenêtre qui s''ouvre : Fichiers temporaires, coche « Installation(s) précédente(s) de Windows »,' -ForegroundColor Cyan
        Write-Host '   puis « Supprimer les fichiers ». Après cela, revenir à la version précédente ne sera plus possible.' -ForegroundColor Cyan
        try { Start-Process 'ms-settings:storagesense' -ErrorAction Stop }
        catch { Write-Host '   [!] Ouverture impossible : Démarrer > Paramètres > Système > Stockage.' -ForegroundColor Yellow }
    }
}

if ($repFile -and $script:Report.Count -gt $repMark) {
    # Le rapport a été enregistré avant les actions : il est complété avec leur résultat
    $script:Report.Insert($repMark, '== ACTIONS LANCÉES APRÈS LE SCAN ==')
    $script:Report.Insert($repMark, '')
    if (Update-Report $repFile ([string[]]$script:Report)) {
        Write-Host '   >> Rapport complété avec le résultat des actions.' -ForegroundColor DarkGray
    } else {
        Write-Host '   [!] Rapport non complété : le résultat des actions n''y figure pas.' -ForegroundColor Yellow
    }
}
if ($repFile) {
    if (Read-YesNo '   >> Ouvrir le rapport ?') { Start-Process -FilePath (Get-SystemToolPath 'notepad.exe') -ArgumentList ('"{0}"' -f $repFile) }
}

$null = Set-NoSleep $false
Write-Host ''
Type-Line '   >> Fin de session. J.A.R.V.I.S. se met en veille.' 'DarkCyan'
Read-Answer '   [Entrée pour fermer]' | Out-Null
} finally {
    try { [Console]::TreatControlCAsInput = $false } catch {}
    $null = Set-QuickEdit $false
    Restore-ConsoleFont
    $null = Set-NoSleep $false
    if ($script:JarvisMutex) { try { $script:JarvisMutex.ReleaseMutex() } catch {} }
}
