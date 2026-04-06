import Syntax

{-
p1:

set x = 10
line (0,0) to (5,5)
if(x > 5){
  print(x)
}
-}

s1 :: Stmt
s1 = Set "x" (Num 10)

s2 :: Stmt
s2 = Line (Point 0 0) (Point 5 5)

s3 :: Stmt
s3 =
  If (Gt (VarE "x") (Num 5))
     [ Print (VarE "x") ]

p1 :: Program
p1 = [s1, s2, s3]

main :: IO ()
main = do
    putStrLn "Program 1..."
    print p1

    putStrLn "\nSingle statement (line)..."
    print s2