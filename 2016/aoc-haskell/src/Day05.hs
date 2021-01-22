module Day05 (runDay05) where

import Data.Hash.MD5 ( md5s, Str(Str) )
import Data.List ( isPrefixOf )
import qualified Data.Map.Strict as Map

hashes :: [String]
hashes = filter ("00000" `isPrefixOf`) $ map (md5s . Str . ("ojvtpuvg" ++) . show) [0..]

password1 :: String
password1 = take 8 $ map (!! 5) hashes


findPassword :: Map.Map Char Char -> [String] -> Map.Map Char Char
findPassword map (hash: hs) =
    if   Map.size map == 8
    then map
    else findPassword (optInsert hash map) hs

optInsert :: String -> Map.Map Char Char -> Map.Map Char Char
optInsert hash map = 
    if   (hash !! 5 `elem` "01234567") && Map.notMember (hash !! 5) map 
    then Map.insert (hash !! 5) (hash !! 6) map 
    else map

password2 :: String
password2 = Map.elems $ findPassword Map.empty hashes

runDay05 :: String -> (String, String)
runDay05 input = (
        password1, 
        password2
    )
