module ExprParser where

import ExprType
import Data.Maybe (catMaybes)
import Data.List (find)

type Parser a = String -> Maybe (String, a)

safeHead :: [a] -> Maybe a
safeHead s = if null s then Nothing else Just $ head s

next :: Parser Char
next s = do
  h <- safeHead s
  return (tail s, h)

parseByChar ::  Char -> Parser Char
parseByChar c s = do
  (s', rc) <- next s
  if rc == c then Just (s', c) else Nothing

charTaker :: [Parser a] -> Parser a
charTaker ps s = case catMaybes $ ps <*> pure s of
  []    -> Nothing
  (h:_) -> Just h

strToChar :: String -> Parser Char
strToChar s = charTaker $ parseByChar <$> s

numParser :: Parser Char
numParser = strToChar "1234567890"

greedy :: Parser a -> Parser [a]
greedy p = greedy' []
  where
    greedy' x s = case p s of
            Just (s', res) -> greedy' (x ++ [res]) s'
            Nothing -> Just (s, x)

greedy1 :: Parser a -> Parser [a]
greedy1 p s = case greedy p s of
  Nothing -> Nothing
  Just (_, []) -> Nothing
  val -> val

constParser :: Parser Expr
constParser s = do
  (s', intPart) <- greedy1 numParser s
  case parseByChar '.' s' of
    Nothing -> return (s', ExprConst $ read intPart)
    Just (s'', _) -> do
      (s''', fracPart) <- greedy numParser s''
      return (s''', ExprConst $ read $ intPart ++ "." ++ fracPart)

parseParent :: Parser Expr
parseParent s = do
  (s', _) <- parseByChar '(' s
  (s'', expr) <- parseExpr s'
  (s''', _) <- parseByChar ')' s''
  return (s''', expr)

parseUnary :: Operator -> Parser Expr
parseUnary BinaryOp {} _ = undefined
parseUnary (UnaryOp c f _ _) s = do
  (s', _) <- parseByChar c s
  (s'', e) <- parseExpr s'
  return (s'', f e)

parseTerm :: Parser Expr
parseTerm = charTaker [constParser, parseUnary uminus, parseUnary fact, parseParent]

byLayer :: [[Operator]] -> Parser Expr -> Parser Expr
byLayer [] l s = l s
byLayer (ops:opss) l s = do
  (s', res) <- nextLayer s
  (s'', resTail) <- greedy layerTail s'
  return (s'', toExpr $ (head ops, res):resTail)
  where
    opExpr (BinaryOp _ f _ _) = f
    opExpr UnaryOp {} = undefined

    nextLayer = byLayer opss l
    layerTail ts = do
      (s', opChar) <- strToChar (opName <$> ops) ts
      (s'', resTail) <- nextLayer s'
      op <- find ((== opChar).opName) ops
      return (s'', (op, resTail))

    toExpr [] = undefined
    toExpr [(_, e)] = e
    toExpr ((_, e1):(op, e2):es) = toExpr $ (op, opExpr op e1 e2) : es

parseExpr :: Parser Expr
parseExpr = byLayer [[plus, minus], [mult, divop], [pow]] parseTerm

parseInTree :: String -> Maybe Expr
parseInTree s = case parseExpr s of
  Just ([], tree) -> Just tree
  _ -> Nothing
