module Main where

import Env ( getConfig )
import Control.Monad (forever, when)
import System.Environment (getArgs)
import System.Exit (exitFailure, exitSuccess)
import System.IO (hGetLine, hIsEOF, stdin, hSetBuffering)

main :: IO() 
main = do       
  mode <- getArgs
  case mode of
    [arg] -> case arg of
              "local" ->  getConfig "local"
              "prod"  ->  getConfig "prod" 
              _ -> argError
    _ -> argError
    where argError = do
            putStrLn "Please specify the first argument \
                    \as being 'local' or 'prod'"
            exitFailure
