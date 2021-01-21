module Day04 (runDay04) where

import Data.List.Split ( splitOn )
import Data.List ( sort, sortBy, group )
import Data.Char (chr, ord)

data Room = Room { name     :: [String], 
                   id       :: Int, 
                   checksum :: String
                  } deriving Show

getChecksum :: [String] -> String
getChecksum name = take 5 $ ( map head . sortByLen . group . sort . concat) name
    where
        sortByLen ls = sortBy (\a b -> compare (length b) (length a)) ls

getRoom :: String -> Room
getRoom line = Room name id checksum
    where
        (metadata: name) = reverse $ splitOn "-" line
        [id_str, checksum] = splitOn "[" $ filter (/= ']') metadata
        id = read id_str

validRoom :: Room -> Bool 
validRoom (Room name id checksum) = getChecksum name == checksum

rotChar :: Int -> Char -> Char
rotChar n char = numToChar $ (charToNum char + n) `mod` 26
    where
        asciiA = ord 'a'
        charToNum char = ord char - asciiA   -- 'a' = 0, 'b' = 1 ...
        numToChar num  = chr (num + asciiA)

northPoleRoom :: Room -> Bool
northPoleRoom (Room name id _) = "northpole" `elem` (map . map) (rotChar id) name 

runDay04 :: String -> (Int, Int)
runDay04 input = (
        sum $ map Day04.id $ filter validRoom     $ map getRoom $ lines input,
        sum $ map Day04.id $ filter northPoleRoom $ map getRoom $ lines input
    )
