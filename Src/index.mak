## -*- coding: utf-8 -*-
<html>
<head>
<title>Japanese Heraldry Database</title>
<style type="text/css">
div {
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

<h2>By Category</h2>

<p>Jump To:
%for c in sorted(category_map):
<a href="#${c}">${c}</a>
%endfor

%for c in sorted(category_map):
  <h3 id="${c}">${c}</h3>

  %for year, name in category_map[c]:
    <div><a href="Mon/${name}"><span><img src="Mon/${name}-200.png" /></span><br />${name} (${year})</a></div>
  %endfor
%endfor

<center style="margin: 5ex">
Mon images are in the Public Domain. Other
content <a href="https://creativecommons.org/publicdomain/zero/1.0/">hereby
released into the Public Domain</a>.
</center>

</body>
</html>
