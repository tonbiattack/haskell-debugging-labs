module FirstName
  ( firstName
  ) where

-- | Return the first name when present.
--
-- The result type makes absence explicit: an empty input has no first element
-- and returns 'Nothing'; a non-empty input returns its first element in 'Just'.
firstName :: [String] -> Maybe String
firstName [] = Nothing
firstName (name : _) = Just name
