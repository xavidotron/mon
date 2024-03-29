# -*- coding: utf-8 -*-
import re, sys, os
import yaml
from mako.template import Template
from mako.lookup import TemplateLookup

def ctor(loader, node):
    return node.value
yaml.add_constructor('!include', ctor)

#Execute(Delete(Glob("docs/Mon/*")))

pageless_map = {
  'EricObershaw': 'Obershaw, Eric. Photographs. <a href="http://www.jcastle.info/">http://www.jcastle.info/</a>',
}
source_map = {
    'SamuraiHeraldry': 'Turnbull, Stephen. <i>Samurai Heraldry</i>. Osprey Publishing, 2002.',
    'IllEnc': '<i>An Illustrated Encyclopedia of Japanese Family Crests</i>. Graphic-sha, 2001.',
    'DowerCrests': 'Dower, John.  <a href="http://www.amazon.com/Elements-Japanese-Design-Handbook-Symbolism/dp/0834802295"><em>The Elements Of Japanese Design: Handbook Of Family Crests, Heraldry &#038; Symbolism</em></a>.  Weatherhill, 1990.',
    'KamonNoJiten': u'Takasawa Hitoshi (高澤等). <i>Kamon no Jiten (家紋の事典; “Family Crest Encyclopedia”)</i>. Ed. Chikano Shigeru (千鹿野茂). Tōkyōdō Shuppan (東京堂出版), 2008.',
    'FCoJ': '<i>Family Crests of Japan</i>. Stone Bridge Press, 2007.',
    'KenmonShokamon': u'<i>Kenmon Shokamon (見聞諸家紋; “Various Observed Family Crests”)</i>. 1467–1470. <a href="http://dl.ndl.go.jp/info:ndljp/pid/2533035">http://dl.ndl.go.jp/info:ndljp/pid/2533035</a>.',
    'Ohatamoto': u'<i>Ohatamoto sōshirushizu</i> (御簱本惣印図; “Shogunal Vassals All Emblem Drawings”). Library of Congress. 1634. <a href="http://fireflies.xavid.us/wp-content/uploads/2015/11/Ohatamoto-S\%C5\%8Dshirushizu.pdf">http://fireflies.xavid.us/wp-content/uploads/2015/11/Ohatamoto-S\%C5\%8Dshirushizu.pdf</a>',
    'OUmajirushi': u'Xavid “Kihō” Pretzer. <i>O-umajirushi: A 17th-Century Compendium of Samurai Heraldry</i>. The Academy of the Four Directions. 2015.',
    'SamuraiSourcebook': 'Turnbull, Stephen. <i>The Samurai Sourcebook</i>. Cassell & Co, 2000.',
    'Tadoru2': u'<i>Shoku Kamon de Tadoru Anata no Kakei (続家紋でたどるあなたの家系; “Your Family Lineage Followed with Family Crests, Continued”)</i>. Yagishoten (八木書店), 1998.', # https://books.google.com/books?id=F1VdUz1RUosC&dq=%22%E7%A5%9E%E5%AE%B6%22+%E7%89%A9%E9%83%A8&source=gbs_navlinks_s
    'NNK2': u'Tsujiai Kiyotarō (辻合喜代太郎). <i>Shoku Nihon no Kamon (続日本の家紋; “Family Crests of Japan, Continued”)</i>. Hoikusha (保育社), 1975.', # https://books.google.com/books?id=64Tw_yLYlXwC&pg=PA97&lpg=PA97&dq=%E5%B1%B1%E5%BD%A2%E6%9D%91%E7%B4%BA&source=bl&ots=LdkniCZ-ou&sig=AWwyJAbxPD0QjJqIP1isP4m6StY&hl=en&sa=X&ved=0ahUKEwi4iePdztzNAhWLND4KHeG8DzkQ6AEIHDAA#v=onepage&q=%E5%B1%B1%E5%BD%A2%E6%9D%91%E7%B4%BA&f=false
}
wiki_sources = {
    'Commons': ('Wikimedia Commons',
                'https://commons.wikimedia.org/wiki/File:'),
    'Wikipedia': ('Wikipedia', 'https://en.wikipedia.org/wiki/'),
    'JaWikipedia': ('Japanese Wikipedia', 'https://ja.wikipedia.org/wiki/'),
    'Pixta': (u'Pixta', 'https://pixta.jp/illustration/')
}
scanned_sources = {
    'Daibukan': (
        u'Daibukan (大武鑑; “Great Book of Heraldry”)',
        'http://dl.ndl.go.jp/info:ndljp/pid/1015270/%d?tocOpened=1&__lang=en',
        u'Volume 1. Daikōsha (大洽社), 1937'),
    'AshikagaBukan': (
        u'Ashikagake Bukan (足利家武鑑; “House Ashikaga Book of Heraldry”)',
        'http://archive.wul.waseda.ac.jp/kosho/bunko20/bunko20_00368/bunko20_00368_0007/bunko20_00368_0007_p%04d.jpg',
        u'Kinkadō (金花堂), 1822'),
}

