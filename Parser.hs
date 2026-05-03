module Parser (parseProgram) where

import Syntax
import Text.Parsec
import Text.Parsec.String (Parser)
import Text.Parsec.Expr
import Control.Monad.Identity (Identity)

--------------------------------------------------
-- Lexer helpers
--------------------------------------------------

lexeme :: Parser a -> Parser a
lexeme p = p <* spaces

symbol :: String -> Parser String
symbol s = lexeme (string s)

parens :: Parser a -> Parser a
parens = between (symbol "(") (symbol ")")

integer :: Parser Int
integer = lexeme (read <$> many1 digit)

identifier :: Parser String
identifier = lexeme ((:) <$> letter <*> many (alphaNum <|> char '_'))

--------------------------------------------------
-- Expressions
--------------------------------------------------

pExpr :: Parser Expr
pExpr = buildExpressionParser table pTerm

pTerm :: Parser Expr
pTerm =
    Num <$> integer
        <|> VarE <$> identifier
        <|> parens pExpr

table :: OperatorTable String () Identity Expr
table =
    [ [ Infix (Mul <$ symbol "*") AssocLeft
        , Infix (Div <$ symbol "/") AssocLeft ]
        , [ Infix (Add <$ symbol "+") AssocLeft
        , Infix (Sub <$ symbol "-") AssocLeft ]
        ]

    --------------------------------------------------
    -- Points
    --------------------------------------------------

pPoint :: Parser Point
pPoint =
    parens $ do
        x <- pExpr
        _ <- symbol ","
        y <- pExpr
        return (Point x y)

        --------------------------------------------------
        -- Shapes
        --------------------------------------------------

pShape :: Parser Shape
pShape =
    Square   <$ symbol "square"
    <|> Triangle <$ symbol "triangle"
    <|> Circle   <$ symbol "circle"

        --------------------------------------------------
        -- Conditions
        --------------------------------------------------

pCondition :: Parser Condition
pCondition = do
    e1 <- pExpr
    op <- choice
        [ try (Eq <$ symbol "==")
        , try (Ne <$ symbol "!=")
        , try (Le <$ symbol "<=")
        , try (Ge <$ symbol ">=")
        , Lt <$ symbol "<"
        , Gt <$ symbol ">" ]
    e2 <- pExpr
    return (op e1 e2)

            --------------------------------------------------
            -- Statements
            --------------------------------------------------

pSet :: Parser Stmt
pSet = do
    _ <- symbol "set"
    v <- identifier
    _ <- symbol "="
    e <- pExpr
    _ <- symbol ";"
    return (Set v e)

pShapeDecl :: Parser Stmt
pShapeDecl = do
    _ <- symbol "shape"
    v <- identifier
    _ <- symbol "="
    sh <- pShape
    _ <- symbol "size"
    sc <- integer
    _ <- symbol "at"
    pt <- pPoint
    _ <- symbol ";"
    return (ShapeDecl v sh sc pt)

pAdd :: Parser Stmt
pAdd = do
    _ <- symbol "add"
    v <- identifier
    _ <- symbol "to"
    _ <- symbol "drawing"
    _ <- symbol ";"
    return (AddToDrawing v)

pPrint :: Parser Stmt
pPrint = do
    _ <- symbol "print"
    e <- parens pExpr
    _ <- symbol ";"
    return (Print e)

pInstruct :: Parser Stmt
pInstruct = do
    _ <- symbol "instruct"
    _ <- symbol "drawing"
    _ <- symbol ";"
    return InstructDrawing

                                --------------------------------------------------
                                -- Blocks / control flow
                                --------------------------------------------------

pBlock :: Parser [Stmt]
pBlock =
    between (symbol "{") (symbol "}") (many pStmt)

pIf :: Parser Stmt
pIf = do
    _ <- symbol "if"
    cond <- parens pCondition
    body <- pBlock
    return (If cond body)

pWhile :: Parser Stmt
pWhile = do
    _ <- symbol "while"
    cond <- parens pCondition
    body <- pBlock
    return (While cond body)

                                                        --------------------------------------------------
                                                        -- Program
                                                        --------------------------------------------------

pStmt :: Parser Stmt
pStmt = choice
    [ try pShapeDecl
        , try pAdd
        , try pSet
        , try pPrint
        , try pIf
        , try pWhile
        , pInstruct
        ]

parseProgram :: String -> Either ParseError Program
parseProgram =
    parse (spaces *> many pStmt <* eof) "<input>"
