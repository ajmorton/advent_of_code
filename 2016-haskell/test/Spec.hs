
import System.IO ()
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

runTest :: Eq a => String -> (String -> a) -> FilePath -> a -> IO ()
runTest day fn file expected = do
    input <- readFile file
    putStr day
    putStrLn $ if fn input == expected then "OK" else "FAIL!"

main :: IO ()
main = do
    runTest "Day01: " Day01.runDay01 "input/day01.txt" (241, 116)
    runTest "Day02: " Day02.runDay02 "input/day02.txt" ("98575","CD8D4")
    runTest "Day03: " Day03.runDay03 "input/day03.txt" (993, 1849)
    runTest "Day04: " Day04.runDay04 "input/day04.txt" (361724,482)
    -- runTest "Day05: " Day05.runDay05 "input/day05.txt" ("4543c154","1050cbbd")  skipped: runtime is 6 minutes
    runTest "Day06: " Day06.runDay06 "input/day06.txt" ("nabgqlcw","ovtrjcjh")
    runTest "Day07: " Day07.runDay07 "input/day07.txt" (115, 231)
    -- 123, AFBUPZBJPS
    runTest "Day08: " Day08.runDay08 "input/day08.txt" (123, [" ##  #### ###  #  # ###  #### ###    ## ###   ### ", "#  # #    #  # #  # #  #    # #  #    # #  # #    ", "#  # ###  ###  #  # #  #   #  ###     # #  # #    ", "#### #    #  # #  # ###   #   #  #    # ###   ##  ", "#  # #    #  # #  # #    #    #  # #  # #       # ", "#  # #    ###   ##  #    #### ###   ##  #    ###  "])
    runTest "Day09: " Day09.runDay09 "input/day09.txt" (152851,11797310782)
    runTest "Day10: " Day10.runDay10 "input/day10.txt" (93,47101)
