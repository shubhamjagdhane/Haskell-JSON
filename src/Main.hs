module Main where

import Env ( ConfigVar, getLocal, getProd )
import Control.Monad (forever, when)
import System.Environment (getArgs)
import System.Exit (exitFailure, exitSuccess)
import System.IO (hGetLine, hIsEOF, stdin, hSetBuffering)

main :: IO() 
main = do
  mode <- getArgs
  case mode of
    [arg] -> case arg of
              "local" ->  getLocal
              "prod"  ->  getProd 
              _ -> argError
    _ -> argError
    where argError = do
            putStrLn "Please specify the first argument \
                    \as being 'local' or 'prod'"
            exitFailure
