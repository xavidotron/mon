## -*- coding: utf-8 -*-
\documentclass{article}

<%inherit file="base.mak"/>

<%
import re, unicodedata

def unisub(m):
  c = eval("u'\\U%08x'" % int(m.group(1), 16))
  if m.group(1).lower().startswith('2'):
    return r'{\hanabf %s}' % c
  else:
    return r'{\japanesef %s}' % c

def sourcesub(m):
  s = m.group(1)
  if ' ' not in s and '\n' not in s:
    return r'\s%s{}' % s
  if 'http://' in s or 'https://' in s:
    title, url, sname = s.rsplit(', ', 2)
    return r'\s%s{:%s}' % (re.sub(r'\(.+\)', '', sname.replace(' ', '').replace('-', '')),
                          re.sub(r'(: .+)', '', re.sub(r' \(.+\)', '', title)))
  source,rest = s.split(None, 1)
  if not rest[0].isdigit():
    rest = ':' + rest
  if ',_' in rest:
    rest = rest.split(',_', 1)[0]
  return r'\s%s{%s}' % (source, rest.replace(' ', '.').replace(',', ', '))

def monsub(m):
  return '%s (\#%s)' % (m.group(1), rev_map[m.group(1)] + 1)

def html_sub(t):
  t = re.sub(r'<a href="#[^"]+">([^<]+)</a>', '\\1', t)
  t = re.sub(r'<<([^>]+)/>>', sourcesub, t)
  t = re.sub(r'_', r'\\textunderscore ', t)
  t = re.sub(r'<i>([^<]+)</i>', r'\\emph{\1}', t)
  t = re.sub(r'//([^/]+)//', r'\\emph{\1}', t)
  t = re.sub(r'\[\[([^\]|]+)\|(Fireflies Sing)\]\]', r'\2', t)
  t = re.sub(r'\[\[([^\]|]+)\|([^\]]+)\]\]', r'\2\\footnote{\\url{\1}}', t)
  t = re.sub(r'\[\[Mon:([^\]]+)\]\]', monsub, t)
  t = re.sub(r'\[\[Mon:([^\]]+)\]\]', monsub, t)
  t = re.sub(r'([ (])"', r'\1``', t)
  t = ''.join(r'{\japanesef %s}' % c if unicodedata.category(c) == 'Lo' else c
              for c in t)
  t = re.sub(r'\{\\japanesef ([^a-zA-Z])\}([!])', r'{\\kenmonji \1}', t)
  t = re.sub(r'&#x([a-zA-Z0-9]+);', unisub, t)
  assert '<' not in t, t
  assert '[[' not in t, t
  return t
%>

\def\geom{inner=.75in,outer=.5in,vmargin=.5in,twoside,foot=.25in}
\usepackage{setup}
\usepackage{booktabs}

\newfontfamily\japanesef[Scale=.75]{HanaMinA}
\newfontfamily\hanabf[Scale=.75]{HanaMinB}
\newfontfamily\kenmonji[Path=Fonts/,Scale=.75]{KenmonjiI}

