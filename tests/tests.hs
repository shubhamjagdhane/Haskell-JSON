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
testForLocal = checkValid localConfig $ goGetConfig "local" encodeLocal 

testForProd :: Bool 
testForProd = checkValid prodConfig $ goGetConfig "prod" encodeProd

checkValid :: ConfigVar -> Maybe ConfigVar -> Bool
checkValid config (Just x) =  x == config 
checkValid _ Nothing       = False

testInvalidLocal :: Bool
testInvalidLocal = checkInvalid $ goGetConfig "local" encodeProd

testInvalidProd :: Bool
testInvalidProd = checkInvalid $ goGetConfig "prod" encodeLocal
  
checkInvalid :: Maybe ConfigVar -> Bool
checkInvalid (Just _) =  False
checkInvalid Nothing  = True     