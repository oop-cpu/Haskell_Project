module Semantics where

import Syntax

import Debug.Trace (trace)

type EnvVars   = [(Var, Int)]
type EnvShapes = [(VarShape, ShapeInstance)]
type Drawing   = [ShapeInstance]

data ShapeInstance = SI Shape Int (Int, Int)
    deriving (Show)

type State = (EnvVars, EnvShapes, Drawing)

evaluate :: Program -> State
evaluate prog = evaluateProg prog ([], [], [])

evaluateProg :: [Stmt] -> State -> State
evaluateProg [] st = st
evaluateProg (s:ss) st =
    let st' = evaluateStmt s st
    in evaluateProg ss st'


evaluateStmt :: Stmt -> State -> State

evaluateStmt (Set v e) (vars, shapes, drw) =
    ((v, evalExpr vars e) : vars, shapes, drw)

evaluateStmt (Print e) st@(vars, _, _) =
    trace (show (evalExpr vars e)) st

evaluateStmt (ShapeDecl v sh sc p) (vars, shapes, drw) =
    let pt   = evalPoint vars p
        inst = SI sh sc pt
    in (vars, (v, inst) : shapes, drw)

evaluateStmt (AddToDrawing v) (vars, shapes, drw) =
    case lookup v shapes of
         Just inst -> (vars, shapes, inst : drw)
         Nothing   -> error ("Undefined shape: " ++ v)

evaluateStmt (If c ss) st@(vars, _, _) =
    if evalCond vars c
    then evaluateProg ss st
    else st

evaluateStmt w@(While c ss) st@(vars, _, _) =
    if evalCond vars c
        then evaluateStmt w (evaluateProg ss st)
        else st

evaluateStmt InstructDrawing st@(_, _, drw) =
    trace (unlines (map show (reverse drw))) st


evalExpr :: EnvVars -> Expr -> Int
evalExpr _   (Num n) = n
evalExpr env (VarE v) =
    case lookup v env of
        Just n  -> n
        Nothing -> error ("Undefined variable: " ++ v)

evalExpr env (Add e1 e2) = evalExpr env e1 + evalExpr env e2
evalExpr env (Sub e1 e2) = evalExpr env e1 - evalExpr env e2
evalExpr env (Mul e1 e2) = evalExpr env e1 * evalExpr env e2
evalExpr env (Div e1 e2) =
    let d = evalExpr env e2
    in if d == 0
        then error "Division by zero"
        else evalExpr env e1 `div` d


evalPoint :: EnvVars -> Point -> (Int, Int)
evalPoint env (Point ex ey) =
    (evalExpr env ex, evalExpr env ey)

evalCond :: EnvVars -> Condition -> Bool
evalCond env (Eq e1 e2) = evalExpr env e1 == evalExpr env e2
evalCond env (Ne e1 e2) = evalExpr env e1 /= evalExpr env e2
evalCond env (Lt e1 e2) = evalExpr env e1 <  evalExpr env e2
evalCond env (Gt e1 e2) = evalExpr env e1 >  evalExpr env e2
evalCond env (Le e1 e2) = evalExpr env e1 <= evalExpr env e2
evalCond env (Ge e1 e2) = evalExpr env e1 >= evalExpr env e2
