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
  } deriving (Generic, Show, Eq)

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
    Just x  -> putStrLn . show $ x
    Nothing -> putStrLn $"Please make sure that .json file has '" ++ which ++ "' configuration"

goGetConfig ::  String -> B.ByteString -> Maybe ConfigVar
goGetConfig "local" xs = local <$> (decode xs :: Maybe Local)
goGetConfig "prod"  xs = prod  <$> (decode xs :: Maybe Prod)
goGetConfig _  xs      = Nothing