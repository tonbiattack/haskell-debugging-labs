module Main (main) where

import Average (mean)
import Test.Hspec

main :: IO ()
main = hspec $ do
  describe "mean" $ do
    it "keeps the fractional part of a non-integral average" $ do
      mean [1, 2] `shouldBe` Just 1.5

    it "returns an integral average when the sum divides evenly" $ do
      mean [2, 4] `shouldBe` Just 3.0

    it "returns Nothing for an empty collection" $ do
      mean [] `shouldBe` Nothing
