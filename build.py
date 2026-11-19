"""Fabrique JARVIS.cmd à partir de src/jarvis-checkup.ps1.

Usage : python build.py   (sous Windows : le contrôle utilise Windows PowerShell 5.1)
- lance tools/check.ps1 (vrai analyseur PowerShell, règles du projet, tests T1, PSScriptAnalyzer)
  et refuse de fabriquer si un contrôle échoue ;
- vérifie la structure du script (guillemets, commentaires, parenthèses/accolades/crochets) ;
- refuse les tirets cadratin et demi-cadratin et les guillemets typographiques ;
- assemble l'en-tête batch + le code PowerShell, calcule l'empreinte SHA-256 du code
  et l'inscrit dans l'en-tête (contrôle d'intégrité au lancement) ;
- vérifie que l'en-tête batch garde sa longueur (voir HEADER_RESUME) et que la taille est plausible ;
- écrit JARVIS.cmd en UTF-8 sans BOM, fins de ligne CRLF (fichier temporaire puis remplacement).
Ne jamais modifier JARVIS.cmd à la main : l'empreinte ne correspondrait plus.
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
rc = subprocess.call(['powershell.exe', '-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', CHECK], cwd=ROOT)
if rc != 0:
    sys.exit("Fabrication refusée : tools/check.ps1 a échoué (code %d). JARVIS.cmd n'a pas été modifié." % rc)
assert open(SRC,'rb').read(3) == b'\xef\xbb\xbf', 'BOM UTF-8 absent de la source'
s=open(SRC,encoding='utf-8-sig').read().replace('\r\n','\n')
# --- structural check (quotes, comments, brackets)
i=0;n=len(s);stack=[];line=1;err=None
while i<n:
    c=s[i]
    if c=='\n': line+=1
    if s.startswith('<#',i):
        j=s.index('#>',i); line+=s[i:j].count('\n'); i=j+2; continue
    if c=='#':
        i=s.find('\n',i); continue
    if c=="'":
        j=i+1
        while True:
            if s[j]=="'" and j+1<n and s[j+1]=="'": j+=2; continue
            if s[j]=="'": break
            j+=1
        line+=s[i:j].count('\n'); i=j+1; continue
    if c=='"':
        j=i+1
        while s[j]!='"':
            if s[j]=='`': j+=1
            j+=1
        line+=s[i:j].count('\n'); i=j+1; continue
    if c=='`': i+=2; continue
    if c in '{([': stack.append((c,line))
    elif c in '})]':
        o,l=stack.pop()
        if {'}':'{',')':'(',']':'['}[c]!=o: err=('mismatch',line); break
    i+=1
assert not err and not stack, (err, stack[:3])
assert '—' not in s and '–' not in s, 'tiret cadratin ou demi-cadratin interdit'
badq=[c for c in '\u2018\u2019\u201a\u201b\u201c\u201d\u201e' if c in s]
assert not badq, ('guillemets typographiques interdits (PowerShell les traite comme des guillemets)', badq)
header_tpl = r'''<# : JARVIS.cmd - fichier hybride batch + PowerShell. Ne pas modifier ce fichier.
@echo off
rem JARVIS-SHA256=__HASH__
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
'''
assert '#>' not in header_tpl[:header_tpl.rindex('#>')], 'early #> in header'
body = ('\n' + s).replace('\r\n','\n').replace('\n','\r\n')   # starts with CRLF after "#>"
h = hashlib.sha256(body.encode('utf-8')).hexdigest()
head = header_tpl.replace('__HASH__', h).rstrip('\n').replace('\n','\r\n')
resume = len(head[:head.index('\r\nset "JARVIS_RC=') + 2].encode('utf-8'))
assert resume == HEADER_RESUME, ("longueur de l'en-tête modifiée (voir HEADER_RESUME)", resume)
full = head + body
# verify like PowerShell will
e = full.index('\n#>'); b = full[e+3:]
assert hashlib.sha256(b.encode('utf-8')).hexdigest() == h
data = full.encode('utf-8')
assert 1000 < len(data) < 5 * 1024 * 1024, ('taille refusée par la mise à jour en ligne', len(data))
with open(OUT + '.tmp', 'wb') as f:
    f.write(data)
os.replace(OUT + '.tmp', OUT)
v = re.search(r"\$JarvisVersion = '([^']+)'", s)
print('JARVIS.cmd fabriqué : v%s, %d octets, SHA-256 %s...' % (v.group(1) if v else '?', len(data), h[:12]))
