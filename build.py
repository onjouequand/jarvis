"""Fabrique JARVIS.cmd à partir de src/jarvis-checkup.ps1.

Usage : python build.py   (sous Windows : le contrôle utilise Windows PowerShell 5.1)
- lance tools/check.ps1 -RequireAnalyzer (vrai analyseur PowerShell, règles du projet, tests T1,
  PSScriptAnalyzer exigé) et refuse de fabriquer si un contrôle échoue ;
- vérifie la structure du script (guillemets, commentaires, parenthèses/accolades/crochets) ;
- refuse les tirets cadratin et demi-cadratin et les guillemets typographiques ;
- assemble l'en-tête batch + le code PowerShell, calcule l'empreinte SHA-256 du code
  et l'inscrit dans l'en-tête (contrôle d'intégrité au lancement) ;
- vérifie que l'en-tête batch garde sa longueur (voir HEADER_RESUME) et que la taille est plausible ;
- écrit JARVIS.cmd en UTF-8 sans BOM, fins de ligne CRLF (fichier temporaire puis remplacement).
Ne jamais modifier JARVIS.cmd à la main : l'empreinte ne correspondrait plus.

v3.25 (audit, constat T7) : chaque contrôle arrête la fabrication par refuse(), jamais par « assert »,
que « python -O » désactive ; PSScriptAnalyzer est exigé comme sur GitHub (copie locale dans .modules\).
"""
import hashlib, os, re, subprocess, sys
ROOT = os.path.dirname(os.path.abspath(__file__))
SRC = os.path.join(ROOT, 'src', 'jarvis-checkup.ps1')
OUT = os.path.join(ROOT, 'JARVIS.cmd')
CHECK = os.path.join(ROOT, 'tools', 'check.ps1')
# Octet où cmd.exe reprend la lecture de JARVIS.cmd quand PowerShell se termine (début de la ligne
# « set "JARVIS_RC=... »). La mise à jour en ligne remplace le fichier PENDANT qu'il s'exécute : cmd
# reprend alors au même octet dans le NOUVEAU fichier. Si l'en-tête change de longueur, cmd exécute un
# morceau de ligne. Ne changer cette valeur qu'avec une transition prévue pour les versions installées.
HEADER_RESUME = 1107


def refuse(message):
    sys.exit("Fabrication refusée : %s. JARVIS.cmd n'a pas été modifié." % message)


rc = subprocess.call(['powershell.exe', '-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', CHECK, '-RequireAnalyzer'], cwd=ROOT)
if rc != 0:
    refuse('tools/check.ps1 a échoué (code %d)' % rc)
if open(SRC, 'rb').read(3) != b'\xef\xbb\xbf':
    refuse('BOM UTF-8 absent de la source')
s = open(SRC, encoding='utf-8-sig').read().replace('\r\n', '\n')


def structure_error(s):
    """Guillemets, commentaires et parenthèses/accolades/crochets équilibrés ; None si tout va bien."""
    i = 0; n = len(s); stack = []; line = 1
    try:
        while i < n:
            c = s[i]
            if c == '\n': line += 1
            if s.startswith('<#', i):
                j = s.index('#>', i); line += s[i:j].count('\n'); i = j + 2; continue
            if c == '#':
                i = s.find('\n', i)
                if i < 0: break
                continue
            if c == "'":
                j = i + 1
                while True:
                    if s[j] == "'" and j + 1 < n and s[j + 1] == "'": j += 2; continue
                    if s[j] == "'": break
                    j += 1
                line += s[i:j].count('\n'); i = j + 1; continue
            if c == '"':
                j = i + 1
                while s[j] != '"':
                    if s[j] == '`': j += 1
                    j += 1
                line += s[i:j].count('\n'); i = j + 1; continue
            if c == '`': i += 2; continue
            if c in '{([': stack.append((c, line))
            elif c in '})]':
                if not stack: return 'fermeture %r sans ouverture, ligne %d' % (c, line)
                o, l = stack.pop()
                if {'}': '{', ')': '(', ']': '['}[c] != o:
                    return 'fermeture %r ligne %d pour une ouverture %r ligne %d' % (c, line, o, l)
            i += 1
    except (IndexError, ValueError):
        return 'chaîne ou commentaire non fermé (vers la ligne %d)' % line
    if stack:
        return 'ouverture(s) non fermée(s) : %s' % stack[:3]
    return None


err = structure_error(s)
if err:
    refuse('structure du script : ' + err)
if '—' in s or '–' in s:
    refuse('tiret cadratin ou demi-cadratin interdit')
badq = [c for c in '‘’‚‛“”„' if c in s]
if badq:
    refuse('guillemets typographiques interdits (PowerShell les traite comme des guillemets) : %r' % badq)
# v3.24 : l'en-tête n'évalue plus les arguments (Invoke-Expression jusqu'à la v3.23, constat S1 de l'audit) ;
# le programme les lit lui-même dans JARVIS_ARGS (ConvertFrom-JarvisArgLine). Le commentaire en fin de ligne
# garde la longueur de l'en-tête (HEADER_RESUME).
header_tpl = r'''<# : JARVIS.cmd. Ne pas modifier ce texte
@echo off
rem JARVIS-SHA256=__HASH__
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
'''
if '#>' in header_tpl[:header_tpl.rindex('#>')]:
    refuse("séquence #> dans l'en-tête avant la ligne de fermeture")
body = ('\n' + s).replace('\r\n', '\n').replace('\n', '\r\n')   # starts with CRLF after "#>"
h = hashlib.sha256(body.encode('utf-8')).hexdigest()
head = header_tpl.replace('__HASH__', h).rstrip('\n').replace('\n', '\r\n')
resume = len(head[:head.index('\r\nset "JARVIS_RC=') + 2].encode('utf-8'))
if resume != HEADER_RESUME:
    refuse("longueur de l'en-tête modifiée : reprise à l'octet %d au lieu de %d (voir HEADER_RESUME)" % (resume, HEADER_RESUME))
full = head + body
# Même vérification que celle que fera l'en-tête au lancement
e = full.index('\n#>'); b = full[e + 3:]
if hashlib.sha256(b.encode('utf-8')).hexdigest() != h:
    refuse("empreinte recalculée différente de celle inscrite dans l'en-tête")
data = full.encode('utf-8')
if not (1000 < len(data) < 5 * 1024 * 1024):
    refuse('taille refusée par la mise à jour en ligne (%d octets)' % len(data))
with open(OUT + '.tmp', 'wb') as f:
    f.write(data)
os.replace(OUT + '.tmp', OUT)
v = re.search(r"\$JarvisVersion = '([^']+)'", s)
print('JARVIS.cmd fabriqué : v%s, %d octets, SHA-256 %s...' % (v.group(1) if v else '?', len(data), h[:12]))
