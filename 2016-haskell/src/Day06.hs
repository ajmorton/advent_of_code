module Day06 (runDay06) where

import Data.List ( maximumBy, minimumBy, group, sort, transpose )
import Data.Function ( on )

message :: String -> (String -> Char) -> String
message input selector = map selector $ transpose $ lines input

getMostFreqChar :: String -> Char
getMostFreqChar = head . maximumBy (compare `on` length) . group . sort

getLeastFreqChar :: String -> Char
getLeastFreqChar = head . minimumBy (compare `on` length) . group . sort

runDay06 :: String -> (String, String)
runDay06 input = (
        message input getMostFreqChar,
        message input getLeastFreqChar
    )

