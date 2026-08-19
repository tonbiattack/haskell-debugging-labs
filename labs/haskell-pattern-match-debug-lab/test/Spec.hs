module Main (main) where

import DeliveryMessage (Delivery (..), deliveryMessage)
import Test.Hspec

main :: IO ()
main = hspec $ do
  describe "deliveryMessage" $ do
    it "renders a failed delivery instead of raising a pattern-match exception" $ do
      deliveryMessage (Failed "upstream timeout") `shouldBe` "failed: upstream timeout"

    it "renders a queued delivery" $ do
      deliveryMessage Queued `shouldBe` "queued"

    it "renders a sent delivery with its tracking number" $ do
      deliveryMessage (Sent "JP-42") `shouldBe` "sent: JP-42"
