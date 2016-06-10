<html>
<head>
<title>Mon Compendium Index</title>
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

<h2>By Category</h2>

<p>Jump To:
%for c in sorted(category_map):
<a href="#${c}">${c}</a>
%endfor

%for c in sorted(category_map):
  <h3 id="${c}">${c}</h3>

  %for name in category_map[c]:
    <div><a href="Mon/${name}.html"><span><img src="Mon/${name}-200.png" /></span><br />${name}</a></div>
  %endfor
%endfor
</body>
</html>
