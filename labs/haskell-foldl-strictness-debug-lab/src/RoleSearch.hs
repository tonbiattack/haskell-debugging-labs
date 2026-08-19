module RoleSearch (containsAdmin) where

containsAdmin :: [String] -> Bool
containsAdmin = foldr step False
  where
    step role found = role == "admin" || found
