{-# LANGUAGE DeriveGeneric  #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import Env
import Data.Aeson
import qualified Data.ByteString.Lazy as B
import Test.QuickCheck

main :: IO ()
main = do
  runLocal
  runProd

runLocal :: IO ()
runLocal = do
  quickCheck testForLocal
  quickCheck testInvalidLocal

runProd :: IO ()
runProd = do
  quickCheck testForProd
  quickCheck testInvalidProd

prop_additionGreater :: Int -> Bool
prop_additionGreater x = x + 1 > x

runQc :: IO ()
runQc = quickCheck prop_additionGreater

genInt :: Gen Int 
genInt = elements [3000..32000]

genChar :: Gen Char 
genChar = elements ['a'..'z']

localConfig :: ConfigVar
localConfig = ConfigVar "local" 3306 "127.0.0.1" "test" "password"

localValue :: Local
localValue = Local localConfig

prodConfig :: ConfigVar
prodConfig = ConfigVar "production" 3306 "127.0.0.1" "username" "super-secret-password"

prodValue :: Prod
prodValue = Prod prodConfig

encodeLocal :: B.ByteString
encodeLocal = encode localValue

encodeProd :: B.ByteString
encodeProd = encode prodValue

testForLocal :: Bool 
testForLocal = 
  case goGetConfig "local" encodeLocal of
    Just x  -> localConfig == x
    Nothing -> False

testForProd :: Bool 
testForProd = 
  case goGetConfig "prod" encodeProd of
    Just x  -> prodConfig == x
    Nothing -> False    

testInvalidLocal :: Bool
testInvalidLocal =
  case goGetConfig "local" encodeProd of
    Just _  -> False
    Nothing -> True   

testInvalidProd :: Bool
testInvalidProd =
  case goGetConfig "prod" encodeLocal of
    Just _  -> False
    Nothing -> True    