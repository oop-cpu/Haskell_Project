module Syntax where

{-
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
-}

type Program = [Stmt]

data Stmt
  = If Condition [Stmt]
    | While Condition [Stmt]
    | ShapeDecl VarShape Shape Scale Point
    | AddToDrawing VarShape
    | Set Var Expr
    | Print Expr
    | InstructDrawing

data Shape
  = Square
    | Triangle
    | Circle

data Point = Point Expr Expr

type Scale = Int

data Expr
  = Num Int
    | VarE Var
    | Add Expr Expr
    | Sub Expr Expr
    | Mul Expr Expr
    | Div Expr Expr

data Condition
  = Eq Expr Expr
    | Ne Expr Expr
    | Lt Expr Expr
    | Gt Expr Expr
    | Le Expr Expr
    | Ge Expr Expr

type Var = String
type VarShape = String


instance Show Stmt where
  show (If cond stmts) =
    "if(" ++ show cond ++ "){\n"
    ++ concatMap show stmts
    ++ "}\n"

  show (While cond stmts) =
    "while(" ++ show cond ++ "){\n"
    ++ concatMap show stmts
    ++ "}\n"

  show (ShapeDecl v s sc p) =
    "shape " ++ v ++ " = "
    ++ show s ++ " size "
    ++ show sc ++ " at "
    ++ show p ++ ";\n"

  show (AddToDrawing v) =
    "add " ++ v ++ " to drawing;\n"

  show (Set v e) =
    "set " ++ v ++ " = " ++ show e ++ ";\n"

  show (Print e) =
    "print(" ++ show e ++ ");\n"

  show InstructDrawing =
    "instruct drawing;\n"

instance Show Shape where
  show Square   = "square"
  show Triangle = "triangle"
  show Circle   = "circle"

instance Show Expr where
  show (Num n)     = show n
  show (VarE v)    = v
  show (Add e1 e2) = show e1 ++ " + " ++ show e2
  show (Sub e1 e2) = show e1 ++ " - " ++ show e2
  show (Mul e1 e2) = show e1 ++ " * " ++ show e2
  show (Div e1 e2) = show e1 ++ " / " ++ show e2

instance Show Condition where
  show (Eq e1 e2) = show e1 ++ " == " ++ show e2
  show (Ne e1 e2) = show e1 ++ " != " ++ show e2
  show (Lt e1 e2) = show e1 ++ " < "  ++ show e2
  show (Gt e1 e2) = show e1 ++ " > "  ++ show e2
  show (Le e1 e2) = show e1 ++ " <= " ++ show e2
  show (Ge e1 e2) = show e1 ++ " >= " ++ show e2

instance Show Point where
  show (Point x y) =
    "(" ++ show x ++ "," ++ show y ++ ")"
