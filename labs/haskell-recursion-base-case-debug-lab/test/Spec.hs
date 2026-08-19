module Main (main) where

import Control.Exception (evaluate)
import Countdown (countDown)
import System.Timeout (timeout)
import Test.Hspec

main :: IO ()
main = hspec $ do
  describe "countDown" $ do
    it "returns Nothing for a negative starting value instead of recursing forever" $ do
      result <- timeout 1000000 (evaluate (countDown (-1)))
      result `shouldBe` Just Nothing

    it "returns the terminal value for zero" $ do
      countDown 0 `shouldBe` Just [0]

    it "includes every value down to zero for a positive start" $ do
      countDown 3 `shouldBe` Just [3, 2, 1, 0]
