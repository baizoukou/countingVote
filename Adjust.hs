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
