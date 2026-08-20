module Identifier (nextIdentifier) where

nextIdentifier :: Int -> Maybe Int
nextIdentifier current = Just (current + 1)
