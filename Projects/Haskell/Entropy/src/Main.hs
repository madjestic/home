{-# LANGUAGE CPP, TemplateHaskell #-}
-----------------------------------------------------------------------------
--
-- Module      :  Main
-- Copyright   :
-- License     :  AllRightsReserved
--
-- Maintainer  :  Vlad Lopatin
-- Stability   :  unstable
-- Portability :
--
-- this is supposed to draw circles, matching the number of list entries
--
-----------------------------------------------------------------------------

module Main (
    main
) where

import Graphics.Gloss
import Database.HDBC.Sqlite3 (connectSqlite3)
import Database.HDBC


draw_circles' :: IO()
draw_circles' = display (InWindow "My Window" (200, 200) (10, 10)) white circles

circles :: Picture
circles = Pictures $ [circle 80, Translate 10 10 $ circle 70]--map circle $ take 15 [10,22..] --[circle 80, circle 70]


-- Hello World
exeMain = do
    --putStrLn "foo Hello World"
    draw_circles'

#ifndef MAIN_FUNCTION
#define MAIN_FUNCTION exeMain
#endif
main = MAIN_FUNCTION

