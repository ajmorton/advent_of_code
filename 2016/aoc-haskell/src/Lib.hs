module Lib ( run ) where

import System.Environment ( getArgs )   
import System.IO ()  

import Day01 ( runDay01 )
import Day02 ( runDay02 )
import Day03 ( runDay03 )
      
run :: IO ()
run = do  
    day <- fmap (read . head) getArgs
    input <- readFile $ "data/" ++ show day ++ ".txt"
    runDay day input

runDay :: Int -> String -> IO ()    
runDay 1 inp = print $ runDay01 inp
runDay 2 inp = print $ runDay02 inp
runDay 3 inp = print $ runDay03 inp