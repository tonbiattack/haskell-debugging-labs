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

-- | Render a status for a user.
--
-- This intentionally buggy implementation omits 'Failed'. It compiles with a
-- warning under -Wall but raises a runtime exception when that constructor is
-- evaluated by a caller.
deliveryMessage :: Delivery -> String
deliveryMessage Queued = "queued"
deliveryMessage (Sent trackingNumber) = "sent: " ++ trackingNumber
