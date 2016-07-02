## -*- coding: utf-8 -*-
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
def get_key(c):
   return c.replace('Other ', 'ZZY ').replace('Other', 'ZZZ')
lastprefix = 'zzz'
%>

<h2>Contents</h2>
<ul>
%for c in sorted(category_map, key=get_key):
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

%for c in sorted(category_map, key=get_key):
  <h3 id="${c}">${c}</h3>

  %for year, name, thumbsuf in category_map[c]:
    <div><a href="Mon/${name}"><span><img src="Mon/${name}-200.${thumbsuf}" /></span><br />${name} (${year})</a></div>
  %endfor
%endfor

<center style="margin: 5ex">
Mon images are in the Public Domain. Other
content <a href="https://creativecommons.org/publicdomain/zero/1.0/">hereby
released into the Public Domain</a>.
</center>

</body>
</html>
