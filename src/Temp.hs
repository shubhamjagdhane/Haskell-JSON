module Temp where
{-
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE QuasiQuotes #-}
module Temp where

import Data.Aeson (eitherDecodeFileStrict)
import Data.Aeson.Schema (schema, Object)
import Data.Aeson.Schema.Internal (showSchema)
import qualified Data.Text as T

type MySchema = [schema|
  {
    users: List {
      id: Int, 
      name: Text,
    },  
  }
|]

getResult :: IO (Object MySchema)
getResult = either fail return =<< eitherDecodeFileStrict "./src/example.json"
-}