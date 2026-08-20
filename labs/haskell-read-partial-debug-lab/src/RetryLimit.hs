module RetryLimit (parseRetryLimit) where

parseRetryLimit :: String -> Maybe Int
parseRetryLimit raw = Just (read raw)
