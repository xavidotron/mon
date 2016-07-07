## -*- coding: utf-8 -*-
<html>
<head>
<title>Japanese Heraldry Database: ${name}</title>
<style type="text/css">
th { vertical-align: top }
</style>
</head>
<body>
<a href="..">&lt;&lt;</a>
<h1>${name}</h1>
%for iname,suffix,thumbsuf in images:
<a href="${iname}.${suffix}"><img src="${iname}-500.${thumbsuf}" /></a>
%endfor
<table>
%for k in ['kanji', 'transliteration', 'translation', 'date', 'owner', 'blazon', 'categories', 'notes', 'sources']:
  %if k in context.keys():
    <tr><th>${k.capitalize()}</th><td>${unicode(context[k]).replace('\n\n', '\n\n<p>')}</td></tr>
  %endif
%endfor
</table>

<center style="margin: 5ex"><small>
Mon images are in the Public Domain. Other
content <a href="https://creativecommons.org/publicdomain/zero/1.0/">hereby
released into the Public Domain</a>.
</small></center>

</body>
</html>
