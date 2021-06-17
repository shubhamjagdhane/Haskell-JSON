module Main where
import Test.QuickCheck

main :: IO ()
main = do
  runQc

prop_additionGreater :: Int -> Bool
prop_additionGreater x = x + 1 > x

runQc :: IO ()
runQc = quickCheck prop_additionGreater