module Main (main) where

import Data.Either (isLeft)
import PortConfig (loadPort)
import Test.Hspec
import Test.Hspec.QuickCheck (prop)
import Test.QuickCheck (elements, forAll, listOf1)

main :: IO ()
main = hspec $ do
  describe "loadPort" $ do
    it "rejects non-numeric input instead of selecting a default port" $ do
      loadPort "http" `shouldBe` Left "port must be an integer"

    it "rejects a numeric port outside the valid range" $ do
      loadPort "70000" `shouldBe` Left "port must be between 1 and 65535"

    it "returns a valid numeric port" $ do
      loadPort "8080" `shouldBe` Right 8080

    prop "rejects every non-empty lowercase alphabetic input" $
      forAll (listOf1 (chooseLetter)) $ \raw -> isLeft (loadPort raw)
  where
    chooseLetter = elements ['a' .. 'z']
