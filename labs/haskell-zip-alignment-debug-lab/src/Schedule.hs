module Schedule (assignSlots) where

assignSlots :: [String] -> [String] -> Maybe [(String, String)]
assignSlots [] [] = Just []
assignSlots (person : people) (slot : slots) =
  ((person, slot) :) <$> assignSlots people slots
assignSlots _ _ = Nothing
