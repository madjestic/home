module Main where

import System.IO

main = do
--	file <- getLine
	readFile (file<-getLine) >>= print.length.lines

