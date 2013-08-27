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


import Circles
import Query
import Trees

--treeToTl30riples :: [Tree [a]] -> [(b,b,b)]
--treeToTriples :: Tree [a] -> [(b,b,b)]
--treeToTriple tree
--              | leaf tree == True =



exeMain = do
    --draw_circles' $ rstorxys [50,70,60,10,80,30]
    draw_circles' [(50,70,60)]



#ifndef MAIN_FUNCTION
#define MAIN_FUNCTION exeMain
#endif
main = MAIN_FUNCTION

