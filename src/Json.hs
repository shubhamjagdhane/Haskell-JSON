{-# LANGUAGE DeriveGeneric  #-}
{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE OverloadedStrings #-}

module Json where
import Data.Aeson
  ( pairs,
    (.:),
    withObject,
    eitherDecodeFileStrict,
    object,
    FromJSON(parseJSON),
    KeyValue((.=)),
    ToJSON(toJSON, toEncoding), fromJSON )
import GHC.Generics

data Person = Person {
      name     :: String
    , personid :: Int
    , address  :: String 
    } deriving (Generic, Show)

instance ToJSON Person where
    -- this generates a Value
    toJSON (Person name personid address) =
        object ["name" .= name, "personid" .= personid, "address" .= address]

    -- this encodes directly to a bytestring Builder
    toEncoding (Person name personid address) =
        pairs ("name" .= name <> "personid" .= personid <> "address" .= address) 

instance FromJSON Person where
  parseJSON = withObject "Person" $ \v -> Person
      <$> v .: "name"
      <*> v .: "personid"
      <*> v .: "address"

loadFile :: IO [Person]
loadFile = either fail return =<< eitherDecodeFileStrict "./src/example.json"

{-
data ConfigVar = ConfigVar {
    dbName   :: String
  , port     :: Int
  , host     :: String
  , username :: String
  , password :: String
  } deriving (Generic, Show)

instance ToJSON ConfigVar where
  -- this generates a Value
  toJSON (ConfigVar dbName port host username password) =
    object ["dbName" .= dbName, "port" .= port, "host" .= host, "username" .= username, "password" .= password]

  -- this encodes directly to a bytestring Builder
  toEncoding (ConfigVar dbName port host username password) =
    pairs ("dbName" .= dbName <> "port" .= port <> "host" .= host <> "username" .= username <> "password" .= password) 
instance FromJSON ConfigVar where
  parseJSON = withObject "ConfigVar" $ \v -> ConfigVar
    <$> v .: "dbName"
    <*> v .: "port"
    <*> v .: "host"
    <*> v .: "username"
    <*> v .: "password"
data Env = Env {
    local :: ConfigVar
  , prod :: ConfigVar
  } deriving (Generic, Show)  


instance ToJSON Env where
  -- this generates a Value
  toJSON (Env local prod) =
    object ["local" .= local, "prod" .= prod]

  -- this encodes directly to a bytestring Builder
  toEncoding (Env local prod) =
    pairs ("local" .= local <> "prod" .= prod) 

instance FromJSON Env where
  parseJSON = withObject "Env" $ \v -> Env
    <$> v .: "local"
    <*> v .: "prod"


loadEnv :: IO Env1
loadEnv = either fail return =<< eitherDecodeFileStrict "./src/env.json"
   
-}