<html>
<head>
<title>Mon Compendium: ${name}</title>
<style type="text/css">
th { vertical-align: top }
</style>
</head>
<body>
<a href="..">&lt;&lt;</a>
<h1>${name}</h1>
<table>
<a href="${name}.svg"><img src="${name}-500.png" /></a>
%for k in ['kanji', 'transliteration', 'translation', 'date', 'owner', 'blazon', 'categories', 'notes', 'sources']:
  %if k in context.keys():
    <tr><th>${k.capitalize()}</th><td>${context[k]}</td></tr>
  %endif
%endfor
</table>
</body>
</html>
