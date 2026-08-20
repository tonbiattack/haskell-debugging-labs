module RetryLimit (parseRetryLimit) where

import Text.Read (readMaybe)

parseRetryLimit :: String -> Maybe Int
parseRetryLimit = readMaybe
