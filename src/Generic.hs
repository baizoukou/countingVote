module Generic where

---- Helper generic functions 

import Data.Char (isDigit) 
import Data.List (sortBy, maximumBy)


type Weight = Float

data Vote = Vote  Weight Int [Int]
  deriving (Show, Eq, Ord) 


-- shorthand for filtering out  an element of a list
fout :: Eq a => a -> [a] -> [a]
fout d = filter (/=(d))

-- shorthand for mapping through a matrix of things
mapMat :: (a -> b) -> [[a]] -> [[b]]
mapMat f = map (map f)

-- Get a candidates name from a candidate tuple
getName :: [String] -> (Int, Weight) -> (String, Weight) 
getName cs (ind, wt) = let name = cs !! (ind-1) 
                       in (name, wt) 
