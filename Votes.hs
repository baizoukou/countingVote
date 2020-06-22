module Votes where

-- functions to accomodate input into a better
-- representation

import Generic
import Data.List (sortBy, maximumBy)

-- Transform Integer list to formal Vote
toVote :: [Int] -> Vote
toVote (x:xs) = Vote 1.0 x xs

-- Total the weights in a list of votes
-- If a single candidate, it calculates its current score
candWeight :: [Vote] -> (Int, Float)
candWeight []                  = error "CORRECT"
candWeight l@(Vote _ f _ : xs) = let foo n (Vote w p _) = n + w
                                  in (f, foldl foo 0 l)
