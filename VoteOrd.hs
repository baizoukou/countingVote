------------- Alexandre Baizoukou ----------
import Data.List
import TupFunc
import DATA

-------The quota is calculated quota = (number of valid votes number of seats + 1 ) + 1 3. ----
getQuota :: [vote] -> Int -> Float
getQuota xs x = fromIntegral (length xs) / fromIntegral (x + 1) + 1

------------------List representative of quota reach --------
chosenOne :: [Float] -> Float -> Bool
chosenOne xs x | True `elem` [x >= x | x <- xs] = True | otherwise = False

----------------- counting candidate votes and display elected
candidatElect :: [Float] -> [Elect] -> [Elect] -> [Elect]
candidatElect xs candidates
