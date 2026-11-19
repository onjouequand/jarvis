"""Fabrique JARVIS.cmd à partir de src/jarvis-checkup.ps1.

Usage : python build.py
- vérifie la structure du script (guillemets, commentaires, parenthèses/accolades/crochets) ;
- refuse le tiret cadratin et les guillemets typographiques ;
- assemble l'en-tête batch + le code PowerShell, calcule l'empreinte SHA-256 du code
  et l'inscrit dans l'en-tête (contrôle d'intégrité au lancement) ;
- écrit JARVIS.cmd en UTF-8 sans BOM, fins de ligne CRLF.
Ne jamais modifier JARVIS.cmd à la main : l'empreinte ne correspondrait plus.
"""
import hashlib, os, re
ROOT = os.path.dirname(os.path.abspath(__file__))
SRC = os.path.join(ROOT, 'src', 'jarvis-checkup.ps1')
OUT = os.path.join(ROOT, 'JARVIS.cmd')
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
assert '—' not in s
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
full = head + body
# verify like PowerShell will
e = full.index('\n#>'); b = full[e+3:]
assert hashlib.sha256(b.encode('utf-8')).hexdigest() == h
open(OUT,'w',encoding='utf-8',newline='').write(full)
v = re.search(r"\$JarvisVersion = '([^']+)'", s)
print('JARVIS.cmd fabriqué : v%s, %d octets, SHA-256 %s...' % (v.group(1) if v else '?', len(full.encode()), h[:12]))
