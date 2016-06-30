# -*- coding: utf-8 -*-
import re, sys, os
import yaml
from mako.template import Template

def ctor(loader, node):
    return node.value
yaml.add_constructor('!include', ctor)

#Execute(Delete(Glob("gh-pages/Mon/*")))

source_map = {
    'SamuraiHeraldry': 'Turnbull, Stephen. <i>Samurai Heraldry</i>. Osprey Publishing, 2002.',
    'IllEnc': '<i>An Illustrated Encyclopedia of Japanese Family Crests</i>. Graphic-sha, 2001.',
    'DowerCrests': 'Dower, John.  <a href="http://www.amazon.com/Elements-Japanese-Design-Handbook-Symbolism/dp/0834802295"><em>The Elements Of Japanese Design: Handbook Of Family Crests, Heraldry &#038; Symbolism</em></a>.  Weatherhill, 1990.',
    'KamonNoJiten': u'Takasawa Hitoshi (高澤等). <i>Kamon no Jiten (家紋の事典; “Family Crest Encyclopedia”)</i>. Ed. Chikano Shigeru (千鹿野茂). Tōkyōdō Shuppan (東京堂出版), 2008.',
    'FCoJ': '<i>Family Crests of Japan</i>. Stone Bridge Press, 2007.',
    'KenmonShokamon': u'<i>Kenmon Shokamon (見聞諸家紋; “Various Observed Family Crests”)</i>. 1467–1470. <a href="http://dl.ndl.go.jp/info:ndljp/pid/2533035">http://dl.ndl.go.jp/info:ndljp/pid/2533035</a>.',
    'OUmajirushi': u'Xavid “Kihō” Pretzer. <i>O-umajirushi: A 17th-Century Compendium of Samurai Heraldry</i>. The Academy of the Four Directions. 2015.',
    'SamuraiSourcebook': 'Turnbull, Stephen. <i>The Samurai Sourcebook</i>. Cassell & Co, 2000.',
}
wiki_sources = {
    'Commons': ('Wikimedia Commons',
                'https://commons.wikimedia.org/wiki/File:'),
    'Wikipedia': ('Wikipedia', 'https://en.wikipedia.org/wiki/'),
    'JaWikipedia': ('Japanese Wikipedia', 'https://ja.wikipedia.org/wiki/'),
}

def sourcefmt(s):
    assert s.startswith('<<') and s.endswith('/>>'), s
    assert ' ' in s or '\n' in s, s
    s = s[2:-3]
    if 'http://' in s or 'https://' in s:
        title, url, sname = s.split(', ')
        return u'“<a href="%s">%s</a>”. <i>%s</i>.' % (
            url, title, sname)
    source,rest = s.split(None, 1)
    if source in wiki_sources:
        sname, prefix = wiki_sources[source]
        return u'“<a href="%s">%s</a>”. <i>%s</i>.' % (
            prefix + rest, rest, sname)
        
    numbit = ''
    parts = rest.split()
    if len(parts) == 2:
        page, num = parts
        numbit = ' fig. ' + num
    else:
        assert len(parts) == 1, parts
        page = parts[0].replace(',', ', ')
    if ',' in page or '-' in page:
        pp = 'pp'
    else:
        pp = 'pg'
    return source_map[source] + ' %s. %s%s.' % (pp, page, numbit)

def get_local_link(match):
    name = match.group(1)
    return '<a href="%s">%s</a>' % (name, name)

def get_name(f):
    return os.path.basename(str(f)).rsplit('.', 1)[0]

