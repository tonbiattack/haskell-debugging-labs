module Main (main) where

import Identifier (nextIdentifier)
import Test.Hspec

main :: IO ()
main = hspec $ do
  describe "nextIdentifier" $ do
    it "returns Nothing at maxBound instead of wrapping to a negative identifier" $ do
      nextIdentifier maxBound `shouldBe` Nothing

    it "increments a normal identifier" $ do
      nextIdentifier 41 `shouldBe` Just 42

    it "keeps zero non-negative when incremented" $ do
      nextIdentifier 0 `shouldBe` Just 1
