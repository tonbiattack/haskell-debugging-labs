module RoleSearch (containsAdmin) where

import Data.List (foldl)

containsAdmin :: [String] -> Bool
containsAdmin = foldl step False
  where
    step found role = found || role == "admin"
