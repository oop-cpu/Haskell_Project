module Example where

import Syntax
import Semantics

{-
p1:

set i = 0;
set x = 10;
while(i < x){
shape xx = square size 2 at (i, 5);
add xx to drawing;
set i = i + 1;
}
instruct drawing;
-}

s1 :: Stmt
s1 = Set "i" (Num 0)

s2 :: Stmt
s2 = Set "x" (Num 10)

s3 :: Stmt
s3 =
  ShapeDecl "xx" Square 2
  (Point (VarE "i") (Num 5))

s4 :: Stmt
s4 = AddToDrawing "xx"

s5 :: Stmt
s5 = Set "i" (Add (VarE "i") (Num 1))

sWhile :: Stmt
sWhile =
  While (Lt (VarE "i") (VarE "x"))
  [ s3
  , s4
  , s5
  ]

sEnd :: Stmt
sEnd = InstructDrawing

p1 :: Program
p1 = [s1, s2, sWhile, sEnd]

main :: IO ()
main = do
  putStrLn "Program 1..."
  print p1
