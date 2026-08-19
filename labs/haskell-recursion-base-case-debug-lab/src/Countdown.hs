module Countdown (countDown) where

countDown :: Int -> Maybe [Int]
countDown n | n < 0 = Nothing
countDown 0 = Just [0]
countDown n = (n :) <$> countDown (n - 1)
