module ExprType where

data Expr =
    ExprConst Double
  | ExprPlus    Expr Expr
  | ExprMinus   Expr Expr
  | ExprNegative  Expr
  | ExprMult    Expr Expr
  | ExprDiv     Expr Expr
  | ExprPow     Expr Expr
  | ExprFact    Expr
  deriving (Show)

data Operator =
    UnaryOp  OpName (Expr -> Expr) (Double -> Double) (Double -> Bool)
  | BinaryOp OpName (Expr -> Expr -> Expr) (Double -> Double -> Double) (Double -> Double -> Bool)

type OpName = Char

fact, uminus, plus, minus, mult, divop, pow :: Operator
fact   = UnaryOp  '!' ExprFact   (\n-> fromIntegral $ product [1 .. floor n :: Int]) (\v -> fromIntegral (floor v :: Int) /= v)
uminus = UnaryOp  '-' ExprNegative (\v -> -v) (const False)
plus   = BinaryOp '+' ExprPlus   (+)        (const.const False)
minus  = BinaryOp '-' ExprMinus  (-)        (const.const False)
mult   = BinaryOp '*' ExprMult   (*)        (const.const False)
divop  = BinaryOp '/' ExprDiv    (/)        (const.(/= 0.0))
pow    = BinaryOp '^' ExprPow    (**)       (\va vb -> va < 0 && vb < 0)

opName :: Operator -> OpName
opName (UnaryOp c _ _ _)  = c
opName (BinaryOp c _ _ _) = c
