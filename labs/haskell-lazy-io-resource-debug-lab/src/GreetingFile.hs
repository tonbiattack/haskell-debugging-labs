module GreetingFile (readGreeting) where

import System.IO (IOMode (ReadMode), hGetContents', withFile)

readGreeting :: FilePath -> IO String
readGreeting path = withFile path ReadMode hGetContents'
