"""Publication d'une version de J.A.R.V.I.S. sur GitHub, depuis le commit contrôlé (v3.25, audit, constat T6).

Jusqu'à la v3.24, « gh release create » envoyait le JARVIS.cmd de la copie de travail : rien ne prouvait que c'était
celui que GitHub avait contrôlé. Ici, le fichier publié est celui du commit de origin/main, tel que git le garde, et
seulement si les deux contrôles GitHub de ce commit (controle et scan) ont réussi.

  python -X utf8 tools/publier.py v3.25 --notes chantiers/notes-v3.25.md            essai : tout sauf la publication
  python -X utf8 tools/publier.py v3.25 --notes chantiers/notes-v3.25.md --publier  publie (accord de Thomas requis)
  python -X utf8 tools/publier.py --verifier v3.24                                  fichier publié = fichier du commit ?

Contrôles avant publication : commit = origin/main ; contrôles GitHub réussis ; JARVIS.cmd du commit intact (empreinte de
l'en-tête), à la version demandée, plus récent que la dernière version publiée ; étiquette et version encore libres ;
notes en lignes de 85 caractères au plus. Après : fichier téléchargé = fichier envoyé, gh release verify et verify-asset.
Une version publiée est immuable : une erreur se corrige par une nouvelle version.
"""
import argparse, hashlib, json, os, re, shutil, subprocess, sys, tempfile

REPO = 'onjouequand/jarvis'
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
REQUIRED = ('controle', 'scan')
try:
    sys.stdout.reconfigure(encoding='utf-8')
except Exception:
    pass


def stop(message):
    print('[FAIL] ' + message)
    sys.exit('PUBLICATION REFUSÉE.')


def ok(message):
    print('[ OK ] ' + message)


def gh_path():
    p = shutil.which('gh')
    if not p:
        p = r'C:\Program Files\GitHub CLI\gh.exe'
    if not os.path.isfile(p):
        stop('gh introuvable (GitHub CLI)')
    return p


def run(cmd, binary=False, check=True):
    r = subprocess.run(cmd, cwd=ROOT, capture_output=True)
    if check and r.returncode != 0:
        stop('%s : code %d, %s' % (' '.join(cmd[:4]), r.returncode, r.stderr.decode('utf-8', 'replace').strip()[:300]))
    return r.stdout if binary else r.stdout.decode('utf-8', 'replace').strip()


def git(*args, **kw):
    return run(['git'] + list(args), **kw)


def gh(*args, **kw):
    return run([gh_path()] + list(args), **kw)


def file_facts(data):
    """Version et intégrité d'un JARVIS.cmd (même calcul que l'en-tête au lancement)."""
    e = data.find(b'\n#>')
    if e < 0:
        return None, 'fin de l\'en-tête introuvable'
    h = hashlib.sha256(data[e + 3:]).hexdigest()
    m = re.search(rb'rem JARVIS-SHA256=([0-9a-f]{64})', data[:e])
    if not m or m.group(1).decode() != h:
        return None, 'empreinte de l\'en-tête différente du contenu'
    v = re.search(rb"\$JarvisVersion = '([0-9.]+)'", data)
    if not v:
        return None, '$JarvisVersion introuvable'
    if not (1000 < len(data) < 5 * 1024 * 1024):
        return None, 'taille refusée par la mise à jour en ligne (%d octets)' % len(data)
    return v.group(1).decode(), None


def check_runs(sha, required):
    """Dernier passage de chaque contrôle GitHub demandé sur ce commit : tous terminés et réussis."""
    data = json.loads(gh('api', 'repos/%s/commits/%s/check-runs?per_page=100' % (REPO, sha)))
    last = {}
    for c in data.get('check_runs', []):
        n = c.get('name')
        if n not in last or (c.get('started_at') or '') > (last[n].get('started_at') or ''):
            last[n] = c
    missing = [n for n in required if n not in last]
    if missing:
        return 'contrôle(s) GitHub absent(s) sur %s : %s' % (sha[:10], ', '.join(missing))
    bad = ['%s (%s/%s)' % (n, last[n].get('status'), last[n].get('conclusion')) for n in required
           if last[n].get('status') != 'completed' or last[n].get('conclusion') != 'success']
    if bad:
        return 'contrôle(s) GitHub non réussi(s) sur %s : %s' % (sha[:10], ', '.join(bad))
    return None


def vkey(v):
    return tuple(int(x) for x in v.split('.'))


def verify_release(tag):
    """Fichier publié de la version tag = JARVIS.cmd du commit de son étiquette, contrôlé par GitHub."""
    git('fetch', '--quiet', '--tags', 'origin')
    sha = git('rev-parse', tag + '^{commit}')
    blob = git('cat-file', 'blob', sha + ':JARVIS.cmd', binary=True)
    tmp = tempfile.mkdtemp(prefix='jarvis-verif-')
    gh('release', 'download', tag, '-R', REPO, '-p', 'JARVIS.cmd', '-D', tmp)
    pub = open(os.path.join(tmp, 'JARVIS.cmd'), 'rb').read()
    print('Version %s, étiquette sur le commit %s' % (tag, sha))
    if pub != blob:
        stop('fichier publié (%d octets) différent du JARVIS.cmd du commit (%d octets)' % (len(pub), len(blob)))
    ok('fichier publié = JARVIS.cmd du commit (%d octets, SHA-256 %s)' % (len(pub), hashlib.sha256(pub).hexdigest()))
    v, err = file_facts(pub)
    if err:
        stop(err)
    if 'v' + v != tag:
        stop('version %s dans le fichier, étiquette %s' % (v, tag))
    ok('empreinte interne conforme, version %s' % v)
    err = check_runs(sha, ('controle',))
    if err:
        stop(err)
    ok('contrôle GitHub « controle » réussi sur ce commit')
    if check_runs(sha, ('scan',)):
        print('[INFO] pas de scan d\'essai GitHub sur ce commit (ajouté en v3.25)')
    else:
        ok('scan d\'essai GitHub réussi sur ce commit')
    gh('release', 'verify', tag, '-R', REPO)
    gh('release', 'verify-asset', tag, os.path.join(tmp, 'JARVIS.cmd'), '-R', REPO)
    ok('gh release verify et verify-asset : version immuable, fichier attesté par GitHub')
    print('VERSION PUBLIÉE CONFORME.')


