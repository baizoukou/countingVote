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
---- Update votes removing votes whose first preference would be
-- null (exhausted votes) or an already chosen candidate
updVotes :: [Vote] -> [Int] -> [Vote]
updVotes []                         wc = []
updVotes ( (Vote w p []    ) : xs ) wc = updVotes xs wc
updVotes ( (Vote w p (y:ys)) : xs ) wc
| y == -1 || pred = updVotes xs wc
| otherwise       = (Vote w y ys) : updVotes xs wc
where pred = any (==y) wc
-- Used to update weights if necessary
changeWeight :: Weight -> [Vote] -> [Vote]
changeWeight w  = map (\(Vote p a b) -> Vote (p*w) a b)

-- Insert a vote into a Matrix of Votes grouped by first preference
insertVote :: [[Vote]] -> Vote -> [[Vote]]
insertVote [] _ = []
insertVote (l@((Vote _ p _ ):_):xs) h@(Vote _ p' _)
| p == p'   = (h:l) : xs

-- Transfer a bunch of 2nd preference votes to its corresponding group
transfer :: [[Vote]] -> [Vote] -> [[Vote]]
transfer xs ys = foldl insertVote xs ys

-- Computes quota
computeQuota :: Fractional a => Int -> Int -> a
computeQuota cand vot = let a = fromIntegral cand; b = fromIntegral vot
                        in (b / (a+1) ) + 1
