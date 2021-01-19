
import System.IO ()
import Day01 ( runDay01 )
import Day02 ( runDay02 )

main :: IO ()
main = do
    day01Input <- readFile "data/1.txt"
    putStr "Day01: "
    putStrLn $ if Day01.runDay01 day01Input == (241, 116) then "OK" else "FAIL!"

    day02Input <- readFile "data/2.txt"
    putStr "Day02: "
    putStrLn $ if Day02.runDay02 day02Input == ("98575","CD8D4") then "OK" else "FAIL!"
