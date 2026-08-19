module FirstName
  ( firstName
  ) where

-- | Return the first name when present.
--
-- This intentionally buggy implementation claims to represent absence with
-- 'Nothing', but evaluates the partial function 'head' before it can construct
-- a result for an empty list.
firstName :: [String] -> Maybe String
firstName names = Just (head names)
