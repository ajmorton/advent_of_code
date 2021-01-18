
import System.IO ()
import Day01 ( runDay01 )

main :: IO ()
main = do
    day01Input <- readFile "data/1.txt"
    putStr "Day01: "
    putStrLn $ if Day01.runDay01 day01Input == (241, 116) then "OK" else "FAIL!"
