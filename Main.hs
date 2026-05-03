module Main where

import Parser
import Semantics
import System.Environment

main :: IO ()
main = do
    [file] <- getArgs
    src <- readFile file
    case parseProgram src of
         Left err  -> print err
         Right ast -> evaluate ast `seq` return ()
