module Main (main) where

import Schedule (assignSlots)
import Test.Hspec

main :: IO ()
main = hspec $ do
  describe "assignSlots" $ do
    it "rejects a schedule when there are more people than time slots" $ do
      assignSlots ["Aki", "Bo"] ["09:00"] `shouldBe` Nothing

    it "assigns every person when the counts are equal" $ do
      assignSlots ["Aki", "Bo"] ["09:00", "10:00"]
        `shouldBe` Just [("Aki", "09:00"), ("Bo", "10:00")]

    it "accepts two empty inputs as a complete empty schedule" $ do
      assignSlots [] [] `shouldBe` Just []
