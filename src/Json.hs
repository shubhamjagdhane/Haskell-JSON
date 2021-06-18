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