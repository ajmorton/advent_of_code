module Lib ( run ) where

import System.Environment ( getArgs )   
import System.IO ()  
import Text.Printf (printf)

import Day01 ( runDay01 )
import Day02 ( runDay02 )
import Day03 ( runDay03 )
import Day04 ( runDay04 )
import Day05 ( runDay05 )
import Day06 ( runDay06 )
import Day07 ( runDay07 )
import Day08 ( runDay08 )
import Day09 ( runDay09 )
import Day10 ( runDay10 )
      
run :: IO ()
run = do  
    day <- fmap (read . head) getArgs
    input <- readFile $ "input/day" ++ (printf "%02d" day) ++ ".txt"
    runDay day input

runDay :: Int -> String -> IO ()    
runDay 01 inp = print $ runDay01 inp
runDay 02 inp = print $ runDay02 inp
runDay 03 inp = print $ runDay03 inp
runDay 04 inp = print $ runDay04 inp
runDay 05 inp = print $ runDay05 inp
runDay 06 inp = print $ runDay06 inp
runDay 07 inp = print $ runDay07 inp
runDay 08 inp = print $ runDay08 inp
runDay 09 inp = print $ runDay09 inp
runDay 10 inp = print $ runDay10 inp
