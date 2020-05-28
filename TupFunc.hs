-- Author: Alexandre Baizoukou


module TupFunc where

  import Data.List (sortBy)
  import Data.Function (on)

  add :: Num b => (a1, b) -> (a2, b) -> (a1, b)
  add (a1, b1) (a2, b2) = (a1, (b1 + b2))

addingTups :: Num b => [(a1, b)] -> [(a2, b)] -> [(a1, b)]
addingTups [] [] = []
addingTups [] _ = []
addingTups _ [] = []
addingTups (x:xs) (y:ys) = addingTups x y : addingTups xs ys

--- sorting ascending
sortAsc :: Ord b => [(a, b)] -> [(a, b)]
sortAsc = sortBy (compare `on` snd)

---- sorting Descending

sortDsc :: Ord b => [(a, b)] -> [(a, b)]
sortDsc = sortBy (flip compare `on` snd)

------- removing blank vote

removeEmptyVot :: (Eq b, Num b) => [(a, b)] -> [(a, b)]
removeEmptyVot xs = [(fst x, snd x) | x <- xs, snd x /= 0]

changeToNull :: Num p1 => p2 -> p1
changeToNull x = 0

swapSndToZero :: Num b => [(a, p2)] -> [(a, b)]
swapSndToZero [] = []
swapSndToZero ((a1, a2) : xs) = (a1, changeToNull a2) : swapSndToZero xs

---------------------- checking Duplicate votes

isDuplicates :: (Eq b, Num b) => [(a, b)] -> [(a, b)]
isDuplicates ((a1, a2) : []) = [(a1, a2)]
isDuplicates ((a1, a2) : xs) | a2 == snd (head xs) = (a1, changeToNull a2) : swapSndToZero xs | otherwise = ((a1, a2) : isDuplicates xs)

--------------- checking order of preference

prefOrd :: (Eq b, Num b) => [(a, b)] -> [(a, b)]
prefOrd ((a1, a2) : []) = [(a1, a2)]
prefOrd ((a1, a2) : xs) | snd (head xs) /= (a2 + 1) = ((a1, a2) : swapSndToZero xs) | otherwise = ((a1, a2) : prefOrd xs)
