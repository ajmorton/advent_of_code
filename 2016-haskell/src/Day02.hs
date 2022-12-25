module Day02 (runDay02) where

type Key  = Char
type Move = Char
type Pad  = Key -> Move -> Key

pad1 :: Pad
pad1 '1' 'D' = '4'; pad1 '1' 'R' = '2'
pad1 '2' 'D' = '5'; pad1 '2' 'L' = '1'; pad1 '2' 'R' = '3'
pad1 '3' 'D' = '6'; pad1 '3' 'L' = '2'
pad1 '4' 'U' = '1'; pad1 '4' 'D' = '7'; pad1 '4' 'R' = '5'
pad1 '5' 'U' = '2'; pad1 '5' 'D' = '8'; pad1 '5' 'L' = '4'; pad1 '5' 'R' = '6'
pad1 '6' 'U' = '3'; pad1 '6' 'D' = '9'; pad1 '6' 'L' = '5'
pad1 '7' 'U' = '4'; pad1 '7' 'R' = '8'
pad1 '8' 'U' = '5'; pad1 '8' 'L' = '7'; pad1 '8' 'R' = '9'
pad1 '9' 'U' = '6'; pad1 '9' 'L' = '8'
pad1  k   _  = k

pad2 :: Pad
pad2 '1' 'D' = '3'
pad2 '2' 'D' = '6'; pad2 '2' 'R' = '3'
pad2 '3' 'U' = '1'; pad2 '3' 'D' = '7'; pad2 '3' 'L' = '2'; pad2 '3' 'R' = '4'
pad2 '4' 'D' = '8'; pad2 '4' 'L' = '3'
pad2 '5' 'R' = '6'
pad2 '6' 'U' = '2'; pad2 '6' 'D' = 'A'; pad2 '6' 'L' = '5'; pad2 '6' 'R' = '7'
pad2 '7' 'U' = '3'; pad2 '7' 'D' = 'B'; pad2 '7' 'L' = '6'; pad2 '7' 'R' = '8'
pad2 '8' 'U' = '4'; pad2 '8' 'D' = 'C'; pad2 '8' 'L' = '7'; pad2 '8' 'R' = '9'
pad2 '9' 'L' = '8'
pad2 'A' 'U' = '6'; pad2 'A' 'R' = 'B'
pad2 'B' 'U' = '7'; pad2 'B' 'D' = 'D'; pad2 'B' 'L' = 'A'; pad2 'B' 'R' = 'C'
pad2 'C' 'U' = '8'; pad2 'C' 'L' = 'B'
pad2 'D' 'U' = 'B'
pad2 a   _ = a

getPass :: [String] -> Pad -> String
getPass input pad = tail $ scanl lineToNum '5' input
    where
        lineToNum = foldl pad

runDay02 :: String -> (String, String)
runDay02 input = (
        getPass (lines input) pad1,
        getPass (lines input) pad2
    )
