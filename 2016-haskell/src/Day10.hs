module Day10 (runDay10) where

import Data.List (sort, find)
import Data.Maybe (fromJust)
import Data.Map (Map, fromListWith, toList, (!))

type Chip = Int

data Connection = Input {chip :: Chip, bot :: Destination} | Gives {srcBot :: Chip, lowOut :: Destination, highOut :: Destination} 
    deriving Show

data Destination = Bot {botId :: Int} | Output {outputId :: Int}                      
    deriving (Eq, Ord, Show)

runDay10 :: String -> (Int, Int)
runDay10 input = (part1, part2)
    where
        part2 = product $ concat $ map (linksMap !) [Output 0, Output 1, Output 2]

        part1 = (botId . fst) $ fromJust comparingBot
        comparingBot = find (hasChips [17, 61]) (toList linksMap)
        hasChips chips (bot, vals) = (sort vals) == (sort chips)

        linksMap = buildMap parsedInput
        parsedInput = map (parseConnection . words) (lines input)

parseTarget :: String -> String -> Destination
parseTarget "bot" id = Bot (read id)
parseTarget "output" id = Output (read id)

parseConnection :: [String] -> Connection
parseConnection ["bot", botId, "gives", "low", "to", lowType, lowId, "and", "high", "to", highType, highId] = Gives (read botId) (parseTarget lowType lowId) (parseTarget highType highId)
parseConnection ["value", valId, "goes", "to", "bot", botId] = Input (read valId) (Bot (read botId))

buildMap :: [Connection] -> Map Destination [Chip]
buildMap connections = connectionMap
  where
    connectionMap = fromListWith (++) (concatMap moveChips connections)

    moveChips (Input chip bot) = [(bot, [chip])]
    moveChips (Gives srcBot lowOut highOut) = [(lowOut, [lowChip]), (highOut, [highChip])]
      where 
        lowChip = foldr1 min (connectionMap ! Bot srcBot)        
        highChip = foldr1 max (connectionMap ! Bot srcBot)