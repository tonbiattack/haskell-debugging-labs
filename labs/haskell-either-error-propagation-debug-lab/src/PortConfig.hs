module PortConfig
  ( loadPort
  ) where

import Text.Read (readMaybe)

-- | Load a TCP port from text.
--
-- This intentionally buggy implementation treats a parse failure as the
-- default port. Its result type promises a diagnostic in 'Left', but malformed
-- input is silently accepted as a successful configuration.
loadPort :: String -> Either String Int
loadPort raw =
  case readMaybe raw of
    Nothing -> Right 8080
    Just port -> validatePort port

validatePort :: Int -> Either String Int
validatePort port
  | port < 1 || port > 65535 = Left "port must be between 1 and 65535"
  | otherwise = Right port
