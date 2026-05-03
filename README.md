#Drawing Language

##Instructions: 

###How to code: 
####Write all code in program.txt
####program.txt should be pre-loaded with a demo program.

###How to run: 
####Run and save instruction:    'runhaskell Main.hs program.txt 2> instructions.dat'
####Run with normal output:      'runhaskell Main.hs program.txt'
####Display drawing on terminal: 'java show'

##Context-Free Grammar
'''
<program>   -> [<stmt>]

<stmt> ->
if(<condition>){[<stmt>]}
| while(<condition>){[<stmt>]}
| shape <varShape> = <shape> size <scale> at <point>;
| add <varShape> to drawing;
| set <var> = <expr>;
| print(<expr>);
| instruct drawing;

<point>     -> (<expr>, <expr>)
<shape>     -> square | triangle | circle
<scale>     -> <R>

<expr> ->
<R>
| <var>
| <expr> + <expr>
| <expr> - <expr>
| <expr> * <expr>
| <expr> / <expr>

<condition> -> <expr> <boolop> <expr>

<boolop>    -> == | != | < | > | <= | >=
<var>       -> x | y | z | a | b | c | i
<varShape>  -> xx | yy | zz | aa | bb | cc | ii
<R>         -> digit+
'''
