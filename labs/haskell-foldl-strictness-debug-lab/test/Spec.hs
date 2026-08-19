module Main (main) where

import Control.Exception (evaluate)
import RoleSearch (containsAdmin)
import System.Timeout (timeout)
import Test.Hspec

main :: IO ()
main = hspec $ do
  describe "containsAdmin" $ do
    it "returns True when admin is the first element of an infinite role stream" $ do
      result <- timeout 1000000 (evaluate (containsAdmin ("admin" : repeat "viewer")))
      result `shouldBe` Just True

    it "returns False for a finite stream with no admin role" $ do
      containsAdmin ["viewer", "editor"] `shouldBe` False
