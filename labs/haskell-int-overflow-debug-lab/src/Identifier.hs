module Identifier (nextIdentifier) where

nextIdentifier :: Int -> Maybe Int
nextIdentifier current
  | current == maxBound = Nothing
  | otherwise = Just (current + 1)
