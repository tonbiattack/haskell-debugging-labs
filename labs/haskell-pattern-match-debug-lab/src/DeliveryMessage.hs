module DeliveryMessage
  ( Delivery (..)
  , deliveryMessage
  ) where

-- | A delivery can be queued, sent, or fail with a diagnostic.
data Delivery
  = Queued
  | Sent String
  | Failed String
  deriving (Eq, Show)

-- | Render every delivery status for a user.
deliveryMessage :: Delivery -> String
deliveryMessage Queued = "queued"
deliveryMessage (Sent trackingNumber) = "sent: " ++ trackingNumber
deliveryMessage (Failed reason) = "failed: " ++ reason
