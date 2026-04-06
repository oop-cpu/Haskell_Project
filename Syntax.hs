module Syntax where

{-
<program>   -> [<stmt>]

<stmt> ->
    if(<condition>){[<stmt>]}
  | while(<condition>){[<stmt>]}
  | line <point> to <point>
  | store <drawing> as <var>
  | set <var> = <expr>
  | print(<expr>)
  | instruct <drawing>

<point>    -> (<R>, <R>)
<line>     -> (<point>, [<point>])
<drawing>  -> (<line>, [<line>])

<expr>     -> <R> | <var> | <drawing>
<condition> -> <expr> <boolop> <expr>

<boolop>   -> == | != | < | > | <= | >=
<var>      -> x | y | z | a | b | c
<R>        -> digit+
-}

type Program = [Stmt]

data Stmt
  = If Condition [Stmt]
  | While Condition [Stmt]
  | Line Point Point
  | Store Drawing Var
  | Set Var Expr
  | Print Expr
  | Instruct Drawing

data Point = Point Int Int
data LineObj = LineObj Point [Point]
data Drawing = Drawing LineObj [LineObj]

data Expr
  = Num Int
  | VarE Var
  | DrawE Drawing

data Condition
  = Eq Expr Expr
  | Ne Expr Expr
  | Lt Expr Expr
  | Gt Expr Expr
  | Le Expr Expr
  | Ge Expr Expr

type Var = String



instance Show Stmt where
  show (If cond stmts) =
    "if(" ++ show cond ++ "){\n"
      ++ concatMap show stmts
      ++ "}\n"

  show (While cond stmts) =
    "while(" ++ show cond ++ "){\n"
      ++ concatMap show stmts
      ++ "}\n"

  show (Line p1 p2) =
    "line " ++ show p1 ++ " to " ++ show p2 ++ "\n"

  show (Store d v) =
    "store " ++ show d ++ " as " ++ v ++ "\n"

  show (Set v e) =
    "set " ++ v ++ " = " ++ show e ++ "\n"

  show (Print e) =
    "print(" ++ show e ++ ")\n"

  show (Instruct d) =
    "instruct " ++ show d ++ "\n"


instance Show Expr where
  show (Num n)   = show n
  show (VarE v)  = v
  show (DrawE d) = show d


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

instance Show LineObj where
  show (LineObj p ps) =
    "(" ++ show p ++ ", " ++ show ps ++ ")"

instance Show Drawing where
  show (Drawing l ls) =
    "(" ++ show l ++ ", " ++ show ls ++ ")"
