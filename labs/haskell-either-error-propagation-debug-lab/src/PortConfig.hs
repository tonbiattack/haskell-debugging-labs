module PortConfig
  ( loadPort
  ) where

import Text.Read (readMaybe)

-- | Load a TCP port from text.
--
-- Parsing and range validation are both part of the public error contract.
-- A malformed value is preserved as 'Left' rather than silently selecting a
-- different, successful configuration.
loadPort :: String -> Either String Int
loadPort raw =
  case readMaybe raw of
    Nothing -> Left "port must be an integer"
    Just port -> validatePort port

validatePort :: Int -> Either String Int
validatePort port
  | port < 1 || port > 65535 = Left "port must be between 1 and 65535"
  | otherwise = Right port
