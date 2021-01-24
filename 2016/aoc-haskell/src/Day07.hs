module Day07 (runDay07) where

import Data.List
import Data.List.Split

everySecond :: [a] -> [a]
everySecond (x:y:ys) = x : everySecond ys
everySecond [x]      = [x]
everySecond _        = []

hyperAndSupernets :: String -> ([String], [String])
hyperAndSupernets str = (hyper, super)
    where
        splitIP =  splitWhen (`elem` "[]") str
        super   = everySecond splitIP
        hyper   = everySecond . tail $ splitIP

isTLS :: ([String], [String]) -> Bool 
isTLS (hypernet, supernet) = not (any hasAbba hypernet) && any hasAbba supernet

hasAbba :: String -> Bool 
hasAbba (a:b:c:d:tail)
    | a == d && b == c && a /= b = True
    | otherwise = hasAbba (b:c:d:tail)
hasAbba _ = False

bab :: String -> String
bab [a,b,c] = [b,a,b]

isSSL :: ([String], [String]) -> Bool 
isSSL (hypernet, supernet) = (not . null $ supernet_abas) && hypernet_bab
    where 
        supernet_abas = concatMap getAbas supernet
        hypernet_bab = or [ bab a `isInfixOf` b | a <- supernet_abas, b <- hypernet ]

getAbas :: String -> [String]
getAbas str = filter isAba $ map (take 3) $ tails str
    where
        isAba str = length str == 3 && head str == (str !! 2) && (head str /= str !! 1)

runDay07 :: String -> (Int, Int)
runDay07 input = (
    length $ filter isTLS $ map hyperAndSupernets $ lines input,
    length $ filter isSSL $ map hyperAndSupernets $ lines input
    )

