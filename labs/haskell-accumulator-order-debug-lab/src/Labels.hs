module Labels (collectLabels) where

collectLabels :: [String] -> [String]
collectLabels = go []
  where
    go accumulated [] = accumulated
    go accumulated (label : remaining) = go (label : accumulated) remaining
