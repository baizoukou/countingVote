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
                                  -- Return either best or worst candidate
                                  minMax :: (Ord a, Ord b) => Bool ->  [(a,b)] -> (a,b)
                                  minMax cond = let p = if cond then compare else flip (compare)
                                                in maximumBy (\(_,a) (_,b) -> p a b )

                                  -- From a Matrix of first preference grouped votes, sepparate the nth 
                                  -- sublist of votes
                                  takeCand :: [[Vote]] -> Int -> ([[Vote]], [Vote])
                                  takeCand xs n  = tv xs n []
                                    where
                                     tv (l@((Vote _ p _ ):_):xs) n vs
                                       | p == n    = ( reverse vs ++ xs, l )
                                       | otherwise = tv xs n (l:vs)
