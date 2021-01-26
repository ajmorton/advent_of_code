module Day09 (runDay09) where

import Data.List.Split ( splitOn )

type LengthFunc = Int -> Int -> String -> Int

part1 :: LengthFunc
part1 n m remString = n * m + ddecode (drop n remString) part1

part2 :: LengthFunc
part2 n m remString = (m * ddecode (take n remString) part2) + ddecode (drop n remString) part2

ddecode :: String -> LengthFunc -> Int
ddecode str lengthFunc
    | null str        = 0
    | head str == '(' = lengthFunc n m remString
    | otherwise       = 1 + ddecode (tail str) lengthFunc 
    where
        repeat    = takeWhile (/=')') $ tail str
        [n, m]    = map read $ splitOn "x" repeat 
        remString = tail $ dropWhile (/=')') str

runDay09 :: String -> (Int, Int)
runDay09 input = (
    ddecode input part1, 
    ddecode input part2
    )