def sourcefmt(s):
    assert s.startswith('<<') and s.endswith('/>>'), s.encode('utf-8')
    s = s[2:-3]
    if ' ' not in s and '\n' not in s:
        return pageless_map[s]
    if 'http://' in s or 'https://' in s:
        title, url, sname = s.rsplit(', ', 2)
        return u'“<a href="%s">%s</a>”. <i>%s</i>.' % (
            url, title, sname.strip())
    source,rest = s.split(None, 1)
    if source in scanned_sources:
        pg = int(rest)
        title, url, endbit = scanned_sources[source]
        return u'<i><a href="%s">%s</a></i>, %s. p. %d.' % (
            url % (pg), title, endbit, pg)
    elif source in wiki_sources:
        sname, prefix = wiki_sources[source]
        return u'“<a href="%s">%s</a>”. <i>%s</i>.' % (
            prefix + rest, rest, sname)
        
    numbit = ''
    parts = rest.split()
    if len(parts) == 2:
        page, num = parts
        assert not page.endswith(','), parts
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

font_dict = {'!': 'kenmonji'}

CITE_RE = re.compile(r'<<[^>]+>>')
FONT_RE = re.compile(r'([^a-zA-Z])([!])')

def font_sub(s):
    return FONT_RE.sub(lambda m: '<span class="%s">%s</span>' %
                       (font_dict[m.group(2)], m.group(1)),
                       s)

def yaml_mako(images):
    def yaml_mako_impl(target, source, env):
        makof, yamlf = source
        tmpl = Template(filename=str(makof))
        with open(str(yamlf)) as fil:
            d = yaml.load(fil)
        for k in d:
            assert k in ('sources', 'notes', 'date', 'tags', 'owner',
                         'kanji', 'modern kanji',
                         'transliteration', 'name', 'blazon',
                         'image', 'translation', 'imagesource', 'categories'), (
                str(yamlf), k)
        d['name'] = get_name(yamlf)
        sources = []
        if 'sources' in d:
            for s in d['sources'].split('; '):
                sources.append(sourcefmt('<<'+s+'/>>'))
        if 'date' in d and isinstance(d['date'], str) and '<' in d['date']:
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
            d['notes'] = font_sub(d['notes'])
        if 'imagesource' in d:
            s = sourcefmt(d['imagesource'])
            if s not in sources:
                sources.append(s + ' (for image)')
        for k in ('kanji', 'transliteration'):
            if k in d and '<<' in d[k]:
                d[k], source = d[k].split('<<', 1)
                s = sourcefmt('<<' + source)
                if (s not in sources and s + ' (for image)' not in sources
                    and s + ' (for Japanese)' not in sources):
                    sources.append(s + ' (for Japanese)')
        for k in ('kanji',):
            if k in d:
                modern = FONT_RE.sub(r'\1', d[k])
                if modern != d[k]:
                    d['modern ' + k] = modern
                d[k] = font_sub(d[k])
        for k in ('owner',):
            if k in d:
                if isinstance(d[k], list):
                    for i in range(len(d[k])):
                        o = d[k][i]
                        assert o[-1] == ')'
                        roomaji, kanji = o[:-1].split(' (')
                        modern = FONT_RE.sub(r'\1', kanji)
                        if modern != kanji:
                            d[k][i] = '%s (%s; %s)' % (
                                roomaji, font_sub(kanji), modern)
                    d[k] = ', '.join(d[k])
        d['sources'] = '<br />'.join(sources)
        d['categories'] = ', '.join('<a href="../#%s">%s</a>' % ((c,) * 2)
                                    for c in get_categories(d))
        d['images'] = images
        rendered = tmpl.render(**d)
        assert '<<' not in rendered, d
        assert '[[' not in rendered, rendered.encode('utf-8')
        with open(str(target[0]), 'w') as fil:
            fil.write(rendered)
    return yaml_mako_impl

LOCAL_LINK_RE = re.compile(r'\[\[Mon:([^\]|]+)\]\]')

STEM_RE = re.compile(r'^Src/(.+?)(?:\.image)?\.(svg|png|jpg)$')

all_yaml = []
thumbsuf_map = {}
image_map = {}
image_200s = []
image_500s = []
for f in Glob('Src/*.svg') + Glob('Src/*.png') + Glob('Src/*.jpg'):
    m = STEM_RE.search(str(f))
    stem = m.group(1)
    suf = m.group(2)
    thumbsuf = suf if suf != 'svg' else 'png'
    pngf = 'docs/Mon/' + stem + '-200.' + thumbsuf
    image_200s.append(pngf)
    bigpngf = 'docs/Mon/' + stem + '-500.' + thumbsuf
    image_500s.append(bigpngf)
    if suf == 'svg':
        c = Command(pngf, f, 'bin/svg_to_png $SOURCE $TARGET 200')
        Depends(c, 'bin/svg_to_png')
        c = Command(bigpngf, f, 'bin/svg_to_png $SOURCE $TARGET 500')
        Depends(c, 'bin/svg_to_png')
    else:
        Command(pngf, f, r'convert $SOURCE -resize 200x200\> $TARGET')
        Command(bigpngf, f, r'convert $SOURCE -resize 500x500\> $TARGET')
    Command('docs/Mon/%s.%s' % (stem, suf), [f],
            Copy('$TARGET', '$SOURCE'))
    if stem[-1].isdigit():
        yamlf = 'Src/' + stem[:-1] + '.yaml'
        image_map[yamlf].append((stem, suf, thumbsuf))
    else:
        yamlf = 'Src/' + stem + '.yaml'
        all_yaml.append(yamlf)
        thumbsuf_map[yamlf] = thumbsuf
        assert yamlf not in image_map
        image_map[yamlf] = [(stem, suf, thumbsuf)]

