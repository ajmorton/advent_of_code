
import System.IO ()
import Day01 ( runDay01 )
import Day02 ( runDay02 )
import Day03 ( runDay03 )

runTest :: Eq a => String -> (String -> a) -> FilePath -> a -> IO ()
runTest day fn file expected = do
    input <- readFile file
    putStr day
    putStrLn $ if fn input == expected then "OK" else "FAIL!"

main :: IO ()
main = do
    runTest "Day01: " Day01.runDay01 "data/1.txt" (241, 116)
    runTest "Day02: " Day02.runDay02 "data/2.txt" ("98575","CD8D4")
    runTest "Day03: " Day03.runDay03 "data/3.txt" (993, 1849)
