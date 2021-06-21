{-# LANGUAGE DeriveGeneric  #-}
{-# LANGUAGE OverloadedStrings #-}

module Env where

import qualified Data.ByteString.Lazy as B
import Data.Aeson
import GHC.Generics

data ConfigVar = ConfigVar {
    dbName   :: String
  , port     :: Int
  , host     :: String
  , username :: String
  , password :: String
  } deriving (Generic, Show)

instance ToJSON ConfigVar where
instance FromJSON ConfigVar where

newtype Local = Local {
    local :: ConfigVar
  } deriving (Generic, Show)  

instance ToJSON Local where
instance FromJSON Local where

newtype Prod = Prod {
    prod :: ConfigVar
  } deriving (Generic, Show)  

instance ToJSON Prod where
instance FromJSON Prod where

loadFile :: IO B.ByteString
loadFile = do B.readFile "./src/env.json"

getConfig :: String -> IO ()
getConfig which = do
  result <- loadFile
  case goGetConfig which result of
    Just x ->  putStrLn . show $ x
    Nothing -> putStrLn $"Please make sure that .json file has '" ++ which ++ "' configuration"

goGetConfig ::  String -> B.ByteString -> Maybe ConfigVar
goGetConfig which xs = 
  case which of
    "local" -> 
      case decode xs :: Maybe Local of
        Just y  -> local <$> Just y
        Nothing -> Nothing
    "prod" ->
      case decode xs :: Maybe Prod of
        Just y  -> prod <$> Just y
        Nothing -> Nothing

     