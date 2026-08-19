module Average (mean) where

mean :: [Int] -> Maybe Double
mean [] = Nothing
mean values =
  Just (fromIntegral (sum values) / fromIntegral (length values))
