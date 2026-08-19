module Average (mean) where

mean :: [Int] -> Maybe Double
mean [] = Nothing
mean values = Just (fromIntegral (sum values `div` length values))
