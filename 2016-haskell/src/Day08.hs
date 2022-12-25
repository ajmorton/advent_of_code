module Day08 (runDay08) where

import Data.List
import Data.List.Split

type Screen = [[Char]]
data Command = Rect Int Int | RotCol Int Int | RotRow Int Int
    deriving Show

emptyScreen :: Screen
emptyScreen = [ [ ' ' | c <- [1..50] ] | r <- [1..6] ]

setBits :: Int -> Int -> Screen -> Screen
setBits r c screen = map (setFirst c) (take r screen) ++ drop r screen
    where
        setFirst c line = replicate c '#' ++ drop c line

rotRow :: Int -> Int -> Screen -> Screen
rotRow r rot screen = take (r-1) screen ++ [rotLine (screen !! (r-1))] ++ drop r screen
    where
        rotLine line = drop (length line - rot) line ++ take (length line - rot) line

rotCol :: Int -> Int -> Screen -> Screen
rotCol c rot screen = transpose $ rotRow c rot $ transpose screen

transform :: Command -> Screen -> Screen
transform (Rect r c)     = setBits r c
transform (RotCol c rot) = rotCol c rot
transform (RotRow c rot) = rotRow c rot

transformScreen :: [Command] -> Screen
transformScreen = foldl (flip transform) emptyScreen

parseCommands :: String -> [Command]
parseCommands input = map commandFrom $ lines input

commandFrom :: String -> Command
commandFrom line
    | "rect" `isPrefixOf` line = Rect (parseRect !! 1) (head parseRect)
    | "rotate row" `isPrefixOf` line = RotRow parseIndex parseRot
    | "rotate column" `isPrefixOf` line = RotCol parseIndex parseRot
    where
        parseRect = map read $ splitOn "x" $ words line !! 1
        parseIndex = (read . drop 2 $ words line !! 2) + 1
        parseRot = read $ words line !! 4

runDay08 :: String -> (Int, Screen)
runDay08 input = (
    length $ filter (== '#') $ concat $ transformScreen $ parseCommands input,
    transformScreen $ parseCommands input
    )

