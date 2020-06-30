module Main where


import Control.Monad (when) 
import Data.List (transpose, sort, sortBy)
import System.Directory (listDirectory)
import System.Environment (getArgs)
import System.IO (readFile)

import Adjust
import Cleaning
import Generic 
import Votes


main :: IO ()
main = do 
   dirEnts <- listDirectory "."
   args <- getArgs

   if length args == 2 then do 

     let csvFile = args !! 0
         exists = any (==csvFile) dirEnts
         nSeats = read (args !! 1) :: Int

     if exists then do
       csv <- readFile csvFile
      
       let (cands:fullVotes) = filterVoters csv        -- extract text
           nCands     = length cands
  
       if nCands >= nSeats then do 
  
          let standard   = toStandard fullVotes        -- make it a [[Int]]
              cleaned    = map clean standard          -- clean votes 
              rankList   = map (perm nCands) cleaned   -- transform to list of ranked cands 
              unSpol     = removeSpoiled rankList
  
              nVotes     = length unSpol               -- # of unspoiled votes
              quota      = computeQuota nSeats nVotes  -- quota
  
              sorted     = sortByHead unSpol           -- sort to group
              grouped    = accom sorted                -- group by head
              final      = mapMat toVote grouped       -- convert to vote
           
             --- a composition of a lot of functions bound to a name.
              allW = mapMat toVote . accom . sortByHead . removeSpoiled . map ( (perm nCands) . clean ) . toStandard $ fullVotes
  
          if length final >= nSeats then do 
  
            isEnd <- checkEnd final cands [] nSeats
   
            when (not isEnd) (do  
              putStrLn $ "Quota of: " ++ show quota 
              transference final [] [] nSeats quota cands)
  
          else putStrLn "stv: Less candidates than seats after cleaning."
       else  putStrLn "stv: Less candidates than seats.."
     else putStrLn "stv: No such .csv file."
   else putStrLn "stv: Format is: stv [file.csv] [number-of-seats]"


-- Routine for dealing with transference on votes. It recursively applies the stv 
-- method accross each round. Arguments are: 
--
-- [grouped votes] -> [winners] -> [losers] -> # of seats -> quota -> [names] 
transference :: [[Vote]] -> [(Int,Weight)] -> [Int] -> Int -> Float -> [String] -> IO ()
transference grpVts winers losers nSeats quota candidates = do 
   let eltd   = map fst winers 
       nEltd  = length eltd
       remaining = length grpVts 
       results   = map candWeight grpVts 
       (wn, wt)  = minMax True results

   putStrLn $ "\nResults: " ++ show (map (getName candidates) results) 
  
   if ( wt > quota ) then do           
     let (grpVts', votes) = takeCand grpVts wn               -- separate winner from hopefulls
         newEltd       = wn:eltd 
         unexhausted      = updVotes votes (newEltd++losers) -- remove exhausted votes

         (w,ttw)          = candWeight unexhausted           -- compute total transference weight
         surplus          = wt - quota
         ratio            = surplus/ttw

         finalVotes       = if ttw > surplus                 -- choose wether to update weight
                            then changeWeight ratio unexhausted 
                            else unexhausted
         newWiners        = ((wn,wt):winers) 
         newGroupedVotes  = transfer grpVts' finalVotes

     putStrLn $ (candidates !! (wn-1)) ++ " eltd with weight " ++ show wt 
     isEnd <- checkEnd newGroupedVotes candidates newWiners nSeats

     when (not isEnd) $ do       

       putStrLn $ "Redistributing surplus of: " ++ show surplus 
       putStrLn $ show ratio ++ " is the new weighting factor "

       transference newGroupedVotes newWiners losers nSeats quota candidates
      
   else do 
     let (ls, wt)               = minMax False results          -- compute looser
         (grpVts', votes)       = takeCand grpVts ls            -- separate looser from hopefulls
         unexhausted            = updVotes votes (eltd++losers) -- arrange votes 
         newGroupedVotes        = transfer grpVts' unexhausted
         newLosers              = ls:losers

     putStrLn $ (candidates !! (ls-1)) ++ " Eliminated "
     isEnd <- checkEnd newGroupedVotes candidates winers nSeats

     when (not isEnd) $ do      
         
       transference grpVts' winers newLosers nSeats quota candidates
       

-- Check termination of the voting process. Arguments are
-- [grouped votes] -> [candidate names] -> [winners] -> # of seats
checkEnd ::  [[Vote]] -> [String] -> [(Int,Weight)] -> Int -> IO Bool 
checkEnd grpVts candidates winers nSeats = do 
     let nEl    = length winers
         rem    = length grpVts
         condA  = nEl == nSeats
         condB  = nEl + rem == nSeats
         result = map candWeight grpVts

     if (condA || condB) then do 
       putStrLn "\nAll seats filled."
        
       if condA then do 
         let short = map (getName candidates) (reverse winers)
         putStrLn $ "Winners: "++ show short
       else do 
         let std   = sortBy (\(_,a) (_,b) -> compare b a ) result 
             short = map (getName candidates) (reverse winers ++ std)
         putStrLn $ "Winners: "++ show short 
       
       return True
     else do return False
