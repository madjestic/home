-----------------------------------------------------------------------------
--
-- Module      :  Circles
-- Copyright   :
-- License     :  AllRightsReserved
--
-- Maintainer  :  madjestic13@gmail.com
-- Stability   :  unstable
-- Portability :
--
-- |
--
-----------------------------------------------------------------------------

module Circles
(draw_circles'
,rstorxys
) where

import Graphics.Gloss
--import Database.HDBC.Sqlite3 (connectSqlite3)
--import Database.HDBC
import Data.Angle
import Data.List

scale = 100

circles :: [(Float,Float)] -> [Float] -> [Picture]
circles = zipWith (\xy r -> translate' xy (Circle r))

translate' :: (Float, Float) -> (Picture -> Picture)
translate' (a,b) = Translate a b

draw_circles :: [(Float, Float)] -> [Float] -> IO()
draw_circles ys xs = display' $ Pictures (circles ys xs)

draw_circles' :: [(Float, Float, Float)] -> IO()
draw_circles' xs = draw_circles pos_list rad_list
  where pos_list = map abctobc xs
        rad_list = map abctoa  xs

abctoa :: (a,b,c) -> a
abctoa (a,_,_) = a

abctobc :: (a,b,c) -> (b,c)
abctobc (_,b,c) = (b,c)

display' :: Picture -> IO()
display' = display (InWindow "My Window" (200, 200) (10, 10)) white

arc_len :: [Float] -> Float
arc_len rs = foldl1 (+) rs

--[parent nodes radii] -> node_radius
node_radius :: [Float] -> Float
node_radius []          = 0
node_radius (x:[])      = x*2.0
node_radius xs@(x:y:[]) = (maximum xs)*2.0
node_radius xs = k*2*(arc_len xs)/pi
           where k = 1.1


--[parent nodes radii] -> [parent nodes angles]
p_nodes_angles :: [Float] -> [Float]
p_nodes_angles rs = scanl1 (+) $ map (step*) $ weighted_k_list rs
                   where step = 180/(fromIntegral $ 2 * length rs) -- zipWith const [1..] xs produces

k_list :: [Float] -> [Float]
k_list xs = 1: (take len (repeat 2))
               where len = length xs - 1

weighted_k_list :: [Float] -> [Float]
weighted_k_list rs = zipWith (\x y -> x*((1+y)/2)) (k_list rs) $ map (\x -> x/avg_len) rs -- r/(len): weighted_r_list rs
                      where avg_len = (arc_len rs)/(fromIntegral $ length rs)
-- list of weighted k(c)oefficients. Ks need to be scaled according to rs
-- r/sum(rs)


p_nodes_positions :: Float -> [Float] -> [(Float, Float)]
p_nodes_positions r angles = case angles of (x:[])     -> (0.0, -r):[]
                                            (x:y:[])   -> (pos,-pos):(-pos,-pos):[]
                                                  where pos = r * sqrt(2)/2
                                            (ang:angs) -> p_nodes_positions' r (ang:angs)

p_nodes_positions' :: Float -> [Float] -> [(Float, Float)]
p_nodes_positions' _ []         = []
p_nodes_positions' r (ang:angs)  =
                                  let -- r     = node_radius rs
                                    pos_x = (-1) * r * cosine (Degrees ang)
                                    pos_y = (-1) * r * sine (Degrees ang)
                                  in (pos_x, pos_y) : p_nodes_positions' r angs

a_bc_abc :: [Float] -> [(Float,Float)] -> [(Float, Float, Float)]
a_bc_abc [] _ = []
a_bc_abc _ [] = []
a_bc_abc (r:rs) (p:ps) = (r, fst p, snd p) : a_bc_abc rs ps
--angles_with_positions = zipWith (\x yz -> (x, fst yz, snd yz)) -- another way of  putting it

rstorxys :: [Float] -> [(Float, Float, Float)]
rstorxys [] = []
rstorxys rs = (r, 0.0, 0.0): a_bc_abc rs (p_nodes_positions r angles)
                                          where angles = (p_nodes_angles rs)
                                                r      = node_radius rs



-- we need to supply draw_function with a list of triples [(radius, posx, posy)]
-- more specifically: [(current_node_radius, current_node_posx, current_node_posy), (parent_node_radius, parent_node_posx, parent_node_posy)]
-- the minimal necessary argument is [parent_nodes_radii]

--current_node_with_parents :: [Float] -> [(Float, Float, Float)]
--current_node_with_parents rs = (node_radius rs, 0, 0): (angles_with_positions rs positions)
--                      where positions =