def publish(tag, notes, really):
    if not re.fullmatch(r'v\d+\.\d+', tag):
        stop('étiquette attendue sous la forme v3.25')
    if not notes or not os.path.isfile(notes):
        stop('fichier de notes introuvable : %s' % notes)
    lines = open(notes, encoding='utf-8').read().splitlines()
    long_lines = [i + 1 for i, l in enumerate(lines) if len(l) > 85]
    if long_lines:
        stop('notes : ligne(s) de plus de 85 caractères : %s' % long_lines[:10])
    if any(c in open(notes, encoding='utf-8').read() for c in '\u2014\u2013'):
        stop('notes : tiret cadratin ou demi-cadratin')
    ok('notes : %d lignes de 85 caractères au plus' % len(lines))

    git('fetch', '--quiet', '--tags', 'origin')
    sha = git('rev-parse', 'origin/main')
    print('Commit publié : origin/main = %s' % sha)
    if git('ls-remote', '--tags', 'origin', 'refs/tags/' + tag):
        stop('l\'étiquette %s existe déjà sur GitHub' % tag)
    if gh('release', 'view', tag, '-R', REPO, check=False):
        stop('la version %s existe déjà sur GitHub' % tag)
    ok('étiquette et version %s libres' % tag)

    err = check_runs(sha, REQUIRED)
    if err:
        stop(err)
    ok('contrôles GitHub réussis sur ce commit : %s' % ', '.join(REQUIRED))

    blob = git('cat-file', 'blob', sha + ':JARVIS.cmd', binary=True)
    v, err = file_facts(blob)
    if err:
        stop('JARVIS.cmd du commit : ' + err)
    if 'v' + v != tag:
        stop('JARVIS.cmd du commit est en version %s, pas %s' % (v, tag[1:]))
    latest = json.loads(gh('release', 'view', '-R', REPO, '--json', 'tagName'))['tagName']
    if vkey(v) <= vkey(latest[1:]):
        stop('version %s pas plus récente que la dernière publiée (%s)' % (v, latest))
    digest = hashlib.sha256(blob).hexdigest()
    ok('JARVIS.cmd du commit : version %s (dernière publiée %s), empreinte interne conforme, %d octets, SHA-256 %s'
       % (v, latest, len(blob), digest))
    local = os.path.join(ROOT, 'JARVIS.cmd')
    if os.path.isfile(local) and open(local, 'rb').read() != blob:
        print('[INFO] le JARVIS.cmd de la copie de travail diffère : c\'est celui du commit qui sera publié')

    tmp = tempfile.mkdtemp(prefix='jarvis-publier-')
    asset = os.path.join(tmp, 'JARVIS.cmd')
    open(asset, 'wb').write(blob)
    cmd = ['release', 'create', tag, asset, '-R', REPO, '--target', sha, '--title', 'J.A.R.V.I.S. ' + tag,
           '--notes-file', notes]
    if not really:
        print('ESSAI RÉUSSI : rien n\'est publié. Avec --publier, la commande serait :')
        print('  gh ' + ' '.join('"%s"' % a if ' ' in a else a for a in cmd))
        return
    # Dernière vérification juste avant d'envoyer : main n'a pas bougé pendant les contrôles
    git('fetch', '--quiet', 'origin', 'main')
    if git('rev-parse', 'origin/main') != sha:
        stop('origin/main a changé pendant les contrôles : relance')
    gh(*cmd)
    ok('version %s créée sur GitHub' % tag)
    back = tempfile.mkdtemp(prefix='jarvis-relu-')
    gh('release', 'download', tag, '-R', REPO, '-p', 'JARVIS.cmd', '-D', back)
    if open(os.path.join(back, 'JARVIS.cmd'), 'rb').read() != blob:
        stop('fichier relu sur GitHub différent du fichier envoyé : version immuable, à corriger par une nouvelle version')
    ok('fichier relu sur GitHub = fichier du commit')
    gh('release', 'verify', tag, '-R', REPO)
    gh('release', 'verify-asset', tag, asset, '-R', REPO)
    ok('gh release verify et verify-asset réussis')
    print('PUBLIÉE : https://github.com/%s/releases/tag/%s' % (REPO, tag))


a = argparse.ArgumentParser(description='Publie ou vérifie une version de J.A.R.V.I.S. sur GitHub.')
a.add_argument('tag', nargs='?', help='version à publier, par exemple v3.25')
a.add_argument('--notes', help='fichier des notes de version')
a.add_argument('--publier', action='store_true', help='publier pour de bon (sinon : essai)')
a.add_argument('--verifier', metavar='TAG', help='vérifier une version déjà publiée')
o = a.parse_args()
if o.verifier:
    verify_release(o.verifier)
elif o.tag:
    publish(o.tag, o.notes, o.publier)
else:
    a.print_help()