CITE_RE = re.compile(r'<<[^>]+>>')
def yaml_mako(suf):
    def yaml_mako_impl(target, source, env):
        makof, yamlf = source
        tmpl = Template(filename=str(makof))
        with open(str(yamlf)) as fil:
            d = yaml.load(fil)
        assert 'source' not in d, yamlf
        assert 'note' not in d, yamlf
        d['name'] = get_name(yamlf)
        sources = []
        if 'sources' in d:
            for s in d['sources'].split('; '):
                sources.append(sourcefmt('<<'+s+'/>>'))
        if 'date' in d and isinstance(d['date'], basestring) and '<' in d['date']:
            d['date'], source = d['date'].split('<', 1)
            sources.append(sourcefmt('<' + source))
        if 'notes' in d:
            for s in CITE_RE.findall(d['notes']):
                s = sourcefmt(s)
                if s not in sources:
                    sources.append(s)
            d['notes'] = CITE_RE.sub('', d['notes'])
            d['notes'] = re.sub(r'\[\[([^|\]]+)\|([^\]]+)\]\]',
                                r'<a href="\1">\2</a>',
                                d['notes'])
            d['notes'] = LOCAL_LINK_RE.sub(get_local_link, d['notes'])
            d['notes'] = re.sub(r'//([^/]+)//', r'<i>\1</i>', d['notes'])
        if 'imagesource' in d:
            s = sourcefmt(d['imagesource'])
            if s not in sources:
                sources.append(s + ' (for image)')
        for k in ('kanji', 'transliteration'):
            if k in d and '<' in d[k]:
                d[k], source = d[k].split('<', 1)
                s = sourcefmt('<' + source)
                if (s not in sources and s + ' (for image)' not in sources
                    and s + ' (for Japanese)' not in sources):
                    sources.append(s + ' (for Japanese)')
        d['sources'] = '<br />'.join(sources)
        d['categories'] = ', '.join('<a href="../#%s">%s</a>' % ((c,) * 2)
                                    for c in get_categories(d))
        d['suffix'] = suf
        rendered = tmpl.render(**d)
        assert '<<' not in rendered, d
        assert '[[' not in rendered, rendered.encode('utf-8')
        with open(str(target[0]), 'w') as fil:
            fil.write(rendered.encode('utf-8'))
    return yaml_mako_impl

LOCAL_LINK_RE = re.compile(r'\[\[Mon:([^\]|]+)\]\]')

STEM_RE = re.compile(r'^Src/(.+?)(?:\.image)?\.(svg|png)$')

all_yaml = []
for f in Glob('Src/*.svg') + Glob('Src/*.png'):
    m = STEM_RE.search(str(f))
    stem = m.group(1)
    suf = m.group(2)
    pngf = 'gh-pages/Mon/' + stem + '-200.png'
    bigpngf = 'gh-pages/Mon/' + stem + '-500.png'
    yamlf = 'Src/' + stem + '.yaml'
    all_yaml.append(yamlf)
    htmlf = 'gh-pages/Mon/' + stem + '.html'
    if suf == 'svg':
        c = Command(pngf, f, 'bin/svg_to_png $SOURCE $TARGET 200')
        Depends(c, 'bin/svg_to_png')
        c = Command(bigpngf, f, 'bin/svg_to_png $SOURCE $TARGET 500')
        Depends(c, 'bin/svg_to_png')
    else:
        Command(pngf, f, r'convert $SOURCE -resize 200x200\> $TARGET')
        Command(bigpngf, f, r'convert $SOURCE -resize 500x500\> $TARGET')
    Command('gh-pages/Mon/%s.%s' % (stem, suf), [f],
            Copy('$TARGET', '$SOURCE'))
    c = Command(htmlf, ['Src/html.mak', yamlf], yaml_mako(suf))
    Depends(c, 'SConstruct')

def get_categories(d):
    if 'categories' in d:
        for c in d['categories'].split(', '):
            yield c
        return
    assert 'tags' in d, d
    tags = d['tags']
    for t in tags.split(', '):
        if t.startswith('[[MP:'):
            yield re.sub(r'([a-z](?=[A-Z])|[A-Z](?=[A-Z][a-z]))',
                              r'\1 ', t[5:-2])    

def make_index(target, source, env):
    makof = source[0]
    yamlfs = source[1:]
    tmpl = Template(filename=str(makof))
    category_map = {}
    for yamlf in yamlfs:
        with open(str(yamlf)) as fil:
            d = yaml.load(fil)
        found = False
        for category in get_categories(d):
            if category not in category_map:
                category_map[category] = []
            if 'date' in d:
                date = d['date']
                if isinstance(date, basestring) and date != 'Modern':
                    date = int(CITE_RE.sub('', date))
            else:
                date = 'Modern'
            category_map[category].append((date, get_name(yamlf)))
            found = True
        assert found, (str(yamlf), d['tags'])
    for c in category_map:
        category_map[c].sort()
    rendered = tmpl.render(category_map=category_map)
    with open(str(target[0]), 'w') as ofil:
        ofil.write(rendered.encode('utf-8'))

Command('gh-pages/index.html', ['Src/index.mak'] + all_yaml, make_index)
