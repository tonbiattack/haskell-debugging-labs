module Main (main) where

import Control.Exception (evaluate)
import GreetingFile (readGreeting)
import Test.Hspec

fixturePath :: FilePath
fixturePath = "artifacts/greeting.txt"

expectedGreeting :: String
expectedGreeting = "hello from a file\n"

main :: IO ()
main = hspec $ do
  describe "readGreeting" $ do
    it "returns contents that remain usable after withFile closes its handle" $ do
      contents <- readGreeting fixturePath
      evaluate (length contents) `shouldReturn` length expectedGreeting
