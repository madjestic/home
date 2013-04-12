module Trees
( sumLeaves
) where

import Data.Tree hiding (Functor)


-- debug trees
tree0 = Node {rootLabel = "0", subForest = []}
tree1 = Node {rootLabel = "1", subForest = []}
tree2 = Node {rootLabel = "2", subForest = []}
tree21 = Node {rootLabel = "21", subForest = tree2:tree1:[]}
tree321 = Node {rootLabel = "321", subForest = tree2:tree1:tree21:[]}
tree231 = Node {rootLabel = "231", subForest = tree2:tree21:tree1:[]}
tree321321=Node{rootLabel="321321",subForest = tree321:tree321:[]}
tree231231=Node{rootLabel="231231",subForest = tree231:tree231:[]}

root = Node {rootLabel = "root", subForest = tree0:tree1:tree2:tree321:tree21:tree0:[]}
-- end of debug trees

-- | Neat 2-dimensional drawing of a tree.
drawTree' :: Tree String -> String
drawTree'  = unwords . draw

draw :: Tree String -> [String]
draw (Node x ts0) = x : drawSubTrees ts0
  where
    drawSubTrees [] = []
    drawSubTrees [t] =
        "|" : shift "`- " "   " (draw t)
    drawSubTrees (t:ts) =
        "|" : shift "+- " "|  " (draw t) ++ drawSubTrees ts

    shift first other = zipWith (++) (first : repeat other)


sumStrings :: [String] -> Int
sumStrings [] = 0
sumStrings xs = foldr1 (+) $ map read xs


leaf :: Eq a => Tree a -> Bool
leaf tree
		| subForest tree == [] = True
		| otherwise            = False


leaves :: Tree [Char] -> Tree Bool
leaves tree
		| leaf tree == True = Node {rootLabel = True,  subForest = []}
		| otherwise         = Node {rootLabel = False, subForest = subleaves (subForest tree)}
                                                             where subleaves [] = []
                                                                   subleaves (t:ts)
                                                                             | leaf t    = Node {rootLabel = True,  subForest = []} : subleaves ts
                                                                             | otherwise = Node {rootLabel = False, subForest = (subleaves $ subForest t)} : subleaves ts


-- check whether the above patter-matching based functions can be replaced with
-- a better Functor alternative:
-- A
--mapLabel ::  Eq a => (a -> b) -> Tree a -> Tree b
--mapLabel f (Node label []) = Node (f label) []
--mapLabel f (Node label subTrees) = (Node (f label) (subLeaves subTrees))
--                                            where subLeaves [] = []
--                                                  subLeaves (t:ts)
--                                                              | leaf t    =  Node (f label) [] : subLeaves ts
--                                                              | otherwise =  Node (f label) (subLeaves subTrees) : subLeaves ts
--                                                                               where label    = rootLabel t
--
--
-- B
-- instance Functor Tree where
--    fmap f (Node x ts) = Node (f x) (map (fmap f) ts)
-- mapLabel (++ "foo") tree21
-- fmap (++ "foo") tree21
--      -> produce identical result


--mapSubForest f (Node x [])       =  Node x []
--mapSubForest f (Node x subTrees) = (Node (f subTrees) (subLeaves subTrees))
--                                                 where subLeaves [] = []
--                                                       subLeaves (t:ts)
--						                | leaf t    = Node (f subTrees) [] : subLeaves ts
--								| otherwise = Node (f subTrees) (subLeaves subTrees) : subLeaves ts
--							                        where subTrees = subForest t
-- The above is replaced by:

fmapF :: (Forest t -> a) -> Tree t -> Tree a
fmapF f (Node x ts) = Node (f ts) (map (fmapF f) ts)

boolToInt :: Bool -> Integer
boolToInt = (\x -> if x == True then 1 else 0)


-- rootLabel becomes a list of subforest rootLabel values as [Int]
foobar :: Tree [Char] -> Tree [Int]
foobar = fmapF (map (read . rootLabel))

sumLeaves :: Tree [Char] -> Int
sumLeaves t = sumStrings $ flatten $ leavesValue t

leavesValue :: Tree [Char] -> Tree [Char]
leavesValue tree
		| leaf tree = tree
		| otherwise = Node {rootLabel = "0", subForest = leaves_from (subForest tree)}
		                                           where leaves_from [] = []
		                                                 leaves_from st@(t:ts)
	                                                                     | leaf t    = t : leaves_from ts	
	                                                                     | otherwise = Node {rootLabel = "0", subForest = leaves_from (subForest t)} : leaves_from ts



walkTree :: Tree String -> [String]
walkTree (Node x [])  = x : []
walkTree (Node x ts0) = x : drawSubTrees ts0
  where drawSubTrees [] = []
	drawSubTrees [t]    = (walkTree t)
	drawSubTrees (t:ts) = (walkTree t) ++ drawSubTrees ts


-- Radius and Weight are sinonyms
-- I need a function, which takes a tree and draws a set of circles.
-- 100) a draw function takes a triple (x, y, radius))
-- each tree contains leafs and branches
-- 		(~= each node contains 0 or more sub-nodes)
-- both branches and trees are represented as circles: a branch is a circle,
-- 		(~= each node is a circle)
-- surrounded by other circles - leaves and sub-branches
--		(~= each node is surrounded by 0 or more sub-nodes)
-- The tree is being walked through:
-- 5) Compute the number of sub-objects on a tree and their weights:
-- 10) 	Aquire a tree, containing weight (radius) values
--  		node weight is based on the number of sub-nodes per node
-- 13) 	Aquire a tree, containing the number of members per node #DONE
-- 15) 	(?) Modify the tree data type to accomodate for weights (radii) and number of members
--		   (number of members may be aquired from weights (radii))
-- 20)  Tree [radii] -> Tree [x,y]
-- 25)  map draw $ zipWith (Tree -> (x,y,radius)) Tree [x,y] Tree [radii]


-- Aquire a tree with the number of sub-nodes as a value of the rootLabel:
members :: Tree String -> Tree String
members (Node x [])  = Node {rootLabel = "0", subForest = []}
members (Node x ts0) = Node {rootLabel = (show $ length ts0), subForest = subNodes ts0}
    where subNodes []     = []
          subNodes [t]    = members t : []
          subNodes (t:ts) = (members t): subNodes ts
