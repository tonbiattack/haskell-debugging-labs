module Schedule (assignSlots) where

assignSlots :: [String] -> [String] -> Maybe [(String, String)]
assignSlots people slots = Just (zip people slots)
