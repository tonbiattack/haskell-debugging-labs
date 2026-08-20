module Main (main) where

import RetryLimit (parseRetryLimit)
import Test.Hspec

main :: IO ()
main = hspec $ do
  describe "parseRetryLimit" $ do
    it "returns Nothing for non-numeric input instead of throwing" $ do
      parseRetryLimit "many" `shouldBe` Nothing

    it "parses a complete numeric input" $ do
      parseRetryLimit "3" `shouldBe` Just 3

    it "rejects numeric input with trailing characters" $ do
      parseRetryLimit "3times" `shouldBe` Nothing
