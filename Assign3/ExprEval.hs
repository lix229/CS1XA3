module ExprEval where

import ExprType
import ExprParser

unaryCalculation :: Operator -> Expr -> Maybe Double
unaryCalculation BinaryOp{} _ = undefined
unaryCalculation (UnaryOp _ _ op err) a = do
  aval <- calculationMap a
  if err aval then Nothing else Just $ op aval
-- Method for unaryCalculations

binaryCalculation :: Operator -> Expr -> Expr -> Maybe Double
binaryCalculation UnaryOp{} _ _ = undefined
binaryCalculation (BinaryOp _ _ op err) a b = do
  aval <- calculationMap a
  bval <- calculationMap b
  if err aval bval then Nothing else Just $ aval `op` bval
--Method for binaryCalculations

calculationMap :: Expr -> Maybe Double
calculationMap (ExprConst val) = Just val
calculationMap (ExprNegative a)  = unaryCalculation  uminus a
calculationMap (ExprFact a)    = unaryCalculation  fact   a
calculationMap (ExprPlus a b)  = binaryCalculation plus   a b
calculationMap (ExprMinus a b) = binaryCalculation minus  a b
calculationMap (ExprMult a b)  = binaryCalculation mult   a b
calculationMap (ExprDiv a b)   = binaryCalculation divop  a b
calculationMap (ExprPow a b)   = binaryCalculation pow    a b
-- Pattern matching over the constructor to identify the operation

parse :: String -> Maybe Double
parse s = calculationMap =<< parseInTree (filter (/=' ') s)
