module Lib ( run ) where

import System.Environment ( getArgs )   
import System.IO ()  

import Day01 ( runDay01 )
      
run :: IO ()
run = do  
    day <- fmap (read . head) getArgs
    input <- readFile $ "data/" ++ show day ++ ".txt"
    runDay day input

runDay :: Int -> String -> IO ()    
runDay 1 inp = print $ runDay01 inp