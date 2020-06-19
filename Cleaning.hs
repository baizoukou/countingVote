-- @uthor: Alexandre Baizoukou

module Cleaning (clean) where

---- functions for vote cleaning

import Generic
import Data.List (sort)


-- From a vote it derives those elements that shouldn't be on it.
removable :: [Int] -> [Int]
removable xs = cv ls 1
 where
   ls = sort . fout (-1) $ xs

   cv l@(c:cs) n
     | c == n    = cv cs (n+1)
     | otherwise = l
   cv []     n = []


-- Cleans votes
clean :: [Int] -> [Int]
clean xs = cn xs
   where
      cn cs = let f a b = if a == b then -1 else b
              in foldl (\acc b-> map (f b) acc) cs (removable cs)
