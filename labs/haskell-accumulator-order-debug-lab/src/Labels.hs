module Labels (collectLabels) where

collectLabels :: [String] -> [String]
collectLabels labels = reverse (go [] labels)
  where
    go accumulated [] = accumulated
    go accumulated (label : remaining) = go (label : accumulated) remaining