\newsource{\sAshikagaBukan}{AB}{\emph{Ashikagake Bukan} (足利家武鑑; “House Ashikaga Book of Heraldry”). u'Kinkadō (金花堂), 1822. \url{http://archive.wul.waseda.ac.jp/kosho/bunko20/bunko20_00368/bunko20_00368_0007/}}
\newsource{\sDaibukan}{Db}{\emph{Daibukan} (大武鑑; “Great Book of Heraldry”). Volume 1. Daikōsha (大洽社), 1937. \url{http://dl.ndl.go.jp/info:ndljp/pid/1015270/1?tocOpened=1&__lang=en}}
\newsource{\sDowerCrests}{EJD}{Dower, John.  \emph{The Elements Of Japanese Design: Handbook Of Family Crests, Heraldry \& Symbolism}.  Weatherhill, 1990.}
\newsource{\seMuseum}{eM}{e-Museum: National Treasures \& Important Cultural Properties of National Museums, Japan. \url{http://www.emuseum.jp/}}
\newsource{\sEricObershaw}{EO}{Obershaw, Eric. Photographs. \url{http://www.jcastle.info/}}
\newsource{\sFCoJ}{FCoJ}{\emph{Family Crests of Japan}. Stone Bridge Press, 2007.}
\newsource{\sIllEnc}{IE}{\emph{An Illustrated Encyclopedia of Japanese Family Crests}. Graphic-sha, 2001.}
\newsource{\sJaWikipedia}{JaW}{Japanese Wikipedia. \url{https://ja.wikipedia.org/}}
\newsource{\sKamonDB}{KDB}{Kamon DB. \url{http://kamon-db.net/}}
\newsource{\sKobeCityMuseumviaGoogleCulturalInstitute}{KCM}{Kobe City Museum via Google Cultural Institute. \url{https://www.google.com/culturalinstitute/beta/partner/kobe-city-museum}}
\newsource{\sKamonNoJiten}{KnJ}{Takasawa Hitoshi (高澤等). \emph{Kamon no Jiten} (家紋の事典; “Family Crest Encyclopedia”). Ed. Chikano Shigeru (千鹿野茂). Tōkyōdō Shuppan (東京堂出版), 200}
\newsource{\sKenmonShokamon}{KS}{\emph{Kenmon Shokamon (見聞諸家紋; “Various Observed Family Crests”)}. 1467–1470. \url{http://dl.ndl.go.jp/info:ndljp/pid/2533035}.}
\newsource{\sLosAngelesCountyMuseumofArt}{LACMA}{Los Angeles County Museum of Art. \url{http://www.lacma.org/}}
\newsource{\sNNK2}{NnK2}{Tsujiai Kiyotarō (辻合喜代太郎). \emph{Shoku Nihon no Kamon (続日本の家紋; “Family Crests of Japan, Continued”)}. Hoikusha (保育社), 1975.}
\newsource{\sOhatamoto}{OS}{\emph{Ohatamoto s\=oshirushizu} (御簱本惣印図; “Shogunal Vassals All Emblem Drawings”). Library of Congress. 1634. \url{http://fireflies.xavid.us/wp-content/uploads/2015/11/Ohatamoto-S\%C5\%8Dshirushizu.pdf}}
\newsource{\sOUmajirushi}{OU}{Xavid “Kihō” Pretzer. \emph{O-umajirushi: A 17th-Century Compendium of Samurai Heraldry}. The Academy of the Four Directions. 2015.}
\newsource{\sPixta}{Px}{Pixta. \url{https://pixta.jp/}}
\newsource{\sRijksmuseum}{Rj}{Rijksmuseum. \url{https://www.rijksmuseum.nl/}}
\newsource{\sSamuraiHeraldry}{SH}{Turnbull, Stephen. \emph{Samurai Heraldry}. Osprey Publishing, 2002.}
\newsource{\sSamuraiSourcebook}{SS}{Turnbull, Stephen. \emph{The Samurai Sourcebook}. Cassell \& Co, 2000.}
\newsource{\sTadoru2}{T2}{\emph{Shoku Kamon de Tadoru Anata no Kakei} (続家紋でたどるあなたの家系; “Your Family Lineage Followed with Family Crests, Continued”). Yagishoten (八木書店), 1998.}
\newsource{\sCommons}{WC}{Wikimedia Commons. \url{https://commons.wikimedia.org/}}
\newsource{\sWikipedia}{Wp}{Wikipedia. \url{https://en.wikipedia.org/}}

\begin{document}

\chapter{Kihō's Japanese Heraldry Database (\url{http://mon.xavid.us/})}

\small
\raggedright
\raggedcolumns
\renewcommand{\baselinestretch}{.8}

<%
cats = sorted(category_map, key=self.get_key)
for c in category_map:
  category_map[c].sort(key=lambda m: m['year'])
all_mon.sort(key=lambda m:m['name'])
rev_map = {}
for i in range(len(all_mon)):
  rev_map[all_mon[i]['name']] = i
%>

\begin{multicols*}{3}

%for ci in range(len(cats)):
  <% c = cats[ci] %>
  \small
  
  \paragraph{${c}}~\\*[1ex]
  %if c in notes_map:
    ${html_sub(notes_map[c])}\\*[1ex]
  %endif
  
  %if c in seealso_map:
    See also: ${', '.join(sac for sac in seealso_map[c])}\\*[1ex]
  %endif
  
  {\tiny ~\\*}
  
  \begin{tabular}{T{30pt}T{30pt}T{30pt}T{30pt}T{30pt}}
  %for moni in range(len(category_map[c])):
    <% mon = category_map[c][moni] %>
    \begin{minipage}[c][30pt]{30pt}\centering
    \includegraphics[width=30pt,height=30pt,keepaspectratio]{docs/Mon/${mon['name']}-200.${mon['thumbsuf']}}
    \end{minipage}
    \footnotesize \#${rev_map[mon['name']] + 1} (${re.sub(r'<<([^>]+)/>>', '', str(mon['year'])).replace(' ', '~')})
    %if moni % 5 == 4:
      \\ 
      %if moni != len(category_map[c]) - 1:
        \addlinespace[1pt]
      %endif
    %else:
      &
    %endif
  %endfor
  \end{tabular}
%endfor
\end{multicols*}

\clearpage
\ifthenelse{\isodd{\arabic{page}}}{~\clearpage}{}

\setlist{itemsep=.5ex}
\small

<%
j = 0
imgs = []
%>

\begin{multicols*}{3}
\begin{itemize}
%for moni in range(len(all_mon)):
    <% mon = all_mon[moni] %>
    \par\small
    \item[${moni + 1}.] ${mon['name']} %
      %if 'kanji' in mon:
        (${html_sub(mon['kanji'])};
        %if 'modern kanji' in mon:
          ${html_sub(mon['modern kanji'])};
        %elif '!' in mon['kanji']:
          ${html_sub(mon['kanji'].replace('!', ''))};
        %endif
        ${html_sub(mon['transliteration'])}; ${html_sub(mon['translation'].strip())})
      %endif
      (${mon['year']})%
    %if 'sources' in mon:
      ${html_sub('<<%s/>>' % mon['sources'])}
    %endif
      \\ \footnotesize Categories: ${', '.join(mon['categories'])}
    %if 'owner' in mon:
      \\ Used by: ${html_sub(mon['owner'])}
    %endif
    %if 'notes' in mon:
      \par \footnotesize ${html_sub(mon['notes'])}
    %endif
    <%
    imgs.append('docs/Mon/%s-200.%s' % (mon['name'], mon['thumbsuf']))
    %>
    %if moni % 30 == 29 or moni == len(all_mon) - 1:
      \end{itemize}
      \end{multicols*}
      \clearpage
      \begin{center}
      \begin{tabular}{w{100pt}w{100pt}w{100pt}w{100pt}w{100pt}}
      %for img in imgs:
        \includegraphics[width=100pt,height=100pt,keepaspectratio]{${img}}
        %if j % 5 == 4 or j == len(all_mon) - 1:
          \\ 
          ${' & '.join('(%d)' % k for k in range(j - j % 5 + 1, j + 2))}\\ 
          %if j % 30 != 29:
            \midrule
            \addlinespace
          %endif
        %else:
          &
        %endif
        <% j += 1 %>
      %endfor
      \end{tabular}
      \end{center}
      \clearpage
      \begin{multicols*}{3}
      %if moni != len(all_mon) - 1:
        \begin{itemize}
      %endif
      <%
      imgs = []
      %>
    %endif
%endfor
\end{multicols*}

\clearpage

\section*{Sources Cited}

\begin{description}
\cited
\end{description}

\end{document}
