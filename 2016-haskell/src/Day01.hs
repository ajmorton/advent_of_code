module Day01 (runDay01) where

import Data.List.Split
import qualified Data.Set as Set

data Direction = North | South | East | West deriving (Show)
data Position  = Position Int Int deriving (Show, Ord, Eq)
data State     = State Direction Position deriving (Show)

type Distance    = Int
data Turn        = Left | Right | Forward deriving (Show)
data Instruction = Instruction Turn Distance deriving (Show)

parseInstruction :: String -> Instruction
parseInstruction ('L': dist) = Instruction Day01.Left  (read dist)
parseInstruction ('R': dist) = Instruction Day01.Right (read dist)

parsePath :: String -> [Instruction]
parsePath input = map parseInstruction $ splitOn ", " input


-- Instruction Left 3 -> [Instruction Left 1, Instruction Left 1, Instruction Left 1]
expandInstr :: Instruction -> [Instruction]
expandInstr (Instruction turn 1) = [Instruction turn 1]
expandInstr (Instruction turn n) = Instruction turn 1 : expandInstr (Instruction Forward (n-1)) 

expandPath :: [Instruction] -> [Instruction]
expandPath = concatMap expandInstr


changeDir :: Direction -> Turn -> Direction
changeDir dir  Day01.Forward = dir
changeDir North Day01.Left   = West
changeDir North Day01.Right  = East
changeDir South Day01.Left   = East
changeDir South Day01.Right  = West
changeDir East  Day01.Left   = North
changeDir East  Day01.Right  = South
changeDir West  Day01.Left   = South
changeDir West  Day01.Right  = North

move :: Position -> Direction -> Distance -> Position
move (Position x y) North dist = Position x (y + dist)
move (Position x y) South dist = Position x (y - dist)
move (Position x y) East  dist = Position (x + dist) y
move (Position x y) West  dist = Position (x - dist) y

walk :: State -> Instruction -> State
walk (State dir curPos) (Instruction turn dist) = State newDir newPos
    where
        newDir = changeDir dir turn
        newPos = move curPos newDir dist
        newHist = Set.insert curPos



manhattan :: Position -> Int
manhattan (Position x y) = abs x + abs y

path :: String -> [State]
path input = scanl walk startState path
    where
        startState = State North (Position 0 0)
        path = expandPath $ parsePath input

firstReturn :: Set.Set Position -> [Position] -> Position
firstReturn history (curPos: remPos)
    | Set.member curPos history = curPos
    | otherwise                 = firstReturn (Set.insert curPos history) remPos  

getPos :: State -> Position
getPos (State _ pos) = pos

runDay01 :: String -> (Int, Int)
runDay01 input = (
        manhattan . getPos $ last $ path input,
        manhattan $ firstReturn Set.empty $ map getPos $ path input
    )
