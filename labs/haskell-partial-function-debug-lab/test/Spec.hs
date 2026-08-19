module Main (main) where

import FirstName (firstName)
import Test.Hspec
import Test.Hspec.QuickCheck (prop)

main :: IO ()
main = hspec $ do
  describe "firstName" $ do
    it "returns Nothing for an empty list instead of raising an exception" $ do
      firstName [] `shouldBe` Nothing

    it "returns the first element for a non-empty list" $ do
      firstName ["Ada", "Grace"] `shouldBe` Just "Ada"

    prop "returns the first element for every non-empty list" $ \name rest ->
      firstName (name : rest) == Just name
