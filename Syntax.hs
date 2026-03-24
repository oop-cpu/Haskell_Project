module Syntax where

-- context free grammar

-- object languague
{-
<program> -> <stmts>
<stmts> -> <stmt><stmts> | epsilon    -- [<stmt>]
<stmt> -> create table <tablename> [<column>]
    | insert into <tablename> values [<record>]
    | update <tablename> set <columnname> = <value>
    | update <tablename> set <columnname> = <value> where [<condition>]
    | delete from <tablename> where <condition> [<condition>]
    | select * from <tablename>
    | select * from <tablename> where [<condition>]
    | select [<columnname>] from <tablename>
    | select [<columnname>] from <tablename> where [<condition>]

<condition> -> <columnname> <value>

<tablename> -> string
<columnname> -> string
<type> -> int | string | float | bool | date
<column> -> (<columnname>, <type>)

<record> -> [<value>]
<value> -> Int | Float | String | Bool | Date Int Int Int

<table> -> [<column>] [<record>]
-- environment
<env> -> [(<tablename>, <table>)]
-}

-- abstract syntax
type Program = [Stmt]
data Stmt = Create TableName [Column]
        | Insert TableName [Record]
        | Update TableName (Columnname, Value) [Condition]
        | Delete TableName Condition [Condition]
        | SelectAll TableName [Condition]
        | Select [Columnname] TableName [Condition]
    -- deriving Show
type Column = (Columnname, Type)

instance Show Stmt where
    show (Create t cols) = "create table " ++ t ++ " [" ++ printCols cols ++ "]\n"
    show (Insert t recs) = "insert into " ++ t ++ " values\n" ++ printRecs recs ++ "\n"
    show (Update t (c, v) []) = "update " ++ t ++ " set " ++ c ++ " = " ++ show v
    show (Update t (c, v) conds) = "update " ++ t ++ " set " ++ c ++ " = " ++ show v ++ " where\n{\n" ++ printConds conds ++ "\n}\n"
    show (Delete t cond []) = "delete from " ++ t ++ " where\n" ++ printCondition cond ++ "\n"
    show (Delete t cond conds) = "delete from " ++ t ++ " where\n{\n" ++ printConds (cond: conds) ++ "\n}\n"
    show (SelectAll t []) = "select * from " ++ t ++ "\n"
    show (SelectAll t conds) = "select * from " ++ t ++ " where\n{\n" ++ printConds conds ++ "\n}\n"
    show (Select cols t []) = "select " ++ show cols ++ " from " ++ t ++ "\n"
    show (Select cols t conds) = "select " ++ show cols ++ " from " ++ t ++ " where\n{\n" ++ printConds conds ++ "\n}\n"

type Condition = (Columnname, Value)
type Record = [Value]

printRecord :: Record -> String
printRecord [] = ""
printRecord [v] = show v
printRecord (v : vals) = show v ++ ", " ++ printRecord vals

-- sqr 3 + 5 => (sqr 3) + 5
-- sqr (3+5) => sqr 8

printRecs :: [Record] -> String
printRecs [] = ""
printRecs [r] = "(" ++ printRecord r ++ ")"
printRecs (r:recs) = "(" ++ printRecord r ++ "),\n" ++ printRecs recs

printCondition :: Condition -> String
printCondition (c, v) = "  " ++ c ++ " = " ++ show v

printConds :: [Condition] -> String
printConds [] = ""
printConds [c] = printCondition c
printConds (c: conds) = printCondition c ++ ",\n" ++ printConds conds

type TableName = String -- type synonyms
type Columnname = String
data Type = TypeI | TypeS | TypeF | TypeB | TypeD
    -- deriving Show



printColumn :: Column -> String
printColumn (c, t) = "(" ++ c ++ ", " ++ show t ++ ")"

printCols :: [Column] -> String
printCols [] = ""
printCols [c] = printColumn c
printCols (c : cols) = printColumn c ++ ", " ++ printCols cols

-- I :: Int -> Value
data Value = I Int | F Float | B Bool | S String | Date Month Day Year
    -- deriving Show

type Year = Int
type Month = Int
type Day = Int



data Table = T [Column] [Record]
    deriving Show

-- environment
type Env = [(TableName, Table)]

-- show :: a -> String
instance Show Type where
    show (TypeI) = "int"
    show (TypeF) = "float"
    show (TypeS) = "string"
    show (TypeB) = "bool"
    show (TypeD) = "date"

instance Show Value where
    show (I iv) = show iv
    show (F fv) = show fv
    show (B bv) = show bv
    show (S sv) = show sv -- show (S "abc") => "abc"
    show (Date m d y) = show m ++ "-" ++ show d ++ "-" ++ show y
