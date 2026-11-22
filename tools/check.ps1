<#
Contrôle de src/jarvis-checkup.ps1 avant fabrication. Lancé par build.py et par la CI GitHub.

  powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\check.ps1 [-RequireAnalyzer]

Ne lance jamais le programme : il analyse le texte et l'arbre syntaxique, puis exécute seulement
les tests T1 (fonctions pures, aucune dépendance au PC). Code de sortie : 0 si tout passe, 1 sinon.

  1. Fichier    : UTF-8 avec BOM, fins de ligne CRLF, caractères interdits
  2. Syntaxe    : le vrai analyseur de Windows PowerShell 5.1
  3. Règles     : version cohérente, Read-Host, questions oui/non, Invoke-Expression,
                  suppressions récursives, outils système appelés sans chemin, blocs catch vides
  4. Tests T1   : Invoke-SelfTestAnalyzers, hors console, en mode strict
  5. PSScriptAnalyzer (s'il est installé ; exigé avec -RequireAnalyzer)
#>
param(
    [string]$Source,
    [switch]$RequireAnalyzer
)

$ErrorActionPreference = 'Stop'
try { [Console]::OutputEncoding = [Text.Encoding]::UTF8 } catch { $null = $_ }

$Root = Split-Path -Parent $PSScriptRoot
if (-not $Source) { $Source = Join-Path $Root 'src\jarvis-checkup.ps1' }
$Settings = Join-Path $Root 'PSScriptAnalyzerSettings.psd1'

# ------------------------------------------------------------------
# Plafonds : ils ne peuvent que BAISSER. Chaque valeur est le nombre de cas connus et justifiés.
# ------------------------------------------------------------------
# Blocs « catch {} » vides (échec ignoré en silence).
$MaxEmptyCatch = 25
# Outils système appelés par leur seul nom (recherche dans le PATH) : plus aucun depuis la v3.13,
# tous passent par Get-SystemToolPath.
$MaxBareTools = 0
# « Remove-Item -Recurse » autorisés, par fonction : seulement la clé de registre de la désinstallation.
# Les dossiers se suppriment par Remove-TreeNoJunction, qui ne suit aucune jonction.
$RecurseAllowed = @{ 'Uninstall-Jarvis' = 1 }
# Suppressions de bas niveau autorisées, par fonction (règle 18) : [IO.File]::Delete, [IO.Directory]::Delete,
# vidage de la corbeille (SHEmptyRecycleBin) et suppression par CIM (Invoke-CimMethod -MethodName Delete).
# Invoke-SelfTest : jonctions et fichiers des bacs à sable des tests T5 seulement.
$LowDeleteAllowed = @{ 'Remove-TempCandidates' = 2; 'Remove-EmptyDir' = 1; 'Remove-TreeNoJunction' = 1; 'Clear-CleanTarget' = 1;
                       'Clear-RecycleBinChecked' = 1; 'Clear-DoCache' = 1; 'Invoke-SelfTest' = 5 }
# Nombre minimal de tests T1 attendus (garde-fou contre un lot de tests vidé par erreur).
$MinT1 = 65

$script:Fails = New-Object System.Collections.Generic.List[string]
function Add-Fail([string]$Message) {
    $script:Fails.Add($Message)
    Write-Host ('  [FAIL] ' + $Message) -ForegroundColor Red
}
function Add-Pass([string]$Message) { Write-Host ('  [ OK ] ' + $Message) -ForegroundColor Green }
function Add-Note([string]$Message) { Write-Host ('  [INFO] ' + $Message) -ForegroundColor Cyan }
function Write-Step([string]$Title) { Write-Host ''; Write-Host $Title -ForegroundColor White }

function Get-OuterFunction($Node) {
    # Nom de la fonction de premier niveau qui contient ce noeud, ou « (programme principal) »
    $name = '(programme principal)'
    $p = $Node.Parent
    while ($p) {
        if ($p -is [System.Management.Automation.Language.FunctionDefinitionAst]) { $name = $p.Name }
        $p = $p.Parent
    }
    return $name
}

Write-Host ('Contrôle de ' + $Source) -ForegroundColor White

# ------------------------------------------------------------------
# 1. Fichier
# ------------------------------------------------------------------
Write-Step '1. Fichier'
$bytes = [IO.File]::ReadAllBytes($Source)
if ($bytes.Length -gt 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF) {
    Add-Pass 'UTF-8 avec BOM'
} else {
    Add-Fail 'BOM UTF-8 absent : Windows PowerShell 5.1 lirait mal les accents'
}
$text = [Text.Encoding]::UTF8.GetString($bytes)
$lines = $text -split "`n"
$loneLf = 0
for ($i = 0; $i -lt $lines.Count - 1; $i++) { if (-not $lines[$i].EndsWith("`r")) { $loneLf++ } }
if ($loneLf -eq 0) { Add-Pass 'fins de ligne CRLF' }
else { Add-Fail ("{0} ligne(s) terminée(s) par LF seul (sed de Git Bash ?) : la source doit rester en CRLF" -f $loneLf) }

$forbidden = @{
    0x2014 = 'tiret cadratin'; 0x2013 = 'tiret demi-cadratin'
    0x2018 = 'guillemet typographique'; 0x2019 = 'guillemet typographique'; 0x201A = 'guillemet typographique'
    0x201B = 'guillemet typographique'; 0x201C = 'guillemet typographique'; 0x201D = 'guillemet typographique'
    0x201E = 'guillemet typographique'
}
$badChars = 0
foreach ($code in $forbidden.Keys) {
    $ch = [string][char]$code
    for ($i = 0; $i -lt $lines.Count; $i++) {
        if ($lines[$i].Contains($ch)) {
            $badChars++
            Add-Fail ("ligne {0} : {1} (U+{2:X4}) interdit" -f ($i + 1), $forbidden[$code], $code)
        }
    }
}
if ($badChars -eq 0) { Add-Pass 'aucun tiret long ni guillemet typographique' }

# ------------------------------------------------------------------
# 2. Syntaxe
# ------------------------------------------------------------------
Write-Step '2. Syntaxe (analyseur PowerShell)'
$tokens = $null
$errors = $null
$ast = [System.Management.Automation.Language.Parser]::ParseFile($Source, [ref]$tokens, [ref]$errors)
if (@($errors).Count -eq 0) {
    Add-Pass ('aucune erreur (PowerShell ' + $PSVersionTable.PSVersion.ToString() + ')')
} else {
    foreach ($e in @($errors) | Select-Object -First 10) {
        Add-Fail ("ligne {0} : {1}" -f $e.Extent.StartLineNumber, $e.Message)
    }
}
if ($PSVersionTable.PSVersion.Major -ne 5) {
    Add-Fail 'ce contrôle doit tourner sous Windows PowerShell 5.1 (powershell.exe), pas PowerShell 7'
}

# ------------------------------------------------------------------
# 3. Règles du projet
# ------------------------------------------------------------------
Write-Step '3. Règles du projet'

# Version : la même aux 4 endroits (règle 13 de CLAUDE.md)
$vCode = [regex]::Matches($text, '(?m)^\$JarvisVersion = ''([0-9.]+)''')
$vDoc = [regex]::Matches($text, 'Check-up système v([0-9.]+)')
$vBanner = [regex]::Matches($text, 'module check-up v([0-9.]+)')
$versions = @()
foreach ($m in @($vCode) + @($vDoc) + @($vBanner)) { $versions += $m.Groups[1].Value }
$distinct = @($versions | Select-Object -Unique)
if ($vCode.Count -ne 1 -or $vDoc.Count -ne 1 -or $vBanner.Count -ne 2) {
    Add-Fail ("version : attendu 1 `$JarvisVersion, 1 en-tête et 2 bannières ; trouvé {0}, {1} et {2}" -f $vCode.Count, $vDoc.Count, $vBanner.Count)
} elseif ($distinct.Count -ne 1) {
    Add-Fail ('version incohérente entre $JarvisVersion, en-tête et bannières : ' + ($versions -join ', '))
} else {
    Add-Pass ('version ' + $distinct[0] + ' identique aux 4 endroits')
}

$commands = @($ast.FindAll({ param($n) $n -is [System.Management.Automation.Language.CommandAst] }, $true))

# Toute saisie passe par Read-Answer (règle 4)
$readHost = @($commands | Where-Object { [string]$_.GetCommandName() -match '(^|\\)Read-Host$' })
$badRead = @($readHost | Where-Object { (Get-OuterFunction $_) -ne 'Read-Answer' })
if ($badRead.Count -eq 0) { Add-Pass 'Read-Host seulement dans Read-Answer' }
else { foreach ($c in $badRead) { Add-Fail ("ligne {0} : Read-Host hors de Read-Answer" -f $c.Extent.StartLineNumber) } }

# Toute question oui/non passe par Read-YesNo (règle 16) : la marque de réponse par défaut n'existe que là,
# et aucune réponse n'est jugée sur sa première lettre
$yesNoMarks = @($ast.FindAll({
    param($n) $n -is [System.Management.Automation.Language.StringConstantExpressionAst] -and
              ($n.Value -cmatch '\[o/N\]' -or $n.Value -cmatch '\[O/n\]')
}, $true) | Where-Object { (Get-OuterFunction $_) -ne 'Read-YesNo' })
$firstLetter = @([regex]::Matches($text, "(?m)^.*\^\[(oOyY|nN|yYoO|Nn)\].*$"))
$testNo = @($commands | Where-Object { [string]$_.GetCommandName() -eq 'Test-No' })
if ($yesNoMarks.Count -eq 0 -and $firstLetter.Count -eq 0 -and $testNo.Count -eq 0) {
    Add-Pass 'questions oui/non seulement par Read-YesNo'
} else {
    foreach ($c in $yesNoMarks) { Add-Fail ("ligne {0} : question oui/non hors de Read-YesNo" -f $c.Extent.StartLineNumber) }
    foreach ($c in $testNo) { Add-Fail ("ligne {0} : Test-No n'existe plus, utiliser Read-YesNo" -f $c.Extent.StartLineNumber) }
    foreach ($m in $firstLetter) { Add-Fail ('réponse jugée sur sa première lettre, utiliser Read-YesNo : ' + $m.Value.Trim().Substring(0, [Math]::Min(70, $m.Value.Trim().Length))) }
}

# Aucune exécution de texte
$iex = @($commands | Where-Object { [string]$_.GetCommandName() -match '^(Invoke-Expression|iex)$' })
if ($iex.Count -eq 0) { Add-Pass 'aucun Invoke-Expression' }
else { foreach ($c in $iex) { Add-Fail ("ligne {0} : Invoke-Expression interdit" -f $c.Extent.StartLineNumber) } }

# Suppressions récursives : liste blanche par fonction (règle 6)
$recurse = @($commands | Where-Object {
    [string]$_.GetCommandName() -eq 'Remove-Item' -and
    @($_.CommandElements | Where-Object {
        $_ -is [System.Management.Automation.Language.CommandParameterAst] -and $_.ParameterName -like 'Rec*'
    }).Count -gt 0
})
$recurseOk = $true
foreach ($g in ($recurse | Group-Object { Get-OuterFunction $_ })) {
    $allowed = 0
    if ($RecurseAllowed.ContainsKey($g.Name)) { $allowed = $RecurseAllowed[$g.Name] }
    if ($g.Count -gt $allowed) {
        $recurseOk = $false
        $where = ($g.Group | ForEach-Object { $_.Extent.StartLineNumber }) -join ', '
        Add-Fail ("Remove-Item -Recurse dans {0} : {1} trouvé(s), {2} autorisé(s) (lignes {3})" -f $g.Name, $g.Count, $allowed, $where)
    }
}
if ($recurseOk) { Add-Pass ("Remove-Item -Recurse : {0}, tous sur liste blanche" -f $recurse.Count) }

# Suppressions de bas niveau : liste blanche par fonction (règle 18)
$lowDel = @($ast.FindAll({
    param($n)
    if (-not ($n -is [System.Management.Automation.Language.InvokeMemberExpressionAst]) -or -not $n.Static) { return $false }
    $m = [string]$n.Member.Extent.Text
    $ty = [string]$n.Expression.Extent.Text
    return (($m -eq 'Delete' -and $ty -match '^\[(System\.)?IO\.(File|Directory)\]$') -or $m -eq 'SHEmptyRecycleBin')
}, $true))
$lowDel += @($commands | Where-Object { [string]$_.GetCommandName() -eq 'Invoke-CimMethod' -and $_.Extent.Text -match '-MethodName\s+[''"]?Delete\b' })
$lowOk = $true
foreach ($g in ($lowDel | Group-Object { Get-OuterFunction $_ })) {
    $allowed = 0
    if ($LowDeleteAllowed.ContainsKey($g.Name)) { $allowed = $LowDeleteAllowed[$g.Name] }
    if ($g.Count -gt $allowed) {
        $lowOk = $false
        $where = ($g.Group | ForEach-Object { $_.Extent.StartLineNumber }) -join ', '
        Add-Fail ("suppression de bas niveau dans {0} : {1} trouvée(s), {2} autorisée(s) (lignes {3})" -f $g.Name, $g.Count, $allowed, $where)
    }
}
if ($lowOk) { Add-Pass ("suppressions de bas niveau : {0}, toutes sur liste blanche" -f $lowDel.Count) }

# Outils système appelés par leur seul nom : un programme du même nom placé dans le PATH serait lancé en admin
$bare = @($commands | Where-Object {
    [string]$_.GetCommandName() -match '^(dism|sfc|chkdsk|shutdown|powercfg|bcdedit|reg|netsh|wevtutil|cleanmgr|cmd|powershell)(\.exe)?$'
})
$bareWhere = ($bare | ForEach-Object { '{0} l.{1}' -f $_.GetCommandName(), $_.Extent.StartLineNumber }) -join ', '
if ($bare.Count -gt $MaxBareTools) {
    Add-Fail ("outils système appelés sans chemin complet : {0}, plafond {1} ({2})" -f $bare.Count, $MaxBareTools, $bareWhere)
} elseif ($bare.Count -lt $MaxBareTools) {
    Add-Fail ("outils système sans chemin : {0}, plafond {1} : baisse `$MaxBareTools à {0} dans tools\check.ps1" -f $bare.Count, $MaxBareTools)
} elseif ($bare.Count -eq 0) {
    Add-Pass 'outils système tous appelés par chemin complet'
} else {
    Add-Note ("outils système sans chemin : {0} connus, à corriger ({1})" -f $bare.Count, $bareWhere)
}

# Blocs catch vides
$emptyCatch = @($ast.FindAll({
    param($n) $n -is [System.Management.Automation.Language.CatchClauseAst] -and $n.Body.Statements.Count -eq 0
}, $true))
if ($emptyCatch.Count -gt $MaxEmptyCatch) {
    $known = ($emptyCatch | ForEach-Object { $_.Extent.StartLineNumber }) -join ', '
    Add-Fail ("blocs catch vides : {0}, plafond {1} (lignes {2})" -f $emptyCatch.Count, $MaxEmptyCatch, $known)
} elseif ($emptyCatch.Count -lt $MaxEmptyCatch) {
    Add-Fail ("blocs catch vides : {0}, plafond {1} : baisse `$MaxEmptyCatch à {0} dans tools\check.ps1" -f $emptyCatch.Count, $MaxEmptyCatch)
} else {
    Add-Pass ("blocs catch vides : {0} (plafond {1})" -f $emptyCatch.Count, $MaxEmptyCatch)
}

# ------------------------------------------------------------------
# 4. Tests T1 hors console
# ------------------------------------------------------------------
Write-Step '4. Tests T1 (analyseurs, hors console, mode strict)'
if (@($errors).Count -gt 0) {
    Add-Fail 'tests T1 non lancés : la source a des erreurs de syntaxe'
} else {
    # Fonctions de premier niveau et les seules variables globales dont T1 a besoin
    $needVars = @('$JarvisVersion', '$JarvisRepo', '$script:GlyphMap')
    $parts = @()
    foreach ($st in $ast.EndBlock.Statements) {
        if ($st -is [System.Management.Automation.Language.AssignmentStatementAst] -and $needVars -contains $st.Left.Extent.Text) {
            $parts += $st.Extent.Text
        } elseif ($st -is [System.Management.Automation.Language.FunctionDefinitionAst]) {
            $parts += $st.Extent.Text
        }
    }
    $prelude = [scriptblock]::Create(($parts -join "`r`n"))
    $t1 = New-Object System.Collections.Generic.List[object]
    try {
        & {
            # Même réglage que le programme (ligne « $ErrorActionPreference » de la source)
            $ErrorActionPreference = 'SilentlyContinue'
            . $prelude
            function Write-Section { }
            function Assert-True([bool]$Cond, [string]$Msg) { if (-not $Cond) { throw $Msg } }
            function Test-Case([string]$Name, [scriptblock]$Body, [switch]$NeedAdmin) {
                try {
                    $r = & $Body | Select-Object -Last 1
                    $t1.Add([pscustomobject]@{ Name = $Name; Ok = $true; Detail = [string]$r })
                } catch {
                    $t1.Add([pscustomobject]@{ Name = $Name; Ok = $false; Detail = $_.Exception.Message })
                }
            }
            Set-StrictMode -Version Latest
            Invoke-SelfTestAnalyzers
        }
    } catch {
        Add-Fail ('tests T1 interrompus : ' + $_.Exception.Message)
    }
    $ko = @($t1 | Where-Object { -not $_.Ok })
    foreach ($k in $ko) { Add-Fail ("T1 « {0} » : {1}" -f $k.Name, $k.Detail) }
    if ($t1.Count -lt $MinT1) {
        Add-Fail ("seulement {0} test(s) T1 exécuté(s), au moins {1} attendus" -f $t1.Count, $MinT1)
    } elseif ($ko.Count -eq 0) {
        Add-Pass ("{0} tests T1 réussis" -f $t1.Count)
    }
}

# ------------------------------------------------------------------
# 5. PSScriptAnalyzer
# ------------------------------------------------------------------
Write-Step '5. PSScriptAnalyzer'
# Copie locale possible dans .modules\ (hors dépôt) : sur un PC où Documents est protégé (OneDrive, Accès
# contrôlé aux dossiers), « Install-Module -Scope CurrentUser » échoue. Pour la poser :
#   Save-Module -Name PSScriptAnalyzer -Repository PSGallery -Path .modules
$localModules = Join-Path $Root '.modules'
if (Test-Path -LiteralPath $localModules) { $env:PSModulePath = $localModules + ';' + $env:PSModulePath }
$pssa = Get-Module -ListAvailable -Name PSScriptAnalyzer | Sort-Object Version -Descending | Select-Object -First 1
if (-not $pssa) {
    if ($RequireAnalyzer) { Add-Fail 'PSScriptAnalyzer absent alors qu''il est exigé (-RequireAnalyzer)' }
    else { Add-Note 'non installé sur ce PC : étape sautée (la CI GitHub la fait). Pour l''avoir : Save-Module -Name PSScriptAnalyzer -Repository PSGallery -Path .modules' }
} else {
    try {
        Import-Module PSScriptAnalyzer -ErrorAction Stop
        $found = @(Invoke-ScriptAnalyzer -Path $Source -Settings $Settings)
        if ($found.Count -eq 0) { Add-Pass ('aucune remarque (version ' + $pssa.Version + ')') }
        else {
            foreach ($f in $found | Select-Object -First 30) {
                Add-Fail ("ligne {0} : {1} : {2}" -f $f.Line, $f.RuleName, $f.Message)
            }
            if ($found.Count -gt 30) { Add-Fail ("... et {0} autre(s) remarque(s)" -f ($found.Count - 30)) }
        }
    } catch {
        Add-Fail ('PSScriptAnalyzer en erreur : ' + $_.Exception.Message)
    }
}

# ------------------------------------------------------------------
Write-Host ''
if ($script:Fails.Count -gt 0) {
    Write-Host ("CONTRÔLE REFUSÉ : {0} problème(s)." -f $script:Fails.Count) -ForegroundColor Red
    exit 1
}
Write-Host 'CONTRÔLE RÉUSSI.' -ForegroundColor Green
exit 0
