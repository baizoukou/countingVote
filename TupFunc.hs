-- Author: Alexandre Baizoukou


module TupFunc where

  import Data.List (sortBy)
  import Data.Function (on)

  add :: Num b => (a1, b) -> (a2, b) -> (a1, b)
  add (a1, b1) (a2, b2) = (a1, (b1 + b2))
