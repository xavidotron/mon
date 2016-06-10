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
}
wiki_sources = {
    'Commons': ('Wikimedia Commons',
                'https://commons.wikimedia.org/wiki/File:'),
    'Wikipedia': ('Wikipedia', 'https://en.wikipedia.org/wiki/'),
    'JaWikipedia': ('Japanese Wikipedia', 'https://ja.wikipedia.org/wiki/'),
}

def sourcefmt(s):
    assert s.startswith('<<') and s.endswith('/>>'), s
    source,rest = s[2:-3].split(None, 1)
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
        page = parts[0]
    if ',' in page or '-' in page:
        pp = 'pp'
    else:
        pp = 'pg'
    return source_map[source] + ' %s. %s%s.' % (pp, page, numbit)

def get_local_link(match):
    with open('Src/%s.yaml' % match.group(1)) as fil:
        d = yaml.load(fil)
    name = d['name'] if 'name' in d else d['translation']
    return '<a href="%s.html">%s</a>' % (name, name)

def yaml_mako(target, source, env):
    makof, yamlf = source
    tmpl = Template(filename=str(makof))
    with open(str(yamlf)) as fil:
        d = yaml.load(fil)
    if 'name' not in d:
        d['name'] = d['translation']
    sources = []
    if 'date' in d and isinstance(d['date'], basestring) and '<' in d['date']:
        d['date'], source = d['date'].split('<', 1)
        sources.append(sourcefmt('<' + source))
    if 'notes' in d:
        for s in re.findall(r'<<[^>]+>>', d['notes']):
            s = sourcefmt(s)
            if s not in sources:
                sources.append(s)
        d['notes'] = re.sub(r'<<[^>]+>>', '', d['notes'])
        d['notes'] = re.sub(r'\[\[([^|\]]+)\|([^\]]+)\]\]',
                            r'<a href="\1">\2</a>',
                            d['notes'])
        d['notes'] = LOCAL_LINK_RE.sub(get_local_link, d['notes'])
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
                                for c in tags_to_categories(d['tags']))
    rendered = tmpl.render(**d)
    assert '<<' not in rendered, d
    assert '[[' not in rendered, rendered.encode('utf-8')
    with open(str(target[0]), 'w') as fil:
        fil.write(rendered.encode('utf-8'))

def install_to_out(target, source, env):
    with open(str(source[0])) as fil:
        d = yaml.load(fil)
        name = d['name'] if 'name' in d else d['translation']
    assert str(source[0]).endswith('.yaml')
    prefix = str(source[0])[:-len('.yaml')]
    for f in source[1:]:
        assert str(f).startswith(prefix) or str(f).startswith(prefix.replace('Src/', 'Out/')), (str(f), prefix)
        suffix = str(f)[len(prefix):]
        if suffix.startswith('.image'):
            suffix = suffix[len('.image'):]
        dest_path = 'gh-pages/Mon/' + name + suffix
        Execute(Copy(dest_path, f))

LOCAL_LINK_RE = re.compile(r'\[\[(Mon:[^ \]|]+)\]\]')

def yaml_scan(node, env, path):
    contents = node.get_text_contents()
    refs = LOCAL_LINK_RE.findall(contents)
    return env.File(['Src/' + r + '.yaml' for r in refs])

yaml_scanner = Scanner(function = yaml_scan,
                       skeys = ['.yaml'])
env = Environment()
env.Append(SCANNERS = yaml_scanner)

STEM_RE = re.compile(r'^Src/(.+?)(?:\.image)?\.svg$')

all_yaml = []
for f in Glob('Src/*.svg'):
    stem = STEM_RE.search(str(f)).group(1)
    pngf = 'Out/' + stem + '-200.png'
    bigpngf = 'Out/' + stem + '-500.png'
    yamlf = 'Src/' + stem + '.yaml'
    all_yaml.append(yamlf)
    htmlf = 'Out/' + stem + '.html'
    c = Command(pngf, f, 'bin/svg_to_png $SOURCE $TARGET 200')
    Depends(c, 'bin/svg_to_png')
    c = Command(bigpngf, f, 'bin/svg_to_png $SOURCE $TARGET 500')
    Depends(c, 'bin/svg_to_png')
    c = env.Command(htmlf, ['Src/html.mak', yamlf], yaml_mako)
    Depends(c, 'SConstruct')

    Command(yamlf + ' (install)', [yamlf, pngf, bigpngf, f, htmlf],
            install_to_out)

def tags_to_categories(tags):
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
        assert 'tags' in d, str(yamlf)
        for category in tags_to_categories(d['tags']):
            if category not in category_map:
                category_map[category] = []
            category_map[category].append(
                d['name'] if 'name' in d else d['translation'])
            found = True
        assert found, (str(yamlf), d['tags'])
    for c in category_map:
        category_map[c].sort()
    rendered = tmpl.render(category_map=category_map)
    with open(str(target[0]), 'w') as ofil:
        ofil.write(rendered.encode('utf-8'))

Command('gh-pages/index.html', ['Src/index.mak'] + all_yaml, make_index)
