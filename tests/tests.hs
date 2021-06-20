module Main where

import Test.QuickCheck
import Env
main :: IO ()
main = do
  runQc

-- Implement Gen for String and Int
-- Make ByteString which can have 'local' or 'prod' or both key
-- the bytestring object must contain variables in the ConfigVar


genInt :: Gen Int 
genInt = elements [0..9]

genChar :: Gen Char 
genChar = elements ['a'..'z'] -- 568


prop_additionGreater :: Int -> Bool
prop_additionGreater x = x + 1 > x

runQc :: IO ()
runQc = quickCheck prop_additionGreater


{-

prop_LocalEnv :: String -> Bool 
prop_LocalEnv x = 
  encode (Env1 {local = ConfigVar {dbName=x, port=3306, host="127.0.0.1",username=x, password=x}, prod = ConfigVar {dbName=x, port=3306, host="127.0.0.1",username=x, password=x}})

encode (Person {name = "Joe", age = 12})
{local = ConfigVar {dbName="local", port=3306, host="127.0.0.1",username="test", password="password"}, prod = ConfigVar {dbName="production", port=3306, host="127.0.0.1",username="username", password="super-secret-password"}}


encode (Env1 {local = ConfigVar {dbName="local", port=3306, host="127.0.0.1",username="test", password="password"}, prod = ConfigVar {dbName="production", port=3306, host="127.0.0.1",username="username", password="super-secret-password"}})


encode (Env2 {loc = ConfigVar {dbName="local", port=3306, host="127.0.0.1",username="test", password="password"}})

encode (Env3 {pro = ConfigVar {dbName="local", port=3306, host="127.0.0.1",username="test", password="password"}})
-}