{-# LANGUAGE DeriveGeneric  #-}
{-# LANGUAGE DeriveAnyClass #-}
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
  toEncoding = genericToEncoding defaultOptions
instance FromJSON ConfigVar where
  
data Env1 = Env1 {
    local :: ConfigVar
  , prod :: ConfigVar
  } deriving (Generic, Show)  

instance ToJSON Env1 where
instance FromJSON Env1 where

newtype Env2 = Env2 {
    loc :: ConfigVar
  } deriving (Generic, Show)  

instance ToJSON Env2 where
  toJSON (Env2 loc) =
    object ["local" .= loc]

  toEncoding (Env2 loc) =
    pairs ("local" .= loc)    

instance FromJSON Env2 where
  parseJSON = withObject "Env2" $ \v -> Env2
    <$> v .: "local"  
 
newtype Env3 = Env3 {
    pro :: ConfigVar
  } deriving (Generic, Show)  

instance ToJSON Env3 where
  toJSON (Env3 pro) =
    object ["prod" .= pro]

  toEncoding (Env3 pro) =
    pairs ("prod" .= pro) 

instance FromJSON Env3 where
  parseJSON = withObject "Env3" $ \v -> Env3
    <$> v .: "prod"

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
  case decode xs :: Maybe Env1 of
    Just x  -> 
      case which of
        "local" -> local <$> Just x 
        "prod"  -> prod <$> Just x
    Nothing -> 
      case which of
        "local" -> 
          case decode xs :: Maybe Env2 of
            Just y  -> loc <$> Just y
            Nothing -> Nothing
        "prod" ->
          case decode xs :: Maybe Env3 of
            Just y  -> pro <$> Just y
            Nothing -> Nothing

     