module Main where

import Control.Applicative
import Control.Monad (forever)
import ExprParser
import ExprType
import ExprEval

main::IO()
main = do
  putStrLn "Please enter the expression. Ctrl-C to exit."
  forever $ do
    line <- getLine
    print $ parse line
