module Day03 (runDay03) where

import Data.List ( transpose )

type Triangle = (Int, Int, Int)

collectTriangles :: [Int] -> [Triangle]
collectTriangles (x:y:z:ls) = (x,y,z) : collectTriangles ls
collectTriangles _          = []

numValid :: [Triangle] -> Int
numValid triangles = length $ filter isValid triangles
    where
        isValid (x,y,z) = x + y > z && x + z > y && y + z > x

p1Triangles :: String -> [Triangle]
p1Triangles input = collectTriangles $ concat $ intList input

part2Triangles :: String -> [Triangle]
part2Triangles input = collectTriangles $ concat $ transpose $ intList input

intList :: String -> [[Int]]
intList input = map (map read . words) $ lines input

runDay03 :: String -> (Int, Int)
runDay03 input = (
        numValid $ p1Triangles input,
        numValid $ part2Triangles input
    )
