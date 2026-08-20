module Main (main) where

import Labels (collectLabels)
import Test.Hspec

main :: IO ()
main = hspec $ do
  describe "collectLabels" $ do
    it "preserves the caller's input order" $ do
      collectLabels ["first", "second", "third"]
        `shouldBe` ["first", "second", "third"]

    it "returns an empty list for empty input" $ do
      collectLabels [] `shouldBe` []

    it "keeps a singleton unchanged" $ do
      collectLabels ["only"] `shouldBe` ["only"]
