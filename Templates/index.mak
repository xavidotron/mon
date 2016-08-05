## -*- coding: utf-8 -*-
<%inherit file="base.mak"/>
<html>
<head>
<title>Japanese Heraldry Database</title>
<style type="text/css">
div {
  vertical-align: top;
  text-align: center;
  display: inline-block;
  width: 200px;
  margin: 5px;
}
span {
  display: table-cell;
  vertical-align: middle;
  height: 200px;
}
</style>
</head>
<body>

<h1>Kihō's Japanese Heraldry Database</h1>

<p>A compendium of mon (crests) and other forms of Japanese heraldry,
focusing on early Edo and pre-Edo Japan.  See
also <a href="http://fireflies.xavid.us/">Fireflies Sing</a>, my more general Feudal Japan blog.</a>

<%
lastprefix = 'zzz'
implicit_set = set()
%>

<h2>Contents</h2>
<ul>
%for c in sorted(category_map, key=self.get_key):
  %if c.startswith(lastprefix):
, <a href="#${c}">${c.split(': ', 1)[1]}</a>\
  %else:
    %if ': ' in c:
      <% lastprefix = c.split(': ', 1)[0] + ': ' %>
      <li><a href="#${c}">${c.split(': ', 1)[0]}</a>:
      <a href="#${c}">${c.split(': ', 1)[1]}</a>\
    %else:
      <% lastprefix = 'zzz' %>
      <li><a href="#${c}">${c}</a>
    %endif
  %endif
%endfor
</ul>

<h2>By Category</h2>

%for c in sorted(category_map, key=self.get_key):
  %if ' (' in c and c.split(' (', 1)[0] not in implicit_set:
  <% implicit_set.add(c.split(' (', 1)[0]) %>
  <a id="${c.split(' (', 1)[0]}"></a>
  %endif
  <h3 id="${c}">${c}</h3>

  %if c in notes_map:
    <p>${notes_map[c]}</p>
  %endif

  %if c in seealso_map:
    <p>See also: ${', '.join('<a href="#%s">%s</a>' % (sac, sac) for sac in seealso_map[c])}</p>
  %endif

  %for mon in category_map[c]:
    <div><a href="Mon/${mon['name']}"><span><img src="Mon/${mon['name']}-200.${mon['thumbsuf']}" /></span><br />${mon['name']} (${mon['year']})
    %if mon['count'] > 1:
      (x${mon['count']})
    %endif
    </a></div>
  %endfor
%endfor

<center style="margin: 5ex"><small>
Mon images are in the Public Domain. Other
content <a href="https://creativecommons.org/publicdomain/zero/1.0/">hereby
released into the Public Domain</a>.
</small></center>

</body>
</html>
