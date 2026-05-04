# Drawing Language

## Needed Installs

- GHC and Java
```bash
sudo apt install ghc
```
```bash
sudo apt install java
```

## Compile Java
```bash
javac shape.java
```
```bash
javac displayManager.java
```
```bash
javac show.java
```

## Instructions

### How to Code
- Write all code in `program.txt`
- `program.txt` should be pre-loaded with a demo program

### How to Run
Run/Save/Show from source code `program.txt`
```bash
runhaskell Main.hs program.txt 2> instructions.dat; java show
```
Run and save instructions:
```bash
runhaskell Main.hs program.txt 2> instructions.dat
```
Run with normal output: 
```bash
runhaskell Main.hs program.txt
```
Render and print drawing on terminal: 
```bash
java show
```
### Context-Free Grammar
```haskell
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
```
