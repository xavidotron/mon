<%
def get_key(c):
   return (c.replace('Other ', 'ZZY ').replace('Other', 'ZZZ')
            .replace('One', '1').replace('Two', '2').replace('Three', '3')
	    .replace('1-', 'One-').replace('2-', 'Two-').replace('3-', 'Three-')
	    .replace('Single', '1')
            .replace(')', '  ')
	   )
self.get_key = get_key
%>

${self.body()}