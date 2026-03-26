{-

context free grammar

<canvas> -> <stmts>
<stmts> -> <stmt> <stmts>

<stmt> ->
	if(<condition>){<stmts>}
	| while(<condition>){<stmts>}
	| line <point> to <point>
	| store <drawing> as <var>
	| set <var> = <expr>
	| print(<expr>)
	| instruct <drawing>
	
<point> -> (<R>, <R>)
<line> -> ( point, [<point>] )
<drawing> -> ( line, [<line>] )
	
<expr> -> (<expr>) | [R] | <var> | <drawing>
<var> -> x | y | z | a | b | c 

<condition> -> <expr> <boolop> <expr>

-}






{-



-}





