for yamlf in all_yaml:
    images = image_map[yamlf]
    stem = yamlf[len('Src/'):-len('.yaml')]
    htmlf = 'docs/Mon/' + stem + '.html'
    c = Command(htmlf, ['Src/html.mak', yamlf], yaml_mako(images))
    Depends(c, 'SConstruct')

def deyaml_category(c):
    if isinstance(c, dict):
        assert len(c) == 1
        for k in c:
            return '%s: %s' % (k, c[k])
    else:
        return c.strip()

def get_categories(d):
    if 'categories' in d:
        cl = d['categories']
        if not isinstance(cl, list):
            cl = cl.split(', ')
        for c in cl:
            yield deyaml_category(c)
        return
    #assert 'tags' in d, d
    if 'tags' not in d:
        yield 'Uncategorized'
        return
    tags = d['tags']
    for t in tags.split(', '):
        if t.startswith('[[MP:'):
            yield re.sub(r'([a-z:](?=[A-Z])|[A-Z](?=[A-Z][a-z]))',
                              r'\1 ', t[5:-2])    

def make_index(yamlfs, categoryfs):
    def make_index_impl(target, source, env):
        makof = source[0]
        tmpl = Template(filename=str(makof),
                        lookup=TemplateLookup(directories=[
                    os.path.dirname(os.path.dirname(os.path.abspath(str(makof))))]))
        all_mon = []
        category_map = {}
        for yamlf in yamlfs:
            with open(str(yamlf)) as fil:
                d = yaml.load(fil)
            found = False
            categories = list(get_categories(d))
            if 'date' in d:
                date = d['date']
                if isinstance(date, str) and date != 'Modern':
                    date = CITE_RE.sub('', date)
                else:
                    date = str(date)
            else:
                date = 'Modern'
            mon = dict(
                year=date,
                name=get_name(yamlf),
                thumbsuf=thumbsuf_map[str(yamlf)],
                count=len(image_map[str(yamlf)]))
            for k in ('notes', 'owner', 'kanji', 'modern kanji', 'translation',
                      'transliteration', 'sources'):
                if k in d:
                    mon[k] = d[k]
            if 'owner' in mon and isinstance(mon['owner'], list):
                mon['owner'] = ', '.join(mon['owner'])
            mon['categories'] = categories
            for category in categories:
                if category not in category_map:
                    category_map[category] = []
                category_map[category].append(mon)
                found = True
            assert found, (str(yamlf), d['tags'])
            all_mon.append(mon)
        for c in category_map:
            category_map[c].sort(key=lambda m:m['year'])
        seealso_map = {}
        notes_map = {}
        for catf in categoryfs:
            with open(str(catf)) as fil:
                d = yaml.load(fil)
            cat = str(catf).split('/', 1)[1].split('.', 1)[0]
            if 'seealso' in d:
                seealso_map[cat] = [deyaml_category(c) for c in d['seealso']]
            if 'notes' in d:
                notes_map[cat] = d['notes']
        rendered = tmpl.render(category_map=category_map,
                               seealso_map=seealso_map,
                               notes_map=notes_map,
                               all_mon=all_mon)
        with open(str(target[0]), 'w') as ofil:
            ofil.write(rendered)
    return make_index_impl

Command('docs/index.html',
        ['Templates/index.mak'] + all_yaml + Glob('Categories/*.yaml'),
        make_index(all_yaml, Glob('Categories/*.yaml')))

Command('MonDatabase.tex',
        ['Templates/MonDatabase.tex.mak']
        + all_yaml + Glob('Categories/*.yaml'),
        make_index(all_yaml, Glob('Categories/*.yaml')))

# MonHandout
Command('docs/Introduction to Japanese Crests.pdf',
        'MonHandout.pdf',
        Copy('$TARGET', '$SOURCE'))
c = Command('MonHandout.pdf',
            'MonHandout.tex',
            'latexmk -xelatex $SOURCE')
Depends(c, image_500s)

c = Command('MonDatabase.pdf',
            'MonDatabase.tex',
            'latexmk -xelatex $SOURCE')
Depends(c, image_200s)

Command("docs/Zen Meals under Dougen's Pure Standards.pdf",
        'Ouryouki.pdf',
        Copy('$TARGET', '$SOURCE'))
Command('Ouryouki.pdf',
        'Ouryouki.tex',
        'latexmk -xelatex $SOURCE')
