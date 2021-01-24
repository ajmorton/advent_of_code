
import System.IO ()
import Day01 ( runDay01 )
import Day02 ( runDay02 )
import Day03 ( runDay03 )
import Day04 ( runDay04 )
import Day05 ( runDay05 )
import Day06 ( runDay06 )
import Day07 ( runDay07 )

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
    runTest "Day04: " Day04.runDay04 "data/4.txt" (361724,482)
    -- runTest "Day05: " Day05.runDay05 "data/5.txt" ("4543c154","1050cbbd")  skipped: runtime is 6 minutes
    runTest "Day06: " Day06.runDay06 "data/6.txt" ("nabgqlcw","ovtrjcjh")
    runTest "Day07: " Day07.runDay07 "data/7.txt" (115, 231)
