module Adjust (
                commaSep,
                filterVoters,
                toStandard,
                perm,
                sortByHead,
                removeSpoiled,
                accom
               ) where

import Data.List.Split (splitWhen)
import Data.List (sortBy, groupBy)
import Data.Char (isDigit)
import Generic

-- Break lines in comma sepparated vals
commaSep :: String -> [String]
commaSep = splitWhen (==',')
-- Filter voters name, or 2 first csv on the .csv
filterVoters :: String -> [[String]]
filterVoters = (map (tail . tail)) . map commaSep . lines

-- Remove empty* sublist from 3d list
removeEmp :: Eq a => [[[a]]] -> [[[a]]]
removeEmp = filter (not . all (==[]))

-- Convert input csv to a standard vote (Int) representation
toStandard :: [[String]] -> [[Int]]
toStandard = mapMat (toMine) . removeEmp . mapMat toValid
where
toMine cs = if head cs == '*' then -1 else read cs :: Int
toValid   = let pred p = isDigit p || p == '*'
in filter pred
 -- create list of candidates ranked by index out of list of preferences
perm :: Int -> [Int] ->  [Int]
perm n = map choosePropper . (toBack [] ) . sortTup . (tupling n 1)
where
tupling _ _ []     = []
tupling r n (x:xs)
| n < r     = (x,n) : tupling r (n+1) xs
| otherwise = [(x,n)]
sortTup = sortBy (\(a,_) (b,_) -> compare a b)

  toBack  bs (l@(-1,b):xs) = toBack (l:bs) xs
  toBack  bs (x:xs)        = x : toBack bs xs
  toBack  bs []            = bs

  choosePropper (a,b) = if a == -1 then -1 else b

-- Sort list of list by head of sublists
sortByHead :: Ord a => [[a]] -> [[a]]
sortByHead = sortBy (\(x:_) (y:_) -> compare x y)

-- Remove sublists off only -1
removeSpoiled :: [[Int]] -> [[Int]]
removeSpoiled = filter (not . all (==(-1)))

-- Group elements on a matrix by their heads
accom :: Eq a => [[a]] -> [[[a]]]
accom = groupBy (\ (x:_) (y:_) -> x == y )
